---
title: "Beispiel: Wikidata-Eintrag"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "example", "wikidata"]
summary: "Ein GEUL-Dokument mit 63 WORD zu Wikidata Q42 (Douglas Adams), das einen Namen, zwei Propositionen und eine einschränkende Bedingung enthält, wird von Anfang bis Ende gelesen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Wir lesen ein kleines Dokument über den Wikidata-Eintrag Q42 (Douglas Adams) von Anfang bis Ende. Es enthält Folgendes:

- Englischer Name: Douglas Adams
- Q42 ist eine Instanz von Mensch (Q5) (P31).
- Q42 wurde am St John's College (Q691283) ausgebildet (P69). Der Beginn (P580) ist das Jahr 1971.

Das Dokument gehört zu Issuer `0x00010000`, hat die Dokument-ID `0x510000000000002a` und umfasst insgesamt 63 WORD (126 Bytes).

## Gesamtes Dokument

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

`1880` ist Meta (`11`), Length 2 WORD, Codec `0x00` (DOC-1WORD). Der Wert `003f` (63) ist die Gesamtzahl der WORD des Dokuments. Der Decoder kennt damit das Ende des Dokuments im Voraus.

```
1890 0001
```

Meta `0x10` SPEC-VERSION. Die Spezifikationsausgabe, der dieses Dokument folgt. v1 ist `0001`.

```
1c92 0438 0001 0000 5100 0000 0000 002a 0000 0000
```

Meta `0x12` DOC-ID, insgesamt 10 WORD. Der Payload ist ein DOC-POINTER-Reference.

| WORD | Bedeutung |
|---|---|
| `0438` | Reference, 9 WORD, Codec `0111` (DOC-POINTER), Quantifier `000` |
| `0001 0000` | Issuer `0x00010000` (2 WORD) |
| `5100 0000 0000 002a` | Dokument-ID `0x510000000000002a` |
| `0000 0000` | Version `0` (das Dokument selbst) |

```
180e
```

BODY. Der HEAD endet, und der BODY beginnt.

## BODY

### #1 LABEL — Englischer Name

```
1704 0010 0088 0001 00a0 002a 0ccb 08c6 656e 446f 7567 6c61 7320 4164 616d 7300
```

| WORD | Bedeutung |
|---|---|
| `1704` | Edge, Length `1110` (erweitert), Codec `0x04` LABEL |
| `0010` | Erweiterte Länge: insgesamt 16 WORD |
| `0088 0001` | Edge Id: LOCAL 1 |
| `00a0 002a` | Subject: Wikidata Q42 |
| `0ccb` | Object: UTF8-LANGUAGE-TEXT, 10 WORD, ungerade Bytezahl (`0x4B`) |
| `08c6 656e` | Sprache: BCP 47 `en` |
| `446f … 7300` | `Douglas Adams` 13 Bytes + Padding `00` |

### #2 TRIPLE — Q42 ist ein Mensch

```
148a 0088 0002 00a8 001f 00a0 002a 00a0 0005 0000
```

| WORD | Bedeutung |
|---|---|
| `148a` | Edge, 10 WORD, Codec `0x0A` TRIPLE |
| `0088 0002` | Edge Id: LOCAL 2 |
| `00a8 001f` | Predicate: P31 (instance of) |
| `00a0 002a` | Subject: Q42 |
| `00a0 0005` | Object: Q5 (Mensch) |
| `0000` | Rank: normal |

### #3 TRIPLE — Q42 wurde am St John's College ausgebildet

```
150a 0088 0003 00a8 0045 00a0 002a 0120 000a 8c53 0000
```

| WORD | Bedeutung |
|---|---|
| `150a` | Edge, 11 WORD, TRIPLE |
| `0088 0003` | Edge Id: LOCAL 3 |
| `00a8 0045` | Predicate: P69 (educated at) |
| `00a0 002a` | Subject: Q42 |
| `0120 000a 8c53` | Object: Q691283. Der Wert übersteigt 16 Bit, daher ein Reference aus 3 WORD |
| `0000` | Rank: normal |

### #4 QUALIFIER — Beginn im Jahr 1971

```
148b 0088 0004 00a8 0244 0088 0003 0924 3139 3731
```

| WORD | Bedeutung |
|---|---|
| `148b` | Edge, 10 WORD, Codec `0x0B` QUALIFIER |
| `0088 0004` | Edge Id: LOCAL 4 |
| `00a8 0244` | Property: P580 (start time) |
| `0088 0003` | Target: #3 (das TRIPLE oben) |
| `0924 3139 3731` | Value: EDTF `1971` (Genauigkeit Jahr, daher EDTF statt GREGORIAN-DATE) |

Die Bedeutung von #3 ist die Gesamtheit von #3 selbst und aller QUALIFIER, die auf #3 verweisen: „Q42 wurde seit 1971 am St John's College ausgebildet.“

```
180f
```

END. Bis hierher sind es 63 WORD.

## Lesen ohne Codebook

Auch ein Decoder, der das Codebook nicht kennt, weiß Folgendes:

- Das Dokument umfasst 63 WORD und hat im HEAD 2 Meta und im BODY 4 Edges.
- Den Codec jedes Edge (LABEL, TRIPLE, TRIPLE, QUALIFIER) und seine Edge Id (1, 2, 3, 4).
- Die Position des jeweils nächsten Records.

Die Rolle der Komponenten (Predicate, Subject, Object, Rank) erfährt man erst aus dem [Spezifikationsdokument](/de/grammar/codec-spec/) des jeweiligen Codecs.

## Inhaltshash

Der Inhaltshash (SHA-256) dieses Dokuments lautet wie folgt. Bei einer Veröffentlichung wird dieser Hash zusammen mit der Versions-ID in der Versionsliste festgehalten.

```
0x4f05137f92de70951f581156cf90f15471c254c7e87ad1ba100bf91dd705ebc1
```
