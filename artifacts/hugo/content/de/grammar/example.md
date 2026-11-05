---
title: "Beispiel: Wikidata-Eintrag"
weight: 140
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "example", "wikidata"]
summary: "Ein kleines Dokument über den Wikidata-Eintrag Q42 (Douglas Adams) wird von Anfang bis Ende gelesen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Ein kleines Dokument über den Wikidata-Eintrag Q42 (Douglas Adams) wird von Anfang bis Ende gelesen. Es enthält Folgendes.

- Englischer Name: Douglas Adams
- Q42 ist eine Instanz von Mensch (Q5) (P31).
- Q42 wurde am St John's College (Q691283) ausgebildet (P69). Der Beginn (P580) ist das Jahr 1971.

Das Dokument ist das Dokument `0x510000000000002A` des Issuers `0x00000001` und umfasst insgesamt 63 WORD (126 Byte).

## Gesamt {#전체}

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

`1C01` ist Meta (Abschnitt 14), Codec `0x1C0L` (DOC-1WORD), Length 2 WORD. Der Wert `003F` (63) ist die Gesamtzahl der WORD des Dokuments. Anhand dieses Wertes kennt der Decoder das Ende des Dokuments im Voraus.

```
1C51 0001
```

Meta `0x1C5L` SPEC-VERSION. Das ist die Fassung der Spezifikation, der dieses Dokument folgt. Bei v1 ist es `0001`.

```
1C79 0418 0000 0001 5100 0000 0000 002A 0000 0000
```

Meta `0x1C7L` DOC-ID, insgesamt 10 WORD. Der Payload ist eine einzelne DOC-POINTER Reference.

| WORD | Bedeutung |
|---|---|
| `0418` | Reference, Codec `0x041L` (DOC-POINTER), 9 WORD |
| `0000 0001` | Issuer `0x00000001` (2 WORD) |
| `5100 0000 0000 002A` | Dokument-ID `0x510000000000002A` |
| `0000 0000` | Version `0` (das Dokument selbst) |

```
1C30
```

BODY. Hier endet HEAD, und BODY beginnt.

## BODY {#body}

### #1 LABEL — englischer Name {#1-label--영어-이름}

```
0A4E 0010 0051 0001 0141 002A 0799 0761 656E 446F 7567 6C61 7320 4164 616D 7300
```

| WORD | Bedeutung |
|---|---|
| `0A4E` | Edge, Codec `0x0A4L` LABEL, Length `1110` (erweitert) |
| `0010` | erweiterte Length: insgesamt 16 WORD |
| `0051 0001` | Edge Id: LOCAL 1 |
| `0141 002A` | Subject: Wikidata Q42 |
| `0799` | Object: UTF8-LANGUAGE-TEXT, ungerade Byteanzahl (`0x079L`), 10 WORD |
| `0761 656E` | Sprache: BCP 47 `en` |
| `446F … 7300` | `Douglas Adams` 13 Byte + Padding `00` |

### #2 TRIPLE — Q42 ist ein Mensch {#2-triple--q42는-사람이다}

```
0AA9 0051 0002 0191 001F 0141 002A 0141 0005 0000
```

| WORD | Bedeutung |
|---|---|
| `0AA9` | Edge, Codec `0x0AAL` TRIPLE, 10 WORD |
| `0051 0002` | Edge Id: LOCAL 2 |
| `0191 001F` | Predicate: P31 (instance of) |
| `0141 002A` | Subject: Q42 |
| `0141 0005` | Object: Q5 (Mensch) |
| `0000` | Rank: normal |

### #3 TRIPLE — Q42 wurde am St John's College ausgebildet {#3-triple--q42는-st-johns-college에서-교육받았다}

```
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000
```

| WORD | Bedeutung |
|---|---|
| `0AAA` | Edge, TRIPLE, 11 WORD |
| `0051 0003` | Edge Id: LOCAL 3 |
| `0191 0045` | Predicate: P69 (educated at) |
| `0141 002A` | Subject: Q42 |
| `0142 000A 8C53` | Object: Q691283. Der Wert überschreitet 16 Bit und ist daher eine Reference mit 3 WORD |
| `0000` | Rank: normal |

### #4 QUALIFIER — Beginn im Jahr 1971 {#4-qualifier--시작-시점-1971년}

```
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731
```

| WORD | Bedeutung |
|---|---|
| `0AB9` | Edge, Codec `0x0ABL` QUALIFIER, 10 WORD |
| `0051 0004` | Edge Id: LOCAL 4 |
| `0191 0244` | Property: P580 (start time) |
| `0051 0003` | Target: #3 (das TRIPLE oben) |
| `06E2 3139 3731` | Value: EDTF `1971` (wegen der Jahresgenauigkeit EDTF statt GREGORIAN-DATE) |

Die Bedeutung von #3 ist die Gesamtheit aus #3 selbst und allen QUALIFIER, die auf #3 verweisen: „Q42 wurde ab 1971 am St John's College ausgebildet.“

```
1C40
```

END. Bis hierhin sind es 63 WORD.

## Lesen ohne Codebook {#코덱북-없이-읽으면}

Auch ein Decoder, der das Codebook nicht kennt, weiß Folgendes.

- Das Dokument hat 63 WORD, im HEAD stehen 2 Meta, im BODY 4 Edge.
- Der Codec jeder Edge (LABEL, TRIPLE, TRIPLE, QUALIFIER) und die Edge Id (1, 2, 3, 4).
- Die Position des jeweils nächsten Records.

Die Rollen der Komponenten (Predicate, Subject, Object, Rank) erfährt man erst aus dem [Spezifikationsdokument](codec-spec.md) des jeweiligen Codec.

## Inhaltshash {#내용-해시}

Der Inhaltshash (SHA-256) dieses Dokuments lautet wie folgt. Bei der Veröffentlichung wird dieser Hash zusammen mit der Versions-ID in der Versionsliste eingetragen.

```
0x561C157203D51AF8C754D53E20AD190F17E73ACDC4235BA47C87F608C946737F
```
