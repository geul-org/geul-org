---
title: "LANGUAGE-BCP47-CODE"
weight: 71
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-BCP47-CODE is a Value that holds a complete BCP 47 language tag as an ASCII byte sequence. It uses the even-odd byte code pair 0x46/0x47."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-BCP47-CODE is a Value that holds a complete BCP 47 language tag. It is used when the language must be written exactly, down to script, region, and variant.

## Layout

- Code: Value direct codes `0x46` (even bytes) and `0x47` (odd bytes). Family TEXT.
- The byte count is set by the lowest bit of the Codec and the Payload WORD count. It is `2 × Payload WORD count − lowest bit`, and no Byte Count is placed ([Value](/grammar/value/)).
- The Payload is not UTF-8 text but the ASCII byte sequence of a BCP 47 tag.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x46/0x47
[Length extension TAG] when the total is 15 WORD or more
Payload WORD 1st ... Nth          BCP 47 tag bytes / final zero padding
```

## Interpretation and Validity

- The byte sequence must be a well-formed BCP 47 language tag of RFC 5646. An empty string is not allowed.
- The Payload uses only ASCII letters, digits, and the hyphen-minus `-`. The separator must be ASCII `-`; `_`, spaces, and non-ASCII characters are not allowed.
- Comparison of BCP 47 tags is case-insensitive. The GEUL canonical profile writes all separators as `-` and serializes language, extlang, variant, extension, and private-use subtags in lowercase, script in Titlecase, and region in uppercase.
- Being well-formed alone is not enough. The validity of registered subtags and grandfathered tags is judged against a specific IANA Language Subtag Registry snapshot, and the date of that snapshot or the registry version must be preserved with it.
- A private-use tag and private-use subtags are allowed if well-formed under the RFC 5646 grammar. However, their meaning depends on agreement between the parties and is not defined by the IANA registry, so public interoperability is not guaranteed.
- If a deprecated subtag or grandfathered tag has a Preferred-Value in the same snapshot, the canonical GEUL form writes that replacement in canonical casing. A tag in the deprecated notation can be interpreted as input but is not a canonical stored form.
- BCP 47 is an ASCII profile, so Unicode normalization requirements such as UTF-8 NFC do not apply.
- Within a WORD, the upper byte comes first. If the byte count is odd (odd code), the unused lower byte of the last WORD must be `00`.
- The Payload WORD count is `ceil(byte count/2)`. If it is an odd code but the lower byte of the last WORD is not `00`, reject.

## Standards Basis

- The language tag grammar, case-insensitive interpretation, and the deprecated/Preferred-Value concepts follow [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- The registry that decides tag validity is the [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- The even-odd code pair, zero padding, the canonical casing storage policy, and the Length calculation are GEUL framing rules.

## Length

- The total is the WORD count of the TAG 1 WORD, the Length extension TAG (if any), and the Payload. 14 WORDs or fewer use a direct length, and 15 WORDs or more use the `1110`/`1111` extended length, with the extension TAG also counted in the total ([Length](/grammar/record/)).

## Relation to LANGUAGE-SHORT-CODE

- To hold only the primary language subtag in a short form, use [LANGUAGE-SHORT-CODE](/grammar/value/text/language-short-code/).
- If script, region, variant, extension, or private-use is needed, use LANGUAGE-BCP47-CODE.
- Use LANGUAGE-BCP47-CODE also for a language not yet assigned in the LANGUAGE-SHORT-CODE registry, when the `0xffff` escape would be needed, and when the original of the full tag must be preserved.

## Example

- `ko-KR` is 5 ASCII bytes (odd), so it is `LANGUAGE-BCP47-CODE-ODD` (`0x47`), and the Payload is `6b6f 2d4b 5200`.
- TAG 1 WORD and Payload 3 WORD make 4 WORD in total, with `LLLL=0011`. The whole is `09C7 6b6f 2d4b 5200`.
