---
title: "Issuer and Publication"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "GEUL does not gather its identification scheme in one place."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL does not gather its identification scheme in one place. Each Issuer defines its own objects and formats, and other documents take and use the published definitions. A definition is kept confidential, published on geul.org (CC0), or published privately (under a license the Issuer sets). The user decides which definitions to trust and use.

Publication addresses, format designation, the Issuer list, version lists, and trust layers are determined by [Publication addresses and version lists](publishing.md).

## What an Issuer Defines {#issuer가-정의하는-것}

| Object | Method |
|---|---|
| Object (entity, concept, term) | Declared as a LOCAL of its own document |
| Reference format | Defined under the Issuer code with a 2 WORD Codec number |
| Value format | Defined under the Issuer code with a 2 WORD Codec number |
| Edge format | Defined under the Issuer code with a 2 WORD Codec number |

- The definitions of Reference, Value, and Edge formats are also published as documents.

## Principles {#원칙}

- An object defined by an Issuer is a LOCAL of a document that Issuer published. Other documents cite it directly with a directing declaration (`EXTERNAL-ISSUER-*`), or bring it in with `IMPORT-DOC` and point to it with `EXTERNAL-POINTER-*`. The meaning of a [REFERENCE-ISSUER](reference/_index.md#reference-issuer) record is determined by the Codec document the Issuer issued.
- For an object that must be pointed to from outside the document, issue a LOCAL of a published document. That document must have a [DOC-ID](meta/0x1C7L-doc-id.md).

## Issuer Grades {#issuer-등급}

| Width | Value range | Issuance |
|---|---|---|
| 2 WORD | `0x00000000`~`0xFFFFFFFF` | Registered at geul.org. Domain ownership proof required. Numbers that geul.org assigns to standards bodies and major institutions are also this width ([2 WORD assignment table](#2-word-배정표)) |
| 4 WORD | `2^32`~`2^64−1` | Registered at geul.org. No ownership proof |
| 16 WORD | `2^64` or more | Self-issued. Computed from a public key |

- **An Issuer ID is an integer value.** Equal values are the same Issuer. The width is not part of the identifier.
- **A longer notation of a short Issuer ID padded with leading zeros is the same Issuer** (2 → 4, 2 → 16, 4 → 16 WORD). `0x00000001` and `0x0000000000000001` are the same Issuer. So no 4 WORD Issuer is assigned a value `0x00000000XXXXXXXX`, and no 16 WORD Issuer a value whose upper 12 WORDs are 0.
- **The canonical form is the shortest width.** In a record, write the shortest width that holds the value, and reject a notation of wider width. So the assignment of each width starts from the value after the range of the width just below it ends. 2 WORD is the shortest width. When used in a publication address, write it with the digit count of the issuance width (8 digits for 2 WORD, 16 for 4 WORD, 64 for 16 WORD) in uppercase hex (an address written in lowercase is converted to uppercase before lookup), and when reading, accept a widened notation as the same Issuer ([Publication addresses and version lists](publishing.md#id-표기)).

## 2 WORD Assignment Table {#2-word-배정표}

geul.org assigns 2 WORD Issuer numbers to standards bodies and major institutions in order from the start. De facto standards or conventional formats with no standardizing body go under `ADHOC` (`adhoc.geul.org`). Formats unique to GEUL's design are direct codes. The Issuer of a standards body is a geul.org subdomain Issuer. The subdomain name is the lowercase name of the institution (`<institution>.geul.org`, for example `iso.geul.org`, `iec.geul.org`). Domains are listed in the table below.

| Issuer | Name | Domain | Body | Representative formats |
|---|---|---|---|---|
| `0x00000000` | GEUL | `geul.org` | geul.org | Direct code specification documents (codebook) |
| `0x00000001` | wikidata.geul.org | `wikidata.geul.org` | geul.org | Wikidata item and property documents |
| `0x00000002` | ADHOC | `adhoc.geul.org` | geul.org | Conventional formats with no standardizing body. BFLOAT16, BLAKE3, complex numbers, fractions, intervals, quaternions, vectors, tensors |
| `0x00000003` | ISO | `iso.geul.org` | International Organization for Standardization | ISO 8601, ISO 4217 (currency), ISO 3166 (country) |
| `0x00000004` | IEC | `iec.geul.org` | International Electrotechnical Commission | IEC 80000 (unit notation) |
| `0x00000005` | ISO-IEC-JTC1 | `iso-iec-jtc1.geul.org` | ISO/IEC Joint Technical Committee 1 | ISO/IEC information technology standards |
| `0x00000006` | ITU-T | `itu-t.geul.org` | ITU Telecommunication Standardization Sector | X.509, X.690 (ASN.1 encoding) |
| `0x00000007` | IETF | `ietf.geul.org` | Internet Engineering Task Force | URI (RFC 3986), UUID (RFC 9562), CRC32C, IPv4, IPv6 |
| `0x00000008` | IANA | `iana.geul.org` | Internet Assigned Numbers Authority | Media types, language subtag registry |
| `0x00000009` | W3C | `w3c.geul.org` | World Wide Web Consortium | XML Schema data types, RDF |
| `0x0000000A` | WHATWG | `whatwg.geul.org` | Web Hypertext Application Technology Working Group | URL, HTML |
| `0x0000000B` | UNICODE | `unicode.geul.org` | Unicode Consortium | Character encoding, normalization, CLDR |
| `0x0000000C` | ECMA | `ecma.geul.org` | Ecma International | JSON (ECMA-404) |
| `0x0000000D` | IEEE | `ieee.geul.org` | Institute of Electrical and Electronics Engineers | IEEE 754 floating point and decimal, MAC address (802) |
| `0x0000000E` | KHRONOS | `khronos.geul.org` | Khronos Group | Pixel formats (RGBA8, BGRA8 UNORM), glTF |
| `0x0000000F` | OGC | `ogc.geul.org` | Open Geospatial Consortium | Coordinates, bounding boxes, GeoJSON family |
| `0x00000010` | ONNX | `onnx.geul.org` | ONNX (LF AI & Data Foundation) | FP8 E4M3FN, E4M3FNUZ, E5M2, E5M2FNUZ |
| `0x00000011` | OCP | `ocp.geul.org` | Open Compute Project | Microscaling formats (E8M0, FP4 E2M1) |
| `0x00000012` | OASIS | `oasis.geul.org` | OASIS Open | Document and security standards |
| `0x00000013` | BIPM | `bipm.geul.org` | Bureau International des Poids et Mesures | SI units, TAI |
| `0x00000014` | IERS | `iers.geul.org` | International Earth Rotation and Reference Systems Service | Leap seconds, UTC−TAI |
| `0x00000015` | NIST | `nist.geul.org` | National Institute of Standards and Technology | SHA-2 (FIPS 180-4), SHA-3 (FIPS 202) |
| `0x00000016` | GPS | `gps.geul.org` | Government operator of GPS | GPS time |
| `0x00000017` | KATS | `kats.geul.org` | Korean Agency for Technology and Standards (국가기술표준원) | KS standards |

- An extension format goes under the Issuer of the body that established that format. Codec numbers under an Issuer are defined by each Issuer.
- Codec numbers are set by the Issuer. GEUL assigns them no meaning. A Codec number does not overlap within that Issuer, regardless of Kind ([Publication addresses and version lists](publishing.md#id-표기)).
- If a standards body does not manage GEUL Codec numbers itself, geul.org registers that body's standards with numbers on its behalf. The number is recorded together with the standard's document identifier.
- A new standards body receives the next free number.
- **A domain can change.** The binding between an Issuer and a domain can change later. The Issuer ID does not change. When an institution comes to manage it directly, it is replaced with that institution's official domain.
- **A geul.org subdomain is not an official publisher.** A geul.org subdomain that uses the name of a standards body is not that body's official publisher. For example, `iso.geul.org` is not the official publisher of ISO.

## 16 WORD Issuer {#16-word-issuer}

```
Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ signature algorithm ID (2 bytes) ‖ public key)
```

- Write the resulting 32 bytes into 16 WORDs, most significant byte first.
- Anyone can create one without registration. Ownership is proved by a signature with that private key.
- The public key and algorithm are declared in the document HEAD with [ISSUER-KEY](meta/0x1E5L-issuer-key.md). Signature algorithm `0x0001` is Ed25519, and other values are Reserved.
- The prefix `GEUL-ISSUER-v1` keeps the same ID from being produced when the same key is used for a different purpose (domain separation).
- Even if the signature algorithm changes (for example Ed25519 → ML-DSA), the ID width stays 16 WORD.
- If the result is less than `2^64` (the probability is effectively 0), no Issuer is created from that key, because it would overlap with the shortest-width rule.

## Domain Proof {#도메인-증명}

- Proof of domain ownership for a 2 WORD Issuer is checked only at registration. Domain management afterward is the Issuer's responsibility.
- One domain corresponds to only one Issuer. One Issuer can have several domains. The correspondence is written with BIND in the Issuer list `issuers/` ([Publication addresses and version lists](publishing.md#issuer-목록)).
- Even if a domain expires or changes hands, the correspondence stays with the Issuer that first proved it. The new owner cannot use that domain as an Issuer name.
- A domain name is for resolver and CLI input and display. It is not a publication URL address ([Publication addresses and version lists](publishing.md#도메인-이름)). Only the Issuer ID is written inside a GEUL document.

## Term Definition Documents {#용어-정의-문서}

- A term an Issuer defines (a tool, a program, a role, a concept within an organization) is kept as **one document per term**. The term is a LOCAL of that document, its name is linked with [BIND](edge/0x0A3L-bind.md), and the external object it points to (a URI and so on) is linked with [REFERENCE-NODE](edge/0x0A0L-reference-node.md).
- Other documents point to the term with `EXTERNAL-ISSUER-*` (Issuer, document ID, LOCAL ID). The same definition is not repeated in each document. Example: the tool of [TRANSFORMED-BY](meta/0x1D4L-transformed-by.md).
- The range of document IDs for term definition documents is set by the Issuer. geul.org (`0x00000000`) uses `0x0001xxxx xxxxxxxx`.
- Every Issuer reserves the document IDs `0x0000000000000000` and `0xFFFFFFFFFFFFFFFF`. They are currently used in the two ways below.
- Document ID `0x0000000000000000` is the place for that Issuer's **term definition index document**: `<Issuer>/docs/0x0000000000000000/`. It is the place that lists the term definition documents.
- Document ID `0xFFFFFFFFFFFFFFFF` is used for the Issuer list `issuers/` of Issuer geul.org (`0x00000000`). Other Issuers do not use this ID. This ID is not served at the address `<Issuer>/docs/<document ID>/` of any Issuer (404) ([Publication addresses and version lists](publishing.md#목록-문서)).
- An index document is **recommended** for every Issuer. It is not required.
- The order for pointing to an external object: (1) a suitable Reference Codec, if one exists (WIKIDATA-QID and so on); (2) a GEUL document that defines the object, if one exists (DOC-POINTER, EXTERNAL-ISSUER); (3) otherwise, define it as a LOCAL in one's own term definition document and point to that.

## Document Publication Modes {#문서-공개-방식}

| Mode | Applies to | License | Version management | Persistence |
|---|---|---|---|---|
| Confidential | Every Issuer | Internal to the Issuer | Issuer | Depends on the Issuer |
| geul.org publication | 2 WORD Issuer | CC0 | geul.org | Preserved by geul.org |
| Private publication | Every Issuer | Set by the Issuer | Issuer | Depends on the Issuer |

### geul.org Publication {#geulorg-공표}

- A 2 WORD Issuer can register and publish documents at geul.org. Registered documents are CC0. Once registered, a document is published immediately, and problems are handled afterward.
- The definitions that can be published are concepts and Codecs. **A Reference that points to a natural person cannot be published at geul.org.** Use confidential or private publication.
  - Exception: pointing to a natural person with [WIKIDATA-QID](reference/0x014L-wikidata-qid.md) is allowed.
- A registered version is neither changed nor deleted, and the document remains even if the Issuer disappears (preservation of the old statute). The exceptions are legal deletion and deletion by authority ([TOMBSTONE](edge/0x0BAL-tombstone.md)).
- An Issuer can only mark a definition with a deprecation advisory (deprecated). A definition so advised is still interpreted.
- A new version of the same document can create, revise, or delete definitions ([Document](document.md#개정)). **A deleted entity ID or Codec number is not reused for another object.** The wire layout of a Codec number is not revised.

### Private Publication {#사설-공표}

- An Issuer that wants to publish under a license other than CC0 serves its documents on a private network (its own domain and so on). The license is declared with [LICENSE](meta/0x1DEL-license.md) in the document HEAD.
- Private publication uses the same paths as geul.org ([Publication addresses and version lists](publishing.md)).
- Version management, availability, domain upkeep, and license terms are set by the Issuer. geul.org does not take part in or guarantee private publication.

### Confidential {#대외비}

- A confidential document is not published. Access control is applied and it is marked with [ACCESS](meta/0x1DFL-access.md).
- If a document that uses a confidential definition is sent outside, the receiver cannot interpret those Reference, Value, and Edge records and skips them. Publish the definitions you exchange with the outside.

### The User's Choice {#사용자의-선택}

- The user chooses which documents to use by looking at the declared license and the Issuer's likelihood of persistence.
- Definitions with overly restrictive licenses, or from Issuers whose persistence is uncertain, go unused.
- For references that must be preserved long-term, use geul.org published documents.

## Signatures {#서명}

- A signature is required on a published document. Place it in the HEAD as [SIGNATURE](meta/0x1E6L-signature.md). A document without a signature is also a valid GEUL document, and confidential or internal documents should be signed where possible.
- The signature target is the document's **content hash** ([Document](document.md#내용-해시)). The BODY alone is not signed.
  - The HEAD holds interpretation rules. If the target of `IMPORT-DOC` is changed, the same BODY points to a different target.
  - If `LICENSE` and `PARENT` are not signed, the license and history can be forged.
- A document can carry several signatures. All sign the same content hash, so adding a signature does not change the content hash.
- Signing key verification:
  - 2 and 4 WORD Issuers: the key registered at geul.org (verification keys are published below).
  - 16 WORD Issuers: the `ISSUER-KEY` in the same document. The Issuer ID computed from that public key must equal the signer.
- A reader lowers its trust if there is no signature, and lowers it further if a signature exists but fails verification, since that is evidence of tampering or impersonation.
- A document signature is made by that document's Issuer, and a version list signature by the publisher that assigned the version IDs ([Publication addresses and version lists](publishing.md#서명-주체)).

## Publishing Verification Keys {#검증키-공개}

- geul.org publishes the signature verification keys of registered Issuers (2 and 4 WORD).
- The key list is issued as a published document of the GEUL Issuer (`0x00000000`). It is CC0 and signed by geul.org.
  - Entries: Issuer, signature algorithm ID, public key, start of validity, time and reason of revocation.
- A revoked key is also not deleted. A past signature is verified with the key that was valid at the time of signing.
- A key change is registered by signing the new key with the old key. The verifier can confirm the continuity of the key without trusting geul.org.
- Key change records are kept as an append-only log (the same approach as Certificate Transparency and Go sumdb). Altering the history is exposed.
- If a key is lost and cannot sign with the old key, geul.org re-verifies the identity and registers a new key. A 2 WORD Issuer goes through domain ownership proof again. In this case geul.org must be trusted, and the reason is recorded in the log.
- 16 WORD Issuers are not covered. The Issuer ID is computed from the public key, so verification uses only the `ISSUER-KEY` in the document.

## Import {#가져오기}

IMPORT brings in documents only.

```
IMPORT-DOC                      DOC-POINTER (Issuer + document ID + version ID) + IMPORT ID
                                For a Codec document, CODEC-POINTER (Issuer + Codec ID + version ID) + IMPORT ID
EXTERNAL-POINTER-1/2/4WORD      IMPORT ID + LOCAL ID
EXTERNAL-ISSUER-2/4/16WORD      Issuer + document ID + LOCAL ID (without IMPORT)
ISSUER-POINTER                  Issuer (the Issuer itself)
DOC-POINTER                     Issuer + document ID + version ID (2 WORD, 0 means latest)
CODEC-POINTER                   Issuer + Codec ID + version ID (2 WORD, 0 means latest)
```

- An Issuer of any width and its documents can be pointed to with a directing declaration without IMPORT. The Issuer itself is `ISSUER-POINTER`, a document itself is `DOC-POINTER`, and a LOCAL of a document is `EXTERNAL-ISSUER-*`. A directing declaration follows the latest version; to pin a version, use `IMPORT-DOC` (version ID) and `EXTERNAL-POINTER-*`.
- A BODY Reference that points to an object in an external document uses only IMPORT ID + object ID, instead of the full path (Issuer + document + object ID). [REFERENCE-ISSUER](reference/_index.md#reference-issuer) writes the Issuer and Codec number.
- The width of the IMPORT ID is determined by the length in `IMPORT-DOC` and by the Codec in `EXTERNAL-POINTER-*` ([IMPORT-DOC](meta/0x1E4L-import-doc.md)).
- Importing without a version ID follows the latest version. Writing a version ID pins that version. Published documents write the version ID.

## License {#라이선스}

- geul.org published documents and GEUL Issuer (`0x00000000`) documents are CC0.
- The license of a privately published document is set by the Issuer. GEUL does not enforce it.
- **License of Issuer formats.** Only the direct codes and publications that geul.org provides are CC0. The license of an Issuer format is set by that Issuer.
- **Issuer display.** GEUL relies on Issuer display for Resolve. A document that uses another Issuer's Codec always shows that Issuer.
- GEUL core outputs do not copy the contents of non-CC0 Issuer documents.

## Open Problems {#열린-문제}

- The domain ownership proof method (DNS TXT `_geul.<domain>`, HTTP `.well-known`), and whether to bind the signing key fingerprint into the proof value.
- Responding to domain hijacking during key-loss recovery. If a new key is registered by domain re-proof alone, a hijacker can take over the Issuer. Registered-contact confirmation, a grace period with objection by the old key, and applying the outcome of a domain dispute are under review.
- The record format of the term definition index document (document ID `0`) (the Edge that lists term definition documents).
- The default signature algorithm (Ed25519 recommended).
