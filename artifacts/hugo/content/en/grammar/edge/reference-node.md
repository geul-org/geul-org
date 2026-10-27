---
title: "REFERENCE-NODE"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "REFERENCE-NODE is a directional description Edge that binds a Reference to one Object record and defines what that Reference is (Codec 0x00)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REFERENCE-NODE is a directional description Edge that links a Reference to one Object record and defines or binds what that Reference is. Codec `0x00`.

Subject denotes Object. This binding is not [SAME-NODE](/grammar/edge/same-node/), which asserts semantic identity, and it does not mean the bytes of the two records are the same.

## Layout

```
TAG WORD          0001 0LLL L000 0000
[Length extension TAG]
Edge Id           LOCAL Reference record
Subject           one Reference record
Object            one Reference or Value record
```

## Interpretation and Validity

- Subject must be exactly one complete [Reference](/grammar/reference/) record. Its boundary is found by the Length of Subject itself; if it is not a Reference or is incomplete, it is invalid.
- Object must be exactly one complete Reference or Value record. Its boundary is found by the Length of Object itself; if it is an Edge or Meta, or is incomplete, it is invalid.
- If Object is a Reference, the Reference chain followed through REFERENCE-NODE bindings must not be circular, and a LOCAL must resolve in the end. A resolution cycle or a dangling LOCAL is invalid.
- If one LOCAL ID in a document is bound to conflicting Objects, it is invalid. The scope, ID, minimum width, and merge rules of a LOCAL follow [LOCAL](/grammar/reference/local/).
- Not every Reference has to be bound by a REFERENCE-NODE.
- The representative use is `LOCAL → UTF8-LANGUAGE-TEXT`. When a LOCAL is placed in the Object of a [LABEL](/grammar/edge/label/), this binding in the same document resolves the text.

The direction in which Subject denotes Object must not be read in reverse. The meaning and detailed rules of SAME and DIFFERENT are set separately by each format.

## Length

```
total = 1 + N_len + N_id + N_subject + N_object WORDs
```

`N_len` is the number of Length extension TAG WORDs, `N_id` is the WORD count of the Edge Id LOCAL record, and `N_subject` and `N_object` are the total WORD counts of each record. The cursor after reading both Subject and Object must match the end of the Edge exactly.

## Example (non-normative)

Edge Id `0008`, Subject is LOCAL 1, Object is the [UTF8-LANGUAGE-TEXT](/grammar/value/text/utf8-language-text/) of `Donald Trump` (en).

- The Edge Id is `0088 0008`, 2 WORDs.
- Subject is `0088 0001`, 2 WORDs.
- Object is the language `08C6 656e` (BCP47 `en`) + text of 12 bytes (even), so `UTF8-LANGUAGE-TEXT-EVEN` (`0x4A`), 9 WORDs in total. The TAG is `0C4A`.
- The Edge is TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORDs, `LLLL=1101`. The TAG is `1680`.

```
1680 0088 0008 0088 0001 0C4A 08C6 656e 446f 6e61 6c64 2054 7275 6d70
```

## Related Pages

- [Edge](/grammar/edge/), [SAME-NODE](/grammar/edge/same-node/), [DIFFERENT-NODE](/grammar/edge/different-node/), [LABEL](/grammar/edge/label/)
- [Reference](/grammar/reference/), [LOCAL](/grammar/reference/local/), [UTF8-LANGUAGE-TEXT](/grammar/value/text/utf8-language-text/)
