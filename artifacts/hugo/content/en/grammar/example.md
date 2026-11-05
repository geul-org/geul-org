---
title: "Example: A Wikidata Item"
weight: 140
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "example", "wikidata"]
summary: "A small document about the Wikidata item Q42 (Douglas Adams), read from start to finish."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

This reads a small document about the Wikidata item Q42 (Douglas Adams) from start to finish. It contains the following.

- English name: Douglas Adams
- Q42 is an instance of human (Q5) (P31).
- Q42 was educated at St John's College (Q691283) (P69). The start time (P580) is 1971.

The document is document `0x510000000000002A` of Issuer `0x00000001`, 63 WORDs (126 bytes) in total.

## Whole Document {#전체}

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

`1C01` is Meta (section 14), Codec `0x1C0L` (DOC-1WORD), Length 2 WORDs. The value `003F` (63) is the total number of WORDs in the document. With this value the decoder knows the end of the document in advance.

```
1C51 0001
```

Meta `0x1C5L` SPEC-VERSION. This is the specification edition the document follows. v1 is `0001`.

```
1C79 0418 0000 0001 5100 0000 0000 002A 0000 0000
```

Meta `0x1C7L` DOC-ID, 10 WORDs in total. The Payload is one DOC-POINTER Reference.

| WORD | Meaning |
|---|---|
| `0418` | Reference, Codec `0x041L` (DOC-POINTER), 9 WORDs |
| `0000 0001` | Issuer `0x00000001` (2 WORDs) |
| `5100 0000 0000 002A` | Document ID `0x510000000000002A` |
| `0000 0000` | Version `0` (itself) |

```
1C30
```

BODY. The HEAD ends and the BODY begins.

## BODY {#body}

### #1 LABEL — English name {#1-label--영어-이름}

```
0A4E 0010 0051 0001 0141 002A 0799 0761 656E 446F 7567 6C61 7320 4164 616D 7300
```

| WORD | Meaning |
|---|---|
| `0A4E` | Edge, Codec `0x0A4L` LABEL, Length `1110` (extended) |
| `0010` | Extended length: 16 WORDs in total |
| `0051 0001` | Edge Id: LOCAL 1 |
| `0141 002A` | Subject: Wikidata Q42 |
| `0799` | Object: UTF8-LANGUAGE-TEXT, odd byte count (`0x079L`), 10 WORDs |
| `0761 656E` | Language: BCP 47 `en` |
| `446F … 7300` | `Douglas Adams`, 13 bytes + padding `00` |

### #2 TRIPLE — Q42 is a human {#2-triple--q42는-사람이다}

```
0AA9 0051 0002 0191 001F 0141 002A 0141 0005 0000
```

| WORD | Meaning |
|---|---|
| `0AA9` | Edge, Codec `0x0AAL` TRIPLE, 10 WORDs |
| `0051 0002` | Edge Id: LOCAL 2 |
| `0191 001F` | Predicate: P31 (instance of) |
| `0141 002A` | Subject: Q42 |
| `0141 0005` | Object: Q5 (human) |
| `0000` | Rank: normal |

### #3 TRIPLE — Q42 was educated at St John's College {#3-triple--q42는-st-johns-college에서-교육받았다}

```
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000
```

| WORD | Meaning |
|---|---|
| `0AAA` | Edge, TRIPLE, 11 WORDs |
| `0051 0003` | Edge Id: LOCAL 3 |
| `0191 0045` | Predicate: P69 (educated at) |
| `0141 002A` | Subject: Q42 |
| `0142 000A 8C53` | Object: Q691283. The value exceeds 16 bits, so it is a 3-WORD Reference |
| `0000` | Rank: normal |

### #4 QUALIFIER — start time 1971 {#4-qualifier--시작-시점-1971년}

```
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731
```

| WORD | Meaning |
|---|---|
| `0AB9` | Edge, Codec `0x0ABL` QUALIFIER, 10 WORDs |
| `0051 0004` | Edge Id: LOCAL 4 |
| `0191 0244` | Property: P580 (start time) |
| `0051 0003` | Target: #3 (the TRIPLE above) |
| `06E2 3139 3731` | Value: EDTF `1971` (year precision, so EDTF rather than GREGORIAN-DATE) |

The meaning of #3 is #3 itself together with every QUALIFIER that points to #3: "Q42 was educated at St John's College starting in 1971."

```
1C40
```

END. Everything up to here is 63 WORDs.

## Reading Without a Codebook {#코덱북-없이-읽으면}

A decoder that does not know the codebook still knows the following.

- The document is 63 WORDs, with 2 Meta in the HEAD and 4 Edges in the BODY.
- The Codec of each Edge (LABEL, TRIPLE, TRIPLE, QUALIFIER) and the Edge Id (1, 2, 3, 4).
- The position of the next record for every record.

The roles of the components (Predicate, Subject, Object, Rank) are known only by reading the [specification document](codec-spec.md) of each Codec.

## Content Hash {#내용-해시}

The content hash (SHA-256) of this document is as follows. When published, this hash is recorded in the version list together with the version ID.

```
0x561C157203D51AF8C754D53E20AD190F17E73ACDC4235BA47C87F608C946737F
```
