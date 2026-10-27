---
title: "FIELD"
weight: 29
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "FIELD는 Codec Payload의 필드 하나를 선언하는 서술 Edge다(Codec 0x1C). 속한 DECLARE와 폭(레코드, 날값 n WORD, 나머지 날값)을 적는다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FIELD는 Codec Payload의 필드 하나를 선언하는 서술 Edge다. Codec `0x1C`.

FIELD가 자기 [DECLARE](/ko/grammar/edge/declare/)를 가리킨다. 한 DECLARE를 가리키는 FIELD들이 문서 안 순서대로 Payload를 구성한다. 레이아웃은 디코더에 내장한다([Codec 규격 문서](/ko/grammar/codec-spec/)).

## 레이아웃

```
TAG WORD          0001 0LLL L001 1100
Edge Id           LOCAL Reference 레코드
DECLARE           LOCAL Reference 레코드. 이 필드가 속한 DECLARE Edge
폭                1 WORD. 0 = 레코드, n (1~65534) = 날값 n WORD, 0xFFFF = 나머지 날값
```

## 해석과 유효성

- DECLARE는 같은 문서의 DECLARE Edge를 가리킨다. FIELD 하나는 DECLARE 하나에만 속한다. 순서는 따로 적지 않으며 FIELD 레코드가 문서에 놓인 순서다.
- FIELD 규격 문서는 DECLARE를 폭 `0`(레코드), CODEC `0008`(LOCAL)인 필드로 선언한다. 그래서 뷰어 그래프에서 FIELD → DECLARE 연결로 그려진다.
- 폭 `0`은 레코드 필드다. TAG WORD로 시작하고 그 TAG의 Length만큼 읽는다([DECLARE](/ko/grammar/edge/declare/) 해석 규칙).
- 폭 `n`(1~65534)은 날값 필드다. 언제나 정확히 n WORD다.
- 폭 `0xFFFF`는 나머지 날값이다. DECLARE에 하나만 두며 앞·중간·끝 어디든 된다. 폭은 바깥 레코드의 TAG Length가 정한 남은 WORD에서 뒤 필드들의 폭을 뺀 값이다. 그래서 나머지 필드 뒤의 필드는 모두 고정 폭 날값이어야 한다(레코드는 앞에서부터 읽어야 끝을 알 수 있다). 0 WORD일 수 있다. ENUM을 붙이지 않는다.
- 필드가 받는 Kind·Codec은 [CODEC](/ko/grammar/edge/codec/)으로 지정한다. 레코드 필드는 CODEC이 없으면 아무 레코드나 받고, 있으면 그중 하나여야 한다. 날값 필드에 CODEC을 하나 두면 그 날값을 TAG를 뺀 그 Value로 해석한다.
- 필드 이름은 FIELD Edge Id에 [BIND](/ko/grammar/edge/bind/)로 묶는다(예: `doc`, `hash`). DECLARE·FIELD·ENUM·CODEC에 붙이는 UTF8-TEXT는 모두 BIND로 하며, LABEL 등 다른 Edge로 붙이지 않는다.
- 날값 필드의 코드값 의미는 [ENUM](/ko/grammar/edge/enum/)으로 붙인다.
- 그래프에서 다른 노드를 가리키는 필드는 따로 표시하지 않는다. 레코드 필드가 Reference면 그것이 연결이다.

## 길이

```
전체 = 1 + 2 + 2 + 1 WORD   (Edge Id·DECLARE가 LOCAL 1 WORD ID일 때)
```

## 예시 (비규범)

- 레코드 필드: Edge Id 7, DECLARE #1, 폭 `0`. TAG 1 + Edge Id 2 + DECLARE 2 + 폭 1 = 6 WORD. LOCAL만 받게 하려면 [CODEC](/ko/grammar/edge/codec/) 예시를 본다.

```
129C 0088 0007 0088 0001 0000
```

- 내용 해시 같은 날값 필드는 [DECLARE](/ko/grammar/edge/declare/) 예시를 본다.

## 관련 페이지

- [DECLARE](/ko/grammar/edge/declare/), [ENUM](/ko/grammar/edge/enum/), [CODEC](/ko/grammar/edge/codec/), [BIND](/ko/grammar/edge/bind/)
- [Codec 규격 문서](/ko/grammar/codec-spec/)
