---
title: "DEFAULT-LANGUAGE"
weight: 23
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "DEFAULT-LANGUAGE는 문서 텍스트의 기본 언어를 언어 Value로 선언하는 정의 Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

문서 텍스트의 기본 언어를 선언한다. 언어를 따로 적지 않은 텍스트는 이 언어다.

## 레이아웃

```
TAG WORD          0001 1LLL L001 0110      Codec 0x16
[Length 확장 TAG]
Payload           언어 Value 하나
```

- Codec: Meta `0x16`, 정의 클래스(`001`)
- Payload: 내장 Value([LANGUAGE-BCP47-CODE](/ko/grammar/value/text/language-bcp47-code/) 또는 [LANGUAGE-SHORT-CODE](/ko/grammar/value/text/language-short-code/))
- 개수: 많아야 하나

## 해석과 유효성

- TANGEUL 문서는 작성 로케일을 적는다(예: `en`, `ko`).

## 예시

- `en`: `0x1916 0x08C6 0x656E`
