---
title: "Why We Must Leave It Empty"
weight: 21
date: 2026-03-01T15:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["reserved", "extensibility", "TAG WORD", "design-principle", "IPv4"]
summary: "GEUL leaves 75% of the 16-bit TAG WORD space that opens every record empty. The lessons of IPv4, Unicode, and ASCII — the cost of filling is irreversible, while the cost of leaving empty is three bits per record."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Every GEUL record begins with a single 16-bit TAG WORD. The leading bits of the TAG WORD divide it into regions. GEUL leaves 75% of this space empty.

```
1xx:  50%    Far future
01x:  25%    Near future
001:  12.5%  Standard
000:  12.5%  Current grammar (free / proposal)
```

The entire current grammar lives in the `000` region, inside 12.5%. When an official standard is launched, adopted layouts stay as they are and only the leading bits move to `001`. The remaining 75% is left for generations not yet born.

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
TAG WORD 16 bits = 3-bit region + 13 bits

The 13 bits of the current region 000:
  Kind    2 bits   Reference · Value · Edge · Meta
  Length  4 bits   1–14 WORDs, up to 2³²−1 WORDs when extended
  Codec   7 bits   124 direct codes + 4 Issuer forms
```

Are 13 bits not too few? They are not. A format that does not get a direct code is written as an Issuer format. Every format-defining party (Issuer) has its own 16-bit format numbers, so there is practically no limit on the number of formats. The price is a few WORDs of extension TAG. Frequent formats are short; rare formats are a little longer.

The cost of leaving empty is three bits of the TAG WORD per record. Those three bits keep six times the space in use today for the future.

The cost of filling? IPv4 showed us. It is irreversible.

---

## Design Principle

The fifth design principle of the GEUL v1 [grammar](/grammar/overview/):

> **Leave it empty.** Most of the bit space is kept for the future. Direct codes cannot be reclaimed, so only formats with confirmed frequency get one.

The grammar nails this principle down as a rule. A v1 decoder rejects any TAG WORD whose leading bits are not `000`. The path to borrowing the empty space for temporary use is closed from the start.

This is not a technical decision. It is an ethical one.

Choosing not to use space that could be used now is a declaration that the freedom of the future takes precedence over the convenience of the present. The debt that the generation who designed IPv4 left to us — we will not leave to the next generation.

---

## The Most Humble Design

```
"I know the future" -> Use all 16 bits.
"I don't know the future" -> Leave 75% empty.
```

Leaving space empty is humility. It is the act of acknowledging that we cannot know the future. And that humility produces the most robust design.

IPv4 was a product of confidence. 32 bits is enough. It wasn't.

GEUL is a product of humility. We don't know if the 12.5% in use today is enough. But if we leave 75% empty, it's okay to be wrong.

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
