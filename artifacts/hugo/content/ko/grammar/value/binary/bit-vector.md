---
title: "BIT-VECTOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BIT-VECTOR는 32bit 비트 수 N 뒤에 N bit를 MSB-first로 담는 GEUL Issuer 형식이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIT-VECTOR는 길이를 밝힌 raw bit sequence다. Value `ISSUER-1WORD`(`0x7C`), Issuer `0x0000` GEUL, 형식 번호 `0xC002`, 계열 BINARY다. 첫 2 Payload WORD는 unsigned 32bit bit count `N`이고, 뒤에 `ceil(N/16)` WORD가 온다.

## 레이아웃

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length 확장 TAG] 전체 15 WORD 이상일 때
Issuer            1 WORD  0x0000 (GEUL)
형식 번호         1 WORD  0xC002
Payload WORD 1st–2nd       Bit Count N (상위 16bit │ 하위 16bit)
Payload WORD 3rd ... Nth   Payload bits, MSB-first
```

## 해석과 유효성

- `N`은 첫 2 Payload WORD를 big-endian unsigned 32bit 정수로 읽은 값이다.
- payload bit는 각 WORD의 최상위 비트부터 차례로 채운다.
- payload WORD 수는 정확히 `ceil(N/16)`이고 마지막 WORD에서 쓰지 않는 하위 bit는 모두 0이어야 한다.
- `N=0`이면 payload WORD는 없다. 두 count WORD가 이미 Payload를 이루므로 Payload 최소 1 WORD 규칙과 충돌하지 않는다.

## 형식 지위

- unsigned 32bit bit count, MSB-first 배치, 마지막 WORD zero padding은 외부 산업표준을 인용한 것이 아니라 GEUL 고유 framing이다.
- GEUL TAG, Length, 16bit WORD 규칙을 포함해 이 페이지가 표현을 정의한다.

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG(있으면), Issuer 1 WORD, 형식 번호 1 WORD, Payload를 합한 WORD 수다. 14 WORD 이하는 직접 길이, 15 WORD 이상은 `1110`·`1111` 확장 길이를 쓰며 확장 TAG도 전체 수에 들어간다([레코드와 TAG WORD](/ko/grammar/record/)).

## 예시

- 빈 bit vector는 count `0000 0000`, payload 없음, 전체 5 WORD, `LLLL=0100`이다.
- bit sequence `101`은 count `0000 0003`, payload `a000`, 전체 6 WORD, `LLLL=0101`이다.
