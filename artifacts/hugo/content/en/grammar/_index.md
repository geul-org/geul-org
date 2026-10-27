---
title: "GEUL Grammar"
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "specification"]
summary: "The GEUL v1 grammar specification. It defines records on 16-bit words, the four Kinds and all Codecs, the document structure, and the rules for Issuers and publication."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
showContent: true
---

This is the GEUL v1 grammar specification. If you are reading it for the first time, read in the order below.

1. [Overview](/grammar/overview/) — What GEUL is and the principles it is designed on
2. [Records and the TAG WORD](/grammar/record/) — The 16-bit TAG WORD, Kind, Length, Codec
3. [Document](/grammar/document/) — HEAD and BODY, content hash, versions and revisions
4. [Reference](/grammar/reference/), [Value](/grammar/value/), [Edge](/grammar/edge/), [Meta](/grammar/meta/) — The four Kinds
5. [Issuer and Publication](/grammar/issuer/) — The party that issues documents and formats, the 1 WORD assignment table, disclosure methods, signatures and verification keys
6. [Publication Addresses and Version Lists](/grammar/publishing/) — ID notation, publication addresses, format specification, name index, version lists, trust layers
7. [Codec specification document](/grammar/codec-spec/) — How to write a Codec layout as a GEUL document
8. [Example: A Wikidata Item](/grammar/example/) — One real document

This page is the index of all Codecs. Click a name to go to the detail page of that Codec. A name without a link has no detail page yet. A direct code not in the tables is reserved.

## Kind

The TAG WORD is `000K KLLL LCCC CCCC`. `KK` is the Kind, `LLLL` is the Length, and `CCC CCCC` is the 7-bit Codec. For Reference, however, it is a 4-bit Codec and a 3-bit Quantifier.

| Value | Class | Description |
|---|---|---|
| `0000 0LLL LCCC CQQQ` | [Reference](/grammar/reference/) | A record that points to a target. `QQQ` is the Quantifier |
| `0000 1LLL LCCC CCCC` | [Value](/grammar/value/) | A value record |
| `0001 0LLL LCCC CCCC` | [Edge](/grammar/edge/) | A composing record |
| `0001 1LLL LCCC CCCC` | [Meta](/grammar/meta/) | A record about the document and its records |

## Reference

`0000 0LLL LCCC CQQQ` — [Reference](/grammar/reference/)

### Codec (`CCCC`)

| CCCC | Name | Class | Target ID |
|---|---|---|---|
| `0000` | [Slot marker](/grammar/reference/slot-marker/) | Reserved | A set of 1 WORD markers that point to no target. The lower 3 bits are the marker number (table below) |
| `0001` | [LOCAL](/grammar/reference/local/) | Declaration | An ID issued by this document |
| `0010` | [GEUL](/grammar/reference/geul/) | Declaration | An entity issued by geul.org under CC0. Small numbers are assigned to high-frequency entities |
| `0011` | [GEUL-SIDX](/grammar/reference/geul-sidx/) | Declaration | GEUL SIDX (Semantic-aligned Index). An identifier that carries meaning in its bits |
| `0100` | [WIKIDATA-QID](/grammar/reference/wikidata-qid/) | Declaration | A Wikidata item. The integer after `Q` |
| `0101` | [WIKIDATA-PID](/grammar/reference/wikidata-pid/) | Declaration | A Wikidata property. The integer after `P` |
| `0110` | [ISSUER-POINTER](/grammar/reference/issuer-pointer/) | Pointer-declaration | The Issuer itself. The Payload is only the Issuer (1/2/4/16 WORD) and there is no target ID |
| `0111` | [DOC-POINTER](/grammar/reference/doc-pointer/) | Pointer-declaration | One version of an Issuer's document. Issuer + document ID 4 WORD + version ID 2 WORD, no target ID |
| `1000` | [EXTERNAL-POINTER-1WORD](/grammar/reference/external-pointer/) | Pointer | A LOCAL ID of a document imported with `IMPORT-DOC`. IMPORT ID 1 WORD |
| `1001` | [EXTERNAL-POINTER-2WORD](/grammar/reference/external-pointer/) | Pointer | Same as above. IMPORT ID 2 WORD |
| `1010` | [EXTERNAL-POINTER-4WORD](/grammar/reference/external-pointer/) | Pointer | Same as above. IMPORT ID 4 WORD |
| `1011` | [EXTERNAL-POINTER-8WORD](/grammar/reference/external-pointer/) | Pointer | Same as above. IMPORT ID 8 WORD |
| `1100` | [EXTERNAL-ISSUER-1WORD](/grammar/reference/external-issuer/) | Pointer-declaration | A LOCAL ID of a document of a 1 WORD Issuer |
| `1101` | [EXTERNAL-ISSUER-2WORD](/grammar/reference/external-issuer/) | Pointer-declaration | A LOCAL ID of a document of a 2 WORD Issuer |
| `1110` | [EXTERNAL-ISSUER-4WORD](/grammar/reference/external-issuer/) | Pointer-declaration | A LOCAL ID of a document of a 4 WORD Issuer |
| `1111` | [EXTERNAL-ISSUER-16WORD](/grammar/reference/external-issuer/) | Pointer-declaration | A LOCAL ID of a document of a 16 WORD Issuer |

### Slot Marker (Codec `0000`)

`0000 0000 0000 0MMM` — [Slot marker](/grammar/reference/slot-marker/). It comes in a position only when the field's CODEC list has exactly that WORD.

| WORD | Name | Meaning | Wikidata |
|---|---|---|---|
| `0x0000` | [ABSENT](/grammar/reference/slot-marker/) | Not written. An optional field was omitted. Asserts nothing about the world | no snak |
| `0x0001` | [UNKNOWN-VALUE](/grammar/reference/slot-marker/) | Unknown. A value exists, but it is unknown what it is | `somevalue` |
| `0x0002` | [NO-VALUE](/grammar/reference/slot-marker/) | None. There is no value | `novalue` |
| `0x0003`-`0x0007` | Reserved | | |

### Quantifier (`QQQ`)

| QQQ | Name | Meaning | Example |
|---|---|---|---|
| `000` | Identified | An identified individual | Elon Musk, South Korea |
| `001` | Generic | A general or defining statement about a whole kind. Allows exceptions | Soldiers obey orders |
| `010` | Free-choice | Any target that satisfies a condition | Any soldier |
| `011` | Universal | Every target in a given range | All soldiers |
| `100` | Variable | A discourse variable | that person, this woman |
| `101`-`111` | Reserved |  |  |

- In Codec `0000` (slot markers), the lower 3 bits are the marker number, not a Quantifier.

## Issuer

An Issuer is the party that defines documents and formats — [Issuer and Publication](/grammar/issuer/)

| Position | Meaning |
|---|---|
| Value and Edge ISSUER codes (`0x7C`-`0x7F`) | A format defined by that Issuer |
| Meta `DOC-ID` | The Issuer that issued this document |
| Meta `IMPORT-DOC` | The Issuer that issued the imported document |
| Reference `EXTERNAL-ISSUER-*`, `DOC-POINTER` | The Issuer that issued the pointed-to document (1/2/4/16 WORD) |
| Reference `ISSUER-POINTER` | The Issuer being pointed to itself (1/2/4/16 WORD) |

| Issuer width | Issuance |
|---|---|
| 1 WORD | geul.org assigns it to standards bodies and major institutions ([1 WORD Assignment Table](/grammar/issuer/#1-word-assignment-table)). |
| 2 WORD | Registered with geul.org. An Issuer that went through domain ownership proof (for example, company.com) |
| 4 WORD | Registered with geul.org. An Issuer registered without ownership proof |
| 16 WORD | Self-issued. Calculated from a public key with no registration. Follows the generation rule below. |

### 16 WORD Issuer Signature Algorithms

| Signature algorithm ID | Algorithm |
|---|---|
| `0x0001` | Ed25519 |
| Others | Reserved |

## Edge

`0001 0LLL LCCC CCCC` — [Edge](/grammar/edge/)

The upper 2 bits of the Codec are the family. Both direct codes (7 bits) and ISSUER format numbers (16 bits) follow the same rule.

| Upper 2 bits | Family | Direct codes | Format numbers |
|---|---|---|---|
| `00` | Description | `0x00`-`0x1F` | `0x0000`-`0x3FFF` |
| `01` | Evidence | `0x20`-`0x3F` | `0x4000`-`0x7FFF` |
| `10` | Execution | `0x40`-`0x5F` | `0x8000`-`0xBFFF` |
| `11` | [TOULMIN](/grammar/edge/toulmin/) | `0x60`-`0x7B` | `0xC000`-`0xFFFF` |

### Description (`00`)

| CCCCC | Codec | Name | Subformat | Description |
|---|---|---|---|---|
| `00000` | `0x00` | [REFERENCE-NODE](/grammar/edge/reference-node/) |  | A directional binding in which Subject, a Reference, denotes Object |
| `00001` | `0x01` | [SAME-NODE](/grammar/edge/same-node/) |  | Identity: two References denote the same target |
| `00010` | `0x02` | [DIFFERENT-NODE](/grammar/edge/different-node/) |  | Non-identity: two References denote different targets |
| `00011` | `0x03` | [BIND](/grammar/edge/bind/) |  | Binds a name that machines match against (`UTF8-TEXT-*`) to Subject. Unique within its scope, must match exactly, and has no language |
| `00100` | `0x04` | [LABEL](/grammar/edge/label/) |  | Links a per-language name (label) of Subject. Object is UTF8-LANGUAGE-TEXT |
| `00101` | `0x05` | [ALIAS](/grammar/edge/alias/) |  | Links another name (alias) of Subject. The layout is the same as LABEL |
| `00110` | `0x06` | [DESCRIPTION](/grammar/edge/description/) |  | Links a per-language description of Subject. The layout is the same as LABEL |
| `00111` | `0x07` | Reserved |  |  |
| `01000` | `0x08` | VERB-SHORT |  | Abbreviated verb statement |
| `01001` | `0x09` | VERB |  | Verb statement |
| `01010` | `0x0A` | [TRIPLE](/grammar/edge/triple/) |  | A proposition in the order Predicate, Subject, Object, and a rank. Object is a value or the UNKNOWN-VALUE or NO-VALUE marker. Its meaning is everything gathered from the QUALIFIERs that point to its Edge Id |
| `01011` | `0x0B` | [QUALIFIER](/grammar/edge/qualifier/) |  | One condition that qualifies the proposition of another Edge. Property, Target (Edge Id), Value (a value or the UNKNOWN-VALUE or NO-VALUE marker). Part of the proposition |
| `01100`-`01111` | `0x0C`-`0x0F` | Reserved |  |  |
| `10000` | `0x10` | WORLD | Yes | Structure for expressing a worldview |
| `10001` | `0x11` | TIMELINE | Yes | Structure expressing the order of worlds and events |
| `10010` | `0x12` | SCENE | Yes | Scene structure for describing scenario characteristics |
| `10011`-`10111` | `0x13`-`0x17` | Reserved |  |  |
| `11000` | `0x18` | [PUBLICATION](/grammar/edge/publication/) |  | Publication of a document. DOC-POINTER, content hash |
| `11001` | `0x19` | DEPRECATION |  | Deprecation of a published version. DOC-POINTER |
| `11010` | `0x1A` | TOMBSTONE |  | Deletion (tombstone) of a published version. DOC-POINTER, reason category |
| `11011` | `0x1B` | [DECLARE](/grammar/edge/declare/) |  | Declares the Payload composition of one Codec. Target Kind and Codec |
| `11100` | `0x1C` | [FIELD](/grammar/edge/field/) |  | One Payload field. The DECLARE it belongs to, width: record (the Length of the TAG) or raw value of n WORDs |
| `11101` | `0x1D` | [ENUM](/grammar/edge/enum/) |  | One code value of a raw-value field. Field, code value |
| `11110` | `0x1E` | [CODEC](/grammar/edge/codec/) |  | One Kind and Codec a field accepts. Field, target WORD (`000K KLLL LCCC CCCC`, LLLL 0000 exact, 1111 wildcard; slot markers only as exact targets `0000`-`0002`). A record field takes several (a closed list); a raw-value field takes one (that Value without a TAG) |
| `11111` | `0x1F` | Reserved |  |  |

| Upper 2 bits of CCCCC | Group |
|---|---|
| `00` | Pointers and names |
| `01` | Propositions |
| `10` | Structure |
| `11` | Other |

### Evidence (`01`)

| Codec | Name | Subformat | Description |
|---|---|---|---|
| `0x20` | [SOURCE](/grammar/edge/source/) |  | Links one record, or the whole document, to its source. Target (BODY Edge Id; in the HEAD, `0` = the whole document), Origin (Reference, ABSENT, or UNKNOWN-VALUE). The properties of the source go in a TRIPLE with the source as Subject, and the properties of the citation (retrieval date, position, source hash) in QUALIFIERs attached to the SOURCE. The SOURCE for the whole document and its QUALIFIERs are placed in the HEAD |
| `0x21`-`0x3F` | Reserved |  |  |

- Range within the source, creating party, confidence, per-article period in force, and old records are written as QUALIFIERs, and the version in which a record first appeared is calculated from the version history ([SOURCE](/grammar/edge/source/#expressing-other-evidence)).

### Execution (`10`)

| CCCCC | Codec | Name | Description |
|---|---|---|---|
| `00000` | `0x40` | Reserved |  |
| `00001` | `0x41` | FUNCTION-DECLARE | Function declaration. Symbol, parameter symbol list, return type, body (BLOCK) |
| `00010` | `0x42` | TYPE-DECLARE | Type declaration. Symbol and composition (field symbol list, enumeration values, alias target) |
| `00011`-`00111` | `0x43`-`0x47` | Reserved |  |
| `01000` | `0x48` | CONST | Constant expression. One embedded Value |
| `01001` | `0x49` | UNARY | Unary expression. Operator 1 WORD, operand |
| `01010` | `0x4A` | BINARY | Binary expression. Operator 1 WORD, left, right |
| `01011` | `0x4B` | CALL | Call. Target function, argument count, argument × argument count |
| `01100` | `0x4C` | MEMBER | Member access. Target, field symbol |
| `01101` | `0x4D` | INDEX | Index access. Target, index |
| `01110` | `0x4E` | CONSTRUCT | Construct a compound value (list, record). Type, element count, element × element count |
| `01111` | `0x4F` | CONDITIONAL | Conditional expression. Condition, value if true, value if false |
| `10000` | `0x50` | BLOCK | An ordered group of statements. Statement count, statement × statement count |
| `10001` | `0x51` | ASSIGN | Assignment. Target (symbol, MEMBER, INDEX), value |
| `10010` | `0x52` | IF | Conditional branch. Condition, true BLOCK, false (BLOCK or IF, 0 if none) |
| `10011` | `0x53` | SWITCH | Multi-way branch. Target, branch count, (value, BLOCK) × branch count, default BLOCK (0 if none) |
| `10100` | `0x54` | WHILE | Conditional loop. Condition, body BLOCK |
| `10101` | `0x55` | FOREACH | Iteration loop. Element symbol, target, body BLOCK |
| `10110` | `0x56` | JUMP | Loop control. Kind 1 WORD (break, continue), target loop |
| `10111` | `0x57` | RETURN | Return. Value (0 if none) |
| `11000` | `0x58` | RAISE | Raise an error. Error value |
| `11001` | `0x59` | TRY | Error handling. Body BLOCK, error symbol, handler BLOCK, finally BLOCK (0 if none) |
| `11010`-`11111` | `0x5A`-`0x5F` | Reserved |  |

| Upper 2 bits of CCCCC | Group |
|---|---|
| `00` | Declarations |
| `01` | Expressions |
| `10` | Statements |
| `11` | Errors |

### TOULMIN (`11`)

Details: [TOULMIN](/grammar/edge/toulmin/)

| CCCCC | Codec | Name | Description |
|---|---|---|---|
| `00000` | `0x60` | [CASE-DECLARE](/grammar/edge/toulmin/node/) | Case declaration. A judgment graph holding nodes and relations |
| `00001` | `0x61` | [PREDICATE-DECLARE](/grammar/edge/toulmin/expr/) | Predicate declaration. Judgment functions and expressions, criteria (Spec), fact contracts (Ground) |
| `00010` | `0x62` | [SPEC-DECLARE](/grammar/edge/toulmin/node/) | Criterion declaration. Constants and lists (Backing) |
| `00011` | `0x63` | [RULE-DECLARE](/grammar/edge/toulmin/node/) | Claim declaration. Places a predicate in a case as a general rule (Warrant). It can be attacked. |
| `00100` | `0x64` | [COUNTER-DECLARE](/grammar/edge/toulmin/node/) | Rebuttal declaration. Attacks with its own conclusion. The default Level is Fail |
| `00101` | `0x65` | [EXCEPT-DECLARE](/grammar/edge/toulmin/node/) | Exception declaration. Attacks without its own conclusion. The default Level is Review |
| `00110`-`00111` | `0x66`-`0x67` | Reserved |  |
| `01000` | `0x68` | [ATTACKS](/grammar/edge/toulmin/link/) | Attack relation. The attacker's judgment gradually reduces the target's judgment. |
| `01001` | `0x69` | [SUPERSEDES](/grammar/edge/toulmin/link/) | Override relation. If the attacker is Active, it removes the target from aggregation decisively. |
| `01010` | `0x6A` | SUPERSEDE-CHAIN | Priority chain `A > B > C`. An abbreviation of pairwise SUPERSEDES. Layout undecided |
| `01011`-`01111` | `0x6B`-`0x6F` | Reserved |  |
| `10000` | `0x70` | [RUN](/grammar/edge/toulmin/link/) | Execution composition. If the node is Active, it runs a lower case (DAG). |
| `10001` | `0x71` | [DO](/grammar/edge/toulmin/link/) | An action performed when the node is Active |
| `10010` | `0x72` | [DO-ONCE](/grammar/edge/toulmin/link/) | An action performed only once even on retry |
| `10011` | `0x73` | [UNDO](/grammar/edge/toulmin/link/) | The compensating action of a DO (saga). Performed in reverse order if a later step fails. |
| `10100` | `0x74` | [CHECKING](/grammar/edge/toulmin/link/) | A link that only judges, with no side effects |
| `10101` | `0x75` | [ENTRY](/grammar/edge/toulmin/node/) | An external entry point. Runs or judges a case |
| `10110` | `0x76` | [TRIGGER](/grammar/edge/toulmin/node/) | An event or periodic entry point with no external call |
| `10111` | `0x77` | Reserved |  |
| `11000` | `0x78` | VERDICT | The judgment result of a node or record. Result (Pass, Review, Fail), judgment value, Activated, Excluded, Level. Layout undecided. The judgment of the whole document is the Meta [VERDICT](/grammar/meta/verification/verdict/) (`0x44`) |
| `11001` | `0x79` | EVIDENCE | Evidence of a judgment. Position, expected value, actual value (Fact). Layout undecided |
| `11010`-`11011` | `0x7A`-`0x7B` | Reserved |  |
| `111xx` | `0x7C`-`0x7F` | ISSUER-* | Formats defined by an Issuer |

| Upper 2 bits of CCCCC | Group |
|---|---|
| `00` | Declarations |
| `01` | Relations |
| `10` | Execution |
| `11` | Results (`0x7C`-`0x7F` are ISSUER) |

### Edge ISSUER Formats

After `0x7C`-`0x7F` (ISSUER-1/2/4/16WORD), the Codec extension TAG holds the Issuer and format number. The upper 2 bits of the format number are the family. The format number space is separate from Value's.

| Issuer | Format number | Name | Family | Description |
|---|---|---|---|---|
| `0x0000` GEUL | `0xC000` | [SOURCE](/grammar/edge/toulmin/source/) | TOULMIN | Authored source text. SPAN width and UTF8 Value |
| `0x0000` GEUL | `0xC001` | [TEXT](/grammar/edge/toulmin/source/) | TOULMIN | A name or string |
| `0x0000` GEUL | `0xC002` | [SECTION](/grammar/edge/toulmin/source/) | TOULMIN | Start of a section. Section code |
| `0x0000` GEUL | `0xC003` | [CASE-BEGIN](/grammar/edge/toulmin/source/) | TOULMIN | Start of a case range |
| `0x0000` GEUL | `0xC004` | [CASE-END](/grammar/edge/toulmin/source/) | TOULMIN | End of a case range |
| `0x0000` GEUL | `0xC005` | [PROSE](/grammar/edge/toulmin/source/) | TOULMIN | A prose paragraph (SPAN) |
| `0x0000` GEUL | `0xC010` | [NAMESPACE](/grammar/edge/toulmin/node/) | TOULMIN | NODE. `this document is` |
| `0x0000` GEUL | `0xC011` | [FUNC](/grammar/edge/toulmin/node/) | TOULMIN | NODE. Function reference |
| `0x0000` GEUL | `0xC012` | [FIELD](/grammar/edge/toulmin/node/) | TOULMIN | NODE. `is required` |
| `0x0000` GEUL | `0xC013` | [ALIAS](/grammar/edge/toulmin/node/) | TOULMIN | NODE. `see … from` |
| `0x0000` GEUL | `0xC014` | [GROUP](/grammar/edge/toulmin/node/) | TOULMIN | NODE. An ordered execution group |
| `0x0000` GEUL | `0xC020` | [REQUIRES](/grammar/edge/toulmin/link/) | TOULMIN | LINK. case → field |
| `0x0000` GEUL | `0xC021` | [MEANS](/grammar/edge/toulmin/link/) | TOULMIN | LINK. definition item → value or type |
| `0x0000` GEUL | `0xC022` | [HAS](/grammar/edge/toulmin/link/) | TOULMIN | LINK. definition item → field |
| `0x0000` GEUL | `0xC023` | [RUNS](/grammar/edge/toulmin/link/) | TOULMIN | LINK. entry point → case, run |
| `0x0000` GEUL | `0xC024` | [EVALUATES](/grammar/edge/toulmin/link/) | TOULMIN | LINK. entry point → case, judge |
| `0x0000` GEUL | `0xC025` | [TRIGGERS](/grammar/edge/toulmin/link/) | TOULMIN | LINK. trigger → case |
| `0x0000` GEUL | `0xC026` | [UNTIL](/grammar/edge/toulmin/link/) | TOULMIN | LINK. trigger → case (`every … until`) |
| `0x0000` GEUL | `0xC027` | [SAME-AS](/grammar/edge/toulmin/link/) | TOULMIN | LINK. node → global identifier |
| `0x0000` GEUL | `0xC028` | [IMPORTED-FROM](/grammar/edge/toulmin/link/) | TOULMIN | LINK. alias → path (TEXT) |
| `0x0000` GEUL | `0xC029` | [LABEL](/grammar/edge/toulmin/link/) | TOULMIN | LINK. node → TEXT, a name notation |

## Value

`0000 1LLL LCCC CCCC` — [Value](/grammar/value/)

The upper 2 bits of the Codec are the family. NUMERIC and DECIMAL are divided again by the third upper bit (`000` NUMERIC, `001` DECIMAL).

| Upper 2 bits | Family | Direct codes | Format numbers |
|---|---|---|---|
| `00` | [NUMERIC](/grammar/value/numeric/)/[DECIMAL](/grammar/value/decimal/) | `0x00`-`0x1F` | `0x0000`-`0x3FFF` |
| `01` | [TIME](/grammar/value/time/) | `0x20`-`0x3F` | `0x4000`-`0x7FFF` |
| `10` | [TEXT](/grammar/value/text/) | `0x40`-`0x5F` | `0x8000`-`0xBFFF` |
| `11` | [BINARY](/grammar/value/binary/) | `0x60`-`0x7B` | `0xC000`-`0xFFFF` |

### Direct Codes

| Codec | Name | Family | Description |
|---|---|---|---|
| `0x00` | [BOOL](/grammar/value/numeric/bool/) | NUMERIC | A fixed 1 WORD false or true |
| `0x01` | [SIGNED-INTEGER](/grammar/value/numeric/signed-integer/) | NUMERIC | A signed integer in minimal WORDs, two's complement |
| `0x02` | [UNSIGNED-INTEGER](/grammar/value/numeric/unsigned-integer/) | NUMERIC | An integer in minimal WORDs, big-endian unsigned magnitude |
| `0x03` | [BINARY-FLOAT](/grammar/value/numeric/binary-float/) | NUMERIC | An IEEE 754 binary16/32/64/128 scalar with a Payload of 1/2/4/8 WORD |
| `0x04` | [COORDINATE-EARTH](/grammar/value/numeric/coordinate-earth/) | NUMERIC | Earth (WGS 84) latitude and longitude as binary64, uncertainty as binary32, and its unit Reference (ABSENT = unknown) |
| `0x05` | [COORDINATE-GEO](/grammar/value/numeric/coordinate-geo/) | NUMERIC | A celestial body Reference, latitude and longitude as binary64, uncertainty as binary32, and its unit Reference |
| `0x06` | [QUANTITY](/grammar/value/numeric/quantity/) | NUMERIC | A SIGNED-DECIMAL amount, a unit Reference, lower and upper bounds. The unit and bounds can be omitted (ABSENT `0x0000`) |
| `0x07`-`0x0F` | Reserved | NUMERIC |  |
| `0x10` | [SIGNED-DECIMAL](/grammar/value/decimal/signed-decimal/) | DECIMAL | `C×10^E` with a signed exponent `E` and a coefficient `C` in minimal WORDs, two's complement |
| `0x11` | [UNSIGNED-DECIMAL](/grammar/value/decimal/unsigned-decimal/) | DECIMAL | `C×10^E` with a signed exponent `E` and a coefficient `C` in minimal WORDs, unsigned |
| `0x12`-`0x1F` | Reserved | DECIMAL |  |
| `0x20` | [GREGORIAN-DATE](/grammar/value/time/gregorian-date/) | TIME | A signed day count from the proleptic Gregorian `1970-01-01` |
| `0x21` | [CIVIL-TIME-NANOSECONDS](/grammar/value/time/civil-time-nanoseconds/) | TIME | An unsigned nanosecond count after midnight of a civil day |
| `0x22` | [POSIX-TIMESTAMP-SECONDS](/grammar/value/time/posix-timestamp-seconds/) | TIME | A signed second count from the Unix/POSIX epoch |
| `0x23` | [DURATION-SECONDS](/grammar/value/time/duration-seconds/) | TIME | A signed SI-second elapsed time with no epoch |
| `0x24`/`0x25` | [EDTF](/grammar/value/time/edtf/) | TIME | An EDTF (ISO 8601-2) date string. Even and odd bytes. Not used for dates that can be written as GREGORIAN-DATE |
| `0x26`/`0x27` | [GEDCOM-DATE](/grammar/value/time/gedcom-date/) | TIME | A GEDCOM 7 date value string. Keeps the original notation of other calendars (Julian and so on). Even and odd bytes |
| `0x28`-`0x3F` | Reserved | TIME |  |
| `0x40` | [UTF8-TEXT-EVEN](/grammar/value/text/utf8-text/) | TEXT | A valid UTF-8 byte sequence that implies no normalization. Even bytes |
| `0x41` | [UTF8-TEXT-ODD](/grammar/value/text/utf8-text/) | TEXT | Same as above. Odd bytes |
| `0x42`/`0x43` | Reserved | TEXT |  |
| `0x44` | [URI-EVEN](/grammar/value/text/uri/) | TEXT | An ASCII byte sequence of the RFC 3986 `URI` production. Even bytes |
| `0x45` | [URI-ODD](/grammar/value/text/uri/) | TEXT | Same as above. Odd bytes |
| `0x46` | [LANGUAGE-BCP47-CODE-EVEN](/grammar/value/text/language-bcp47-code/) | TEXT | An ASCII byte sequence of a complete BCP 47 language tag in canonical casing. Even bytes |
| `0x47` | [LANGUAGE-BCP47-CODE-ODD](/grammar/value/text/language-bcp47-code/) | TEXT | Same as above. Odd bytes |
| `0x48` | [LANGUAGE-SHORT-CODE](/grammar/value/text/language-short-code/) | TEXT | A GEUL compressed code for a primary language, with a fixed Payload of 1 WORD |
| `0x49` | Reserved | TEXT |  |
| `0x4A`/`0x4B` | [UTF8-LANGUAGE-TEXT](/grammar/value/text/utf8-language-text/) | TEXT | Text with a language. A language Value record (LANGUAGE-SHORT-CODE or LANGUAGE-BCP47-CODE) and UTF-8 bytes. Even or odd text bytes |
| `0x4C`-`0x5F` | Reserved | TEXT |  |
| `0x60` | [UUID](/grammar/value/binary/uuid/) | BINARY | An RFC 9562 UUID of 128 bits, with a fixed Payload of 8 WORD |
| `0x61` | [SHA-256-DIGEST](/grammar/value/binary/sha-256-digest/) | BINARY | A SHA-256 result, with a fixed Payload of 16 WORD |
| `0x62` | [SHA1-DIGEST](/grammar/value/binary/sha1-digest/) | BINARY | A SHA-1 result, with a fixed Payload of 10 WORD. Only for identification, such as git object IDs |
| `0x63`-`0x7B` | Reserved | BINARY |  |
| `0x7C`-`0x7F` | ISSUER-* |  | Formats defined by an Issuer. See Value ISSUER Formats below |

### Value ISSUER Formats

After `0x7C`-`0x7F` (ISSUER-1/2/4/16WORD), the Codec extension TAG holds the Issuer and format number. The upper 2 bits of the format number are the family.

| Issuer | Format number | Name | Family | Description |
|---|---|---|---|---|
| `0x0000` GEUL | `0x4000` | [DURATION-NANOSECONDS](/grammar/value/time/duration-nanoseconds/) | TIME | A signed nanosecond elapsed time with no epoch |
| `0x0000` GEUL | `0xC000` | [OPAQUE-BYTES-EVEN](/grammar/value/binary/opaque-bytes/) | BINARY | A byte sequence of unknown meaning and format. Even bytes |
| `0x0000` GEUL | `0xC001` | [OPAQUE-BYTES-ODD](/grammar/value/binary/opaque-bytes/) | BINARY | Same as above. Odd bytes |
| `0x0000` GEUL | `0xC002` | [BIT-VECTOR](/grammar/value/binary/bit-vector/) | BINARY | N bits stored MSB-first after a bit-count |
| `0x0001` ADHOC | `0x0000` | BFLOAT16 | NUMERIC | BF16 interchange bits, with a fixed Payload of 1 WORD |
| `0x0001` ADHOC | `0x0500` | [DENSE-I16-VECTOR](/grammar/value/vector/dense-i16-vector/) | NUMERIC | A contiguous big-endian int16 vector |
| `0x0001` ADHOC | `0x0501` | [DENSE-U16-VECTOR](/grammar/value/vector/dense-u16-vector/) | NUMERIC | A contiguous big-endian uint16 vector |
| `0x0001` ADHOC | `0x0502` | [DENSE-I32-VECTOR](/grammar/value/vector/dense-i32-vector/) | NUMERIC | A contiguous big-endian int32 vector |
| `0x0001` ADHOC | `0x0503` | [DENSE-U32-VECTOR](/grammar/value/vector/dense-u32-vector/) | NUMERIC | A contiguous big-endian uint32 vector |
| `0x0001` ADHOC | `0x0504` | [DENSE-I64-VECTOR](/grammar/value/vector/dense-i64-vector/) | NUMERIC | A contiguous big-endian int64 vector |
| `0x0001` ADHOC | `0x0505` | [DENSE-U64-VECTOR](/grammar/value/vector/dense-u64-vector/) | NUMERIC | A contiguous big-endian uint64 vector |
| `0x0001` ADHOC | `0x0506` | [DENSE-BINARY16-VECTOR](/grammar/value/vector/dense-binary16-vector/) | NUMERIC | A contiguous IEEE 754 binary16 vector |
| `0x0001` ADHOC | `0x0507` | [DENSE-BFLOAT16-VECTOR](/grammar/value/vector/dense-bfloat16-vector/) | NUMERIC | A contiguous BF16 vector |
| `0x0001` ADHOC | `0x0508` | [DENSE-BINARY32-VECTOR](/grammar/value/vector/dense-binary32-vector/) | NUMERIC | A contiguous IEEE 754 binary32 vector |
| `0x0001` ADHOC | `0x0509` | [DENSE-BINARY64-VECTOR](/grammar/value/vector/dense-binary64-vector/) | NUMERIC | A contiguous IEEE 754 binary64 vector |
| `0x0001` ADHOC | `0x050A` | [POINT2-BINARY64](/grammar/value/vector/point2-binary64/) | NUMERIC | An IEEE binary64 2-dimensional vector in the order `(x,y)` |
| `0x0001` ADHOC | `0x050B` | [POINT3-BINARY64](/grammar/value/vector/point3-binary64/) | NUMERIC | An IEEE binary64 3-dimensional vector in the order `(x,y,z)` |
| `0x0001` ADHOC | `0x050C` | [BBOX2-BINARY64](/grammar/value/vector/bbox2-binary64/) | NUMERIC | An IEEE binary64 vector in the order `(minX,minY,maxX,maxY)` |
| `0x0001` ADHOC | `0x0600` | [DESCRIBED-DENSE-TENSOR](/grammar/value/tensor/described-dense-tensor/) | NUMERIC | element-format, rank, shape, and a C-contiguous dense payload |
| `0x0001` ADHOC | `0x0601` | [DESCRIBED-PACKED-TENSOR](/grammar/value/tensor/described-packed-tensor/) | NUMERIC | packed-format, rank, shape, and a payload packed low-bit-first within each octet |
| `0x0001` ADHOC | `0x0700` | [COMPLEX64](/grammar/value/etc/complex64/) | NUMERIC | Two binary32 in the order `(real, imag)` |
| `0x0001` ADHOC | `0x0701` | [COMPLEX128](/grammar/value/etc/complex128/) | NUMERIC | Two binary64 in the order `(real, imag)` |
| `0x0001` ADHOC | `0x0702` | [RATIONAL-I64](/grammar/value/etc/rational-i64/) | NUMERIC | A normalized int64 numerator and a positive int64 denominator |
| `0x0001` ADHOC | `0x0703` | [CLOSED-INTERVAL-BINARY64](/grammar/value/etc/closed-interval-binary64/) | NUMERIC | A binary64 closed interval with `lower ≤ upper` |
| `0x0001` ADHOC | `0x0704` | [QUATERNION-BINARY32](/grammar/value/etc/quaternion-binary32/) | NUMERIC | Four binary32 in the order `(x,y,z,w)` |
| `0x0001` ADHOC | `0xC000` | [BLAKE3-256-DIGEST](/grammar/value/binary/blake3-256-digest/) | BINARY | The default BLAKE3 result, with a fixed Payload of 16 WORD |
| `0x0020` IETF | `0x8000` | [URI-RELATIVE-REF-EVEN](/grammar/value/text/uri-relative-ref/) | TEXT | An ASCII byte sequence of RFC 3986 relative-ref. Even bytes |
| `0x0020` IETF | `0x8001` | [URI-RELATIVE-REF-ODD](/grammar/value/text/uri-relative-ref/) | TEXT | Same as above. Odd bytes |
| `0x0020` IETF | `0xC000` | [CRC32C](/grammar/value/binary/crc32c/) | BINARY | A Castagnoli CRC-32C result, with a fixed Payload of 2 WORD |
| `0x0020` IETF | `0xC001` | [IPV4-ADDRESS](/grammar/value/binary/ipv4-address/) | BINARY | An IPv4 address of 32 bits, with a fixed Payload of 2 WORD |
| `0x0020` IETF | `0xC002` | [IPV6-ADDRESS](/grammar/value/binary/ipv6-address/) | BINARY | An IPv6 address of 128 bits, with a fixed Payload of 8 WORD |
| `0x0040` IEEE | `0x2000` | [IEEE-DECIMAL32-DPD](/grammar/value/decimal/ieee-decimal32-dpd/) | DECIMAL | IEEE 754 decimal32 DPD, with a fixed Payload of 2 WORD |
| `0x0040` IEEE | `0x2001` | [IEEE-DECIMAL64-DPD](/grammar/value/decimal/ieee-decimal64-dpd/) | DECIMAL | IEEE 754 decimal64 DPD, with a fixed Payload of 4 WORD |
| `0x0040` IEEE | `0x2002` | [IEEE-DECIMAL128-DPD](/grammar/value/decimal/ieee-decimal128-dpd/) | DECIMAL | IEEE 754 decimal128 DPD, with a fixed Payload of 8 WORD |
| `0x0040` IEEE | `0x2003` | [IEEE-DECIMAL32-BID](/grammar/value/decimal/ieee-decimal32-bid/) | DECIMAL | IEEE 754 decimal32 BID, with a fixed Payload of 2 WORD |
| `0x0040` IEEE | `0x2004` | [IEEE-DECIMAL64-BID](/grammar/value/decimal/ieee-decimal64-bid/) | DECIMAL | IEEE 754 decimal64 BID, with a fixed Payload of 4 WORD |
| `0x0040` IEEE | `0x2005` | [IEEE-DECIMAL128-BID](/grammar/value/decimal/ieee-decimal128-bid/) | DECIMAL | IEEE 754 decimal128 BID, with a fixed Payload of 8 WORD |
| `0x0040` IEEE | `0x4000` | [POSIX-TIMESTAMP-NANOSECONDS](/grammar/value/time/posix-timestamp-nanoseconds/) | TIME | A signed nanosecond count from the Unix/POSIX epoch |
| `0x0040` IEEE | `0xC000` | [MAC-48-ADDRESS](/grammar/value/binary/mac-48-address/) | BINARY | An IEEE 802 MAC address of 48 bits, with a fixed Payload of 3 WORD |
| `0x0041` KHRONOS | `0x0000` | [RGBA8-UNORM](/grammar/value/vector/rgba8-unorm/) | NUMERIC | A fixed 4×UNORM8 packed vector in the order R, G, B, A |
| `0x0041` KHRONOS | `0x0001` | [BGRA8-UNORM](/grammar/value/vector/bgra8-unorm/) | NUMERIC | A fixed 4×UNORM8 packed vector in the order B, G, R, A |
| `0x0043` ONNX | `0x0000` | FP8-E4M3FN | NUMERIC | An ONNX E4M3FN scalar in the upper octet of the Payload |
| `0x0043` ONNX | `0x0001` | FP8-E4M3FNUZ | NUMERIC | An ONNX E4M3FNUZ scalar in the upper octet of the Payload |
| `0x0043` ONNX | `0x0002` | FP8-E5M2 | NUMERIC | An ONNX E5M2 scalar in the upper octet of the Payload |
| `0x0043` ONNX | `0x0003` | FP8-E5M2FNUZ | NUMERIC | An ONNX E5M2FNUZ scalar in the upper octet of the Payload |
| `0x0044` OCP | `0x0000` | FP8-E8M0FNU | NUMERIC | An unsigned exponent-only E8M0FNU scalar in the upper octet of the Payload |
| `0x0044` OCP | `0x0001` | FP4-E2M1FN | NUMERIC | An ONNX/DLPack E2M1FN scalar in the upper nibble of the Payload |
| `0x0060` BIPM | `0x4000` | [TAI-TIMESTAMP-SECONDS](/grammar/value/time/tai-timestamp-seconds/) | TIME | A signed SI-second count from `1970-01-01T00:00:00 TAI` |
| `0x0060` BIPM | `0x4001` | [TAI-TIMESTAMP-NANOSECONDS](/grammar/value/time/tai-timestamp-nanoseconds/) | TIME | A signed nanosecond count from the same TAI epoch |
| `0x0062` NIST | `0xC000` | [SHA-512-DIGEST](/grammar/value/binary/sha-512-digest/) | BINARY | A SHA-512 result, with a fixed Payload of 32 WORD |
| `0x0062` NIST | `0xC001` | [SHA3-256-DIGEST](/grammar/value/binary/sha3-256-digest/) | BINARY | A SHA3-256 result, with a fixed Payload of 16 WORD |
| `0x0063` GPS | `0x4000` | [GPS-TIMESTAMP-SECONDS](/grammar/value/time/gps-timestamp-seconds/) | TIME | A signed second count from the GPS epoch |
| `0x0063` GPS | `0x4001` | [GPS-TIMESTAMP-NANOSECONDS](/grammar/value/time/gps-timestamp-nanoseconds/) | TIME | A signed nanosecond count from the GPS epoch |

## Meta

`0001 1LLL LCCC CCCC` — [Meta](/grammar/meta/)

The upper 3 bits of the Codec are the class. Meta has no ISSUER codes.

| Upper 3 bits | Class | Direct codes | What it covers |
|---|---|---|---|
| `000` | [Structure](/grammar/meta/structure/) | `0x00`-`0x0F` | Document boundaries and length |
| `001` | [Declaration](/grammar/meta/declaration/) | `0x10`-`0x1F` | Interpretation declarations |
| `010` | [Provenance](/grammar/meta/provenance/) | `0x20`-`0x2F` | Who, when, where |
| `011` | [Lineage](/grammar/meta/lineage/) | `0x30`-`0x3F` | What it came from and how |
| `100` | [Verification](/grammar/meta/verification/) | `0x40`-`0x4F` | Whether it can be trusted |
| `101` | [Policy](/grammar/meta/policy/) | `0x50`-`0x5F` | How to handle it |
| `110` | [IMPORT](/grammar/meta/import/) | `0x60`-`0x6F` | Imports an external document under an IMPORT ID (`IMPORT-DOC`) |
| `111` | Reserved | `0x70`-`0x7F` |  |

### Structure (`000`)

| Codec | Name | Description |
|---|---|---|
| `0x00` | [DOC-1WORD](/grammar/meta/structure/doc/) | Document start with the total length given in a Payload of 1 WORD |
| `0x01` | [DOC-2WORD](/grammar/meta/structure/doc/) | Document start with the total length given in a Payload of 2 WORD |
| `0x02` | [DOC-4WORD](/grammar/meta/structure/doc/) | Document start with the total length given in a Payload of 4 WORD |
| `0x03`-`0x0D` | Reserved |  |
| `0x0E` | [BODY](/grammar/meta/structure/body/) | 1 WORD. Ends the HEAD of the document and starts the BODY. |
| `0x0F` | [END](/grammar/meta/structure/end/) | 1 WORD. Closes the document. |

### Declaration (`001`)

| Codec | Name | Description |
|---|---|---|
| `0x10` | [SPEC-VERSION](/grammar/meta/declaration/spec-version/) | The GEUL spec version followed. The Payload is itself an unsigned integer in the shortest width. v1 is `0x0001` (record `0x1890 0x0001`) |
| `0x11` | [PROFILE](/grammar/meta/declaration/profile/) | The applied profile |
| `0x12` | [DOC-ID](/grammar/meta/declaration/doc-id/) | The identifier of this document. An embedded Reference `DOC-POINTER` (Issuer, document ID, version 0) |
| `0x13` | [EFFECTIVE-FROM](/grammar/meta/declaration/effective-from/) | The date this version takes effect. A GREGORIAN-DATE or POSIX-TIMESTAMP Value. If absent, the publication time |
| `0x14` | [EFFECTIVE-UNTIL](/grammar/meta/declaration/effective-until/) | The end of this version's period of validity (a temporary law). If absent, until the next version takes effect |
| `0x15` | Reserved |  |
| `0x16` | [DEFAULT-LANGUAGE](/grammar/meta/declaration/default-language/) | The default language |
| `0x17`-`0x1F` | Reserved |  |

### Provenance (`010`)

| Codec | Name | Description |
|---|---|---|
| `0x20` | [AUTHOR](/grammar/meta/provenance/author/) | Author. A Reference (git author) |
| `0x21` | [CO-AUTHOR](/grammar/meta/provenance/co-author/) | Co-author. A Reference (git `Co-authored-by`) |
| `0x22` | [CREATED-AT](/grammar/meta/provenance/created-at/) | Creation time. A TIME Value (git author date) |
| `0x23` | [MODIFIED-AT](/grammar/meta/provenance/modified-at/) | Modification time. A TIME Value |
| `0x24` | [RECORDED-BY](/grammar/meta/provenance/recorded-by/) | The party that recorded it. A Reference (git committer) |
| `0x25` | [RECORDED-AT](/grammar/meta/provenance/recorded-at/) | The time it was recorded. A TIME Value (git commit date) |
| `0x26`-`0x2F` | Reserved |  |

- The source material and its range, time obtained, and hash are written not as Meta but with the HEAD evidence Edge [SOURCE](/grammar/edge/source/#source-of-the-whole-document) (Target `0`) and its QUALIFIERs.

### Lineage (`011`)

| Codec | Name | Description |
|---|---|---|
| `0x30` | [PARENT](/grammar/meta/lineage/parent/) | Content hash of the previous version (git parent). If absent, it is the first version; if several, it is a merge (git merge commit). |
| `0x31` | [DERIVED-FROM](/grammar/meta/lineage/derived-from/) | Derived from records or material of another lineage. To pin a specific version of external material, attach a source hash QUALIFIER (P4092) to the HEAD [SOURCE](/grammar/edge/source/#source-of-the-whole-document) (git submodule). |
| `0x32` | [GENERATED-BY](/grammar/meta/lineage/generated-by/) | The generating party. Person, model, rule engine |
| `0x33` | [TRANSFORMED-BY](/grammar/meta/lineage/transformed-by/) | How it was converted. Tool, rule, version |
| `0x34` | [CHERRY-PICKED-FROM](/grammar/meta/lineage/cherry-picked-from/) | Content hash of the original version from which a change was taken from another lineage (git cherry-pick `-x`) |
| `0x35` | [REVERTS](/grammar/meta/lineage/reverts/) | Content hash of the version whose change was reverted (git revert) |
| `0x36` | [REPLACES](/grammar/meta/lineage/replaces/) | Content hash of the version that was rewritten (git amend, rebase). The original version is not deleted. |
| `0x37` | [SQUASHED-FROM](/grammar/meta/lineage/squashed-from/) | Content hashes of the original versions merged into one (git squash) |
| `0x38` | [MESSAGE](/grammar/meta/lineage/message/) | The reason for the change. A UTF8-LANGUAGE-TEXT Value, one per language (git commit message) |
| `0x39` | [TAG](/grammar/meta/lineage/tag/) | An immutable name attached to a version. A TEXT Value and a content hash (git annotated tag) |
| `0x3A` | [DELTA-BASE](/grammar/meta/lineage/delta-base/) | This version file is a diff against a base version of the same document (2 WORD version ID) (git packfile delta) |
| `0x3B` | [DELTA-REMOVE](/grammar/meta/lineage/delta-remove/) | List of LOCAL IDs (Edge Ids) to remove from the base BODY in a diff |
| `0x3C` | [NEXT-LOCAL-ID](/grammar/meta/lineage/next-local-id/) | The next LOCAL ID to assign (auto increment). Placed in the HEAD of the version list `versions.geul` |
| `0x3D`-`0x3F` | Reserved |  |

### Verification (`100`)

| Codec | Name | Description |
|---|---|---|
| `0x40` | [ISSUER-KEY](/grammar/meta/verification/issuer-key/) | Declares the signature algorithm ID and public key of a self-issued Issuer |
| `0x41` | [SIGNATURE](/grammar/meta/verification/signature/) | A signature over a target. A signature over a document signs the content hash (git signed commits and tags) |
| `0x42` | [SIGNED-OFF](/grammar/meta/verification/signed-off/) | Confirmation of the right to contribute. A Reference (git `Signed-off-by`, DCO) |
| `0x43` | [CONFIDENCE](/grammar/meta/verification/confidence/) | Confidence |
| `0x44` | [VERDICT](/grammar/meta/verification/verdict/) | The judgment result for the whole document. Pass, Review, Fail. At the level of a node or record, [TOULMIN](/grammar/edge/toulmin/) `VERDICT` (Edge `0x78`) |
| `0x45`-`0x4F` | Reserved |  |

### Policy (`101`)

| Codec | Name | Description |
|---|---|---|
| `0x50` | [LICENSE](/grammar/meta/policy/license/) | License. A Reference |
| `0x51` | [ACCESS](/grammar/meta/policy/access/) | Scope of disclosure |
| `0x52` | [PRIVACY](/grammar/meta/policy/privacy/) | Privacy level |
| `0x53` | [RETENTION](/grammar/meta/policy/retention/) | Retention period |
| `0x54` | [CONSENT](/grammar/meta/policy/consent/) | Scope and basis of consent |
| `0x55` | [USAGE](/grammar/meta/policy/usage/) | Usage restrictions |
| `0x56`-`0x5F` | Reserved |  |

### IMPORT (`110`)

| Codec | Name | Description |
|---|---|---|
| `0x60` | [IMPORT-DOC](/grammar/meta/import/import-doc/) | Imports an external document under an IMPORT ID. An embedded Reference `DOC-POINTER` + IMPORT ID |
| `0x61`-`0x6F` | Reserved |  |
