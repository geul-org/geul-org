---
title: "Why We Must Leave It Empty"
weight: 21
date: 2026-03-01T15:00:00+09:00
lastmod: 2026-03-01T15:00:00+09:00
tags: ["reserved", "extensibility", "64-bit", "design-principle", "IPv4"]
summary: "GEUL leaves 75% of its 64-bit space empty. The lessons of IPv4, Unicode, and ASCII tell us — the cost of filling is irreversible, but the cost of leaving empty is zero."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

64 bits yield 18,446,744,073,709,551,616 addresses. 18.4 quintillion. GEUL leaves 75% of them empty.

```
bit1 = 1:    50%    Far future
bit1-2 = 01: 25%    Near future
bit1-3 = 001: 12.5% Standard
bit1-4 = 0001: 6.25% Current proposal
```

The space currently in use is 6.25%. Of the remaining 93.75%, 12.5% is reserved for when standards are established, and 75% is left for generations not yet born.

Why?

---

## The Lesson of IPv4

In 1981, the designers of IPv4 thought 32 bits would be enough. 4.3 billion addresses. At the time, there were only a few hundred computers in the entire world. 4.3 billion seemed like it would last forever.

In 2011, IPv4 addresses ran out.

30 years. Just 30 years.

What humanity did after exhaustion: NAT, CGNAT, address trading markets, IPv6 dual stack. Trillions of dollars over decades. All costs that "would have been unnecessary if they had left space empty from the start."

IPv6 went with 128 bits. 3.4 x 10^38 addresses. 6.7 x 10^17 per square meter of the Earth's surface. Surely enough this time? Probably. But even they weren't confident enough, which is exactly why they chose 128 bits.

---

## The Lesson of Unicode

In 1991, Unicode 1.0 assumed 16 bits would be enough. 65,536 characters. It seemed like it could hold every character in the world.

It wasn't enough. CJK extensions, emoji, ancient scripts, musical notation. They exceeded 16 bits.

The result: UTF-16 surrogate pairs. One of the ugliest hacks in the history of software. Windows, Java, and JavaScript still carry this legacy.

Unicode eventually expanded to 21 bits (1,114,112 code points). Current usage is about 10%. The rest was left empty. This time, they learned the lesson.

---

## The Lesson of ASCII

In 1963, ASCII used 7 bits. 128 characters. They only thought about English.

As a result, humanity lived through 60 years of encoding hell. EUC-KR, Shift_JIS, Big5, the ISO-8859 series, CP949. The same byte representing different characters on different systems. Garbled Korean. Garbled Japanese. Question marks in email subjects.

If they had used just one more bit. If they had secured a full 8 bits and said "the rest is for later." History would have been different.

---

## The Arrogance of Designers

All these cases share one thing in common: **the judgment that "what we need now is enough."**

Were the people who designed IPv4 fools? No. They were the finest engineers of their era. They simply underestimated the future. Every generation has done the same.

"640KB ought to be enough for anybody." Whether Bill Gates actually said this is debatable, but the fact that engineers of every era have fallen into this trap is not.

GEUL aims to avoid this trap. The method is simple. **Don't use it.**

---

## Third Time's the Charm

There is an old principle: opportunities should come in threes.

```
First chance: 001 (Standard)
  When humans establish standards.
  Whether through international bodies, industry consortia, or communities.
  Space to be filled at the speed of human consensus.

Second chance: 01 (Future)
  After S1. When superintelligence emerges.
  Entities that will structure knowledge in ways humans cannot predict.
  They may use the structures we designed as-is,
  or they may redefine them in ways we cannot imagine.
  Space reserved for those entities.

Third chance: 1 (Far future)
  No one knows when.
  Perhaps when K1 is achieved and we become an interstellar civilization.
  Perhaps when the very form of consciousness has changed.
  Perhaps something we can only imagine as science fiction today.
  If someone beyond Orion's Arm* is reading this bit,
  this space belongs to them.
```

Leaving 50% for the far future means yielding half of all possibility to "what we do not know."

---

## The Cost of Leaving Empty

Does leaving space empty cost anything?

```
75% of 64 bits reserved = 48 bits unused.
Remaining 16 bits (6.25%) = 1,152,921,504,606,846,976 addresses.

1.15 quintillion.
Ten million times the entirety of Wikidata (108 million items).
More than enough to hold all data that currently exists.
```

Leaving space empty does not create scarcity. 6.25% is sufficient for current needs. The cost of leaving empty is zero.

The cost of filling? IPv4 showed us. It is irreversible.

---

## Design Principle

Article 1 of the design principles of GEUL Grammar v0.11:

> **Long-term extensibility:** Reserved bits shall not be repurposed for temporary use. Space for future generations shall be preserved.

This is not a technical decision. It is an ethical one.

Choosing not to use space that could be used now is a declaration that the freedom of the future takes precedence over the convenience of the present. The debt that the generation who designed IPv4 left to us — we will not leave to the next generation.

---

## The Most Humble Design

```
"I know the future" -> Use all 64 bits.
"I don't know the future" -> Leave 75% empty.
```

Leaving space empty is humility. It is the act of acknowledging that we cannot know the future. And that humility produces the most robust design.

IPv4 was a product of confidence. 32 bits is enough. It wasn't.

GEUL is a product of humility. We don't know if 6.25% of 64 bits is enough. But if we leave 75% empty, it's okay to be wrong.

---

*It took this many words to explain why we leave it empty. The act of leaving empty itself takes only one line:*

```
if (bit1 == 1): reserved  // 50%. Far future.
```

*A single line of code guards half the world.*

---

<small>

\* Orion's Arm — the spiral arm of the Milky Way that contains our solar system. Also, the [Orion's Arm Universe Project](https://www.orionsarm.com/) is a collaborative hard science fiction worldbuilding project set in this spiral arm, depicting a future more than ten thousand years from now. It explores themes such as superintelligence, interstellar civilizations, and the transformation of consciousness with scientific rigor, built by hundreds of contributors since 2000. The timescale that GEUL calls "the far future" — they are already imagining it.

</small>
