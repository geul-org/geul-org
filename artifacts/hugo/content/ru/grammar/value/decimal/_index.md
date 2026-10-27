---
title: "Value — десятичные числа"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "Форматы точных десятичных чисел семейства DECIMAL (Codec `0x10`~`0x1F`, номера форматов `0x2000`~`0x3FFF`): SIGNED- и UNSIGNED-DECIMAL, а также IEEE 754 decimal32/64/128."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Семейство DECIMAL — форматы точных десятичных чисел. Размещаются в прямых кодах `0x10`~`0x1F` (старшие 3 бита Codec `001`) и в номерах форматов Issuer `0x2000`~`0x3FFF`.

- Прямые коды SIGNED-DECIMAL и UNSIGNED-DECIMAL записываются как `C × 10^E` и сохраняют число знаков исходной записи. `1.20` (`C=120, E=−2`) и `1.2` (`C=12, E=−1`) — разные записи. Равенство значений и сохранение quantum — открытый вопрос в [SIGNED-DECIMAL](/ru/grammar/value/decimal/signed-decimal/#открытые-вопросы).
- Кодирования DPD и BID для IEEE 754 decimal32/64/128 — форматы Issuer IEEE (`0x0040`).
