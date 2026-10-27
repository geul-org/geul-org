---
title: "SOURCE and Sections"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "GEUL ISSUER formats 0xC000-0xC005 that write the authored source text (SOURCE), strings (TEXT), section and case divisions (SECTION, CASE-BEGIN, CASE-END), and prose paragraphs (PROSE) of a TOULMIN document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Records that write the source text and divisions of a TOULMIN document. All are Edges that use a format number under `ISSUER-1WORD` (`0x7C`), Issuer `0x0000` (GEUL) ([TOULMIN](/grammar/edge/toulmin/#issuer-formats)).

## Formats

| Format number | Name | Layout |
|---|---|---|
| `0xC000` | SOURCE | ID, SPAN width WORD, UTF8 Value |
| `0xC001` | TEXT | ID, UTF8 Value |
| `0xC002` | SECTION | ID, section code 1 WORD |
| `0xC003` | CASE-BEGIN | ID, REF (case) |
| `0xC004` | CASE-END | ID, REF (case) |
| `0xC005` | PROSE | ID, SPAN |

- ID is an Edge Id, and REF is the Edge Id of a record of this document (the common fields of [TOULMIN](/grammar/edge/toulmin/#common-fields)).
- A UTF8 Value is a [UTF8-TEXT](/grammar/value/text/utf8-text/) Value record. It holds the bytes as they are.

## SOURCE

The whole authored source text. Every SPAN is a byte range within this source text.

```
ID
SPAN width WORD  upper 2 bits = width (00=1, 01=2, 10=4, 11=8 WORD), remaining 14 bits = 0
Source text      UTF8-TEXT Value record
```

- SOURCE is the first record of the BODY. There is one per document.
- A SPAN has two fields: a start byte and a byte count. Each field is an unsigned integer of the width (1/2/4/8 WORD) set by the SPAN width WORD.

## TEXT

One name or string. It is pointed to by REF from the F_WITH and F_GROUNDS lists of NODE, and by LABEL and IMPORTED-FROM of LINK.

## SECTION

The start of a section. The section code is 1 WORD.

| Code | Section | TANGEUL |
|---|---|---|
| 1 | Subject | `this document is x` |
| 2 | See | `see a from path` |
| 3 | Definitions | `means`, `has` |
| 4 | Rules | condition-expression rules |
| 5 | Cases | `in case of x` |
| 6 | Provides | `provides x` |
| 7 | Internal | `on`, `every` |

- `0` is not used. Sections are declared in the order of these codes.
- The section title is the PROSE right after the SECTION.

## CASE-BEGIN, CASE-END

- The range of a case lies between a CASE-BEGIN and a CASE-END that point to the same case (a CASE-DECLARE NODE).

## PROSE

A prose paragraph that is not a rule. It points only to a range (SPAN) of the source text.

## Related Pages

- [TOULMIN](/grammar/edge/toulmin/), [NODE](/grammar/edge/toulmin/node/), [LINK](/grammar/edge/toulmin/link/)
