---
title: "COORDINATE-GEO"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-30T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-GEO는 천체 Reference와 위도·경도 binary64, 불확도 binary32와 그 단위 Reference로 행성·위성 등 천체 위의 한 점을 담는 Value다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COORDINATE-GEO는 지정한 천체(행성, 위성, 소행성 등) 위의 한 점을 위도·경도와 불확도로 나타내는 좌표 Value다. Value 직접 코드 `0x05`, 계열 NUMERIC이다. [COORDINATE-EARTH](/ko/grammar/value/numeric/coordinate-earth/)(`0x04`) 앞에 천체(Globe) Reference를 더한 형식이며, 위도·경도·불확도·단위 규칙은 COORDINATE-EARTH와 같다.

## 레이아웃

```
TAG WORD          0000 1LLL L000 0101      Codec 0x05
[Length 확장 TAG] 전체 15 WORD 이상일 때
Globe             Reference 레코드 1개 (천체를 가리키는 Reference, Quantifier Identified)
Latitude          4 WORD 날값, IEEE 754 binary64 (도)
Longitude         4 WORD 날값, IEEE 754 binary64 (도)
Uncertainty       2 WORD 날값, IEEE 754 binary32 (Unit 단위)
Unit              Reference 레코드 1개, 또는 자리 표지 0x0000 ABSENT
```

## 해석과 유효성

- Payload는 Globe 레코드로 시작한다. Globe는 완전한 Reference 레코드 정확히 하나이고 Quantifier는 Identified(`000`)다. 천체를 가리키는 어떤 Reference든 쓸 수 있다: [WIKIDATA-QID](/ko/grammar/reference/wikidata-qid/)(이름 있는 천체), [GEUL](/ko/grammar/reference/geul/), 같은 문서의 [LOCAL](/ko/grammar/reference/local/)(문서 안에서 정의한 천체), 다른 문서의 천체([EXTERNAL-POINTER](/ko/grammar/reference/external-pointer/)·[EXTERNAL-ISSUER](/ko/grammar/reference/external-issuer/)) 등. 천체는 무수히 많고 QID가 있는 천체는 그 일부다.
- Globe 뒤에 10 WORD(Latitude 4, Longitude 4, Uncertainty 2)와 Unit 레코드 하나가 온다. Unit을 읽은 커서는 레코드 끝과 맞아야 한다.
- Latitude는 `-90 ≤ φ ≤ 90`, Longitude는 `-360 ≤ λ ≤ 360`이다. 경도를 0~360°로 세는 천체 좌표계(동경·서경)의 값과 그 반대 방향으로 적은 음수 값을 바꾸지 않고 담으려고 지구보다 넓게 허용한다. 범위는 위키데이터 globecoordinate 데이터 모델(Wikibase `LatLongValue`)과 같다. `λ`와 `λ ± 360`은 같은 자오선이며 GEUL은 정규화하지 않는다. 그 밖의 규칙(binary64, 유한값, 축 순서, Uncertainty·Unit의 뜻, 미상 표현)은 COORDINATE-EARTH와 같다.
- 좌표계는 천체마다 그 천체의 관례를 따른다(행성중심 위도, 동경 또는 서경 0~360° 등). 천체별 좌표계는 별도의 GEUL 문서로 정한다.
- 거리 단위(미터 등)의 Uncertainty는 천체 표면 위의 거리다. 각도 단위(도·각분·각초)는 천체 크기와 상관없이 위도·경도의 각도 반경이다.
- 지구(Q2) 좌표는 COORDINATE-EARTH를 쓰기를 권한다. 이 형식에 지구를 적어도 invalid는 아니며, 비교하는 쪽이 같은 좌표로 맞춰 본다.
- geul.org 규격 문서 `0x0000/0x0000000000000805`는 Latitude·Longitude·Uncertainty 날값 필드에 [CODEC](/ko/grammar/edge/codec/) BINARY-FLOAT(`0803`)를, Unit 레코드 필드에 CODEC `0780`(아무 Reference)·`0000`(ABSENT)을 둔다.

## 길이

- 전체는 TAG 1 WORD + (Length 확장 TAG) + Globe 레코드 + 10 WORD + Unit 레코드다.
- Globe가 2 WORD(QID가 1 WORD에 들어갈 때)이고 Unit이 ABSENT면 14 WORD, `LLLL=1101`, TAG `0E85`다. Unit이 Reference(2 WORD 이상)이면 15 WORD를 넘어 확장 길이를 쓴다: TAG `0F05`, 다음 WORD에 전체 WORD 수([레코드와 TAG WORD](/ko/grammar/record/)).

## 위키데이터 대응

- globe가 지구(Q2)가 아닌 globecoordinate는 이 형식으로 쓴다. Globe = WIKIDATA-QID(globe 항목). 위도·경도, precision → Uncertainty·Unit 대응은 COORDINATE-EARTH와 같다(precision은 도 단위 기록 해상도라 천체 크기와 상관없이 그대로 옮긴다).
- 위키데이터 표본(좌표 클레임 약 2.4만 건)의 지구 밖 천체: 화성(Q111), 세레스(Q596), 달(Q405), 수성(Q308), 금성(Q313) 등 23건. globe가 비어 있는 41건은 변환하지 않고 원문을 UTF8-TEXT로 보존한다.

## 예시

화성(Q111) 4.5, 137.4, 불확도 미상:

```
0E85 00A0 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 0000 0000 0000
```

- TAG `0E85`(Codec `0x05`, `LLLL=1101`, 14 WORD), Globe `00A0 006F`(WIKIDATA-QID Q111), Latitude `4012 0000 0000 0000`, Longitude `4061 2CCC CCCC CCCD`, Uncertainty `0000 0000`(+0), Unit `0000`(ABSENT, 미상).
- 텍스트 표기: `COORDINATE-GEO(Q111, 4.5, 137.4, 0, ABSENT)`.

같은 점, precision 0.1°(Unit 도 Q28390):

```
0F05 0010 00A0 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 3DCC CCCD 00A0 6EE6
```

- TAG `0F05`(`LLLL=1110`, 확장 길이), 전체 `0010`(16 WORD), Uncertainty `3DCC CCCD`(binary32 0.1), Unit `00A0 6EE6`(Q28390).

## 표준 근거

- 의미: [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870)의 위도·경도·`u`(Unit이 미터일 때). RFC 5870의 `crs`에 등록된 좌표계는 `wgs84`뿐이라 지구 밖 천체는 GEUL Globe Reference로 지정한다.
- 수치: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64(위도·경도), binary32(불확도).
- 경도 범위: 위키데이터 globecoordinate 데이터 모델 [DataValues Geo `LatLongValue`](https://github.com/DataValues/Geo)의 `-360 ≤ λ ≤ 360`.

## 열린 문제

1. 천체별 좌표계 문서: 천체마다 위도 정의(행성중심·행성면)와 경도 방향·범위.

## 관련 페이지

- [Value](/ko/grammar/value/), [COORDINATE-EARTH](/ko/grammar/value/numeric/coordinate-earth/), [WIKIDATA-QID](/ko/grammar/reference/wikidata-qid/), [GEUL](/ko/grammar/reference/geul/), [LOCAL](/ko/grammar/reference/local/)
