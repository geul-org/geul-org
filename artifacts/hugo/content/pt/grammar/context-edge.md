---
title: "Context Edge"
weight: 60
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "context", "worldview", "modal-logic"]
summary: "Edge leve de 3 palavras que expressa 'em que cosmovisão/contexto esta afirmação é verdadeira'. Codifica as condições de verdade com 64 tipos incluindo fonte, cosmovisão, ficção e perspetiva."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Context Edge expressa **"em que cosmovisão/contexto este Claim é verdadeiro"**.

É um conceito que corresponde aos mundos possíveis da Modal Logic: para o mesmo Subject, podem existir factos diferentes conforme a cosmovisão.

```
Context "Realidade":           (Terra, idade, 4600 milhões de anos)
Context "Terra jovem":         (Terra, idade, 6000 anos)
Context "Harry Potter":        (magia, exists, true)
```

## Estrutura do pacote (3 palavras, 48 bits)

```
1st WORD (16 bits):
┌─────────────────────┬─────────────────┐
│       Prefix        │  Context Type   │
│       10 bits       │     6 bits      │
└─────────────────────┴─────────────────┘
 [1100 000 100]        [TTTTTT]

2nd WORD: Context TID (16 bits)
3rd WORD: Target TID (16 bits)
```

| Campo | Bits | Descrição |
|-------|------|-----------|
| Prefix | 10 | `1100 000 100` |
| Context Type | 6 | 0=não especificado, 1~62=tipo, 63=extensão (reservado) |
| Context TID | 16 | Identificador único deste Context |
| Target TID | 16 | Claim alvo ([Triple](../triple-edge/)/[Verb](../verb-edge/)/[Event6](../event6-edge/)/[Clause](../clause-edge/) TID) |

## Context Type (6 bits = 64)

### Fonte (Source) -- Code 1~20

| Code | Tipo | Descrição | Exemplo |
|------|------|-----------|---------|
| 1 | SYSTEM | Gerado automaticamente pelo sistema | Sincronização Wikidata |
| 2 | USER | Entrada direta do utilizador | Criação manual |
| 3 | DOCUMENT | Documento geral | PDF, Word |
| 4 | NEWS | Artigo de notícias | Reuters, AP |
| 5 | ACADEMIC | Artigo académico | arXiv, Nature |
| 6 | GOVERNMENT | Governo/organismo público | SEC, INE |
| 7 | WIKI | Wikipedia/Wikidata | Q42, P31 |
| 8 | API | API externa | Finanças, clima |
| 9 | ORG | Comunicado de organização | IR empresarial |
| 10 | BOOK | Livro | Baseado em ISBN |
| 11 | INTERVIEW | Entrevista/testemunho | Citação direta |
| 12 | DATASET | Conjunto de dados | Kaggle |
| 13 | SOCIAL | Redes sociais | Twitter |
| 14 | LEGAL | Leis/jurisprudência | Sentença judicial |
| 15 | ARCHIVE | Arquivo | archive.org |
| 16 | MULTIMEDIA | Vídeo/áudio | YouTube |
| 17 | DATABASE | Base de dados | IMDB, Freebase |
| 18 | ENCYCLOPEDIA | Enciclopédia | Britannica |
| 19 | MANUAL | Manual/guia | Documentação técnica |
| 20 | STANDARD | Documento padrão | ISO, RFC |

### Derivado/inferência (Derived) -- Code 21~30

| Code | Tipo | Descrição | Exemplo |
|------|------|-----------|---------|
| 21 | MODEL | Gerado por modelo IA | GPT, Claude |
| 22 | INFERENCE | Inferência lógica | Baseada em regras |
| 23 | AGGREGATION | Agregação/integração | Síntese de múltiplas fontes |
| 24 | CALCULATION | Resultado de cálculo | Aplicação de fórmula |
| 25 | TRANSLATION | Tradução | Original → tradução |
| 26 | EXTRACTION | Extração | NER, RE |
| 27 | CORRECTION | Correção | Correção de erros |
| 28 | HEARSAY | Boato | Não confirmado |
| 29 | ESTIMATION | Estimativa | Valor aproximado |
| 30 | PREDICTION | Previsão | Perspetiva futura |

### Cosmovisão/crença (Worldview) -- Code 31~45

| Code | Tipo | Descrição | Exemplo |
|------|------|-----------|---------|
| 31 | RELIGION | Cosmovisão religiosa | Protestantismo, budismo |
| 32 | PHILOSOPHY | Perspetiva filosófica | Existencialismo |
| 33 | SCIENCE | Consenso científico | Física moderna |
| 34 | POLITICS | Perspetiva política | Conservador, progressista |
| 35 | CULTURE | Perspetiva cultural | Oriental, ocidental |
| 36 | MYTHOLOGY | Sistema mitológico | Mitologia grega |
| 37 | FOLKLORE | Folclore/tradição oral | Lendas locais |
| 38 | IDEOLOGY | Sistema ideológico | Capitalismo |
| 39 | THEORY | Teoria | Relatividade |
| 40 | HYPOTHESIS | Hipótese | Pré-verificação |
| 41 | TRADITION | Tradição/costume | Tradição confuciana |
| 42 | CONSENSUS | Consenso/doutrina aceite | Doutrina académica |
| 43 | MAINSTREAM | Opinião maioritária | Opinião da maioria |
| 44 | ALTERNATIVE | Opinião alternativa | Opinião minoritária |
| 45 | FRINGE | Marginal/heterodoxo | Pseudociência |

### Ficção/criação (Fiction) -- Code 46~55

| Code | Tipo | Descrição | Exemplo |
|------|------|-----------|---------|
| 46 | NOVEL | Mundo de romance | O Senhor dos Anéis |
| 47 | FILM | Mundo de filme | MCU |
| 48 | GAME | Mundo de videojogo | Zelda |
| 49 | COMICS | Mundo de banda desenhada | Universo DC |
| 50 | ANIMATION | Mundo de animação | Ghibli |
| 51 | DRAMA | Mundo de série/drama | Game of Thrones |
| 52 | THEATER | Mundo teatral | Hamlet |
| 53 | FANFIC | Criação de fãs | Fanfiction |
| 54 | LEGEND | Lenda | Rei Artur |
| 55 | FAIRYTALE | Conto de fadas | Cinderela |

### Perspetiva/narrador (Perspective) -- Code 56~62

| Code | Tipo | Descrição | Exemplo |
|------|------|-----------|---------|
| 56 | NARRATOR | Perspetiva do narrador | Narrador omnisciente |
| 57 | PROTAGONIST | Perspetiva do protagonista | Ponto de vista do herói |
| 58 | ANTAGONIST | Perspetiva do antagonista | Ponto de vista do vilão |
| 59 | AUTHOR | Intenção do autor | Comentário do escritor |
| 60 | EXPERT | Opinião de especialista | Opinião de académico |
| 61 | LAYMAN | Perceção do público geral | Perceção popular |
| 62 | SATIRICAL | Sátira/ironia | Expressão irónica |

Code 0 é UNSPECIFIED (não especificado), Code 63 é EXTENDED (extensão, reservado).

## Extensão de metadados

A informação adicional sobre o Context (fonte, fiabilidade, nome do mundo) expressa-se via [Triple Edge](../triple-edge/).

```
(Context TID, P:source_entity, Reuters_Entity)  - Organização fonte
(Context TID, P:confidence, 0.95)               - Fiabilidade
(Context TID, P:universe_name, "Harry Potter")   - Nome do mundo
(Context TID, P:perspective_holder, Vilão_Entity) - Sujeito da perspetiva
```

## Exemplos

### Fonte: "Segundo a Reuters"

```
Context Edge:
  1st: [1100 000 100] + [000100]  - NEWS (4)
  2nd: [0x0300]                   - Context TID
  3rd: [0x0001]                   - Target: Triple "Apple adquiriu Tesla"

Triples adicionais:
  (0x0300, P:source_entity, Reuters)
  (0x0300, P:date, 2026-01-29)
```

### Ficção: "Mundo de Harry Potter"

```
Context Edge:
  1st: [1100 000 100] + [101110]  - NOVEL (46)
  2nd: [0x0302]                   - Context TID
  3rd: [0x0003]                   - Target: Triple "Hogwarts é_uma escola"

Triples adicionais:
  (0x0302, P:universe_name, "Harry Potter")
  (0x0302, P:author, J.K. Rowling)
```

### Inferência IA: "Claude infere"

```
Context Edge:
  1st: [1100 000 100] + [010101]  - MODEL (21)
  2nd: [0x0304]                   - Context TID
  3rd: [0x0005]                   - Target: Triple "X causa Y"

Triples adicionais:
  (0x0304, P:model, Claude_Entity)
  (0x0304, P:confidence, 0.75)
```

## Fundamento do design

- **Context Edge como tipo independente**: A cosmovisão é uma camada meta diferente de Triple/Clause. Corresponde ao G (Graph) do RDF Quad.
- **6 bits de Context Type**: Permite classificação imediata sem Triples separados. 62 tipos cobrem a maioria dos casos.
- **Estrutura leve de 3 palavras**: As conexões de Context são geradas em massa, pelo que se assegura a eficiência de armazenamento com o tamanho mínimo.
