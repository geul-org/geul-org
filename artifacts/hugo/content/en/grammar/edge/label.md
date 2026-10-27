---
title: "LABEL"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "LABEL is a description Edge that links one per-language name of the Subject target to a UTF8-LANGUAGE-TEXT Object (Codec 0x04)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LABEL is a description Edge that links one name (label) of the Subject target in a particular language as its Object. Codec `0x04`. It is not an Edge that represents a lemma in general lexicography.

The name and its language are held in one Object, [UTF8-LANGUAGE-TEXT](/grammar/value/text/utf8-language-text/). There are no raw-value fields.

## Layout

```
TAG WORD          0001 0LLL L000 0100
[Length extension TAG]
Edge Id           LOCAL Reference record
Subject           one Reference record
Object            one UTF8-LANGUAGE-TEXT Value or LOCAL Reference record
```

## Interpretation and Validity

- Subject is exactly one complete Reference record. Its boundary is found by the Length of Subject itself; if it is not a Reference or is incomplete, it is invalid.
- Object is exactly one complete [UTF8-LANGUAGE-TEXT](/grammar/value/text/utf8-language-text/) (`0x4A`, `0x4B`) record. The rules for language and text (both language formats are allowed, comparison of the same language) follow that format.
- Object can also be a LOCAL Reference. In that case it must resolve to a UTF8-LANGUAGE-TEXT through a [REFERENCE-NODE](/grammar/edge/reference-node/) binding in the same document. If it does not resolve, or resolves to another kind of target, it is invalid.
- A geul.org specification document writes this restriction with [CODEC](/grammar/edge/codec/) (Object = `084A`, `084B`, `0008`). What a LOCAL resolves to is not expressed with CODEC.
- If Object is not one of the two forms above, or the record is incomplete, it is invalid. Text with no language (UTF8-TEXT) cannot be a LABEL. A machine-oriented name with no language is written as [BIND](/grammar/edge/bind/). A name common to several languages is written with the language `mul`.
- There is at most one LABEL per Subject and language. Other names are written as [ALIAS](/grammar/edge/alias/).

## Length

```
total = 1 + N_len + N_id + N_subject + N_object WORDs
```

- The language record and the text byte count of Object are handled by the Object record, not by the Edge. The cursor after reading all of the last record must match the end of the Edge exactly.

## Examples (non-normative)

The language code registry for `en` is not yet sealed, so `0783` is a non-normative value, not a confirmed code.

### LANGUAGE-SHORT-CODE

Edge Id `0007`, Subject Q22686 (`00A0 589e`), Object `Donald Trump` (en).

- Object is the language `08C8 0783` (SHORT-CODE, 2 WORDs) + text of 12 bytes (even, 6 WORDs), so `UTF8-LANGUAGE-TEXT-EVEN` (`0x4A`), 9 WORDs in total: `0C4A 08C8 0783 446f 6e61 6c64 2054 7275 6d70`.
- The Edge is TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORDs, `LLLL=1101`. The TAG is `1684`.

```
1684 0088 0007 00A0 589e 0C4A 08C8 0783 446f 6e61 6c64 2054 7275 6d70
```

### LANGUAGE-BCP47-CODE

Edge Id `0008`, Subject Q155 (`00A0 009b`), Object `Brasil` (pt-BR).

- Object is the language `09C7 7074 2d42 5200` (BCP47 `pt-BR`, 4 WORDs) + text of 6 bytes (even, 3 WORDs), so 8 WORDs in total: `0BCA 09C7 7074 2d42 5200 4272 6173 696c`.
- The Edge is TAG 1 + Edge Id 2 + Subject 2 + Object 8 = 13 WORDs, `LLLL=1100`. The TAG is `1604`.

```
1604 0088 0008 00A0 009b 0BCA 09C7 7074 2d42 5200 4272 6173 696c
```

## Related Pages

- [Edge](/grammar/edge/), [ALIAS](/grammar/edge/alias/), [DESCRIPTION](/grammar/edge/description/), [BIND](/grammar/edge/bind/)
- [UTF8-LANGUAGE-TEXT](/grammar/value/text/utf8-language-text/), [LANGUAGE-SHORT-CODE](/grammar/value/text/language-short-code/), [LANGUAGE-BCP47-CODE](/grammar/value/text/language-bcp47-code/)
- [LOCAL](/grammar/reference/local/), [REFERENCE-NODE](/grammar/edge/reference-node/)
