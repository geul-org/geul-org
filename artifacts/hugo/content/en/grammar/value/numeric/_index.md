---
title: "Value — Numbers"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "The basic number formats of the NUMERIC family (Codec `0x00`-`0x0F`): BOOL, integers, IEEE 754 floating point, Earth and celestial coordinates, and QUANTITY with a unit."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

The basic number formats of the NUMERIC family. They are placed in direct codes `0x00`-`0x0F` (upper 3 bits of the Codec `000`) and Issuer format numbers `0x0000`-`0x1FFF`.

- They include BOOL, signed and unsigned integers, IEEE 754 binary floating point, Earth (WGS 84) and celestial coordinates, and QUANTITY, which bundles an amount, a unit, and bounds.
- An integer is written in the minimum WORDs that hold the value.
- The small-scalar Issuer formats (BFLOAT16, FP8, FP4) have only format numbers assigned and no detailed specification (open questions in [Value](/grammar/value/#open-questions)).
- Vectors, tensors, complex numbers, fractions, and intervals are also NUMERIC family, but since they are Issuer formats they are placed in the [vector](/grammar/value/vector/), [tensor](/grammar/value/tensor/), and [etc](/grammar/value/etc/) bundles.
