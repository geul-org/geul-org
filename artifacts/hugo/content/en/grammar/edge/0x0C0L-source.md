---
title: "SOURCE (0x0C0L)"
weight: 192
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SOURCE is an evidence Edge that links one record (the target) or the whole document to the source it came from."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `SOURCE` (spec document BIND `SOURCE`) |
| TAG ID | `0x0C0L` |
| Codec ID | `0x00000C00` |
| Spec document | `0x00000000/codecs/0x00000C00/` (DECLARE target `0C00`) |
| Section | 6 `0110` (Edge evidence), offset within section C = 0 |
| Kind | Edge · family: evidence |
| TAG WORD | `0000 1100 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Links one record or the whole document to its source. Target (BODY Edge Id; in the HEAD, `0` = the whole document), Origin (Reference, ABSENT, or UNKNOWN-VALUE). The properties of the source go in a TRIPLE with the source as Subject; the properties of the citation (retrieval date, position, source hash) go in a QUALIFIER attached to the SOURCE. The SOURCE for the whole document and its QUALIFIERs are placed in the HEAD |
| Hugo page | `edge/source.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the Payload field order ([Codec spec document](../codec-spec.md)). The Edge Id of an Edge is not declared as a FIELD.

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `target` | #2 | record | `0050` LOCAL |  |
| 2 | `origin` | #3 | record | `000F` all of section 0 (wildcard, Reference), `020F` all of section 1 (wildcard, Reference), `040F` all of section 2 (wildcard, Reference), `0010` UNKNOWN-VALUE, `0000` ABSENT (optional field) |  |

SOURCE is an evidence Edge that links one record (the target) or the whole document to the source it came from. Codec `0x0C0L`. It is the only direct code of the evidence family (`01`).

One Wikidata reference (a bundle of source information) is one SOURCE. If a record has several sources, there are several SOURCEs.

## Layout {#레이아웃}

```
TAG WORD          0000 1100 0000 LLLL
[Length extension TAG]
Edge Id           LOCAL Reference record
Target            LOCAL Reference record (in the BODY, the Edge Id of the Edge the evidence is attached to; in the HEAD, 0 = the whole document)
Origin            Reference record, or the slot marker 0x0000 ABSENT or 0x0010 UNKNOWN-VALUE
```

- Origin points to the source. If there is a Reference that fits the source, use it (WIKIDATA-QID, the DOC-POINTER or EXTERNAL-ISSUER of a GEUL document, and so on); if there is none, it is a LOCAL node of this document.
- If the source information does not describe a source (for example, a Wikidata "imported from" (P143) or a source that has only a retrieval date), Origin is [ABSENT](../slot-marker.md) (not written). The writer merely did not write the source, and asserts nothing about it. The rest of the source stays as it is in the QUALIFIERs.
- [UNKNOWN-VALUE](../slot-marker.md) is used only when the writer asserts "there is a source but I do not know what it is" (a record written by a person and so on). A converter that carries over from source material does not assert what the source did not say, so it uses ABSENT.
- An Origin that is ABSENT or UNKNOWN-VALUE is independent at each occurrence. The sources of two SOURCEs are not read as the same.

## Two layers {#두-층}

Information about a source splits in two. The two are not mixed.

| Layer | What | How to write it | Examples |
|---|---|---|---|
| Source | Properties of the source itself. The same no matter who cites it | A [TRIPLE](0x0AAL-triple.md) with the source as Subject (rank normal) | URL (P854), title (P1476), author (P50, P2093), publication date (P577), published in (P1433), publisher (P123), language (P407) |
| Citation | Properties of the act of this record citing the source | A [QUALIFIER](0x0ABL-qualifier.md) whose Target is the Edge Id of the SOURCE | retrieval date (P813), position within the source (page P304, section P958, external identifiers P227, P1417), imported from (P143), inferred from (P887), source hash (P4092) |

- **The meaning of a SOURCE is the sum of all QUALIFIERs that point to its Edge Id.** Two sources that cite the same source on different days have the same source and different QUALIFIERs.
- A source TRIPLE is an assertion about the source. A property whose layer cannot be decided goes on the citation side (QUALIFIER). Not asserting anything about the source is the safer choice.
- Within a document, the same source is declared once as a single LOCAL, and several SOURCEs point to it together.
- A source described by a URL alone is defined as a [REFERENCE-NODE](0x0A0L-reference-node.md) (LOCAL → URI). This is the same way as for a sitelink document page.

## Interpretation and validity {#해석과-유효성}

- Target and Origin are each exactly one complete record. The cursor after reading Origin must coincide with the end of the Edge.
- Target is a LOCAL Reference. A SOURCE in the BODY points to an Edge Id in the BODY of the same document. `0` (the whole document) is used only by a SOURCE in the HEAD ([Source of the whole document](#문서-전체의-출처)). A SOURCE with Target `0` in the BODY is invalid. Evidence for a record of another document is attached within that document.
- Origin is a Reference. As slot markers it accepts only `0x0000` (ABSENT) and `0x0010` (UNKNOWN-VALUE). It does not accept NO-VALUE (`0x0020`) or a Value.
- The geul.org spec document `0x00000000/codecs/0x00000C00` (name `source`) puts [CODEC](0x0BEL-codec.md) LOCAL (`0050`) on Target, and CODEC `000F`, `020F`, `040F` (any Reference), `0000` (ABSENT, optional), and `0010` (UNKNOWN-VALUE) on Origin.
- The order among SOURCEs of the same Target has no meaning. The order of items within one source has no meaning either (the order of values of the same property remains as the document order).
- A SOURCE does not change whether its target is true or false. It only records where the target came from. The judgment result is the job of [TOULMIN](../toulmin/_index.md) `VERDICT`.

## Source of the whole document {#문서-전체의-출처}

The source of the whole document (the original dump, the edition, the source text file) is written as a **SOURCE with Target `0` in the HEAD**. QUALIFIERs whose Target is that SOURCE (source hash P4092, received time P813, source range, and so on) are also placed in the HEAD ([Document](../document.md#head와-body)).

- These two are the only Edges that can be placed in the HEAD. All other Edges go in the BODY.
- A QUALIFIER in the HEAD is placed after the HEAD SOURCE it points to. The decoder reads from the front and separates the HEAD from the BODY.
- A QUALIFIER in the BODY whose Target is a HEAD SOURCE is invalid. A SOURCE or QUALIFIER in the BODY does not point to an Edge in the HEAD.
- **The HEAD and the BODY share one Edge Id number space.** An Edge Id is unique within the document, is taken from [NEXT-LOCAL-ID](../meta/0x1DDL-next-local-id.md) like other Edges, and when the document is rebuilt with the same content it inherits the same number. Even in a version from which a HEAD Edge is missing, that number is not reused.
- If Origin is LOCAL, its definition (REFERENCE-NODE, source TRIPLE) goes in the BODY. LOCAL has the whole document as its scope.
- A HEAD Edge is not a verification-class Meta, so it enters the [content hash](../document.md#내용-해시). In a diff it changes together with the HEAD as a whole (it is not written in `DELTA-REMOVE`).
- There is no separate Meta for the source of the whole document. With a Meta, the source range or acquisition time cannot be tied to one of several sources. A QUALIFIER attached to a SOURCE fixes that by its Target.

Example: the HEAD of a Q42 document converted from a Wikidata dump (Edge Ids are for illustration).

```
SPEC-VERSION  0x0001
DOC-ID        0x00000001/0x510000000000002A
TRANSFORMED-BY …
#1738 SOURCE     #0     #1735                                         entity revision
#1741 SOURCE     #0     #1740                                         dump file
#1742 QUALIFIER  P4092  #1741  SHA-256-DIGEST(0xA249…0774)            file hash
#1743 QUALIFIER  P813   #1741  POSIX-TIMESTAMP-SECONDS(1792996483)    received time
BODY
#1736 TRIPLE     P577   #1735  POSIX-TIMESTAMP-SECONDS(1792210885) normal                      revision saved time
#1737 TRIPLE     P854   #1735  <https://www.wikidata.org/w/index.php?oldid=2557857485> normal  revision permalink
#1739 REFERENCE-NODE    #1740  <https://dumps.wikimedia.org/wikidatawiki/entities/20261019/wikidata-20261019-all.json.bz2>
…
```

- The revision and the dump are different sources, so there are two SOURCEs. The revision is the source of the content (the same content can be fetched again through the permalink), and the dump is the file in which that revision was received. The file hash and received time are citation-side properties of the dump file, so they attach to the dump SOURCE.

## Expressing other evidence {#다른-근거의-표현}

Only SOURCE is placed in the evidence family. Other evidence is written as QUALIFIERs.

| Evidence | How to write it | Property |
|---|---|---|
| Range within the source text | QUALIFIER on a SOURCE. One SOURCE per range | page P304, section P958, quotation P1683. Character range is a GEUL term (undecided) |
| Time the source material was received | QUALIFIER on a SOURCE | retrieval date P813 |
| Hash of the source bytes (pins the edition) | QUALIFIER on a SOURCE | checksum P4092, value such as [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md) |
| Creating agent (person, model, rule engine) | QUALIFIER on the SOURCE (the agent that made the citation) or on the target | GEUL term (undecided) |
| Confidence | QUALIFIER on the target | GEUL term (undecided), value 0 to 1 like Meta [CONFIDENCE](../meta/0x1E8L-confidence.md) |
| Validity period per article | QUALIFIER on the target | start P580, end P582 |
| Old record before a move, split, or merge | QUALIFIER on the target, value is the old Edge Id (LOCAL) | P1365 (replaces) |
| Version of first entry | Not stored. Computed from the version history (git blame) | |

## Example (non-normative) {#예시-비규범}

Q42 P19 (place of birth) Q350, target TRIPLE `#178`. In the 2026-10-19 Wikidata dump this statement has five sources, of which three are shown. ③ the Telegraph article (`#1358` to `#1367`) has the same shape as ②, and ⑤ Store norske leksikon (Q746368) the same as ①, so they are omitted.

```
SOURCE     #1347  #178   Q5375741                     ① Britannica: P248 alone, no source description
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

- ① has no source description and only one P248, so the source is that item. `#1347` is TAG 1 + Edge Id 2 + Target 2 + Q5375741 3 = 8 WORD, TAG `0C07`.

```
0C07 0051 0543 0051 00B2 0142 0052 06FD
```

- A source that is a URL alone: `REFERENCE-NODE #1383 #1384 <http://www.eskimo.com/~rkj/weekly/aa051701a.htm>`, `SOURCE #1385 #180 #1384`.
- A source that is only "imported from" English Wikipedia: `SOURCE #n #t ABSENT`, `QUALIFIER P143 #n Q328`. Origin `0x0000` is 1 WORD.

## Open problems {#열린-문제}

- GEUL terms to express character range, creating agent, and confidence (term definition documents and IDs).
- When a source description does not identify the source (a source with only a language, and so on), sharing the same description as one LOCAL would assert that different sources are the same.
- A list of source and citation properties for sources outside Wikidata (statutes, web citations).
- Source of a source (chain): whether to attach a SOURCE again to the source LOCAL.

## Related pages {#관련-페이지}

- [Edge](_index.md), [TRIPLE](0x0AAL-triple.md), [QUALIFIER](0x0ABL-qualifier.md), [REFERENCE-NODE](0x0A0L-reference-node.md), [Slot markers](../slot-marker.md)
- [Document](../document.md) (HEAD and BODY), [Meta — Source](../meta/_index.md#출처)

## Spec document source text {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000C00/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000C0000000000
BODY
#1 DECLARE 0x0C00
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "SOURCE"
#5 BIND #2 "target"
#6 BIND #3 "origin"
#7 CODEC #2 0x0050
#8 CODEC #3 0x000F
#11 CODEC #3 0x020F
#12 CODEC #3 0x040F
#9 CODEC #3 0x0010
#10 CODEC #3 0x0000
```
