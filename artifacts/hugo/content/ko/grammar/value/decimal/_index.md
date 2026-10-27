---
title: "Value — 10진수"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "DECIMAL 계열(Codec `0x10`~`0x1F`, 형식 번호 `0x2000`~`0x3FFF`)의 정확한 10진수 형식: SIGNED·UNSIGNED-DECIMAL과 IEEE 754 decimal32/64/128."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DECIMAL 계열은 정확한 10진수 형식이다. 직접 코드 `0x10`~`0x1F`(Codec 상위 3비트 `001`), Issuer 형식 번호 `0x2000`~`0x3FFF`에 둔다.

- 직접 코드 SIGNED-DECIMAL·UNSIGNED-DECIMAL은 `C × 10^E`로 쓰며 원래 표기의 자릿수를 그대로 담는다. `1.20`(`C=120, E=−2`)과 `1.2`(`C=12, E=−1`)는 다른 레코드다. 값 동등성과 quantum 보존은 [SIGNED-DECIMAL](/ko/grammar/value/decimal/signed-decimal/#열린-문제)의 열린 문제다.
- IEEE 754 decimal32/64/128의 DPD·BID 인코딩은 IEEE Issuer(`0x0040`) 형식이다.
