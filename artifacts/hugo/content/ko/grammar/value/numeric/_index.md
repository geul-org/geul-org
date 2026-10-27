---
title: "Value — 수"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "NUMERIC 계열(Codec `0x00`~`0x0F`)의 기본 수 형식: BOOL, 정수, IEEE 754 부동소수, 지구·천체 좌표, 단위가 붙은 QUANTITY, 표기를 보존하는 분수 FRACTION."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NUMERIC 계열의 기본 수 형식이다. 직접 코드 `0x00`~`0x0F`(Codec 상위 3비트 `000`), Issuer 형식 번호 `0x0000`~`0x1FFF`에 둔다.

- BOOL, 부호 있는·없는 정수, IEEE 754 binary 부동소수, 지구(WGS 84)·천체 좌표, 양·단위·경계를 묶은 QUANTITY, 원문 표기 그대로의 분수 FRACTION이 있다.
- 정수는 값이 들어가는 최소 WORD로 쓴다.
- 작은 스칼라 Issuer 형식(BFLOAT16, FP8, FP4)은 형식 번호만 배정되어 있고 상세 규격이 없다([Value](/ko/grammar/value/#열린-문제) 열린 문제).
- 벡터, 텐서, 복소수, 기약분수(RATIONAL-I64), 구간도 NUMERIC 계열이지만 Issuer 형식이라 [vector](/ko/grammar/value/vector/), [tensor](/ko/grammar/value/tensor/), [etc](/ko/grammar/value/etc/) 묶음에 둔다.
