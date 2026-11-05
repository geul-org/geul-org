---
title: "Publication Addresses and Version Lists"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "GEUL points to a document not by a string URL but by an ID (Issuer, document ID, version ID)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL points to a document not by a string URL but by an ID (Issuer, document ID, version ID). The address is determined from the ID. This page sets the publication rules that encoders, decoders, and resolvers need in order to work together. Issuer grades and publication modes are set by [Issuer and Publication](issuer.md).

## ID Notation {#id-표기}

IDs used in addresses are written in hex.

- The prefix is lowercase `0x`. Hexadecimal is written with uppercase A-F. A resolver also converts an address written in lowercase to uppercase before lookup.
- The digit count is fixed at width × 4. Leading zeros are not omitted, and the digit count is the width.
- When writing an address, the Issuer is written with the digit count of its issuance width: 8 digits for 2 WORD, 16 for 4 WORD, 64 for 16 WORD.
- When reading, an Issuer is accepted at 8, 16, or 64 digits. A longer notation of a short Issuer ID padded with leading zeros is looked up as the same Issuer (`0x00000001` and `0x0000000000000001` are the same Issuer, [Issuer and Publication](issuer.md#issuer-등급)).

| Object | Width | Digits | Example |
|---|---|---|---|
| Issuer | 2 WORD | 8 | `0x00000001` |
| Issuer | 4 WORD | 16 | `0x0000000100000000` |
| Issuer | 16 WORD | 64 | `0x` + 64 digits |
| Codec ID | 2 WORD | 8 | `0x00000AA0` |
| Document ID | 4 WORD | 16 | `0x0000000000000000` |
| Version ID | 2 WORD | 8 | `0x00000003` |
| Content hash | 16 WORD | 64 | `0x` + 64 digits |

- The Codec ID of a GEUL direct code is its TAG WORD (L=0) written as 32 bits (TRIPLE `0x0AAL` → `0x00000AA0`). The Kind is contained in the TAG, so there is no overlap.
- A Codec of ISSUER format from another Issuer is placed under that Issuer's `codecs/` with the record's Codec number. Example: IETF CRC32C is `0x00000007/codecs/0x0000C000/`.
- The Codec ID of an Issuer Codec is the record's Codec number (2 WORD). An Issuer assigns Codec numbers so that they do not overlap within its own `<Issuer>/codecs/`, regardless of Kind (Reference, Value, Edge). Addresses are not divided by Kind (there are no folders like `references/`, `values/`, `edges/`).
- A resolver treats it as an error if the Kind of a record differs from the Kind of the target of the [DECLARE](edge/0x0BBL-declare.md) in its Codec document.
- Publication rejects uploading a different Codec under the same Codec ID.
- The rules for version IDs (from 1, `0` is latest, assigned by the publisher, a new document ID when used up) are set by [Document](document.md#버전).

## Publication Addresses {#공표-주소}

```
/.well-known/geul/issuers/latest.geul                              Issuer list, latest
/.well-known/geul/issuers/<version ID>.geul                        Issuer list, specified version
/.well-known/geul/issuers/versions.geul                            Issuer list, version list
/.well-known/geul/<Issuer>/codecs/<Codec ID>/latest.geul           Codec, latest
/.well-known/geul/<Issuer>/codecs/<Codec ID>/<version ID>.geul     Codec, specified version
/.well-known/geul/<Issuer>/codecs/<Codec ID>/versions.geul         Codec, version list
/.well-known/geul/<Issuer>/docs/<document ID>/latest.geul          Document, latest
/.well-known/geul/<Issuer>/docs/<document ID>/<version ID>.geul    Document, specified version
/.well-known/geul/<Issuer>/docs/<document ID>/versions.geul        Document, version list
/.well-known/geul/<Issuer>/hashes/<content hash>.geul              Lookup by content hash
```

Example: `/.well-known/geul/0x00000002/docs/0x0000000000000000/latest.geul`

- The path follows `.well-known` of RFC 8615. geul.org and private publication use the same path and differ only in domain. The suffix to register is the single `geul`.
- The Issuer list is `issuers/`. Codecs, ordinary documents, and hashes are split under the Issuer folder into `codecs/<Codec ID>/`, `docs/<document ID>/`, and `hashes/`. The Issuer list also starts at version 1 and has `versions.geul` ([List documents](#목록-문서)).
- `latest.geul` is a reserved word and an alias. It is not stored. It finds the most recent version in the `versions.geul` at the same place and serves the bytes of that version as they are. It does not redirect. Every `latest.geul` is the same for the Issuer list, Codecs, and documents.
- The canonical address of a version is `/<Issuer>/docs/<document ID>/<version ID>.geul`. For a Codec it is `/<Issuer>/codecs/<Codec ID>/<version ID>.geul`. Other addresses that serve the same content point to the canonical address with `Link: rel=canonical`.
- Version-specified addresses and content hash addresses are immutable. Immutable addresses can be kept in permanent caches and CDNs. The receiver verifies against the content hash in the version list (or lock record).
- To look up by content hash, the Issuer must be known. There is no global lookup by hash alone.
- A Codec document has no document ID. It points to itself and its version with a [CODEC-POINTER](reference/0x042L-codec-pointer.md) (Issuer, Codec ID, version ID).
- An ID always starts with `0x`. So reserved names (`issuers`, `codecs`, `docs`, `hashes`, `latest.geul`, `versions.geul`) and human-assigned names do not collide with an ID, even words made only of hex digits like `add` or `cafe`.
- Location (which server it is fetched from) is not put into the document content. If it were, the content hash would change when the address changes. Location is determined by the configuration of the receiving side.

### Publication Form and Lookup {#공표-형태와-조회}

- An address is a logical address. A publisher may issue individual files or packs; if it is a pack, it cannot be fetched directly by the address URL and is read with a GEUL resolver.
- Whether stored as individual files, a pack, or a zstd pack, it is found at the same address. An address outside the 10 forms above, and an address that does not exist, is 404 (not found).

The command-line tool `geul` ([gogeul](https://github.com/geul-org/gogeul)):

```
geul get <address>     writes the pure GEUL document binary to standard output
geul show <address>    shows the document as text
```

- `geul get` accepts `file://` and `https://` addresses. An address outside the 10 forms and an address that does not exist end with 404 (not found).

The `pkg/resolve` of the Go library gogeul has a lookup function for each address. All return pure GEUL binary (`[]byte`). Version IDs start at 1, so `Latest` (0) is the latest. A nonexistent address is a not-found error (`ErrNotFound`).

```go
const Latest uint32 = 0

Issuers(ctx, v)               / IssuersVersions(ctx)
Codec(ctx, issuer, codec, v)  / CodecVersions(ctx, issuer, codec)
Doc(ctx, issuer, doc, v)      / DocVersions(ctx, issuer, doc)
Hash(ctx, issuer, hash)

ParseAddr(s string) (Addr, error)   // forms other than the 10 are 404 (not found)
Fetch(ctx, Addr) ([]byte, error)    // geul get = ParseAddr → Fetch → standard output
```

### Format Designation {#형식-지정}

- A publication address ends in `.geul` and is binary (`application/vnd.geul`).
- The binary is the canonical form of a document. The content hash and signatures are computed only from the binary.

### List Documents {#목록-문서}

The only list document is the Issuer list `issuers/`. It binds Issuers to domains ([Issuer list](#issuer-목록)). It starts at version 1 and has `versions.geul`. The document ID of the list is the reserved document ID `0xFFFFFFFFFFFFFFFF` (Issuer geul.org `0x00000000`). Every Issuer reserves the document IDs `0x0000000000000000` and `0xFFFFFFFFFFFFFFFF` ([Issuer and Publication](issuer.md#용어-정의-문서)).

- `latest.geul` is an alias that is not stored. It finds the most recent version in `versions.geul` and serves its bytes.
- The PUBLICATION, DEPRECATION, and TOMBSTONE in `issuers/versions.geul` point to a list version with a DOC-POINTER (`0x00000000`, `0xFFFFFFFFFFFFFFFF`, version ID). So even when fetched via `hashes/`, it is known what the list is for ([PUBLICATION](edge/0x0B8L-publication.md#목록-문서의-버전-목록)).
- The document ID `0xFFFFFFFFFFFFFFFF` is not served at the address `<Issuer>/docs/<document ID>/` of any Issuer (404). The other reserved document ID `0x0000000000000000` is that Issuer's term definition index document and is placed under `docs/` ([Issuer and Publication](issuer.md#용어-정의-문서)).
- A list document has no `DOC-ID`. What the list is for is stated by the DOC-POINTER in its records ([DOC-ID](meta/0x1C7L-doc-id.md)).
- Documents and Codecs are found directly by the ID computed from a record, without a list ([Document names](#문서-이름)).

### Domain Names {#도메인-이름}

A domain name is not a publication URL address. An address that writes a domain in the `<Issuer>` position or a name in an ID position is outside the 10 forms above, so it is 404 (not found). There is no redirect from a name to an ID address either.

- A domain name is an input to resolvers and the CLI. A resolver converts a domain to an Issuer ID with BIND in the Issuer list `issuers/`. The converted ID is kept in the lock record. There is no document name address ([Document names](#문서-이름)).
- The canonical address, cache key, and signature target are the ID address.
- Domains are written in lowercase, and internationalized domains in IDNA (punycode) form. No trailing `.` is added.
- 16 WORD Issuers, which have no registry, and air-gapped environments that cannot reach geul.org cannot use domain names. They use the ID.

### Issuer List {#issuer-목록}

The Issuer list is a document under `/.well-known/geul/issuers/` (the latest is `issuers/latest.geul`). It binds Issuers to their names (domains).

```
BODY
  BIND   Subject = ISSUER-POINTER(Issuer)   name = "geul.org"
  …
```

- The Subject is an [ISSUER-POINTER](reference/0x040L-issuer-pointer.md) (the Issuer itself), and the name is bound with [BIND](edge/0x0A3L-bind.md).
- The name is a domain that has passed domain ownership proof. It is lowercase, and internationalized domains are written in IDNA (punycode). One name is bound to only one Issuer.
- A human-readable Issuer display name (per language) is attached to the same Subject as a statement [LABEL](edge/0x0A4L-label.md).
- It is signed by geul.org (the GEUL Issuer), and changes are appended, never edited (the same chain rule as version lists).

### Document Names {#문서-이름}

**There is no document name address.** Documents and Codecs are found by ID.

- No index that converts document names or Codec names to IDs is kept. A document name [BIND](edge/0x0A3L-bind.md) is also not placed in a version list ([PUBLICATION](edge/0x0B8L-publication.md#버전-목록-문서)).
- An index for people to browse is built by a tool (viewer) from the pack inventory.
- The canonical address, cache key, and signature target are the ID address. IMPORT and citations inside documents use IDs only.
- A human-readable title (per language) is attached as a statement [LABEL](edge/0x0A4L-label.md).

### Deleted Documents {#삭제된-문서}

- The address of a version discarded by legal deletion or deletion by authority (TOMBSTONE) is also 404 (not found), like any other nonexistent address.
- A version for which deprecation was advised (DEPRECATION) is not 404. It continues to be served at that version's address.
- A deletion is left in the version list as a [TOMBSTONE](edge/0x0BAL-tombstone.md) record (the DOC-POINTER of that version, and a reason category).

## Layers {#층}

GEUL expresses even provenance, meta, and lists as GEUL documents. The minimum needed to read them is built into the decoder to break the circularity. Each layer relies only on the layers below.

| Layer | Contents | Relies on |
|---|---|---|
| Layer 0 | Rules built into the decoder: framing, content hash, signature verification, the version list record Codecs (`PUBLICATION`, `DEPRECATION`, `TOMBSTONE`), the Codec specification vocabulary (`DECLARE`, `FIELD`, `ENUM`, `CODEC`), [slot markers](slot-marker.md) (`0x0000`, `0x0010`, `0x0020`), and trust keys received from outside the document | Nothing. No lookup |
| Layer 1 | Version list documents | Layer 0 |
| Layer 2 | Ordinary documents, codebooks, Codec specification documents, Issuer verification key documents | Found via Layer 1 and verified with Layer 0 |

- No layer relies on its own layer or one above it.
- Distinguish what is expressed in GEUL from what can be read only by interpreting GEUL. Layer 0 can be expressed in GEUL, but its interpretation needs no lookup.
- A fixed core that cannot be turned into a TOULMIN document, such as the meaning of a verdict, is also placed here ([TOULMIN](toulmin/_index.md#메타-인지와-자기-개정)).

## Version Lists {#버전-목록}

For each document, the publisher keeps appending to one version list document (`/<Issuer>/docs/<document ID>/versions.geul`; for a Codec `/<Issuer>/codecs/<Codec ID>/versions.geul`; for the Issuer list `issuers/versions.geul`). The record format and document structure are set by [PUBLICATION](edge/0x0B8L-publication.md).

```
DOC-*
  SPEC-VERSION
  PARENT          content hash of the previous version list
  RECORDED-AT     time this list was issued
  NEXT-LOCAL-ID   the next LOCAL ID to assign
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
| DEPRECATION | Marks a published version with a deprecation advisory. It is still interpreted |
| TOMBSTONE | Deletes a published version (legal or by-authority deletion). Records a reason category |

- Records are only appended. They are not edited, deleted, or reordered. Deprecation and deletion are also appended as records. A new list keeps the BODY of the previous list as it is at the front and appends records, and the lists are linked by a `PARENT` hash chain.
- This means publication records are not edited, which differs from revision of document content ([Document](document.md#개정)). The current state of a version is computed by applying the records in order.
- Version IDs are ascending from 1 with no gaps. The same content is not published again.
- The latest version is the highest version that is neither deprecated nor deleted.
- No time is put in a record. The `RECORDED-AT` of the list where that record first appeared is the publication time.
- A version list has no `DOC-ID`. The DOC-POINTER in the records (the document ID; the reserved document ID for the Issuer list) states what the list is for.
- A version list has no IMPORT and uses only Layer 0 Codecs. The BODY holds only PUBLICATION, DEPRECATION, and TOMBSTONE.
- Past version lists are pointed to only by content hash (`<Issuer>/hashes/<content hash>.geul`), and the history is linked by the `PARENT` chain.
- The mutable addresses are `latest.geul` and `versions.geul`. A mutable pointer cannot be made into a document, so it is verified by the signature, `RECORDED-AT`, and `PARENT` of the received list.

### Signing Party {#서명-주체}

| Signature | Party | Target |
|---|---|---|
| Document signature | The Issuer of that document | The document's content hash ([Issuer and Publication](issuer.md#서명)) |
| List signature | The publisher that assigned the version IDs | The version list's content hash |

- For geul.org publication, geul.org (the GEUL Issuer) assigns version IDs and signs the list; for private publication, that Issuer does.
- The author is responsible for the content, and the publisher for the numbers and order.

### Verification {#검증}

- A signature is excluded from the content hash, so removing it leaves the hash unchanged. So verification is not "check it if there is a signature" but "a signature by the designated key must exist". The keys to require are determined by the resolver's trust settings and the lock record.
- A resolver keeps the content hash of the last list it saw in the lock record. If a newly received list's `PARENT` chain does not contain that hash, it rejects it (preventing rewind and fork).
- Mirrors and air-gapped environments copy the version list chain along with the rest. With only the public key, verification is possible offline.
- A received document is verified by its content hash whatever its origin. The origin need not be trusted.

## Dependency Resolution {#의존성-해석}

- A document lists the documents it depends on in the HEAD with [IMPORT-DOC](meta/0x1E4L-import-doc.md).
- A new version promises no compatibility with the previous version. So the versions of one document are not merged into one across the whole graph (minimal version selection is not used).
- Each `IMPORT-DOC` is bound to the edition it pins. Several editions of the same document can coexist in one graph (a ruling that cites the old statute and a ruling that cites the current statute). A reference resolves as (document, version, LOCAL ID).
- A latest (version `0`) import is bound to the latest edition at the time of interpretation. If interpreted at a fixed point in time, it is bound to the edition in force at that time ([Document](document.md#개정)).
- An import pinned by version ID is reproducible (the content of a version ID is immutable and is verified by the lock record).

## Media Type {#미디어-타입}

- The media type of a GEUL document is `application/vnd.geul`. The extension is `.geul`.
- Even if it moves to the standards tree `application/geul`, `application/vnd.geul` continues to be accepted.

## Open Problems {#열린-문제}

- Handling when version IDs diverge (the same version ID, different content) in private publication, 16 WORD Issuers, and air-gapped environments.
- The HEAD composition and the signature and chain format of the Issuer list `issuers/`. Naming rules for Issuers without a domain (4 WORD), name dispute handling, and a length cap.
- When and in what format to move from the full chain to a Merkle log (inclusion and consistency proofs) as lists grow.
- A Meta that records in the HEAD the Issuer that provides the location.
