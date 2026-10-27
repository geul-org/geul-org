---
title: "Publication Addresses and Version Lists"
weight: 85
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "A published GEUL document is served at a fixed address determined by its ID (Issuer, document ID, version ID) and verified by a version list signed by the publisher. This page sets ID notation, addresses, format specification, name indexes, version lists, and trust layers."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL points to a document not by a string URL but by an ID (Issuer, document ID, version ID). The address is determined from the ID. This page sets the publication rules that encoders, decoders, and resolvers need in order to work together. Issuer tiers and disclosure methods are set by [Issuer and Publication](/grammar/issuer/).

## ID Notation

IDs used in addresses are written in hex.

- The prefix is lowercase `0x`, and the hex digits are lowercase too.
- The number of digits is fixed at width × 4. Leading zeros are not omitted, and the digit count is the width.
- An Issuer ID is written in the shortest width that fits the value. There is no widened notation such as `0x00000005` (write `0x0005`).

| Subject | Width | Digits | Example |
|---|---|---|---|
| Issuer | 1 WORD | 4 | `0x0001` |
| Issuer | 2 WORD | 8 | `0x00010000` |
| Issuer | 4 WORD | 16 | `0x0000000100000000` |
| Issuer | 16 WORD | 64 | `0x` + 64 digits |
| Document ID | 4 WORD | 16 | `0x0000000000000000` |
| Version ID | 2 WORD | 8 | `0x00000003` |
| Content hash | 16 WORD | 64 | `0x` + 64 digits |

- A request that is not in canonical form (`0X`, uppercase, omitted zeros) is redirected with `301` to the canonical address. This fixes a single cache key and signing target.
- The rules for version IDs (start from 1, `0` is latest, assigned by the publisher, a new document ID when used up) are set by [Document](/grammar/document/#versions).

## Publication Addresses

```
/.well-known/geul/<Issuer>/<document ID>.geul              Latest version. Sends to the canonical address with 302 (mutable)
/.well-known/geul/<Issuer>/<document ID>/<version ID>.geul    One whole document (immutable, canonical address)
/.well-known/geul/<Issuer>/<document ID>/versions.geul     Version list document (mutable, signed)
/.well-known/geul/h/<content hash>.geul                   Lookup by content hash (immutable)
```

Example: `/.well-known/geul/0x0001/0x0000000000000000.geul`

- The path follows `.well-known` from RFC 8615. geul.org and private publication use the same path and differ only in domain. The only suffix to register is `geul`.
- Document content is served only from immutable addresses. The latest-version address gives no content; it sends to the canonical address of that version with `302`.
- The canonical address of a version is `/<Issuer>/<document ID>/<version ID>.geul`. Other addresses that serve the same content point to the canonical address with `Link: rel=canonical`.
- Immutable addresses can be kept in permanent caches and CDNs. The receiver verifies them with the content hash in the version list (or the lock record).
- An ID always starts with `0x`. So reserved names (`h`, `keys`, `issuers.geul`, `documents.geul`, `versions.geul`) and human-assigned names never collide with an ID, even words made only of hex such as `add` or `cafe`.
- Location (which server it is fetched from) is not put into the document content. If it were, the content hash would change when the address changes. Location is set by the configuration of the party receiving the document.

### Format Specification

- A file extension specifies the format. `.geul` is binary (`application/vnd.geul`).
- Without an extension, the `Accept` header decides. Browsers get an HTML view, and tools get the binary. Example: `/<Issuer>/<document ID>/<version ID>`
- The binary is the canonical form of a document. The content hash and signatures are calculated only from the binary.

### Domain Names

An Issuer that has passed domain ownership proof can use that domain in place of the ID in the `<Issuer>` position of the address.

```
/.well-known/geul/<domain>/<document ID>.geul              → 302 → /<Issuer>/<document ID>.geul
/.well-known/geul/<domain>/<document ID>/<version ID>.geul    → 302 → /<Issuer>/<document ID>/<version ID>.geul
/.well-known/geul/<domain>/<document ID>/                  → 302 → /<Issuer>/<document ID>/
```

Example: `/.well-known/geul/geul.org/0x0000000000001018/0x00000001.geul`

- A domain address gives no content; it sends to the ID address with `302`. The canonical address, cache key, and signing target are the ID address. Since the correspondence can change, a permanent redirect is not used.
- Domains are written in lowercase, and internationalized domains are written in IDNA (punycode) form. No trailing `.` is added. If not in canonical form, it is redirected to the canonical form with `301`.
- A domain contains `.`, so it never collides with an ID starting with `0x` or with a reserved name.
- When a resolver receives a domain address, it checks the correspondence with the Issuer name index, converts it to an ID, and records it in the lock record.
- 16 WORD Issuers, which have no registry, and air-gapped environments that cannot reach geul.org cannot use domain names. They use the ID address.

### Issuer Names

The Issuer name index is a single document, `/.well-known/geul/issuers.geul`.

```
BODY
  BIND   Subject = ISSUER-POINTER(Issuer)   name = "geul.org"
  …
```

- The Subject is [ISSUER-POINTER](/grammar/reference/issuer-pointer/) (the Issuer itself), and the name is bound with [BIND](/grammar/edge/bind/).
- The name is a domain that has passed domain ownership proof. It is lowercase, and internationalized domains are written in IDNA (punycode). One name is bound to only one Issuer.
- A human-readable display name of the Issuer (per language) is attached to the same Subject with a descriptive [LABEL](/grammar/edge/label/).
- It is signed by geul.org (the GEUL Issuer), and changes are appended, never edited (the same chain rule as version lists).
- The reserved name `issuers.geul` contains `.`, so it looks like a domain. Even if a domain with the same name appears, this path remains the Issuer name index.

### Document Names

An address can also use a document name instead of a document ID. In the `<Issuer>` position, use an ID or a domain name.

```
/.well-known/geul/<Issuer|domain>/<document name>.geul              → 302 → /<Issuer>/<document ID>.geul
/.well-known/geul/<Issuer|domain>/<document name>/<version ID>.geul    → 302 → /<Issuer>/<document ID>/<version ID>.geul
/.well-known/geul/<Issuer|domain>/<document name>/                  → 302 → /<Issuer>/<document ID>/
```

Example: `/.well-known/geul/geul.org/publication/0x00000001.geul` → `/0x0000/0x0000000000001018/0x00000001.geul`

**Document names are bound by the Issuer's name index `/<Issuer>/documents.geul` using BIND.** A resolver maps a name to a document ID with this index.

```
BODY
  BIND   Subject = DOC-POINTER(Issuer, document ID, version 0)   name = "publication"
  …
```

- The Subject is a [DOC-POINTER](/grammar/reference/doc-pointer/) (Issuer, document ID, version `0`). The name is bound to the document, not to a version.
- The Issuer of the Subject must equal the Issuer that holds the index. Documents of other Issuers are ignored.
- A name is bound only to a published document.
- A document name is a lowercase ASCII slug: `a-z`, `0-9`, `-`. It does not begin or end with `-`, and does not start with `0x`. So it never collides with a document ID (`0x…`) or a reserved name (`h`, `versions.geul`, and so on) ([BIND](/grammar/edge/bind/)).
- Within one Issuer, a name is bound to only one document, and a name once bound is not reused for another document. To rename, append a new BIND. The old name continues to point to the same document. If the same name appears several times, the last BIND is the representative.
- A document does not write its own name inside. The canonical address, cache key, and signing target are the ID address. IMPORT and citations inside documents use IDs only.
- A human-readable title (per language) is not a name. Attach it with a descriptive `LABEL`.
- A version list document can also hold the same document name BIND ([PUBLICATION](/grammar/edge/publication/#document-names)). If it does, it must match the name index. A resolver reads only the name index.

### Deleted Documents

- The address of a version deleted by legal deletion or deletion by authority returns `410 Gone` and a tombstone (version ID, content hash, deletion date, reason category).
- It remains in the version list as a [TOMBSTONE](/grammar/edge/publication/) record.

## Layers

GEUL expresses even provenance, meta, and lists as GEUL documents. The minimum needed to read them is built into the decoder, which breaks the circularity. Each layer relies only on the layers below it.

| Layer | Contents | Relies on |
|---|---|---|
| Layer 0 | Rules built into the decoder: framing, content hash, signature verification, the version list record Codecs (`PUBLICATION`, `DEPRECATION`, `TOMBSTONE`), the Codec specification vocabulary (`DECLARE`, `FIELD`, `ENUM`, `CODEC`), the [slot marker](/grammar/reference/slot-marker/) (`0x0000` to `0x0002`), and trust keys received from outside the document | Nothing. No lookup |
| Layer 1 | Version list documents | Layer 0 |
| Layer 2 | Ordinary documents, codebooks, Codec specification documents, Issuer verification key documents | Found through Layer 1 and verified with Layer 0 |

- No layer relies on its own layer or one above.
- We distinguish what is expressed in GEUL from what can be read only by interpreting GEUL. Layer 0 can be expressed in GEUL, but interpreting it needs no lookup.
- Fixed cores that cannot be turned into TOULMIN documents, such as the meaning of a judgment, are also placed here ([TOULMIN](/grammar/edge/toulmin/#metacognition-and-self-revision)).

## Version Lists

For each document, the publisher keeps appending one version list document (`/<Issuer>/<document ID>/versions.geul`). The record format and document structure are set by [PUBLICATION](/grammar/edge/publication/).

```
DOC-*
  SPEC-VERSION
  PARENT          content hash of the previous list document
  RECORDED-AT     time this list was issued
  NEXT-LOCAL-ID   next LOCAL ID to assign
  SIGNATURE       the publisher's signature
BODY
  PUBLICATION     #1  document@1  content hash
  PUBLICATION     #2  document@2  content hash
  DEPRECATION     #3  document@1
  …
END
```

| Edge | Meaning |
|---|---|
| PUBLICATION | Publishes one version of a document and its content hash |
| DEPRECATION | Marks a published version with a deprecation notice. It is still interpreted |
| TOMBSTONE | Deletes a published version (legal or by-authority deletion). Records a reason category |

- Records are only appended. They are never edited, deleted, or reordered. Deprecation and deletion also append records. A new list keeps the BODY of the previous list unchanged at the front and appends records, and the lists are linked by a `PARENT` hash chain.
- This means the publication record is not edited, and it is different from the revision of document content ([Document](/grammar/document/#revisions)). The current state of a version is calculated by applying the records in order.
- Version IDs are in ascending order from 1 with no gaps. The same content is not published again.
- The latest version is the highest version that is neither deprecated nor deleted.
- Records carry no time. The `RECORDED-AT` of the list in which the record first appeared is the publication time.
- A list document has no `DOC-ID`. The document ID in the records says what it is a list of.
- A list document has no IMPORT and uses only Layer 0 Codecs.
- A list document is not placed on another list (no list of lists). Past lists are pointed to only by content hash (`h/<content hash>.geul`), and history is linked by the `PARENT` chain.
- The only mutable address is the latest list address (`/<Issuer>/<document ID>/versions.geul`). A mutable pointer cannot be made into a document, so it is verified with the received list's signature, `RECORDED-AT`, and `PARENT`.

### Signing Parties

| Signature | Party | Target |
|---|---|---|
| Document signature | The document's Issuer | The document's content hash ([Issuer and Publication](/grammar/issuer/#signatures)) |
| List signature | The publisher that assigned the version IDs | The content hash of the list document |

- For geul.org publication, geul.org (the GEUL Issuer) assigns version IDs and signs the list; for private publication, the Issuer does.
- The author is responsible for the content, and the publisher for numbers and order.

### Verification

- A signature is left out of the content hash, so the hash stays the same if it is removed. Therefore verification is not "check the signature if there is one" but "a signature by the designated key must be present". The keys to require are set by the resolver's trust settings and the lock record.
- A resolver records the content hash of the last list it saw in the lock record. If that hash is not in the `PARENT` chain of a newly received list, it rejects it (preventing rewind and forks).
- Mirrors and air-gapped environments copy the chain of list documents together. With just the public key, verification works offline.
- A received document is verified by its content hash whatever its source. The source does not need to be trusted.

## Dependency Resolution

- A document lists the documents it depends on with [IMPORT-DOC](/grammar/meta/import/import-doc/) in its HEAD.
- A new version does not promise compatibility with earlier versions. So the versions of a document are not merged into one across the whole graph (minimal version selection is not used).
- Each `IMPORT-DOC` is bound to the edition it pinned. Several editions of the same document can be in one graph together (a judgment citing the old law and a judgment citing the current law). References are resolved by (document, version, LOCAL ID).
- A latest (version `0`) import is bound to the latest edition at the time of interpretation. If interpreted at a given point in time, it is bound to the edition in force at that time ([Document](/grammar/document/#revisions)).
- An import pinned by version ID is reproducible (the content of a version ID is immutable and verified with the lock record).

## Media Type

- The media type of a GEUL document is `application/vnd.geul`. The extension is `.geul`.
- Even if it moves to the standards tree `application/geul`, `application/vnd.geul` continues to be accepted.

## Open Questions

- How far geul.org serves documents of 1, 2, 4, and 16 WORD Issuers directly, and from where it sends to the registry's address. The status codes at that point (canonical 308, latest 302 or 307).
- Handling when version IDs diverge (the same version ID with different content) in private publication, 16 WORD Issuers, and air-gapped environments.
- The definition of a text representation and content negotiation (binary, text, or HTML view depending on `Accept`).
- The relation between the document name index `documents.geul` and the version list BIND (whether to merge them into one), and signing of the index.
- The HEAD composition and signature and chain format of `issuers.geul`. Name rules for Issuers without a domain (1 and 4 WORD), handling of name disputes, and a length limit.
- Whether 1 WORD Issuers can optionally pass domain proof and use domain names.
- The point and format for moving to a Merkle log (inclusion and consistency proofs) instead of the full chain when lists get large.
- A Meta that writes the location-providing Issuer in the HEAD.
