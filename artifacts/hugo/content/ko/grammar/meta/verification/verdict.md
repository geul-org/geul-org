---
title: "VERDICT"
weight: 69
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "VERDICT는 문서 전체의 판정 결과(Pass, Review, Fail)를 1 WORD로 적는 검증 Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

문서 전체의 판정 결과를 적는다. 노드·레코드 단위 판정은 TOULMIN `VERDICT`가 맡는다.

## 레이아웃

```
TAG WORD          0001 1LLL L100 0100      Codec 0x44
[Length 확장 TAG]
판정              1 WORD (0 Pass, 1 Review, 2 Fail)
```

- Codec: Meta `0x44`, 검증 클래스(`100`)
- Payload: 날값(판정 1 WORD)
- 개수: 많아야 하나

## 해석과 유효성

- 검증 클래스라 내용 해시에서 빠진다.
- 다른 문서에 대한 판정은 판정 대상과 다른 문서의 BODY에 둔다.

## 열린 문제

- 판정 주체와 근거를 함께 적을지.
