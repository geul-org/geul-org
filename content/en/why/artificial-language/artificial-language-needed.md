---
title: "Why Is an Artificial Language Needed?"
weight: 7
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["artificial language", "natural language", "hallucination", "LLVM IR"]
summary: "Natural language evolved for human communication. Ambiguity, redundancy, and implication are strengths for humans but causes of hallucination for AI. Neither programming languages nor existing semantic frameworks are the answer. A new artificial language satisfying six conditions simultaneously is needed."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

## Natural language brought humanity this far. But it can take us no further.

---

## The greatest invention: natural language

The greatest technology ever created by humankind is natural language.

Not the discovery of fire, not the invention of the wheel, not even the semiconductor.
Natural language is what made all of those possible.

Because natural language existed, knowledge could be transmitted.
Because natural language existed, cooperation became possible.
Because natural language existed, the thoughts of the dead could be inherited by the living.

The reason Homo sapiens came to dominate the Earth was not muscle -- it was language.
For tens of thousands of years, natural language has been the medium of every intellectual endeavor.

And now, natural language has become the bottleneck of the AI era.

---

## Why natural language came into being

To understand the problem, we must return to the original purpose of natural language.

Natural language evolved for **real-time communication between humans**.

When early humans were hunting on the savanna,
what was needed to convey "There's a lion over there!" was not
precise logical structure but rapid transmission.

This evolutionary pressure determined every characteristic of natural language.

**Ambiguity is a feature.**
You do not need to know exactly how many meters away "over there" is.
The listener turns their head and sees the lion.
Context compensates for ambiguity.

**Redundancy is a feature.**
Even if half the message is drowned out by wind, the meaning must still get through.
That is why natural language expresses the same idea in multiple ways.

**Implication is a feature.**
In many cultures, a greeting like "Have you eaten?" is not really about food -- it is a way of asking "How are you?"
Shared cultural context decodes the implication.

All of these characteristics are strengths in human-to-human communication.
Fast, flexible, and adaptive to context.

The problem arises when we try to use this for AI.

---

## What natural language means to AI

Current LLMs receive input in natural language, reason in natural language, and produce output in natural language.

This is like conducting a chemistry experiment
while recording every measurement as "quite a lot," "a little," or "roughly this much."

"Admiral Yi Sun-sin was great."

What happens when an AI processes this sentence?

Who said he was great? The speaker? The historical community? Korean society?
By what criteria was he great? Military? Moral? Historical impact?
As of when? His own era? The present day?
How confident is the claim? Fact? Opinion? Speculation?

None of this is specified in the natural language sentence.
It is all merely implied: "figure it out from context."

Humans have tens of thousands of years of evolutionary hardware for decoding these implications.
Facial expressions, tone of voice, shared experience, cultural background.
AI has none of this. It has only text.

So AI guesses. And states its guesses as if they were certainties.
We call this "Hallucination."

Hallucination is not a bug. As long as natural language is used as AI's language of reasoning,
it is a structurally inevitable outcome.

---

## Hallucination is born from the ambiguity of natural language

Let us pinpoint this more precisely.

When an LLM answers "Admiral Yi Sun-sin died in the Battle of Noryang,"
what is the basis for this sentence?

It is because patterns similar to this sentence appeared with high probability in the training data.

But which source those patterns came from,
how reliable that source is,
as of when this information was valid,
whether conflicting accounts exist --
none of this can be structurally conveyed in natural language output.

Natural language has no reserved space for metadata.

"Admiral Yi died in the Battle of Noryang" and
"The Annals of the Joseon Dynasty record that Admiral Yi died in the Battle of Noryang"
are, in natural language, merely two sentences of different lengths.

But epistemologically, they are entirely different kinds of statements.
One is a factual claim; the other is a sourced narration.

Natural language cannot structurally distinguish between the two.
So AI cannot distinguish them either.
So hallucination occurs.

---

## Programming languages are not the answer

"Then why not just use a programming language?"

Programming languages are unambiguous. Structured. Precise.
But programming languages are **languages for describing procedures**,
not **languages for describing the world**.

Try expressing "Admiral Yi Sun-sin was great" in Python:

```python
is_great("Yi Sun-sin") == True
```

This is not a description -- it is a boolean verdict.
Who made the judgment, on what basis, in what context, with what degree of confidence --
programming languages have no structure for any of this.

Data formats like JSON, XML, and RDF are the same.
They have structure, but no unified system for defining the meaning of that structure.
Every project creates its own schema,
and those schemas are incompatible with each other.

Natural language is rich in meaning but lacks structure.
Programming languages have structure but lack meaning.
Data formats have both structure and meaning but lack unification.

What is needed is a different kind of language.

---

## The path shown by LLVM

There is an exact precedent in computer science.

In the 1990s, there were dozens of programming languages
and dozens of processor architectures.
To support every language on every architecture,
N x M compilers were needed.

LLVM's solution was an intermediate representation (IR).

Every language is translated into LLVM IR.
LLVM IR is translated into every architecture.
Only N + M translators are needed.

Users never see LLVM IR.
They write C++ and receive an executable.
LLVM IR works behind the scenes.

GEUL is the LLVM IR for AI.

Every natural language is translated into GEUL.
GEUL is stored in WMS, used for reasoning, and translated back into natural language.
Users never see GEUL.
They ask in natural language and receive answers in natural language.
GEUL works behind the scenes.

---

## The conditions an artificial language must satisfy

To surpass the limitations of natural language without losing its expressive power,
an artificial language must satisfy the following conditions simultaneously.

**1. Elimination of ambiguity**

When "Admiral Yi Sun-sin was great" is input,
"who stated this, in what context, on what basis, with what degree of confidence"
must be structurally specified.
If a field is empty, it must be marked as empty.
No reliance on implication.

**2. Built-in metadata**

Every statement must include source, timestamp, confidence, and point of view (POV)
as part of the statement's own structure, not as separate annotations.
Without this, white-box AI is impossible.

**3. LLM compatibility**

LLMs must be able to "learn" this language.
It does not need to be easy for humans to understand.
What matters is that it is tokenizable, that patterns are regular,
and that it follows a fixed structure.

**4. Graph expressiveness**

The world is not a table -- it is a graph.
Entities are nodes and relationships are edges.
An artificial language must be able to naturally serialize graphs.

**5. Separation of fact and narration**

"Admiral Yi died in 1598" is not a fact.
"The Annals of the Joseon Dynasty recorded that Admiral Yi died in 1598" is the primary data.
An artificial language must structurally enforce this distinction.

**6. Future extensibility**

The system defined today must remain backward-compatible and extensible
ten years from now, a hundred years from now, and in an unimaginable future.

---

## Why existing approaches fall short

This is not the first attempt.

**Esperanto** was an artificial language designed for humans.
It is structured, but it was not designed to carry AI reasoning.
It prioritized ease of learning over precision of meaning.

**OWL/RDF** was a semantic representation system designed for machines.
Logically rigorous, but designed in the pre-LLM era.
Translation to and from natural language is difficult, and expressions are verbose.
And fatally slow -- large-scale reasoning is not practical.

**Knowledge graphs (Wikidata, Freebase)** represented the world as a graph.
But they store "facts," not "narrations."
They store "Admiral Yi was a general" as a triple,
but not who claimed it or how confident they were.

**Chain-of-Thought** records an LLM's reasoning process in natural language.
A good direction, but since the recording medium is natural language,
it cannot fundamentally solve the ambiguity problem.

Each of these approaches satisfies one or two of the conditions,
but none satisfies all six simultaneously.

---

## GEUL: the intersection of six conditions

GEUL stands at the intersection of these six conditions.

A 16-bit word-based stream format.
Context, source, and confidence are structurally built into every statement.
Graphs are serialized through node and edge packets.
It follows fixed patterns that map 1:1 with LLM tokens.
It treats narration (Claim), not fact, as the primary data.
It reserves 50% of the total address space for the future.

GEUL is invisible to users.
Users speak in natural language and receive answers in natural language.
In between, GEUL structures reasoning,
records it, accumulates it, and makes it reusable.

---

## The age of natural language does not end

There is something that must not be misunderstood.

GEUL does not replace natural language.
Humans will continue to speak, write, and think in natural language.
Natural language will survive forever as the language of humanity.

What GEUL replaces is
the role that natural language has been playing inside AI.

The medium of reasoning.
The storage format for knowledge.
The protocol for inter-system communication.

In this role, natural language has already reached its limit.
That limit manifests as hallucination, as black boxes, as inefficiency.

Natural language brought humanity this far.
That achievement is eternal.
But to reach the next stage, a new language is needed.

That is why an artificial language is needed.

---

## Summary

The ambiguity of natural language is a feature in human communication, but a defect in AI reasoning.

1. Natural language has no structural space for metadata.
2. Therefore AI reasons without source, confidence, or context.
3. Therefore hallucination occurs. This is not a bug -- it is structural inevitability.
4. Programming languages describe procedures; they cannot describe the world.
5. Existing semantic representation systems each satisfy only one or two conditions.
6. A new artificial language satisfying all six conditions simultaneously is needed.

Just as LLVM IR is the invisible bridge between programming languages and hardware,
GEUL is the invisible bridge between natural language and AI reasoning.
