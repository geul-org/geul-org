---
title: "EDTF"
weight: 37
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "EDTF는 ISO 8601-2 확장 날짜 문자열로 연·월 정밀도, 기원전, 불확실, 구간 같은 날짜를 담는 Value다(Codec 0x24/0x25)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDTF는 [Extended Date/Time Format](https://www.loc.gov/standards/datetime/edtf.html)(미 의회도서관, ISO 8601-2:2019) 문자열로 날짜를 담는 Value다. 날보다 거친 정밀도, 기원전, 불확실·대략·일부 미상, 구간을 나타낸다.

## 레이아웃

- 코드: Value 직접 코드 `0x24`(짝수 바이트)·`0x25`(홀수 바이트). 계열 TIME. Payload는 문자열이지만 TIME 계열에 두어, 디코더와 색인이 형식을 몰라도 시간 값으로 다룬다.
- 바이트 수는 Codec의 최하위 비트와 Payload WORD 수로 정한다. `2 × Payload WORD 수 − 최하위 비트`이며 Byte Count는 두지 않는다([Value](/ko/grammar/value/)).

```
TAG WORD          0000 1LLL L010 010P      Codec 0x24/0x25 (P = 홀수 바이트)
[Length 확장 TAG] 전체 15 WORD 이상일 때
Payload WORD 1st ... Nth          EDTF 문자열의 ASCII 바이트 / 홀수면 마지막 0x00
```

## 해석과 유효성

- 바이트열은 EDTF Level 0·1·2 문법을 따르는 ASCII 문자열이다. 빈 문자열은 invalid다.
- 예: 일 `1952-03-11`, 월 `1952-03`, 연 `1952`, 10년 `195X`, 기원전 44년 `-0043`, 불확실 `1974?`, 대략 `~1974`, 구간 `1952/2001`, 큰 연도 `Y-13799999999`.
- 연도는 ISO 8601 천문식이다. `0000`은 기원전 1년, `-0043`은 기원전 44년이다. 역사식 표기에서 옮길 때는 한 해를 옮긴다.
- 그레고리력이다. EDTF는 다른 달력을 다루지 않는다. 율리우스력 같은 다른 달력의 원본 표기는 [GEDCOM-DATE](/ko/grammar/value/time/gedcom-date/)로 보존한다. 그 날짜와 같은 날·기간을 그레고리력으로 옮긴 값은 EDTF나 GREGORIAN-DATE로 쓸 수 있다.
- **정규형:** [GREGORIAN-DATE](/ko/grammar/value/time/gregorian-date/)로 정확히 쓸 수 있는 날짜, 곧 한정자(`?`, `~`, `%`)·미상 자릿수(`X`)·구간·`Y` 접두가 없는 `[-]YYYY-MM-DD`는 GREGORIAN-DATE로 쓴다. 이런 날짜를 EDTF로 쓰면 invalid다. 같은 날이 한 형식으로만 적혀야 시간으로 색인·비교할 수 있다.
- schema는 아직 EDTF 문법을 검사하지 않는다. 생산자가 EDTF 파서로 검사한다. 예: `github.com/sfomuseum/go-edtf`(BSD-3-Clause)의 `parser.ParseString`. `parser.IsValid`는 문법만 보아 `2023-02-29`, `1974-13`도 통과시키므로 쓰지 않는다. 이 파서는 `Y` 접두 연도를 아직 지원하지 않는다.

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG(있으면)와 Payload를 합한 WORD 수다([Length](/ko/grammar/record/)).

## 예시

| 날짜 | 바이트 | 전체 WORD |
|---|---|---|
| `1974` | 4 (짝수) | `0924 3139 3734` |
| `197X` | 4 (짝수) | `0924 3139 3758` |
| `1952-03` | 7 (홀수) | `0A25 3139 3532 2d30 3300` |

## 표준 근거

- [Library of Congress, Extended Date/Time Format (EDTF) Specification](https://www.loc.gov/standards/datetime/edtf.html). Level 0은 ISO 8601-1의 부분집합, Level 1·2는 ISO 8601-2의 기능이다.
- RDF에서는 데이터타입 `http://id.loc.gov/datatypes/edtf`로 같은 문자열을 표시한다.

## 열린 문제

- schema의 EDTF 문법 검사.
- 위키데이터의 세기·천년 정밀도를 EDTF 미상 자릿수로 옮기는 규칙.

## 관련 페이지

- [Value](/ko/grammar/value/), [GREGORIAN-DATE](/ko/grammar/value/time/gregorian-date/), [GEDCOM-DATE](/ko/grammar/value/time/gedcom-date/)
