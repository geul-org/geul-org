---
title: "DENSE-U16-VECTOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-U16-VECTOR는 big-endian uint16 원소를 descriptor 없이 이어 담는 1차원 벡터 Value다(ADHOC Issuer 형식 0x0501)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-U16-VECTOR는 big-endian uint16 원소를 descriptor 없이 이어 저장하는 동질 1차원 Value다.

## 레이아웃

- 코드: Value `ISSUER-1WORD`(`0x7C`), Issuer `0x0001` ADHOC, 형식 번호 `0x0501`. 계열 NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length 확장 TAG] 전체 15 WORD 이상일 때
Issuer            1 WORD  0x0001 (ADHOC)
형식 번호         1 WORD  0x0501
Payload: [uint16 1st: 1 WORD] ... [uint16 Nth: 1 WORD]
```

## 해석 규칙

- 각 WORD를 독립된 unsigned 16비트 정수로 읽는다. 원소 수는 Payload WORD 수다.
- 원소 사이와 끝에 ABI padding은 없다.

## 유효성

- Payload는 1 WORD 이상이어야 한다. descriptor가 없는 이 형식은 빈 vector를 허용하지 않는다.
- Payload 크기는 원소 폭 1 WORD의 정수배여야 한다.

## 표준 근거와 형식 지위

- unsigned integer dtype의 unsigned 해석과 16비트 폭은 [ONNX IR의 tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) 및 [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html)의 산업 dtype에 맞춘다.
- descriptor 없는 1차원 연속열, GEUL TAG/Length와 big-endian WORD 배치는 GEUL 고유 형식이다. DLPack은 dtype을 native-endian으로 가정하므로 이 Payload는 DLPack이나 ONNX의 wire serialization이 아니다.

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG(있으면), Issuer 1 WORD, 형식 번호 1 WORD와 Payload를 합한 WORD 수다. 14 WORD 이하는 직접 길이, 15 WORD 이상은 `1110`·`1111` 확장 길이를 쓰며, 확장 TAG도 전체 수에 포함한다([Length](/ko/grammar/record/)).

## 예시

- Payload `0000 ffff`는 원소 `[0, 65535]`이고, 직접 길이 `LLLL=0100`인 전체 5 WORD 레코드다.
