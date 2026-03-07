---
title: "Clause Edge"
weight: 40
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "clause", "RST", "discourse"]
summary: "Edge fixo de 4 palavras que expressa relações lógicas e discursivas entre predicados, eventos e relações. Codifica relações de causalidade, temporalidade, contraste e argumentação com 16 tipos baseados em RST."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Clause Edge é um tipo de Edge que expressa **relações lógicas/discursivas** entre predicados ([Verb Edge](../verb-edge/)), eventos ([Event6 Edge](../event6-edge/)), relações ([Triple Edge](../triple-edge/)) ou outros Clauses.

Concebido com base nas relações discursivas da RST (Rhetorical Structure Theory).

## Estrutura do pacote (4 palavras, 64 bits)

```
1st WORD (16 bits):
┌─────────────────────┬────────────┬────────┐
│      Prefix         │ Tipo rel.  │ Reserv.│
│       10 bits       │   4 bits   │ 2 bits │
└─────────────────────┴────────────┴────────┘
 [1100 000 010]        [RRRR]       [xx]

2nd WORD: Edge TID (16 bits)
3rd WORD: TID 1 (16 bits) - primeira cláusula
4th WORD: TID 2 (16 bits) - segunda cláusula
```

| Campo | Bits | Descrição |
|-------|------|-----------|
| Prefix | 10 | `1100 000 010` |
| Tipo de relação | 4 | 16 relações RST |
| Reservado | 2 | Para extensão futura |
| Edge TID | 16 | Identificador único deste Edge |
| TID 1 | 16 | Referência à primeira cláusula |
| TID 2 | 16 | Referência à segunda cláusula |

## Tipos de relação (4 bits = 16)

### Relações causais

| Código | Tipo | Descrição | Exemplo |
|--------|------|-----------|---------|
| 0000 | CAUSE | Causa→resultado | "Choveu, por isso fiquei em casa" |
| 0001 | RESULT | Resultado←causa | "Fiquei em casa, porque choveu" |
| 0010 | CONDITION | Condição→consequência | "Se chover, não vou" |
| 0011 | PURPOSE | Propósito | "Come para viver" |

### Relações temporais/sequenciais

| Código | Tipo | Descrição | Exemplo |
|--------|------|-----------|---------|
| 0100 | SEQUENCE | Ordem cronológica | "Comeu e depois dormiu" |
| 0101 | PARALLEL | Simultâneo/paralelo | "Falou sorrindo" |

### Relações de contraste/concessão

| Código | Tipo | Descrição | Exemplo |
|--------|------|-----------|---------|
| 0110 | CONTRAST | Contraste | "A é grande e B é pequeno" |
| 0111 | CONCESSION | Concessão | "Embora fosse difícil, fez" |

### Relações de elaboração/fundo

| Código | Tipo | Descrição | Exemplo |
|--------|------|-----------|---------|
| 1000 | ELABORATION | Detalhe | "Concretamente falando" |
| 1001 | BACKGROUND | Informação de fundo | "Para referência, naquela altura" |

### Relações argumentativas

| Código | Tipo | Descrição | Exemplo |
|--------|------|-----------|---------|
| 1010 | EVIDENCE | Apresentação de evidência | "Porque... por isso" |
| 1011 | EVALUATION | Avaliação | "Isto é bom/mau" |

### Outras relações

| Código | Tipo | Descrição | Exemplo |
|--------|------|-----------|---------|
| 1100 | SOLUTIONHOOD | Problema→solução | "O problema é X, a solução é Y" |
| 1101 | ALTERNATIVE | Escolha/alternativa | "Ir ou não ir" |
| 1110 | MEANS | Meio | "Conseguiu fazendo assim" |
| 1111 | RESERVED | Reservado | Para extensão futura |

## Regras de ordem de TID

A direção é determinada pela ordem dos TIDs.

| Relação | TID 1 | TID 2 |
|---------|-------|-------|
| CAUSE | Causa | Resultado |
| RESULT | Resultado | Causa |
| CONDITION | Condição | Consequência |
| PURPOSE | Ação | Propósito |
| SEQUENCE | Anterior | Posterior |
| EVIDENCE | Evidência | Afirmação |
| ELABORATION | Núcleo | Detalhe |

## Multinuclear vs Nucleus-Satellite

Segue a distinção da RST.

### Nucleus-Satellite (assimétrico)

| Relação | TID 1 | TID 2 |
|---------|-------|-------|
| CAUSE | Causa (Satellite) | Resultado (Nucleus) |
| CONDITION | Condição (Satellite) | Consequência (Nucleus) |
| EVIDENCE | Evidência (Satellite) | Afirmação (Nucleus) |
| ELABORATION | Núcleo (Nucleus) | Detalhe (Satellite) |

### Multinuclear (simétrico)

| Relação | TID 1 | TID 2 |
|---------|-------|-------|
| SEQUENCE | Anterior | Posterior |
| PARALLEL | Primeiro | Segundo |
| CONTRAST | Primeiro | Segundo |
| ALTERNATIVE | Primeiro | Segundo |

Nas relações simétricas, a ordem dos TIDs não indica prioridade semântica.

## Exemplos

### Causalidade simples: "Choveu, por isso fiquei em casa"

```
Verb Edge E01: rain(chuva) | TID=0x0001
Verb Edge E02: stay(eu, casa) | TID=0x0002

Clause Edge:
  1st: [1100 000 010] [0000] [00]  - Prefix + CAUSE + Reservado
  2nd: [0x0100]                    - Edge TID
  3rd: [0x0001]                    - TID 1 (causa: E01)
  4th: [0x0002]                    - TID 2 (resultado: E02)
```

### Clause aninhado: "Choveu, por isso fiquei em casa, e por isso estudei"

```
Verb Edge E01: rain(chuva) | TID=0x0001
Verb Edge E02: stay(eu, casa) | TID=0x0002
Verb Edge E03: study(eu) | TID=0x0003

Clause Edge C01:
  1st: [1100 000 010] [0000] [00]  - Prefix + CAUSE
  2nd: [0x0100]                    - Edge TID
  3rd: [0x0001]                    - E01
  4th: [0x0002]                    - E02

Clause Edge C02:
  1st: [1100 000 010] [0001] [00]  - Prefix + RESULT
  2nd: [0x0101]                    - Edge TID
  3rd: [0x0100]                    - C01 (referência TID de Clause)
  4th: [0x0003]                    - E03
```

## Fundamento do design

### Por que basear-se em RST

- Mais de 30 anos de investigação acumulada
- Verificado com diversos corpora
- Existem ferramentas de parsing discursivo
- Independente do idioma

### Por que 4 bits (16 tipos)

- Cobre 12 ou mais relações nucleares da RST
- Margem para extensão
- 3 bits (8 tipos) é insuficiente

### Por que simplificar para 4 palavras

- Direção: determina-se pela ordem dos TIDs (não precisa de bits adicionais)
- Confiança: trata-se como metadados separados
- 2 bits reservados: para extensão futura
