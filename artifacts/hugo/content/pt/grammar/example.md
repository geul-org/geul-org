---
title: "Exemplo: item do Wikidata"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "example", "wikidata"]
summary: "Lê do começo ao fim um documento GEUL de 63 WORDs que contém um nome, duas proposições e uma condição restritiva de Q42 (Douglas Adams) do Wikidata."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Vamos ler do começo ao fim um pequeno documento sobre o item Q42 (Douglas Adams) do Wikidata. O conteúdo é este.

- Nome em inglês: Douglas Adams
- Q42 é uma instância de pessoa (Q5) (P31).
- Q42 estudou no St John's College (Q691283) (P69). A data de início (P580) é 1971.

O documento tem Issuer `0x00010000` e ID de documento `0x510000000000002a`, com 63 WORDs no total (126 bytes).

## Completo

```
1880 003f 1890 0001 1c92 0438 0001 0000 5100 0000 0000 002a 0000 0000
180e
1704 0010 0088 0001 00a0 002a 0ccb 08c6 656e 446f 7567 6c61 7320 4164 616d 7300
148a 0088 0002 00a8 001f 00a0 002a 00a0 0005 0000
150a 0088 0003 00a8 0045 00a0 002a 0120 000a 8c53 0000
148b 0088 0004 00a8 0244 0088 0003 0924 3139 3731
180f
```

## HEAD

```
1880 003f
```

`1880` é Meta (`11`), Length de 2 WORDs, Codec `0x00` (DOC-1WORD). O valor `003f` (63) é o número total de WORDs do documento. Com ele, o decodificador sabe de antemão onde o documento termina.

```
1890 0001
```

Meta `0x10` SPEC-VERSION. É a versão da especificação que este documento segue. A v1 é `0001`.

```
1c92 0438 0001 0000 5100 0000 0000 002a 0000 0000
```

Meta `0x12` DOC-ID, 10 WORDs no total. O Payload é uma única Reference DOC-POINTER.

| WORD | Significado |
|---|---|
| `0438` | Reference, 9 WORDs, Codec `0111` (DOC-POINTER), Quantifier `000` |
| `0001 0000` | Issuer `0x00010000` (2 WORDs) |
| `5100 0000 0000 002a` | ID do documento `0x510000000000002a` |
| `0000 0000` | versão `0` (o próprio documento) |

```
180e
```

BODY. O HEAD termina e o BODY começa.

## BODY

### #1 LABEL — nome em inglês

```
1704 0010 0088 0001 00a0 002a 0ccb 08c6 656e 446f 7567 6c61 7320 4164 616d 7300
```

| WORD | Significado |
|---|---|
| `1704` | Edge, Length `1110` (estendido), Codec `0x04` LABEL |
| `0010` | comprimento estendido: 16 WORDs no total |
| `0088 0001` | Edge Id: LOCAL 1 |
| `00a0 002a` | Subject: Q42 do Wikidata |
| `0ccb` | Object: UTF8-LANGUAGE-TEXT, 10 WORDs, número ímpar de bytes (`0x4B`) |
| `08c6 656e` | idioma: BCP 47 `en` |
| `446f … 7300` | `Douglas Adams`, 13 bytes + preenchimento `00` |

### #2 TRIPLE — Q42 é uma pessoa

```
148a 0088 0002 00a8 001f 00a0 002a 00a0 0005 0000
```

| WORD | Significado |
|---|---|
| `148a` | Edge, 10 WORDs, Codec `0x0A` TRIPLE |
| `0088 0002` | Edge Id: LOCAL 2 |
| `00a8 001f` | Predicate: P31 (instance of) |
| `00a0 002a` | Subject: Q42 |
| `00a0 0005` | Object: Q5 (pessoa) |
| `0000` | Rank: normal |

### #3 TRIPLE — Q42 estudou no St John's College

```
150a 0088 0003 00a8 0045 00a0 002a 0120 000a 8c53 0000
```

| WORD | Significado |
|---|---|
| `150a` | Edge, 11 WORDs, TRIPLE |
| `0088 0003` | Edge Id: LOCAL 3 |
| `00a8 0045` | Predicate: P69 (educated at) |
| `00a0 002a` | Subject: Q42 |
| `0120 000a 8c53` | Object: Q691283. O valor ultrapassa 16 bits, por isso é uma Reference de 3 WORDs |
| `0000` | Rank: normal |

### #4 QUALIFIER — data de início 1971

```
148b 0088 0004 00a8 0244 0088 0003 0924 3139 3731
```

| WORD | Significado |
|---|---|
| `148b` | Edge, 10 WORDs, Codec `0x0B` QUALIFIER |
| `0088 0004` | Edge Id: LOCAL 4 |
| `00a8 0244` | Property: P580 (start time) |
| `0088 0003` | Target: #3 (o TRIPLE acima) |
| `0924 3139 3731` | Value: EDTF `1971` (a precisão é de ano, então é EDTF e não GREGORIAN-DATE) |

O significado de #3 é a soma do próprio #3 com todos os QUALIFIERs que apontam para #3: "Q42 estudou no St John's College a partir de 1971."

```
180f
```

END. Até aqui são 63 WORDs.

## Lendo sem codebook

Mesmo um decodificador que não conhece o codebook sabe o seguinte.

- O documento tem 63 WORDs, com 2 Metas no HEAD e 4 Edges no BODY.
- O Codec de cada Edge (LABEL, TRIPLE, TRIPLE, QUALIFIER) e o Edge Id (1, 2, 3, 4).
- A posição do registro seguinte a cada registro.

Os papéis dos componentes (Predicate, Subject, Object, Rank) só se conhecem lendo o [documento de especificação](/pt/grammar/codec-spec/) de cada Codec.

## Hash de conteúdo

O hash de conteúdo (SHA-256) deste documento é o seguinte. Quando é publicado, esse hash é registrado na lista de versões junto com o ID da versão.

```
0x4f05137f92de70951f581156cf90f15471c254c7e87ad1ba100bf91dd705ebc1
```
