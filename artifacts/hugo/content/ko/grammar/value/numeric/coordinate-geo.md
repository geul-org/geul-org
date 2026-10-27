---
title: "COORDINATE-GEO"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-GEO는 천체 Reference와 위도·경도 binary64, 불확도(mm)로 행성·위성 등 천체 위의 한 점을 담는 Value다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COORDINATE-GEO는 지정한 천체(행성, 위성, 소행성 등) 위의 한 점을 위도·경도와 불확도로 나타내는 좌표 Value다. Value 직접 코드 `0x05`, 계열 NUMERIC이다. [COORDINATE-EARTH](/ko/grammar/value/numeric/coordinate-earth/)(`0x04`) 앞에 천체(Globe) Reference를 더한 형식이며, 위도·경도·불확도 규칙은 COORDINATE-EARTH와 같다.

## 레이아웃

```
TAG WORD          0000 1LLL L000 0101      Codec 0x05
[Length 확장 TAG] 전체 15 WORD 이상일 때
Globe             Reference 레코드 1개 (천체를 가리키는 Reference, Quantifier Identified)
Latitude          4 WORD 날값, IEEE 754 binary64 (도)
Longitude         4 WORD 날값, IEEE 754 binary64 (도)
U                 2 WORD 날값, uint32 (밀리미터)
```

## 해석과 유효성

- Payload는 Globe 레코드로 시작한다. Globe는 완전한 Reference 레코드 정확히 하나이고 Quantifier는 Identified(`000`)다. 천체를 가리키는 어떤 Reference든 쓸 수 있다: [WIKIDATA-QID](/ko/grammar/reference/wikidata-qid/)(이름 있는 천체), [GEUL](/ko/grammar/reference/geul/), 같은 문서의 [LOCAL](/ko/grammar/reference/local/)(문서 안에서 정의한 천체), 다른 문서의 천체([EXTERNAL-POINTER](/ko/grammar/reference/external-pointer/)·[EXTERNAL-ISSUER](/ko/grammar/reference/external-issuer/)) 등. 천체는 무수히 많고 QID가 있는 천체는 그 일부다.
- Globe를 읽은 뒤 정확히 10 WORD(Latitude 4, Longitude 4, U 2)가 남아야 한다.
- Latitude는 `-90 ≤ φ ≤ 90`, Longitude는 `-180 ≤ λ ≤ 360`이다. `(180, 360]`은 경도를 0~360°로 세는 천체 좌표계의 값을 그대로 담으려고 허용한다. 그 밖의 규칙(binary64, 유한값, 축 순서, U의 뜻과 특별값)은 COORDINATE-EARTH와 같다.
- 좌표계는 천체마다 그 천체의 관례를 따른다(행성중심 위도, 동경 또는 서경 0~360° 등). 천체별 좌표계는 별도의 GEUL 문서로 정한다.
- 지구(Q2) 좌표는 COORDINATE-EARTH를 쓰기를 권한다. 이 형식에 지구를 적어도 invalid는 아니며, 비교하는 쪽이 같은 좌표로 맞춰 본다.
- geul.org 규격 문서는 Latitude·Longitude 날값 필드에 [CODEC](/ko/grammar/edge/codec/) BINARY-FLOAT(`0803`)를 둔다(4 WORD = binary64).

## 길이

- 전체는 TAG 1 WORD + (Length 확장 TAG) + Globe 레코드 + 10 WORD다.
- Globe가 2 WORD(QID가 1 WORD에 들어갈 때)이면 13 WORD, `LLLL=1100`, TAG `0E05`다. Globe가 4 WORD 이상이면 15 WORD를 넘어 확장 길이를 쓴다([레코드와 TAG WORD](/ko/grammar/record/)).

## 위키데이터 대응

- globe가 지구(Q2)가 아닌 globecoordinate는 이 형식으로 쓴다. Globe = WIKIDATA-QID(globe 항목). 위도·경도 대응은 COORDINATE-EARTH와 같다.
- precision → U는 COORDINATE-EARTH의 방법(WGS 84 타원체)을 그대로 쓰지 않는다. 천체 크기가 다르기 때문이다. 그 천체의 반지름을 알기 전까지 U는 미상(`0xFFFFFFFF`)으로 둔다.
- 위키데이터 표본(좌표 클레임 약 2.4만 건)의 지구 밖 천체: 화성(Q111), 세레스(Q596), 달(Q405), 수성(Q308), 금성(Q313) 등 23건. globe가 비어 있는 41건은 변환하지 않고 원문을 UTF8-TEXT로 보존한다.

## 예시

화성(Q111) 4.5, 137.4, 불확도 미상:

```
0E05 00A0 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD FFFF FFFF
```

- TAG `0E05`(Codec `0x05`, `LLLL=1100`, 13 WORD), Globe `00A0 006F`(WIKIDATA-QID Q111), Latitude `4012 0000 0000 0000`, Longitude `4061 2CCC CCCC CCCD`, U `FFFF FFFF`(미상).

## 표준 근거

- 의미: [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870)의 위도·경도·`u`. RFC 5870의 `crs`에 등록된 좌표계는 `wgs84`뿐이라 지구 밖 천체는 GEUL Globe Reference로 지정한다.
- 수치: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64.

## 열린 문제

1. 천체별 좌표계 문서: 천체마다 위도 정의(행성중심·행성면)와 경도 방향·범위.

## 관련 페이지

- [Value](/ko/grammar/value/), [COORDINATE-EARTH](/ko/grammar/value/numeric/coordinate-earth/), [WIKIDATA-QID](/ko/grammar/reference/wikidata-qid/), [GEUL](/ko/grammar/reference/geul/), [LOCAL](/ko/grammar/reference/local/)
