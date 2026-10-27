---
title: "CONFIDENCE"
weight: 68
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "CONFIDENCE는 문서 전체의 신뢰도를 0 이상 1 이하의 소수 Value로 적는 검증 Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

문서 전체의 신뢰도를 적는다. 레코드 단위 신뢰도는 대상 Edge에 붙는 QUALIFIER로 쓴다(속성은 미정, [SOURCE](/ko/grammar/edge/source/#다른-근거의-표현)).

## 레이아웃

```
TAG WORD          0001 1LLL L100 0011      Codec 0x43
[Length 확장 TAG]
Payload           UNSIGNED-DECIMAL Value, 0 이상 1 이하
```

- Codec: Meta `0x43`, 검증 클래스(`100`)
- Payload: 내장 Value([UNSIGNED-DECIMAL](/ko/grammar/value/decimal/unsigned-decimal/))
- 개수: 많아야 하나

## 해석과 유효성

- 누가 매긴 값인지는 [GENERATED-BY](/ko/grammar/meta/lineage/generated-by/) 등으로 함께 적는다.

## 열린 문제

- 척도(0~1)와 TOULMIN 판정과의 관계.
