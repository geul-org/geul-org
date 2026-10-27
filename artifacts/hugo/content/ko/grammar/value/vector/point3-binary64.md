---
title: "POINT3-BINARY64"
weight: 1012
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT3-BINARY64는 (x, y, z) 순서의 IEEE 754 binary64 세 성분으로 된 3차원 점 Value다(ADHOC Issuer 형식 0x050B)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT3-BINARY64는 `(x, y, z)` 순서의 IEEE 754 binary64 세 성분으로 된 3차원 점이다.

## 레이아웃

- 코드: Value `ISSUER-1WORD`(`0x7C`), Issuer `0x0001` ADHOC, 형식 번호 `0x050B`. 계열 NUMERIC.

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length 확장 TAG   1 WORD  0x0010 (전체 16 WORD)
Issuer            1 WORD  0x0001 (ADHOC)
형식 번호         1 WORD  0x050B
Payload: [x binary64: 4 WORD][y binary64: 4 WORD][z binary64: 4 WORD]
```

## 해석 규칙

- 각 성분은 상위 WORD부터 읽으며, NaN payload와 signed zero bit pattern을 보존한다.
- CRS, 축의 의미·순서와 단위는 외부 문맥이다. ABI padding은 없다.

## 유효성

- Payload는 정확히 12 WORD이고, 각 4 WORD 구간은 binary64 interchange bits다.

## 표준 근거와 형식 지위

- 점의 `x, y, z` 좌표 순서는 OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html)의 Point/WKB axis order를 참고하고, 각 성분은 [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/)를 따른다.
- 이 Payload는 WKB type/byte-order header나 GeoPackage header를 담지 않는 GEUL compact profile이며, OGC WKB wire format이 아니다. CRS, 축의 의미와 단위는 외부 문맥이다.

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG 1 WORD, Issuer 1 WORD, 형식 번호 1 WORD와 Payload 12 WORD를 합한 정확히 16 WORD이고 `LLLL=1110`을 쓴다. descriptor와 padding은 없다.
- Payload가 정확히 12 WORD가 아니면 거부한다.

## 예시

- Payload의 세 binary64가 `1.0, 2.0, 3.0`이면 점 `(1.0, 2.0, 3.0)`이다.
