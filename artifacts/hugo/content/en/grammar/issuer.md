---
title: "Issuer and Publication"
weight: 80
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "An Issuer is the party that defines documents and formats. How one is issued depends on its width (1, 2, 4, or 16 WORD). This page sets the Issuer tiers, the 1 WORD assignment table, how documents are disclosed, and how signatures and verification keys are published."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL does not gather its identification scheme in one place. Each Issuer defines its own targets and formats, and other documents use the published definitions. A definition is kept confidential, or published on geul.org (CC0) or by private publication (under a license the Issuer sets). Which definitions to trust and use is up to the user.

Publication addresses, format specification, name indexes, version lists, and trust layers are set by [Publication Addresses and Version Lists](/grammar/publishing/).

## What an Issuer Defines

| Subject | Method |
|---|---|
| Targets (entities, concepts, terms) | Declared as LOCAL in the Issuer's own documents |
| Value formats | Defined with a format number under the Issuer code |
| Edge formats | Defined with a format number under the Issuer code |

- Definitions of Value and Edge formats are also published as documents.

## Principles

- Every ID is scoped to a document. LOCAL IDs (including Edge Ids and variables) and IMPORT IDs are valid only inside that document.
- A target defined by an Issuer is a LOCAL in a document that Issuer published. Other documents cite it directly with a pointer-declaration (`EXTERNAL-ISSUER-*`), or bring it in with `IMPORT-DOC` and point to it with `EXTERNAL-POINTER-*`.
- For a target that must be pointed to from outside the document, issue a LOCAL in a published document. That document must have a [DOC-ID](/grammar/meta/declaration/doc-id/).

## Issuer Tiers

| Width | Value range | Issuance |
|---|---|---|
| 1 WORD | `0x0000`-`0xFFFF` | Assigned by geul.org to standards bodies and major institutions ([1 WORD Assignment Table](#1-word-assignment-table)) |
| 2 WORD | `0x00010000`-`0xFFFFFFFF` | Registered with geul.org. Requires proof of domain ownership |
| 4 WORD | `2^32`-`2^64−1` | Registered with geul.org. No proof of ownership |
| 16 WORD | `2^64` and above | Self-issued. Computed from a public key |

- **An Issuer ID is an integer value.** The same value means the same Issuer (`0x0001` and `0x00000001` are the same value). The width is not part of the identifier.
- **The canonical form is the shortest width.** Write the value in the shortest width that fits it, and reject a notation in a wider width. So the assignment for each width starts from the value after the range of the width just below it (2 WORD starts at `0x00010000`).

## 1 WORD Assignment Table

geul.org assigns 1 WORD Issuers to standards bodies and major institutions. Formats designed by GEUL itself go under `GEUL`, and de facto standards or conventional formats with no standardizing body go under `ADHOC`.

| Issuer | Name | Body | Representative formats |
|---|---|---|---|
| `0x0000` | GEUL | geul.org | GEUL-specific formats, the codebook |
| `0x0001` | ADHOC | geul.org | Conventional formats with no standardizing body. BFLOAT16, BLAKE3, complex numbers, fractions, intervals, quaternions, vectors, tensors |
| `0x0002`-`0x000F` | Reserved | | |
| `0x0010` | ISO | International Organization for Standardization | ISO 8601, ISO 4217 (currency), ISO 3166 (country) |
| `0x0011` | IEC | International Electrotechnical Commission | IEC 80000 (unit notation) |
| `0x0012` | ISO-IEC-JTC1 | ISO/IEC Joint Technical Committee 1 | ISO/IEC information technology standards |
| `0x0013` | ITU-T | ITU Telecommunication Standardization Sector | X.509, X.690 (ASN.1 encoding) |
| `0x0014`-`0x001F` | Reserved | International standards bodies | |
| `0x0020` | IETF | Internet Engineering Task Force | URI (RFC 3986), UUID (RFC 9562), CRC32C, IPv4 and IPv6 |
| `0x0021` | IANA | Internet Assigned Numbers Authority | Media types, language subtag registry |
| `0x0022` | W3C | World Wide Web Consortium | XML Schema data types, RDF |
| `0x0023` | WHATWG | Web Hypertext Application Technology Working Group | URL, HTML |
| `0x0024` | UNICODE | Unicode Consortium | Character encoding, normalization, CLDR |
| `0x0025` | ECMA | Ecma International | JSON (ECMA-404) |
| `0x0026`-`0x003F` | Reserved | Internet and web standards bodies | |
| `0x0040` | IEEE | Institute of Electrical and Electronics Engineers | IEEE 754 floating point and decimal, MAC addresses (802) |
| `0x0041` | KHRONOS | Khronos Group | Pixel formats (RGBA8 and BGRA8 UNORM), glTF |
| `0x0042` | OGC | Open Geospatial Consortium | Coordinates, bounding boxes, GeoJSON family |
| `0x0043` | ONNX | ONNX (LF AI & Data Foundation) | FP8 E4M3FN, E4M3FNUZ, E5M2, E5M2FNUZ |
| `0x0044` | OCP | Open Compute Project | Microscaling formats (E8M0, FP4 E2M1) |
| `0x0045` | OASIS | OASIS Open | Document and security standards |
| `0x0046`-`0x005F` | Reserved | Industry standards bodies | |
| `0x0060` | BIPM | Bureau International des Poids et Mesures | SI units, TAI |
| `0x0061` | IERS | International Earth Rotation and Reference Systems Service | Leap seconds, UTC−TAI |
| `0x0062` | NIST | National Institute of Standards and Technology | SHA-2 (FIPS 180-4), SHA-3 (FIPS 202) |
| `0x0063` | GPS | The government body that operates GPS | GPS time |
| `0x0064`-`0x00FF` | Reserved | Metrology and government agencies | |
| `0x0100` | KATS | Korean Agency for Technology and Standards | KS standards |
| `0x0101`-`0x01FF` | Reserved | National standards bodies | |
| `0x0200`-`0xFFFF` | Reserved | Later assignment | |

- An extended format goes under the Issuer of the body that established the format. Format numbers under an Issuer are defined by each Issuer.
- The upper bits of a format number must follow the family rules of the Kind concerned. That way the family is known without a codebook.
- If a standards body does not manage GEUL format numbers itself, geul.org lists that body's standard under a number on its behalf. The number is recorded together with the standard document identifier.
- Assignment starts from the lowest number within the body-group range. The ranges are for classification convenience, and decoders have no obligation to interpret them.

## 16 WORD Issuer

```
Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ signature algorithm ID (2 bytes) ‖ public key)
```

- The resulting 32 bytes are written into 16 WORDs, upper byte first.
- Anyone can create one without registration. Ownership is proved by a signature with the private key.
- The public key and algorithm are declared with [ISSUER-KEY](/grammar/meta/verification/issuer-key/) in the document HEAD. Signature algorithm `0x0001` is Ed25519, and other values are reserved.
- The prefix `GEUL-ISSUER-v1` makes sure the same ID does not result when the same key is used for a different purpose (purpose separation).
- Even if the signature algorithm changes (for example Ed25519 → ML-DSA), the ID width stays 16 WORDs.
- If the result is below `2^64` (the probability is practically zero), no Issuer is created with that key, because it would collide with the shortest-width rule.

## Domain Proof

- Proof of domain ownership for a 2 WORD Issuer is checked only at registration. Domain management afterward is the Issuer's responsibility.
- One domain corresponds to only one Issuer. One Issuer can have several domains. The correspondence is written as a BIND in the Issuer name index `issuers.geul` ([Publication Addresses and Version Lists](/grammar/publishing/#issuer-names)).
- Even if a domain expires or changes hands, the correspondence stays with the Issuer that first proved it. The new owner cannot use that domain as an Issuer name.
- A domain name is for entering and displaying addresses. Only the Issuer ID is written inside a GEUL document.

## Term Definition Documents

- A term defined by an Issuer (a tool, a program, a role, a concept inside an organization) is kept as **one document per term**. The term is a LOCAL in that document, its name is attached with [BIND](/grammar/edge/bind/), and the external target it points to (a URI and so on) is linked with [REFERENCE-NODE](/grammar/edge/reference-node/).
- Other documents point to a term with `EXTERNAL-ISSUER-*` (Issuer, document ID, LOCAL ID). The same definition is not repeated in each document. Example: the tool of [TRANSFORMED-BY](/grammar/meta/lineage/transformed-by/).
- The Issuer decides the document ID range for term definition documents. geul.org (`0x0000`) uses `0x0001xxxx xxxxxxxx` ([Codec specification document](/grammar/codec-spec/#document-ids-of-the-geul-issuer)).
- Document ID `0x0000000000000000` of each Issuer is reserved for that Issuer's **term definition index document**: `<Issuer>/0x0000000000000000/`. It is the place that lists the term definition documents.
- An index document is **recommended** for every Issuer. It is not required. Without an index, term definition documents are found through the name index `documents.geul`.
- The order for pointing to an external target: (1) a matching Reference Codec if one exists (WIKIDATA-QID and so on), (2) a GEUL document that defines the target if one exists (DOC-POINTER, EXTERNAL-ISSUER), (3) otherwise define it as a LOCAL in your own term definition document and point to that.

## How Documents Are Disclosed

| Method | Applies to | License | Version management | Persistence |
|---|---|---|---|---|
| Confidential | Any Issuer | Internal to the Issuer | Issuer | Depends on the Issuer |
| Publication on geul.org | 1 and 2 WORD Issuers | CC0 | geul.org | Preserved by geul.org |
| Private publication | Any Issuer | Set by the Issuer | Issuer | Depends on the Issuer |

### Publication on geul.org

- 1 and 2 WORD Issuers can register and publish documents on geul.org. Registered documents are CC0.
  - A 1 WORD Issuer publishes after review in advance by geul.org.
  - A 2 WORD Issuer is published immediately upon registration, and problems are handled afterward.
- What can be published are definitions of concepts and codecs. **A Reference that points to a natural person cannot be published on geul.org.** Use confidential or private publication.
  - Exception: pointing to a natural person with [WIKIDATA-QID](/grammar/reference/wikidata-qid/) is allowed.
- A registered version is neither changed nor deleted, and the document remains even if the Issuer disappears (the old law is preserved). The exceptions are legal deletion and deletion by authority ([TOMBSTONE](/grammar/edge/publication/)).
- An Issuer can only mark a definition with a deprecation notice (deprecated). A deprecated definition is still interpreted.
- A new version of the same document may add, revise, or delete definitions ([Document](/grammar/document/#revisions)). **A deleted entity ID or format number is not reused for another target.** The wire layout of a format number is not revised.

### Private Publication

- An Issuer that wants to publish under a license other than CC0 serves its documents on a private network (its own domain and so on). The license is declared with [LICENSE](/grammar/meta/policy/license/) in the document HEAD.
- Private publication uses the same paths as geul.org ([Publication Addresses and Version Lists](/grammar/publishing/)).
- Version management, availability, domain upkeep, and license terms are set by the Issuer. geul.org neither takes part in nor guarantees private publication.

### Confidential

- A confidential document is not published. Put access control on it and mark it with [ACCESS](/grammar/meta/policy/access/).
- If a document that uses confidential definitions is sent outside, the receiver cannot interpret those References, Values, and Edges and skips them. Publish the definitions you exchange with the outside.

### The User's Choice

- Users choose the documents to use by looking at the declared license and the Issuer's likelihood of persisting.
- Definitions under overly restrictive licenses, or from Issuers whose persistence is uncertain, will not be used.
- For references that must be preserved for a long time, use documents published on geul.org.

## Signatures

- A signature is required for published documents. Place it in the HEAD as [SIGNATURE](/grammar/meta/verification/signature/). A document without a signature is still a valid GEUL document, and confidential and internal documents should also be signed where possible.
- What is signed is the document's **content hash** ([Document](/grammar/document/#content-hash)). The BODY alone is not signed.
  - The HEAD holds interpretation rules. If the target of an `IMPORT-DOC` is changed, the same BODY points to a different target.
  - If `LICENSE` and `PARENT` are not signed, the license and history can be forged.
- A document can carry several signatures. All of them sign the same content hash, so adding a signature does not change the content hash.
- Checking the signing key:
  - 1, 2, and 4 WORD Issuers: the key registered with geul.org (see Publishing Verification Keys below).
  - 16 WORD Issuers: the `ISSUER-KEY` in the same document. The Issuer ID computed from that public key must equal the signer.
- A reader lowers its confidence when there is no signature, and lowers it even further when there is a signature but verification fails, since that is evidence of tampering or impersonation.
- A document signature is made by the document's Issuer, and a version list signature by the publisher that assigned the version IDs ([Publication Addresses and Version Lists](/grammar/publishing/#signing-parties)).

## Publishing Verification Keys

- geul.org publishes the signature verification keys of registered Issuers (1, 2, and 4 WORD).
- The key list is issued as a published document of the GEUL Issuer (`0x0000`). It is CC0 and signed by geul.org.
  - Entries: Issuer, signature algorithm ID, public key, start of validity, and time and reason of revocation.
- Revoked keys are not erased. Past signatures are verified with the key that was valid at the time of signing.
- Key rotation is registered by signing the new key with the old key. A verifier can check the continuity of keys without trusting geul.org.
- Key change records are kept in an append-only log (the same approach as Certificate Transparency and Go sumdb). Any tampering with the history would be exposed.
- If a key is lost and the old key cannot sign, geul.org re-verifies the identity and registers a new key. A 2 WORD Issuer goes through domain ownership proof again. In this case geul.org must be trusted, and the reason is recorded in the log.
- 16 WORD Issuers are not covered. The Issuer ID is computed from the public key, so verification uses only the `ISSUER-KEY` inside the document.

## Importing

IMPORT brings in documents only.

```
IMPORT-DOC                      DOC-POINTER (Issuer + document ID + version ID) + IMPORT ID
EXTERNAL-POINTER-1/2/4/8WORD    IMPORT ID + LOCAL ID
EXTERNAL-ISSUER-1/2/4/16WORD    Issuer + document ID + LOCAL ID (without IMPORT)
ISSUER-POINTER                  Issuer (the Issuer itself)
DOC-POINTER                     Issuer + document ID + version ID (2 WORD, 0 = latest)
```

- An Issuer of any width and its documents can be pointed to by pointer-declarations without IMPORT. The Issuer itself is `ISSUER-POINTER`, a document itself is `DOC-POINTER`, and a LOCAL in a document is `EXTERNAL-ISSUER-*`. A pointer-declaration follows the latest version; to pin a version, use `IMPORT-DOC` (with a version ID) and `EXTERNAL-POINTER-*`.
- A Reference in the body uses only IMPORT ID + target ID instead of the full path (Issuer + document + target ID).
- The width of an IMPORT ID is set by the length in `IMPORT-DOC` and by the Codec in `EXTERNAL-POINTER-*`. It is valid only inside that document ([IMPORT-DOC](/grammar/meta/import/import-doc/)).
- Importing without a version ID follows the latest version. Writing a version ID pins that version. Published documents write the version ID.

## License

- Documents published on geul.org and documents of the GEUL Issuer (`0x0000`) are CC0.
- The license of privately published documents is set by the Issuer. GEUL does not enforce one.
- GEUL core deliverables do not copy the content of documents from Issuers that are not CC0.

## Open Questions

- Whether to allow geul.org publication for 4 WORD and 16 WORD Issuers.
- The method of domain ownership proof (DNS TXT `_geul.<domain>`, HTTP `.well-known`) and whether to bind the signing key fingerprint to the proof value.
- Handling domain hijacking during key loss recovery. If a new key is registered with domain re-proof alone, a hijacker could take over the Issuer. Checking the registered contact, a grace period with objections from the old key, and applying the result of domain disputes are under consideration.
- The record format of the term definition index document (document ID `0`) (the Edge that lists term definition documents).
- The default signature algorithm (Ed25519 recommended).
