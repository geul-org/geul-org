---
title: "FRACTION"
weight: 8
date: 2026-10-28T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "FRACTION은 분자(정수·10진수)와 분모(부호 없는 정수·10진수)를 원문 표기 그대로, 약분하지 않고 담는 분수 Value다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FRACTION은 원문에 적힌 분수를 표기 그대로 나타내는 Value다. Value 직접 코드 `0x07`, 계열 NUMERIC이다. 분자와 분모는 각각 완전한 Value 레코드다. 약분하지 않는다. 법령의 "3분의 2", "100분의 5"와 등기의 소수 지분 `23.45/1256.1`처럼 적힌 그대로가 기록인 분수를 담는다.

## 레이아웃

```
TAG WORD          0000 1LLL L000 0111      Codec 0x07
[Length 확장 TAG] 전체 15 WORD 이상일 때
numerator         Value 레코드 1개: SIGNED-INTEGER 또는 SIGNED-DECIMAL
denominator       Value 레코드 1개: UNSIGNED-INTEGER 또는 UNSIGNED-DECIMAL
```

## 해석과 유효성

- numerator는 [SIGNED-INTEGER](/ko/grammar/value/numeric/signed-integer/)(`0x01`) 또는 [SIGNED-DECIMAL](/ko/grammar/value/decimal/signed-decimal/)(`0x10`) 레코드 정확히 하나다.
- denominator는 [UNSIGNED-INTEGER](/ko/grammar/value/numeric/unsigned-integer/)(`0x02`) 또는 [UNSIGNED-DECIMAL](/ko/grammar/value/decimal/unsigned-decimal/)(`0x11`) 레코드 정확히 하나다.
- 닫힌 목록이다. 그 밖의 Value, FRACTION 자신(중첩 금지), 자리 표지(`0x0000` 등)는 받지 않는다.
- 두 레코드는 각자 길이를 가지므로 경계를 따로 적지 않는다. 두 레코드를 읽은 커서는 Payload 끝과 정확히 맞아야 한다.
- 안쪽 레코드도 각 Codec의 정규형을 따른다(정수·coefficient는 최소 WORD). 비정규 안쪽 레코드가 있으면 FRACTION 전체가 invalid다.
- 값은 `numerator / denominator`다.

### 표기 보존

- **정수와 소수**: 원문 성분이 정수(소수점 없음)이면 INTEGER 레코드, 소수점이 있으면 DECIMAL 레코드를 쓴다. 성분을 지수 `E = 0`인 DECIMAL로 쓰면 invalid다. 그래서 같은 표기는 바이트열이 하나다.
- DECIMAL 성분의 C와 E는 원문 자릿수 그대로다. `23.450`은 `23450×10^-3`이고 `23.45`와 다른 Value다.
- **약분하지 않는다.** `2/4`, "100분의 5"(`5/100`)는 그대로 쓴다. 바이트가 같으면 원문 표기가 같다.
- 분모가 1인 분수(`3/1`)도 원문이 그렇게 적었으면 그대로 쓴다. 원문이 정수면 FRACTION이 아니라 정수 Codec을 쓴다. 원문이 소수(`0.5`, `5%`)면 DECIMAL을 쓴다.
- 부호는 분자에만 둔다. 분모는 부호 없는 Codec이다.
- 분모의 값이 0이면 invalid다(`0`, `0.0` 모두).

### 비교

- 비교 계층은 FRACTION을 정확한 유리수 `(C1 × 10^E1) / (C2 × 10^E2)`로 계산한다(INTEGER 성분은 `E = 0`). 부동소수로 근사하지 않는다.
- 비교·정렬·중복 판정은 이 값으로 하고, 저장·서명·내용 해시는 표기(바이트)로 한다. `2/4`, `1/2`, `0.5`는 값이 같고 바이트가 다르다.
- 정족수 판정("출석한 주주의 의결권의 3분의 2 이상")은 이 정확한 값으로 비교한다.

## 길이

- 전체는 TAG 1 WORD + (Length 확장 TAG) + 두 레코드다. 정수 레코드는 TAG 1 + Payload 1 WORD 이상, 10진수 레코드는 TAG 1 + 지수 2 + coefficient 1 WORD 이상이다.
- 작은 정수 분수는 5 WORD, 작은 소수 분수는 9 WORD다. 15 WORD 이상이면 확장 길이를 쓴다([레코드와 TAG WORD](/ko/grammar/record/)).

| 원문 | 성분 | 전체 |
|---|---|---|
| `2/3` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `5/100` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `23.45/1256.1` | DECIMAL 4 WORD + DECIMAL 4 WORD | 9 WORD |

## 예시

`2/3`:

```
0A07 0881 0002 0882 0003
```

- TAG `0A07`(Codec `0x07`, 5 WORD), numerator `0881 0002`(SIGNED-INTEGER 2), denominator `0882 0003`(UNSIGNED-INTEGER 3).

`23.45/1256.1`:

```
0C07 0990 FFFF FFFE 0929 0991 FFFF FFFF 3111
```

- TAG `0C07`(9 WORD), numerator `0990 FFFF FFFE 0929`(SIGNED-DECIMAL E = -2, C = 2345), denominator `0991 FFFF FFFF 3111`(UNSIGNED-DECIMAL E = -1, C = 12561).

## 다른 형식과의 관계

- [QUANTITY](/ko/grammar/value/numeric/quantity/)의 amount·lower·upper는 FRACTION을 받는다. "출석 의결권의 3분의 2"는 amount `2/3`, 무단위 QUANTITY로 쓸 수 있다.
- geul.org 규격 문서 `0x0000/0x0000000000000807`은 numerator(`0801`·`0810`), denominator(`0802`·`0811`)의 레코드 필드 둘로 적는다([Codec 규격 문서](/ko/grammar/codec-spec/)).
- 약분을 강제하는 고정 int64 분수가 필요하면 Issuer 형식 [RATIONAL-I64](/ko/grammar/value/etc/rational-i64/)를 쓴다.

## 열린 문제

1. 대분수(`1과 2/3`)의 표기 보존.
2. 성분에 단위가 있는 분수(면적/면적)를 QUANTITY 둘로 담는 형식. FRACTION은 단위를 담지 않는다.
3. 백분율·퍼밀(`5%`, `5‰`)을 DECIMAL과 단위로 둘지, FRACTION(`5/100`)으로 둘지의 표기 기준.
4. 번분수(분자·분모에 FRACTION). 지금은 금지한다.

## 관련 페이지

- [Value](/ko/grammar/value/), [QUANTITY](/ko/grammar/value/numeric/quantity/), [SIGNED-INTEGER](/ko/grammar/value/numeric/signed-integer/), [SIGNED-DECIMAL](/ko/grammar/value/decimal/signed-decimal/), [RATIONAL-I64](/ko/grammar/value/etc/rational-i64/)
