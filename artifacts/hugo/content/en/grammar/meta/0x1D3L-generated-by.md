---
title: "GENERATED-BY (0x1D3L)"
weight: 467
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Records who or what produced the document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `GENERATED-BY` (spec document BIND `GENERATED-BY`) |
| TAG ID | `0x1D3L` |
| Codec ID | `0x00001D30` |
| Spec document | `0x00000000/codecs/0x00001D30/` (DECLARE target `1D30`) |
| Section | 14 `1110` (Meta), offset within section C = 3 |
| Kind | Meta · class: lineage |
| TAG WORD | `0001 1101 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | The generating agent. A person, a model, or a rule engine |
| Hugo side | `meta/lineage/generated-by.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `agent` | #2 | record | any record (except slot markers) |  |
| 2 | `version` | #5 | record | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0000` ABSENT (optional field) |  |

Records who or what produced the document. It can be a person, a model, or a rule engine.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0011 LLLL      Codec 0x1D3L
[Length extension TAG]
Generating agent  Reference (person, model, rule engine)
Version           UTF8-TEXT Value, or the omission marker 0x0000 (optional field)
```

- Codec: Meta `0x1D3L`, lineage class
- Payload: embedded Reference + version text (optional)
- Count: several allowed

## Interpretation and validity {#해석과-유효성}

- If it is a model, also write the model version.
- If the version is unknown or not given, omit that slot and use ABSENT (`0x0000`) ([CODEC](../edge/0x0BEL-codec.md) optional field). The geul.org spec `0x1D30` is a two-record-field spec: agent (no CODEC) and version (`0720`, `0730`, `0000`).
- For the source version (commit) of a program, the form of [TRANSFORMED-BY](0x1D4L-transformed-by.md) (digest, required) is more accurate. The version of GENERATED-BY records as text what is not a commit ID, such as a model name and version.
- Documents published on geul.org carry no Reference that points at a natural person ([Issuer and publication](../issuer.md#geulorg-공표)). They point at an organization or Issuer. As an exception, pointing at a natural person with [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) is allowed.

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001D30/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D3000000000
BODY
#1 DECLARE 0x1D30
#2 FIELD #1 record
#3 BIND #1 "GENERATED-BY"
#4 BIND #2 "agent"
#5 FIELD #1 record
#6 BIND #5 "version"
#7 CODEC #5 0x0720
#8 CODEC #5 0x0730
#9 CODEC #5 0x0000
```
