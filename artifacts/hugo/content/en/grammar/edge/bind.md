---
title: "BIND"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "BIND is a description Edge that binds a machine-matched name (a language-less UTF8-TEXT) to the Subject (Codec 0x03)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIND is a description Edge that binds a name that machines match against to a Subject. Codec `0x03`.

It is naming. The human-readable name (a per-language title) is handled by [LABEL](/grammar/edge/label/). The name of a program symbol and the name for addressing a document are written with the same record.

## Layout

```
TAG WORD          0001 0LLL L000 0011
[Length extension TAG]
Edge Id           LOCAL Reference record
Subject           one Reference record, or a codec TAG WORD (1 WORD)
Name              one UTF8-TEXT-* Value
```

## Interpretation and Validity

- Subject is exactly one complete [Reference](/grammar/reference/) record. If it is a LOCAL, it is a target of this document (a symbol and so on); if a pointer Reference, it is a target of another document. A document itself is a [DOC-POINTER](/grammar/reference/doc-pointer/), and an Issuer itself is an [ISSUER-POINTER](/grammar/reference/issuer-pointer/).
- Alternatively, Subject is one codec TAG WORD (only Kind and Codec, `LLLL = 0`, no Payload). This is not a record with an empty Payload but the direct code itself, that is, it points to its specification document (the GEUL Issuer document `0x000000000000<TAG>`) ([Codec specification document](/grammar/codec-spec/), [DECLARE](/grammar/edge/declare/)). For example, `1018` is PUBLICATION. A name index uses a DOC-POINTER Subject. Issuer-format codecs are not used.
- Other records (Value and so on) cannot be Subject. The FIELD in the BIND specification document declares Subject only with width `0` (record), so this restriction is a rule of the BIND body.
- The name is exactly one [UTF8-TEXT](/grammar/value/text/utf8-text/) Value. It has no language and is not normalized. Names are the same only if the bytes are the same.
- The scope of a name is the document that holds the BIND. The same name is not bound to different Subjects in one document.
- Several names can be bound to one Subject (aliases, old names). Unless the document says otherwise, the last BIND is the representative name.
- Other records point to a target by LOCAL ID, not by name. A name is used to match the outside (host functions, address input, people).
- The characters usable in a name are set by its use. A name for addressing a document follows the document name rules (lowercase ASCII slug) ([Publication Addresses and Version Lists](/grammar/publishing/#document-names)).

## Length

```
total = 1 + N_len + N_id + N_subject + N_name WORDs
```

## Examples (non-normative)

A program symbol: Edge Id `0003`, Subject LOCAL 7, name `main`.

- The name `main` is 4 bytes (even), so it is 3 WORDs `0940 6d61 696e`.
- The Edge is TAG 1 + Edge Id 2 + Subject 2 + name 3 = 8 WORDs, TAG `1383`.

```
1383 0088 0003 0088 0007 0940 6d61 696e
```

A document name (inside the version list document of that document, `0x0000/0xffff000000000002/versions.geul`): Edge Id `0005`, Subject `DOC-POINTER` (Issuer `0x0000`, document `0xffff000000000002`, version `0` = the document itself), name `this-is-sample-doc`.

- Subject is TAG `03B8` + Issuer 1 + document ID 4 + version ID 2 = 8 WORDs.
- The name is 18 bytes (even), so TAG `0CC0` + 9 WORDs = 10 WORDs.
- The Edge is TAG 1 + Length extension 1 + Edge Id 2 + Subject 8 + name 10 = 22 WORDs, so `LLLL=1110`, TAG `1703`, extension `0016`.

```
1703 0016 0088 0005 03B8 0000 ffff 0000 0000 0002 0000 0000 0CC0 7468 6973 2d69 732d 7361 6d70 6c65 2d64 6f63
```

## Related Pages

- [Edge](/grammar/edge/), [LABEL](/grammar/edge/label/), [PUBLICATION](/grammar/edge/publication/) (document names in the version list document)
- [LOCAL](/grammar/reference/local/), [DOC-POINTER](/grammar/reference/doc-pointer/), [ISSUER-POINTER](/grammar/reference/issuer-pointer/)
