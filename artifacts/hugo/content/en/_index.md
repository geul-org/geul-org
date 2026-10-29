---
title: "GEUL"
image: "/images/og-default.webp"
date: 2026-02-26T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
summary: "GEUL is an artificial language and binary format designed for unambiguous communication between humans and AI."
---

## Why GEUL

---

AI has gotten smart. Remarkably so.

But something strange is happening.
The smarter AI gets, the more the quality of information we feed it matters.

Think about it.
Hand AI a hundred pages of internal documents and say "summarize this" --
it does a pretty good job.

But what if those hundred pages contain
a mix of three-year-old data and yesterday's data?
What if sources are unclear?
What if the numbers contradict each other?

AI doesn't know.
It reads everything, trusts everything, blends everything, and answers.

This is not AI's fault.
The information going into AI has no source, no timestamp, no confidence level.
Natural language has no place to put these things.

---

I believe this is a problem of language.

Natural language evolved for humans.
Humans know context. When "recently" was, which "that company" refers to, how confident the speaker is.
So natural language can afford to leave these things out.

AI doesn't know context.
It doesn't know when "recently" was, which "that company" is, or how confident the speaker is.
AI guesses what natural language omits.
Sometimes the guess is right. Sometimes it's wrong.

What about programming languages?
They're precise and unambiguous. But they describe procedures, not the world.
You can't express "Yi Sun-sin was great" in Python.

Human language is ambiguous.
Machine language can't describe the world.
There's a gap between the two.

GEUL is an attempt to fill that gap.

---

GEUL (General Encoding Unified Language) is an artificial language designed for AI.

Every statement has a place for its source.
Every statement has a place for its timestamp.
Every statement has a place for its confidence level.
Every entity has a unique identifier.
The machine knows that "Samsung Electronics" and "Samsung Electronics" are the same thing.

Information written in GEUL can be checked mechanically.
Whether the form is correct and whether references are valid, a machine confirms at once.
Judging whether statements contradict one another is the next step.
Before AI reads it, before a human checks it, a machine inspects it first.

Why does this matter?

AI's context window is finite.
Whether it's 128K tokens or 1M tokens, it's finite.
The quality of information that fits into that finite space determines the quality of the output.
If sourceless, outdated, contradictory information goes in,
the AI's output degrades accordingly.

GEUL is a way to organize the information that goes into AI.

---

King Sejong analyzed sounds and designed letters.
The insight that sounds have structure, and a writing system reflecting that structure is better.

GEUL starts from a similar question.
Meaning has structure too -- wouldn't an expression reflecting that structure be better?

The difference is the audience.
Hangul's audience was humans.
GEUL's audience is AI.

---

This site explains why GEUL is needed.
We're not selling a product. The technical specification lives separately in the [Grammar](/grammar/).
Here we answer the question: "Why?"

Why is natural language not enough?
Why don't programming languages work either?
Why is a field called context engineering necessary?
Why does the information we show AI need structure?

If the answers make sense, GEUL will seem natural.
If they don't, GEUL isn't needed.

The judgment is up to the reader.
