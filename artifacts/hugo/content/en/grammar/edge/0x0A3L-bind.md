---
title: "BIND (0x0A3L)"
weight: 163
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "BIND is a statement Edge that binds to Subject a name that machines match against."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `BIND` (specification document BIND `BIND`) |
| TAG ID | `0x0A3L` |
| Codec ID | `0x00000A30` |
| Specification document | `0x00000000/codecs/0x00000A30/` (DECLARE target `0A30`) |
| Section | 5 `0101` (Edge statement), offset within section C = 3 |
| Kind | Edge · family: statement, group: pointing and names |
| TAG WORD | `0000 1010 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Binds to Subject a name (`UTF8-TEXT-*`) that machines match against. It must be unique within its scope and match exactly, and has no language |
| Hugo side | `edge/bind.md` |

## Fields (specification document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec specification document](../codec-spec.md)). The Edge Id of an Edge is not declared as a FIELD.

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | record | Any record (excluding slot markers) |  |
| 2 | `name` | #3 | record | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD |  |

BIND is a statement Edge that binds to Subject a name that machines match against. Codec `0x0A3L`.

It is naming. The human-readable name (a per-language title) is the job of [LABEL](0x0A4L-label.md). The name of a program symbol and the domain name in the Issuer list are written with the same record.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0011 LLLL
[Length extension TAG]
Edge Id           LOCAL Reference record
Subject           1 Reference record, or 1 codec TAG WORD
Name              1 UTF8-TEXT-* Value
```

## Interpretation and validity {#해석과-유효성}

- Subject is exactly one complete [Reference](../reference/_index.md) record. If LOCAL, it is a target in this document (a symbol, etc.); if a pointing Reference, it is a target in another document. The document itself is [DOC-POINTER](../reference/0x041L-doc-pointer.md), and the Issuer itself is [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md).
- Alternatively, Subject is a single codec TAG WORD (Kind and Codec only, `LLLL = 0`, no Payload). This is not a record with an empty Payload; it points to that direct code itself, that is, to its specification document (GEUL Issuer codec `0x0000<TAG>`) ([Codec specification document](../codec-spec.md), [DECLARE](0x0BBL-declare.md)). Example: `0B80` is PUBLICATION. An Issuer-form codec is not pointed to in this form.
- No other record (a Value, etc.) can be Subject. The FIELD in the BIND specification document declares Subject only as width `0` (record), so this constraint is a rule of the BIND body.
- The name is exactly one [UTF8-TEXT](../value/0x072L-utf8-text.md) Value. It has no language and is not normalized. Names are the same only if their bytes are the same.
- The scope of a name is the document containing the BIND. Within one document, the same name is not bound to different Subjects.
- Several names may be bound to one Subject (aliases, former names). Unless the document says otherwise, the last BIND is the representative name.
- Other records point to a target by LOCAL ID, not by name. Names are used to match the outside (host functions, address input, people).
- The characters usable in a name are set by its use. A domain name in the Issuer list follows domain rules (lowercase, IDNA) ([publication addresses and version list](../publishing.md#issuer-목록)).
- A version list does not hold BIND. There is no document-name address ([publication addresses and version list](../publishing.md#문서-이름)).

## Length {#길이}

```
total = 1 + N_len + N_id + N_subject + N_name WORD
```

## Example (non-normative) {#예시-비규범}

Program symbol: Edge Id `0003`, Subject LOCAL 7, name `main`.

- The name `main` is 4 bytes (even), so `0722 6D61 696E` is 3 WORDs.
- The Edge is TAG 1 + Edge Id 2 + Subject 2 + name 3 = 8 WORDs, TAG `0A37`.

```
0A37 0051 0003 0051 0007 0722 6D61 696E
```

## Related pages {#관련-페이지}

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [publication addresses and version list](../publishing.md#issuer-목록) (domain names in the Issuer list)
- [LOCAL](../reference/0x005L-local.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md), [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md)

## Specification document source {#규격-문서-원문}

This is the specification document `0x00000000/codecs/0x00000A30/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A3000000000
BODY
#1 DECLARE 0x0A30
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "BIND"
#5 BIND #2 "subject"
#6 BIND #3 "name"
#7 CODEC #3 0x0720
#8 CODEC #3 0x0730
```
