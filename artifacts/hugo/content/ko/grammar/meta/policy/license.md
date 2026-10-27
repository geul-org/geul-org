---
title: "LICENSE"
weight: 81
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "LICENSE는 이 문서와 바이트열 안 저작물의 라이선스를 적는 정책 Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

이 문서와 바이트열 안 저작물의 라이선스를 적는다.

## 레이아웃

```
TAG WORD          0001 1LLL L101 0000      Codec 0x50
[Length 확장 TAG]
Payload           라이선스를 가리키는 Reference, 또는 SPDX 식별자 UTF8-TEXT, 또는 URI Value
```

- Codec: Meta `0x50`, 정책 클래스(`101`)
- Payload: 내장 Reference 또는 Value([UTF8-TEXT](/ko/grammar/value/text/utf8-text/), [URI](/ko/grammar/value/text/uri/))
- 개수: 많아야 하나

## 해석과 유효성

- geul.org 공표 문서는 CC0다. 사설 공표는 Issuer가 정한다([Issuer](/ko/grammar/issuer/)).
- 원천 저작물의 원래 라이선스를 기록한다.

## 열린 문제

- SPDX 식별자를 텍스트로 둘지, GEUL 엔티티 Reference로 둘지.
