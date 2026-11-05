---
title: "EDTF (0x06EL·0x06FL)"
weight: 110
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "EDTF는 ISO 8601-2 확장 날짜 문자열로 연·월 정밀도, 기원전, 불확실, 구간 같은 날짜를 담는 Value다(Codec 0x06EL/0x06FL)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDTF는 ISO 8601-2 확장 날짜 문자열로 연·월 정밀도, 기원전, 불확실, 구간 같은 날짜를 담는 Value다(Codec 0x06EL/0x06FL).

| 항목 | 값 |
|---|---|
| 이름 | `EDTF` (홀짝 묶음. 코드별 이름은 아래 구성원 표) |
| TAG ID | `0x06EL`·`0x06FL` |
| 섹션 | 3 `0011` (Value), 섹션 안 오프셋 C = 14~15 |
| Kind | Value · 계열: TIME |
| 색인 설명 | EDTF(ISO 8601-2) 날짜 문자열. 짝수·홀수 바이트. GREGORIAN-DATE로 쓸 수 있는 날짜는 쓰지 않는다 |
| Hugo 쪽 | `value/time/edtf.md` |

## 구성원

이 쪽은 홀짝 쌍 두 코드를 함께 다룬다. 짝수 코드는 바이트 수가 짝수, 홀수 코드는 홀수인 값이다([레코드와 TAG WORD](../record.md#가변-길이-바이트열)). 코덱 문서는 코드마다 하나다. 두 코덱 문서의 필드는 같고 DECLARE 대상과 이름(BIND)만 다르다.

| TAG ID | 이름 | 바이트 수 | 코덱 ID | 규격 문서 | TAG WORD |
|---|---|---|---|---|---|
| `0x06EL` | `EDTF-EVEN` | 짝수 | `0x000006E0` | `0x00000000/codecs/0x000006E0/` | `0000 0110 1110 LLLL` |
| `0x06FL` | `EDTF-ODD` | 홀수 | `0x000006F0` | `0x00000000/codecs/0x000006F0/` | `0000 0110 1111 LLLL` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | 나머지 날값(`0xFFFF`) |  |  |

EDTF는 [Extended Date/Time Format](https://www.loc.gov/standards/datetime/edtf.html)(미 의회도서관, ISO 8601-2:2019) 문자열로 날짜를 담는 Value다. 날보다 거친 정밀도, 기원전, 불확실·대략·일부 미상, 구간을 나타낸다.

## 레이아웃

- 코드: Value 직접 코드 `0x06EL`(짝수 바이트)·`0x06FL`(홀수 바이트). 계열 TIME. Payload는 문자열이지만 TIME 계열에 둔다.
- 바이트 수는 Codec의 최하위 비트와 Payload WORD 수로 정한다. `2 × Payload WORD 수 − 최하위 비트`이며 Byte Count는 두지 않는다([Value](_index.md)).

```
TAG WORD          0000 0110 111P LLLL      Codec 0x06EL/0x06FL (P = 홀수 바이트)
[Length 확장 TAG] 전체 15 WORD 이상일 때
Payload WORD 1st ... Nth          EDTF 문자열의 ASCII 바이트 / 홀수면 마지막 0x00
```

## 해석과 유효성

- 바이트열은 EDTF Level 0·1·2 문법을 따르는 ASCII 문자열이다. 빈 문자열은 invalid다.
- 예: 일 `1952-03-11`, 월 `1952-03`, 연 `1952`, 10년 `195X`, 기원전 44년 `-0043`, 불확실 `1974?`, 대략 `~1974`, 구간 `1952/2001`, 큰 연도 `Y-13799999999`.
- 연도는 ISO 8601 천문식이다. `0000`은 기원전 1년, `-0043`은 기원전 44년이다. 역사식 표기에서 옮길 때는 한 해를 옮긴다.
- 그레고리력이다. EDTF는 다른 달력을 다루지 않는다. 율리우스력 같은 다른 달력의 원본 표기는 [GEDCOM-DATE](0x070L-gedcom-date.md)로 보존한다. 그 날짜와 같은 날·기간을 그레고리력으로 옮긴 값은 EDTF나 GREGORIAN-DATE로 쓸 수 있다.
- **정규형:** [GREGORIAN-DATE](0x06AL-gregorian-date.md)로 정확히 쓸 수 있는 날짜, 곧 한정자(`?`, `~`, `%`)·미상 자릿수(`X`)·구간·`Y` 접두가 없는 `[-]YYYY-MM-DD`는 GREGORIAN-DATE로 쓴다. 이런 날짜를 EDTF로 쓰면 invalid다. 같은 날이 한 형식으로만 적혀야 시간으로 색인·비교할 수 있다.
- schema는 아직 EDTF 문법을 검사하지 않는다. 생산자가 EDTF 파서로 검사한다. 예: `github.com/sfomuseum/go-edtf`(BSD-3-Clause)의 `parser.ParseString`. `parser.IsValid`는 문법만 보아 `2023-02-29`, `1974-13`도 통과시키므로 쓰지 않는다. 이 파서는 `Y` 접두 연도를 아직 지원하지 않는다.

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG(있으면)와 Payload를 합한 WORD 수다([Length](../record.md)).

## 예시

| 날짜 | 바이트 | 전체 WORD |
|---|---|---|
| `1974` | 4 (짝수) | `06E2 3139 3734` |
| `197X` | 4 (짝수) | `06E2 3139 3758` |
| `1952-03` | 7 (홀수) | `06F4 3139 3532 2D30 3300` |

## 표준 근거

- [Library of Congress, Extended Date/Time Format (EDTF) Specification](https://www.loc.gov/standards/datetime/edtf.html). Level 0은 ISO 8601-1의 부분집합, Level 1·2는 ISO 8601-2의 기능이다.
- RDF에서는 데이터타입 `http://id.loc.gov/datatypes/edtf`로 같은 문자열을 표시한다.

## 열린 문제

- 검사기의 EDTF 문법 검사(검사기가 외부 라이브러리에 기댈지 여부).
- 위키데이터의 세기·천년 정밀도를 EDTF 미상 자릿수로 옮기는 규칙.

## 관련 페이지

- [Value](_index.md), [GREGORIAN-DATE](0x06AL-gregorian-date.md), [GEDCOM-DATE](0x070L-gedcom-date.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x000006E0/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006E000000000
BODY
#1 DECLARE 0x06E0
#2 FIELD #1 rest
#3 BIND #1 "EDTF-EVEN"
#4 BIND #2 "bytes"
```

위는 `EDTF-EVEN`(`0x06EL`)의 코덱 문서다. 다른 구성원(`EDTF-ODD`)의 코덱 문서는 DOC-ID의 코덱 ID, DECLARE 대상, `#1`에 묶은 이름(BIND)만 다르다.
