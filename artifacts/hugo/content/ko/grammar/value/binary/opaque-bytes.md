---
title: "OPAQUE-BYTES"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "OPAQUE-BYTES는 의미와 형식을 스스로 정하지 않는 임의의 바이트열을 담는 GEUL Issuer 형식이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

OPAQUE-BYTES는 의미와 형식을 이 형식 자체에서 정하지 않는 임의의 바이트열이다. Value `ISSUER-1WORD`(`0x7C`), Issuer `0x0000` GEUL, 형식 번호 `0xC000`·`0xC001`(짝수·홀수 바이트), 계열 BINARY다. 바이트 수는 형식 번호의 최하위 비트와 Payload WORD 수로 정한다. `2 × Payload WORD 수 − 최하위 비트`이며 Byte Count는 두지 않는다([Value](/ko/grammar/value/)).

## 레이아웃

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length 확장 TAG] 전체 15 WORD 이상일 때
Issuer            1 WORD  0x0000 (GEUL)
형식 번호         1 WORD  0xC000/0xC001
Payload WORD 1st ... Nth   바이트 / 마지막 zero padding
```

## 해석과 유효성

- Payload에서 바이트 수만큼 byte를 순서대로 읽는다. WORD 안에서는 상위 byte가 먼저 온다.
- Payload WORD 수는 `ceil(바이트 수/2)`다. 홀수 코드인데 마지막 WORD의 하위 byte가 `00`이 아니면 거부한다.
- 짝수·홀수 코드, Payload WORD 수, zero padding이 서로 맞지 않으면 거부한다.

## 형식 지위

- 홀짝 코드 쌍, payload 배치, 마지막 WORD zero padding은 외부 산업표준을 인용한 것이 아니라 GEUL 고유 framing이다.

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG(있으면), Issuer 1 WORD, 형식 번호 1 WORD, Payload를 합한 WORD 수다. 14 WORD 이하는 직접 길이, 15 WORD 이상은 `1110`·`1111` 확장 길이를 쓰며 확장 TAG도 전체 수에 들어간다([레코드와 TAG WORD](/ko/grammar/record/)).
- 0 byte는 짝수 형식 번호(`0xC000`)에 Payload 없는 3 WORD 레코드(TAG, Issuer, 형식 번호)로 쓴다.

## 예시

byte `ab cd ef`는 3 byte(홀수)라 형식 번호 `0xC001`, Payload `abcd ef00`이다. 전체 5 WORD이므로 `LLLL=0100`이다.

```
0A7C 0000 C001 abcd ef00
```
