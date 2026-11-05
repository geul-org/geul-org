---
title: "Exemplo: item do Wikidata"
weight: 140
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "example", "wikidata"]
summary: "Lê do início ao fim um pequeno documento sobre o item Q42 (Douglas Adams) do Wikidata."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Lê-se do início ao fim um pequeno documento sobre o item Q42 (Douglas Adams) do Wikidata. O conteúdo é o seguinte.

- Nome em inglês: Douglas Adams
- Q42 é uma instância de pessoa (Q5) (P31).
- Q42 estudou no St John's College (Q691283) (P69). O momento de início (P580) é o ano de 1971.

O documento é o documento `0x510000000000002A` do Issuer `0x00000001`, com 63 WORD no total (126 bytes).

## Visão completa {#전체}

```
1C01 003F 1C51 0001 1C79 0418 0000 0001 5100 0000 0000 002A 0000 0000
1C30
0A4E 0010 0051 0001 0141 002A 0799 0761 656E 446F 7567 6C61 7320 4164 616D 7300
0AA9 0051 0002 0191 001F 0141 002A 0141 0005 0000
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731
1C40
```

## HEAD {#head}

```
1C01 003F
```

`1C01` é Meta (seção 14), Codec `0x1C0L` (DOC-1WORD), Length de 2 WORD. O valor `003F` (63) é o número total de WORD do documento. Com esse valor, o decodificador sabe de antemão onde o documento termina.

```
1C51 0001
```

Meta `0x1C5L` SPEC-VERSION. É a edição da especificação que este documento segue. A v1 é `0001`.

```
1C79 0418 0000 0001 5100 0000 0000 002A 0000 0000
```

Meta `0x1C7L` DOC-ID, 10 WORD no total. O Payload é uma única Reference DOC-POINTER.

| WORD | Significado |
|---|---|
| `0418` | Reference, Codec `0x041L` (DOC-POINTER), 9 WORD |
| `0000 0001` | Issuer `0x00000001` (2 WORD) |
| `5100 0000 0000 002A` | ID do documento `0x510000000000002A` |
| `0000 0000` | versão `0` (o próprio documento) |

```
1C30
```

BODY. O HEAD termina e o BODY começa.

## BODY {#body}

### #1 LABEL — nome em inglês {#1-label--영어-이름}

```
0A4E 0010 0051 0001 0141 002A 0799 0761 656E 446F 7567 6C61 7320 4164 616D 7300
```

| WORD | Significado |
|---|---|
| `0A4E` | Edge, Codec `0x0A4L` LABEL, Length `1110` (estendido) |
| `0010` | comprimento estendido: 16 WORD no total |
| `0051 0001` | Edge Id: LOCAL 1 |
| `0141 002A` | Subject: Q42 do Wikidata |
| `0799` | Object: UTF8-LANGUAGE-TEXT, número ímpar de bytes (`0x079L`), 10 WORD |
| `0761 656E` | idioma: BCP 47 `en` |
| `446F … 7300` | `Douglas Adams`, 13 bytes + preenchimento `00` |

### #2 TRIPLE — Q42 é uma pessoa {#2-triple--q42는-사람이다}

```
0AA9 0051 0002 0191 001F 0141 002A 0141 0005 0000
```

| WORD | Significado |
|---|---|
| `0AA9` | Edge, Codec `0x0AAL` TRIPLE, 10 WORD |
| `0051 0002` | Edge Id: LOCAL 2 |
| `0191 001F` | Predicate: P31 (instance of) |
| `0141 002A` | Subject: Q42 |
| `0141 0005` | Object: Q5 (pessoa) |
| `0000` | Rank: normal |

### #3 TRIPLE — Q42 estudou no St John's College {#3-triple--q42는-st-johns-college에서-교육받았다}

```
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000
```

| WORD | Significado |
|---|---|
| `0AAA` | Edge, TRIPLE, 11 WORD |
| `0051 0003` | Edge Id: LOCAL 3 |
| `0191 0045` | Predicate: P69 (educated at) |
| `0141 002A` | Subject: Q42 |
| `0142 000A 8C53` | Object: Q691283. O valor excede 16 bits, por isso é uma Reference de 3 WORD |
| `0000` | Rank: normal |

### #4 QUALIFIER — início no ano de 1971 {#4-qualifier--시작-시점-1971년}

```
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731
```

| WORD | Significado |
|---|---|
| `0AB9` | Edge, Codec `0x0ABL` QUALIFIER, 10 WORD |
| `0051 0004` | Edge Id: LOCAL 4 |
| `0191 0244` | Property: P580 (start time) |
| `0051 0003` | Target: #3 (o TRIPLE acima) |
| `06E2 3139 3731` | Value: EDTF `1971` (por ter precisão de ano, usa-se EDTF e não GREGORIAN-DATE) |

O significado de #3 é a soma do próprio #3 com todos os QUALIFIERs que apontam para #3: "Q42 estudou no St John's College a partir de 1971."

```
1C40
```

END. Até aqui são 63 WORD.

## Lendo sem livro de códigos {#코덱북-없이-읽으면}

Mesmo um decodificador que não conhece o livro de códigos sabe o seguinte.

- O documento tem 63 WORD, com 2 Meta no HEAD e 4 Edges no BODY.
- O Codec de cada Edge (LABEL, TRIPLE, TRIPLE, QUALIFIER) e o Edge Id (1, 2, 3, 4).
- A posição do registro seguinte a cada registro.

Os papéis dos componentes (Predicate, Subject, Object, Rank) só se conhecem lendo o [documento de especificação](codec-spec.md) de cada Codec.

## Hash de conteúdo {#내용-해시}

O hash de conteúdo (SHA-256) deste documento é o seguinte. Ao publicar, a lista de versões registra esse hash junto com o ID da versão.

```
0x561C157203D51AF8C754D53E20AD190F17E73ACDC4235BA47C87F608C946737F
```
