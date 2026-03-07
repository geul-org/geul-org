---
title: "Why WordNet?"
weight: 14
date: 2026-03-01T14:00:00+09:00
lastmod: 2026-03-01T14:00:00+09:00
tags: ["WordNet", "verbs", "semantic primitives", "synset"]
summary: "Building a verb system from scratch means gaps, arbitrary choices, and no justification. WordNet is a 40-year lexical database of 13,767 verb synsets built by linguists. We borrow the dictionary and build the grammar on top."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

We needed verbs.

To let AI describe the world, you need verbs. In "Yi Sun-sin built the turtle ship," without "built" there is no sentence.

For entity identification, there is Wikidata. Yi Sun-sin is Q28090. The turtle ship is Q249845. Identification is already done.

For verbs, there is no equivalent. There is no ID for "build." Whether "build," "construct," and "manufacture" mean the same thing or different things — there is no agreed-upon standard.

Any project that deals with verbs — whether knowledge graphs, semantic search, or structured language design — inevitably faces this question. Where do you get your verb system?

---

## Building from scratch

You could design a verb list from the ground up.

move, give, think, feel, say. Pick around 50 basic verbs and attach sub-verbs beneath them. Under move: walk, run, crawl. Under give: donate, bestow, grant.

Three problems arise.

First, gaps. When a person lists verbs from memory, something always gets left out. You miss "adsorb," you miss "ruminate," you miss "resign oneself." The moment a missing verb is needed, the system breaks.

Second, no criteria. Are walk and stroll separate verbs or variants of the same one? When you build it yourself, this judgment depends on the designer's intuition. Intuition differs from person to person.

Third, arbitrary hierarchy. You put walk under move, but walk is also a sub-type of travel. Where to place it is the designer's decision. That decision has no justification.

A hand-built verb system looks perfect inside the designer's head. To anyone else, it becomes "Why was it classified this way?"

---

## The legacy of WordNet

An English lexical database started at Princeton University in 1985.

For 40 years, linguists have grouped English words into meaning units (synsets) and connected them through hypernym-hyponym relations. There are 13,767 synsets for verbs alone. Each synset has a unique ID, a definition, and explicit relations to other synsets.

"donate" and "bestow" are grouped in the same synset. They mean the same thing.
"donate" is a troponym of "give." It is a specific form of give.
"give" is a troponym of "transfer." It is a specific form of transfer.

This hierarchy already exists for 13,767 verbs.

No gaps. Linguists have been filling it for 40 years.
Clear criteria. Synset definitions and relations are explicit.
Justified hierarchy. Troponym relations are grounded in linguistic analysis.

---

## Dictionary and grammar are different things

If WordNet is the dictionary of verbs, how to use those verbs is a separate matter.

WordNet tells you what "give" means and how it relates to "donate." But it does not tell you how to use "give" in a sentence — who gives, what is given, to whom — that structure is not its job.

This is the same relationship as with Wikidata. Wikidata tells you that Yi Sun-sin is Q28090. But how to compose a sentence about Yi Sun-sin is not Wikidata's responsibility.

Borrow the dictionary; build the grammar yourself.

What to take from WordNet: synset IDs, semantic definitions, troponym hierarchy trees. The verb frames, participant structures, and syntactic patterns that WordNet also provides are better designed by each project on its own. WordNet's syntactic information is English-specific, and a verb's semantic system and a verb's usage are separate problems.

---

## From 13,767 down to 10

Listing all 13,767 WordNet verbs is meaningless. Structure is needed.

Climbing the troponym tree in WordNet, you reach top-level nodes with nowhere further to go. Root verbs. There are 559 of them.

Group the 559 semantically and you get 68 sub-primitives.
Group the 68 further and you get 10 primitives.

```
13,767 verbs → 559 roots → 68 sub-primitives → 10 primitives

BE          — existence, possession, location
PERCEIVE    — perception, detection, discovery
FEEL        — emotion, preference, desire
THINK       — cognition, judgment, memory
CHANGE      — change, beginning, ending
CAUSE       — action, creation, destruction
MOVE        — movement, arrival, departure
COMMUNICATE — utterance, indication, agreement
TRANSFER    — delivery, receipt, exchange
SOCIAL      — cooperation, competition, affiliation
```

These 10 are the semantic primitives of human verbs. They come not from one person's intuition but from the structure of 40 years of WordNet accumulation across 13,767 data points.

This four-level hierarchy — primitives, sub-primitives, roots, individual verbs — allows resolution control. At a coarse level, there are 10 types of action; at a fine level, 13,767. Cut at whatever resolution you need.

---

## Expansion and compression

What if 13,767 is not enough? Add new verbs. Multilingual verbs, neologisms, technical terms. Add them under the relevant sub-primitive. The existing system does not break.

What if 13,767 is too many? Merge synonym synsets into one. Redirect donate → give. Data previously recorded under donate finds its way to give. Same principle as HTTP 301.

What matters is the order. First include everything, actually run it, look at the usage data, then trim. Trimming at a desk without data means cutting away distinctions you actually need.

---

## Beyond: semantic atoms

WordNet's 13,767 verbs are the list of verbs humans have named. Comprehensive, but not the whole story.

"give" can be decomposed further. CAUSE + HAVE + MOVE. Decomposing into semantic primitives. Once this decomposition is complete, even verbs not on the list can be expressed as combinations of atoms.

If WordNet is the standard library, the semantic atom system is the compiler. Just as a compiler can produce functions not in the standard library.

This is a major research undertaking, something to attempt after a WordNet-based system is working. For now, the standard library is enough.

---

## Summary

Every project that tries to build a verb system faces the same question. Where do you get it?

Build it yourself and there are gaps, arbitrariness, and no justification.
Build it on WordNet and there are no gaps, consensus, and data-driven grounding.

WordNet is humanity's verb dictionary, accumulated by linguists over 40 years.
Borrow the words from this dictionary, but build the grammar yourself.
This is why we use Wikidata for entities, and why we use WordNet for verbs.
