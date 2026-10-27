---
title: "CONSENT"
weight: 85
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "CONSENT는 동의 범위와 근거를 Reference 또는 텍스트로 적는 정책 Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

동의 범위와 근거를 적는다.

## 레이아웃

```
TAG WORD          0001 1LLL L101 0100      Codec 0x54
[Length 확장 TAG]
Payload           동의 근거를 가리키는 Reference 또는 텍스트
```

- Codec: Meta `0x54`, 정책 클래스(`101`)
- Payload: 내장 Reference 또는 Value
- 개수: 여럿 가능

## 열린 문제

- 범위 표현(목적·기간·제3자 제공)의 구조.
