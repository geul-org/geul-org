---
title: "Exemple : un élément Wikidata"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "example", "wikidata"]
summary: "Lecture complète d'un document GEUL de 63 WORD contenant un nom, deux propositions et une condition restrictive de Q42 (Douglas Adams) de Wikidata."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Lisons de bout en bout un petit document sur l'élément Wikidata Q42 (Douglas Adams). Il contient :

- Nom anglais : Douglas Adams
- Q42 est une instance d'être humain (Q5) (P31).
- Q42 a fait ses études à St John's College (Q691283) (P69). La date de début (P580) est 1971.

Le document est celui de l'Issuer `0x00010000` d'ID `0x510000000000002a`, et fait 63 WORD au total (126 octets).

## Vue d'ensemble

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

`1880` est un Meta (`11`), Length 2 WORD, Codec `0x00` (DOC-1WORD). La valeur `003f` (63) est le nombre total de WORD du document. Le décodeur connaît ainsi à l'avance la fin du document.

```
1890 0001
```

Meta `0x10` SPEC-VERSION. C'est l'édition de la spécification que suit ce document. v1 vaut `0001`.

```
1c92 0438 0001 0000 5100 0000 0000 002a 0000 0000
```

Meta `0x12` DOC-ID, 10 WORD au total. Le Payload est une Reference DOC-POINTER.

| WORD | Sens |
|---|---|
| `0438` | Reference, 9 WORD, Codec `0111` (DOC-POINTER), Quantifier `000` |
| `0001 0000` | Issuer `0x00010000` (2 WORD) |
| `5100 0000 0000 002a` | ID de document `0x510000000000002a` |
| `0000 0000` | Version `0` (lui-même) |

```
180e
```

BODY. Le HEAD se termine et le BODY commence.

## BODY

### #1 LABEL — nom anglais

```
1704 0010 0088 0001 00a0 002a 0ccb 08c6 656e 446f 7567 6c61 7320 4164 616d 7300
```

| WORD | Sens |
|---|---|
| `1704` | Edge, Length `1110` (étendue), Codec `0x04` LABEL |
| `0010` | Longueur étendue : 16 WORD au total |
| `0088 0001` | Edge Id : LOCAL 1 |
| `00a0 002a` | Subject : Q42 de Wikidata |
| `0ccb` | Object : UTF8-LANGUAGE-TEXT, 10 WORD, nombre d'octets impair (`0x4B`) |
| `08c6 656e` | Langue : BCP 47 `en` |
| `446f … 7300` | `Douglas Adams` 13 octets + remplissage `00` |

### #2 TRIPLE — Q42 est un être humain

```
148a 0088 0002 00a8 001f 00a0 002a 00a0 0005 0000
```

| WORD | Sens |
|---|---|
| `148a` | Edge, 10 WORD, Codec `0x0A` TRIPLE |
| `0088 0002` | Edge Id : LOCAL 2 |
| `00a8 001f` | Predicate : P31 (instance of) |
| `00a0 002a` | Subject : Q42 |
| `00a0 0005` | Object : Q5 (être humain) |
| `0000` | Rank : normal |

### #3 TRIPLE — Q42 a fait ses études à St John's College

```
150a 0088 0003 00a8 0045 00a0 002a 0120 000a 8c53 0000
```

| WORD | Sens |
|---|---|
| `150a` | Edge, 11 WORD, TRIPLE |
| `0088 0003` | Edge Id : LOCAL 3 |
| `00a8 0045` | Predicate : P69 (educated at) |
| `00a0 002a` | Subject : Q42 |
| `0120 000a 8c53` | Object : Q691283. La valeur dépassant 16 bits, c'est une Reference de 3 WORD |
| `0000` | Rank : normal |

### #4 QUALIFIER — date de début 1971

```
148b 0088 0004 00a8 0244 0088 0003 0924 3139 3731
```

| WORD | Sens |
|---|---|
| `148b` | Edge, 10 WORD, Codec `0x0B` QUALIFIER |
| `0088 0004` | Edge Id : LOCAL 4 |
| `00a8 0244` | Property : P580 (start time) |
| `0088 0003` | Target : #3 (le TRIPLE ci-dessus) |
| `0924 3139 3731` | Value : EDTF `1971` (précision à l'année, donc EDTF et non GREGORIAN-DATE) |

Le sens de #3 est l'ensemble de #3 lui-même et de tous les QUALIFIER qui le désignent : « Q42 a fait ses études à St John's College à partir de 1971. »

```
180f
```

END. Cela fait jusqu'ici 63 WORD.

## Lecture sans livre de codes

Un décodeur qui ignore le livre de codes sait déjà :

- Le document fait 63 WORD, avec 2 Meta dans le HEAD et 4 Edge dans le BODY.
- Le Codec de chaque Edge (LABEL, TRIPLE, TRIPLE, QUALIFIER) et son Edge Id (1, 2, 3, 4).
- La position de l'enregistrement suivant pour chaque enregistrement.

Le rôle des composants (Predicate, Subject, Object, Rank) ne se connaît qu'en lisant le [document de spécification](/fr/grammar/codec-spec/) de chaque Codec.

## Hachage du contenu

Le hachage du contenu (SHA-256) de ce document est le suivant. À la publication, ce hachage est consigné dans la liste des versions avec l'ID de version.

```
0x4f05137f92de70951f581156cf90f15471c254c7e87ad1ba100bf91dd705ebc1
```
