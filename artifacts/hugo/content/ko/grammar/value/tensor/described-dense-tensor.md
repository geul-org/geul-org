---
title: "DESCRIBED-DENSE-TENSOR"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-DENSE-TENSOR는 element format·rank·shape descriptor 뒤에 C-contiguous row-major 원소를 담는 ADHOC Issuer 형식이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-DENSE-TENSOR는 shape와 element format을 Payload descriptor에 적고 C-contiguous row-major payload를 저장하는 텐서 Value다. Value `ISSUER-1WORD`(`0x7C`), Issuer `0x0001` ADHOC, 형식 번호 `0x0600`, 계열 NUMERIC이다.

## 레이아웃

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length 확장 TAG] 전체 15 WORD 이상일 때
Issuer            1 WORD  0x0001 (ADHOC)
형식 번호         1 WORD  0x0600
Payload WORD 1st  [version: 4bit][element-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload 나머지    [dense payload]
```

## 해석

- rank는 descriptor의 4bit 값이므로 구조적으로 `0..15`만 표현한다. 각 dimension은 음이 아닌 big-endian uint32다.
- ONNX의 논리 tensor 규칙처럼 rank 0 shape `[]`는 원소 1개의 scalar이고, dimension 중 하나라도 0이면 원소 수는 0이다. 그 밖의 원소 수는 모든 dimension의 곱이다.
- payload는 descriptor의 element format으로 읽으며 C-contiguous row-major 순서다. 계산한 논리 원소 수는 descriptor 뒤 payload의 원소 수와 같아야 한다.

## 유효성

- 지원하는 version과 element format이 정해지면 그 원소 폭으로 payload 경계를 복구하고, overflow 없이 계산한 shape 곱과 맞는지 검증한다.
- descriptor, 모든 dimension, payload는 레코드 Length 안에 완전히 들어가야 하며 임의 ABI padding은 없다.

## 표준 근거와 형식 지위

- shape가 음이 아닌 dimension 목록이고 값 수가 dimension 곱과 같다는 규칙, rank 0 scalar와 zero dimension의 뜻은 [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html)을 따른다. C-contiguous row-major 논리 순서는 [Apache Arrow canonical fixed-shape tensor extension](https://arrow.apache.org/docs/format/CanonicalExtensions.html)의 순서와 맞춘다.
- 4bit rank, uint32 dimension, version/element-format field, GEUL TAG/Length, big-endian WORD payload는 GEUL 고유 descriptor다. [Arrow tensor IPC format](https://arrow.apache.org/docs/format/Other.html), ONNX TensorProto, [DLPack C API](https://dmlc.github.io/dlpack/latest/c_api.html)의 wire·memory serialization이 아니다.

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG(있으면), Issuer 1 WORD, 형식 번호 1 WORD, Payload를 합한 WORD 수다. 14 WORD 이하는 직접 길이, 15 WORD 이상은 `1110`·`1111` 확장 길이를 쓰며 확장 TAG도 전체 수에 들어간다([레코드와 TAG WORD](/ko/grammar/record/)).
- descriptor는 1 WORD, shape는 `2 × rank` WORD이며 나머지가 payload다.

## 예시

- rank가 2인 profile이라면 descriptor 뒤 4 WORD가 두 uint32 dimension이고, 그 뒤 전체가 row-major payload다. 실제 허용 여부와 원소 수 검증에는 확정된 version·format profile이 필요하다.

## 열린 문제

- version과 element-format registry의 값, 그리고 표현 가능한 rank `0..15` 중 지원할 profile 범위는 아직 정하지 않았다.
