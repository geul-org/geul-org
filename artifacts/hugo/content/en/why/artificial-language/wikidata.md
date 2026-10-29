---
title: "Why Wikidata"
weight: 13
date: 2026-02-26T12:00:17+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["Wikidata", "Ontology", "wikigeul", "SIDX"]
summary: "GEUL does not reject Wikidata. It loads the dump without loss and turns each of about 120 million entities into one GEUL document holding every language. Designing a semantically aligned identifier (SIDX) from its classification and frequency statistics is ongoing research."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

## GEUL does not reject Wikidata. It stands on top of it.

---

## You cannot build a language without a dictionary

Every language needs a vocabulary.

Korean has the Korean dictionary.
English has the English dictionary.
Programming languages have standard libraries.

The same is true for an artificial language.
A list of entities, a list of relations, a list of properties.
What code represents "Samsung Electronics" in this language?
What code represents the relation "capital"?
You need a vocabulary before you can write a sentence.

How do you build this vocabulary?
There are two approaches.

Build it from scratch.
Or use what already exists.

---

## Building from scratch: the lesson of CYC

The CYC project began in 1984.

Its goal was to formalize and store general common-sense knowledge.
The ontology was designed from the ground up.
Concepts were defined, relations were defined, rules were defined.
Experts entered them by hand.

Thirty years passed.
Millions of rules were entered.

Yet it was nowhere near enough to cover the world's knowledge.
A separate ontology had to be designed for each domain.
Maintaining consistency across domains proved difficult.
Every time a new concept emerged, the ontology had to be revised.
Revisions frequently conflicted with existing rules.

What CYC demonstrated was not its potential but its limits.
Having a small team of experts design the world's ontology
becomes unmaintainable at scale.

---

## What already exists: Wikidata

Wikidata started in 2012.

A structured knowledge base run by the Wikimedia Foundation.
Anyone can edit it.
As of the October 19, 2026 dump: about 121.97 million entities.
Of these, 13,991 are properties.
About 1.78 billion statements.
Labels in more than 600 language codes.

What CYC could not achieve in 30 years with teams of experts,
Wikidata achieved in 14 years with a community.

Let us look at what Wikidata has.

**Entity identifiers.** Q-IDs. Samsung Electronics is Q20718. Seoul is Q8684. Yi Sun-sin is Q217300. Globally unique identifiers. Language-independent.

**Property identifiers.** P-IDs. "Headquarters location" is P159. "Inception" is P571. "Population" is P1082. Relations and properties are uniquely identified.

**Hierarchy.** P31 (instance of) and P279 (subclass of) form a type hierarchy. "Seoul → city → human settlement → geographic entity." The world's classification system is expressed through these two properties.

**Multilingual labels.** Q20718 has the Korean label "삼성전자," the English label "Samsung Electronics," and the Japanese label "サムスン電子." One identifier, a different name in each language.

**Community verification.** Editors around the world. Vandalism detection. Source requirements. Not perfect, but more scalable than a small group of experts.

There is no reason to build this from scratch.

---

## GEUL carries Wikidata over as it is

GEUL does not invent new identifiers for Wikidata.
It uses them as they are.

GEUL's grammar has dedicated References for Wikidata.
[WIKIDATA-QID](/grammar/reference/wikidata-qid/) writes the number of a Q-ID, and [WIKIDATA-PID](/grammar/reference/wikidata-pid/) the number of a P-ID, as an unsigned integer.
Q42 is the integer 42. P31 is the integer 31.
Because they are integers, not strings, comparing them for equality needs no normalization.

The path works as follows.

**Step 1: Lossless loading.**
[wikipg](/repos/#wikipg) loads the Wikidata JSON dump into PostgreSQL.
It stores entities, labels, descriptions, aliases, statements, qualifiers, references and sitelinks in dump order,
and keeps every line of the dump verbatim.
It also records the dump file itself (URL, size, checksums, loader commit).
Only when nothing is thrown away can we later check what was carried over and what was skipped.

**Step 2: One document per entity.**
[wikigeul](/repos/#wikigeul) reads the loaded dump and produces one GEUL document for each item and each property.
It holds labels, descriptions, aliases, statements with their qualifiers and references, and sitelinks.
Every language goes into the same document. Nothing is split by language.

All documents share one Issuer, `0x00010000` (wikidata.geul.org).
A document ID is 64 bits. The top byte is the letter of the entity kind, and the low 56 bits are its number.
Q42's document is `0x510000000000002a`. `0x51` is `Q`, and `0x2a` is 42.
P31's document is `0x500000000000001f`.
The hex alone tells you which entity the document is for.
You can read a real document from start to finish in [Example: A Wikidata Item](/grammar/example/).

**Step 3: Citing by integer.**
Inside statements, items and properties are written as integers.
"Q42 is a human (Q5)" is a TRIPLE of three integers: P31, Q42 and Q5.
That integer is the number in the document ID.
From any statement you can go straight to the document of the thing it names.

References are carried over too.
One Wikidata reference becomes one GEUL SOURCE.
The head of each document records which dump it came from and which tool (commit) converted it.

**Step 4: Publishing as pack archives.**
You cannot publish 120 million entities as 120 million files.
Documents are bundled into a pack archive per Issuer, and records are compressed with zstd.
A reader fetches only the documents it needs, not the whole archive.

Right now the conversion is being verified on the range Q1–Q10000.
Round trips through reverse conversion, the archive, and completeness are checked exhaustively.
Full conversion and publication come after that.

---

## SIDX comes next

A Q-ID is a number assigned in order of registration.
Numbers that are close are not close in meaning.
Q42 is Douglas Adams; Q41 is Greece, and Q43 is Turkey.

GEUL is also researching another kind of identifier.
[SIDX](/grammar/reference/geul-sidx/) (Semantic-aligned Index), a semantically aligned identifier that gives close values to things that are close in meaning.
The goal is to put meaning into the bits themselves,
so that the upper bits alone tell you whether something is a person, a place, or an organization.

SIDX is still pre-v1 research.
The grammar only reserves a place for it: the GEUL-SIDX Reference.
Its width is not decided. 64 bits, 256 bits and others are under consideration, and the choice will follow the statistics.
No SIDX has been assigned yet.
So today's Wikidata documents are written with Q-IDs, without SIDX.
Once SIDX values are assigned, an existing identifier and the SIDX of the same thing will be linked with [SAME-NODE](/grammar/edge/same-node/).

This is where Wikidata comes in again.
SIDX research starts from Wikidata's classification system and frequency statistics.
The direction under consideration is this.

**Type extraction.**
Collect the Q-IDs used as objects of P31 (instance of).
This is the list of "types."
"Human (Q5)," "city (Q515)," "country (Q6256)," "enterprise (Q4830453)"...
Count the instances of each type.

**Hierarchy construction.**
Build a tree from the P279 (subclass of) relations between types.
"City → human settlement → geographic entity → entity."
How to handle multiple inheritance, where one type belongs to several parent types, is an open problem.

**Bit assignment.**
The tree structure becomes the prefix relationships of bit patterns.
Subtypes under the same parent share the same prefix.
"City" and "town" share the prefix of "human settlement."
Types with many instances get a shorter prefix, that is, a wider number space.
It is the same idea as Huffman coding.

This is still a hypothesis.
Problems remain to be solved.
An SIDX, once assigned, must not move when the statistics change.
The same value must never be assigned to two things.
The format for publishing the codebook and the registry has to be decided as well.

---

## What Wikidata provides

Along this path, Wikidata provides three things.

**Identifiers.**
The answer to "what in the world are we pointing at?"
Q-IDs and P-IDs become GEUL's integer References as they are.
Wikidata's knowledge can be carried into GEUL documents,
and Wikidata identifiers can be read straight out of GEUL documents.

**Classification system.**
The answer to "what kinds of things exist in the world?"
CYC had a team of experts design this.
GEUL takes it from Wikidata.
The research goal is to turn the classification system that editors have agreed on over 14 years
into the bit tree of SIDX.

**Frequency statistics.**
The answer to "how many of each kind of thing exist in the world?"
If there are 9 million human entities and 1 million asteroids,
the type "human" should receive a more efficient code than "asteroid."
Actual usage frequency becomes the basis for code design.

---

## What Wikidata does not provide

Wikidata is a dictionary. A dictionary is not a language.

A dictionary provides a list of words.
A language provides the grammar for building sentences from words.

What Wikidata does not provide is what GEUL adds.

**From Fact to Claim.**
Wikidata's basic unit is a fact.
"The population of Seoul is 9.74 million."
It is either true or false.

GEUL's basic unit is a claim.
"According to A, the population of Seoul is approximately 9.74 million. (confidence 0.9, as of 2023)"
Who claims it, how certain they are, and as of when are all part of the statement.
This difference is discussed in detail in [Why claims, not facts](/why/claims-not-facts/).

**Verb qualifiers.**
Wikidata has no place to express the nuances of verbs.
In "Yi Sun-sin won the Battle of Myeongnyang,"
where are tense, aspect, evidentiality, mood, and confidence?
In Wikidata, these are partially expressed through qualifiers,
but there is no systematic verb qualification system.

GEUL is designing a verb qualification system that attaches dimensions
such as tense, aspect, polarity, evidentiality, mood, volitionality, and confidence to every statement structurally.
This, too, is pre-v1 work.

**16-bit words.**
Wikidata's representations were not designed for context windows.
JSON-LD, RDF, SPARQL.
Machine-readable, but not token-efficient.

GEUL is a sequence of 16-bit words.
The first word of a record (the TAG WORD) states the kind and length of that record.
Records can be filtered and skipped even without a codebook.
It is a representation built on the premise that the context window is finite.
This was already discussed in [Why not MD/JSON/XML](/why/not-md-json-xml/).

**Context pipeline.**
Wikidata is a store. GEUL is part of a pipeline.
Clarification, verification, filtering, consistency checking, exploration — everything discussed in this series
operates on top of GEUL's structured representation.
Wikidata has no such pipeline.
Nor does it need one. Wikidata has a different purpose.

---

## The relationship between dictionary and language

To put it all together:

Wikidata is the world's vocabulary.
What entities exist,
what relations exist,
what types there are and how they are classified.
A community built this over 14 years.

GEUL puts grammar on top of this vocabulary.
The vocabulary's identifiers → GEUL's integer References.
The vocabulary's entries → one GEUL document per entity.
The vocabulary's classification system and frequency statistics → material for SIDX research.

And it adds what the vocabulary lacks.
Claim structure. Verb qualification. 16-bit words. A context pipeline.

Could GEUL be built without Wikidata?
Yes. You could design an ontology from scratch, as CYC did.
But that was attempted 40 years ago, and the results are in.

Because Wikidata exists, GEUL does not design an ontology.
It carries over a consensus that already exists.

---

## Summary

An artificial language needs a vocabulary.
Building one from scratch was attempted by CYC, and 30 years proved the limits of that approach.

Wikidata is the world's vocabulary, with about 120 million entities and about 1.78 billion statements (October 2026 dump).
A community built it over 14 years.

GEUL carries this vocabulary over as it is.
wikipg loads the dump into PostgreSQL without loss,
and wikigeul turns each entity into one GEUL document holding every language.
Items and properties are cited as integers, and documents are published as pack archives.

SIDX is the research that comes next.
It designs a semantically aligned identifier from P31 instance frequencies and the P279 hierarchy.
Neither its width nor its assignments are settled yet.

Wikidata is a dictionary; GEUL is a language.
A dictionary provides words; a language provides grammar.
GEUL builds claim structure, verb qualification, 16-bit words, and a context pipeline on top of Wikidata's vocabulary.

GEUL does not reject Wikidata.
It stands on top of it.
