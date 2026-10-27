---
title: "POINT2-BINARY64"
weight: 1011
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT2-BINARY64는 (x, y) 순서의 IEEE 754 binary64 두 성분으로 된 2차원 점 Value다(ADHOC Issuer 형식 0x050A)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT2-BINARY64는 `(x, y)` 순서의 IEEE 754 binary64 두 성분으로 된 2차원 점이다.

## 레이아웃

- 코드: Value `ISSUER-1WORD`(`0x7C`), Issuer `0x0001` ADHOC, 형식 번호 `0x050A`. 계열 NUMERIC.

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  전체 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
형식 번호         1 WORD  0x050A
Payload: [x binary64: 4 WORD][y binary64: 4 WORD]
```

## 해석 규칙

- 각 성분은 상위 WORD부터 읽으며, NaN payload와 signed zero bit pattern을 보존한다.
- CRS, 축의 의미·순서와 단위는 외부 문맥이다. ABI padding은 없다.

## 유효성

- Payload는 정확히 8 WORD이고, 각 4 WORD 구간은 binary64 interchange bits다.

## 표준 근거와 형식 지위

- 점의 `x, y` 좌표 순서는 OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html)의 Point/WKB axis order를 참고하고, 각 성분은 [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/)를 따른다.
- 이 Payload는 WKB type/byte-order header나 GeoPackage header를 담지 않는 GEUL compact profile이며, OGC WKB wire format이 아니다. CRS, 축의 의미와 단위는 외부 문맥이다.

## 길이

- 전체는 TAG 1 WORD, Issuer 1 WORD, 형식 번호 1 WORD와 Payload 8 WORD를 합한 정확히 11 WORD이고 직접 길이 `LLLL=1010`을 쓴다. Length 확장 TAG, descriptor, padding은 없다.
- Payload가 정확히 8 WORD가 아니면 거부한다.

## 예시

- Payload `3ff0 0000 0000 0000 4000 0000 0000 0000`은 `(1.0, 2.0)`이다.
