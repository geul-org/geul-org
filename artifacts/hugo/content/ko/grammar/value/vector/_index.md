---
title: "Value — 벡터"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "NUMERIC 계열 Issuer 형식(ADHOC `0x05xx`, KHRONOS)의 벡터: 정수·실수 밀집 벡터, 2·3차원 점, 경계 상자, RGBA8·BGRA8 픽셀."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

벡터 형식은 NUMERIC 계열의 Issuer 형식이다. 정수·실수 밀집 벡터와 점·경계 상자는 ADHOC(`0x0001`) 형식 번호 `0x0500`~`0x050C`, 픽셀 형식은 KHRONOS(`0x0041`) 아래에 둔다.

- 밀집 벡터의 원소는 big-endian으로 연속해 저장한다.
- Issuer 형식이라 Codec 확장 TAG에 Issuer와 형식 번호 2 WORD가 붙는다.
