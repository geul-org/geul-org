---
title: "MESSAGE"
weight: 57
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "MESSAGE는 변경 이유를 언어가 붙은 텍스트로 적는 계보 Meta다(git commit message)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

변경 이유를 적는다(git commit message).

## 레이아웃

```
TAG WORD          0001 1LLL L011 1000      Codec 0x38
[Length 확장 TAG]
메시지            UTF8-LANGUAGE-TEXT Value 1개
```

- Codec: Meta `0x38`, 계보 클래스(`011`)
- Payload: 내장 Value([UTF8-LANGUAGE-TEXT](/ko/grammar/value/text/utf8-language-text/))
- 개수: 언어마다 많아야 하나

## 해석과 유효성

- 메시지와 언어는 UTF8-LANGUAGE-TEXT 하나에 담는다. 같은 언어의 MESSAGE는 하나다.
- geul.org 규격 문서는 [CODEC](/ko/grammar/edge/codec/) `084A`·`084B`로 적는다.
