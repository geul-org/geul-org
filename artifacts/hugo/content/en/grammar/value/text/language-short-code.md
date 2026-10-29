---
title: "LANGUAGE-SHORT-CODE"
weight: 73
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE is a GEUL language code Value that compresses only the primary language subtag into 1 WORD (Codec 0x48)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-SHORT-CODE is a GEUL compressed language code that holds only the primary language subtag, not the full BCP 47 tag. The Payload is exactly 1 WORD.

## Layout

- Code: Value direct code `0x48`. Family TEXT.
- The Payload is exactly one WORD, an unsigned 16-bit code.

```
TAG WORD          0x08C8 (0000 1000 1100 1000)  2 WORD in total
Payload WORD 1st (16 bits)           GEUL language code (uint16)
```

## Interpretation and Validity

- The 1 Payload WORD is read as an unsigned 16-bit integer.
- This value is a compressed code of the primary language subtag. It does not hold script, region, variant, extension, or private-use. If such information is needed, use [LANGUAGE-BCP47-CODE](/grammar/value/text/language-bcp47-code/) (`0x46`, `0x47`).
- `0x0000..0xfffe` is the assignment range of the GEUL Language Registry. Even within this range, a value not actually assigned in that registry version is invalid.
- The initial assignment targets are the public records of `Type: language` in a specific IANA Language Subtag Registry snapshot, excluding `Scope: private-use`. Collections, macrolanguages, and special are not excluded.
- The initial assignment sorts those public records in ASCII subtag order and gives them IDs. The physical order of the IANA file is not an ID rule.
- New `Type: language` subtags added later are appended at the end without changing existing numbers (append-only).
- The ID of a deprecated language subtag is neither deleted nor reused. The Preferred-Value relation and the deprecated state are preserved as registry metadata.
- `0xffff` is reserved as an extension escape. Until an extension format is defined separately, it is invalid in a standalone LANGUAGE-SHORT-CODE Value. It is not used to mean `null`, `unknown`, `und`, and the like.
- Another Codec spec may in future define interpretation rules after `0xffff`. But that does not mean those rules lengthen the Payload of this format or allow a trailing Payload.
- A Codec spec may hold the same 1 WORD code in a raw-value field with no TAG (a [CODEC](/grammar/codec-spec/#codec) on a raw-value field). That is a rule of that Codec spec, and the wire form of a standalone Value is always TAG 1 WORD + Payload 1 WORD.
- To judge the meaning of a value, the GEUL Language Registry version used and the date of the IANA registry snapshot that version pins must be preserved together.

## Standards Basis

- The source registry of primary language subtags and the deprecated/Preferred-Value metadata follow the [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- The basic meaning of the BCP 47 language subtag system follows [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- ASCII-sorted append-only ID assignment, the `0xffff` reservation, and the distinction from TAG-less embedding in a raw-value field are GEUL rules.

## Length

- The total is exactly 2 WORDs, the TAG 1 WORD plus the Payload 1 WORD, using the direct length `LLLL=0001`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 1 WORD, reject.

## Example

- The registry snapshot and the actual code table are not yet decided, so no numeric ID example for a specific language is given.

## Open Questions

- The initial IANA snapshot date, the GEUL Language Registry version name, and the full mapping table. Until they are decided, concrete numeric examples and the code table are not fixed.
