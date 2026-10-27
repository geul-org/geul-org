---
title: "Value — Decimal"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "The exact decimal formats of the DECIMAL family (Codec `0x10`-`0x1F`, format numbers `0x2000`-`0x3FFF`): SIGNED- and UNSIGNED-DECIMAL, and IEEE 754 decimal32/64/128."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

The DECIMAL family is the exact decimal formats. They are placed in direct codes `0x10`-`0x1F` (upper 3 bits of the Codec `001`) and Issuer format numbers `0x2000`-`0x3FFF`.

- The direct codes SIGNED-DECIMAL and UNSIGNED-DECIMAL are written as `C × 10^E` and hold the digits of the original notation as they are. `1.20` (`C=120, E=−2`) and `1.2` (`C=12, E=−1`) are different records. Value equality and quantum preservation are open questions in [SIGNED-DECIMAL](/grammar/value/decimal/signed-decimal/#open-questions).
- The DPD and BID encodings of IEEE 754 decimal32/64/128 are IEEE Issuer (`0x0040`) formats.
