---
title: "Edge"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "An Edge is a record that binds References, Values, and other Edges to make a statement. Its first component is always the Edge Id, and the upper 2 bits of the Codec give the family (description, evidence, execution, TOULMIN)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

An Edge is a record that binds other records as components to make a statement. A statement such as "Q42 is a human" or "The English name of Q42 is Douglas Adams" is one Edge.

## Layout

```
TAG WORD          0001 0LLL LCCC CCCC
[Length extension TAG]
[Codec extension TAG]  for an Issuer format
Edge Id           LOCAL Reference record
Components        in the order the Codec sets
```

- `LLLL` is the total WORD count including the TAG WORD, minus 1. A decoder skips to the next record from the Length alone, without knowing the Codec.
- **The first component is always the Edge Id (a LOCAL Reference).** Since it is a LOCAL Reference (`0088` + ID, Quantifier `000`), the Edge Id can be read without knowing the codec.
- Each component finds its boundary with its own Length. The position after reading the last component must match the end of the Edge exactly.
- The composition (Payload) of the components is set by each Edge Codec page.
- For Codecs that have subformats (WORLD, TIMELINE, SCENE), one Codec-specific TAG WORD specifies the subformat.
- The order among Edge records has no meaning (except where a Codec sets it separately, for example the [TOULMIN](/grammar/edge/toulmin/) pages).
- Another Edge is pointed to by its Edge Id. An Edge in this document is pointed to with a LOCAL, and an Edge in another document with a pointer Reference (`EXTERNAL-POINTER-*`, `EXTERNAL-ISSUER-*`).

## Families

| Upper 2 bits | Family | Direct codes | What it does |
|---|---|---|---|
| `00` | Description | `0x00`-`0x1F` | Builds content about the world and events |
| `01` | Evidence | `0x20`-`0x3F` | Where records and documents came from ([SOURCE](/grammar/edge/source/)) |
| `10` | Execution | `0x40`-`0x5F` | An executable program structure (AST) |
| `11` | [TOULMIN](/grammar/edge/toulmin/) | `0x60`-`0x7B` | Argument graph: claims, rebuttals, exceptions, attack relations, execution, judgment results |

## Description Edges

| Codec | Name | Components |
|---|---|---|
| `0x00` | [REFERENCE-NODE](/grammar/edge/reference-node/) | A directional binding saying that Subject (Reference) denotes Object |
| `0x01` | [SAME-NODE](/grammar/edge/same-node/) | Two References denote the same target |
| `0x02` | [DIFFERENT-NODE](/grammar/edge/different-node/) | Two References denote different targets |
| `0x03` | [BIND](/grammar/edge/bind/) | Binds a machine-oriented name (UTF8-TEXT) to Subject |
| `0x04` | [LABEL](/grammar/edge/label/) | A per-language name of Subject (UTF8-LANGUAGE-TEXT) |
| `0x05` | [ALIAS](/grammar/edge/alias/) | Another name of Subject. The layout is the same as LABEL |
| `0x06` | [DESCRIPTION](/grammar/edge/description/) | A per-language description of Subject. The layout is the same as LABEL |
| `0x08`/`0x09` | VERB-SHORT / VERB | Verb statement |
| `0x0A` | [TRIPLE](/grammar/edge/triple/) | One proposition (Predicate, Subject, Object) and a rank |
| `0x0B` | [QUALIFIER](/grammar/edge/qualifier/) | One condition that qualifies the proposition of another Edge |
| `0x10`-`0x12` | WORLD / TIMELINE / SCENE | Worldview, event order, scene structure |
| `0x18`-`0x1A` | [PUBLICATION](/grammar/edge/publication/) / DEPRECATION / TOMBSTONE | Publication, deprecation advisory, and deletion of document versions ([Publication Addresses and Version Lists](/grammar/publishing/#version-lists)) |
| `0x1B`-`0x1E` | [DECLARE](/grammar/edge/declare/) / [FIELD](/grammar/edge/field/) / [ENUM](/grammar/edge/enum/) / [CODEC](/grammar/edge/codec/) | The vocabulary for writing Codec specifications ([Codec specification document](/grammar/codec-spec/)) |

- A `-SHORT` form and the general form are placed as an even-odd pair (VERB-SHORT `0x08` / VERB `0x09`). LABEL takes the language inside the language record in Object (UTF8-LANGUAGE-TEXT), so only `0x04` is used.
- PUBLICATION, DEPRECATION, and TOMBSTONE are written by the version list document. The version list must be readable without a codebook, so they are built into the decoder (Layer 0 in [Publication Addresses and Version Lists](/grammar/publishing/#layers)).
- DECLARE, FIELD, ENUM, and CODEC are the vocabulary for writing Codec specifications. A specification document must be readable without a codebook, so their layouts are built into the decoder (Layer 0). Each Codec specification document written in that vocabulary is an ordinary document.

### TRIPLE

Details: [TRIPLE](/grammar/edge/triple/)

```
TAG WORD          0001 0LLL L000 1010
[Length extension TAG]
Edge Id           LOCAL Reference
Predicate         Reference (a Wikidata property and so on)
Subject           Reference
Object            Reference or Value
Rank              1 WORD
```

| Rank | Name | Meaning |
|---|---|---|
| `0` | normal | Default |
| `1` | preferred | The current value, the most authoritative value |
| `2` | deprecated | A value judged wrong or outdated but kept as a record |

- Rank is the same as the Wikidata statement rank. A source that does not assign ranks uses `0`.
- **The meaning of a TRIPLE is everything gathered from the QUALIFIERs that point to its Edge Id.** The reader gathers the QUALIFIERs before interpreting the TRIPLE.

Example: Q42 — P31 (instance of) — Q5 (human), normal, Edge Id 2

```
148A  0088 0002  00A8 001F  00A0 002A  00A0 0005  0000
TAG   #2         P31        Q42        Q5         normal
```

### QUALIFIER

Details: [QUALIFIER](/grammar/edge/qualifier/)

```
TAG WORD          0001 0LLL L000 1011
[Length extension TAG]
Edge Id           LOCAL Reference
Property          Reference
Target            LOCAL Reference (the Edge Id of the Edge being qualified)
Value             Reference or Value
```

- A QUALIFIER is part of a proposition. It is not a separate claim about the proposition; it qualifies the conditions under which the proposition is true (start and end time, scope of application, and so on).
- A separate claim about a proposition (who claimed it and so on) is written as a TRIPLE.
- Target is an Edge in the same document. The order of QUALIFIERs with the same Target is the order in the document.

Example: Q42 — P69 (educated at) — Q691283, start (P580) 1971

```
150A 0088 0003 00A8 0045 00A0 002A 0120 000A 8C53 0000   TRIPLE    #3 P69 Q42 Q691283 normal
148B 0088 0004 00A8 0244 0088 0003 0924 3139 3731        QUALIFIER #4 P580 #3 EDTF "1971"
```

### LABEL, ALIAS, DESCRIPTION

Details: [LABEL](/grammar/edge/label/), [ALIAS](/grammar/edge/alias/), [DESCRIPTION](/grammar/edge/description/)

```
TAG WORD          0001 0LLL L000 0100   (LABEL)
[Length extension TAG]
Edge Id           LOCAL Reference
Subject           Reference
Object            UTF8-LANGUAGE-TEXT
```

- The name and its language are held in one Object (UTF8-LANGUAGE-TEXT).
- There is at most one LABEL per Subject and language. Other names are written as ALIAS.
- A machine-oriented name with no language is written as BIND. A LABEL must have a language.

### BIND

Details: [BIND](/grammar/edge/bind/)

- Binds a name that machines match against (UTF8-TEXT) to Subject. It has no language and is not normalized. Names are the same only if the bytes are the same.
- The scope of a name is the document that holds the BIND. The same name is not bound to different Subjects in one document.
- Other records are pointed to by LOCAL ID, not by name. A name is used to match the outside (host functions, address input, people).

### SAME-NODE, DIFFERENT-NODE, REFERENCE-NODE

Details: [SAME-NODE](/grammar/edge/same-node/), [DIFFERENT-NODE](/grammar/edge/different-node/), [REFERENCE-NODE](/grammar/edge/reference-node/)

- SAME-NODE is the identity that two References point to the same target. It is reflexive, symmetric, and transitive.
- DIFFERENT-NODE is the non-identity that two References are different targets.
- REFERENCE-NODE is a directional binding that defines what Subject (a Reference) is, by Object. It is not an identity claim. For example, it defines the URI that a LOCAL node points to.

## Evidence Edges

Attaches evidence to an individual record inside the BODY, or to the whole document (HEAD). The only direct code of the evidence family is [SOURCE](/grammar/edge/source/) (`0x20`).

| Codec | Name | Components |
|---|---|---|
| `0x20` | [SOURCE](/grammar/edge/source/) | Target (the Edge Id of the BODY Edge the evidence is attached to; in the HEAD, `0` = the whole document), Origin (a source Reference, ABSENT, or UNKNOWN-VALUE) |
| `0x21`-`0x3F` | Reserved | |

- The properties of the source itself (URL, title, author, publication date, and so on) are written as a TRIPLE with the source as Subject, and the properties of the citation (retrieval date, position within the source, and so on) as a QUALIFIER whose Target is the Edge Id of the SOURCE.
- The source of the whole document is written in the HEAD as a SOURCE with Target `0`, and the QUALIFIERs that have it as their Target are also placed in the HEAD. These are the only Edges that come in the HEAD, and the HEAD and the BODY share one Edge Id number space ([Source of the Whole Document](/grammar/edge/source/#source-of-the-whole-document)).
- Other evidence (range within the source, creating party, confidence, per-article period in force, old records) is written as a QUALIFIER, and the version in which a record first appeared is calculated from the version history ([SOURCE](/grammar/edge/source/#expressing-other-evidence)).
- The judgment result for an individual record is handled by TOULMIN `VERDICT`.

### SOURCE

Details: [SOURCE](/grammar/edge/source/)

```
TAG WORD          0001 0LLL L010 0000
[Length extension TAG]
Edge Id           LOCAL Reference
Target            LOCAL Reference (the Edge Id of the BODY Edge the evidence is attached to; in the HEAD, 0 = the whole document)
Origin            Reference, or the slot marker 0x0000 ABSENT or 0x0001 UNKNOWN-VALUE
```

Example: the source of the Q42 P19 TRIPLE `#178` is Encyclopaedia Britannica (Q5375741), with the identifier P1417 inside it

```
SOURCE     #1347  #178   Q5375741
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"
```

## Execution Edges

A program structure not tied to a particular programming language. Components are pointed to by LOCAL ID of this document.

| Group | Codecs |
|---|---|
| Declarations | FUNCTION-DECLARE, TYPE-DECLARE |
| Expressions | CONST, UNARY, BINARY, CALL, MEMBER, INDEX, CONSTRUCT, CONDITIONAL |
| Statements | BLOCK, ASSIGN, IF, SWITCH, WHILE, FOREACH, JUMP, RETURN |
| Errors | RAISE, TRY |

- It is not a format that holds the code of an outside language as it is. The code of an outside language is placed in an Issuer format.
- Components are pointed to by LOCAL ID (REF) of this document. An expression position holds an expression Edge or a symbol. REF `0` means none.
- An expression yields a value; a statement does not. An expression can be placed in a statement position of a BLOCK (the value is discarded).
- A C-style `for` is written as BLOCK (initialization, WHILE), and `else if` as an IF in the false position.
- A symbol is a LOCAL ID, and its name is bound with BIND. Other records point to a symbol by LOCAL ID, not by name. Even if the names are the same, symbols with different LOCAL IDs are different symbols.
- What a symbol is (variable, parameter, function, type) is set by the record that points to it. A symbol with no definition in the document is provided by the outside (the host); if it is the target of a CALL, it is a host function.

Open questions: operator codes, type representation, and the Payload layout of each Codec.

## TOULMIN Edges

Details: [TOULMIN](/grammar/edge/toulmin/)

Writes judgment and execution graphs with the Toulmin model of argument. This is the core family that lets GEUL describe its own rules in GEUL and correct itself.

| Group | Codecs |
|---|---|
| Declarations | CASE-DECLARE (case), [PREDICATE-DECLARE](/grammar/edge/toulmin/expr/) (predicate), SPEC-DECLARE (criterion), RULE-DECLARE (claim), COUNTER-DECLARE (rebuttal), EXCEPT-DECLARE (exception) — [NODE](/grammar/edge/toulmin/node/) |
| Relations | ATTACKS (attack), SUPERSEDES (override) — [LINK](/grammar/edge/toulmin/link/), SUPERSEDE-CHAIN (priority chain, layout undecided) |
| Execution | RUN, DO, DO-ONCE, UNDO, CHECKING — [LINK](/grammar/edge/toulmin/link/), ENTRY, TRIGGER — [NODE](/grammar/edge/toulmin/node/) |
| Results | VERDICT (judgment result: Pass, Review, Fail), EVIDENCE (evidence of the judgment) — layout undecided |

- The source text, sections, auxiliary nodes, and relations are the ISSUER formats (`0xC000`-`0xC029`) of the GEUL Issuer ([SOURCE and Sections](/grammar/edge/toulmin/source/)).
- A judgment result is placed in a document different from the one being judged. The result document imports the target document and points to it. So judging does not change the content hash of the target document.

## Issuer Format Edges

An Issuer can define and use its own Edge formats (Codec `0x7C`-`0x7F`). The direct codes `0x7C`-`0x7F` lie inside the TOULMIN range but are common ISSUER codes, and the family is set by the upper 2 bits of the format number.

| Issuer | Format numbers | Names | Family |
|---|---|---|---|
| `0x0000` GEUL | `0xC000`-`0xC005` | [SOURCE, TEXT, SECTION, CASE-BEGIN, CASE-END, PROSE](/grammar/edge/toulmin/source/) | TOULMIN |
| `0x0000` GEUL | `0xC010`-`0xC014` | [NAMESPACE, FUNC, FIELD, ALIAS, GROUP](/grammar/edge/toulmin/node/) | TOULMIN |
| `0x0000` GEUL | `0xC020`-`0xC029` | [REQUIRES … LABEL](/grammar/edge/toulmin/link/) | TOULMIN |
