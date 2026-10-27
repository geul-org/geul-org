---
title: "PRIVACY"
weight: 83
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "PRIVACY는 문서의 개인정보 등급을 1 WORD로 적는 정책 Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

문서의 개인정보 등급을 적는다.

## 레이아웃

```
TAG WORD          0001 1LLL L101 0010      Codec 0x52
[Length 확장 TAG]
등급              1 WORD
```

- Codec: Meta `0x52`, 정책 클래스(`101`)
- Payload: 날값(등급 1 WORD)
- 개수: 많아야 하나

## 해석과 유효성

- 해석을 바꾸지 않는다. 취급만 정한다.

## 열린 문제

- 등급 코드표(개인정보 보호법 분류와의 대응).
