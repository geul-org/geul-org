---
title: "COORDINATE-GEO (0x065L)"
weight: 101
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-GEO는 지정한 천체(행성, 위성, 소행성 등) 위의 한 점을 위도·경도와 불확도로 나타내는 좌표 Value다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `COORDINATE-GEO` (규격 문서 BIND `COORDINATE-GEO`) |
| TAG ID | `0x065L` |
| 코덱 ID | `0x00000650` |
| 규격 문서 | `0x00000000/codecs/0x00000650/` (DECLARE 대상 `0650`) |
| 섹션 | 3 `0011` (Value), 섹션 안 오프셋 C = 5 |
| Kind | Value · 계열: NUMERIC |
| TAG WORD | `0000 0110 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 천체 Reference와 위도·경도 binary64, 불확도 binary32와 그 단위 Reference |
| Hugo 쪽 | `value/numeric/coordinate-geo.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `globe` | #2 | 레코드 | `0050` LOCAL, `00A0` GEUL, `00F0` GEUL-SIDX, `0140` WIKIDATA-QID, `0200` EXTERNAL-POINTER-1WORD, `0250` EXTERNAL-POINTER-2WORD, `02A0` EXTERNAL-POINTER-4WORD, `02F0` EXTERNAL-ISSUER-2WORD, `0340` EXTERNAL-ISSUER-4WORD, `0390` EXTERNAL-ISSUER-16WORD |  |
| 2 | `latitude` | #3 | 날값 4 WORD | `0630` BINARY-FLOAT |  |
| 3 | `longitude` | #4 | 날값 4 WORD | `0630` BINARY-FLOAT |  |
| 4 | `uncertainty` | #5 | 날값 2 WORD | `0630` BINARY-FLOAT |  |
| 5 | `unit` | #26 | 레코드 | `000F` 섹션 0 전체(와일드카드, Reference), `020F` 섹션 1 전체(와일드카드, Reference), `040F` 섹션 2 전체(와일드카드, Reference), `0000` ABSENT(선택 필드) |  |

COORDINATE-GEO는 지정한 천체(행성, 위성, 소행성 등) 위의 한 점을 위도·경도와 불확도로 나타내는 좌표 Value다. Value 직접 코드 `0x065L`, 계열 NUMERIC이다. [COORDINATE-EARTH](0x064L-coordinate-earth.md)(`0x064L`) 앞에 천체(Globe) Reference를 더한 형식이며, 위도·경도·불확도·단위 규칙은 COORDINATE-EARTH와 같다.

## 레이아웃

```
TAG WORD          0000 0110 0101 LLLL      Codec 0x065L
[Length 확장 TAG] 전체 15 WORD 이상일 때
Globe             Reference 레코드 1개 (천체를 가리키는 Reference, Quantifier Identified)
Latitude          4 WORD 날값, IEEE 754 binary64 (도)
Longitude         4 WORD 날값, IEEE 754 binary64 (도)
Uncertainty       2 WORD 날값, IEEE 754 binary32 (Unit 단위)
Unit              Reference 레코드 1개, 또는 자리 표지 0x0000 ABSENT
```

## 해석과 유효성

- Payload는 Globe 레코드로 시작한다. Globe는 완전한 Reference 레코드 정확히 하나이고 Quantifier는 Identified다. 천체를 가리키는 어떤 Reference든 쓸 수 있다: [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)(이름 있는 천체), [GEUL](../reference/0x00AL-geul.md), 같은 문서의 [LOCAL](../reference/0x005L-local.md)(문서 안에서 정의한 천체), 다른 문서의 천체([EXTERNAL-POINTER](../reference/0x020L-external-pointer-1word.md)·[EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md)) 등. 천체는 무수히 많고 QID가 있는 천체는 그 일부다.
- Globe 뒤에 10 WORD(Latitude 4, Longitude 4, Uncertainty 2)와 Unit 레코드 하나가 온다. Unit을 읽은 커서는 레코드 끝과 맞아야 한다.
- Latitude는 `-90 ≤ φ ≤ 90`, Longitude는 `-360 ≤ λ ≤ 360`이다. 경도를 0~360°로 세는 천체 좌표계(동경·서경)의 값과 그 반대 방향으로 적은 음수 값을 바꾸지 않고 담으려고 지구보다 넓게 허용한다. 범위는 위키데이터 globecoordinate 데이터 모델(Wikibase `LatLongValue`)과 같다. `λ`와 `λ ± 360`은 같은 자오선이며 GEUL은 정규화하지 않는다. 그 밖의 규칙(binary64, 유한값, 축 순서, Uncertainty·Unit의 뜻, 미상 표현)은 COORDINATE-EARTH와 같다.
- 좌표계는 천체마다 그 천체의 관례를 따른다(행성중심 위도, 동경 또는 서경 0~360° 등). 천체별 좌표계는 별도의 GEUL 문서로 정한다.
- 거리 단위(미터 등)의 Uncertainty는 천체 표면 위의 거리다. 각도 단위(도·각분·각초)는 천체 크기와 상관없이 위도·경도의 각도 반경이다.
- 지구(Q2) 좌표는 COORDINATE-EARTH를 쓰기를 권한다. 이 형식에 지구를 적어도 invalid는 아니며, 비교하는 쪽이 같은 좌표로 맞춰 본다.
- geul.org 규격 문서 `0x00000000/codecs/0x00000650`은 Latitude·Longitude·Uncertainty 날값 필드에 [CODEC](../edge/0x0BEL-codec.md) BINARY-FLOAT(`0630`)를, Unit 레코드 필드에 CODEC `000F`·`020F`·`040F`(아무 Reference)·`0000`(ABSENT)을 둔다.

## 길이

- 전체는 TAG 1 WORD + (Length 확장 TAG) + Globe 레코드 + 10 WORD + Unit 레코드다.
- Globe가 2 WORD(QID가 1 WORD에 들어갈 때)이고 Unit이 ABSENT면 14 WORD, `LLLL=1101`, TAG `065D`다. Unit이 Reference(2 WORD 이상)이면 15 WORD를 넘어 확장 길이를 쓴다: TAG `065E`, 다음 WORD에 전체 WORD 수([레코드와 TAG WORD](../record.md)).

## 위키데이터 대응

- globe가 지구(Q2)가 아닌 globecoordinate는 이 형식으로 쓴다. Globe = WIKIDATA-QID(globe 항목). 위도·경도, precision → Uncertainty·Unit 대응은 COORDINATE-EARTH와 같다(precision은 도 단위 기록 해상도라 천체 크기와 상관없이 그대로 옮긴다).
- 위키데이터 표본(좌표 클레임 약 2.4만 건)의 지구 밖 천체: 화성(Q111), 세레스(Q596), 달(Q405), 수성(Q308), 금성(Q313) 등 23건. globe가 비어 있는 41건은 변환하지 않고 원문을 UTF8-TEXT로 보존한다.

## 예시

화성(Q111) 4.5, 137.4, 불확도 미상:

```
065D 0141 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 0000 0000 0000
```

- TAG `065D`(Codec `0x065L`, `LLLL=1101`, 14 WORD), Globe `0141 006F`(WIKIDATA-QID Q111), Latitude `4012 0000 0000 0000`, Longitude `4061 2CCC CCCC CCCD`, Uncertainty `0000 0000`(+0), Unit `0000`(ABSENT, 미상).
- 텍스트 표기: `COORDINATE-GEO(Q111, 4.5, 137.4, 0, ABSENT)`.

같은 점, precision 0.1°(Unit 도 Q28390):

```
065E 0010 0141 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 3DCC CCCD 0141 6EE6
```

- TAG `065E`(`LLLL=1110`, 확장 길이), 전체 `0010`(16 WORD), Uncertainty `3DCC CCCD`(binary32 0.1), Unit `0141 6EE6`(Q28390).

## 표준 근거

- 의미: [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870)의 위도·경도·`u`(Unit이 미터일 때). RFC 5870의 `crs`에 등록된 좌표계는 `wgs84`뿐이라 지구 밖 천체는 GEUL Globe Reference로 지정한다.
- 수치: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64(위도·경도), binary32(불확도).
- 경도 범위: 위키데이터 globecoordinate 데이터 모델 [DataValues Geo `LatLongValue`](https://github.com/DataValues/Geo)의 `-360 ≤ λ ≤ 360`.

## 열린 문제

1. 천체별 좌표계 문서: 천체마다 위도 정의(행성중심·행성면)와 경도 방향·범위.

## 관련 페이지

- [Value](_index.md), [COORDINATE-EARTH](0x064L-coordinate-earth.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md), [GEUL](../reference/0x00AL-geul.md), [LOCAL](../reference/0x005L-local.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000650/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000065000000000
BODY
#1 DECLARE 0x0650
#2 FIELD #1 record
#3 FIELD #1 0x0004
#4 FIELD #1 0x0004
#5 FIELD #1 0x0002
#6 BIND #1 "COORDINATE-GEO"
#7 BIND #2 "globe"
#8 BIND #3 "latitude"
#9 BIND #4 "longitude"
#10 BIND #5 "uncertainty"
#11 CODEC #3 0x0630
#12 CODEC #4 0x0630
#13 CODEC #2 0x0050
#14 CODEC #2 0x00A0
#15 CODEC #2 0x00F0
#16 CODEC #2 0x0140
#17 CODEC #2 0x0200
#18 CODEC #2 0x0250
#19 CODEC #2 0x02A0
#22 CODEC #2 0x02F0
#23 CODEC #2 0x0340
#24 CODEC #2 0x0390
#25 CODEC #5 0x0630
#26 FIELD #1 record
#27 BIND #26 "unit"
#28 CODEC #26 0x000F
#30 CODEC #26 0x020F
#31 CODEC #26 0x040F
#29 CODEC #26 0x0000
```
