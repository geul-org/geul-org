---
title: "Event6 Edge"
weight: 50
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "event6", "5W1H"]
summary: "Edge de evento de comprimento variável que expressa as 6 perguntas fundamentais (Who, What, Whom, When, Where, Why) de uma só vez. Realiza uma estrutura variável de 3 a 8 palavras por máscara de bits Presence."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Event6 Edge é um tipo de Edge de evento que expressa as **6 perguntas fundamentais** (Who, What, Whom, When, Where, Why) de uma só vez.

## Elementos das 6 perguntas

| Elemento | Inglês | Bit | Significado | Referência TID |
|----------|--------|-----|-------------|----------------|
| Quem | Agent | 0 | Agente | [Entity Node](../entity-node/) |
| O quê | Action | 1 | Ação | [Verb Edge](../verb-edge/) |
| A quem | Patient | 2 | Paciente | [Entity Node](../entity-node/) |
| Quando | Time | 3 | Tempo | Quantity/Entity |
| Onde | Location | 4 | Local | [Entity Node](../entity-node/) |
| Porquê | Reason | 5 | Razão/propósito | [Clause Edge](../clause-edge/)/Entity |

## Estrutura do pacote

```
1st WORD (16 bits)
┌────────────────────┬────────────────────┐
│      Prefix        │     Presence       │
│      10bit         │       6bit         │
└────────────────────┴────────────────────┘

2nd WORD (16 bits)
┌────────────────────────────────────────────┐
│                Edge TID                    │
└────────────────────────────────────────────┘

3rd+ WORD: TIDs dos elementos (na ordem do Presence)
```

### Máscara de bits Presence (6 bits)

| Bit | Elemento | Se presente |
|-----|----------|-------------|
| 0 | Who | Inclui-se o TID correspondente |
| 1 | What | Inclui-se o TID correspondente |
| 2 | Whom | Inclui-se o TID correspondente |
| 3 | When | Inclui-se o TID correspondente |
| 4 | Where | Inclui-se o TID correspondente |
| 5 | Why | Inclui-se o TID correspondente |

Total de palavras = 2 (cabeçalho + Edge TID) + popcount(Presence). O intervalo é de 3~8 palavras (48~128 bits).

## Estrutura por modo

### Modo mínimo (3 palavras)

```
Exemplo: "Choveu" (só What)

1st: [Prefix] + [000010]      - Só What presente
2nd: [Edge TID]
3rd: [What TID]               - "rain" Verb Edge
```

### Modo nuclear (5 palavras)

Who + What + Whom. A composição mais frequente.

```
Exemplo: "João bateu na Maria"

1st: [Prefix] + [000111]      - Who, What, Whom
2nd: [Edge TID]
3rd: [Who TID]                - João
4th: [What TID]               - "hit" Verb Edge
5th: [Whom TID]               - Maria
```

### Modo padrão (6 palavras)

```
Exemplo: "João encontrou-se com a Maria ontem"

1st: [Prefix] + [001111]      - Who, What, Whom, When
2nd: [Edge TID]
3rd: [Who TID]                - João
4th: [What TID]               - "meet" Verb Edge
5th: [Whom TID]               - Maria
6th: [When TID]               - Ontem
```

### Modo completo (8 palavras)

```
Exemplo: "João, por amor, deu um presente para Maria ontem na escola"

1st: [Prefix] + [111111]      - Todos
2nd: [Edge TID]
3rd: [Who TID]                - João
4th: [What TID]               - "give" Verb Edge
5th: [Whom TID]               - Maria
6th: [When TID]               - Ontem
7th: [Where TID]              - Escola
8th: [Why TID]                - Amor (razão)
```

## Detalhe dos elementos

### What (ação)

What referencia o TID de um [Verb Edge](../verb-edge/). O Verb Edge correspondente contém a informação de qualificadores como tempo e aspecto.

### Why (razão)

Razões simples são expressas com um TID de Entity ("amor"), e razões complexas com um TID de [Clause Edge](../clause-edge/) ("porque choveu").

## Comparação Event6 vs Verb Edge

| | Verb Edge | Event6 Edge |
|--|-----------|-------------|
| **Foco** | Predicado/ação | Evento completo |
| **Participantes** | Estrutura de Participant | TIDs das 6 perguntas |
| **Espaço-tempo** | Expressão separada | When/Where integrados |
| **Razão** | Clause separado | Why integrado |
| **Palavras** | 2~5 | 3~8 |
| **Uso** | Expressão predicativa | Armazenamento de eventos |

**Guia de seleção:** Verb Edge para análise de predicados/frases, Event6 Edge para armazenamento de eventos/registos, [Triple Edge](../triple-edge/) para factos simples.

## Exemplos

### "A Apple adquiriu a Tesla"

```
Who:  Apple (Q312)     → Entity TID 0x0001
What: acquire          → Verb Edge TID 0x0100
Whom: Tesla (Q478214)  → Entity TID 0x0002

Event6 Edge:
  1st: [1100 000 011] + [000111]  - Prefix + Who,What,Whom
  2nd: [TID: 0x0200]              - Edge TID
  3rd: [TID: 0x0001]              - Apple (Who)
  4th: [TID: 0x0100]              - acquire (What)
  5th: [TID: 0x0002]              - Tesla (Whom)

Total: 5 palavras
```

### "Yi Sun-sin morreu na batalha de Noryang em 1598"

```
Who:   Yi Sun-sin        → Entity TID 0x0010
What:  die (morrer)       → Verb Edge TID 0x0101
When:  1598              → Entity TID 0x0011
Where: Batalha de Noryang → Entity TID 0x0012

Event6 Edge:
  1st: [1100 000 011] + [011011]  - Who,What,When,Where
  2nd: [TID: 0x0202]
  3rd: [TID: 0x0010]              - Yi Sun-sin
  4th: [TID: 0x0101]              - die
  5th: [TID: 0x0011]              - 1598
  6th: [TID: 0x0012]              - Batalha de Noryang

Total: 6 palavras
```

## Análise (parsing)

```python
def parse_event6(data: bytes) -> dict:
    word1 = int.from_bytes(data[0:2], 'big')

    prefix = word1 >> 6
    assert prefix == 0b1100000011, "Not Event6 Edge"

    presence = word1 & 0x3F
    edge_tid = int.from_bytes(data[2:4], 'big')

    elements = {}
    element_names = ['who', 'what', 'whom', 'when', 'where', 'why']
    offset = 4

    for i, name in enumerate(element_names):
        if presence & (1 << i):
            tid = int.from_bytes(data[offset:offset+2], 'big')
            elements[name] = tid
            offset += 2

    return {
        'presence': presence,
        'edge_tid': edge_tid,
        'elements': elements,
        'words': 2 + bin(presence).count('1')
    }
```
