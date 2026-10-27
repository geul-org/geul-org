---
title: "COORDINATE-EARTH"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-EARTH는 지구(WGS 84) 위의 한 점을 위도·경도 binary64와 불확도(mm)로 담는 고정 11 WORD Value다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COORDINATE-EARTH는 지구 위의 한 점을 위도·경도와 불확도로 나타내는 좌표 Value다. Value 직접 코드 `0x04`, 계열 NUMERIC이다. 뜻은 [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870)(geo URI)의 `geo:위도,경도;u=불확도`(좌표계 WGS 84)와 같고, 문자열이 아니라 고정 폭 수치로 담는다. 지구 밖 천체의 좌표는 [COORDINATE-GEO](/ko/grammar/value/numeric/coordinate-geo/)(`0x05`)로 쓴다.

## 레이아웃

```
TAG WORD          0000 1101 0000 0100      Codec 0x04, 전체 11 WORD
Latitude          4 WORD 날값, IEEE 754 binary64 (도)
Longitude         4 WORD 날값, IEEE 754 binary64 (도)
U                 2 WORD 날값, uint32 (밀리미터)
```

## 해석과 유효성

- Payload는 정확히 10 WORD다(Latitude 4, Longitude 4, U 2). 다른 폭은 invalid다.
- 좌표계는 WGS 84다(RFC 5870의 기본 `crs=wgs84`).
- Latitude·Longitude는 Payload WORD를 big-endian 순서로 이어 붙인 IEEE 754 binary64다([BINARY-FLOAT](/ko/grammar/value/numeric/binary-float/)의 binary64와 같은 비트 배치). 단위는 도(°)다.
  - 유한한 값이어야 한다. NaN과 ±Infinity는 invalid다.
  - Latitude는 `-90 ≤ φ ≤ 90`(북쪽이 양수), Longitude는 `-180 ≤ λ ≤ 180`(동쪽이 양수)이다.
  - 축 순서는 위도, 경도다(RFC 5870·ISO 6709와 같다). WKB·GeoJSON의 x(경도)·y(위도) 순서가 아니다.
- U는 RFC 5870의 `u`(uncertainty)와 같은 뜻이다. 실제 위치가 이 반경(밀리미터) 안에 있다.
  - `0`: 정확한 좌표(RFC 5870의 `u=0`).
  - `0xFFFFFFFF`: 불확도 미상(RFC 5870에서 `u`를 생략한 경우).
  - 그 밖: 1mm 단위 반경, 최대 4,294,967,294mm(약 4,295km).
- 고도는 담지 않는다. 필요하면 별도 형식으로 정한다. 위키데이터 altitude는 표본에서 쓰이지 않았고(0/23,066), 값이 있으면 변환하지 않고 원문을 UTF8-TEXT로 보존한다.
- 지구 좌표는 이 형식을 쓰기를 권한다. COORDINATE-GEO에 지구(Q2)를 적은 좌표도 invalid는 아니며, 비교하는 쪽이 같은 좌표로 맞춰 본다.
- geul.org 규격 문서는 Latitude·Longitude 날값 필드에 [CODEC](/ko/grammar/edge/codec/) BINARY-FLOAT(`0803`)를 둔다(4 WORD = binary64).

## 길이

- 전체는 고정 11 WORD(TAG 1 + Payload 10), `LLLL=1010`, TAG `0D04`다. 짝·홀 Codec 쌍과 Length 확장은 두지 않는다.

## 위키데이터 대응

위키데이터 globecoordinate: `{"latitude":52.516666666667,"longitude":13.383333333333,"altitude":null,"precision":0.016666666666667,"globe":"http://www.wikidata.org/entity/Q2"}`

| 위키데이터 | COORDINATE-EARTH |
|---|---|
| globe `…/entity/Q2` | 이 형식(지구). 다른 천체는 COORDINATE-GEO |
| latitude, longitude | binary64 그대로 (위키데이터 값은 원래 binary64라 손실이 없다) |
| precision (도, 기록 해상도) | U = 정밀도에서 오는 불확도(아래 "정밀도 → U"), mm 올림 |
| precision null 또는 없음 | U = `0xFFFFFFFF` (미상) |
| altitude | 버린다 (항상 null) |

### 정밀도 → U

[Georeferencing Best Practices](https://docs.gbif.org/georeferencing-best-practices/1.0/en/)(Chapman & Wieczorek 2020, GBIF) 3.4.3 "Uncertainty Related to Coordinate Precision"의 방법을 따른다(Darwin Core `coordinateUncertaintyInMeters`의 지침).

- 위도 방향 오차 `e_φ = p × M(φ) × π/180`, 경도 방향 오차 `e_λ = p × N(φ) cos φ × π/180`. p는 precision(도), M·N은 WGS 84 타원체(`a = 6378137 m`, `f = 1/298.257223563`)의 자오선·묘유선 곡률 반경이다: `M = a(1−e²)/(1−e² sin²φ)^{3/2}`, `N = a/(1−e² sin²φ)^{1/2}`, `e² = f(2−f)`.
- U = `⌈√(e_φ² + e_λ²)⌉`(mm 단위로 올림).
- 이 U는 기록 정밀도에서 오는 불확도일 뿐이며, 측정·좌표계 등 다른 원인을 더한 전체 불확도의 **하한**이다. 지침도 정밀도를 불확도 대신 쓰지 말라고 한다. 위키데이터가 정밀도만 주므로 이 하한을 U로 쓴다.
- precision이 0 이하이거나 유한하지 않거나 180°를 넘으면 변환하지 않고 원문을 UTF8-TEXT로 보존한다.
- 위키데이터 표본(좌표 클레임 약 2.4만 건): precision은 10의 거듭제곱 도 65.2%, 초 단위 26.3%, 분 단위 1.2%, 그 밖의 값 6.5%(음수·1e-15 같은 이상값 포함), 없음 0.8%. 천체는 지구가 99.7%다.
- 음수 precision 같은 이상값과 천체가 비어 있는 값은 변환하지 않고 원문을 UTF8-TEXT로 보존한다.

## 예시

베를린 52.516666666667, 13.383333333333, precision 1/60° → U 2,172,487mm(위도 오차 약 1,855m, 경도 오차 약 1,131m):

```
0D04 404A 4222 2222 2251 402A C444 4444 4389 0021 2647
```

- TAG `0D04`, Latitude `404A 4222 2222 2251`, Longitude `402A C444 4444 4389`, U `0021 2647`.

## 표준 근거

- 의미: [RFC 5870, A Uniform Resource Identifier for Geographic Locations ('geo' URI)](https://www.rfc-editor.org/rfc/rfc5870) — 위도·경도 순서, `u` 불확도(미터), 기본 좌표계 WGS 84.
- 수치: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64.
- 축 순서와 범위: ISO 6709(Standard representation of geographic point location by coordinates).
- 정밀도 → 불확도: [Chapman & Wieczorek (2020), Georeferencing Best Practices](https://docs.gbif.org/georeferencing-best-practices/1.0/en/) 3.4.3, [Darwin Core coordinateUncertaintyInMeters](https://dwc.tdwg.org/terms/#dwc:coordinateUncertaintyInMeters).
- 고정 폭 배치, U의 mm 단위와 특별값은 GEUL 규칙이다.

## 열린 문제

1. 고도.
2. ISO 6709 문자열 원문을 보존하는 형식(COORDINATE-ISO6709)은 사용처가 생기면 정한다.

## 관련 페이지

- [Value](/ko/grammar/value/), [COORDINATE-GEO](/ko/grammar/value/numeric/coordinate-geo/), [BINARY-FLOAT](/ko/grammar/value/numeric/binary-float/)
- Issuer 형식 [POINT2-BINARY64](/ko/grammar/value/vector/point2-binary64/)는 좌표계·단위·축 의미를 외부 문맥에 맡기는 일반 2차원 점이고, 이 형식은 지구 위의 지리 좌표다.
