---
title: "GEDCOM-DATE"
weight: 39
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GEDCOM-DATE는 GEDCOM 7 날짜 값 문자열로 율리우스력 같은 다른 달력의 날짜를 적힌 그대로 보존하는 Value다(Codec 0x26/0x27)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEDCOM-DATE는 [GEDCOM 7](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html)(FamilySearch)의 날짜 값(`DateValue`) 문자열을 담는 Value다. 원본이 그레고리력이 아닌 달력(율리우스력 등)으로 적은 날짜를 **적힌 그대로** 보존한다.

## 레이아웃

- 코드: Value 직접 코드 `0x26`(짝수 바이트)·`0x27`(홀수 바이트). 계열 TIME.
- 바이트 수는 Codec의 최하위 비트와 Payload WORD 수로 정한다. `2 × Payload WORD 수 − 최하위 비트`이며 Byte Count는 두지 않는다([Value](/ko/grammar/value/)).

```
TAG WORD          0000 1LLL L010 011P      Codec 0x26/0x27 (P = 홀수 바이트)
[Length 확장 TAG] 전체 15 WORD 이상일 때
Payload WORD 1st ... Nth          GEDCOM 날짜 문자열의 ASCII 바이트 / 홀수면 마지막 0x00
```

## 해석과 유효성

- 바이트열은 GEDCOM 7 `DateValue` 문법을 따르는 ASCII 문자열이다. 빈 문자열은 invalid다. GEDCOM은 빈 `DateValue`를 허용하지만, 값이 없으면 레코드를 쓰지 않는다.
- 문법 요지: `[달력] [[일] 월] 연 [BCE]`. 앞에 `ABT`·`CAL`·`EST`(대략), `BEF`·`AFT`·`BET … AND …`(범위), `FROM … TO …`(기간)를 붙인다. 구분자는 공백 하나다.
- 달력: `GREGORIAN`(생략하면 기본), `JULIAN`, `FRENCH_R`, `HEBREW`, 확장 태그. 월 이름은 달력마다 정해져 있다(율리우스력은 그레고리력과 같은 `JAN`…`DEC`).
- 연도는 **역사식**이다. 0년이 없고 기원전은 `BCE`를 붙인다(`44 BCE` = 기원전 44년). EDTF·GREGORIAN-DATE의 천문식과 한 해 차이가 난다.
- schema는 바이트 형식만 검사한다: ASCII `0x20`~`0x7E`, 비어 있지 않음, 앞뒤 공백 없음. 문법과 실재하는 날인지는 생산자가 검사한다. 예: `github.com/cacack/gedcom-go/v3`(MIT)의 `gedcom.ParseDate`. 이 라이브러리의 `Validate`는 그레고리력에서만 날을 검사해 `JULIAN 30 FEB 1100`을 통과시키고, `ToGregorian`은 연·월 정밀도를 실제로 변환하지 않는다. 날짜의 실재 검사와 정규화는 따로 한다.
- **쓰는 곳:** 그레고리력 날짜는 [GREGORIAN-DATE](/ko/grammar/value/time/gregorian-date/)나 [EDTF](/ko/grammar/value/time/edtf/)로 쓴다. GEDCOM-DATE는 원본 표기를 보존해야 하는 다른 달력의 날짜에 쓴다.

## 정규화된 값과 함께 쓰기

- 같은 날짜를 시간 축에서 비교·색인하려면 그레고리력 값이 필요하다. 일 정밀도는 같은 날의 GREGORIAN-DATE, 연·월 정밀도는 그 기간의 그레고리력 구간 EDTF(`JULIAN 1300` → `1300-01-09/1301-01-08`)가 정확한 대응이다.
- 원본 표기(GEDCOM-DATE)와 정규화된 값을 두 Value로 함께 담는 방법은 아직 정하지 않았다(열린 문제).

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG(있으면)와 Payload를 합한 WORD 수다([Length](/ko/grammar/record/)).

## 예시

| 날짜 | 바이트 | 전체 WORD |
|---|---|---|
| `JULIAN 1300` | 11 (홀수) | `0B27 4a55 4c49 414e 2031 3330 3000` |

## 표준 근거

- [FamilySearch GEDCOM 7, Data types — Date](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#date), [Appendix A: Calendars and Dates](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#A-calendars). 명세 저장소의 라이선스는 Apache 2.0이다. GEUL은 형식을 참조할 뿐 명세 본문을 옮기지 않는다.
- ISO 8601, EDTF, XSD, CLDR 달력 식별자(`u-ca`)에는 율리우스력이 없다. GEDCOM 7은 달력 접두·기원전·정밀도·한정자를 한 문법으로 다루는 공개 교환 형식이다.

## 열린 문제

- 원본 표기와 정규화된 값을 함께 쓰는 방법(한 TRIPLE에 둘을 잇는 방법).
- schema의 GEDCOM 문법 검사.
- 세기·10년 정밀도. GEDCOM에는 해당 형식이 없다. 위키데이터에서 옮기지 못하는 날짜는 원문을 UTF8-TEXT로 남긴다.

## 관련 페이지

- [Value](/ko/grammar/value/), [EDTF](/ko/grammar/value/time/edtf/), [GREGORIAN-DATE](/ko/grammar/value/time/gregorian-date/)
