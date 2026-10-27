---
title: "QUANTITY"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY는 수량 하나를 정확한 10진수 양, 단위 Reference, 하한·상한의 네 레코드로 담는 Value다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUANTITY는 수량 하나를 정확한 10진수, 단위, 하한·상한으로 나타내는 Value다. Value 직접 코드 `0x06`, 계열 NUMERIC이다. 네 부분은 각각 완전한 레코드다. 단위와 경계는 [선택 필드](/ko/grammar/codec-spec/)라 없으면 없음 표지 `0x0000`을 쓴다.

## 레이아웃

```
TAG WORD          0000 1LLL L000 0110      Codec 0x06
[Length 확장 TAG] 전체 15 WORD 이상일 때
amount            SIGNED-DECIMAL Value 레코드
unit              Reference 레코드 (단위 항목), 무단위면 0x0000
lower             SIGNED-DECIMAL Value 레코드, 없으면 0x0000
upper             SIGNED-DECIMAL Value 레코드, 없으면 0x0000
```

## 해석과 유효성

- amount는 [SIGNED-DECIMAL](/ko/grammar/value/decimal/signed-decimal/) `C×10^E`다. C와 E는 원래 표기의 자릿수를 그대로 담는다: `1.20` = `120×10^-2`, `1.2` = `12×10^-1`. 두 값은 같은 수지만 유효숫자가 다르므로 다른 Value다. coefficient 자릿수에 상한은 없다(최소 WORD 2의 보수, 가변 길이).
- unit은 완전한 Reference 레코드 정확히 하나이거나 `0x0000`이다. 단위 항목을 가리키는 어떤 Reference든 쓸 수 있다(위키데이터 단위는 WIKIDATA-QID). `0x0000`은 무단위(개수, 비율, 인구 등)다.
- lower·upper는 각각 SIGNED-DECIMAL 레코드이거나 `0x0000`이다. 둘 중 하나만 있어도 된다. 대칭 범위(`652 ± 1`)도 하한·상한 둘로 쓴다(`651`, `653`). 비대칭 범위가 있어 어차피 두 값이 필요하므로 ± 하나로 줄이는 형식은 두지 않는다.
- 단위는 값의 일부다. 단위를 QUALIFIER 등으로 떼어 내지 않는다(떼면 `652`가 km인지 m인지 알 수 없다).
- SI 단위로 환산한 값은 담지 않는다. 단위와 환산표에서 계산할 수 있는 파생값이다.
- 네 레코드를 읽은 커서는 Payload 끝과 정확히 맞아야 한다. 그 밖의 형태는 invalid다.
- geul.org 규격 문서는 amount(`0810`), unit(`0780`·`0000`), lower·upper(`0810`·`0000`)의 레코드 필드 넷으로 적는다([Codec 규격 문서](/ko/grammar/codec-spec/)).

## 길이

- 전체는 TAG 1 WORD + (Length 확장 TAG) + 네 레코드다. 10진수 레코드는 TAG 1 + 지수 2 + coefficient 1 WORD 이상이다.
- 무단위·경계 없는 작은 수는 8 WORD다. 15 WORD 이상이면 확장 길이를 쓴다([레코드와 TAG WORD](/ko/grammar/record/)).

## 예시

무단위 `1.20`:

```
0B86 0990 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0B86`(Codec `0x06`, 8 WORD), amount `0990 FFFF FFFE 0078`(E = -2, C = 120), unit·lower·upper `0000`.

`652 km`, 범위 `[651, 653]`(km = Q828224):

```
0F06 0011
0990 0000 0000 028C
0120 000C A340
0990 0000 0000 028B
0990 0000 0000 028D
```

- 전체 17 WORD라 `LLLL=1110`, 확장 TAG `0011`.

## 위키데이터 대응

- `quantity` datavalue `{"amount","unit","lowerBound","upperBound"}` → amount·unit·lower·upper. amount와 경계 문자열(`+1.20`, 지수 표기 포함)은 자릿수 그대로 C와 E로 옮긴다.
- unit `"1"`은 무단위(`0x0000`), `http://www.wikidata.org/entity/Qn`은 WIKIDATA-QID다. 그 밖의 단위, 형식이 맞지 않는 수·경계는 변환하지 않고 원문을 UTF8-TEXT로 보존한다.
- 위키데이터 표본(덤프 앞부분 quantity 약 4.2만 건): 무단위 61%, 경계 있음 13%(그중 대칭 93%), 가장 긴 amount 31자.

## 표준 근거

- 10진 표기와 자릿수 보존: [IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) decimal의 coefficient·exponent·quantum 개념(GEUL SIGNED-DECIMAL).
- 위키데이터 수량 모델: Wikibase DataModel `QuantityValue`.

## 관련 페이지

- [Value](/ko/grammar/value/), [SIGNED-DECIMAL](/ko/grammar/value/decimal/signed-decimal/), [COORDINATE-GEO](/ko/grammar/value/numeric/coordinate-geo/), [CODEC](/ko/grammar/edge/codec/), [WIKIDATA-QID](/ko/grammar/reference/wikidata-qid/)
