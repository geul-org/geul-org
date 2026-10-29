---
title: "Repositories"
date: 2026-02-28T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
summary: "Public GitHub repositories of GEUL: the Go library and geul CLI, Wikidata loading and conversion, the SILK search engine, pre-v1 codebooks and this website."
image: "/images/og-default.webp"
---

GEUL's public repositories live under the [geul-org](https://github.com/geul-org) GitHub organization. The normative grammar is [GEUL Grammar](/grammar/) on this site.

A GEUL document is a sequence of 16-bit WORDs. The unit of data is the record, which starts with one TAG WORD, and records are held in a document. Documents are published by an Issuer, and each version is pinned by a content hash. The repositories below are tools that write, read, convert and search these documents.

---

## Library

### gogeul

The GEUL Go library and the `geul` command-line tool.

Writes, reads, checks and publishes GEUL documents (`.geul`). Its packages provide format checks, record decoding through Codec spec documents, version diffs, IMPORT dependency resolution and the TOULMIN Codec. The `geul` CLI covers editing (`new`, `add`), publishing (`publish`), browsing (`ls`, `log`, `show`), a browser viewer (`serve`, `build`) and pack archives (`pack build`, `pack unpack`). Pack archives can store records compressed with zstd.

| | |
|---|---|
| GitHub | [geul-org/gogeul](https://github.com/geul-org/gogeul) |
| Language | Go |
| License | CC0 |

---

## Wikidata

### wikigeul

Wikidata → GEUL conversion (formerly gogeulwiki).

Reads a Wikidata dump that wikipg has loaded into PostgreSQL and publishes one GEUL document per item or property, with labels, descriptions, aliases, statements with their qualifiers and references, and sitelinks in every language. All documents are published under the Issuer `wikidata.geul.org` (`0x00010000`).

| | |
|---|---|
| GitHub | [geul-org/wikigeul](https://github.com/geul-org/wikigeul) |
| Language | Go |
| License | CC0 |

### wikipg

Lossless loading of Wikidata JSON dumps into PostgreSQL.

Stores entities, labels, descriptions, aliases, claims, qualifiers, references, sitelinks and Lexemes in dump order, and keeps every dump line verbatim. The dump itself (file, URL, size, checksums, loader commit) is recorded too. wikipg does not depend on GEUL.

| | |
|---|---|
| GitHub | [geul-org/wikipg](https://github.com/geul-org/wikipg) |
| Language | Go |
| License | CC0 |

---

## Search

### silk

[SILK](/projects/silk/) — an indexing and search engine built for GEUL.

Builds partitioned, sorted indexes of the records in a GEUL pack archive and answers queries such as "which documents state that someone's occupation (P106) is physicist (Q169470)?" without decoding every document. It frames records and their fields from TAG WORDs alone, without a codebook. It is in early development, validating its search algorithms, and its formats may change before a first release.

| | |
|---|---|
| GitHub | [geul-org/silk](https://github.com/geul-org/silk) |
| Language | Go |
| License | CC0 |

---

## Codebooks (pre-v1)

The two repositories below were designed before the current v1 grammar. Parts of them do not match it.

### sidx

Research on SIDX (Semantic-aligned Index) assignment.

Research material toward assigning SIDX, a semantic address that gives close numbers to entities with close meanings, from Wikidata usage statistics. It holds the earlier 48-bit Entity attribute schema, encoder scripts and codebooks; no SIDX assignment has been produced yet. The normative definition of SIDX is [GEUL-SIDX](/grammar/reference/geul-sidx/) in the grammar.

| | |
|---|---|
| GitHub | [geul-org/sidx](https://github.com/geul-org/sidx) |
| Language | Python |
| License | CC0 |

### wordnet-verb

A provisional 16-bit verb codebook based on WordNet 3.0.

Gives each of the 13,767 verb synsets of WordNet 3.0 one 16-bit code, with close codes for verbs close in meaning. It is a provisional edition to be replaced by a codebook that does not use WordNet, and how the codes would be carried in GEUL records is not decided.

It contains material derived from WordNet, so it is **not a CC0 output.** The WordNet-derived parts follow the WordNet 3.0 License; only the GEUL project's own parts, such as the codes and the classification, are CC0.

| | |
|---|---|
| GitHub | [geul-org/wordnet-verb](https://github.com/geul-org/wordnet-verb) |
| Language | Python |
| License | WordNet 3.0 License (derived parts) · CC0 (own parts) |

---

## Website

### geul-org

Source of this website, geul.org.

A Hugo static site in 12 languages, deployed with S3 + CloudFront.

| | |
|---|---|
| GitHub | [geul-org/geul-org](https://github.com/geul-org/geul-org) |
| Language | Hugo |
| License | CC0 |

---

## Related Repositories

Repositories outside the geul-org organization.

### toulmin

A rule engine based on the Toulmin argument model (TypeScript, Python, Go, C).

Rules are functions, and exceptions are attack relations in a graph. The [TOULMIN](/grammar/edge/toulmin/) Edge of the GEUL grammar (direct codes `0x60`–`0x7B`) writes these judgment and execution graphs as GEUL documents.

| | |
|---|---|
| GitHub | [park-jun-woo/toulmin](https://github.com/park-jun-woo/toulmin) |
| License | MIT |
