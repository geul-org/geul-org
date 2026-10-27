---
title: "GEUL 문법"
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "specification"]
summary: "GEUL v1 문법 명세. 16비트 워드 위의 레코드, 네 가지 Kind와 모든 Codec, 문서 구조, Issuer와 공표 규칙을 정의한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
showContent: true
---

GEUL v1 문법 명세다. 처음 읽는다면 아래 순서로 읽는다.

1. [개요](/ko/grammar/overview/) — GEUL이 무엇이고 어떤 원칙으로 설계했는가
2. [레코드와 TAG WORD](/ko/grammar/record/) — 16비트 TAG WORD, Kind, Length, Codec
3. [문서](/ko/grammar/document/) — HEAD와 BODY, 내용 해시, 버전과 개정
4. [Reference](/ko/grammar/reference/), [Value](/ko/grammar/value/), [Edge](/ko/grammar/edge/), [Meta](/ko/grammar/meta/) — 네 가지 Kind
5. [Issuer와 공표](/ko/grammar/issuer/) — 문서와 형식을 내는 주체, 1 WORD 배정표, 공개 방식, 서명과 검증키
6. [공표 주소와 버전 목록](/ko/grammar/publishing/) — ID 표기, 공표 주소, 형식 지정, 이름 색인, 버전 목록, 신뢰 층
7. [Codec 규격 문서](/ko/grammar/codec-spec/) — Codec 레이아웃을 GEUL 문서로 쓰는 법
8. [예시: 위키데이터 항목](/ko/grammar/example/) — 실제 문서 한 벌

이 페이지는 모든 Codec의 색인이다. 이름을 누르면 그 Codec의 상세 문서로 간다. 링크가 없는 이름은 아직 상세 문서가 없다. 표에 없는 직접 코드는 예약이다.

## Kind

TAG WORD는 `000K KLLL LCCC CCCC`다. `KK`는 Kind, `LLLL`은 Length, `CCC CCCC`는 Codec 7비트다. 단, Reference는 Codec 4비트와 Quantifier 3비트다.

| 값 | 분류 | 설명 |
|---|---|---|
| `0000 0LLL LCCC CQQQ` | [Reference](/ko/grammar/reference/) | 대상을 가리키는 레코드. `QQQ`는 Quantifier |
| `0000 1LLL LCCC CCCC` | [Value](/ko/grammar/value/) | 값 레코드 |
| `0001 0LLL LCCC CCCC` | [Edge](/ko/grammar/edge/) | 구성 레코드 |
| `0001 1LLL LCCC CCCC` | [Meta](/ko/grammar/meta/) | 문서와 레코드에 관한 레코드 |

## Reference

`0000 0LLL LCCC CQQQ` — [Reference](/ko/grammar/reference/)

### Codec (`CCCC`)

| CCCC | 이름 | 분류 | 대상 ID |
|---|---|---|---|
| `0000` | [자리 표지](/ko/grammar/reference/slot-marker/) | 예약 | 대상을 가리키지 않는 1 WORD 표지 묶음. 하위 3비트가 표지 번호다(아래 표) |
| `0001` | [LOCAL](/ko/grammar/reference/local/) | 선언 | 이 문서가 발급한 ID |
| `0010` | [GEUL](/ko/grammar/reference/geul/) | 선언 | geul.org가 CC0로 발급하는 엔티티. 작은 번호를 고빈도 엔티티에 배정한다 |
| `0011` | [GEUL-SIDX](/ko/grammar/reference/geul-sidx/) | 선언 | GEUL SIDX(Semantic-aligned Index). 비트에 의미를 담은 식별자 |
| `0100` | [WIKIDATA-QID](/ko/grammar/reference/wikidata-qid/) | 선언 | 위키데이터 항목. `Q` 뒤의 정수 |
| `0101` | [WIKIDATA-PID](/ko/grammar/reference/wikidata-pid/) | 선언 | 위키데이터 속성. `P` 뒤의 정수 |
| `0110` | [ISSUER-POINTER](/ko/grammar/reference/issuer-pointer/) | 지시선언 | Issuer 자신. Payload는 Issuer(1/2/4/16 WORD)뿐이며 대상 ID가 없다 |
| `0111` | [DOC-POINTER](/ko/grammar/reference/doc-pointer/) | 지시선언 | Issuer 문서의 한 버전. Issuer + 문서 ID 4 WORD + 버전 ID 2 WORD, 대상 ID가 없다 |
| `1000` | [EXTERNAL-POINTER-1WORD](/ko/grammar/reference/external-pointer/) | 지시 | `IMPORT-DOC`으로 가져온 문서의 LOCAL ID. IMPORT ID 1 WORD |
| `1001` | [EXTERNAL-POINTER-2WORD](/ko/grammar/reference/external-pointer/) | 지시 | 위와 같음. IMPORT ID 2 WORD |
| `1010` | [EXTERNAL-POINTER-4WORD](/ko/grammar/reference/external-pointer/) | 지시 | 위와 같음. IMPORT ID 4 WORD |
| `1011` | [EXTERNAL-POINTER-8WORD](/ko/grammar/reference/external-pointer/) | 지시 | 위와 같음. IMPORT ID 8 WORD |
| `1100` | [EXTERNAL-ISSUER-1WORD](/ko/grammar/reference/external-issuer/) | 지시선언 | 1 WORD Issuer 문서의 LOCAL ID |
| `1101` | [EXTERNAL-ISSUER-2WORD](/ko/grammar/reference/external-issuer/) | 지시선언 | 2 WORD Issuer 문서의 LOCAL ID |
| `1110` | [EXTERNAL-ISSUER-4WORD](/ko/grammar/reference/external-issuer/) | 지시선언 | 4 WORD Issuer 문서의 LOCAL ID |
| `1111` | [EXTERNAL-ISSUER-16WORD](/ko/grammar/reference/external-issuer/) | 지시선언 | 16 WORD Issuer 문서의 LOCAL ID |

### 자리 표지 (Codec `0000`)

`0000 0000 0000 0MMM` — [자리 표지](/ko/grammar/reference/slot-marker/). 필드의 CODEC 목록이 그 WORD를 정확히 둘 때만 그 자리에 온다.

| WORD | 이름 | 뜻 | 위키데이터 |
|---|---|---|---|
| `0x0000` | [ABSENT](/ko/grammar/reference/slot-marker/) | 적지 않음. 선택 필드를 생략했다. 세계에 관해 아무것도 단언하지 않는다 | snak 없음 |
| `0x0001` | [UNKNOWN-VALUE](/ko/grammar/reference/slot-marker/) | 알 수 없음. 값이 있지만 무엇인지 모른다 | `somevalue` |
| `0x0002` | [NO-VALUE](/ko/grammar/reference/slot-marker/) | 없음. 값이 없다 | `novalue` |
| `0x0003`~`0x0007` | Reserved | | |

### Quantifier (`QQQ`)

| QQQ | 이름 | 의미 | 예시 |
|---|---|---|---|
| `000` | Identified | 식별된 개체 | 일론 머스크, 대한민국 |
| `001` | Generic | 종류 전체에 관한 일반적·정의적 진술. 예외를 허용한다. | 병사는 명령에 복종한다 |
| `010` | Free-choice | 조건을 만족하는 임의의 대상 | 아무 병사나 |
| `011` | Universal | 주어진 범위에 속하는 모든 대상 | 모든 병사 |
| `100` | Variable | 담화 변수 | 그 사람, 이 여자 |
| `101`~`111` | Reserved |  |  |

- Codec `0000`(자리 표지)에서는 하위 3비트가 Quantifier가 아니라 표지 번호다.

## Issuer

Issuer는 문서와 형식을 정의하는 주체다 — [Issuer와 공표](/ko/grammar/issuer/)

| 자리 | 뜻 |
|---|---|
| Value·Edge ISSUER 코드(`0x7C`~`0x7F`) | 그 Issuer가 정의한 형식 |
| Meta `DOC-ID` | 이 문서를 낸 Issuer |
| Meta `IMPORT-DOC` | 가져온 문서를 낸 Issuer |
| Reference `EXTERNAL-ISSUER-*`·`DOC-POINTER` | 가리키는 문서를 낸 Issuer(1/2/4/16 WORD) |
| Reference `ISSUER-POINTER` | 가리키는 Issuer 자신(1/2/4/16 WORD) |

| Issuer 폭 | 발급 |
|---|---|
| 1 WORD | geul.org가 표준 제정 단체와 주요 기관에 배정한다([1 WORD 배정표](/ko/grammar/issuer/#1-word-배정표)). |
| 2 WORD | geul.org 등록. 도메인 소유 증명(예: company.com)을 거친 Issuer |
| 4 WORD | geul.org 등록. 소유 증명 없이 등록한 Issuer |
| 16 WORD | 자체 발급. 등록 없이 공개키에서 계산한다. 아래 생성 규칙을 따른다. |

### 16 WORD Issuer 서명 알고리즘

| 서명 알고리즘 ID | 알고리즘 |
|---|---|
| `0x0001` | Ed25519 |
| 그 외 | 예약 |

## Edge

`0001 0LLL LCCC CCCC` — [Edge](/ko/grammar/edge/)

Codec의 상위 2비트가 계열이다. 직접 코드(7비트)와 ISSUER 형식 번호(16비트) 모두 같은 규칙을 따른다.

| 상위 2비트 | 계열 | 직접 코드 | 형식 번호 |
|---|---|---|---|
| `00` | 서술 | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | 근거 | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | 실행 | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | [TOULMIN](/ko/grammar/edge/toulmin/) | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

### 서술 (`00`)

| CCCCC | Codec | 이름 | 하위 형식 | 설명 |
|---|---|---|---|---|
| `00000` | `0x00` | [REFERENCE-NODE](/ko/grammar/edge/reference-node/) |  | Reference인 Subject가 Object를 지시하는 방향성 바인딩 |
| `00001` | `0x01` | [SAME-NODE](/ko/grammar/edge/same-node/) |  | 두 Reference가 동일한 대상을 지시하는 동일성 |
| `00010` | `0x02` | [DIFFERENT-NODE](/ko/grammar/edge/different-node/) |  | 두 Reference가 서로 다른 대상을 지시하는 비동일성 |
| `00011` | `0x03` | [BIND](/ko/grammar/edge/bind/) |  | Subject에 기계가 맞추는 이름(`UTF8-TEXT-*`)을 묶는다. 범위 안에서 유일하고 정확히 일치해야 하며 언어가 없다 |
| `00100` | `0x04` | [LABEL](/ko/grammar/edge/label/) |  | Subject의 언어 이름(label) 연결. Object는 UTF8-LANGUAGE-TEXT |
| `00101` | `0x05` | [ALIAS](/ko/grammar/edge/alias/) |  | Subject의 다른 이름(별칭) 연결. 레이아웃은 LABEL과 같다 |
| `00110` | `0x06` | [DESCRIPTION](/ko/grammar/edge/description/) |  | Subject의 언어 설명(description) 연결. 레이아웃은 LABEL과 같다 |
| `00111` | `0x07` | Reserved |  |  |
| `01000` | `0x08` | VERB-SHORT |  | 동사 서술 축약 |
| `01001` | `0x09` | VERB |  | 동사 서술 |
| `01010` | `0x0A` | [TRIPLE](/ko/grammar/edge/triple/) |  | Predicate, Subject, Object 순서의 명제와 rank. Object는 값 또는 UNKNOWN-VALUE·NO-VALUE 표지. 의미는 그 Edge Id를 가리키는 QUALIFIER를 모두 모은 것이다 |
| `01011` | `0x0B` | [QUALIFIER](/ko/grammar/edge/qualifier/) |  | 다른 Edge의 명제를 한정하는 조건 하나. Property, Target(Edge Id), Value(값 또는 UNKNOWN-VALUE·NO-VALUE 표지). 명제의 일부다 |
| `01100`~`01111` | `0x0C`~`0x0F` | Reserved |  |  |
| `10000` | `0x10` | WORLD | 있음 | 세계관 표현을 위한 구조 |
| `10001` | `0x11` | TIMELINE | 있음 | 세계와 사건의 순서를 표현하는 구조 |
| `10010` | `0x12` | SCENE | 있음 | 시나리오 특성의 서술을 위한 장면 구조 |
| `10011`~`10111` | `0x13`~`0x17` | Reserved |  |  |
| `11000` | `0x18` | [PUBLICATION](/ko/grammar/edge/publication/) |  | 문서 공표. DOC-POINTER, 내용 해시 |
| `11001` | `0x19` | DEPRECATION |  | 공표한 버전의 deprecate. DOC-POINTER |
| `11010` | `0x1A` | TOMBSTONE |  | 공표한 버전의 삭제(묘비). DOC-POINTER, 사유 범주 |
| `11011` | `0x1B` | [DECLARE](/ko/grammar/edge/declare/) |  | Codec 하나의 Payload 구성 선언. 대상 Kind·Codec |
| `11100` | `0x1C` | [FIELD](/ko/grammar/edge/field/) |  | Payload 필드 하나. 속한 DECLARE, 폭: 레코드(TAG의 Length) 또는 날값 n WORD |
| `11101` | `0x1D` | [ENUM](/ko/grammar/edge/enum/) |  | 날값 필드의 코드값 하나. 필드, 코드값 |
| `11110` | `0x1E` | [CODEC](/ko/grammar/edge/codec/) |  | 필드가 받는 Kind·Codec 하나. 필드, 대상 WORD(`000K KLLL LCCC CCCC`, LLLL 0000 정확·1111 와일드카드, 자리 표지는 정확한 대상 `0000`~`0002`로만). 레코드 필드는 여러 개(닫힌 목록), 날값 필드는 하나(TAG 없는 그 Value) |
| `11111` | `0x1F` | Reserved |  |  |

| CCCCC 상위 2비트 | 묶음 |
|---|---|
| `00` | 지시와 이름 |
| `01` | 명제 |
| `10` | 구조 |
| `11` | 기타 |

### 근거 (`01`)

| Codec | 이름 | 하위 형식 | 설명 |
|---|---|---|---|
| `0x20` | [SOURCE](/ko/grammar/edge/source/) |  | 레코드 하나 또는 문서 전체를 그 원천에 잇는다. Target(BODY Edge Id, HEAD에서는 `0` = 문서 전체), Origin(Reference, ABSENT 또는 UNKNOWN-VALUE). 원천의 성질은 원천을 Subject로 하는 TRIPLE, 인용의 성질(조회일, 위치, 원문 해시)은 SOURCE에 붙는 QUALIFIER. 문서 전체의 SOURCE와 그 QUALIFIER는 HEAD에 둔다 |
| `0x21`~`0x3F` | Reserved |  |  |

- 원문 범위, 만든 주체, 신뢰도, 조문별 시행 기간, 옛 레코드는 QUALIFIER로 쓰고, 처음 들어온 버전은 버전 이력에서 계산한다([SOURCE](/ko/grammar/edge/source/#다른-근거의-표현)).

### 실행 (`10`)

| CCCCC | Codec | 이름 | 설명 |
|---|---|---|---|
| `00000` | `0x40` | Reserved |  |
| `00001` | `0x41` | FUNCTION-DECLARE | 함수 선언. 기호, 매개변수 기호 목록, 반환 타입, 본문(BLOCK) |
| `00010` | `0x42` | TYPE-DECLARE | 타입 선언. 기호와 구성(필드 기호 목록, 열거값, 별칭 대상) |
| `00011`~`00111` | `0x43`~`0x47` | Reserved |  |
| `01000` | `0x48` | CONST | 상수식. 내장 Value 하나 |
| `01001` | `0x49` | UNARY | 단항식. 연산자 1 WORD, 피연산자 |
| `01010` | `0x4A` | BINARY | 이항식. 연산자 1 WORD, 왼쪽, 오른쪽 |
| `01011` | `0x4B` | CALL | 호출. 대상 함수, 인자 수, 인자 × 인자 수 |
| `01100` | `0x4C` | MEMBER | 멤버 접근. 대상, 필드 기호 |
| `01101` | `0x4D` | INDEX | 색인 접근. 대상, 색인 |
| `01110` | `0x4E` | CONSTRUCT | 복합값 생성(목록, 레코드). 타입, 요소 수, 요소 × 요소 수 |
| `01111` | `0x4F` | CONDITIONAL | 조건식. 조건, 참일 때 값, 거짓일 때 값 |
| `10000` | `0x50` | BLOCK | 순서 있는 문 묶음. 문 수, 문 × 문 수 |
| `10001` | `0x51` | ASSIGN | 대입. 대상(기호, MEMBER, INDEX), 값 |
| `10010` | `0x52` | IF | 조건 분기. 조건, 참 BLOCK, 거짓(BLOCK·IF, 없으면 0) |
| `10011` | `0x53` | SWITCH | 다중 분기. 대상, 갈래 수, (값, BLOCK) × 갈래 수, 기본 BLOCK(없으면 0) |
| `10100` | `0x54` | WHILE | 조건 반복. 조건, 본문 BLOCK |
| `10101` | `0x55` | FOREACH | 순회 반복. 요소 기호, 대상, 본문 BLOCK |
| `10110` | `0x56` | JUMP | 반복 제어. 종류 1 WORD(break, continue), 대상 반복 |
| `10111` | `0x57` | RETURN | 반환. 값(없으면 0) |
| `11000` | `0x58` | RAISE | 오류 발생. 오류 값 |
| `11001` | `0x59` | TRY | 오류 처리. 본문 BLOCK, 오류 기호, 처리 BLOCK, 마무리 BLOCK(없으면 0) |
| `11010`~`11111` | `0x5A`~`0x5F` | Reserved |  |

| CCCCC 상위 2비트 | 묶음 |
|---|---|
| `00` | 선언 |
| `01` | 식 |
| `10` | 문 |
| `11` | 오류 |

### TOULMIN (`11`)

자세히: [TOULMIN](/ko/grammar/edge/toulmin/)

| CCCCC | Codec | 이름 | 설명 |
|---|---|---|---|
| `00000` | `0x60` | [CASE-DECLARE](/ko/grammar/edge/toulmin/node/) | 사안 선언. 노드와 관계를 담는 판정 그래프 |
| `00001` | `0x61` | [PREDICATE-DECLARE](/ko/grammar/edge/toulmin/expr/) | 술어 선언. 판정 함수·식, 판단 기준(Spec), 사실 계약(Ground) |
| `00010` | `0x62` | [SPEC-DECLARE](/ko/grammar/edge/toulmin/node/) | 판단 기준 선언. 상수·목록 (Backing) |
| `00011` | `0x63` | [RULE-DECLARE](/ko/grammar/edge/toulmin/node/) | 주장 선언. 사안 안에서 술어를 일반 규칙(Warrant)으로 둔다. 공격받을 수 있다. |
| `00100` | `0x64` | [COUNTER-DECLARE](/ko/grammar/edge/toulmin/node/) | 반박 선언. 자기 결론을 가지고 공격한다. 기본 Level은 Fail |
| `00101` | `0x65` | [EXCEPT-DECLARE](/ko/grammar/edge/toulmin/node/) | 예외 선언. 자기 결론 없이 공격한다. 기본 Level은 Review |
| `00110`~`00111` | `0x66`~`0x67` | Reserved |  |
| `01000` | `0x68` | [ATTACKS](/ko/grammar/edge/toulmin/link/) | 공격 관계. 공격자의 판정이 대상의 판정을 점진적으로 깎는다. |
| `01001` | `0x69` | [SUPERSEDES](/ko/grammar/edge/toulmin/link/) | 배제 관계. 공격자가 Active이면 대상을 집계에서 결정적으로 뺀다. |
| `01010` | `0x6A` | SUPERSEDE-CHAIN | 우선순위 사슬 `A > B > C`. 쌍별 SUPERSEDES의 축약. 레이아웃 미정 |
| `01011`~`01111` | `0x6B`~`0x6F` | Reserved |  |
| `10000` | `0x70` | [RUN](/ko/grammar/edge/toulmin/link/) | 실행 합성. 노드가 Active이면 하위 사안을 실행한다(DAG). |
| `10001` | `0x71` | [DO](/ko/grammar/edge/toulmin/link/) | 노드가 Active이면 수행하는 동작 |
| `10010` | `0x72` | [DO-ONCE](/ko/grammar/edge/toulmin/link/) | 재시도해도 한 번만 수행하는 동작 |
| `10011` | `0x73` | [UNDO](/ko/grammar/edge/toulmin/link/) | DO의 보상 동작(saga). 이후 단계가 실패하면 역순으로 수행한다. |
| `10100` | `0x74` | [CHECKING](/ko/grammar/edge/toulmin/link/) | 부작용 없이 판정만 하는 연결 |
| `10101` | `0x75` | [ENTRY](/ko/grammar/edge/toulmin/node/) | 외부 진입점. 사안을 실행하거나 판정한다 |
| `10110` | `0x76` | [TRIGGER](/ko/grammar/edge/toulmin/node/) | 외부 호출 없는 이벤트·주기 진입점 |
| `10111` | `0x77` | Reserved |  |
| `11000` | `0x78` | VERDICT | 노드·레코드의 판정 결과. 결과(Pass, Review, Fail), 판정값, Activated, Excluded, Level. 레이아웃 미정. 문서 전체의 판정은 Meta [VERDICT](/ko/grammar/meta/verification/verdict/)(`0x44`) |
| `11001` | `0x79` | EVIDENCE | 판정의 증거. 위치, 기대값, 실제값 (Fact). 레이아웃 미정 |
| `11010`~`11011` | `0x7A`~`0x7B` | Reserved |  |
| `111xx` | `0x7C`~`0x7F` | ISSUER-* | Issuer가 정의한 형식 |

| CCCCC 상위 2비트 | 묶음 |
|---|---|
| `00` | 선언 |
| `01` | 관계 |
| `10` | 실행 |
| `11` | 결과 (`0x7C`~`0x7F`는 ISSUER) |

### Edge ISSUER 형식

`0x7C`~`0x7F`(ISSUER-1/2/4/16WORD) 뒤 Codec 확장 TAG에 Issuer와 형식 번호를 둔다. 형식 번호의 상위 2비트가 계열이다. 형식 번호 공간은 Value와 따로다.

| Issuer | 형식 번호 | 이름 | 계열 | 설명 |
|---|---|---|---|---|
| `0x0000` GEUL | `0xC000` | [SOURCE](/ko/grammar/edge/toulmin/source/) | TOULMIN | 저작 원문. SPAN 폭과 UTF8 Value |
| `0x0000` GEUL | `0xC001` | [TEXT](/ko/grammar/edge/toulmin/source/) | TOULMIN | 이름·문자열 |
| `0x0000` GEUL | `0xC002` | [SECTION](/ko/grammar/edge/toulmin/source/) | TOULMIN | 섹션 시작. 섹션 코드 |
| `0x0000` GEUL | `0xC003` | [CASE-BEGIN](/ko/grammar/edge/toulmin/source/) | TOULMIN | 사안 범위 시작 |
| `0x0000` GEUL | `0xC004` | [CASE-END](/ko/grammar/edge/toulmin/source/) | TOULMIN | 사안 범위 끝 |
| `0x0000` GEUL | `0xC005` | [PROSE](/ko/grammar/edge/toulmin/source/) | TOULMIN | 서술 문단(SPAN) |
| `0x0000` GEUL | `0xC010` | [NAMESPACE](/ko/grammar/edge/toulmin/node/) | TOULMIN | NODE. `this document is` |
| `0x0000` GEUL | `0xC011` | [FUNC](/ko/grammar/edge/toulmin/node/) | TOULMIN | NODE. 함수 참조 |
| `0x0000` GEUL | `0xC012` | [FIELD](/ko/grammar/edge/toulmin/node/) | TOULMIN | NODE. `is required` |
| `0x0000` GEUL | `0xC013` | [ALIAS](/ko/grammar/edge/toulmin/node/) | TOULMIN | NODE. `see … from` |
| `0x0000` GEUL | `0xC014` | [GROUP](/ko/grammar/edge/toulmin/node/) | TOULMIN | NODE. 순서 있는 실행 묶음 |
| `0x0000` GEUL | `0xC020` | [REQUIRES](/ko/grammar/edge/toulmin/link/) | TOULMIN | LINK. 사안 → 필드 |
| `0x0000` GEUL | `0xC021` | [MEANS](/ko/grammar/edge/toulmin/link/) | TOULMIN | LINK. 정의 항목 → 값·타입 |
| `0x0000` GEUL | `0xC022` | [HAS](/ko/grammar/edge/toulmin/link/) | TOULMIN | LINK. 정의 항목 → 필드 |
| `0x0000` GEUL | `0xC023` | [RUNS](/ko/grammar/edge/toulmin/link/) | TOULMIN | LINK. 진입점 → 사안, 실행 |
| `0x0000` GEUL | `0xC024` | [EVALUATES](/ko/grammar/edge/toulmin/link/) | TOULMIN | LINK. 진입점 → 사안, 판정 |
| `0x0000` GEUL | `0xC025` | [TRIGGERS](/ko/grammar/edge/toulmin/link/) | TOULMIN | LINK. 트리거 → 사안 |
| `0x0000` GEUL | `0xC026` | [UNTIL](/ko/grammar/edge/toulmin/link/) | TOULMIN | LINK. 트리거 → 사안(`every … until`) |
| `0x0000` GEUL | `0xC027` | [SAME-AS](/ko/grammar/edge/toulmin/link/) | TOULMIN | LINK. 노드 → 전역 식별자 |
| `0x0000` GEUL | `0xC028` | [IMPORTED-FROM](/ko/grammar/edge/toulmin/link/) | TOULMIN | LINK. 별칭 → 경로(TEXT) |
| `0x0000` GEUL | `0xC029` | [LABEL](/ko/grammar/edge/toulmin/link/) | TOULMIN | LINK. 노드 → TEXT, 이름 표기 |

## Value

`0000 1LLL LCCC CCCC` — [Value](/ko/grammar/value/)

Codec의 상위 2비트가 계열이다. NUMERIC/DECIMAL은 상위 3번째 비트로 다시 나눈다(`000` NUMERIC, `001` DECIMAL).

| 상위 2비트 | 계열 | 직접 코드 | 형식 번호 |
|---|---|---|---|
| `00` | [NUMERIC](/ko/grammar/value/numeric/)/[DECIMAL](/ko/grammar/value/decimal/) | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | [TIME](/ko/grammar/value/time/) | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | [TEXT](/ko/grammar/value/text/) | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | [BINARY](/ko/grammar/value/binary/) | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

### 직접 코드

| Codec | 이름 | 계열 | 설명 |
|---|---|---|---|
| `0x00` | [BOOL](/ko/grammar/value/numeric/bool/) | NUMERIC | 고정 1 WORD의 false 또는 true |
| `0x01` | [SIGNED-INTEGER](/ko/grammar/value/numeric/signed-integer/) | NUMERIC | 최소 WORD 2의 보수 부호 있는 정수 |
| `0x02` | [UNSIGNED-INTEGER](/ko/grammar/value/numeric/unsigned-integer/) | NUMERIC | 최소 WORD big-endian unsigned magnitude 정수 |
| `0x03` | [BINARY-FLOAT](/ko/grammar/value/numeric/binary-float/) | NUMERIC | Payload 1/2/4/8 WORD의 IEEE 754 binary16/32/64/128 scalar |
| `0x04` | [COORDINATE-EARTH](/ko/grammar/value/numeric/coordinate-earth/) | NUMERIC | 지구(WGS 84) 위도·경도 binary64, 불확도 binary32와 그 단위 Reference(ABSENT = 미상) |
| `0x05` | [COORDINATE-GEO](/ko/grammar/value/numeric/coordinate-geo/) | NUMERIC | 천체 Reference와 위도·경도 binary64, 불확도 binary32와 그 단위 Reference |
| `0x06` | [QUANTITY](/ko/grammar/value/numeric/quantity/) | NUMERIC | SIGNED-DECIMAL amount, 단위 Reference, 하한·상한. 단위·경계는 없음 표지 `0x0000` 가능 |
| `0x07`~`0x0F` | Reserved | NUMERIC |  |
| `0x10` | [SIGNED-DECIMAL](/ko/grammar/value/decimal/signed-decimal/) | DECIMAL | signed exponent `E`와 최소 WORD 2의 보수 coefficient `C`의 `C×10^E` |
| `0x11` | [UNSIGNED-DECIMAL](/ko/grammar/value/decimal/unsigned-decimal/) | DECIMAL | signed exponent `E`와 최소 WORD unsigned coefficient `C`의 `C×10^E` |
| `0x12`~`0x1F` | Reserved | DECIMAL |  |
| `0x20` | [GREGORIAN-DATE](/ko/grammar/value/time/gregorian-date/) | TIME | proleptic Gregorian `1970-01-01` 기준 signed 날짜 수 |
| `0x21` | [CIVIL-TIME-NANOSECONDS](/ko/grammar/value/time/civil-time-nanoseconds/) | TIME | 민사일 자정 후 unsigned nanosecond 계수 |
| `0x22` | [POSIX-TIMESTAMP-SECONDS](/ko/grammar/value/time/posix-timestamp-seconds/) | TIME | Unix/POSIX epoch부터의 signed 초 계수 |
| `0x23` | [DURATION-SECONDS](/ko/grammar/value/time/duration-seconds/) | TIME | epoch 없는 signed SI-second 경과 시간 |
| `0x24`/`0x25` | [EDTF](/ko/grammar/value/time/edtf/) | TIME | EDTF(ISO 8601-2) 날짜 문자열. 짝수·홀수 바이트. GREGORIAN-DATE로 쓸 수 있는 날짜는 쓰지 않는다 |
| `0x26`/`0x27` | [GEDCOM-DATE](/ko/grammar/value/time/gedcom-date/) | TIME | GEDCOM 7 날짜 값 문자열. 다른 달력(율리우스력 등)의 원본 표기 보존. 짝수·홀수 바이트 |
| `0x28`~`0x3F` | Reserved | TIME |  |
| `0x40` | [UTF8-TEXT-EVEN](/ko/grammar/value/text/utf8-text/) | TEXT | 정규화를 암시하지 않는 valid UTF-8 바이트열. 짝수 바이트 |
| `0x41` | [UTF8-TEXT-ODD](/ko/grammar/value/text/utf8-text/) | TEXT | 위와 같음. 홀수 바이트 |
| `0x42`/`0x43` | Reserved | TEXT |  |
| `0x44` | [URI-EVEN](/ko/grammar/value/text/uri/) | TEXT | RFC 3986 `URI` production ASCII 바이트열. 짝수 바이트 |
| `0x45` | [URI-ODD](/ko/grammar/value/text/uri/) | TEXT | 위와 같음. 홀수 바이트 |
| `0x46` | [LANGUAGE-BCP47-CODE-EVEN](/ko/grammar/value/text/language-bcp47-code/) | TEXT | canonical casing의 완전한 BCP 47 language tag ASCII 바이트열. 짝수 바이트 |
| `0x47` | [LANGUAGE-BCP47-CODE-ODD](/ko/grammar/value/text/language-bcp47-code/) | TEXT | 위와 같음. 홀수 바이트 |
| `0x48` | [LANGUAGE-SHORT-CODE](/ko/grammar/value/text/language-short-code/) | TEXT | 고정 Payload 1 WORD의 GEUL primary language 압축 코드 |
| `0x49` | Reserved | TEXT |  |
| `0x4A`/`0x4B` | [UTF8-LANGUAGE-TEXT](/ko/grammar/value/text/utf8-language-text/) | TEXT | 언어가 붙은 텍스트. 언어 Value 레코드(LANGUAGE-SHORT-CODE 또는 LANGUAGE-BCP47-CODE)와 UTF-8 바이트. 텍스트 바이트의 짝수·홀수 |
| `0x4C`~`0x5F` | Reserved | TEXT |  |
| `0x60` | [UUID](/ko/grammar/value/binary/uuid/) | BINARY | 고정 Payload 8 WORD의 RFC 9562 UUID 128bit |
| `0x61` | [SHA-256-DIGEST](/ko/grammar/value/binary/sha-256-digest/) | BINARY | 고정 Payload 16 WORD의 SHA-256 결과 |
| `0x62` | [SHA1-DIGEST](/ko/grammar/value/binary/sha1-digest/) | BINARY | 고정 Payload 10 WORD의 SHA-1 결과. git 객체 ID 같은 식별 용도로만 |
| `0x63`~`0x7B` | Reserved | BINARY |  |
| `0x7C`~`0x7F` | ISSUER-* |  | Issuer가 정의한 형식. 아래 Value ISSUER 형식 참조 |

### Value ISSUER 형식

`0x7C`~`0x7F`(ISSUER-1/2/4/16WORD) 뒤 Codec 확장 TAG에 Issuer와 형식 번호를 둔다. 형식 번호의 상위 2비트가 계열이다.

| Issuer | 형식 번호 | 이름 | 계열 | 설명 |
|---|---|---|---|---|
| `0x0000` GEUL | `0x4000` | [DURATION-NANOSECONDS](/ko/grammar/value/time/duration-nanoseconds/) | TIME | epoch 없는 signed nanosecond 경과 시간 |
| `0x0000` GEUL | `0xC000` | [OPAQUE-BYTES-EVEN](/ko/grammar/value/binary/opaque-bytes/) | BINARY | 의미·형식 불명의 바이트열. 짝수 바이트 |
| `0x0000` GEUL | `0xC001` | [OPAQUE-BYTES-ODD](/ko/grammar/value/binary/opaque-bytes/) | BINARY | 위와 같음. 홀수 바이트 |
| `0x0000` GEUL | `0xC002` | [BIT-VECTOR](/ko/grammar/value/binary/bit-vector/) | BINARY | bit-count 뒤에 MSB-first로 저장한 N bit |
| `0x0001` ADHOC | `0x0000` | BFLOAT16 | NUMERIC | 고정 Payload 1 WORD의 BF16 interchange bits |
| `0x0001` ADHOC | `0x0500` | [DENSE-I16-VECTOR](/ko/grammar/value/vector/dense-i16-vector/) | NUMERIC | 연속 big-endian int16 vector |
| `0x0001` ADHOC | `0x0501` | [DENSE-U16-VECTOR](/ko/grammar/value/vector/dense-u16-vector/) | NUMERIC | 연속 big-endian uint16 vector |
| `0x0001` ADHOC | `0x0502` | [DENSE-I32-VECTOR](/ko/grammar/value/vector/dense-i32-vector/) | NUMERIC | 연속 big-endian int32 vector |
| `0x0001` ADHOC | `0x0503` | [DENSE-U32-VECTOR](/ko/grammar/value/vector/dense-u32-vector/) | NUMERIC | 연속 big-endian uint32 vector |
| `0x0001` ADHOC | `0x0504` | [DENSE-I64-VECTOR](/ko/grammar/value/vector/dense-i64-vector/) | NUMERIC | 연속 big-endian int64 vector |
| `0x0001` ADHOC | `0x0505` | [DENSE-U64-VECTOR](/ko/grammar/value/vector/dense-u64-vector/) | NUMERIC | 연속 big-endian uint64 vector |
| `0x0001` ADHOC | `0x0506` | [DENSE-BINARY16-VECTOR](/ko/grammar/value/vector/dense-binary16-vector/) | NUMERIC | 연속 IEEE 754 binary16 vector |
| `0x0001` ADHOC | `0x0507` | [DENSE-BFLOAT16-VECTOR](/ko/grammar/value/vector/dense-bfloat16-vector/) | NUMERIC | 연속 BF16 vector |
| `0x0001` ADHOC | `0x0508` | [DENSE-BINARY32-VECTOR](/ko/grammar/value/vector/dense-binary32-vector/) | NUMERIC | 연속 IEEE 754 binary32 vector |
| `0x0001` ADHOC | `0x0509` | [DENSE-BINARY64-VECTOR](/ko/grammar/value/vector/dense-binary64-vector/) | NUMERIC | 연속 IEEE 754 binary64 vector |
| `0x0001` ADHOC | `0x050A` | [POINT2-BINARY64](/ko/grammar/value/vector/point2-binary64/) | NUMERIC | `(x,y)` 순서의 IEEE binary64 2차원 vector |
| `0x0001` ADHOC | `0x050B` | [POINT3-BINARY64](/ko/grammar/value/vector/point3-binary64/) | NUMERIC | `(x,y,z)` 순서의 IEEE binary64 3차원 vector |
| `0x0001` ADHOC | `0x050C` | [BBOX2-BINARY64](/ko/grammar/value/vector/bbox2-binary64/) | NUMERIC | `(minX,minY,maxX,maxY)` 순서의 IEEE binary64 vector |
| `0x0001` ADHOC | `0x0600` | [DESCRIBED-DENSE-TENSOR](/ko/grammar/value/tensor/described-dense-tensor/) | NUMERIC | element-format·rank·shape와 C-contiguous dense payload |
| `0x0001` ADHOC | `0x0601` | [DESCRIBED-PACKED-TENSOR](/ko/grammar/value/tensor/described-packed-tensor/) | NUMERIC | packed-format·rank·shape와 octet 내 low-bit-first packed payload |
| `0x0001` ADHOC | `0x0700` | [COMPLEX64](/ko/grammar/value/etc/complex64/) | NUMERIC | `(real, imag)` 순서의 binary32 두 개 |
| `0x0001` ADHOC | `0x0701` | [COMPLEX128](/ko/grammar/value/etc/complex128/) | NUMERIC | `(real, imag)` 순서의 binary64 두 개 |
| `0x0001` ADHOC | `0x0702` | [RATIONAL-I64](/ko/grammar/value/etc/rational-i64/) | NUMERIC | 정규화한 int64 numerator와 양의 int64 denominator |
| `0x0001` ADHOC | `0x0703` | [CLOSED-INTERVAL-BINARY64](/ko/grammar/value/etc/closed-interval-binary64/) | NUMERIC | `lower ≤ upper`인 binary64 닫힌 구간 |
| `0x0001` ADHOC | `0x0704` | [QUATERNION-BINARY32](/ko/grammar/value/etc/quaternion-binary32/) | NUMERIC | `(x,y,z,w)` 순서의 binary32 네 개 |
| `0x0001` ADHOC | `0xC000` | [BLAKE3-256-DIGEST](/ko/grammar/value/binary/blake3-256-digest/) | BINARY | 고정 Payload 16 WORD의 기본 BLAKE3 결과 |
| `0x0020` IETF | `0x8000` | [URI-RELATIVE-REF-EVEN](/ko/grammar/value/text/uri-relative-ref/) | TEXT | RFC 3986 relative-ref ASCII 바이트열. 짝수 바이트 |
| `0x0020` IETF | `0x8001` | [URI-RELATIVE-REF-ODD](/ko/grammar/value/text/uri-relative-ref/) | TEXT | 위와 같음. 홀수 바이트 |
| `0x0020` IETF | `0xC000` | [CRC32C](/ko/grammar/value/binary/crc32c/) | BINARY | 고정 Payload 2 WORD의 Castagnoli CRC-32C 결과 |
| `0x0020` IETF | `0xC001` | [IPV4-ADDRESS](/ko/grammar/value/binary/ipv4-address/) | BINARY | 고정 Payload 2 WORD의 IPv4 주소 32bit |
| `0x0020` IETF | `0xC002` | [IPV6-ADDRESS](/ko/grammar/value/binary/ipv6-address/) | BINARY | 고정 Payload 8 WORD의 IPv6 주소 128bit |
| `0x0040` IEEE | `0x2000` | [IEEE-DECIMAL32-DPD](/ko/grammar/value/decimal/ieee-decimal32-dpd/) | DECIMAL | 고정 Payload 2 WORD의 IEEE 754 decimal32 DPD |
| `0x0040` IEEE | `0x2001` | [IEEE-DECIMAL64-DPD](/ko/grammar/value/decimal/ieee-decimal64-dpd/) | DECIMAL | 고정 Payload 4 WORD의 IEEE 754 decimal64 DPD |
| `0x0040` IEEE | `0x2002` | [IEEE-DECIMAL128-DPD](/ko/grammar/value/decimal/ieee-decimal128-dpd/) | DECIMAL | 고정 Payload 8 WORD의 IEEE 754 decimal128 DPD |
| `0x0040` IEEE | `0x2003` | [IEEE-DECIMAL32-BID](/ko/grammar/value/decimal/ieee-decimal32-bid/) | DECIMAL | 고정 Payload 2 WORD의 IEEE 754 decimal32 BID |
| `0x0040` IEEE | `0x2004` | [IEEE-DECIMAL64-BID](/ko/grammar/value/decimal/ieee-decimal64-bid/) | DECIMAL | 고정 Payload 4 WORD의 IEEE 754 decimal64 BID |
| `0x0040` IEEE | `0x2005` | [IEEE-DECIMAL128-BID](/ko/grammar/value/decimal/ieee-decimal128-bid/) | DECIMAL | 고정 Payload 8 WORD의 IEEE 754 decimal128 BID |
| `0x0040` IEEE | `0x4000` | [POSIX-TIMESTAMP-NANOSECONDS](/ko/grammar/value/time/posix-timestamp-nanoseconds/) | TIME | Unix/POSIX epoch부터의 signed nanosecond 계수 |
| `0x0040` IEEE | `0xC000` | [MAC-48-ADDRESS](/ko/grammar/value/binary/mac-48-address/) | BINARY | 고정 Payload 3 WORD의 IEEE 802 MAC 주소 48bit |
| `0x0041` KHRONOS | `0x0000` | [RGBA8-UNORM](/ko/grammar/value/vector/rgba8-unorm/) | NUMERIC | R, G, B, A 순서의 고정 4×UNORM8 packed vector |
| `0x0041` KHRONOS | `0x0001` | [BGRA8-UNORM](/ko/grammar/value/vector/bgra8-unorm/) | NUMERIC | B, G, R, A 순서의 고정 4×UNORM8 packed vector |
| `0x0043` ONNX | `0x0000` | FP8-E4M3FN | NUMERIC | Payload 상위 octet의 ONNX E4M3FN scalar |
| `0x0043` ONNX | `0x0001` | FP8-E4M3FNUZ | NUMERIC | Payload 상위 octet의 ONNX E4M3FNUZ scalar |
| `0x0043` ONNX | `0x0002` | FP8-E5M2 | NUMERIC | Payload 상위 octet의 ONNX E5M2 scalar |
| `0x0043` ONNX | `0x0003` | FP8-E5M2FNUZ | NUMERIC | Payload 상위 octet의 ONNX E5M2FNUZ scalar |
| `0x0044` OCP | `0x0000` | FP8-E8M0FNU | NUMERIC | Payload 상위 octet의 unsigned exponent-only E8M0FNU scalar |
| `0x0044` OCP | `0x0001` | FP4-E2M1FN | NUMERIC | Payload 상위 nibble의 ONNX/DLPack E2M1FN scalar |
| `0x0060` BIPM | `0x4000` | [TAI-TIMESTAMP-SECONDS](/ko/grammar/value/time/tai-timestamp-seconds/) | TIME | `1970-01-01T00:00:00 TAI`부터의 signed SI-second 계수 |
| `0x0060` BIPM | `0x4001` | [TAI-TIMESTAMP-NANOSECONDS](/ko/grammar/value/time/tai-timestamp-nanoseconds/) | TIME | 같은 TAI epoch부터의 signed nanosecond 계수 |
| `0x0062` NIST | `0xC000` | [SHA-512-DIGEST](/ko/grammar/value/binary/sha-512-digest/) | BINARY | 고정 Payload 32 WORD의 SHA-512 결과 |
| `0x0062` NIST | `0xC001` | [SHA3-256-DIGEST](/ko/grammar/value/binary/sha3-256-digest/) | BINARY | 고정 Payload 16 WORD의 SHA3-256 결과 |
| `0x0063` GPS | `0x4000` | [GPS-TIMESTAMP-SECONDS](/ko/grammar/value/time/gps-timestamp-seconds/) | TIME | GPS epoch부터의 signed second 계수 |
| `0x0063` GPS | `0x4001` | [GPS-TIMESTAMP-NANOSECONDS](/ko/grammar/value/time/gps-timestamp-nanoseconds/) | TIME | GPS epoch부터의 signed nanosecond 계수 |

## Meta

`0001 1LLL LCCC CCCC` — [Meta](/ko/grammar/meta/)

Codec의 상위 3비트가 클래스다. Meta에는 ISSUER 코드가 없다.

| 상위 3비트 | 클래스 | 직접 코드 | 다루는 것 |
|---|---|---|---|
| `000` | [구조](/ko/grammar/meta/structure/) | `0x00`~`0x0F` | 문서의 경계와 길이 |
| `001` | [정의](/ko/grammar/meta/declaration/) | `0x10`~`0x1F` | 해석 선언 |
| `010` | [출처](/ko/grammar/meta/provenance/) | `0x20`~`0x2F` | 누가, 언제, 어디서 |
| `011` | [계보](/ko/grammar/meta/lineage/) | `0x30`~`0x3F` | 무엇에서 어떻게 나왔는가 |
| `100` | [검증](/ko/grammar/meta/verification/) | `0x40`~`0x4F` | 믿을 수 있는가 |
| `101` | [정책](/ko/grammar/meta/policy/) | `0x50`~`0x5F` | 어떻게 취급하는가 |
| `110` | [IMPORT](/ko/grammar/meta/import/) | `0x60`~`0x6F` | 외부 문서를 IMPORT ID로 가져온다 (`IMPORT-DOC`) |
| `111` | Reserved | `0x70`~`0x7F` |  |

### 구조 (`000`)

| Codec | 이름 | 설명 |
|---|---|---|
| `0x00` | [DOC-1WORD](/ko/grammar/meta/structure/doc/) | 전체 길이를 Payload 1 WORD에 지정한 문서 시작 |
| `0x01` | [DOC-2WORD](/ko/grammar/meta/structure/doc/) | 전체 길이를 Payload 2 WORD에 지정한 문서 시작 |
| `0x02` | [DOC-4WORD](/ko/grammar/meta/structure/doc/) | 전체 길이를 Payload 4 WORD에 지정한 문서 시작 |
| `0x03`~`0x0D` | Reserved |  |
| `0x0E` | [BODY](/ko/grammar/meta/structure/body/) | 1 WORD. 문서의 HEAD를 끝내고 BODY를 시작한다. |
| `0x0F` | [END](/ko/grammar/meta/structure/end/) | 1 WORD. 문서를 닫는다. |

### 정의 (`001`)

| Codec | 이름 | 설명 |
|---|---|---|
| `0x10` | [SPEC-VERSION](/ko/grammar/meta/declaration/spec-version/) | 따르는 GEUL 명세 판. Payload가 곧 가장 짧은 폭의 unsigned 정수다. v1은 `0x0001` (레코드 `0x1890 0x0001`) |
| `0x11` | [PROFILE](/ko/grammar/meta/declaration/profile/) | 적용 프로파일 |
| `0x12` | [DOC-ID](/ko/grammar/meta/declaration/doc-id/) | 이 문서의 식별자. 내장 Reference `DOC-POINTER`(Issuer, 문서 ID, 버전 0) |
| `0x13` | [EFFECTIVE-FROM](/ko/grammar/meta/declaration/effective-from/) | 이 버전의 시행일. GREGORIAN-DATE 또는 POSIX-TIMESTAMP Value. 없으면 공표 시각 |
| `0x14` | [EFFECTIVE-UNTIL](/ko/grammar/meta/declaration/effective-until/) | 이 버전의 유효기간 끝(한시법). 없으면 다음 버전이 시행될 때까지 |
| `0x15` | Reserved |  |
| `0x16` | [DEFAULT-LANGUAGE](/ko/grammar/meta/declaration/default-language/) | 기본 언어 |
| `0x17`~`0x1F` | Reserved |  |

### 출처 (`010`)

| Codec | 이름 | 설명 |
|---|---|---|
| `0x20` | [AUTHOR](/ko/grammar/meta/provenance/author/) | 작성자. Reference (git author) |
| `0x21` | [CO-AUTHOR](/ko/grammar/meta/provenance/co-author/) | 공동 작성자. Reference (git `Co-authored-by`) |
| `0x22` | [CREATED-AT](/ko/grammar/meta/provenance/created-at/) | 작성 시각. TIME Value (git author date) |
| `0x23` | [MODIFIED-AT](/ko/grammar/meta/provenance/modified-at/) | 수정 시각. TIME Value |
| `0x24` | [RECORDED-BY](/ko/grammar/meta/provenance/recorded-by/) | 기록한 주체. Reference (git committer) |
| `0x25` | [RECORDED-AT](/ko/grammar/meta/provenance/recorded-at/) | 기록한 시각. TIME Value (git commit date) |
| `0x26`~`0x2F` | Reserved |  |

- 원천 자료와 그 범위·확보 시각·해시는 Meta가 아니라 HEAD의 근거 Edge [SOURCE](/ko/grammar/edge/source/#문서-전체의-출처)(Target `0`)와 그 QUALIFIER로 쓴다.

### 계보 (`011`)

| Codec | 이름 | 설명 |
|---|---|---|
| `0x30` | [PARENT](/ko/grammar/meta/lineage/parent/) | 직전 버전의 내용 해시 (git parent). 없으면 최초 버전이고, 여럿이면 병합이다(git merge commit). |
| `0x31` | [DERIVED-FROM](/ko/grammar/meta/lineage/derived-from/) | 다른 계보의 레코드·자료에서 파생. 외부 자료의 특정 버전에 고정할 때는 HEAD의 [SOURCE](/ko/grammar/edge/source/#문서-전체의-출처)에 원문 해시 QUALIFIER(P4092)를 붙인다(git submodule). |
| `0x32` | [GENERATED-BY](/ko/grammar/meta/lineage/generated-by/) | 생성 주체. 사람, 모델, 규칙 엔진 |
| `0x33` | [TRANSFORMED-BY](/ko/grammar/meta/lineage/transformed-by/) | 변환 방법. 도구·규칙·버전 |
| `0x34` | [CHERRY-PICKED-FROM](/ko/grammar/meta/lineage/cherry-picked-from/) | 다른 계보의 변경을 가져온 원 버전의 내용 해시 (git cherry-pick `-x`) |
| `0x35` | [REVERTS](/ko/grammar/meta/lineage/reverts/) | 변경을 되돌린 대상 버전의 내용 해시 (git revert) |
| `0x36` | [REPLACES](/ko/grammar/meta/lineage/replaces/) | 고쳐 쓴 대상 버전의 내용 해시 (git amend·rebase). 원 버전은 지우지 않는다. |
| `0x37` | [SQUASHED-FROM](/ko/grammar/meta/lineage/squashed-from/) | 하나로 합친 원 버전들의 내용 해시 (git squash) |
| `0x38` | [MESSAGE](/ko/grammar/meta/lineage/message/) | 변경 이유. UTF8-LANGUAGE-TEXT Value, 언어마다 하나 (git commit message) |
| `0x39` | [TAG](/ko/grammar/meta/lineage/tag/) | 버전에 붙인 불변 이름. TEXT Value와 내용 해시 (git annotated tag) |
| `0x3A` | [DELTA-BASE](/ko/grammar/meta/lineage/delta-base/) | 이 버전 파일은 같은 문서의 기준 버전(2 WORD 버전 ID)에 대한 diff다 (git packfile delta) |
| `0x3B` | [DELTA-REMOVE](/ko/grammar/meta/lineage/delta-remove/) | diff에서 기준 BODY에서 뺄 LOCAL ID(Edge Id) 목록 |
| `0x3C` | [NEXT-LOCAL-ID](/ko/grammar/meta/lineage/next-local-id/) | 다음에 배정할 LOCAL ID (auto increment). 버전 목록 `versions.geul`의 HEAD에 둔다 |
| `0x3D`~`0x3F` | Reserved |  |

### 검증 (`100`)

| Codec | 이름 | 설명 |
|---|---|---|
| `0x40` | [ISSUER-KEY](/ko/grammar/meta/verification/issuer-key/) | 자체 발급 Issuer의 서명 알고리즘 ID와 공개키 선언 |
| `0x41` | [SIGNATURE](/ko/grammar/meta/verification/signature/) | 대상에 대한 서명. 문서에 대한 서명은 내용 해시에 서명한다 (git 서명 커밋·태그) |
| `0x42` | [SIGNED-OFF](/ko/grammar/meta/verification/signed-off/) | 기여 권리 확인. Reference (git `Signed-off-by`, DCO) |
| `0x43` | [CONFIDENCE](/ko/grammar/meta/verification/confidence/) | 신뢰도 |
| `0x44` | [VERDICT](/ko/grammar/meta/verification/verdict/) | 문서 전체의 판정 결과. Pass, Review, Fail. 노드·레코드 단위는 [TOULMIN](/ko/grammar/edge/toulmin/) `VERDICT`(Edge `0x78`) |
| `0x45`~`0x4F` | Reserved |  |

### 정책 (`101`)

| Codec | 이름 | 설명 |
|---|---|---|
| `0x50` | [LICENSE](/ko/grammar/meta/policy/license/) | 라이선스. Reference |
| `0x51` | [ACCESS](/ko/grammar/meta/policy/access/) | 공개 범위 |
| `0x52` | [PRIVACY](/ko/grammar/meta/policy/privacy/) | 개인정보 등급 |
| `0x53` | [RETENTION](/ko/grammar/meta/policy/retention/) | 보존 기한 |
| `0x54` | [CONSENT](/ko/grammar/meta/policy/consent/) | 동의 범위와 근거 |
| `0x55` | [USAGE](/ko/grammar/meta/policy/usage/) | 사용 제한 |
| `0x56`~`0x5F` | Reserved |  |

### IMPORT (`110`)

| Codec | 이름 | 설명 |
|---|---|---|
| `0x60` | [IMPORT-DOC](/ko/grammar/meta/import/import-doc/) | 외부 문서를 IMPORT ID로 가져온다. 내장 Reference `DOC-POINTER` + IMPORT ID |
| `0x61`~`0x6F` | Reserved |  |
