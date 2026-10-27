---
title: "COORDINATE-EARTH"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-EARTH는 지구(WGS 84) 위의 한 점을 위도·경도 binary64와 불확도 binary32, 불확도의 단위 Reference로 담는 Value다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COORDINATE-EARTH는 지구 위의 한 점을 위도·경도와 불확도로 나타내는 좌표 Value다. Value 직접 코드 `0x04`, 계열 NUMERIC이다. 뜻은 [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870)(geo URI)의 `geo:위도,경도;u=불확도`(좌표계 WGS 84)와 같고, 문자열이 아니라 고정 폭 수치로 담는다. 불확도는 단위를 함께 적는다. 지구 밖 천체의 좌표는 [COORDINATE-GEO](/ko/grammar/value/numeric/coordinate-geo/)(`0x05`)로 쓴다.

## 레이아웃

```
TAG WORD          0000 1LLL L000 0100      Codec 0x04
Latitude          4 WORD 날값, IEEE 754 binary64 (도)
Longitude         4 WORD 날값, IEEE 754 binary64 (도)
Uncertainty       2 WORD 날값, IEEE 754 binary32 (Unit 단위)
Unit              Reference 레코드 1개, 또는 자리 표지 0x0000 ABSENT
```

## 해석과 유효성

- Payload는 Latitude 4 WORD, Longitude 4 WORD, Uncertainty 2 WORD 뒤에 Unit 레코드 정확히 하나다. Unit을 읽은 커서는 레코드 끝과 맞아야 한다.
- 좌표계는 WGS 84다(RFC 5870의 기본 `crs=wgs84`).
- Latitude·Longitude는 Payload WORD를 big-endian 순서로 이어 붙인 IEEE 754 binary64다([BINARY-FLOAT](/ko/grammar/value/numeric/binary-float/)의 binary64와 같은 비트 배치). 단위는 도(°)다.
  - 유한한 값이어야 한다. NaN과 ±Infinity는 invalid다.
  - Latitude는 `-90 ≤ φ ≤ 90`(북쪽이 양수), Longitude는 `-180 ≤ λ ≤ 180`(동쪽이 양수)이다.
  - 축 순서는 위도, 경도다(RFC 5870·ISO 6709와 같다). WKB·GeoJSON의 x(경도)·y(위도) 순서가 아니다.
- Uncertainty는 2 WORD를 big-endian으로 이어 붙인 IEEE 754 binary32다(BINARY-FLOAT의 binary32와 같은 비트 배치). 실제 위치가 이 반경 안에 있다는 뜻이고, 값은 Unit 단위로 읽는다.
  - 유한한 `+0` 이상이어야 한다. 음수, `-0`(`8000 0000`), NaN, ±Infinity는 invalid다.
  - `0`(Unit이 있을 때): 정확한 좌표. 어느 단위로 적어도 같다.
- Unit은 Uncertainty의 단위를 가리키는 Reference다. Value는 받지 않는다. Quantifier는 Identified(`000`)다.
  - 위키데이터 단위 항목 [WIKIDATA-QID](/ko/grammar/reference/wikidata-qid/)를 쓰기를 권한다: 도 Q28390, 각분 Q209426, 각초 Q829073, 미터 Q11573, 밀리미터 Q174789 등. QID가 없는 단위는 다른 Reference(LOCAL, GEUL 등)로 가리킨다. 같은 단위를 가리키는 Reference가 여럿이면 QID가 정규형이다.
  - Unit이 미터(Q11573)이면 Uncertainty는 RFC 5870의 `u`와 같다.
- **미상**: Unit 자리에 [ABSENT](/ko/grammar/reference/slot-marker/)(`0x0000`)를 쓰고 Uncertainty는 `+0`(`0000 0000`)으로 둔다. RFC 5870에서 `u`를 생략한 경우와 같다. ABSENT인데 Uncertainty가 `+0`이 아니면 invalid다(표현을 하나로 고정한다).
- 고도는 담지 않는다. 필요하면 별도 형식으로 정한다. 위키데이터 altitude는 표본에서 쓰이지 않았고(0/23,066), 값이 있으면 변환하지 않고 원문을 UTF8-TEXT로 보존한다.
- 지구 좌표는 이 형식을 쓰기를 권한다. COORDINATE-GEO에 지구(Q2)를 적은 좌표도 invalid는 아니며, 비교하는 쪽이 같은 좌표로 맞춰 본다.
- geul.org 규격 문서 `0x0000/0x0000000000000804`는 Latitude·Longitude·Uncertainty 날값 필드에 [CODEC](/ko/grammar/edge/codec/) BINARY-FLOAT(`0803`)를 두고(4 WORD = binary64, 2 WORD = binary32), Unit 레코드 필드에 CODEC `0780`(아무 Reference)·`0000`(ABSENT)을 둔다.

## 길이

- 전체는 TAG 1 WORD + 10 WORD + Unit 레코드다.

| Unit | 전체 | TAG |
|---|---|---|
| ABSENT (1 WORD) | 12 WORD | `0D84` (`LLLL=1011`) |
| QID가 1 WORD에 들어갈 때 (2 WORD, 예: 도 Q28390) | 13 WORD | `0E04` (`LLLL=1100`) |
| QID가 2 WORD일 때 (3 WORD, 예: 각분 Q209426) | 14 WORD | `0E84` (`LLLL=1101`) |
| Unit 레코드 4 WORD 이상 | 15 WORD 이상 | 확장 길이([레코드와 TAG WORD](/ko/grammar/record/)) |

- 짝·홀 Codec 쌍은 두지 않는다.

## 위키데이터 대응

위키데이터 globecoordinate: `{"latitude":52.516666666667,"longitude":13.383333333333,"altitude":null,"precision":0.016666666666667,"globe":"http://www.wikidata.org/entity/Q2"}`

| 위키데이터 | COORDINATE-EARTH |
|---|---|
| globe `…/entity/Q2` | 이 형식(지구). 다른 천체는 COORDINATE-GEO |
| latitude, longitude | binary64 그대로 (위키데이터 값은 원래 binary64라 손실이 없다) |
| precision (도) | Uncertainty와 Unit. 아래 "정밀도" |
| precision null 또는 없음 | Unit = ABSENT, Uncertainty = `+0` (미상) |
| altitude | 버린다 (항상 null) |

- 위키데이터 precision은 측정 오차가 아니라 **기록 해상도**다(좌표를 몇 도·분·초 단위로 적었는가). GEUL Uncertainty는 그 값을 바꾸지 않고 옮긴다. 측정·좌표계 오차를 더한 반경은 아니다.

### 정밀도

precision을 환산 없이 옮긴다. 도·각분·각초 중 원래 표기를 되살리는 첫 단위를 고른다.

| precision 원문(예) | Unit | Uncertainty |
|---|---|---|
| `0.0001`, `0.0000010`, `1`, `10` (10^k 도) | 도 Q28390 | 그 값의 binary32 |
| `0.0166667` 같은 짧은 10진 표기 | 도 Q28390 | 그 값의 binary32 |
| `0.016666666666667` (1/60°) | 각분 Q209426 | `1` |
| `0.00027777777777778` (1/3600°) | 각초 Q829073 | `1` |
| `0.000027777777777778` (1/36000° = 0.1″) | 각초 Q829073 | `0.1` |

- 정변환: 도, 각분(×60), 각초(×3600) 순서로, precision에 단위 수를 곱한 값에 가장 가까운 binary32를 Uncertainty로 삼고, 아래 역변환이 precision 원문을 그대로 되돌리는 첫 단위를 쓴다.
- 역변환: Uncertainty의 가장 짧은 10진 표기(그 binary32로 다시 읽히는 가장 짧은 수)를 단위 수로 나눠 도로 바꾸고, 위키베이스가 덤프에 적는 방식(유효숫자 14자리, `1e-4` 미만은 지수 표기 `1.0e-6`·`2.7777777777778e-5`)으로 적는다. 적재 DB(jsonb)는 이것을 소수 표기 `0.0000010`·`0.000027777777777778`로 보관한다.
- 어느 단위도 원문을 되돌리지 못하면(유효숫자 17자리 표기 `0.0002777777777777778`, 계산값처럼 보이는 이상값 등) 좌표 전체를 변환하지 않고 원문을 UTF8-TEXT로 보존한다. 음수 precision과 천체가 비어 있는 값도 같다.
- 위키데이터 Q1–Q10000 표본(좌표 클레임 7,026건, precision 있음 6,824건): 원문을 되돌린 것 5,933건(86.9%; 도 4,104, 각초 1,370, 각분 459). 못 되돌린 891건 중 753건이 유효숫자 17자리 표기의 1/3600·1/60 계열이다.

## 예시

베를린 52.516666666667, 13.383333333333, precision 1/60°(각분 1):

```
0E84 404A 4222 2222 2251 402A C444 4444 4389 3F80 0000 0120 0003 3212
```

- TAG `0E84`(14 WORD), Latitude `404A 4222 2222 2251`, Longitude `402A C444 4444 4389`, Uncertainty `3F80 0000`(binary32 1.0), Unit `0120 0003 3212`(WIKIDATA-QID Q209426, 각분).
- 텍스트 표기: `COORDINATE-EARTH(52.516666666667, 13.383333333333, 1, Q209426)`.

불확도 미상인 같은 점: `0D84 404A 4222 2222 2251 402A C444 4444 4389 0000 0000 0000` (12 WORD, Unit ABSENT).

## 표준 근거

- 의미: [RFC 5870, A Uniform Resource Identifier for Geographic Locations ('geo' URI)](https://www.rfc-editor.org/rfc/rfc5870) — 위도·경도 순서, `u` 불확도(미터), 기본 좌표계 WGS 84. Unit이 미터이면 Uncertainty = `u`.
- 수치: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64(위도·경도), binary32(불확도).
- 축 순서와 범위: ISO 6709(Standard representation of geographic point location by coordinates).
- 단위: 위키데이터 단위 항목(QID). 고정 폭 배치, Unit 필드와 미상 표현은 GEUL 규칙이다.

## 열린 문제

1. 고도.
2. ISO 6709 문자열 원문을 보존하는 형식(COORDINATE-ISO6709)은 사용처가 생기면 정한다.
3. 위키데이터 precision의 유효숫자 17자리 표기(표본의 약 11%)를 무손실로 옮길 방법.

## 관련 페이지

- [Value](/ko/grammar/value/), [COORDINATE-GEO](/ko/grammar/value/numeric/coordinate-geo/), [BINARY-FLOAT](/ko/grammar/value/numeric/binary-float/), [자리 표지](/ko/grammar/reference/slot-marker/)
- Issuer 형식 [POINT2-BINARY64](/ko/grammar/value/vector/point2-binary64/)는 좌표계·단위·축 의미를 외부 문맥에 맡기는 일반 2차원 점이고, 이 형식은 지구 위의 지리 좌표다.
