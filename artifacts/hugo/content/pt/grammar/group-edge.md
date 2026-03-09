---
title: "Group Edge"
weight: 90
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "group", "set", "logic"]
summary: "Edge de comprimento variável que agrupa múltiplos Nodes em 7 tipos: AND, OR, LIST, SET, etc. Suporta membros ilimitados por Prefix de 13 bits e marcador de terminação (0x0000)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Group Edge é um tipo de Edge que **agrupa múltiplos Nodes num único grupo** para expressão.

## Estrutura do pacote

```
1st WORD (16 bits)
┌───────────────────────┬───────────┐
│        Prefix         │ GroupType │
│        13 bits        │   3 bits  │
└───────────────────────┴───────────┘
  [1100 000 111 000]       [TTT]

2nd WORD: Edge TID (16 bits)
3rd+ WORD: TIDs dos membros (variável)
Última WORD: Marcador de terminação (0x0000)
```

| Campo | Bits | Descrição |
|-------|------|-----------|
| Prefix | 13 | `1100 000 111 000` |
| GroupType | 3 | Tipo de grupo (8 tipos) |
| Edge TID | 16 | Identificador único deste Edge |
| TIDs dos membros | 16×N | Referências aos membros do grupo |
| Marcador de terminação | 16 | `0x0000` |

Mínimo 4 palavras (1 membro), geral 5~6 palavras (2~3 membros), máximo sem limite.

## GroupType (3 bits = 8)

| Código | Tipo | Significado | Membros |
|--------|------|-------------|---------|
| 000 | **AND** | Conjunção lógica | 2+ |
| 001 | **OR** | Disjunção lógica | 2+ |
| 010 | **XOR** | Seleção exclusiva | 2+ |
| 011 | **LIST** | Lista ordenada | 1+ |
| 100 | **SET** | Conjunto sem ordem | 1+ |
| 101 | **RANGE** | Intervalo (início~fim) | Exatamente 2 |
| 110 | **PAIR** | Par ordenado | Exatamente 2 |
| 111 | Extensão | Extensão futura | - |

## Detalhe do GroupType

### AND

Todos os membros participam simultaneamente. Exemplo: "João **e** Maria **e** Pedro reuniram-se"

### OR

Um ou mais dos membros aplicam (ou inclusivo). Exemplo: "Peça café **ou** chá"

### XOR

Exatamente um dos membros aplica (ou exclusivo). Exemplo: "Aprovado ou reprovado (um dos dois)"

### LIST

Lista onde a ordem é significativa. Usa-se para rankings e sequências. Exemplo: "1.º João, 2.º Maria, 3.º Pedro"

### SET

Conjunto onde a ordem não importa. Só importa a pertença. Exemplo: "Participantes: João, Maria, Pedro"

### RANGE

Intervalo contínuo que inclui valores intermédios. Exatamente 2 membros (início, fim). Exemplo: "de 1 a 10"

### PAIR

Par ordenado simples. Exatamente 2 membros. Usa-se para coordenadas, key-value, etc. Exemplo: "coordenada (3, 5)"

### RANGE vs PAIR

| Tipo | Significado | Valores intermédios |
|------|-------------|---------------------|
| RANGE | Intervalo contínuo | Incluídos |
| PAIR | Par simples | Não há |

`RANGE [1, 5]` → 1, 2, 3, 4, 5 (existem valores intermédios). `PAIR [1, 5]` → (1, 5) (só dois valores).

## Exemplos

### "João e Maria encontraram-se"

```
1. Entity Node: João (TID=0x0001)
2. Entity Node: Maria (TID=0x0002)
3. Group Edge: AND (TID=0x0100)
   1st: [1100 000 111 000] [000] = Prefix + AND
   2nd: [0x0100]                 = Edge TID
   3rd: [0x0001]                 = João
   4th: [0x0002]                 = Maria
   5th: [0x0000]                 = Terminação

4. Verb Edge: meet
   Subject: 0x0100 (referência de grupo)

Total: 5 palavras
```

### "Coordenada (3, 5)"

```
1. Quantity Node: 3 (TID=0x0001)
2. Quantity Node: 5 (TID=0x0002)
3. Group Edge: PAIR (TID=0x0100)
   1st: [1100 000 111 000] [110] = Prefix + PAIR
   2nd: [0x0100]
   3rd: [0x0001]                 = Primeiro (x)
   4th: [0x0002]                 = Segundo (y)
   5th: [0x0000]

Total: 5 palavras
```

## Restrições

| GroupType | Mínimo | Máximo |
|-----------|--------|--------|
| AND / OR / XOR | 2 | sem limite |
| LIST / SET | 1 | sem limite |
| RANGE / PAIR | 2 | 2 |

- Os TIDs dos membros devem referenciar Nodes/Edges já declarados
- Não se permite autorreferência (ciclos)
- TID=0x0000 está reservado como marcador de terminação
