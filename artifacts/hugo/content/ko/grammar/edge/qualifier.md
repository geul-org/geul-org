---
title: "QUALIFIER"
weight: 12
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "QUALIFIER는 다른 Edge(주로 TRIPLE)의 명제를 한정하는 조건 하나를 붙이는 서술 Edge다(Codec 0x0B)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUALIFIER는 다른 Edge(주로 [TRIPLE](/ko/grammar/edge/triple/))가 담은 명제를 한정하는 조건 하나를 붙이는 서술 Edge다. Codec `0x0B`.

위키데이터 qualifier(snak) 하나와 같다: 속성 하나와 값 하나.

## 레이아웃

```
TAG WORD          0001 0LLL L000 1011
[Length 확장 TAG]
Edge Id           LOCAL Reference 레코드
Property          Reference 레코드 (WIKIDATA-PID 등)
Target            LOCAL Reference 레코드 (한정하는 Edge의 Edge Id)
Value             Reference 또는 Value 레코드
```

- 구성요소 순서는 TRIPLE과 같다(Property ↔ Predicate, Target ↔ Subject, Value ↔ Object). 디코더는 같은 경로로 읽는다. 역할은 Codec이 정한다.

## 해석과 유효성

- Property, Target은 정확히 하나의 완전한 Reference 레코드이고, Target은 LOCAL Reference다. geul.org 규격 문서는 Target에 [CODEC](/ko/grammar/edge/codec/) LOCAL(`0008`)을 둔다. Value는 정확히 하나의 완전한 Reference 또는 Value 레코드다. Value를 읽은 커서는 Edge 끝과 맞아야 한다.
- Target은 같은 문서 안의 Edge Id다. QUALIFIER는 한정하는 Edge와 같은 문서에 둔다.
- **QUALIFIER는 명제의 일부다.** 명제에 관한 별도의 주장이 아니라, 명제가 참이 되는 조건을 한정한다. 대상 TRIPLE의 의미는 그것을 가리키는 QUALIFIER를 모두 모은 것이다.
  - 명제에 관한 별도의 주장(누가 언제 주장했나, 출처 노드의 속성 등)은 TRIPLE로 쓴다.
- 같은 Target에 같은 Property의 QUALIFIER가 여럿일 수 있다. 같은 Target의 QUALIFIER 순서는 문서 안 순서다(Edge 순서에 의미를 주는 예외).

## 예시 (비규범)

Q42 P69(educated at) Q691283(St John's College), 1971~1974.

```
TRIPLE     #9   P69   Q42  Q691283  rank 0
QUALIFIER  #10  P580  #9   EDTF "1971"
QUALIFIER  #11  P582  #9   EDTF "1974"
```

- `#10`: TAG 1 + Edge Id 2 + Property 2 + Target 2 + Value 3 = 10 WORD. Value는 [EDTF](/ko/grammar/value/time/edtf/) `"1971"`이다.

```
148B 0088 000A 00A8 0244 0088 0009 0924 3139 3731
```

## 열린 문제

- 값 없음(위키데이터 novalue)과 값 미상(somevalue)을 Value로 쓰는 방법. 정해질 때까지 그런 qualifier는 쓰지 않는다.

## 관련 페이지

- [Edge](/ko/grammar/edge/), [TRIPLE](/ko/grammar/edge/triple/), [WIKIDATA-PID](/ko/grammar/reference/wikidata-pid/), [EDTF](/ko/grammar/value/time/edtf/)
