---
title: "DENSE-BFLOAT16-VECTOR"
weight: 1008
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BFLOAT16-VECTOR는 BF16 원소를 descriptor 없이 이어 담는 1차원 벡터 Value다(ADHOC Issuer 형식 0x0507)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BFLOAT16-VECTOR는 bfloat16 16비트 원소 bit pattern을 descriptor 없이 이어 저장한다. binary16과는 다른 형식이다.

## 레이아웃

- 코드: Value `ISSUER-1WORD`(`0x7C`), Issuer `0x0001` ADHOC, 형식 번호 `0x0507`. 계열 NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length 확장 TAG] 전체 15 WORD 이상일 때
Issuer            1 WORD  0x0001 (ADHOC)
형식 번호         1 WORD  0x0507
Payload: [BF16 bits 1st: 1 WORD] ... [BF16 bits Nth: 1 WORD]
```

## 해석 규칙

- 원소 수는 Payload WORD 수다. NaN payload와 signed zero를 포함한 bit pattern을 그대로 보존한다.
- 원소 사이와 끝에 ABI padding은 없다.

## 유효성

- Payload는 1 WORD 이상이어야 한다. descriptor가 없는 이 형식은 빈 vector를 허용하지 않는다.
- Payload 크기는 원소 폭 1 WORD의 정수배여야 한다.

## 표준 근거와 형식 지위

- bfloat16이라는 별도 16비트 dtype과 binary16과의 구별은 [ONNX IR의 tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) 및 [DLPack `kDLBfloat`](https://dmlc.github.io/dlpack/latest/c_api.html)에 맞춘다.
- descriptor 없는 1차원 bit-pattern 연속열, GEUL TAG/Length와 16비트 big-endian WORD 배치는 GEUL 고유 형식이다. DLPack은 native-endian을 가정하므로 이 Payload는 DLPack, Arrow, ONNX의 wire serialization이 아니다.

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG(있으면), Issuer 1 WORD, 형식 번호 1 WORD와 Payload를 합한 WORD 수다. 14 WORD 이하는 직접 길이, 15 WORD 이상은 `1110`·`1111` 확장 길이를 쓰며, 확장 TAG도 전체 수에 포함한다([Length](/ko/grammar/record/)).

## 예시

- Payload `3f80 8000`은 BF16 `1.0`과 `-0`이고, 전체 5 WORD 레코드다.
