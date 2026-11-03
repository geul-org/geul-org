---
title: "COMPLEX64"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "COMPLEX64는 실수부·허수부 binary32 두 성분으로 복소수를 담는 고정 9 WORD ADHOC Issuer 형식이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COMPLEX64는 `(real, imag)` 순서의 IEEE 754 binary32 두 성분으로 복소수를 나타내는 Value다. Value `VALUE-ISSUER-2WORD`(`0x07DL`), Issuer `0x00000002` ADHOC, 코덱 번호 `0x00000700`, 계열 NUMERIC이다.

## 레이아웃

```
TAG WORD          0x07D8 (0000 0111 1101 1000)  전체 9 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
코덱 번호         2 WORD  0x00000700
Payload           [real binary32: 2 WORD][imag binary32: 2 WORD]
```

## 해석과 유효성

- 각 성분은 big-endian WORD 순서의 binary32 interchange bits다.
- NaN payload와 signed zero를 포함한 bit pattern을 그대로 보존하며 ABI padding은 없다.
- Payload는 정확히 4 WORD다. 두 binary32 성분의 모든 interchange bit pattern을 보존한다.

## 표준 근거와 형식 지위

- `complex64`가 32bit real 성분과 32bit imaginary 성분으로 이루어진다는 뜻은 [ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html)을 따르고, real-first 순서는 공식 [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3)의 complex raw-data mapping과 같다. 각 성분의 bit pattern은 [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/)를 따른다.
- ONNX raw data는 fixed-width little-endian이지만 이 형식은 GEUL big-endian WORD framing을 쓰므로 ONNX TensorProto wire serialization 자체는 아니다.

## 길이

- 전체는 TAG 1 WORD, Issuer 2 WORD, 코덱 번호 2 WORD, Payload 4 WORD를 합한 정확히 9 WORD이고 직접 길이 `LLLL=1000`을 쓴다. Length 확장 TAG, descriptor, padding은 없다.
- Payload가 정확히 4 WORD가 아니면 거부한다.

## 예시

- Payload `3f80 0000 4000 0000`은 `1.0 + 2.0i`다.
