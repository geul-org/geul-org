---
title: "SOURCE"
weight: 33
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SOURCE is an evidence Edge that links one record, or the whole document, to its source (Codec 0x20). The properties of the source go in a TRIPLE with the source as Subject, and the properties of the citation (retrieval date, position within the source, source hash) go in QUALIFIERs attached to the SOURCE. The SOURCE for the whole document is placed in the HEAD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SOURCE is an evidence Edge that links one record (the target), or the whole document, to the source it came from. Codec `0x20`. It is the only direct code of the evidence family (`01`).

One Wikidata reference (a bundle of source information) is one SOURCE. If a record has several sources, there are several SOURCEs.

## Layout

```
TAG WORD          0001 0LLL L010 0000
[Length extension TAG]
Edge Id           LOCAL Reference record
Target            LOCAL Reference record (in the BODY, the Edge Id of the Edge the evidence is attached to; in the HEAD, 0 = the whole document)
Origin            Reference record, or the slot marker 0x0000 ABSENT or 0x0001 UNKNOWN-VALUE
```

- Origin points to the source. If there is a Reference that fits the source, use it (WIKIDATA-QID, the DOC-POINTER or EXTERNAL-ISSUER of a GEUL document, and so on); if there is none, it is a LOCAL node of this document.
- If the source information does not describe a source (for example, a Wikidata "imported from" (P143) or a source that has only a retrieval date), Origin is [ABSENT](/grammar/reference/slot-marker/) (not written). The writer merely did not write the source, and asserts nothing about it. The rest of the source stays as it is in the QUALIFIERs.
- [UNKNOWN-VALUE](/grammar/reference/slot-marker/) is used only when the writer asserts "there is a source but I do not know what it is" (a record written by a person and so on). A converter that carries over from source material does not assert what the source did not say, so it uses ABSENT.
- An Origin that is ABSENT or UNKNOWN-VALUE is independent at each occurrence. The sources of two SOURCEs are not read as the same.

## Two Layers

Information about a source is divided into two. Do not mix them.

| Layer | What | How to write it | Examples |
|---|---|---|---|
| Source | Properties of the source itself. The same no matter who cites it | A [TRIPLE](/grammar/edge/triple/) with the source as Subject (rank normal) | URL (P854), title (P1476), author (P50, P2093), publication date (P577), published in (P1433), publisher (P123), language (P407) |
| Citation | Properties of the act of this record citing the source | A [QUALIFIER](/grammar/edge/qualifier/) whose Target is the Edge Id of the SOURCE | Retrieved (P813), position within the source (page P304, section P958, external identifiers P227, P1417), imported from (P143), inferred from (P887), source hash (P4092) |

- **The meaning of a SOURCE is everything gathered from the QUALIFIERs that point to its Edge Id.** Two sources that cite the same source on different days have the same source and different QUALIFIERs.
- A source TRIPLE is an assertion about the source. A property that cannot be assigned to a layer is placed on the citation side (QUALIFIER). It is safer not to assert about the source.
- Within a document, the same source is declared once as a single LOCAL and several SOURCEs point to it together.
- A source described only by a URL is defined by [REFERENCE-NODE](/grammar/edge/reference-node/) (LOCAL → URI). This is the same as the sitelink document pages.

## Interpretation and Validity

- Target and Origin are each exactly one complete record. The cursor after reading Origin must match the end of the Edge.
- Target is a LOCAL Reference. A SOURCE in the BODY points to an Edge Id in the BODY of the same document. `0` (the whole document) is used only by a SOURCE in the HEAD ([Source of the Whole Document](#source-of-the-whole-document)). A SOURCE with Target `0` in the BODY is invalid. Evidence for a record of another document is attached inside that document.
- Origin is a Reference. Of the slot markers, only `0x0000` (ABSENT) and `0x0001` (UNKNOWN-VALUE) are accepted. NO-VALUE (`0x0002`) and Value are not accepted.
- The geul.org specification document `0x0000/0x0000000000001020` (name `source`) places [CODEC](/grammar/edge/codec/) LOCAL (`0008`) on Target, and on Origin CODEC `0780` (any Reference), `0000` (ABSENT, optional), and `0001` (UNKNOWN-VALUE).
- The order among SOURCEs of the same Target has no meaning. The order of items within one source has no meaning either (the order of values of the same property remains as the document order).
- A SOURCE does not change whether its target is true or false. It only writes where the target came from. The judgment result is handled by [TOULMIN](/grammar/edge/toulmin/) `VERDICT`.

## Source of the Whole Document

The source of the whole document (the original dump, edition, or source file) is written in the **HEAD as a SOURCE with Target `0`**. The QUALIFIERs that have that SOURCE as their Target (source hash P4092, time received P813, range within the source, and so on) are also placed in the HEAD ([Document](/grammar/document/#head-and-body)).

- These two are the only Edges that can be placed in the HEAD. All other Edges go in the BODY.
- A HEAD QUALIFIER is placed after the HEAD SOURCE it points to. The decoder reads from the front and separates the HEAD and the BODY.
- A QUALIFIER whose Target is a HEAD SOURCE placed in the BODY is invalid. A SOURCE or QUALIFIER in the BODY does not point to an Edge in the HEAD.
- **The HEAD and the BODY share one Edge Id number space.** An Edge Id is unique within the document and, like other Edges, is taken from [NEXT-LOCAL-ID](/grammar/meta/lineage/next-local-id/); when rebuilding, the same content inherits the same number. Even in a version where a HEAD Edge is dropped, that number is not reused.
- If Origin is a LOCAL, its definition (REFERENCE-NODE, source TRIPLE) is placed in the BODY. A LOCAL is scoped to the whole document.
- A HEAD Edge is not Meta of the verification class, so it goes into the [content hash](/grammar/document/#content-hash). In a diff, it is replaced wholesale together with the HEAD (it is not written in `DELTA-REMOVE`).
- There is no Meta for the source of the whole document. A range within the source or a time obtained, written as Meta, cannot be assigned to a particular source when there are several. A QUALIFIER attached to a SOURCE decides this by its Target.

Example: the HEAD of a Q42 document carried over from a Wikidata dump (Edge Ids are for explanation).

```
SPEC-VERSION  0x0001
DOC-ID        0x00010000/0x510000000000002a
TRANSFORMED-BY …
#1738 SOURCE     #0     #1735                                         entity revision
#1741 SOURCE     #0     #1740                                         dump file
#1742 QUALIFIER  P4092  #1741  SHA-256-DIGEST(0xa249…0774)            file hash
#1743 QUALIFIER  P813   #1741  POSIX-TIMESTAMP-SECONDS(1792996483)    time received
BODY
#1736 TRIPLE     P577   #1735  POSIX-TIMESTAMP-SECONDS(1792210885) normal                      revision save time
#1737 TRIPLE     P854   #1735  <https://www.wikidata.org/w/index.php?oldid=2557857485> normal  revision permanent address
#1739 REFERENCE-NODE    #1740  <https://dumps.wikimedia.org/wikidatawiki/entities/20261019/wikidata-20261019-all.json.bz2>
…
```

- The revision and the dump are different sources, so there are two SOURCEs. The revision is the source of the content (the same content can be fetched again with the permanent address), and the dump is the file from which that revision was received. The file hash and the time received are citation-side properties of the dump file, so they are attached to the dump SOURCE.

## Expressing Other Evidence

The evidence family has only SOURCE. Other evidence is written as a QUALIFIER.

| Evidence | How to write it | Property |
|---|---|---|
| Range within the source | A QUALIFIER on the SOURCE. One SOURCE per range | page P304, section P958, quotation P1683. A character range is a GEUL term (undecided) |
| Time the source material was received | A QUALIFIER on the SOURCE | retrieved P813 |
| Hash of the source bytes (pinning the edition) | A QUALIFIER on the SOURCE | checksum P4092, the value is [SHA-256-DIGEST](/grammar/value/binary/sha-256-digest/) and so on |
| Creating party (person, model, rule engine) | A QUALIFIER on the SOURCE (the party that made the citation) or on the target | GEUL term (undecided) |
| Confidence | A QUALIFIER on the target | GEUL term (undecided), the value is 0 to 1 like the Meta [CONFIDENCE](/grammar/meta/verification/confidence/) |
| Per-article period in force | A QUALIFIER on the target | start P580, end P582 |
| Old record before a move, split, or merge | A QUALIFIER on the target, the value is the old Edge Id (LOCAL) | P1365 (replaces) |
| The version in which it first appeared | Not stored. Calculated from the version history (git blame) | |

## Example (non-normative)

Q42 P19 (place of birth) Q350, target TRIPLE `#178`. In the 2026-10-19 Wikidata dump this statement has five sources; three are shown. ③, a Telegraph article (`#1358`-`#1367`), has the same shape as ②, and ⑤, Store norske leksikon (Q746368), the same shape as ①, so they are left out.

```
SOURCE     #1347  #178   Q5375741                     ① Britannica: P248 only, no description of the source
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"

TRIPLE     #1350  P50    #1349  Q18145749  normal     ② Guardian article #1349
TRIPLE     #1351  P407   #1349  Q1860      normal
TRIPLE     #1352  P577   #1349  GREGORIAN-DATE(2001-05-15)  normal
TRIPLE     #1353  P854   #1349  <http://www.theguardian.com/news/2001/may/15/guardianobituaries.books>  normal
TRIPLE     #1354  P1433  #1349  Q5614018   normal
TRIPLE     #1355  P1476  #1349  "Obituary: Douglas Adams"@en  normal
SOURCE     #1356  #178   #1349
QUALIFIER  #1357  P813   #1356  GREGORIAN-DATE(2013-12-07)

SOURCE     #1368  #178   #1158                        ④ GND: LOCAL #1158 declared earlier (P248 Q36578, P407 Q188)
QUALIFIER  #1369  P227   #1368  "119033364"
QUALIFIER  #1370  P813   #1368  GREGORIAN-DATE(2022-10-09)
```

- ① has no description of the source and has a single P248, so the source is that item. `#1347` is TAG 1 + Edge Id 2 + Target 2 + Q5375741 3 = 8 WORDs, TAG `13A0`.

```
13A0 0088 0543 0088 00B2 0120 0052 06FD
```

- A source with only one URL: `REFERENCE-NODE #1383 #1384 <http://www.eskimo.com/~rkj/weekly/aa051701a.htm>`, `SOURCE #1385 #180 #1384`.
- A source with only "imported from" English Wikipedia: `SOURCE #n #t ABSENT`, `QUALIFIER P143 #n Q328`. Origin `0x0000` is 1 WORD.

## Open Questions

- GEUL terms (term definition documents and IDs) to express character range, creating party, and confidence.
- When the source description cannot identify the source (a source with only a language, and so on), sharing the same description as one LOCAL would assert that different sources are the same.
- A list of source and citation properties for sources outside Wikidata (statutes, web citations).
- A source of a source (a chain): whether to attach a SOURCE again to a source LOCAL.

## Related Pages

- [Edge](/grammar/edge/), [TRIPLE](/grammar/edge/triple/), [QUALIFIER](/grammar/edge/qualifier/), [REFERENCE-NODE](/grammar/edge/reference-node/), [Slot marker](/grammar/reference/slot-marker/)
- [Document](/grammar/document/) (HEAD and BODY), [Meta — Provenance](/grammar/meta/provenance/)
