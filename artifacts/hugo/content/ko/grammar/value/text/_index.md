---
title: "Value — 텍스트"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "TEXT 계열(Codec `0x40`~`0x5F`, 형식 번호 `0x8000`~`0xBFFF`)의 형식: UTF-8 텍스트, 언어가 붙은 텍스트, URI, 언어 코드."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TEXT 계열은 텍스트와 문자열 식별자 형식이다. 직접 코드 `0x40`~`0x5F`, Issuer 형식 번호 `0x8000`~`0xBFFF`에 둔다.

- 언어가 없는 문자열은 UTF8-TEXT, 이름·제목·문장처럼 언어가 있는 텍스트는 UTF8-LANGUAGE-TEXT다.
- 언어 코드(LANGUAGE-SHORT-CODE, LANGUAGE-BCP47-CODE)도 TEXT 계열이다.
- 가변 길이 바이트열은 짝수·홀수 Codec 쌍으로 둔다. 최하위 비트가 `1`이면 바이트 수가 홀수이고 마지막 WORD의 하위 바이트는 `0x00` 패딩이다([레코드와 TAG WORD](/ko/grammar/record/)).
