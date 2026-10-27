---
title: "BBOX2-BINARY64"
weight: 1013
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BBOX2-BINARY64는 (minX, minY, maxX, maxY) 순서의 IEEE 754 binary64 네 성분으로 된 2차원 경계 상자 Value다(ADHOC Issuer 형식 0x050C)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BBOX2-BINARY64는 `(minX, minY, maxX, maxY)` 순서의 IEEE 754 binary64 네 성분으로 된 2차원 경계 상자다.

## 레이아웃

- 코드: Value `ISSUER-1WORD`(`0x7C`), Issuer `0x0001` ADHOC, 형식 번호 `0x050C`. 계열 NUMERIC.

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length 확장 TAG   1 WORD  0x0014 (전체 20 WORD)
Issuer            1 WORD  0x0001 (ADHOC)
형식 번호         1 WORD  0x050C
Payload: [minX: 4 WORD][minY: 4 WORD][maxX: 4 WORD][maxY: 4 WORD]
```

## 해석 규칙

- 각 성분은 binary64이며 상위 WORD부터 읽는다. signed zero bit pattern을 보존한다.
- CRS, 축의 의미·순서와 단위는 외부 문맥이다. ABI padding은 없다.

## 유효성

- Payload는 정확히 16 WORD여야 하며 `minX ≤ maxX`, `minY ≤ maxY`여야 한다.
- NaN은 비교할 수 없으므로 어느 성분에든 있으면 거부한다.

## 표준 근거와 형식 지위

- 최소·최대 좌표의 의미는 OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html)의 bounding envelope를 참고하고, 각 성분은 [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/)를 따른다.
- GeoPackage envelope의 2D 배열 순서는 `[minx, maxx, miny, maxy]`다. 이 형식의 `(minX, minY, maxX, maxY)` 순서는 그 wire order가 아니라 GEUL이 정한 compact tuple이며, WKB/GeoPackage header도 담지 않는다. CRS, 축의 의미와 단위는 외부 문맥이다.

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG 1 WORD, Issuer 1 WORD, 형식 번호 1 WORD와 Payload 16 WORD를 합한 정확히 20 WORD이고 `LLLL=1110`을 쓴다. descriptor와 padding은 없다.
- Payload가 정확히 16 WORD가 아니면 거부한다.

## 예시

- 성분이 `(0.0, 1.0, 2.0, 3.0)`이면 유효하고, `(2.0, 1.0, 0.0, 3.0)`이면 invalid다.
