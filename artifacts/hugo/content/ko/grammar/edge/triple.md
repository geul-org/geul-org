---
title: "TRIPLE"
weight: 11
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "TRIPLE은 명제 하나(Predicate, Subject, Object)와 그 등급(rank)을 담는 서술 Edge다(Codec 0x0A). Object에는 값 대신 알 수 없음(UNKNOWN-VALUE)이나 없음(NO-VALUE)을 쓸 수 있다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TRIPLE은 명제 하나(Predicate, Subject, Object)와 그 등급(rank)을 담는 서술 Edge다. Codec `0x0A`.

명제를 한정하는 조건(시작·종료 시점, 적용 범위 등)은 TRIPLE의 Edge Id를 가리키는 [QUALIFIER](/ko/grammar/edge/qualifier/)로 붙인다. 출처(위키데이터 references)는 TRIPLE의 Edge Id를 가리키는 근거 Edge [SOURCE](/ko/grammar/edge/source/)로 붙인다.

## 레이아웃

```
TAG WORD          0001 0LLL L000 1010
[Length 확장 TAG]
Edge Id           LOCAL Reference 레코드
Predicate         Reference 레코드 (WIKIDATA-PID 등)
Subject           Reference 레코드
Object            Reference 또는 Value 레코드, 또는 자리 표지 0x0001 UNKNOWN-VALUE·0x0002 NO-VALUE
Rank              1 WORD (ENUM)
```

## Rank

| 코드 | 이름 | 뜻 |
|---|---|---|
| `0` | normal | 기본 |
| `1` | preferred | 현재 값, 가장 권위 있는 값 |
| `2` | deprecated | 틀렸거나 낡았다고 판정됐지만 기록으로 남긴 값 |

- 위키데이터 statement rank와 같다. 대표 값(위키데이터 truthy)은 같은 Subject·Predicate 중 preferred가 있으면 preferred, 없으면 normal이다.
- rank를 따로 매기지 않는 출처는 `0`(normal)을 쓴다.
- 그 밖의 코드는 invalid다.

## 해석과 유효성

- Predicate, Subject는 정확히 하나의 완전한 Reference 레코드다.
- Object는 정확히 하나의 완전한 Reference 또는 Value 레코드, 또는 [자리 표지](/ko/grammar/reference/slot-marker/) `0x0001`(UNKNOWN-VALUE)·`0x0002`(NO-VALUE) 1 WORD다. ABSENT(`0x0000`)는 받지 않는다. Object는 선택 필드가 아니다.
- Object를 읽은 뒤 정확히 1 WORD(Rank)가 남아야 한다.
- geul.org 규격 문서는 Rank 날값 필드에 [CODEC](/ko/grammar/edge/codec/) UNSIGNED-INTEGER(`0802`)와 [ENUM](/ko/grammar/edge/enum/) 0·1·2를 둔다. Object 필드에는 CODEC `0780`(아무 Reference), `0F80`(아무 Value), `0001`(UNKNOWN-VALUE), `0002`(NO-VALUE)를 둔다. Predicate·Subject는 자리 표지를 받지 않는다.
- **TRIPLE의 의미는 같은 문서에서 그 Edge Id를 가리키는 QUALIFIER를 모두 모은 것이다.** 읽는 쪽은 TRIPLE을 해석하기 전에 QUALIFIER를 모은다. QUALIFIER 없이 읽은 TRIPLE은 한정이 빠진 명제일 수 있다(예: 시간 한정이 빠진 "행정부 수반").

## 알 수 없음과 없음

Object 자리의 자리 표지는 값이 아니라 명제에 관한 단언이다.

| Object | 뜻 | 논리 |
|---|---|---|
| 값 v | Subject의 Predicate 값 중 하나가 v다 | `P(s, v)` |
| UNKNOWN-VALUE (`0x0001`) | 값이 있다. 무엇인지 모른다(위키데이터 `somevalue`) | `∃x. P(s, x)` |
| NO-VALUE (`0x0002`) | 값이 없다(위키데이터 `novalue`) | `¬∃x. P(s, x)` |
| TRIPLE 없음 | 아무것도 단언하지 않는다(열린 세계) | |

- **한정 조건 안에서 읽는다.** `∃`·`¬∃`의 범위는 그 TRIPLE을 가리키는 QUALIFIER가 정한다. QUALIFIER가 붙으면 그 범위에서만 닫힌다. "1811~1816년에는 중앙은행이 없었다"는 NO-VALUE TRIPLE에 P580·P582 QUALIFIER를 붙여 쓴다. 같은 Predicate의 다른 시기 값 TRIPLE과 모순되지 않는다.
- **rank는 똑같이 적용된다.** 대표 값(truthy)을 고를 때 UNKNOWN-VALUE·NO-VALUE TRIPLE도 후보에 든다. preferred가 있으면 preferred만 남는다.
- **UNKNOWN-VALUE끼리는 같지 않다.** UNKNOWN-VALUE는 어떤 값과도 같지도 다르지도 않고(비교 결과 미정), 두 UNKNOWN-VALUE끼리도 같은 값으로 보지 않는다. 출현마다 독립된 존재 양화다. 그래서 바이트가 같은 UNKNOWN-VALUE TRIPLE 두 개는 중복이 아니며 병합하지 않는다(자녀가 둘일 수도 하나일 수도 있다).
- 같은 Subject·Predicate·rank에 NO-VALUE와 값(또는 UNKNOWN-VALUE) TRIPLE이 한정 조건이 구별되지 않은 채 함께 있으면 모순이다. 검사기는 경고한다. 거부하지는 않는다(위키데이터에도 있는 상태다).
- 옮기지 못한 값(원천에는 값이 있다)을 UNKNOWN-VALUE로 쓰지 않는다.

## 예시 (비규범)

Q42(Douglas Adams) P31(instance of) Q5(human), normal. Edge Id `0005`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 2 + Rank 1 = 10 WORD, `LLLL=1001`. TAG는 `0001 0 1001 0001010` = `148A`다.

```
148A 0088 0005 00A8 001f 00A0 002a 00A0 0005 0000
```

Q30(미국) P1304(중앙은행) NO-VALUE, normal. 1811~1816년에는 중앙은행이 없었다(P580·P582 QUALIFIER는 [QUALIFIER](/ko/grammar/edge/qualifier/) 예시). Edge Id `3161`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 1 + Rank 1 = 9 WORD, `LLLL=1000`. TAG는 `0001 0 1000 0001010` = `140A`다.

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000      #3161 TRIPLE P1304 Q30 NONE normal
```

- "자녀(P40) 없음"은 `140A 0088 <Edge Id> 00A8 0028 <Subject> 0002 0000`이다.

## 열린 문제

- scope(주장의 맥락: 세계, 관점): 쓰임새가 생길 때 정한다.
- TRIPLE과 QUALIFIER를 한 레코드에 접는 축약형: 반복 필드 선언([DECLARE](/ko/grammar/edge/declare/) 열린 문제)이 생긴 뒤.

## 관련 페이지

- [Edge](/ko/grammar/edge/), [QUALIFIER](/ko/grammar/edge/qualifier/), [SOURCE](/ko/grammar/edge/source/), [LABEL](/ko/grammar/edge/label/), [ALIAS](/ko/grammar/edge/alias/), [자리 표지](/ko/grammar/reference/slot-marker/)
- [WIKIDATA-PID](/ko/grammar/reference/wikidata-pid/), [WIKIDATA-QID](/ko/grammar/reference/wikidata-qid/)
