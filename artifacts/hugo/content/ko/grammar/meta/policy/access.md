---
title: "ACCESS"
weight: 82
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "ACCESS는 문서의 공개 범위(공개, 내부, 대외비)를 1 WORD 등급으로 적는 정책 Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

문서의 공개 범위를 적는다.

## 레이아웃

```
TAG WORD          0001 1LLL L101 0001      Codec 0x51
[Length 확장 TAG]
등급              1 WORD (0 공개, 1 내부, 2 대외비, 그 밖 예약)
```

- Codec: Meta `0x51`, 정책 클래스(`101`)
- Payload: 날값(등급 1 WORD)
- 개수: 많아야 하나

## 해석과 유효성

- 대외비 문서는 공표하지 않는다([Issuer](/ko/grammar/issuer/)).
- 해석을 바꾸지 않는다. 취급만 정한다.

## 열린 문제

- 등급 코드표.
