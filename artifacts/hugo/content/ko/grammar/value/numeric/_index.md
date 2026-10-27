---
title: "Value — 수"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "NUMERIC 계열(Codec `0x00`~`0x0F`)의 기본 수 형식: BOOL, 정수, IEEE 754 부동소수, 지구·천체 좌표, 단위가 붙은 QUANTITY."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NUMERIC 계열의 기본 수 형식이다. 직접 코드 `0x00`~`0x0F`(Codec 상위 3비트 `000`)에 둔다.

- BOOL, 부호 있는·없는 정수, IEEE 754 binary 부동소수, 지구(WGS 84)·천체 좌표, 양·단위·경계를 묶은 QUANTITY가 있다.
- 정수는 값이 들어가는 최소 WORD로 쓴다.
- 벡터, 텐서, 복소수, 분수, 구간도 NUMERIC 계열이지만 Issuer 형식이라 [vector](/ko/grammar/value/vector/), [tensor](/ko/grammar/value/tensor/), [etc](/ko/grammar/value/etc/) 묶음에 둔다.
