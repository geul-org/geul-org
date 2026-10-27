---
title: "DESCRIBED-PACKED-TENSOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-PACKED-TENSOR는 packed format·rank·shape descriptor 뒤에 sub-WORD 원소를 low-bit-first로 채운 ADHOC Issuer 형식이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-PACKED-TENSOR는 shape와 packed format을 Payload descriptor에 적고 WORD보다 작은 원소를 packed로 저장하는 텐서 Value다. Value `ISSUER-1WORD`(`0x7C`), Issuer `0x0001` ADHOC, 형식 번호 `0x0601`, 계열 NUMERIC이다.

## 레이아웃

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length 확장 TAG] 전체 15 WORD 이상일 때
Issuer            1 WORD  0x0001 (ADHOC)
형식 번호         1 WORD  0x0601
Payload WORD 1st  [version: 4bit][packed-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload 나머지    [packed payload octet stream, low-bit-first]
```

## 해석

- rank는 descriptor의 4bit 값이므로 구조적으로 `0..15`만 표현한다. 각 dimension은 음이 아닌 big-endian uint32다. 논리 순서는 C-contiguous row-major다.
- ONNX의 논리 tensor 규칙처럼 rank 0 shape `[]`는 원소 1개의 scalar이고, dimension 중 하나라도 0이면 원소 수는 0이다. 그 밖의 원소 수는 모든 dimension의 곱이다.
- packed-format은 int2/int4, FP4/FP6, 특정 FP8 variant처럼 원소 encoding과 bit 폭을 고정한다.
- payload octet sequence를 `p[0], p[1], ...`라 하고 little-bit-endian 정수 `P = Σ(p[j] << (8j))`로 보면, 폭 `w`인 논리 원소 `i`는 `(P >> (i × w)) & ((1 << w) - 1)`이다. 즉 첫 원소부터 가장 낮은 비트에 넣는다.
- WORD에는 `p[0]`을 첫 WORD의 상위 octet, `p[1]`을 하위 octet 순으로 싣는다. 마지막 사용 octet의 미사용 상위 tail bit는 0이어야 하고, payload octet 수가 홀수이면 마지막 WORD의 미사용 하위 octet 전체가 `00`이어야 한다.

## 유효성

- 지원하는 format의 bit 폭을 적용했을 때 overflow 없이 계산한 shape의 dimension 곱과 payload 원소 수가 맞아야 한다.
- 필요한 payload bit 뒤의 high tail bit나 octet padding이 하나라도 1이면 거부한다. descriptor, shape, payload는 레코드 Length 안에 완전히 들어가야 한다.

## 표준 근거와 형식 지위

- shape, rank 0 scalar, zero dimension의 논리적 뜻은 [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html)을 따른다. sub-byte 원소를 낮은 bit부터 놓는 규칙은 공식 [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3)의 int2/int4 packing과 [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html)의 little bit-endian packing을 따른다.
- 4bit rank, uint32 dimension, version/packed-format field, octet을 big-endian WORD로 묶는 방식, GEUL TAG/Length는 GEUL 고유 descriptor다. ONNX, [Apache Arrow tensor](https://arrow.apache.org/docs/format/Other.html), DLPack 자체의 wire·memory serialization이 아니다.

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG(있으면), Issuer 1 WORD, 형식 번호 1 WORD, Payload를 합한 WORD 수다. 14 WORD 이하는 직접 길이, 15 WORD 이상은 `1110`·`1111` 확장 길이를 쓰며 확장 TAG도 전체 수에 들어간다([레코드와 TAG WORD](/ko/grammar/record/)).
- descriptor는 1 WORD, shape는 `2 × rank` WORD이며 나머지가 packed payload다.
- 논리 원소 수가 `N`, 원소 폭이 `w`이면 payload octet 수는 `ceil(N × w / 8)`, payload WORD 수는 `ceil(payload octet 수 / 2)`다.

## 예시

- rank가 2인 profile이라면 descriptor 뒤 4 WORD가 shape이고 그 뒤가 low-bit-first payload octet sequence다. 원소 폭과 실제 허용 여부는 확정된 format profile로 판단한다.
- 4bit 원소 `[1, 2, 3]`의 payload octet sequence는 `21 03`이고 payload WORD는 `2103`이다. 첫 원소가 첫 octet의 낮은 nibble에 있고, 마지막 octet의 미사용 높은 nibble은 0이다.

## 열린 문제

- version과 packed-format registry의 값, 그리고 표현 가능한 rank `0..15` 중 지원할 profile 범위는 아직 정하지 않았다.
