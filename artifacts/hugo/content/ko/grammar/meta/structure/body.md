---
title: "BODY"
weight: 15
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "BODY는 문서의 HEAD를 끝내고 BODY를 시작하는 1 WORD 구조 Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

HEAD를 끝내고 BODY를 시작하는 레코드다.

## 레이아웃

```
TAG WORD          0001 1LLL L000 1110      Codec 0x0E
[Length 확장 TAG]
```

- Codec: Meta `0x0E`, 구조 클래스(`000`)
- Payload: 없음(1 WORD)
- 개수: 문서마다 많아야 하나

## 해석과 유효성

- HEAD가 비어 있으면 생략한다. `BODY`가 없는 문서는 전부 BODY다. HEAD에 Meta나 HEAD Edge(문서 전체의 [SOURCE](/ko/grammar/edge/source/#문서-전체의-출처)와 그 QUALIFIER)가 있으면 둔다.
- Payload가 없다. 전체 1 WORD다.

## 예시

- `0x180E`
