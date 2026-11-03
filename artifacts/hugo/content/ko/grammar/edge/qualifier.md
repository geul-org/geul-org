---
title: "QUALIFIER"
weight: 12
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "QUALIFIER는 다른 Edge(주로 TRIPLE)의 명제를 한정하는 조건 하나를 붙이는 서술 Edge다(Codec 0x0ABL). Value에는 값 대신 알 수 없음(UNKNOWN-VALUE)이나 없음(NO-VALUE)을 쓸 수 있다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUALIFIER는 다른 Edge(주로 [TRIPLE](/ko/grammar/edge/triple/))가 담은 명제를 한정하는 조건 하나를 붙이는 서술 Edge다. Codec `0x0ABL`.

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

- Property, Target은 정확히 하나의 완전한 Reference 레코드이고, Target은 LOCAL Reference다. geul.org 규격 문서는 Target에 [CODEC](/ko/grammar/edge/codec/) LOCAL(`0050`)을 둔다. Value는 정확히 하나의 완전한 Reference 또는 Value 레코드, 또는 [자리 표지](/ko/grammar/reference/slot-marker/) `0x0010`(UNKNOWN-VALUE)·`0x0020`(NO-VALUE) 1 WORD다. 규격 문서는 Value에 CODEC `000F`, `060F`, `0010`, `0020`을 둔다. ABSENT(`0x0000`)는 받지 않는다. Property·Target은 자리 표지를 받지 않는다. Value를 읽은 커서는 Edge 끝과 맞아야 한다.
- Target은 같은 문서 안의 Edge Id다. QUALIFIER는 한정하는 Edge와 같은 문서에 둔다.
- Target이 HEAD의 [SOURCE](/ko/grammar/edge/source/#문서-전체의-출처)(문서 전체의 원천)이면 QUALIFIER도 HEAD에, 그 SOURCE 뒤에 둔다. 그 밖의 QUALIFIER는 BODY에 둔다. HEAD SOURCE를 Target으로 하는 QUALIFIER가 BODY에 있으면 invalid다.
- Target은 TRIPLE 말고 다른 Edge일 수 있다. [SOURCE](/ko/grammar/edge/source/)에 붙은 QUALIFIER는 인용 행위를 한정한다(조회일, 원천 안의 위치 등). SOURCE의 의미도 그것을 가리키는 QUALIFIER를 모두 모은 것이다.
- **QUALIFIER는 명제의 일부다.** 명제에 관한 별도의 주장이 아니라, 명제가 참이 되는 조건을 한정한다. 대상 TRIPLE의 의미는 그것을 가리키는 QUALIFIER를 모두 모은 것이다.
  - 명제의 출처는 [SOURCE](/ko/grammar/edge/source/)로 쓴다. 원천 노드의 속성(제목, 저자 등)은 원천을 Subject로 하는 TRIPLE로 쓴다.
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

- `#10`: TAG 1 + Edge Id 2 + Property 2 + Target 2 + Value 3 = 10 WORD. Value는 [EDTF](/ko/grammar/value/time/edtf/) `"1971"`이다.

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

- [Edge](/ko/grammar/edge/), [TRIPLE](/ko/grammar/edge/triple/), [SOURCE](/ko/grammar/edge/source/), [WIKIDATA-PID](/ko/grammar/reference/wikidata-pid/), [EDTF](/ko/grammar/value/time/edtf/), [자리 표지](/ko/grammar/reference/slot-marker/)
