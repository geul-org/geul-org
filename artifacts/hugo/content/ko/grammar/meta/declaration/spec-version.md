---
title: "SPEC-VERSION"
weight: 17
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "SPEC-VERSION은 문서가 따르는 GEUL 명세 판을 정수 하나로 선언하는 정의 Meta다. GEUL v1은 0x0001이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

문서가 따르는 GEUL 명세 판을 선언한다. 나머지 레코드를 어떻게 읽을지 이 값이 정한다.

## 레이아웃

```
TAG WORD          0001 1LLL L001 0000      Codec 0x10
[Length 확장 TAG]
Payload           명세 판. v1 = 0x0001
```

- Codec: Meta `0x10`, 정의 클래스(`001`)
- Payload: 날값(가장 짧은 폭의 unsigned 정수)
- 개수: 많아야 하나

## 해석과 유효성

- Value 코드에 기대지 않는다. 어느 판의 디코더든 읽을 수 있게 내장 Value 없이 정수만 둔다.
- 모르는 판이면 디코더는 거부하거나 경고한다.
- 없으면 디코더가 아는 판으로 읽는다. 공표 문서는 적는다.

## 예시

- `0x1890 0x0001`: GEUL v1

## 열린 문제

- 코덱북 문서 버전과의 대응([규격 문서](/ko/grammar/codec-spec/)).
