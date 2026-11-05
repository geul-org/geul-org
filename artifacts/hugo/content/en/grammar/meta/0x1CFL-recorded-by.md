---
title: "RECORDED-BY (0x1CFL)"
weight: 463
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "Records who recorded the document (git committer)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `RECORDED-BY` (spec document BIND `RECORDED-BY`) |
| TAG ID | `0x1CFL` |
| Codec ID | `0x00001CF0` |
| Spec document | `0x00000000/codecs/0x00001CF0/` (DECLARE target `1CF0`) |
| Section | 14 `1110` (Meta), offset within section C = 15 |
| Kind | Meta · class: provenance |
| TAG WORD | `0001 1100 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | The recorder. Reference (git committer) |
| Hugo side | `meta/provenance/recorded-by.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `actor` | #2 | record | any record (except slot markers) |  |

Records who recorded the document (git committer).

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1111 LLLL      Codec 0x1CFL
[Length extension TAG]
Payload           One Reference record (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL, etc.)
```

- Codec: Meta `0x1CFL`, provenance class
- Payload: embedded Reference
- Count: at most one

## Interpretation and validity {#해석과-유효성}

- The Reference is not restricted by Codec. It can be a person, an organization, a model, or a rule engine ([EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md), [GEUL](../reference/0x00AL-geul.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md), [LOCAL](../reference/0x005L-local.md), etc.).
- Documents published on geul.org carry no Reference that points at a natural person ([Issuer and publication](../issuer.md#geulorg-공표)). They point at an organization or Issuer. As an exception, pointing at a natural person with [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) is allowed.
- If it is a LOCAL, describe that target in the BODY.

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001CF0/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CF000000000
BODY
#1 DECLARE 0x1CF0
#2 FIELD #1 record
#3 BIND #1 "RECORDED-BY"
#4 BIND #2 "actor"
```
