---
title: "Edge"
weight: 120
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "An Edge is a record that binds other records as components and makes a statement about them."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

An Edge is a record that binds other records as components and makes a statement about them. A statement such as "Q42 is a human" or "Q42's English name is Douglas Adams" is one Edge.

## Layout {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      Sections 5-13 (0x0A0L~0x1BFL)
[Length extension TAG]
[Codec extension TAG]  for the Issuer form
Edge Id           LOCAL Reference record
Components        in the order set by the Codec
```

- `LLLL` is the total WORD count including the TAG WORD, minus 1. A decoder can skip to the next record from Length alone, without knowing the Codec.
- **The first component is always the Edge Id (a LOCAL Reference).** Because it is a LOCAL Reference (`0051` + ID, Identified `0x005L`), the Edge Id can be read without knowing the codec.
- Each component finds its own boundary through its own Length. The position after the last component must coincide exactly with the end of the Edge.
- The composition (Payload) of the components is set by each Edge Codec document.
- A Codec with subforms (WORLD, TIMELINE, SCENE) specifies the subform with one Codec-specific TAG WORD.
- The order among Edge records carries no meaning (except where a Codec sets it separately, e.g. the [TOULMIN](../toulmin/_index.md) documents).
- Another Edge is pointed to by its Edge Id. An Edge in this document is pointed to as LOCAL; an Edge in another document is pointed to by a pointing Reference (`EXTERNAL-POINTER-*`, `EXTERNAL-ISSUER-*`).

## Families {#계열}

The Edge zone is `0x0A0L~0x1BFL`. The family of a direct code is `(code − 0xA0) >> 5` (the code is the first three digits of the TAG ID). Families are 32 slots each and equal `w >> 9` of the section minus 5. Edge occupies sections 5-13.

| Section | Family | Direct codes | Role |
|---|---|---|---|
| 5 | Statement | `0x0A0L~0x0BFL` | Composes content about the world and events |
| 6 | Evidence | `0x0C0L~0x0DFL` | Where records and documents came from ([SOURCE](0x0C0L-source.md)) |
| 7 | Execution | `0x0E0L~0x0FFL` | Executable program structure (AST) |
| 8 | [TOULMIN](../toulmin/_index.md) | `0x100L~0x11BL` | Argument graph: claims, rebuttals, exceptions, attack relations, execution, verdict results |
| 9 | [TOULMIN](../toulmin/_index.md) form | `0x120L~0x134L` | Source text, sections, auxiliary nodes and relations of a TOULMIN document |

- These five families are the assigned direct codes. `0x11CL~0x11FL` is Reserved, and `0x135L~0x1BCL` is Reserved (sections 10-12 are Reserved in their entirety).
- `0x1BDL~0x1BFL` (the last three slots of section 13) are EDGE-ISSUER (see Issuer-form Edge below). The Issuer form has no family rule.

## Statement Edge {#서술-edge}

| Codec | Name | Components |
|---|---|---|
| `0x0A0L` | [REFERENCE-NODE](0x0A0L-reference-node.md) | A directional binding: Subject (Reference) points to Object |
| `0x0A1L` | [SAME-NODE](0x0A1L-same-node.md) | Two References point to the same target |
| `0x0A2L` | [DIFFERENT-NODE](0x0A2L-different-node.md) | Two References point to different targets |
| `0x0A3L` | [BIND](0x0A3L-bind.md) | Binds a machine-oriented name (UTF8-TEXT) to Subject |
| `0x0A4L` | [LABEL](0x0A4L-label.md) | A per-language name of Subject (UTF8-LANGUAGE-TEXT) |
| `0x0A5L` | [ALIAS](0x0A5L-alias.md) | Another name of Subject. The layout is the same as LABEL |
| `0x0A6L` | [DESCRIPTION](0x0A6L-description.md) | A per-language description of Subject. The layout is the same as LABEL |
| `0x0A8L`/`0x0A9L` | [VERB-SHORT](0x0A8L-verb-short.md) / [VERB](0x0A9L-verb.md) | Verb statement |
| `0x0AAL` | [TRIPLE](0x0AAL-triple.md) | One proposition (Predicate, Subject, Object) with a rank |
| `0x0ABL` | [QUALIFIER](0x0ABL-qualifier.md) | One condition qualifying another Edge's proposition |
| `0x0B0L~0x0B2L` | [WORLD](0x0B0L-world.md) / [TIMELINE](0x0B1L-timeline.md) / [SCENE](0x0B2L-scene.md) | Worldview, event order, scene structure |
| `0x0B8L~0x0BAL` | [PUBLICATION](0x0B8L-publication.md) / [DEPRECATION](0x0B9L-deprecation.md) / [TOMBSTONE](0x0BAL-tombstone.md) | Publication, deprecation advisory, and deletion of a document version ([publication addresses and version list](../publishing.md#버전-목록)) |
| `0x0BBL~0x0BEL` | [DECLARE](0x0BBL-declare.md) / [FIELD](0x0BCL-field.md) / [ENUM](0x0BDL-enum.md) / [CODEC](0x0BEL-codec.md) | Vocabulary for writing Codec specifications ([Codec specification document](../codec-spec.md)) |

- A `-SHORT` form and its general form are placed as an even-odd pair (VERB-SHORT `0x0A8L` / VERB `0x0A9L`). LABEL takes the language as a language record inside Object (UTF8-LANGUAGE-TEXT), so it uses only `0x0A4L`.
- PUBLICATION, DEPRECATION, and TOMBSTONE are used by version-list documents. Because a version list must be readable without a codebook, they are built into the decoder (layer 0 of [publication addresses and version list](../publishing.md#층)).
- DECLARE, FIELD, ENUM, and CODEC are the vocabulary for writing Codec specifications. Because a specification document must be readable without a codebook, their layouts are built into the decoder (layer 0). Each Codec specification document written in that vocabulary is an ordinary document.

### TRIPLE {#triple}

Details: [TRIPLE](0x0AAL-triple.md)

```
TAG WORD          0000 1010 1010 LLLL
[Length extension TAG]
Edge Id           LOCAL Reference
Predicate         Reference (Wikidata property, etc.)
Subject           Reference
Object            Reference or Value
Rank              1 WORD
```

| Rank | Name | Meaning |
|---|---|---|
| `0` | normal | Default |
| `1` | preferred | Current value, the most authoritative value |
| `2` | deprecated | A value judged wrong or outdated but kept as a record |

- Rank is the same as the Wikidata statement rank. A source that assigns no rank uses `0`.
- **The meaning of a TRIPLE is the collection of all QUALIFIERs that point to its Edge Id.** The reader collects the QUALIFIERs before interpreting the TRIPLE.

Example: Q42 — P31 (instance of) — Q5 (human), normal, Edge Id 2

```
0AA9  0051 0002  0191 001F  0141 002A  0141 0005  0000
TAG   #2         P31        Q42        Q5         normal
```

### QUALIFIER {#qualifier}

Details: [QUALIFIER](0x0ABL-qualifier.md)

```
TAG WORD          0000 1010 1011 LLLL
[Length extension TAG]
Edge Id           LOCAL Reference
Property          Reference
Target            LOCAL Reference (Edge Id of the Edge being qualified)
Value             Reference or Value
```

- A QUALIFIER is part of a proposition. It is not a separate claim about the proposition; it qualifies the conditions under which the proposition holds (start and end time, scope of application, etc.).
- A separate claim about a proposition (who asserted it, etc.) is written as a TRIPLE.
- Target is an Edge in the same document. The order of QUALIFIERs with the same Target is their order in the document.

Example: Q42 — P69 (educated at) — Q691283, start (P580) 1971

```
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000   TRIPLE    #3 P69 Q42 Q691283 normal
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731        QUALIFIER #4 P580 #3 EDTF "1971"
```

### LABEL, ALIAS, DESCRIPTION {#label-alias-description}

Details: [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [DESCRIPTION](0x0A6L-description.md)

```
TAG WORD          0000 1010 0100 LLLL   (LABEL)
[Length extension TAG]
Edge Id           LOCAL Reference
Subject           Reference
Object            UTF8-LANGUAGE-TEXT
```

- The name and the language go into one Object (UTF8-LANGUAGE-TEXT).
- There is at most one LABEL per Subject and language. Other names are written as ALIAS.
- A language-less machine-oriented name is written as BIND. A LABEL must have a language.

### BIND {#bind}

Details: [BIND](0x0A3L-bind.md)

- Binds to Subject a name (UTF8-TEXT) that machines match against. It has no language and is not normalized. Names are the same only if their bytes are the same.
- The scope of a name is the document containing the BIND. Within one document, the same name is not bound to different Subjects.
- Other records point by LOCAL ID, not by name. Names are used to match the outside (host functions, address input, people).

### SAME-NODE, DIFFERENT-NODE, REFERENCE-NODE {#same-node-different-node-reference-node}

Details: [SAME-NODE](0x0A1L-same-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

- SAME-NODE is an identity: two References point to the same target. It is reflexive, symmetric, and transitive.
- DIFFERENT-NODE is a non-identity: two References are different targets.
- REFERENCE-NODE is a directional binding that defines, through Object, what Subject (a Reference) is. It is not an identity claim. Example: defining the URI that a LOCAL node points to.

## Evidence Edge {#근거-edge}

Attaches evidence to an individual record in BODY, or to the whole document (HEAD). The evidence family has a single direct code, [SOURCE](0x0C0L-source.md) (`0x0C0L`).

| Codec | Name | Components |
|---|---|---|
| `0x0C0L` | [SOURCE](0x0C0L-source.md) | Target (Edge Id of the BODY Edge to which evidence is attached; in HEAD, `0` = the whole document), Origin (origin Reference, ABSENT or UNKNOWN-VALUE) |
| `0x0C1L~0x0DFL` | Reserved | |

- Properties of the origin itself (URL, title, author, publication date, ...) are written as a TRIPLE whose Subject is the origin. Properties of the citation (access date, location within the origin, ...) are written as a QUALIFIER whose Target is the SOURCE's Edge Id.
- The origin of the whole document is written in HEAD as a SOURCE with Target `0`, and the QUALIFIERs that target it are also placed in HEAD. These are the only Edges that appear in HEAD, and HEAD and BODY share one Edge Id number space ([provenance of the whole document](0x0C0L-source.md#문서-전체의-출처)).
- Other evidence (source text range, creator, confidence, per-article effective period, older records) is written as QUALIFIER, and the version in which a record first entered is computed from the version history ([SOURCE](0x0C0L-source.md#다른-근거의-표현)).
- The verdict result for a single record is handled by TOULMIN `VERDICT`.

### SOURCE {#source}

Details: [SOURCE](0x0C0L-source.md)

```
TAG WORD          0000 1100 0000 LLLL
[Length extension TAG]
Edge Id           LOCAL Reference
Target            LOCAL Reference (Edge Id of the BODY Edge to which evidence is attached; in HEAD, 0 = the whole document)
Origin            Reference or slot marker 0x0000 ABSENT / 0x0010 UNKNOWN-VALUE
```

Example: the provenance of Q42 P19 TRIPLE `#178` is Britannica (Q5375741), with identifier P1417 inside it

```
SOURCE     #1347  #178   Q5375741
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"
```

## Execution Edge {#실행-edge}

A program structure not bound to any particular programming language. Components are pointed to by this document's LOCAL IDs.

| Group | Codec |
|---|---|
| Declaration | [FUNCTION-DECLARE](0x0E1L-function-declare.md), [TYPE-DECLARE](0x0E2L-type-declare.md) |
| Expression | [CONST](0x0E8L-const.md), [UNARY](0x0E9L-unary.md), [BINARY](0x0EAL-binary.md), [CALL](0x0EBL-call.md), [MEMBER](0x0ECL-member.md), [INDEX](0x0EDL-index.md), [CONSTRUCT](0x0EEL-construct.md), [CONDITIONAL](0x0EFL-conditional.md) |
| Statement | [BLOCK](0x0F0L-block.md), [ASSIGN](0x0F1L-assign.md), [IF](0x0F2L-if.md), [SWITCH](0x0F3L-switch.md), [WHILE](0x0F4L-while.md), [FOREACH](0x0F5L-foreach.md), [JUMP](0x0F6L-jump.md), [RETURN](0x0F7L-return.md) |
| Error | [RAISE](0x0F8L-raise.md), [TRY](0x0F9L-try.md) |

- This is not a format that carries foreign-language code as is. Code in an external language is placed in the Issuer form.
- Components are pointed to by this document's LOCAL ID (REF). An expression slot holds an expression Edge or a symbol. REF `0` means none.
- An expression yields a value; a statement does not. An expression may be placed in a statement slot of a BLOCK (the value is discarded).
- A C-style `for` is written as BLOCK (initialization, WHILE), and `else if` as an IF in the false slot.
- A symbol is a LOCAL ID, and its name is bound by BIND. Other records point to a symbol by LOCAL ID, not by name. Even with the same name, different LOCAL IDs are different symbols.
- What a symbol is (variable, parameter, function, type) is determined by the record that points to it. A symbol with no definition in the document is provided from outside (the host); if it is the target of a CALL, it is a host function.

Open problems: operator codes, type representation, and the Payload layout of each Codec.

## TOULMIN Edge {#toulmin-edge}

Writes verdict and execution graphs with the Toulmin argument model. Direct codes are `0x100L~0x11BL`; auxiliary records are in the TOULMIN form family `0x120L~0x134L`. Details: [TOULMIN](../toulmin/_index.md)

## Issuer-form Edge {#issuer-형식-edge}

An Issuer can define and use its own Edge forms ([EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md), [4WORD](0x1BEL-edge-issuer-4word.md), [16WORD](0x1BFL-edge-issuer-16word.md), Codec `0x1BDL`~`0x1BFL`). These are the last three slots of the Edge zone. The Codec extension TAG holds the Issuer and a 2-WORD codec number. The Edge Id is the first element of the Payload that follows (TAG, Issuer, codec number, Edge Id, rest of the Payload). The codec number is set by the Issuer and has no family rule. Regardless of Kind, it does not collide within that Issuer's `codecs/`. The codec document is placed under that Issuer's `codecs/` by the record's codec number ([publication addresses and version list](../publishing.md)).

- No Edge ISSUER form is registered at present.
