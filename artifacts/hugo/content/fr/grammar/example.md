---
title: "Exemple : un élément Wikidata"
weight: 140
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "example", "wikidata"]
summary: "Lecture, du début à la fin, d'un petit document sur l'élément Wikidata Q42 (Douglas Adams)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Lecture, du début à la fin, d'un petit document sur l'élément Wikidata Q42 (Douglas Adams). Il contient ceci.

- Nom anglais : Douglas Adams
- Q42 est une instance de personne (Q5) (P31).
- Q42 a fait ses études au St John's College (Q691283) (P69). La date de début (P580) est 1971.

Le document est le document `0x510000000000002A` de l'Issuer `0x00000001`, et compte 63 WORD au total (126 octets).

## Ensemble {#전체}

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

`1C01` est Meta (section 14), Codec `0x1C0L` (DOC-1WORD), Length 2 WORD. La valeur `003F` (63) est le nombre total de WORD du document. Le décodeur connaît ainsi d'avance la fin du document.

```
1C51 0001
```

Meta `0x1C5L` SPEC-VERSION. C'est la version de la spécification que suit ce document. Pour v1, c'est `0001`.

```
1C79 0418 0000 0001 5100 0000 0000 002A 0000 0000
```

Meta `0x1C7L` DOC-ID, 10 WORD au total. Le Payload est une seule Reference DOC-POINTER.

| WORD | Signification |
|---|---|
| `0418` | Reference, Codec `0x041L` (DOC-POINTER), 9 WORD |
| `0000 0001` | Issuer `0x00000001` (2 WORD) |
| `5100 0000 0000 002A` | ID du document `0x510000000000002A` |
| `0000 0000` | version `0` (lui-même) |

```
1C30
```

BODY. Le HEAD se termine et le BODY commence.

## BODY {#body}

### #1 LABEL — nom anglais {#1-label--영어-이름}

```
0A4E 0010 0051 0001 0141 002A 0799 0761 656E 446F 7567 6C61 7320 4164 616D 7300
```

| WORD | Signification |
|---|---|
| `0A4E` | Edge, Codec `0x0A4L` LABEL, Length `1110` (étendue) |
| `0010` | longueur étendue : 16 WORD au total |
| `0051 0001` | Edge Id : LOCAL 1 |
| `0141 002A` | Subject : Wikidata Q42 |
| `0799` | Object : UTF8-LANGUAGE-TEXT, nombre impair d'octets (`0x079L`), 10 WORD |
| `0761 656E` | langue : BCP 47 `en` |
| `446F … 7300` | `Douglas Adams` 13 octets + remplissage `00` |

### #2 TRIPLE — Q42 est une personne {#2-triple--q42는-사람이다}

```
0AA9 0051 0002 0191 001F 0141 002A 0141 0005 0000
```

| WORD | Signification |
|---|---|
| `0AA9` | Edge, Codec `0x0AAL` TRIPLE, 10 WORD |
| `0051 0002` | Edge Id : LOCAL 2 |
| `0191 001F` | Predicate : P31 (instance of) |
| `0141 002A` | Subject : Q42 |
| `0141 0005` | Object : Q5 (personne) |
| `0000` | Rank : normal |

### #3 TRIPLE — Q42 a fait ses études au St John's College {#3-triple--q42는-st-johns-college에서-교육받았다}

```
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000
```

| WORD | Signification |
|---|---|
| `0AAA` | Edge, TRIPLE, 11 WORD |
| `0051 0003` | Edge Id : LOCAL 3 |
| `0191 0045` | Predicate : P69 (educated at) |
| `0141 002A` | Subject : Q42 |
| `0142 000A 8C53` | Object : Q691283. La valeur dépasse 16 bits ; c'est donc une Reference de 3 WORD |
| `0000` | Rank : normal |

### #4 QUALIFIER — date de début 1971 {#4-qualifier--시작-시점-1971년}

```
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731
```

| WORD | Signification |
|---|---|
| `0AB9` | Edge, Codec `0x0ABL` QUALIFIER, 10 WORD |
| `0051 0004` | Edge Id : LOCAL 4 |
| `0191 0244` | Property : P580 (start time) |
| `0051 0003` | Target : #3 (le TRIPLE ci-dessus) |
| `06E2 3139 3731` | Value : EDTF `1971` (précision à l'année, donc EDTF et non GREGORIAN-DATE) |

Le sens de #3 est l'ensemble de #3 lui-même et des QUALIFIER qui le désignent : « Q42 a fait ses études au St John's College à partir de 1971. »

```
1C40
```

END. Jusqu'ici, 63 WORD.

## Lecture sans codebook {#코덱북-없이-읽으면}

Un décodeur qui ne connaît pas le codebook sait déjà ceci.

- Le document compte 63 WORD, avec 2 Meta dans le HEAD et 4 Edge dans le BODY.
- Le Codec de chaque Edge (LABEL, TRIPLE, TRIPLE, QUALIFIER) et son Edge Id (1, 2, 3, 4).
- La position de l'enregistrement suivant, pour chaque enregistrement.

Le rôle des composants (Predicate, Subject, Object, Rank) ne s'apprend qu'en lisant le [document de spécification](codec-spec.md) de chaque Codec.

## Hachage du contenu {#내용-해시}

Le hachage du contenu (SHA-256) de ce document est le suivant. À la publication, ce hachage est consigné dans la liste des versions avec l'ID de version.

```
0x561C157203D51AF8C754D53E20AD190F17E73ACDC4235BA47C87F608C946737F
```
