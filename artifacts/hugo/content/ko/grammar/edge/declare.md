---
title: "DECLARE"
weight: 28
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DECLARE는 Codec 하나의 Payload 구성을 선언하는 서술 Edge다(Codec 0x0BBL). FIELD·ENUM·CODEC과 함께 Codec 규격 문서를 쓰는 어휘다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DECLARE는 Codec 하나의 Payload 구성을 선언하는 서술 Edge다. Codec `0x0BBL`.

[FIELD](/ko/grammar/edge/field/)(`0x0BCL`), [ENUM](/ko/grammar/edge/enum/)(`0x0BDL`), [CODEC](/ko/grammar/edge/codec/)(`0x0BEL`)와 함께 Codec 규격을 쓰는 어휘다([Codec 규격 문서](/ko/grammar/codec-spec/)). 네 Edge의 레이아웃은 디코더에 내장한다. 이 어휘로 쓴 각 Codec 규격 문서는 일반 문서다. 규격 하나로 검증, 분해, 표시(뷰어)를 함께 한다. 뷰어는 Codec마다 코드를 두지 않고 규격대로 그린다.

## 레이아웃

```
TAG WORD          0000 1011 1011 LLLL
[Length 확장 TAG]
Edge Id           LOCAL Reference 레코드
대상              1 WORD. 선언하는 Codec의 TAG WORD에서 Kind·Codec 자리만 쓴다 (LLLL = 0)
[Issuer·코덱 번호] 대상이 Issuer 형식일 때. Issuer와 코덱 번호 2 WORD. Codec 확장 TAG와 같은 레이아웃이고 세 Kind가 같다
```

- 필드 목록은 DECLARE에 두지 않는다. 각 [FIELD](/ko/grammar/edge/field/)가 자기 DECLARE를 가리키며, 그 FIELD들의 문서 안 순서가 Payload 필드 순서다.

## 해석 규칙

Codec 규격으로 레코드를 읽고 표기하는 규칙이다.

- 날값 필드는 FIELD가 선언한 고정 WORD 수만큼 읽는다. 필드 하나는 나머지 날값(폭 `0xFFFF`)일 수 있으며, 남은 WORD에서 그 뒤 고정 필드들의 폭을 뺀 만큼 읽는다. 나머지 필드 뒤에는 고정 폭 날값만 둔다.
- 레코드 필드는 TAG WORD로 시작하며, 그 TAG의 Length만큼 읽는다.
- 날값 필드는 n WORD 빅엔디언 부호 없는 정수다. 표기는 `0x` + 폭×4자리 hex이며, 같은 값의 ENUM이 있으면 그 BIND 이름을 함께 표기한다.
- 레코드 필드의 의미는 그 레코드의 Codec 규격이 정한다. 부호·소수·날짜처럼 해석이 필요한 값은 날값이 아니라 Value 레코드로 둔다.

그 밖의 경계 규칙은 없다. 가변 날값이 둘 이상이거나, 가변 날값 뒤에 레코드·가변 필드가 오거나, 날값의 폭이 다른 필드 값이나 문서 상태에 따라 달라지는 Codec은 이 어휘로 선언할 수 없다. 그런 레이아웃은 가변 부분을 레코드로 감싸 하나만 남긴다(예: SIGNATURE의 서명자는 Reference 레코드).

## 유효성

- 대상의 Kind는 Reference, Value, Edge, Meta 중 하나다. Reference의 5Q 체계는 체계 머리 코드(Identified, C가 5의 배수)로 둔다. 포인터는 그 코드(`0x040L`, `0x041L`, `0x042L`) 그대로다. REFERENCE-ISSUER의 코덱은 그 Issuer의 문서가 정의한다.
- [자리 표지](/ko/grammar/reference/slot-marker/)(Reference `0x000L~0x002L`)는 DECLARE의 대상이 될 수 없다. 디코더에 내장한다(0층).
- Edge의 Edge Id는 FIELD로 선언하지 않는다. 모든 Edge의 첫 요소라 암묵적이다([Edge](/ko/grammar/edge/)).
- DECLARE의 필드는 그것을 가리키는 FIELD들이며, 0개일 수 있다. FIELD 하나는 DECLARE 하나에만 속한다. 같은 모양의 필드라도 DECLARE마다 FIELD를 따로 둔다.
- DECLARE에는 대상(과 Issuer 형식 대상의 Issuer·코덱 번호) 말고 아무것도 없다.
- 필드를 차례로 읽은 커서는 레코드 끝과 정확히 맞아야 한다. 남거나 모자라면 그 레코드는 규격 위반이다.
- 한 문서에서 같은 대상을 두 번 선언하지 않는다.
- 꼬리 필드가 다른 변형은 분기로 쓰지 않는다. Codec마다 DECLARE를 따로 둔다.

## 규격 문서

- 직접 코드의 규격 문서는 GEUL Issuer `0x00000000`의 코덱 문서다. 코덱 ID는 대상 TAG WORD(L=0)를 32비트로 쓴 값이며(`0x0B80` → `0x00000b80`), `<Issuer>/codecs/<코덱 ID>/`에 버전 ID와 `versions.geul`로 공표한다([Codec 규격 문서](/ko/grammar/codec-spec/)).
- Issuer 코덱의 코덱 문서는 그 Issuer의 `<Issuer>/codecs/<코덱 번호>/`에 둔다. 코덱 번호는 Kind와 상관없이 그 Issuer 안에서 겹치지 않는다. 해석기는 레코드의 Kind와 DECLARE 대상의 Kind가 다르면 오류로 본다([공표 주소와 버전 목록](/ko/grammar/publishing/#id-표기)).
- 규격 문서 하나에 DECLARE는 하나이며, 그 대상이 코덱 ID의 TAG WORD와 같아야 한다. `DOC-ID`는 [CODEC-POINTER](/ko/grammar/reference/codec-pointer/)(`0x00000000`, 그 코덱 ID, `0`)다.

## 이름

- Codec 이름은 DECLARE Edge Id에 [BIND](/ko/grammar/edge/bind/)로 묶는다(예: `PUBLICATION`). DECLARE·FIELD·ENUM·CODEC에 붙이는 UTF8-TEXT는 모두 BIND로 하며, LABEL 등 다른 Edge로 붙이지 않는다.
- 필드 이름과 enum 이름도 같은 방식으로 FIELD·ENUM에 묶는다.

## 예시

PUBLICATION(Edge `0x0B8L`)의 규격 문서 `0x00000000/codecs/0x00000b80/`: Edge Id 다음에 DOC-POINTER 레코드, 내용 해시 16 WORD.

```
0BB3 0051 0001 0B80                 DECLARE #1  Edge 0x0B8L               (BIND "PUBLICATION")
0BC5 0051 0002 0051 0001 0000       FIELD #2    DECLARE #1, 레코드         (BIND "doc")
0BE5 0051 0009 0051 0002 0040       CODEC #9    FIELD #2, DOC-POINTER
0BC5 0051 0004 0051 0001 0010       FIELD #4    DECLARE #1, 날값 16 WORD   (BIND "hash")
```

- DECLARE: TAG 1 + Edge Id 2 + 대상 1 = 4 WORD, `LLLL = 0011`.
- FIELD: TAG 1 + Edge Id 2 + DECLARE 2 + 폭 1 = 6 WORD(`LLLL = 0101`). 받는 Kind·Codec은 [CODEC](/ko/grammar/edge/codec/)으로 따로 둔다(`0410` = DOC-POINTER).
- 선택 필드는 CODEC 대상 `0000`으로 선언한다. 생략한 자리에는 ABSENT(`0x0000`)를 쓴다([CODEC](/ko/grammar/edge/codec/) 선택 필드).
- 필드 순서는 FIELD #2, #4가 문서에 놓인 순서다. Edge Id는 이어지지 않아도 된다(LOCAL AUTO INCREMENT는 권고).

## 열린 문제

- 반복. `CALL`의 "인자 × 인자 수"처럼 앞 날값이 개수를 정하는 구성. 지금은 선언할 수 없다.
- 하위 형식(Codec별 TAG)을 가진 Codec(WORLD 등)의 선언 방법.
- `SPEC-VERSION`이 직접 코드 규격 문서들의 어느 버전 묶음을 뜻하는지.

## 관련 페이지

- [FIELD](/ko/grammar/edge/field/), [ENUM](/ko/grammar/edge/enum/), [CODEC](/ko/grammar/edge/codec/), [BIND](/ko/grammar/edge/bind/)
- [Edge](/ko/grammar/edge/), [Codec 규격 문서](/ko/grammar/codec-spec/)
