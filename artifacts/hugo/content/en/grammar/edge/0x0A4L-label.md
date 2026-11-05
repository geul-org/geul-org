---
title: "LABEL (0x0A4L)"
weight: 164
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "LABEL is a statement Edge that connects, as Object, one name (label) in a particular language for the target of Subject."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `LABEL` (specification document BIND `LABEL`) |
| TAG ID | `0x0A4L` |
| Codec ID | `0x00000A40` |
| Specification document | `0x00000000/codecs/0x00000A40/` (DECLARE target `0A40`) |
| Section | 5 `0101` (Edge statement), offset within section C = 4 |
| Kind | Edge · family: statement, group: pointing and names |
| TAG WORD | `0000 1010 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Connects a language name (label) of Subject. Object is UTF8-LANGUAGE-TEXT |
| Hugo side | `edge/label.md` |

## Fields (specification document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec specification document](../codec-spec.md)). The Edge Id of an Edge is not declared as a FIELD.

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | record | Any record (excluding slot markers) |  |
| 2 | `object` | #3 | record | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

LABEL is a statement Edge that connects, as Object, one name (label) in a particular language for the target of Subject. Codec `0x0A4L`. It is not an Edge that represents a lemma in general lexicography.

The name and its language are carried in a single Object, [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md). There is no raw-value field.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0100 LLLL
[Length extension TAG]
Edge Id           LOCAL Reference record
Subject           1 Reference record
Object            1 UTF8-LANGUAGE-TEXT Value or LOCAL Reference record
```

## Interpretation and validity {#해석과-유효성}

- Subject is exactly one complete Reference record. Its boundary is found by Subject's own Length; if it is not a Reference or is incomplete, it is invalid.
- Object is exactly one complete [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) (`0x078L`, `0x079L`) record. The rules for language and text (both language forms allowed, comparison of the same language) follow that form.
- A LOCAL Reference may also appear as Object. In that case it must resolve to a UTF8-LANGUAGE-TEXT through a [REFERENCE-NODE](0x0A0L-reference-node.md) binding in the same document. If it does not resolve, or resolves to a different kind of target, it is invalid.
- The geul.org specification document writes this restriction with [CODEC](0x0BEL-codec.md) (Object = `0780`, `0790`, `0050`). The resolution target of a LOCAL is not expressed with CODEC.
- If Object is not one of the above two forms, or the record is incomplete, it is invalid. Text without a language (UTF8-TEXT) cannot be a LABEL. A language-less machine-oriented name is written as [BIND](0x0A3L-bind.md). A name common to several languages is written with language `mul`.
- There is at most one LABEL per Subject and language. Other names are written as [ALIAS](0x0A5L-alias.md).

## Length {#길이}

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

- The language record of Object and the number of text bytes are handled by the Object record, not by the Edge. The cursor after reading the last record must coincide exactly with the end of the Edge.

## Examples (non-normative) {#예시-비규범}

The language code `0784` for `en` is a number in GEUL Language Registry v2 (specification document `0x00000000/codecs/0x000007A0`, version 2).

### LANGUAGE-SHORT-CODE {#language-short-code}

Edge Id `0007`, Subject Q22686 (`0141 589E`), Object `Donald Trump` (en).

- Object is language `07A1 0784` (SHORT-CODE, 2 WORDs) + 12 bytes of text (even, 6 WORDs), so it is `UTF8-LANGUAGE-TEXT-EVEN` (`0x078L`), 9 WORDs in total: `0788 07A1 0784 446F 6E61 6C64 2054 7275 6D70`.
- The Edge is TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORDs, `LLLL=1101`. The TAG is `0A4D`.

```
0A4D 0051 0007 0141 589E 0788 07A1 0784 446F 6E61 6C64 2054 7275 6D70
```

### LANGUAGE-BCP47-CODE {#language-bcp47-code}

Edge Id `0008`, Subject Q155 (`0141 009B`), Object `Brasil` (pt-BR).

- Object is language `0773 7074 2D42 5200` (BCP47 `pt-BR`, 4 WORDs) + 6 bytes of text (even, 3 WORDs), so it is 8 WORDs in total: `0787 0773 7074 2D42 5200 4272 6173 696C`.
- The Edge is TAG 1 + Edge Id 2 + Subject 2 + Object 8 = 13 WORDs, `LLLL=1100`. The TAG is `0A4C`.

```
0A4C 0051 0008 0141 009B 0787 0773 7074 2D42 5200 4272 6173 696C
```

## Related pages {#관련-페이지}

- [Edge](_index.md), [ALIAS](0x0A5L-alias.md), [DESCRIPTION](0x0A6L-description.md), [BIND](0x0A3L-bind.md)
- [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md), [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md), [LANGUAGE-BCP47-CODE](../value/0x076L-language-bcp47-code.md)
- [LOCAL](../reference/0x005L-local.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

## Specification document source {#규격-문서-원문}

This is the specification document `0x00000000/codecs/0x00000A40/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A4000000000
BODY
#1 DECLARE 0x0A40
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "LABEL"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
