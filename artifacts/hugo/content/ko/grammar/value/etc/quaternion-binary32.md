---
title: "QUATERNION-BINARY32"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "QUATERNION-BINARY32는 (x, y, z, w) 순서의 binary32 네 성분으로 quaternion을 담는 고정 11 WORD ADHOC Issuer 형식이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUATERNION-BINARY32는 `(x, y, z, w)` 순서의 IEEE 754 binary32 네 성분으로 quaternion을 나타내는 Value다. Value `ISSUER-1WORD`(`0x7C`), Issuer `0x0001` ADHOC, 형식 번호 `0x0704`, 계열 NUMERIC이다.

## 레이아웃

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  전체 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
형식 번호         1 WORD  0x0704
Payload           [x: 2 WORD][y: 2 WORD][z: 2 WORD][w: 2 WORD]
```

## 해석과 유효성

- 각 성분은 big-endian WORD 순서의 binary32 interchange bits다.
- frame, handedness, unit norm, `q/-q` 동등성은 외부 문맥이며 이 형식의 뜻에 들어 있지 않다.
- NaN payload와 signed zero bit pattern을 보존하며 ABI padding은 없다.
- Payload는 정확히 8 WORD다. 이 형식은 unit norm이나 `q/-q` 정규화를 강제하지 않는다.

## 표준 근거와 형식 지위

- `x, y, z, w` 순서는 Khronos [glTF 2.0 specification/registry](https://registry.khronos.org/glTF/)의 quaternion 성분 순서와 같고, 각 성분은 [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/)다.
- glTF node rotation은 W가 scalar인 unit quaternion을 요구한다. 이 형식은 unit norm이나 rotation 의미를 강제하지 않는 일반 quaternion이므로, 외부 profile이 그 조건을 더하지 않는 한 glTF rotation과 같다고 볼 수 없다.

## 길이

- 전체는 TAG 1 WORD, Issuer 1 WORD, 형식 번호 1 WORD, Payload 8 WORD를 합한 정확히 11 WORD이고 직접 길이 `LLLL=1010`을 쓴다. Length 확장 TAG, descriptor, padding은 없다.
- Payload가 정확히 8 WORD가 아니면 거부한다.

## 예시

- 성분 `(0.0, 0.0, 0.0, 1.0)`은 네 bit pattern을 순서대로 저장한 유효한 값이다.
