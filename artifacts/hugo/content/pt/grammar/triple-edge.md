---
title: "Triple Edge"
weight: 30
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "triple", "property"]
summary: "Tipo de Edge que expressa relações e propriedades no formato (Subject, Property, Object). Estrutura dual com modo básico de 4 palavras e modo estendido de 5 palavras que otimiza as Top 63 propriedades de alta frequência."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Triple Edge é um tipo de Edge que expressa **relações/propriedades** no formato `(Subject, Property, Object)`.

## Design de modo dual

- **Modo básico (4 palavras):** PropCode 0~62 (Top 63 propriedades)
- **Modo estendido (5 palavras):** Se PropCode=63, cobre todo o P-ID (16 bits de alinhamento semântico)

## Modo básico (4 palavras = 64 bits)

```
1st WORD (16 bits)
┌────────────────────┬────────────────────┐
│      Prefix        │     PropCode       │
│      10bit         │       6bit         │
└────────────────────┴────────────────────┘

2nd WORD: Edge TID (16 bits)
3rd WORD: Subject TID (16 bits)
4th WORD: Object TID (16 bits)
```

| Campo | Bits | Descrição |
|-------|------|-----------|
| Prefix | 10 | `1100 000 001` |
| PropCode | 6 | 0~62: Top 63 propriedades, 63: modo estendido |
| Edge TID | 16 | TID deste Edge |
| Subject TID | 16 | TID de Entity/Node sujeito |
| Object TID | 16 | TID de Entity/Node/Quantity objeto |

## Modo estendido (5 palavras = 80 bits)

Se PropCode for 63, adiciona-se um P-ID de 16 bits na 3.ª palavra.

```
1st WORD: [Prefix 10bit] + [PropCode=63 6bit]
2nd WORD: Edge TID (16 bits)
3rd WORD: P-ID alinhamento semântico (16 bits)
4th WORD: Subject TID (16 bits)
5th WORD: Object TID (16 bits)
```

## Top 63 propriedades (PropCode 0~62)

Propriedades selecionadas com base na frequência de uso no Wikidata.

### Classificação/tipo (Code 0~7)

| Code | P-ID | Propriedade | Descrição |
|------|------|-------------|-----------|
| 0 | P31 | instance of | Instância de ~ |
| 1 | P279 | subclass of | Subclasse de ~ |
| 2 | P361 | part of | Parte de ~ |
| 3 | P527 | has part | Contém ~ |
| 4 | P1552 | has quality | Propriedade/característica |
| 5 | P460 | same as | Igual |
| 6 | P1889 | different from | Diferente |
| 7 | P156 | followed by | Seguinte |

### Espaço/localização (Code 8~15)

| Code | P-ID | Propriedade | Descrição |
|------|------|-------------|-----------|
| 8 | P17 | country | País |
| 9 | P131 | located in | Localização (divisão administrativa) |
| 10 | P276 | location | Localização (lugar) |
| 11 | P625 | coordinate | Coordenadas |
| 12 | P30 | continent | Continente |
| 13 | P36 | capital | Capital |
| 14 | P150 | contains | Contém (região) |
| 15 | P206 | located next to | Corpo de água adjacente |

### Tempo (Code 16~23)

| Code | P-ID | Propriedade | Descrição |
|------|------|-------------|-----------|
| 16 | P569 | date of birth | Data de nascimento |
| 17 | P570 | date of death | Data de falecimento |
| 18 | P571 | inception | Data de fundação |
| 19 | P576 | dissolved | Data de dissolução |
| 20 | P577 | publication date | Data de publicação |
| 21 | P580 | start time | Momento de início |
| 22 | P582 | end time | Momento de fim |
| 23 | P585 | point in time | Momento específico |

### Informação pessoal (Code 24~31)

| Code | P-ID | Propriedade | Descrição |
|------|------|-------------|-----------|
| 24 | P19 | place of birth | Local de nascimento |
| 25 | P20 | place of death | Local de falecimento |
| 26 | P21 | sex or gender | Sexo ou género |
| 27 | P27 | citizenship | Cidadania |
| 28 | P735 | given name | Nome próprio |
| 29 | P734 | family name | Apelido |
| 30 | P1559 | name in native language | Nome nativo |
| 31 | P742 | pseudonym | Pseudónimo |

### Relações/pertença (Code 32~39)

| Code | P-ID | Propriedade | Descrição |
|------|------|-------------|-----------|
| 32 | P22 | father | Pai |
| 33 | P25 | mother | Mãe |
| 34 | P26 | spouse | Cônjuge |
| 35 | P40 | child | Filho/a |
| 36 | P3373 | sibling | Irmão/ã |
| 37 | P463 | member of | Membro de |
| 38 | P108 | employer | Empregador |
| 39 | P1027 | conferred by | Conferido por |

### Ocupação/atividade (Code 40~47)

| Code | P-ID | Propriedade | Descrição |
|------|------|-------------|-----------|
| 40 | P106 | occupation | Ocupação |
| 41 | P39 | position held | Cargo |
| 42 | P69 | educated at | Educação |
| 43 | P101 | field of work | Área de trabalho |
| 44 | P1344 | participant in | Participação (evento) |
| 45 | P166 | award received | Prémio recebido |
| 46 | P800 | notable work | Obra notável |
| 47 | P1412 | languages spoken | Idiomas falados |

### Media/identificação (Code 48~55)

| Code | P-ID | Propriedade | Descrição |
|------|------|-------------|-----------|
| 48 | P18 | image | Imagem |
| 49 | P154 | logo | Logo |
| 50 | P41 | flag image | Bandeira |
| 51 | P373 | Commons category | Wikimedia |
| 52 | P856 | official website | Site oficial |
| 53 | P214 | VIAF ID | VIAF |
| 54 | P227 | GND ID | GND |
| 55 | P213 | ISNI | ISNI |

### Obras/criação (Code 56~62)

| Code | P-ID | Propriedade | Descrição |
|------|------|-------------|-----------|
| 56 | P50 | author | Autor |
| 57 | P57 | director | Realizador |
| 58 | P86 | composer | Compositor |
| 59 | P175 | performer | Intérprete |
| 60 | P136 | genre | Género |
| 61 | P364 | original language | Idioma original |
| 62 | P123 | publisher | Editora |

Code 63 está reservado como **indicador de modo estendido**.

## Resumo do PropCode

```
┌─────────────────────────────────────────────┐
│  0~7:   Classificação/tipo (P31, P279, ...) │
│  8~15:  Espaço/localização (P17, P131, ...) │
│  16~23: Tempo (P569, P570, ...)             │
│  24~31: Info. pessoal (P19, P20, ...)       │
│  32~39: Relações/pertença (P22, P25, ...)   │
│  40~47: Ocupação/atividade (P106, P39, ...) │
│  48~55: Media/identificação (P18, P856, ..) │
│  56~62: Obras/criação (P50, P57, ...)       │
├─────────────────────────────────────────────┤
│  63: Indicador de modo estendido            │
└─────────────────────────────────────────────┘
```

## Exemplos

### Modo básico: "A Apple é uma empresa"

```
P31 (instance of) → PropCode = 0

Triple Edge:
  1st: [1100 000 001] + [000000]  - Prefix + PropCode 0
  2nd: [TID: 0x0101]              - Edge TID
  3rd: [TID: 0x0010]              - Apple (Subject)
  4th: [TID: 0x0020]              - Empresa (Object)

Total: 4 palavras
```

### Modo estendido: "A altura da Torre Eiffel é 330m"

```
P2048 (height) → Fora do Top 63 → Modo estendido

Triple Edge:
  1st: [1100 000 001] + [111111]  - Prefix + Ext(63)
  2nd: [TID: 0x0102]              - Edge TID
  3rd: [0xA800]                   - P2048 alinhamento semântico
  4th: [TID: 0x0030]              - Torre Eiffel (Subject)
  5th: [TID: 0x0050]              - 330m Quantity (Object)

Total: 5 palavras
```

## Análise (parsing)

```python
def parse_triple_edge(data: bytes) -> dict:
    word1 = int.from_bytes(data[0:2], 'big')

    prefix = word1 >> 6
    assert prefix == 0b1100000001, "Not Triple Edge"

    prop_code = word1 & 0x3F

    if prop_code < 63:
        # Modo básico (4 palavras)
        return {
            'mode': 'basic',
            'prop_code': prop_code,
            'edge_tid': int.from_bytes(data[2:4], 'big'),
            'subject_tid': int.from_bytes(data[4:6], 'big'),
            'object_tid': int.from_bytes(data[6:8], 'big'),
            'words': 4
        }
    else:
        # Modo estendido (5 palavras)
        return {
            'mode': 'extended',
            'p_id': int.from_bytes(data[4:6], 'big'),
            'edge_tid': int.from_bytes(data[2:4], 'big'),
            'subject_tid': int.from_bytes(data[6:8], 'big'),
            'object_tid': int.from_bytes(data[8:10], 'big'),
            'words': 5
        }
```
