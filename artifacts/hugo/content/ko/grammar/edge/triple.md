---
title: "TRIPLE"
weight: 11
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "TRIPLE은 명제 하나(Predicate, Subject, Object)와 그 등급(rank)을 담는 서술 Edge다(Codec 0x0A)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TRIPLE은 명제 하나(Predicate, Subject, Object)와 그 등급(rank)을 담는 서술 Edge다. Codec `0x0A`.

명제를 한정하는 조건(시작·종료 시점, 적용 범위 등)은 TRIPLE의 Edge Id를 가리키는 [QUALIFIER](/ko/grammar/edge/qualifier/)로 붙인다.

## 레이아웃

```
TAG WORD          0001 0LLL L000 1010
[Length 확장 TAG]
Edge Id           LOCAL Reference 레코드
Predicate         Reference 레코드 (WIKIDATA-PID 등)
Subject           Reference 레코드
Object            Reference 또는 Value 레코드
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
- Object는 정확히 하나의 완전한 Reference 또는 Value 레코드다.
- Object를 읽은 뒤 정확히 1 WORD(Rank)가 남아야 한다.
- geul.org 규격 문서는 Rank 날값 필드에 [CODEC](/ko/grammar/edge/codec/) UNSIGNED-INTEGER(`0802`)와 [ENUM](/ko/grammar/edge/enum/) 0·1·2를 둔다.
- **TRIPLE의 의미는 같은 문서에서 그 Edge Id를 가리키는 QUALIFIER를 모두 모은 것이다.** 읽는 쪽은 TRIPLE을 해석하기 전에 QUALIFIER를 모은다. QUALIFIER 없이 읽은 TRIPLE은 한정이 빠진 명제일 수 있다(예: 시간 한정이 빠진 "행정부 수반").

## 예시 (비규범)

Q42(Douglas Adams) P31(instance of) Q5(human), normal. Edge Id `0005`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 2 + Rank 1 = 10 WORD, `LLLL=1001`. TAG는 `0001 0 1001 0001010` = `148A`다.

```
148A 0088 0005 00A8 001f 00A0 002a 00A0 0005 0000
```

## 열린 문제

- 출처(references): 근거 Edge `RECORD-SOURCE`(`0x21`)로 TRIPLE의 Edge Id를 가리키는 안. 출처 묶음은 LOCAL 노드로 한 번 정의하고 그 항목은 TRIPLE로 쓴다.
- scope(주장의 맥락: 세계, 관점): 쓰임새가 생길 때 정한다.
- TRIPLE과 QUALIFIER를 한 레코드에 접는 축약형: 반복 필드 선언([DECLARE](/ko/grammar/edge/declare/) 열린 문제)이 생긴 뒤.

## 관련 페이지

- [Edge](/ko/grammar/edge/), [QUALIFIER](/ko/grammar/edge/qualifier/), [LABEL](/ko/grammar/edge/label/), [ALIAS](/ko/grammar/edge/alias/)
- [WIKIDATA-PID](/ko/grammar/reference/wikidata-pid/), [WIKIDATA-QID](/ko/grammar/reference/wikidata-qid/)
