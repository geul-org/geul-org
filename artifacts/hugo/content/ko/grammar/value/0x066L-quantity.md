---
title: "QUANTITY (0x066L)"
weight: 102
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY는 수량 하나를 수, 단위, 하한·상한으로 나타내는 Value다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `QUANTITY` (규격 문서 BIND `QUANTITY`) |
| TAG ID | `0x066L` |
| 코덱 ID | `0x00000660` |
| 규격 문서 | `0x00000000/codecs/0x00000660/` (DECLARE 대상 `0660`) |
| 섹션 | 3 `0011` (Value), 섹션 안 오프셋 C = 6 |
| Kind | Value · 계열: NUMERIC |
| TAG WORD | `0000 0110 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 수치 Value amount(정수·BINARY-FLOAT·10진수·분수), 단위 Reference, 하한·상한. 단위·경계는 생략 가능(ABSENT `0x0000`) |
| Hugo 쪽 | `value/numeric/quantity.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `amount` | #2 | 레코드 | `0680` SIGNED-DECIMAL, `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |
| 2 | `unit` | #3 | 레코드 | `000F` 섹션 0 전체(와일드카드, Reference), `020F` 섹션 1 전체(와일드카드, Reference), `040F` 섹션 2 전체(와일드카드, Reference), `0000` ABSENT(선택 필드) |  |
| 3 | `lower` | #4 | 레코드 | `0680` SIGNED-DECIMAL, `0000` ABSENT(선택 필드), `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |
| 4 | `upper` | #5 | 레코드 | `0680` SIGNED-DECIMAL, `0000` ABSENT(선택 필드), `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT, `0670` FRACTION, `0690` UNSIGNED-DECIMAL |  |

QUANTITY는 수량 하나를 수, 단위, 하한·상한으로 나타내는 Value다. Value 직접 코드 `0x066L`, 계열 NUMERIC이다. 네 부분은 각각 완전한 레코드다. 단위와 경계는 [선택 필드](../codec-spec.md)라 생략하면 ABSENT(`0x0000`)를 쓴다.

## 레이아웃

```
TAG WORD          0000 0110 0110 LLLL      Codec 0x066L
[Length 확장 TAG] 전체 15 WORD 이상일 때
amount            수치 Value 레코드 (정수·BINARY-FLOAT·10진수·분수)
unit              Reference 레코드 (단위 항목), 무단위면 0x0000
lower             수치 Value 레코드, 생략하면 0x0000 ABSENT
upper             수치 Value 레코드, 생략하면 0x0000 ABSENT
```

## 해석과 유효성

- amount는 완전한 수치 Value 레코드 하나다. 받는 Codec은 [SIGNED-INTEGER](0x061L-signed-integer.md)(`0x061L`), [UNSIGNED-INTEGER](0x062L-unsigned-integer.md)(`0x062L`), [BINARY-FLOAT](0x063L-binary-float.md)(`0x063L`), [FRACTION](0x067L-fraction.md)(`0x067L`), [SIGNED-DECIMAL](0x068L-signed-decimal.md)(`0x068L`), [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md)(`0x069L`)의 여섯이다. 닫힌 목록이며 와일드카드가 아니다. BOOL, COORDINATE-EARTH·COORDINATE-GEO, QUANTITY 자신(중첩 금지, 깊이 고정), 그 밖의 Value는 받지 않는다. amount에는 자리 표지(`0x0000` 등)를 쓸 수 없다.
- 안쪽 레코드도 각 Codec의 정규형을 따른다(정수·coefficient는 최소 WORD, BINARY-FLOAT은 1/2/4/8 WORD, FRACTION은 그 규칙). 비정규 안쪽 레코드가 있으면 QUANTITY 전체가 invalid다.
- amount·lower·upper가 BINARY-FLOAT이면 유한한 값이어야 한다. NaN과 ±Infinity는 invalid다([COORDINATE-EARTH](0x064L-coordinate-earth.md)의 위도·경도와 같은 규칙).
- 수 형식은 원래 표기를 그대로 따른다. 정수 원문은 INTEGER, 소수 원문은 DECIMAL, 분수 원문은 FRACTION, IEEE 754 binary 값은 BINARY-FLOAT로 담고, 인코더가 형식을 바꾸어 정규화하지 않는다. DECIMAL의 C와 E는 원래 표기의 자릿수를 그대로 담는다: `1.20` = `120×10^-2`, `1.2` = `12×10^-1`. 두 값은 같은 수지만 유효숫자가 다르므로 다른 Value다. 정수와 coefficient 자릿수에 상한은 없다(최소 WORD, 가변 길이).
- unit은 완전한 Reference 레코드 정확히 하나이거나 `0x0000`이다. 단위 항목을 가리키는 어떤 Reference든 쓸 수 있다(위키데이터 단위는 WIKIDATA-QID). `0x0000`은 무단위(개수, 비율, 인구 등)다.
- lower·upper는 각각 amount와 같은 여섯 Codec 중 하나의 레코드이거나 `0x0000` ABSENT다. 자리 표지는 ABSENT 생략만 받는다. 둘 중 하나만 있어도 된다. 세 수의 Codec이 같을 필요는 없다.
- lower ≤ amount ≤ upper는 바이트나 Codec이 아니라 수치 값으로 비교한다. 타입이 달라도 수로 비교한다(예: SIGNED-INTEGER `652`와 SIGNED-DECIMAL `651.5`). FRACTION은 정확한 유리수로 비교한다. 대칭 범위(`652 ± 1`)도 하한·상한 둘로 쓴다(`651`, `653`). 비대칭 범위가 있어 어차피 두 값이 필요하므로 ± 하나로 줄이는 형식은 두지 않는다.
- 단위는 값의 일부다. 단위를 QUALIFIER 등으로 떼어 내지 않는다(떼면 `652`가 km인지 m인지 알 수 없다).
- amount 레코드를 꺼내면 그대로 독립된 Value 레코드다. 단위를 뗀 수가 필요하면 다시 인코딩하지 않고 그 레코드를 쓴다.
- SI 단위로 환산한 값은 담지 않는다. 단위와 환산표에서 계산할 수 있는 파생값이다.
- 네 레코드를 읽은 커서는 Payload 끝과 정확히 맞아야 한다. 그 밖의 형태는 invalid다.
- geul.org 규격 문서는 amount(`0610`·`0620`·`0630`·`0670`·`0680`·`0690`), unit(`000F`·`020F`·`040F`·`0000`), lower·upper(`0610`·`0620`·`0630`·`0670`·`0680`·`0690`·`0000`)의 레코드 필드 넷으로 적는다([Codec 규격 문서](../codec-spec.md)).

## 길이

- 전체는 TAG 1 WORD + (Length 확장 TAG) + 네 레코드다. 정수 레코드는 TAG 1 + Payload 1 WORD 이상, BINARY-FLOAT 레코드는 2·3·5·9 WORD, 10진수 레코드는 TAG 1 + 지수 2 + coefficient 1 WORD 이상, FRACTION 레코드는 5 WORD 이상이다.
- 무단위·경계 없는 작은 정수는 6 WORD, 작은 10진수는 8 WORD다. 15 WORD 이상이면 확장 길이를 쓴다([레코드와 TAG WORD](../record.md)).

## 예시

무단위 `1.20`:

```
0667 0683 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0667`(Codec `0x066L`, 8 WORD), amount `0683 FFFF FFFE 0078`(E = -2, C = 120), unit·lower·upper `0000`.

무단위 정수 `42`:

```
0665 0611 002A 0000 0000 0000
```

- TAG `0665`(6 WORD), amount `0611 002A`(SIGNED-INTEGER 42), unit·lower·upper `0000`.

무단위 분수 `2/3`(출석 의결권의 3분의 2):

```
0668 0674 0611 0002 0621 0003 0000 0000 0000
```

- TAG `0668`(9 WORD), amount `0674 0611 0002 0621 0003`([FRACTION](0x067L-fraction.md) 2/3), unit·lower·upper `0000`.

`652 km`, 범위 `[651, 653]`(km = Q828224):

```
066E 0011
0683 0000 0000 028C
0142 000C A340
0683 0000 0000 028B
0683 0000 0000 028D
```

- 전체 17 WORD라 `LLLL=1110`, 확장 TAG `0011`.

## 위키데이터 대응

- `quantity` datavalue `{"amount","unit","lowerBound","upperBound"}` → amount·unit·lower·upper. amount와 경계 문자열(`+1.20`, 지수 표기 포함)은 자릿수 그대로 C와 E로 옮긴다.
- 위키데이터의 amount·경계는 10진 문자열이므로 정수 모양(`+652`)이어도 SIGNED-DECIMAL로 옮긴다. 위키데이터 변환은 다른 수치 Codec을 쓰지 않는다.
- unit `"1"`은 무단위(`0x0000`), `http://www.wikidata.org/entity/Qn`은 WIKIDATA-QID다. 그 밖의 단위, 형식이 맞지 않는 수·경계는 변환하지 않고 원문을 UTF8-TEXT로 보존한다.
- 위키데이터 표본(덤프 앞부분 quantity 약 4.2만 건): 무단위 61%, 경계 있음 13%(그중 대칭 93%), 가장 긴 amount 31자.

## 표준 근거

- 10진 표기와 자릿수 보존: [IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) decimal의 coefficient·exponent·quantum 개념(GEUL SIGNED-DECIMAL).
- 위키데이터 수량 모델: Wikibase DataModel `QuantityValue`.

## 관련 페이지

- [Value](_index.md), [SIGNED-DECIMAL](0x068L-signed-decimal.md), [COORDINATE-GEO](0x065L-coordinate-geo.md), [CODEC](../edge/0x0BEL-codec.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000660/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000066000000000
BODY
#1 DECLARE 0x0660
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 FIELD #1 record
#6 BIND #1 "QUANTITY"
#7 BIND #2 "amount"
#8 BIND #3 "unit"
#9 BIND #4 "lower"
#10 BIND #5 "upper"
#11 CODEC #2 0x0680
#12 CODEC #3 0x000F
#33 CODEC #3 0x020F
#34 CODEC #3 0x040F
#13 CODEC #3 0x0000
#14 CODEC #4 0x0680
#15 CODEC #4 0x0000
#16 CODEC #5 0x0680
#17 CODEC #5 0x0000
#18 CODEC #2 0x0610
#19 CODEC #2 0x0620
#20 CODEC #2 0x0630
#21 CODEC #2 0x0670
#22 CODEC #2 0x0690
#23 CODEC #4 0x0610
#24 CODEC #4 0x0620
#25 CODEC #4 0x0630
#26 CODEC #4 0x0670
#27 CODEC #4 0x0690
#28 CODEC #5 0x0610
#29 CODEC #5 0x0620
#30 CODEC #5 0x0630
#31 CODEC #5 0x0670
#32 CODEC #5 0x0690
```
