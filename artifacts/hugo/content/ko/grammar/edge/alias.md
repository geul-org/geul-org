---
title: "ALIAS"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ALIAS는 Subject 대상의 다른 이름(별칭) 하나를 연결하는 서술 Edge다(Codec 0x05). 레이아웃은 LABEL과 같다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ALIAS는 Subject 대상의 다른 이름(별칭) 하나를 Object로 연결하는 서술 Edge다. Codec `0x05`.

[LABEL](/ko/grammar/edge/label/)은 그 언어의 대표 이름(언어마다 많아야 하나)이고, ALIAS는 같은 대상의 다른 이름이다(언어마다 여럿, 위키데이터 "also known as"). 주로 검색에 쓴다. 레이아웃과 유효성은 LABEL과 같다.

## 레이아웃

```
TAG WORD          0001 0LLL L000 0101
[Length 확장 TAG]
Edge Id           LOCAL Reference 레코드
Subject           Reference 레코드 1개
Object            UTF8-LANGUAGE-TEXT Value 또는 LOCAL Reference 레코드 1개
```

## 해석과 유효성

- Subject, Object의 규칙은 [LABEL](/ko/grammar/edge/label/)과 같다(Object는 [UTF8-LANGUAGE-TEXT](/ko/grammar/value/text/utf8-language-text/) 또는 그것으로 해소되는 LOCAL).
- 같은 Subject·언어에 ALIAS를 여럿 둘 수 있다. 순서는 문서 안 순서다.
- 같은 Subject·언어의 LABEL과 같은 텍스트를 ALIAS로 두지 않는다(대표 이름은 LABEL 하나로 충분하다). 이 규칙은 권고다.
- geul.org 규격 문서는 Object를 [CODEC](/ko/grammar/edge/codec/)으로 제한한다(`084A`·`084B`·`0008`, LABEL과 같다).

## 예시 (비규범)

Edge Id `0003`, Subject Q42(`00A0 002a`), Object `DNA`(en): 언어 `08C6 656e`(BCP47 `en`) + 텍스트 3 byte(홀수) → `UTF8-LANGUAGE-TEXT-ODD`(`0x4B`), `0A4B 08C6 656e 444e 4100`.

- TAG 1 + Edge Id 2 + Subject 2 + Object 5 = 10 WORD, `LLLL=1001`. TAG는 `1485`다.

```
1485 0088 0003 00A0 002a 0A4B 08C6 656e 444e 4100
```

## 관련 페이지

- [Edge](/ko/grammar/edge/), [LABEL](/ko/grammar/edge/label/), [DESCRIPTION](/ko/grammar/edge/description/), [UTF8-LANGUAGE-TEXT](/ko/grammar/value/text/utf8-language-text/)
