---
title: "QUALIFIER (0x0ABL)"
weight: 171
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "QUALIFIER는 다른 Edge(주로 TRIPLE)가 담은 명제를 한정하는 조건 하나를 붙이는 서술 Edge다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `QUALIFIER` (규격 문서 BIND `QUALIFIER`) |
| TAG ID | `0x0ABL` |
| 코덱 ID | `0x00000AB0` |
| 규격 문서 | `0x00000000/codecs/0x00000AB0/` (DECLARE 대상 `0AB0`) |
| 섹션 | 5 `0101` (Edge 서술), 섹션 안 오프셋 C = 11 |
| Kind | Edge · 계열: 서술, 묶음: 명제 |
| TAG WORD | `0000 1010 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 다른 Edge의 명제를 한정하는 조건 하나. Property, Target(Edge Id), Value(값 또는 UNKNOWN-VALUE·NO-VALUE 표지). 명제의 일부다 |
| Hugo 쪽 | `edge/qualifier.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)). Edge의 Edge Id는 FIELD로 선언하지 않는다.

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `property` | #2 | 레코드 | 아무 레코드(자리 표지 제외) |  |
| 2 | `target` | #3 | 레코드 | `0050` LOCAL |  |
| 3 | `value` | #4 | 레코드 | `000F` 섹션 0 전체(와일드카드, Reference), `020F` 섹션 1 전체(와일드카드, Reference), `040F` 섹션 2 전체(와일드카드, Reference), `060F` 섹션 3 전체(와일드카드, Value), `080F` 섹션 4 전체(와일드카드, Value), `0010` UNKNOWN-VALUE, `0020` NO-VALUE |  |

QUALIFIER는 다른 Edge(주로 [TRIPLE](0x0AAL-triple.md))가 담은 명제를 한정하는 조건 하나를 붙이는 서술 Edge다. Codec `0x0ABL`.

위키데이터 qualifier(snak) 하나와 같다: 속성 하나와 값 하나.

## 레이아웃

```
TAG WORD          0000 1010 1011 LLLL
[Length 확장 TAG]
Edge Id           LOCAL Reference 레코드
Property          Reference 레코드 (WIKIDATA-PID 등)
Target            LOCAL Reference 레코드 (한정하는 Edge의 Edge Id)
Value             Reference 또는 Value 레코드, 또는 자리 표지 0x0010 UNKNOWN-VALUE·0x0020 NO-VALUE
```

- 구성요소 순서는 TRIPLE과 같다(Property ↔ Predicate, Target ↔ Subject, Value ↔ Object). 디코더는 같은 경로로 읽는다. 역할은 Codec이 정한다.

## 해석과 유효성

- Property, Target은 정확히 하나의 완전한 Reference 레코드이고, Target은 LOCAL Reference다. geul.org 규격 문서는 Target에 [CODEC](0x0BEL-codec.md) LOCAL(`0050`)을 둔다. Value는 정확히 하나의 완전한 Reference 또는 Value 레코드, 또는 [자리 표지](../slot-marker.md) `0x0010`(UNKNOWN-VALUE)·`0x0020`(NO-VALUE) 1 WORD다. 규격 문서는 Value에 CODEC `000F`, `020F`, `040F`(아무 Reference), `060F`, `080F`(아무 Value), `0010`, `0020`을 둔다. ABSENT(`0x0000`)는 받지 않는다. Property·Target은 자리 표지를 받지 않는다. Value를 읽은 커서는 Edge 끝과 맞아야 한다.
- Target은 같은 문서 안의 Edge Id다. QUALIFIER는 한정하는 Edge와 같은 문서에 둔다.
- Target이 HEAD의 [SOURCE](0x0C0L-source.md#문서-전체의-출처)(문서 전체의 원천)이면 QUALIFIER도 HEAD에, 그 SOURCE 뒤에 둔다. 그 밖의 QUALIFIER는 BODY에 둔다. HEAD SOURCE를 Target으로 하는 QUALIFIER가 BODY에 있으면 invalid다.
- Target은 TRIPLE 말고 다른 Edge일 수 있다. [SOURCE](0x0C0L-source.md)에 붙은 QUALIFIER는 인용 행위를 한정한다(조회일, 원천 안의 위치 등). SOURCE의 의미도 그것을 가리키는 QUALIFIER를 모두 모은 것이다.
- **QUALIFIER는 명제의 일부다.** 명제에 관한 별도의 주장이 아니라, 명제가 참이 되는 조건을 한정한다. 대상 TRIPLE의 의미는 그것을 가리키는 QUALIFIER를 모두 모은 것이다.
  - 명제의 출처는 [SOURCE](0x0C0L-source.md)로 쓴다. 원천 노드의 속성(제목, 저자 등)은 원천을 Subject로 하는 TRIPLE로 쓴다.
- 같은 Target에 같은 Property의 QUALIFIER가 여럿일 수 있다. 같은 Target의 QUALIFIER 순서는 문서 안 순서다(Edge 순서에 의미를 주는 예외).

## 알 수 없음과 없음

QUALIFIER의 Value가 자리 표지면 그 한정의 뜻이 바뀐다. 종료 시점(P582)을 예로 든다.

| 대상 TRIPLE에 붙은 것 | 뜻 | 지금도 유효한 명제인가 |
|---|---|---|
| `QUALIFIER P582 #n EDTF("1974")` | 1974년에 끝났다 | 아니다 |
| `QUALIFIER P582 #n UNKNOWN` | 끝났다. 언제인지 모른다(위키데이터 `somevalue`) | 아니다 |
| `QUALIFIER P582 #n NONE` | 끝나지 않았다고 단언한다(위키데이터 `novalue`) | 그렇다 |
| P582 QUALIFIER 없음 | 끝났는지 모른다(열린 세계) | 모른다 |

- 위키데이터 qualifier의 `somevalue`·`novalue`를 버리면 명제가 넓어진다. 종료 시점 somevalue를 버린 국경 TRIPLE은 "지금도 유효한 국경"으로 읽힌다. 그래서 옮길 때 표지로 옮긴다.
- UNKNOWN-VALUE끼리는 같은 값으로 보지 않는다. 비교 결과는 미정이다.

## 예시 (비규범)

Q42 P69(educated at) Q691283(St John's College), 1971~1974.

```
TRIPLE     #9   P69   Q42  Q691283  rank 0
QUALIFIER  #10  P580  #9   EDTF "1971"
QUALIFIER  #11  P582  #9   EDTF "1974"
```

- `#10`: TAG 1 + Edge Id 2 + Property 2 + Target 2 + Value 3 = 10 WORD. Value는 [EDTF](../value/0x06EL-edtf.md) `"1971"`이다.

```
0AB9 0051 000A 0191 0244 0051 0009 06E2 3139 3731
```

Q30(미국)–Q34266(러시아 제국) 국경(P47), 종료 시점을 모른다. Edge Id `2060`·`3160`.

```
0AA9 0051 080C 0191 002F 0141 001E 0141 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
0AB7 0051 0C58 0191 0246 0051 080C 0010                #3160 QUALIFIER P582 #2060 UNKNOWN
```

- `0AB7` = `000 0101 01011 0111`(섹션 5): Edge, Codec `0x0ABL`, 8 WORD. TAG 1 + Edge Id 2 + Property P582(`0191 0246`) 2 + Target #2060(`0051 080C`) 2 + 표지 1.

Q30 중앙은행(P1304) NO-VALUE TRIPLE `#3161`에 기간을 붙인다. 1811~1816년에만 없었다.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000           #3161 TRIPLE P1304 Q30 NONE normal
0AB9 0051 0C5A 0191 0244 0051 0C59 06E2 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
0AB9 0051 0C5B 0191 0246 0051 0C59 06E2 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

## 관련 페이지

- [Edge](_index.md), [TRIPLE](0x0AAL-triple.md), [SOURCE](0x0C0L-source.md), [WIKIDATA-PID](../reference/0x019L-wikidata-pid.md), [EDTF](../value/0x06EL-edtf.md), [자리 표지](../slot-marker.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000AB0/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000AB000000000
BODY
#1 DECLARE 0x0AB0
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 BIND #1 "QUALIFIER"
#6 BIND #2 "property"
#7 BIND #3 "target"
#8 BIND #4 "value"
#9 CODEC #3 0x0050
#10 CODEC #4 0x000F
#14 CODEC #4 0x020F
#15 CODEC #4 0x040F
#11 CODEC #4 0x060F
#16 CODEC #4 0x080F
#12 CODEC #4 0x0010
#13 CODEC #4 0x0020
```
