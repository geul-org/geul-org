---
title: "Why 16-Bit?"
weight: 17
date: 2026-02-26T12:00:04+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["16-bit", "binary", "stream"]
summary: "A single 16-bit word is designed to be the unit of three worlds: the network stream, the file format, and the LLM vocabulary. Why 16 bits, and not 8, 32, or variable length."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

## A Single Word Penetrates Three Worlds

---

## Three Worlds

There are three worlds in computer science.

**The world of networks.**
Data flows as byte streams.
Bytes come in through TCP sockets, and bytes go out.
The network engineer's vocabulary is packets, headers, and payloads.

**The world of storage.**
Data is persisted in file formats.
Written to disk, read from disk.
The storage engineer's vocabulary is blocks, offsets, and alignment.

**The world of AI.**
Data is processed as token sequences.
LLMs take tokens in and produce tokens out.
The AI engineer's vocabulary is embeddings, attention, and context.

These three worlds speak different languages.
And between them, translation is always required.

---

## The Cost of Translation

Let us trace the path data travels through a modern AI system.

Knowledge is stored in a file. As JSON or plain text.

To deliver this to an AI:

1. Open the file and read the text.
2. Parse the text. If it is JSON, interpret the structure and extract fields.
3. Feed the extracted text into a tokenizer.
4. The tokenizer converts the text into a sequence of token IDs.
5. The token sequence is fed into the LLM.

When the AI generates a response:

6. The LLM outputs a token sequence.
7. Decode the tokens back into text.
8. Serialize the text into a structured format.
9. Write the serialized data to a file.

A simple "read and write" operation requires nine steps.

Every step costs time.
Every step costs memory.
Every step risks information loss.

Steps 3 and 4 -- the tokenization process -- are notoriously problematic.
Because natural language word boundaries do not align with tokenizer token boundaries,
a proper noun like "Yi Sun-sin" may be split into arbitrary fragments,
or a single semantic unit gets scattered across multiple tokens.

This is the price of three worlds speaking different languages.

---

## What If a Single Unit Penetrated All Three Worlds?

In this language, one word is 16 bits (2 bytes).

A single 16-bit word is designed to play three roles at once.

**A unit of the byte stream.**
16-bit words arrive in a continuous flow over the network.
Big Endian. Aligned on 2-byte boundaries.
Just read them in the order they arrive.

**A unit of the file format.**
Write the stream straight to disk, and that is your file.
Read the bytes straight from disk and send them over the network, and that is your stream.
No serialization. No deserialization.

**A unit of the LLM vocabulary.**
16 bits = 65,536 distinct symbols.
Modern LLM vocabulary sizes range from tens of thousands to hundreds of thousands.
GPT-2 uses roughly 50,000; recent models around 100,000 to 200,000.
65,536 sits within that range.
A 16-bit word is a unit of a size an LLM can learn as vocabulary.

Three worlds sharing the same unit.
Translation shrinks.

---

## The Stream Is the File

Let us see what this concretely means.

**Conventional approach: 9 steps**

```
[File] -> Read -> Parse -> Extract text -> Tokenize -> [LLM]
[LLM] -> Decode -> Serialize -> Write -> [File]
```

**The GEUL approach**

```
[Stream] = [File]                          same bytes
[File] -> read record by record, skipping  no codebook needed
```

Write a stream as-is, and it is a file. Send a file as-is, and it is a stream.
No serialization, no deserialization.
The first word of every record (the TAG WORD) gives its kind and length,
so records you do not need are skipped without being interpreted.

The LLM side is still a goal.
One word is not the same as one token.
A record spans several words, and text is carried as a byte string.
Still, when the unit is fixed at 16 bits,
a tokenizer does not have to guess boundaries; it follows boundaries that are already given.
"Yi Sun-sin" is not split in some arbitrary place, because it is a single Reference record pointing to Wikidata Q50184.

---

## Why Not 8-Bit?

8 bits gives you 256 distinct symbols.

256 symbols are far too few to represent the world.
Assign the alphabet, digits, and basic punctuation, and half the space is already gone.

If you use 8 bits as your fundamental unit,
most meaningful tokens end up requiring 2 or more bytes.
That forces variable-length encoding,
and variable length makes parsing complex.

Adequate as a byte stream unit,
but insufficient as a token unit.

---

## Why Not 32-Bit?

32 bits gives you roughly 4.3 billion distinct symbols.

Expressive power is more than sufficient -- vastly more than needed.
But the problem is efficiency.

The smallest record in this language is 1 word: markers such as BODY and END that consist of a single TAG WORD.
A Reference to Wikidata Q42 is 2 words,
and a single TRIPLE saying "Q42 is a human" is 10 words.
At 16 bits per word, that TRIPLE is 20 bytes. With 32-bit words, it would be 40 bytes.
The same record doubles in size.

From the LLM's perspective, there is also a problem.
A 32-bit vocabulary of 4.3 billion symbols is tens of thousands of times larger than any LLM vocabulary.
There is neither the data nor the model to learn a vocabulary that large.

A 32-bit word is overkill as the unit of this language.

---

## Why Not Variable Length?

UTF-8 is a variable-length encoding.
Character length ranges from 1 byte to 4 bytes depending on the character.

This offers advantages in storage efficiency,
but it introduces a fatal weakness in processing efficiency.

To find the n-th character, you must count from the beginning.
Random access is impossible.
SIMD parallel processing becomes difficult.

This language uses fixed-width 16-bit words as its fundamental unit.
The position of the n-th word is always n * 2 bytes.
Random access is O(1).
SIMD can compare multiple words in a single instruction.
GPUs can scan billions of words in parallel.

Yet at the record level, variable length is still permitted.
Records range from 1 word to 2³²−1 words, and the length is written in the first word.
The word unit is fixed, but the record unit is flexible.

The processing efficiency of fixed width combined with the expressiveness of variable length.
The 16-bit word achieves both simultaneously.

---

## The Path That Unicode Proved

Unicode is the most successful encoding standard humanity has ever created.

The basic unit of UTF-16 is 16 bits (2 bytes).
It represents the characters of the Basic Multilingual Plane (BMP) in a single word,
and extends to characters beyond it using surrogate pairs (2 words = 4 bytes).

GEUL follows the same structure.
Frequent formats are carried as a direct code inside a single TAG WORD,
and rare formats are extended with extension TAGs.

Just as Unicode expresses every character in the world
on top of the basic unit of "one character = 2 bytes,"
GEUL expresses statements, their sources and their grounds
on top of the basic unit of "one word = 2 bytes."

---

## Backward Compatibility and Upward Extension

Another strength of 16 bits is alignment.

16 is a multiple of 8, a divisor of 32, a divisor of 64, and a divisor of 128.

This means alignment never breaks, no matter which direction you extend.

What if the transformer architecture changes in the future
and tokens become 32 bits?
Two 16-bit words make one token. No alignment issues.

What about 64 bits?
Four 16-bit words make one token. Still no alignment issues.

Conversely, what if an 8-bit embedded system processes this format?
Simply read each 16-bit word as a high byte and a low byte.

Backward compatibility must be maintained absolutely.
The 16-bit word guarantees this at the physical level.

We cannot predict the word size of future intelligences,
but the multiple alignment of 16 bits guarantees compatibility with any size.

---

## The Triple Structure

Let us summarize.

A single 16-bit word is designed to be the unit of three worlds.

| World | Role of One Word |
|-------|---------------------|
| Network | Unit of the byte stream |
| Storage | Unit of the file format |
| AI | Unit of the LLM vocabulary (goal) |

A single unit penetrates all three worlds.

Store a stream as-is, and it is a file.
Send a file as-is, and it is a stream.
Making it mesh with LLMs word by word is the next step.

Less conversion.
Less translation.
Less loss.

This is why 16-bit.
Not 8-bit, not 32-bit, not variable length.
The number that sits precisely at the intersection of three worlds.

16.
