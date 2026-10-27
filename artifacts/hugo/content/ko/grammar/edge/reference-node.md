---
title: "REFERENCE-NODE"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "REFERENCE-NODE는 Reference 하나를 Object 레코드 하나에 묶어 그 Reference가 무엇인지 정의하는 방향성 서술 Edge다(Codec 0x00)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REFERENCE-NODE는 Reference 하나를 Object 레코드 하나에 연결해, 그 Reference가 무엇인지 정의하거나 바인딩하는 방향성 서술 Edge다. Codec `0x00`.

Subject가 Object를 지시한다. 이 바인딩은 의미상 동일성을 주장하는 [SAME-NODE](/ko/grammar/edge/same-node/)가 아니며, 두 레코드의 byte가 같다는 뜻도 아니다.

## 레이아웃

```
TAG WORD          0001 0LLL L000 0000
[Length 확장 TAG]
Edge Id           LOCAL Reference 레코드
Subject           Reference 레코드 1개
Object            Reference 또는 Value 레코드 1개
```

## 해석과 유효성

- Subject는 정확히 하나의 완전한 [Reference](/ko/grammar/reference/) 레코드여야 한다. Subject 자체의 Length로 경계를 찾으며, Reference가 아니거나 불완전하면 invalid다.
- Object는 정확히 하나의 완전한 Reference 또는 Value 레코드여야 한다. Object 자체의 Length로 경계를 찾으며, Edge·Meta이거나 불완전하면 invalid다.
- Object가 Reference이면, REFERENCE-NODE 바인딩으로 따라가는 Reference 사슬은 순환하지 않아야 하며 LOCAL은 끝내 해소되어야 한다. 해소 순환과 dangling LOCAL은 invalid다.
- 같은 문서에서 LOCAL ID 하나가 서로 충돌하는 Object로 바인딩되면 invalid다. LOCAL의 범위, ID, 최소 폭과 병합 규칙은 [LOCAL](/ko/grammar/reference/local/)을 따른다.
- 모든 Reference가 REFERENCE-NODE로 바인딩되어야 하는 것은 아니다.
- 대표 용례는 `LOCAL → UTF8-LANGUAGE-TEXT`다. [LABEL](/ko/grammar/edge/label/)의 Object에 LOCAL을 두었을 때, 같은 문서의 이 바인딩으로 텍스트를 해소한다.

Subject가 Object를 지시하는 방향을 거꾸로 해석해서는 안 된다. SAME과 DIFFERENT의 의미와 세부 규칙은 각 형식이 따로 정한다.

## 길이

```
전체 = 1 + N_len + N_id + N_subject + N_object WORD
```

`N_len`은 Length 확장 TAG WORD 수, `N_id`는 Edge Id LOCAL 레코드의 WORD 수, `N_subject`·`N_object`는 각 레코드의 전체 WORD 수다. Subject와 Object를 모두 읽은 커서는 Edge 끝과 정확히 맞아야 한다.

## 예시 (비규범)

Edge Id `0008`, Subject는 LOCAL 1, Object는 `Donald Trump`(en)의 [UTF8-LANGUAGE-TEXT](/ko/grammar/value/text/utf8-language-text/)다.

- Edge Id는 `0088 0008`로 2 WORD다.
- Subject는 `0088 0001`로 2 WORD다.
- Object는 언어 `08C6 656e`(BCP47 `en`) + 텍스트 12 byte(짝수)라 `UTF8-LANGUAGE-TEXT-EVEN`(`0x4A`), 전체 9 WORD다. TAG는 `0C4A`다.
- Edge는 TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, `LLLL=1101`이다. TAG는 `1680`이다.

```
1680 0088 0008 0088 0001 0C4A 08C6 656e 446f 6e61 6c64 2054 7275 6d70
```

## 관련 페이지

- [Edge](/ko/grammar/edge/), [SAME-NODE](/ko/grammar/edge/same-node/), [DIFFERENT-NODE](/ko/grammar/edge/different-node/), [LABEL](/ko/grammar/edge/label/)
- [Reference](/ko/grammar/reference/), [LOCAL](/ko/grammar/reference/local/), [UTF8-LANGUAGE-TEXT](/ko/grammar/value/text/utf8-language-text/)
