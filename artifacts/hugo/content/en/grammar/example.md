---
title: "Example: A Wikidata Item"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "example", "wikidata"]
summary: "A walk through, from start to finish, a 63 WORD GEUL document that holds one name, two propositions, and one qualifier for Wikidata Q42 (Douglas Adams)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Let us read a small document about the Wikidata item Q42 (Douglas Adams) from start to finish. It holds the following.

- English name: Douglas Adams
- Q42 is an instance of human (Q5) (P31).
- Q42 was educated at St John's College (Q691283) (P69). The start time (P580) is 1971.

The document has Issuer `0x00010000` and document ID `0x510000000000002a`, and it is 63 WORDs (126 bytes) in total.

## The Whole Document

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

`1880` is Meta (`11`), Length 2 WORDs, Codec `0x00` (DOC-1WORD). The value `003f` (63) is the total WORD count of the document. The decoder knows the end of the document in advance from this value.

```
1890 0001
```

Meta `0x10` SPEC-VERSION. This is the spec version the document follows. For v1 it is `0001`.

```
1c92 0438 0001 0000 5100 0000 0000 002a 0000 0000
```

Meta `0x12` DOC-ID, 10 WORDs in total. The Payload is one DOC-POINTER Reference.

| WORD | Meaning |
|---|---|
| `0438` | Reference, 9 WORDs, Codec `0111` (DOC-POINTER), Quantifier `000` |
| `0001 0000` | Issuer `0x00010000` (2 WORD) |
| `5100 0000 0000 002a` | Document ID `0x510000000000002a` |
| `0000 0000` | Version `0` (itself) |

```
180e
```

BODY. The HEAD ends and the BODY begins.

## BODY

### #1 LABEL: English name

```
1704 0010 0088 0001 00a0 002a 0ccb 08c6 656e 446f 7567 6c61 7320 4164 616d 7300
```

| WORD | Meaning |
|---|---|
| `1704` | Edge, Length `1110` (extended), Codec `0x04` LABEL |
| `0010` | Extended length: 16 WORDs in total |
| `0088 0001` | Edge Id: LOCAL 1 |
| `00a0 002a` | Subject: Wikidata Q42 |
| `0ccb` | Object: UTF8-LANGUAGE-TEXT, 10 WORDs, odd byte count (`0x4B`) |
| `08c6 656e` | Language: BCP 47 `en` |
| `446f … 7300` | `Douglas Adams` 13 bytes + padding `00` |

### #2 TRIPLE: Q42 is a human

```
148a 0088 0002 00a8 001f 00a0 002a 00a0 0005 0000
```

| WORD | Meaning |
|---|---|
| `148a` | Edge, 10 WORDs, Codec `0x0A` TRIPLE |
| `0088 0002` | Edge Id: LOCAL 2 |
| `00a8 001f` | Predicate: P31 (instance of) |
| `00a0 002a` | Subject: Q42 |
| `00a0 0005` | Object: Q5 (human) |
| `0000` | Rank: normal |

### #3 TRIPLE: Q42 was educated at St John's College

```
150a 0088 0003 00a8 0045 00a0 002a 0120 000a 8c53 0000
```

| WORD | Meaning |
|---|---|
| `150a` | Edge, 11 WORDs, TRIPLE |
| `0088 0003` | Edge Id: LOCAL 3 |
| `00a8 0045` | Predicate: P69 (educated at) |
| `00a0 002a` | Subject: Q42 |
| `0120 000a 8c53` | Object: Q691283. The value exceeds 16 bits, so it is a 3 WORD Reference |
| `0000` | Rank: normal |

### #4 QUALIFIER: start time 1971

```
148b 0088 0004 00a8 0244 0088 0003 0924 3139 3731
```

| WORD | Meaning |
|---|---|
| `148b` | Edge, 10 WORDs, Codec `0x0B` QUALIFIER |
| `0088 0004` | Edge Id: LOCAL 4 |
| `00a8 0244` | Property: P580 (start time) |
| `0088 0003` | Target: #3 (the TRIPLE above) |
| `0924 3139 3731` | Value: EDTF `1971` (year precision, so EDTF rather than GREGORIAN-DATE) |

The meaning of #3 is #3 itself together with all QUALIFIERs that point to #3: "Q42 was educated at St John's College from 1971."

```
180f
```

END. This is the end of the 63 WORDs.

## Reading Without a Codebook

A decoder that does not know the codebook still knows the following.

- The document is 63 WORDs, with 2 Meta records in the HEAD and 4 Edges in the BODY.
- The Codec of each Edge (LABEL, TRIPLE, TRIPLE, QUALIFIER) and its Edge Id (1, 2, 3, 4).
- The position of the next record for every record.

The roles of the components (Predicate, Subject, Object, Rank) can be known only by reading the [specification document](/grammar/codec-spec/) of each Codec.

## Content Hash

The content hash (SHA-256) of this document is as follows. When it is published, this hash is recorded in the version list together with the version ID.

```
0x4f05137f92de70951f581156cf90f15471c254c7e87ad1ba100bf91dd705ebc1
```
