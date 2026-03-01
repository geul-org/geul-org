---
title: "Verb Edge"
weight: 10
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "verb", "huffman", "WordNet"]
summary: "Classifica 13.767 verbos do WordNet em 10 Primitives → 68 Sub-primitives e gera um livro de códigos de 16 bits por codificação Huffman. Alcança compressão média de 2,16 palavras com 3 tipos de pacotes: Tiny (2), Short (3) e Full (5)."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Verb Edge é o tipo de Edge que expressa predicados/ações no fluxo GEUL. Classifica 13.767 verbos do WordNet em 10 Primitives → 68 Sub-primitives e gera um livro de códigos de 16 bits por **codificação Huffman ao nível de Sub-primitive**.

## Documentos secundários

| Documento | Descrição |
|-----------|-----------|
| [Papéis de participantes](./semantic-role/) | 16 Semantic Roles (codificação de 4 bits) |
| [Qualificadores semânticos](./qualifier/) | 14 qualificadores: evidencialidade, modo, tempo, aspecto, etc. |

## Hierarquia verbal

```
10 Primitive (categorias semânticas superiores)
 ├── BE          ├── PERCEIVE    ├── FEEL
 ├── THINK       ├── CHANGE      ├── CAUSE
 ├── MOVE        ├── COMMUNICATE ├── TRANSFER
 └── SOCIAL
  → 68 Sub-primitive (classificação intermediária)
    → 559 Root Verb (verbos raiz)
      → 13,767 Leaf Verb (todos os verbos do WordNet)
```

- Os Primitives (categorias principais) tratam apenas do **agrupamento conceptual** sem alocação de bits
- São atribuídos **códigos de comprimento variável baseados em frequência** aos 68 Sub-primitives
- Grupos de verbos mais frequentes recebem códigos mais curtos (4 a 8 bits)

## Tipos de pacotes de Verb Edge

Os 3 tipos de pacotes Tiny/Short/Full partilham os mesmos **16 bits de corpo verbal** na última palavra.

| | Tiny | Short | Full |
|--|------|-------|------|
| Palavras | 2 (32bit) | 3 (48bit) | 5 (80bit) |
| Participantes | 16 padrões | 512 padrões | 19bit flags |
| Qualificadores | 7 padrões | 3.640 padrões | 27bit |
| Corpo verbal | 16bit | 16bit | 16bit |
| Proporção esperada | 90% | 7% | 3% |

**Tamanho médio do pacote:** 0,9x2 + 0,07x3 + 0,03x5 = **2,16 palavras**

### Tiny Verb Edge (2 palavras)

```
1st WORD:  [Prefix 5bit] [Target×padrão 11bit]
2nd WORD:  [Corpo verbal 16bit]
```

- Target×padrão: 18 Target × 113 padrões = 2.034 combinações
- Participantes 16 padrões × qualificadores 7 padrões = 112 + 1 reservado = 113
- Cobertura ~90%

### Short Verb Edge (3 palavras)

```
1st WORD:  [Prefix 6bit] [Type 1bit=0] [Padrão participantes 9bit]
2nd WORD:  [Target×Padrão qualificadores 16bit]
3rd WORD:  [Corpo verbal 16bit]
```

### Full Verb Edge (5 palavras)

```
1st WORD:  [Prefix 6bit] [Type 1bit=1] [Target participantes 5bit] [Flags participantes 4bit]
2nd+3rd:   [Flags participantes 15bit] [Qualificadores 17bit]
4th WORD:  [Qualificadores 10bit] [Reservado 6bit]
5th WORD:  [Corpo verbal 16bit]
```

## Corpo verbal de 16 bits

```
┌─────────────────────────┬────────────────────────────┐
│   sub_primitive code    │     Índice DFS na árvore   │
│   (4-8 bits, Huffman)   │     (8-12 bits)            │
└─────────────────────────┴────────────────────────────┘
```

- **sub_primitive code:** 4~8 bits variável (código Huffman)
- **DFS index:** identificação de verbos individuais dentro do sub_primitive

### Distribuição de comprimento de códigos

| Comprimento | Quantidade | Verbos totais | Proporção |
|-------------|-----------|---------------|-----------|
| 4 bits | 4 | 6.388 | 46,4% |
| 5 bits | 4 | 2.479 | 18,0% |
| 6 bits | 8 | 2.321 | 16,9% |
| 7 bits | 16 | 1.786 | 13,0% |
| 8 bits | 36 | 813 | 5,9% |

### Cálculo de bits do DFS index

| Verbos do sub_primitive | Bits necessários |
|------------------------|------------------|
| 1~256 | 8 bits |
| 257~512 | 9 bits |
| 513~1024 | 10 bits |
| 1025~2048 | 11 bits |
| 2049~4096 | 12 bits |

Exemplo: CHANGE-TRANSFORM = `0000`(4 bits) + 3.063 verbos (12 bits) = 16 bits.

### Comprimento médio de código

```
Média = Σ(comprimento de código × número de verbos) / total de verbos ≈ 5,14 bits
```

| Método | Bits médios |
|--------|-------------|
| Fixo 7 bits (68) | 7,00 |
| Codificação Huffman | 5,14 |
| **Economia** | **1,86 bits (27%)** |

## Primitives - categorias principais (10)

| Primitive | Significado | Sub-primitives | Verbos |
|-----------|-------------|----------------|--------|
| BE | Estado/existência | 8 | 899 |
| PERCEIVE | Percepção/cognição | 4 | 218 |
| FEEL | Emoção | 6 | 204 |
| THINK | Pensamento | 6 | 769 |
| CHANGE | Mudança | 8 | 3.358 |
| CAUSE | Causação/ação | 14 | 3.739 |
| MOVE | Movimento | 6 | 2.182 |
| COMMUNICATE | Comunicação | 6 | 586 |
| TRANSFER | Transferência | 4 | 530 |
| SOCIAL | Ação social | 6 | 387 |

## Sub-primitives de maior frequência (código de 4 bits)

| Sub-primitive | Código | Verbos | Proporção | Exemplo |
|---------------|--------|--------|-----------|---------|
| CHANGE-TRANSFORM | `0000` | 3.063 | 22,2% | "mudar", "tornar-se" |
| CAUSE-USE | `0001` | 1.358 | 9,9% | "usar", "utilizar" |
| MOVE-DISPLACE | `0010` | 1.025 | 7,4% | "deslocar" |
| MOVE-GO | `0011` | 942 | 6,8% | "ir" |

Os 4 Sub-primitives superiores representam 46,4% do total.

## Filosofia de design

### Razão para escolher codificação Huffman

- CHANGE-TRANSFORM (22,2%) tem frequência extremamente alta
- **Economia de 27% em bits médios** em relação à alocação fixa
- Os 4 sub_primitives superiores representam 46,4% do total

### Razão para eliminar os bits de Primitive

- Anterior: Primitive 3 bits + Sub_primitive 4 bits = 7 bits fixos
- Novo: Codificação direta do Sub_primitive = 4~8 bits variável
- **Economia de até 4 bits** em verbos de alta frequência

### Manutenção do agrupamento semântico

A classificação por Primitives é mantida para a legibilidade humana e como dicas de agrupamento semântico durante o treino de LLMs.
