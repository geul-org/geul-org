---
title: "TRANSFORMED-BY"
weight: 52
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "TRANSFORMED-BY is a lineage Meta that records the tool that converted another representation into this document, and the source version of that tool (commit digest)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Records how another representation was converted into this document (for example, a Wikidata converter or a natural-language encoder). Tool is what it was converted with, and Version is which source of that tool it was converted with. With both, the same document can be rebuilt from the same input.

## Layout

```
TAG WORD          0001 1LLL L011 0011      Codec 0x33
[Length extension TAG]
Tool              one Reference record (conversion tool or rule)
Version           one Value record (SHA-256-DIGEST or SHA1-DIGEST)
```

- Codec: Meta `0x33`, lineage class (`011`)
- Payload: embedded Reference (tool) + embedded Value (source version digest)
- Count: several allowed (one per tool)

## Interpretation and Validity

- Tool is exactly one complete Reference record. Any Reference that points to a tool can be used.
  - A tool in a geul.org tool document: [EXTERNAL-ISSUER](/grammar/reference/external-issuer/) (`0x0000`, document ID `0x0001xxxx xxxxxxxx`, its LOCAL). One document per tool ([Issuer](/grammar/issuer/) term definition document).
  - If the codec is a GEUL document, point to that document with a [DOC-POINTER](/grammar/reference/doc-pointer/).
- Version is exactly one complete Value record and is the version-control object ID of the Tool's source. For git, it is the full commit object ID.
  - If the object format of the git repository is SHA-256, it is [SHA-256-DIGEST](/grammar/value/binary/sha-256-digest/) (`0x61`, 16 WORD); if SHA-1, it is [SHA1-DIGEST](/grammar/value/binary/sha1-digest/) (`0x62`, 10 WORD). Check the repository format with `git rev-parse --show-object-format`.
  - An abbreviated ID (such as `2bd496f`) is not used. A digest Value does not allow a truncated value.
  - It is not written as hex text (UTF8-TEXT). The same value takes 22 WORDs in SHA-1 (11 as binary) and 34 WORDs in SHA-256 (18 as binary).
- Version is required. A tool record whose source version is unknown cannot be the basis of reproduction. For a tool outside version control, use the SHA-256 of the distributed artifact (SHA-256-DIGEST).
- Version points to committed source. For a document made from a working tree with uncommitted changes, that commit ID is not used (it is recommended that the tool refuse to run).
- If the tool relies on code outside the repository (for example, a local library pointed to by a Go `replace`), that code is also written separately with TRANSFORMED-BY. The tool's commit ID alone does not fix that code.
- A tool that only carries the source over losslessly (for example, a tool that loads a dump verbatim into a DB) does not decide the document content, so it is not written. A load that is not lossless changes the document, so it is written as a tool.
- The geul.org specification document (`0x1833`) writes it with two record fields: Tool (width 0, any Reference so no CODEC) and Version (width 0, [CODEC](/grammar/edge/codec/) `0861`, `0862`).

## Length

```
total = 1 + N_len + N_tool + N_version WORDs
```

- The cursor after reading all the last record must match the end of the Meta exactly.
- If Tool is EXTERNAL-ISSUER-1WORD (7 WORDs) and Version is SHA1-DIGEST (11 WORDs), the total is 1 + 1 + 7 + 11 = 20 WORDs, so the extended length is used. With SHA-256-DIGEST (18 WORDs) it is 27 WORDs.

## Example

A non-normative example. The tool is LOCAL 2 of the geul.org tool document `0x0001000000000001` (`0360 0000 0001 0000 0000 0001 0002`), and the source is commit `ddc0719974a32aaa7b422ee84221a9721085ce4c` (SHA-1).

```
1F33 0014
0360 0000 0001 0000 0000 0001 0002
0D62 ddc0 7199 74a3 2aaa 7b42 2ee8 4221 a972 1085 ce4c
```

## Open Questions

- Whether to change the version of [GENERATED-BY](/grammar/meta/lineage/generated-by/) the same way (a required digest or another format). A model version is not a commit ID.

## Related Pages

- [Meta](/grammar/meta/), [GENERATED-BY](/grammar/meta/lineage/generated-by/), [DERIVED-FROM](/grammar/meta/lineage/derived-from/)
- [EXTERNAL-ISSUER](/grammar/reference/external-issuer/), [DOC-POINTER](/grammar/reference/doc-pointer/), [SHA-256-DIGEST](/grammar/value/binary/sha-256-digest/), [SHA1-DIGEST](/grammar/value/binary/sha1-digest/), [CODEC](/grammar/edge/codec/)
