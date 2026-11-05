---
title: "TRANSFORMED-BY (0x1D4L)"
weight: 468
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Records how this document was converted from another representation (for example, a Wikidata converter, a natural-language encoder)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `TRANSFORMED-BY` (spec document BIND `TRANSFORMED-BY`) |
| TAG ID | `0x1D4L` |
| Codec ID | `0x00001D40` |
| Spec document | `0x00000000/codecs/0x00001D40/` (DECLARE target `1D40`) |
| Section | 14 `1110` (Meta), offset within section C = 4 |
| Kind | Meta · class: lineage |
| TAG WORD | `0001 1101 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Conversion method. Tool, rules, version |
| Hugo side | `meta/lineage/transformed-by.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `tool` | #2 | record | any record (except slot markers) |  |
| 2 | `version` | #3 | record | `07C0` SHA-256-DIGEST, `07D0` SHA1-DIGEST |  |

Records how this document was converted from another representation (for example, a Wikidata converter, a natural-language encoder). Tool is what it was converted with; Version is which source of that tool it was converted with. Both are needed to reproduce the same document from the same input.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0100 LLLL      Codec 0x1D4L
[Length extension TAG]
Tool              1 Reference record (conversion tool, rules)
Version           1 Value record (SHA-256-DIGEST or SHA1-DIGEST)
```

- Codec: Meta `0x1D4L`, lineage class
- Payload: embedded Reference (tool) + embedded Value (source version digest)
- Count: several allowed (one per tool)

## Interpretation and validity {#해석과-유효성}

- Tool is exactly one complete Reference record. Any Reference that points at a tool can be used.
  - A tool in a geul.org tool document: [EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md) (`0x00000000`, document ID `0x0001xxxx xxxxxxxx`, its LOCAL). One document per tool (the term-definition document of the [Issuer](../issuer.md)).
  - If the codec is a GEUL document, point at that codec document with [CODEC-POINTER](../reference/0x042L-codec-pointer.md).
- Version is exactly one complete Value record and is the version-control object ID of the Tool's source. For git, it is the full commit object ID.
  - If the git repository's object format is SHA-256, use [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md) (`0x07CL`, 16 WORD); if SHA-1, [SHA1-DIGEST](../value/0x07DL-sha1-digest.md) (`0x07DL`, 10 WORD). Check the repository format with `git rev-parse --show-object-format`.
  - Do not use abbreviated IDs (such as `2bd496f`). The digest Values do not allow truncated values.
  - Do not write it as hex text (UTF8-TEXT). The same value takes 22 WORD (11 binary) in SHA-1 and 34 WORD (18 binary) in SHA-256.
- Version is required. A tool record with an unknown source version cannot serve as a basis for reproduction. For a tool outside version control, use the SHA-256 of the distributed artifact (SHA-256-DIGEST).
- Version points at committed source. Do not write a commit ID for a document made from a working tree with uncommitted changes (it is recommended that the tool refuse to run).
- If the tool depends on code outside the repository (for example, a local library pointed at by a Go `replace`), write that code separately with TRANSFORMED-BY. The tool's commit ID alone does not fix that code.
- A tool that only carries the source over losslessly (for example, one that loads a dump into a DB verbatim) does not determine the document content, so it is not written. A non-lossless load changes the document, so write it as a tool.
- The geul.org spec document (`0x1D40`) writes this as a two-record-field spec: Tool (width 0, any Reference so no CODEC) and Version (width 0, [CODEC](../edge/0x0BEL-codec.md) `07C0`, `07D0`).

## Length {#길이}

```
Total = 1 + N_len + N_tool + N_version WORD
```

- After reading the last record, the cursor must coincide exactly with the end of the Meta.
- If Tool is EXTERNAL-ISSUER-2WORD (8 WORD) and Version is SHA1-DIGEST (11 WORD), the total is 1 + 1 + 8 + 11 = 21 WORD, using the extended length. With SHA-256-DIGEST (18 WORD) it is 28 WORD.

## Example {#예시}

A non-normative example. The tool is LOCAL 2 of the geul.org tool document `0x0001000000000001` (`02F7 0000 0000 0001 0000 0000 0001 0002`), and the source is commit `ddc0719974a32aaa7b422ee84221a9721085ce4c` (SHA-1).

```
1D4E 0015
02F7 0000 0000 0001 0000 0000 0001 0002
07DA DDC0 7199 74A3 2AAA 7B42 2EE8 4221 A972 1085 CE4C
```

## Open issues {#열린-문제}

- Whether to change the version of [GENERATED-BY](0x1D3L-generated-by.md) the same way (a required digest or another format). A model version is not a commit ID.

## Related pages {#관련-페이지}

- [Meta](_index.md), [GENERATED-BY](0x1D3L-generated-by.md), [DERIVED-FROM](0x1D2L-derived-from.md)
- [EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md), [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md), [SHA1-DIGEST](../value/0x07DL-sha1-digest.md), [CODEC](../edge/0x0BEL-codec.md)

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001D40/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D4000000000
BODY
#1 DECLARE 0x1D40
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "TRANSFORMED-BY"
#5 BIND #2 "tool"
#6 BIND #3 "version"
#7 CODEC #3 0x07C0
#8 CODEC #3 0x07D0
```
