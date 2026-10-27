---
title: "DENSE-BINARY32-VECTOR"
weight: 1009
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY32-VECTOR는 binary32 원소를 descriptor 없이 이어 담는 1차원 벡터 Value다(ADHOC Issuer 형식 0x0508)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY32-VECTOR는 IEEE 754 binary32 interchange bit pattern을 descriptor 없이 이어 저장한다.

## 레이아웃

- 코드: Value `ISSUER-1WORD`(`0x7C`), Issuer `0x0001` ADHOC, 형식 번호 `0x0508`. 계열 NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length 확장 TAG] 전체 15 WORD 이상일 때
Issuer            1 WORD  0x0001 (ADHOC)
형식 번호         1 WORD  0x0508
Payload: [binary32 bits 1st: 2 WORD] ... [binary32 bits Nth: 2 WORD]
```

## 해석 규칙

- 연속한 2 WORD가 한 원소이며 상위 WORD부터 읽는다. NaN payload와 signed zero를 포함한 bit pattern을 그대로 보존한다.
- 원소 수는 Payload WORD 수의 1/2이며 ABI padding은 없다.

## 유효성

- Payload는 2 WORD 이상이고 2 WORD의 정수배여야 한다. descriptor가 없는 이 형식은 빈 vector를 허용하지 않는다.

## 표준 근거와 형식 지위

- binary32 원소의 interchange format은 [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/)을 따른다.
- descriptor 없는 1차원 연속열, GEUL TAG/Length와 16비트 big-endian WORD 배치는 GEUL 고유 형식이다. [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html)은 native-endian을 가정하므로 이 Payload는 DLPack, Arrow, ONNX의 wire serialization이 아니다.

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG(있으면), Issuer 1 WORD, 형식 번호 1 WORD와 Payload를 합한 WORD 수다. 14 WORD 이하는 직접 길이, 15 WORD 이상은 `1110`·`1111` 확장 길이를 쓰며, 확장 TAG도 전체 수에 포함한다([Length](/ko/grammar/record/)).

## 예시

- Payload `3f80 0000 8000 0000`은 binary32 `[1.0, -0]`이고, 전체 7 WORD 레코드다.
