---
title: "GEUL 문법"
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "specification"]
summary: "GEUL v1 문법 명세. 16비트 워드 위의 레코드, 네 가지 Kind와 모든 Codec, 문서 구조, Issuer와 공표 규칙을 정의한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
showContent: true
---

GEUL v1 문법 명세다. 처음 읽는다면 아래 순서로 읽는다.

1. [개요](/ko/grammar/overview/) — GEUL이 무엇이고 어떤 원칙으로 설계했는가
2. [레코드와 TAG WORD](/ko/grammar/record/) — 16비트 TAG WORD, Kind, Codec, Length
3. [문서](/ko/grammar/document/) — HEAD와 BODY, 내용 해시, 버전과 개정
4. [Reference](/ko/grammar/reference/), [Value](/ko/grammar/value/), [Edge](/ko/grammar/edge/), [Meta](/ko/grammar/meta/) — 네 가지 Kind
5. [Issuer와 공표](/ko/grammar/issuer/) — 문서와 형식을 내는 주체, 2 WORD 배정표, 공개 방식, 서명과 검증키
6. [공표 주소와 버전 목록](/ko/grammar/publishing/) — ID 표기, 공표 주소, 형식 지정, Issuer·문서 목록, 버전 목록, 신뢰 층
7. [Codec 규격 문서](/ko/grammar/codec-spec/) — Codec 레이아웃을 GEUL 문서로 쓰는 법
8. [예시: 위키데이터 항목](/ko/grammar/example/) — 실제 문서 한 벌

이 페이지는 모든 Codec의 색인이다. 이름을 누르면 그 Codec의 상세 문서로 간다. 링크가 없는 이름은 아직 상세 문서가 없다. 표에 없는 직접 코드는 예약이다.

## Kind

TAG WORD는 `000K KKCC CCCC LLLL`다. `KKK`는 Kind, `CCCCCC`는 Codec, `LLLL`은 Length다. TAG ID는 `0x000L`로 쓴다. 앞 세 자리가 Kind와 Codec이고 `L`은 Length 자리다([레코드와 TAG WORD](/ko/grammar/record/)).

| KKK | TAG ID | 분류 | 설명 |
|---|---|---|---|
| `000` | `0x000L~0x03FL` | [Reference](/ko/grammar/reference/) | 대상을 가리키는 레코드 |
| `001` | `0x040L~0x07FL` | [Value](/ko/grammar/value/) | 값 레코드 |
| `010`~`110` | `0x080L~0x1BFL` | [Edge](/ko/grammar/edge/) | 구성 레코드 |
| `111` | `0x1C0L~0x1FFL` | [Meta](/ko/grammar/meta/) | 문서와 레코드에 관한 레코드 |

- Kind는 `(w >> 10) & 7` 하나로 판정한다. 예외는 없다.
- Reference, Value, Edge 구역의 끝 세 칸은 ISSUER다(`..DL` 2 WORD, `..EL` 4 WORD, `..FL` 16 WORD). Meta에는 ISSUER가 없다.

## Reference

`0x000L~0x03FL` — [Reference](/ko/grammar/reference/)

### Codec

| TAG ID | 이름 | 분류 | 대상 ID |
|---|---|---|---|
| `0x000L~0x002L` | [자리 표지](/ko/grammar/reference/slot-marker/) | 예약 | 대상을 가리키지 않는 1 WORD 표지 묶음(아래 표) |
| `0x003L` | [ISSUER-POINTER](/ko/grammar/reference/issuer-pointer/) | 지시선언 | Issuer 자신. Payload는 Issuer(2/4/16 WORD)뿐이며 대상 ID가 없다 |
| `0x004L` | [DOC-POINTER](/ko/grammar/reference/doc-pointer/) | 지시선언 | Issuer 문서의 한 버전. Issuer + 문서 ID 4 WORD + 버전 ID 2 WORD, 대상 ID가 없다 |
| `0x005L~0x009L` | [LOCAL](/ko/grammar/reference/local/) | 선언 | 이 문서가 발급한 ID |
| `0x00AL~0x00EL` | [GEUL](/ko/grammar/reference/geul/) | 선언 | geul.org가 CC0로 발급하는 엔티티. 작은 번호를 고빈도 엔티티에 배정한다 |
| `0x00FL~0x013L` | [GEUL-SIDX](/ko/grammar/reference/geul-sidx/) | 선언 | GEUL SIDX(Semantic-aligned Index). 비트에 의미를 담은 식별자 |
| `0x014L~0x018L` | [WIKIDATA-QID](/ko/grammar/reference/wikidata-qid/) | 선언 | 위키데이터 항목. `Q` 뒤의 정수 |
| `0x019L~0x01DL` | [WIKIDATA-PID](/ko/grammar/reference/wikidata-pid/) | 선언 | 위키데이터 속성. `P` 뒤의 정수 |
| `0x01EL~0x022L` | [EXTERNAL-POINTER-1WORD](/ko/grammar/reference/external-pointer/) | 지시 | `IMPORT-DOC`으로 가져온 문서의 LOCAL ID. IMPORT ID 1 WORD |
| `0x023L~0x027L` | [EXTERNAL-POINTER-2WORD](/ko/grammar/reference/external-pointer/) | 지시 | 위와 같음. IMPORT ID 2 WORD |
| `0x028L~0x02CL` | [EXTERNAL-POINTER-4WORD](/ko/grammar/reference/external-pointer/) | 지시 | 위와 같음. IMPORT ID 4 WORD |
| `0x02DL~0x031L` | [EXTERNAL-ISSUER-2WORD](/ko/grammar/reference/external-issuer/) | 지시선언 | 2 WORD Issuer 문서의 LOCAL ID |
| `0x032L~0x036L` | [EXTERNAL-ISSUER-4WORD](/ko/grammar/reference/external-issuer/) | 지시선언 | 4 WORD Issuer 문서의 LOCAL ID |
| `0x037L~0x03BL` | [EXTERNAL-ISSUER-16WORD](/ko/grammar/reference/external-issuer/) | 지시선언 | 16 WORD Issuer 문서의 LOCAL ID |
| `0x03CL` | [CODEC-POINTER](/ko/grammar/reference/codec-pointer/) | 지시선언 | Issuer 코덱의 한 버전. Issuer + 코덱 ID 2 WORD + 버전 ID 2 WORD, 대상 ID가 없다 |
| `0x03DL` | [REFERENCE-ISSUER-2WORD](/ko/grammar/reference/reference-issuer/) | Issuer 형식 | Issuer 2 WORD와 코덱 번호 2 WORD. 분류와 대상은 Issuer 문서가 정한다 |
| `0x03EL` | [REFERENCE-ISSUER-4WORD](/ko/grammar/reference/reference-issuer/) | Issuer 형식 | Issuer 4 WORD와 코덱 번호 2 WORD. 위와 같음 |
| `0x03FL` | [REFERENCE-ISSUER-16WORD](/ko/grammar/reference/reference-issuer/) | Issuer 형식 | Issuer 16 WORD와 코덱 번호 2 WORD. 위와 같음 |

- 5칸 묶음(LOCAL부터 EXTERNAL-ISSUER-16WORD까지)은 아래 Quantifier 순서로 한 칸씩이다. 예: WIKIDATA-QID Identified `0x014L`, Generic `0x015L`.

### 자리 표지 (`0x000L~0x002L`)

`0x0000`, `0x0010`, `0x0020` — [자리 표지](/ko/grammar/reference/slot-marker/). 필드의 CODEC 목록이 그 WORD를 정확히 둘 때만 그 자리에 온다.

| WORD | 이름 | 뜻 | 위키데이터 |
|---|---|---|---|
| `0x0000` | [ABSENT](/ko/grammar/reference/slot-marker/) | 적지 않음. 선택 필드를 생략했다. 세계에 관해 아무것도 단언하지 않는다 | snak 없음 |
| `0x0010` | [UNKNOWN-VALUE](/ko/grammar/reference/slot-marker/) | 알 수 없음. 값이 있지만 무엇인지 모른다 | `somevalue` |
| `0x0020` | [NO-VALUE](/ko/grammar/reference/slot-marker/) | 없음. 값이 없다 | `novalue` |

### Quantifier

| `C % 5` | 이름 | 의미 | 예시 |
|---|---|---|---|
| `0` | Identified | 식별된 개체 | 일론 머스크, 대한민국 |
| `1` | Generic | 종류 전체에 관한 일반적·정의적 진술. 예외를 허용한다. | 병사는 명령에 복종한다 |
| `2` | Free-choice | 조건을 만족하는 임의의 대상 | 아무 병사나 |
| `3` | Universal | 주어진 범위에 속하는 모든 대상 | 모든 병사 |
| `4` | Variable | 담화 변수 | 그 사람, 이 여자 |

- `5 <= C < 0x3C`이면 양화는 `C % 5`, 체계는 `C / 5`다. 표지(`C < 3`), 포인터(`C = 3, 4, 0x3C`), REFERENCE-ISSUER(`C >= 0x3D`)에는 쓰지 않는다.
- ISSUER-POINTER, DOC-POINTER, CODEC-POINTER는 양화가 없는 한 칸이다. REFERENCE-ISSUER의 양화는 Issuer가 발행한 Codec 문서가 정한다.

## Issuer

Issuer는 문서와 형식을 정의하는 주체다 — [Issuer와 공표](/ko/grammar/issuer/)

| 자리 | 뜻 |
|---|---|
| Reference·Value·Edge ISSUER 코드(각 구역 끝 세 칸) | 그 Issuer가 정의한 형식 |
| Meta `DOC-ID` | 이 문서를 낸 Issuer |
| Meta `IMPORT-DOC` | 가져온 문서를 낸 Issuer |
| Reference `EXTERNAL-ISSUER-*`·`DOC-POINTER`·`CODEC-POINTER` | 가리키는 문서·코덱을 낸 Issuer(2/4/16 WORD) |
| Reference `ISSUER-POINTER` | 가리키는 Issuer 자신(2/4/16 WORD) |

| Issuer 폭 | 발급 |
|---|---|
| 2 WORD | geul.org 등록. 도메인 소유 증명(예: company.com)을 거친 Issuer. geul.org가 표준 제정 단체와 주요 기관에 배정한 번호도 이 폭이다([2 WORD 배정표](/ko/grammar/issuer/#2-word-배정표)). |
| 4 WORD | geul.org 등록. 소유 증명 없이 등록한 Issuer |
| 16 WORD | 자체 발급. 등록 없이 공개키에서 계산한다. 아래 생성 규칙을 따른다. |

### 16 WORD Issuer 서명 알고리즘

| 서명 알고리즘 ID | 알고리즘 |
|---|---|
| `0x0001` | Ed25519 |
| 그 외 | 예약 |

## Edge

`0x080L~0x1BFL` — [Edge](/ko/grammar/edge/)

직접 코드의 계열은 `(코드 − 0x80) >> 5`다(코드는 TAG ID의 앞 세 자리). 계열은 아래 네 구간뿐이다. `0x100L~0x1BCL`은 빈칸이고 계열이 정의되지 않았다. Issuer 형식에는 계열 규칙이 없다.

| 계열 | 직접 코드 |
|---|---|
| 서술 | `0x080L~0x09FL` |
| 근거 | `0x0A0L~0x0BFL` |
| 실행 | `0x0C0L~0x0DFL` |
| [TOULMIN](/ko/grammar/edge/toulmin/) | `0x0E0L~0x0FBL` |

- `0x0FCL~0x0FFL`은 Reserved다.
- `0x1BDL~0x1BFL`은 EDGE-ISSUER다(아래 Edge ISSUER 형식).

### 서술 (`0x080L~0x09FL`)

| Codec | 이름 | 하위 형식 | 설명 |
|---|---|---|---|
| `0x080L` | [REFERENCE-NODE](/ko/grammar/edge/reference-node/) |  | Reference인 Subject가 Object를 지시하는 방향성 바인딩 |
| `0x081L` | [SAME-NODE](/ko/grammar/edge/same-node/) |  | 두 Reference가 동일한 대상을 지시하는 동일성 |
| `0x082L` | [DIFFERENT-NODE](/ko/grammar/edge/different-node/) |  | 두 Reference가 서로 다른 대상을 지시하는 비동일성 |
| `0x083L` | [BIND](/ko/grammar/edge/bind/) |  | Subject에 기계가 맞추는 이름(`UTF8-TEXT-*`)을 묶는다. 범위 안에서 유일하고 정확히 일치해야 하며 언어가 없다 |
| `0x084L` | [LABEL](/ko/grammar/edge/label/) |  | Subject의 언어 이름(label) 연결. Object는 UTF8-LANGUAGE-TEXT |
| `0x085L` | [ALIAS](/ko/grammar/edge/alias/) |  | Subject의 다른 이름(별칭) 연결. 레이아웃은 LABEL과 같다 |
| `0x086L` | [DESCRIPTION](/ko/grammar/edge/description/) |  | Subject의 언어 설명(description) 연결. 레이아웃은 LABEL과 같다 |
| `0x087L` | Reserved |  |  |
| `0x088L` | VERB-SHORT |  | 동사 서술 축약 |
| `0x089L` | VERB |  | 동사 서술 |
| `0x08AL` | [TRIPLE](/ko/grammar/edge/triple/) |  | Predicate, Subject, Object 순서의 명제와 rank. Object는 값 또는 UNKNOWN-VALUE·NO-VALUE 표지. 의미는 그 Edge Id를 가리키는 QUALIFIER를 모두 모은 것이다 |
| `0x08BL` | [QUALIFIER](/ko/grammar/edge/qualifier/) |  | 다른 Edge의 명제를 한정하는 조건 하나. Property, Target(Edge Id), Value(값 또는 UNKNOWN-VALUE·NO-VALUE 표지). 명제의 일부다 |
| `0x08CL~0x08FL` | Reserved |  |  |
| `0x090L` | WORLD | 있음 | 세계관 표현을 위한 구조 |
| `0x091L` | TIMELINE | 있음 | 세계와 사건의 순서를 표현하는 구조 |
| `0x092L` | SCENE | 있음 | 시나리오 특성의 서술을 위한 장면 구조 |
| `0x093L~0x097L` | Reserved |  |  |
| `0x098L` | [PUBLICATION](/ko/grammar/edge/publication/) |  | 문서 공표. DOC-POINTER, 내용 해시 |
| `0x099L` | DEPRECATION |  | 공표한 버전의 deprecate. DOC-POINTER |
| `0x09AL` | TOMBSTONE |  | 공표한 버전의 삭제(묘비). DOC-POINTER, 사유 범주 |
| `0x09BL` | [DECLARE](/ko/grammar/edge/declare/) |  | Codec 하나의 Payload 구성 선언. 대상 Kind·Codec |
| `0x09CL` | [FIELD](/ko/grammar/edge/field/) |  | Payload 필드 하나. 속한 DECLARE, 폭: 레코드(TAG의 Length) 또는 날값 n WORD |
| `0x09DL` | [ENUM](/ko/grammar/edge/enum/) |  | 날값 필드의 코드값 하나. 필드, 코드값 |
| `0x09EL` | [CODEC](/ko/grammar/edge/codec/) |  | 필드가 받는 Kind·Codec 하나. 필드, 대상 WORD(`000K KKCC CCCC LLLL`, LLLL 0000 정확·1111 와일드카드(Kind 전체), 자리 표지는 정확한 대상 `0000`·`0010`·`0020`로만). 레코드 필드는 여러 개(닫힌 목록), 날값 필드는 하나(TAG 없는 그 Value) |
| `0x09FL` | Reserved |  |  |

| TAG ID | 묶음 |
|---|---|
| `0x080L~0x087L` | 지시와 이름 |
| `0x088L~0x08FL` | 명제 |
| `0x090L~0x097L` | 구조 |
| `0x098L~0x09FL` | 기타 |

### 근거 (`0x0A0L~0x0BFL`)

| Codec | 이름 | 하위 형식 | 설명 |
|---|---|---|---|
| `0x0A0L` | [SOURCE](/ko/grammar/edge/source/) |  | 레코드 하나 또는 문서 전체를 그 원천에 잇는다. Target(BODY Edge Id, HEAD에서는 `0` = 문서 전체), Origin(Reference, ABSENT 또는 UNKNOWN-VALUE). 원천의 성질은 원천을 Subject로 하는 TRIPLE, 인용의 성질(조회일, 위치, 원문 해시)은 SOURCE에 붙는 QUALIFIER. 문서 전체의 SOURCE와 그 QUALIFIER는 HEAD에 둔다 |
| `0x0A1L~0x0BFL` | Reserved |  |  |

- 원문 범위, 만든 주체, 신뢰도, 조문별 시행 기간, 옛 레코드는 QUALIFIER로 쓰고, 처음 들어온 버전은 버전 이력에서 계산한다([SOURCE](/ko/grammar/edge/source/#다른-근거의-표현)).

### 실행 (`0x0C0L~0x0DFL`)

| Codec | 이름 | 설명 |
|---|---|---|
| `0x0C0L` | Reserved |  |
| `0x0C1L` | FUNCTION-DECLARE | 함수 선언. 기호, 매개변수 기호 목록, 반환 타입, 본문(BLOCK) |
| `0x0C2L` | TYPE-DECLARE | 타입 선언. 기호와 구성(필드 기호 목록, 열거값, 별칭 대상) |
| `0x0C3L~0x0C7L` | Reserved |  |
| `0x0C8L` | CONST | 상수식. 내장 Value 하나 |
| `0x0C9L` | UNARY | 단항식. 연산자 1 WORD, 피연산자 |
| `0x0CAL` | BINARY | 이항식. 연산자 1 WORD, 왼쪽, 오른쪽 |
| `0x0CBL` | CALL | 호출. 대상 함수, 인자 수, 인자 × 인자 수 |
| `0x0CCL` | MEMBER | 멤버 접근. 대상, 필드 기호 |
| `0x0CDL` | INDEX | 색인 접근. 대상, 색인 |
| `0x0CEL` | CONSTRUCT | 복합값 생성(목록, 레코드). 타입, 요소 수, 요소 × 요소 수 |
| `0x0CFL` | CONDITIONAL | 조건식. 조건, 참일 때 값, 거짓일 때 값 |
| `0x0D0L` | BLOCK | 순서 있는 문 묶음. 문 수, 문 × 문 수 |
| `0x0D1L` | ASSIGN | 대입. 대상(기호, MEMBER, INDEX), 값 |
| `0x0D2L` | IF | 조건 분기. 조건, 참 BLOCK, 거짓(BLOCK·IF, 없으면 0) |
| `0x0D3L` | SWITCH | 다중 분기. 대상, 갈래 수, (값, BLOCK) × 갈래 수, 기본 BLOCK(없으면 0) |
| `0x0D4L` | WHILE | 조건 반복. 조건, 본문 BLOCK |
| `0x0D5L` | FOREACH | 순회 반복. 요소 기호, 대상, 본문 BLOCK |
| `0x0D6L` | JUMP | 반복 제어. 종류 1 WORD(break, continue), 대상 반복 |
| `0x0D7L` | RETURN | 반환. 값(없으면 0) |
| `0x0D8L` | RAISE | 오류 발생. 오류 값 |
| `0x0D9L` | TRY | 오류 처리. 본문 BLOCK, 오류 기호, 처리 BLOCK, 마무리 BLOCK(없으면 0) |
| `0x0DAL~0x0DFL` | Reserved |  |

| TAG ID | 묶음 |
|---|---|
| `0x0C0L~0x0C7L` | 선언 |
| `0x0C8L~0x0CFL` | 식 |
| `0x0D0L~0x0D7L` | 문 |
| `0x0D8L~0x0DFL` | 오류 |

### TOULMIN (`0x0E0L~0x0FBL`)

자세히: [TOULMIN](/ko/grammar/edge/toulmin/)

| Codec | 이름 | 설명 |
|---|---|---|
| `0x0E0L` | [CASE-DECLARE](/ko/grammar/edge/toulmin/node/) | 사안 선언. 노드와 관계를 담는 판정 그래프 |
| `0x0E1L` | [PREDICATE-DECLARE](/ko/grammar/edge/toulmin/expr/) | 술어 선언. 판정 함수·식, 판단 기준(Spec), 사실 계약(Ground) |
| `0x0E2L` | [SPEC-DECLARE](/ko/grammar/edge/toulmin/node/) | 판단 기준 선언. 상수·목록 (Backing) |
| `0x0E3L` | [RULE-DECLARE](/ko/grammar/edge/toulmin/node/) | 주장 선언. 사안 안에서 술어를 일반 규칙(Warrant)으로 둔다. 공격받을 수 있다. |
| `0x0E4L` | [COUNTER-DECLARE](/ko/grammar/edge/toulmin/node/) | 반박 선언. 자기 결론을 가지고 공격한다. 기본 Level은 Fail |
| `0x0E5L` | [EXCEPT-DECLARE](/ko/grammar/edge/toulmin/node/) | 예외 선언. 자기 결론 없이 공격한다. 기본 Level은 Review |
| `0x0E6L~0x0E7L` | Reserved |  |
| `0x0E8L` | [ATTACKS](/ko/grammar/edge/toulmin/link/) | 공격 관계. 공격자의 판정이 대상의 판정을 점진적으로 깎는다. |
| `0x0E9L` | [SUPERSEDES](/ko/grammar/edge/toulmin/link/) | 배제 관계. 공격자가 Active이면 대상을 집계에서 결정적으로 뺀다. |
| `0x0EAL` | SUPERSEDE-CHAIN | 우선순위 사슬 `A > B > C`. 쌍별 SUPERSEDES의 축약. 레이아웃 미정 |
| `0x0EBL~0x0EFL` | Reserved |  |
| `0x0F0L` | [RUN](/ko/grammar/edge/toulmin/link/) | 실행 합성. 노드가 Active이면 하위 사안을 실행한다(DAG). |
| `0x0F1L` | [DO](/ko/grammar/edge/toulmin/link/) | 노드가 Active이면 수행하는 동작 |
| `0x0F2L` | [DO-ONCE](/ko/grammar/edge/toulmin/link/) | 재시도해도 한 번만 수행하는 동작 |
| `0x0F3L` | [UNDO](/ko/grammar/edge/toulmin/link/) | DO의 보상 동작(saga). 이후 단계가 실패하면 역순으로 수행한다. |
| `0x0F4L` | [CHECKING](/ko/grammar/edge/toulmin/link/) | 부작용 없이 판정만 하는 연결 |
| `0x0F5L` | [ENTRY](/ko/grammar/edge/toulmin/node/) | 외부 진입점. 사안을 실행하거나 판정한다 |
| `0x0F6L` | [TRIGGER](/ko/grammar/edge/toulmin/node/) | 외부 호출 없는 이벤트·주기 진입점 |
| `0x0F7L` | Reserved |  |
| `0x0F8L` | VERDICT | 노드·레코드의 판정 결과. 결과(Pass, Review, Fail), 판정값, Activated, Excluded, Level. 레이아웃 미정. 문서 전체의 판정은 Meta [VERDICT](/ko/grammar/meta/verification/verdict/)(`0x1E9L`) |
| `0x0F9L` | EVIDENCE | 판정의 증거. 위치, 기대값, 실제값 (Fact). 레이아웃 미정 |
| `0x0FAL~0x0FBL` | Reserved |  |
| `0x0FCL~0x0FFL` | Reserved |  |

| TAG ID | 묶음 |
|---|---|
| `0x0E0L~0x0E7L` | 선언 |
| `0x0E8L~0x0EFL` | 관계 |
| `0x0F0L~0x0F7L` | 실행 |
| `0x0F8L~0x0FFL` | 결과 (`0x0FCL~0x0FFL`은 Reserved) |

### Edge ISSUER 형식

`0x1BDL`~`0x1BFL`(EDGE-ISSUER-2/4/16WORD) 뒤 Codec 확장 TAG에 Issuer와 코덱 번호 2 WORD를 둔다. 코덱 번호 공간은 Value와 따로다.

| Issuer | 코덱 번호 | 이름 | 설명 |
|---|---|---|---|
| `0x00000000` GEUL | `0x0000C000` | [SOURCE](/ko/grammar/edge/toulmin/source/) | 저작 원문. SPAN 폭과 UTF8 Value |
| `0x00000000` GEUL | `0x0000C001` | [TEXT](/ko/grammar/edge/toulmin/source/) | 이름·문자열 |
| `0x00000000` GEUL | `0x0000C002` | [SECTION](/ko/grammar/edge/toulmin/source/) | 섹션 시작. 섹션 코드 |
| `0x00000000` GEUL | `0x0000C003` | [CASE-BEGIN](/ko/grammar/edge/toulmin/source/) | 사안 범위 시작 |
| `0x00000000` GEUL | `0x0000C004` | [CASE-END](/ko/grammar/edge/toulmin/source/) | 사안 범위 끝 |
| `0x00000000` GEUL | `0x0000C005` | [PROSE](/ko/grammar/edge/toulmin/source/) | 서술 문단(SPAN) |
| `0x00000000` GEUL | `0x0000C010` | [NAMESPACE](/ko/grammar/edge/toulmin/node/) | NODE. `this document is` |
| `0x00000000` GEUL | `0x0000C011` | [FUNC](/ko/grammar/edge/toulmin/node/) | NODE. 함수 참조 |
| `0x00000000` GEUL | `0x0000C012` | [FIELD](/ko/grammar/edge/toulmin/node/) | NODE. `is required` |
| `0x00000000` GEUL | `0x0000C013` | [ALIAS](/ko/grammar/edge/toulmin/node/) | NODE. `see … from` |
| `0x00000000` GEUL | `0x0000C014` | [GROUP](/ko/grammar/edge/toulmin/node/) | NODE. 순서 있는 실행 묶음 |
| `0x00000000` GEUL | `0x0000C020` | [REQUIRES](/ko/grammar/edge/toulmin/link/) | LINK. 사안 → 필드 |
| `0x00000000` GEUL | `0x0000C021` | [MEANS](/ko/grammar/edge/toulmin/link/) | LINK. 정의 항목 → 값·타입 |
| `0x00000000` GEUL | `0x0000C022` | [HAS](/ko/grammar/edge/toulmin/link/) | LINK. 정의 항목 → 필드 |
| `0x00000000` GEUL | `0x0000C023` | [RUNS](/ko/grammar/edge/toulmin/link/) | LINK. 진입점 → 사안, 실행 |
| `0x00000000` GEUL | `0x0000C024` | [EVALUATES](/ko/grammar/edge/toulmin/link/) | LINK. 진입점 → 사안, 판정 |
| `0x00000000` GEUL | `0x0000C025` | [TRIGGERS](/ko/grammar/edge/toulmin/link/) | LINK. 트리거 → 사안 |
| `0x00000000` GEUL | `0x0000C026` | [UNTIL](/ko/grammar/edge/toulmin/link/) | LINK. 트리거 → 사안(`every … until`) |
| `0x00000000` GEUL | `0x0000C027` | [SAME-AS](/ko/grammar/edge/toulmin/link/) | LINK. 노드 → 전역 식별자 |
| `0x00000000` GEUL | `0x0000C028` | [IMPORTED-FROM](/ko/grammar/edge/toulmin/link/) | LINK. 별칭 → 경로(TEXT) |
| `0x00000000` GEUL | `0x0000C029` | [LABEL](/ko/grammar/edge/toulmin/link/) | LINK. 노드 → TEXT, 이름 표기 |

## Value

`0x040L~0x07FL` — [Value](/ko/grammar/value/)

Value 번호는 계열을 뜻하지 않는다. 직접 코드는 `0x040L~0x05DL`에 빈칸 없이 둔다. `0x05EL~0x07CL`은 빈칸이고, `0x07DL~0x07FL`은 VALUE-ISSUER다. 계열 이름(NUMERIC, DECIMAL, TIME, TEXT, BINARY)은 주제 묶음이다. 짝수·홀수 쌍은 짝수 코드에서 시작한다.

| 계열 | 직접 코드 |
|---|---|
| [NUMERIC](/ko/grammar/value/numeric/) | `0x040L~0x047L` |
| [DECIMAL](/ko/grammar/value/decimal/) | `0x048L~0x049L` |
| [TIME](/ko/grammar/value/time/) | `0x04AL~0x051L` |
| [TEXT](/ko/grammar/value/text/) | `0x052L~0x05AL` |
| [BINARY](/ko/grammar/value/binary/) | `0x05BL~0x05DL` |

### 직접 코드

| Codec | 이름 | 계열 | 설명 |
|---|---|---|---|
| `0x040L` | [BOOL](/ko/grammar/value/numeric/bool/) | NUMERIC | 고정 1 WORD의 false 또는 true |
| `0x041L` | [SIGNED-INTEGER](/ko/grammar/value/numeric/signed-integer/) | NUMERIC | 최소 WORD 2의 보수 부호 있는 정수 |
| `0x042L` | [UNSIGNED-INTEGER](/ko/grammar/value/numeric/unsigned-integer/) | NUMERIC | 최소 WORD big-endian unsigned magnitude 정수 |
| `0x043L` | [BINARY-FLOAT](/ko/grammar/value/numeric/binary-float/) | NUMERIC | Payload 1/2/4/8 WORD의 IEEE 754 binary16/32/64/128 scalar |
| `0x044L` | [COORDINATE-EARTH](/ko/grammar/value/numeric/coordinate-earth/) | NUMERIC | 지구(WGS 84) 위도·경도 binary64, 불확도 binary32와 그 단위 Reference(ABSENT = 미상) |
| `0x045L` | [COORDINATE-GEO](/ko/grammar/value/numeric/coordinate-geo/) | NUMERIC | 천체 Reference와 위도·경도 binary64, 불확도 binary32와 그 단위 Reference |
| `0x046L` | [QUANTITY](/ko/grammar/value/numeric/quantity/) | NUMERIC | 수치 Value amount(정수·BINARY-FLOAT·10진수·분수), 단위 Reference, 하한·상한. 단위·경계는 생략 가능(ABSENT `0x0000`) |
| `0x047L` | [FRACTION](/ko/grammar/value/numeric/fraction/) | NUMERIC | 원문 표기를 보존하는 분수: 정수·10진수 분자, 부호 없는 정수·10진수 분모. 약분하지 않음 |
| `0x048L` | [SIGNED-DECIMAL](/ko/grammar/value/decimal/signed-decimal/) | DECIMAL | signed exponent `E`와 최소 WORD 2의 보수 coefficient `C`의 `C×10^E` |
| `0x049L` | [UNSIGNED-DECIMAL](/ko/grammar/value/decimal/unsigned-decimal/) | DECIMAL | signed exponent `E`와 최소 WORD unsigned coefficient `C`의 `C×10^E` |
| `0x04AL` | [GREGORIAN-DATE](/ko/grammar/value/time/gregorian-date/) | TIME | proleptic Gregorian `1970-01-01` 기준 signed 날짜 수 |
| `0x04BL` | [CIVIL-TIME-NANOSECONDS](/ko/grammar/value/time/civil-time-nanoseconds/) | TIME | 민사일 자정 후 unsigned nanosecond 계수 |
| `0x04CL` | [POSIX-TIMESTAMP-SECONDS](/ko/grammar/value/time/posix-timestamp-seconds/) | TIME | Unix/POSIX epoch부터의 signed 초 계수 |
| `0x04DL` | [DURATION-SECONDS](/ko/grammar/value/time/duration-seconds/) | TIME | epoch 없는 signed SI-second 경과 시간 |
| `0x04EL`/`0x04FL` | [EDTF](/ko/grammar/value/time/edtf/) | TIME | EDTF(ISO 8601-2) 날짜 문자열. 짝수·홀수 바이트. GREGORIAN-DATE로 쓸 수 있는 날짜는 쓰지 않는다 |
| `0x050L`/`0x051L` | [GEDCOM-DATE](/ko/grammar/value/time/gedcom-date/) | TIME | GEDCOM 7 날짜 값 문자열. 다른 달력(율리우스력 등)의 원본 표기 보존. 짝수·홀수 바이트 |
| `0x052L` | [UTF8-TEXT-EVEN](/ko/grammar/value/text/utf8-text/) | TEXT | 정규화를 암시하지 않는 valid UTF-8 바이트열. 짝수 바이트 |
| `0x053L` | [UTF8-TEXT-ODD](/ko/grammar/value/text/utf8-text/) | TEXT | 위와 같음. 홀수 바이트 |
| `0x054L` | [URI-EVEN](/ko/grammar/value/text/uri/) | TEXT | RFC 3986 `URI` production ASCII 바이트열. 짝수 바이트 |
| `0x055L` | [URI-ODD](/ko/grammar/value/text/uri/) | TEXT | 위와 같음. 홀수 바이트 |
| `0x056L` | [LANGUAGE-BCP47-CODE-EVEN](/ko/grammar/value/text/language-bcp47-code/) | TEXT | canonical casing의 완전한 BCP 47 language tag ASCII 바이트열. 짝수 바이트 |
| `0x057L` | [LANGUAGE-BCP47-CODE-ODD](/ko/grammar/value/text/language-bcp47-code/) | TEXT | 위와 같음. 홀수 바이트 |
| `0x058L`/`0x059L` | [UTF8-LANGUAGE-TEXT](/ko/grammar/value/text/utf8-language-text/) | TEXT | 언어가 붙은 텍스트. 언어 Value 레코드(LANGUAGE-SHORT-CODE 또는 LANGUAGE-BCP47-CODE)와 UTF-8 바이트. 텍스트 바이트의 짝수·홀수 |
| `0x05AL` | [LANGUAGE-SHORT-CODE](/ko/grammar/value/text/language-short-code/) | TEXT | GEUL Language Registry 번호로 쓴 BCP 47 tag(Payload 1 WORD) |
| `0x05BL` | [UUID](/ko/grammar/value/binary/uuid/) | BINARY | 고정 Payload 8 WORD의 RFC 9562 UUID 128bit |
| `0x05CL` | [SHA-256-DIGEST](/ko/grammar/value/binary/sha-256-digest/) | BINARY | 고정 Payload 16 WORD의 SHA-256 결과 |
| `0x05DL` | [SHA1-DIGEST](/ko/grammar/value/binary/sha1-digest/) | BINARY | 고정 Payload 10 WORD의 SHA-1 결과. git 객체 ID 같은 식별 용도로만 |
| `0x07DL`~`0x07FL` | VALUE-ISSUER-2/4/16WORD |  | Issuer가 정의한 형식. 아래 Value ISSUER 형식 참조 |

### Value ISSUER 형식

`0x07DL`~`0x07FL`(VALUE-ISSUER-2/4/16WORD) 뒤 Codec 확장 TAG에 Issuer와 코덱 번호 2 WORD를 둔다.

| Issuer | 코덱 번호 | 이름 | 설명 |
|---|---|---|---|
| `0x00000000` GEUL | `0x00004000` | [DURATION-NANOSECONDS](/ko/grammar/value/time/duration-nanoseconds/) | epoch 없는 signed nanosecond 경과 시간 |
| `0x00000000` GEUL | `0x0000C000` | [OPAQUE-BYTES-EVEN](/ko/grammar/value/binary/opaque-bytes/) | 의미·형식 불명의 바이트열. 짝수 바이트 |
| `0x00000000` GEUL | `0x0000C001` | [OPAQUE-BYTES-ODD](/ko/grammar/value/binary/opaque-bytes/) | 위와 같음. 홀수 바이트 |
| `0x00000000` GEUL | `0x0000C002` | [BIT-VECTOR](/ko/grammar/value/binary/bit-vector/) | bit-count 뒤에 MSB-first로 저장한 N bit |
| `0x00000002` ADHOC | `0x00000000` | BFLOAT16 | 고정 Payload 1 WORD의 BF16 interchange bits |
| `0x00000002` ADHOC | `0x00000500` | [DENSE-I16-VECTOR](/ko/grammar/value/vector/dense-i16-vector/) | 연속 big-endian int16 vector |
| `0x00000002` ADHOC | `0x00000501` | [DENSE-U16-VECTOR](/ko/grammar/value/vector/dense-u16-vector/) | 연속 big-endian uint16 vector |
| `0x00000002` ADHOC | `0x00000502` | [DENSE-I32-VECTOR](/ko/grammar/value/vector/dense-i32-vector/) | 연속 big-endian int32 vector |
| `0x00000002` ADHOC | `0x00000503` | [DENSE-U32-VECTOR](/ko/grammar/value/vector/dense-u32-vector/) | 연속 big-endian uint32 vector |
| `0x00000002` ADHOC | `0x00000504` | [DENSE-I64-VECTOR](/ko/grammar/value/vector/dense-i64-vector/) | 연속 big-endian int64 vector |
| `0x00000002` ADHOC | `0x00000505` | [DENSE-U64-VECTOR](/ko/grammar/value/vector/dense-u64-vector/) | 연속 big-endian uint64 vector |
| `0x00000002` ADHOC | `0x00000506` | [DENSE-BINARY16-VECTOR](/ko/grammar/value/vector/dense-binary16-vector/) | 연속 IEEE 754 binary16 vector |
| `0x00000002` ADHOC | `0x00000507` | [DENSE-BFLOAT16-VECTOR](/ko/grammar/value/vector/dense-bfloat16-vector/) | 연속 BF16 vector |
| `0x00000002` ADHOC | `0x00000508` | [DENSE-BINARY32-VECTOR](/ko/grammar/value/vector/dense-binary32-vector/) | 연속 IEEE 754 binary32 vector |
| `0x00000002` ADHOC | `0x00000509` | [DENSE-BINARY64-VECTOR](/ko/grammar/value/vector/dense-binary64-vector/) | 연속 IEEE 754 binary64 vector |
| `0x00000002` ADHOC | `0x0000050A` | [POINT2-BINARY64](/ko/grammar/value/vector/point2-binary64/) | `(x,y)` 순서의 IEEE binary64 2차원 vector |
| `0x00000002` ADHOC | `0x0000050B` | [POINT3-BINARY64](/ko/grammar/value/vector/point3-binary64/) | `(x,y,z)` 순서의 IEEE binary64 3차원 vector |
| `0x00000002` ADHOC | `0x0000050C` | [BBOX2-BINARY64](/ko/grammar/value/vector/bbox2-binary64/) | `(minX,minY,maxX,maxY)` 순서의 IEEE binary64 vector |
| `0x00000002` ADHOC | `0x00000600` | [DESCRIBED-DENSE-TENSOR](/ko/grammar/value/tensor/described-dense-tensor/) | element-format·rank·shape와 C-contiguous dense payload |
| `0x00000002` ADHOC | `0x00000601` | [DESCRIBED-PACKED-TENSOR](/ko/grammar/value/tensor/described-packed-tensor/) | packed-format·rank·shape와 octet 내 low-bit-first packed payload |
| `0x00000002` ADHOC | `0x00000700` | [COMPLEX64](/ko/grammar/value/etc/complex64/) | `(real, imag)` 순서의 binary32 두 개 |
| `0x00000002` ADHOC | `0x00000701` | [COMPLEX128](/ko/grammar/value/etc/complex128/) | `(real, imag)` 순서의 binary64 두 개 |
| `0x00000002` ADHOC | `0x00000702` | [RATIONAL-I64](/ko/grammar/value/etc/rational-i64/) | 정규화한 int64 numerator와 양의 int64 denominator |
| `0x00000002` ADHOC | `0x00000703` | [CLOSED-INTERVAL-BINARY64](/ko/grammar/value/etc/closed-interval-binary64/) | `lower ≤ upper`인 binary64 닫힌 구간 |
| `0x00000002` ADHOC | `0x00000704` | [QUATERNION-BINARY32](/ko/grammar/value/etc/quaternion-binary32/) | `(x,y,z,w)` 순서의 binary32 네 개 |
| `0x00000002` ADHOC | `0x0000C000` | [BLAKE3-256-DIGEST](/ko/grammar/value/binary/blake3-256-digest/) | 고정 Payload 16 WORD의 기본 BLAKE3 결과 |
| `0x00000007` IETF | `0x00008000` | [URI-RELATIVE-REF-EVEN](/ko/grammar/value/text/uri-relative-ref/) | RFC 3986 relative-ref ASCII 바이트열. 짝수 바이트 |
| `0x00000007` IETF | `0x00008001` | [URI-RELATIVE-REF-ODD](/ko/grammar/value/text/uri-relative-ref/) | 위와 같음. 홀수 바이트 |
| `0x00000007` IETF | `0x0000C000` | [CRC32C](/ko/grammar/value/binary/crc32c/) | 고정 Payload 2 WORD의 Castagnoli CRC-32C 결과 |
| `0x00000007` IETF | `0x0000C001` | [IPV4-ADDRESS](/ko/grammar/value/binary/ipv4-address/) | 고정 Payload 2 WORD의 IPv4 주소 32bit |
| `0x00000007` IETF | `0x0000C002` | [IPV6-ADDRESS](/ko/grammar/value/binary/ipv6-address/) | 고정 Payload 8 WORD의 IPv6 주소 128bit |
| `0x0000000D` IEEE | `0x00002000` | [IEEE-DECIMAL32-DPD](/ko/grammar/value/decimal/ieee-decimal32-dpd/) | 고정 Payload 2 WORD의 IEEE 754 decimal32 DPD |
| `0x0000000D` IEEE | `0x00002001` | [IEEE-DECIMAL64-DPD](/ko/grammar/value/decimal/ieee-decimal64-dpd/) | 고정 Payload 4 WORD의 IEEE 754 decimal64 DPD |
| `0x0000000D` IEEE | `0x00002002` | [IEEE-DECIMAL128-DPD](/ko/grammar/value/decimal/ieee-decimal128-dpd/) | 고정 Payload 8 WORD의 IEEE 754 decimal128 DPD |
| `0x0000000D` IEEE | `0x00002003` | [IEEE-DECIMAL32-BID](/ko/grammar/value/decimal/ieee-decimal32-bid/) | 고정 Payload 2 WORD의 IEEE 754 decimal32 BID |
| `0x0000000D` IEEE | `0x00002004` | [IEEE-DECIMAL64-BID](/ko/grammar/value/decimal/ieee-decimal64-bid/) | 고정 Payload 4 WORD의 IEEE 754 decimal64 BID |
| `0x0000000D` IEEE | `0x00002005` | [IEEE-DECIMAL128-BID](/ko/grammar/value/decimal/ieee-decimal128-bid/) | 고정 Payload 8 WORD의 IEEE 754 decimal128 BID |
| `0x0000000D` IEEE | `0x00004000` | [POSIX-TIMESTAMP-NANOSECONDS](/ko/grammar/value/time/posix-timestamp-nanoseconds/) | Unix/POSIX epoch부터의 signed nanosecond 계수 |
| `0x0000000D` IEEE | `0x0000C000` | [MAC-48-ADDRESS](/ko/grammar/value/binary/mac-48-address/) | 고정 Payload 3 WORD의 IEEE 802 MAC 주소 48bit |
| `0x0000000E` KHRONOS | `0x00000000` | [RGBA8-UNORM](/ko/grammar/value/vector/rgba8-unorm/) | R, G, B, A 순서의 고정 4×UNORM8 packed vector |
| `0x0000000E` KHRONOS | `0x00000001` | [BGRA8-UNORM](/ko/grammar/value/vector/bgra8-unorm/) | B, G, R, A 순서의 고정 4×UNORM8 packed vector |
| `0x00000010` ONNX | `0x00000000` | FP8-E4M3FN | Payload 상위 octet의 ONNX E4M3FN scalar |
| `0x00000010` ONNX | `0x00000001` | FP8-E4M3FNUZ | Payload 상위 octet의 ONNX E4M3FNUZ scalar |
| `0x00000010` ONNX | `0x00000002` | FP8-E5M2 | Payload 상위 octet의 ONNX E5M2 scalar |
| `0x00000010` ONNX | `0x00000003` | FP8-E5M2FNUZ | Payload 상위 octet의 ONNX E5M2FNUZ scalar |
| `0x00000011` OCP | `0x00000000` | FP8-E8M0FNU | Payload 상위 octet의 unsigned exponent-only E8M0FNU scalar |
| `0x00000011` OCP | `0x00000001` | FP4-E2M1FN | Payload 상위 nibble의 ONNX/DLPack E2M1FN scalar |
| `0x00000013` BIPM | `0x00004000` | [TAI-TIMESTAMP-SECONDS](/ko/grammar/value/time/tai-timestamp-seconds/) | `1970-01-01T00:00:00 TAI`부터의 signed SI-second 계수 |
| `0x00000013` BIPM | `0x00004001` | [TAI-TIMESTAMP-NANOSECONDS](/ko/grammar/value/time/tai-timestamp-nanoseconds/) | 같은 TAI epoch부터의 signed nanosecond 계수 |
| `0x00000015` NIST | `0x0000C000` | [SHA-512-DIGEST](/ko/grammar/value/binary/sha-512-digest/) | 고정 Payload 32 WORD의 SHA-512 결과 |
| `0x00000015` NIST | `0x0000C001` | [SHA3-256-DIGEST](/ko/grammar/value/binary/sha3-256-digest/) | 고정 Payload 16 WORD의 SHA3-256 결과 |
| `0x00000016` GPS | `0x00004000` | [GPS-TIMESTAMP-SECONDS](/ko/grammar/value/time/gps-timestamp-seconds/) | GPS epoch부터의 signed second 계수 |
| `0x00000016` GPS | `0x00004001` | [GPS-TIMESTAMP-NANOSECONDS](/ko/grammar/value/time/gps-timestamp-nanoseconds/) | GPS epoch부터의 signed nanosecond 계수 |

## Meta

`0x1C0L~0x1FFL` — [Meta](/ko/grammar/meta/)

Meta 번호는 비트로 클래스를 나타내지 않는다. 클래스는 아래 구간 표로 안다. 검증 클래스는 Kind가 Meta이고 `C >= 0x25`인 레코드로, 코덱북 없이 안다. Meta에는 ISSUER 코드가 없다.

| 클래스 | 직접 코드 | 다루는 것 |
|---|---|---|
| [구조](/ko/grammar/meta/structure/) | `0x1C0L~0x1C4L` | 문서의 경계와 길이 |
| [정의](/ko/grammar/meta/declaration/) | `0x1C5L~0x1CAL` | 해석 선언 |
| [출처](/ko/grammar/meta/provenance/) | `0x1CBL~0x1D0L` | 누가, 언제, 어디서 |
| [계보](/ko/grammar/meta/lineage/) | `0x1D1L~0x1DDL` | 무엇에서 어떻게 나왔는가 |
| [정책](/ko/grammar/meta/policy/) | `0x1DEL~0x1E3L` | 어떻게 취급하는가 |
| [IMPORT](/ko/grammar/meta/import/) | `0x1E4L` | 외부 문서를 IMPORT ID로 가져온다 (`IMPORT-DOC`) |
| [검증](/ko/grammar/meta/verification/) | `0x1E5L~0x1E9L` | 믿을 수 있는가 |
| 빈칸(검증 전용) | `0x1EAL~0x1FFL` |  |

- 번호는 `0x1C0L`부터 빈칸 없이 이어진다. 검증 밖의 새 Meta는 검증 앞에 넣을 수 없다. 뒤 빈칸 `0x1EAL~0x1FFL`은 검증 전용이다. 검증 밖의 Meta를 여기에 두면 내용 해시에서 빠진다.

### 구조 (`0x1C0L~0x1C4L`)

| Codec | 이름 | 설명 |
|---|---|---|
| `0x1C0L` | [DOC-1WORD](/ko/grammar/meta/structure/doc/) | 전체 길이를 Payload 1 WORD에 지정한 문서 시작 |
| `0x1C1L` | [DOC-2WORD](/ko/grammar/meta/structure/doc/) | 전체 길이를 Payload 2 WORD에 지정한 문서 시작 |
| `0x1C2L` | [DOC-4WORD](/ko/grammar/meta/structure/doc/) | 전체 길이를 Payload 4 WORD에 지정한 문서 시작 |
| `0x1C3L` | [BODY](/ko/grammar/meta/structure/body/) | 1 WORD. 문서의 HEAD를 끝내고 BODY를 시작한다. |
| `0x1C4L` | [END](/ko/grammar/meta/structure/end/) | 1 WORD. 문서를 닫는다. |

### 정의 (`0x1C5L~0x1CAL`)

| Codec | 이름 | 설명 |
|---|---|---|
| `0x1C5L` | [SPEC-VERSION](/ko/grammar/meta/declaration/spec-version/) | 따르는 GEUL 명세 판. Payload가 곧 가장 짧은 폭의 unsigned 정수다. v1은 `0x0001` (레코드 `0x1C51 0x0001`) |
| `0x1C6L` | [PROFILE](/ko/grammar/meta/declaration/profile/) | 적용 프로파일 |
| `0x1C7L` | [DOC-ID](/ko/grammar/meta/declaration/doc-id/) | 이 문서의 식별자. 내장 Reference `DOC-POINTER`(Issuer, 문서 ID, 버전 0). 코덱 문서는 `CODEC-POINTER`(Issuer, 코덱 ID, 버전 0) |
| `0x1C8L` | [EFFECTIVE-FROM](/ko/grammar/meta/declaration/effective-from/) | 이 버전의 시행일. GREGORIAN-DATE 또는 POSIX-TIMESTAMP Value. 없으면 공표 시각 |
| `0x1C9L` | [EFFECTIVE-UNTIL](/ko/grammar/meta/declaration/effective-until/) | 이 버전의 유효기간 끝(한시법). 없으면 다음 버전이 시행될 때까지 |
| `0x1CAL` | [DEFAULT-LANGUAGE](/ko/grammar/meta/declaration/default-language/) | 기본 언어 |

### 출처 (`0x1CBL~0x1D0L`)

| Codec | 이름 | 설명 |
|---|---|---|
| `0x1CBL` | [AUTHOR](/ko/grammar/meta/provenance/author/) | 작성자. Reference (git author) |
| `0x1CCL` | [CO-AUTHOR](/ko/grammar/meta/provenance/co-author/) | 공동 작성자. Reference (git `Co-authored-by`) |
| `0x1CDL` | [CREATED-AT](/ko/grammar/meta/provenance/created-at/) | 작성 시각. TIME Value (git author date) |
| `0x1CEL` | [MODIFIED-AT](/ko/grammar/meta/provenance/modified-at/) | 수정 시각. TIME Value |
| `0x1CFL` | [RECORDED-BY](/ko/grammar/meta/provenance/recorded-by/) | 기록한 주체. Reference (git committer) |
| `0x1D0L` | [RECORDED-AT](/ko/grammar/meta/provenance/recorded-at/) | 기록한 시각. TIME Value (git commit date) |

- 원천 자료와 그 범위·확보 시각·해시는 Meta가 아니라 HEAD의 근거 Edge [SOURCE](/ko/grammar/edge/source/#문서-전체의-출처)(Target `0`)와 그 QUALIFIER로 쓴다.

### 계보 (`0x1D1L~0x1DDL`)

| Codec | 이름 | 설명 |
|---|---|---|
| `0x1D1L` | [PARENT](/ko/grammar/meta/lineage/parent/) | 직전 버전의 내용 해시 (git parent). 없으면 최초 버전이고, 여럿이면 병합이다(git merge commit). |
| `0x1D2L` | [DERIVED-FROM](/ko/grammar/meta/lineage/derived-from/) | 다른 계보의 레코드·자료에서 파생. 외부 자료의 특정 버전에 고정할 때는 HEAD의 [SOURCE](/ko/grammar/edge/source/#문서-전체의-출처)에 원문 해시 QUALIFIER(P4092)를 붙인다(git submodule). |
| `0x1D3L` | [GENERATED-BY](/ko/grammar/meta/lineage/generated-by/) | 생성 주체. 사람, 모델, 규칙 엔진 |
| `0x1D4L` | [TRANSFORMED-BY](/ko/grammar/meta/lineage/transformed-by/) | 변환 방법. 도구·규칙·버전 |
| `0x1D5L` | [CHERRY-PICKED-FROM](/ko/grammar/meta/lineage/cherry-picked-from/) | 다른 계보의 변경을 가져온 원 버전의 내용 해시 (git cherry-pick `-x`) |
| `0x1D6L` | [REVERTS](/ko/grammar/meta/lineage/reverts/) | 변경을 되돌린 대상 버전의 내용 해시 (git revert) |
| `0x1D7L` | [REPLACES](/ko/grammar/meta/lineage/replaces/) | 고쳐 쓴 대상 버전의 내용 해시 (git amend·rebase). 원 버전은 지우지 않는다. |
| `0x1D8L` | [SQUASHED-FROM](/ko/grammar/meta/lineage/squashed-from/) | 하나로 합친 원 버전들의 내용 해시 (git squash) |
| `0x1D9L` | [MESSAGE](/ko/grammar/meta/lineage/message/) | 변경 이유. UTF8-LANGUAGE-TEXT Value, 언어마다 하나 (git commit message) |
| `0x1DAL` | [TAG](/ko/grammar/meta/lineage/tag/) | 버전에 붙인 불변 이름. TEXT Value와 내용 해시 (git annotated tag) |
| `0x1DBL` | [DELTA-BASE](/ko/grammar/meta/lineage/delta-base/) | 이 버전 파일은 같은 문서의 기준 버전(2 WORD 버전 ID)에 대한 diff다 (git packfile delta) |
| `0x1DCL` | [DELTA-REMOVE](/ko/grammar/meta/lineage/delta-remove/) | diff에서 기준 BODY에서 뺄 LOCAL ID(Edge Id) 목록 |
| `0x1DDL` | [NEXT-LOCAL-ID](/ko/grammar/meta/lineage/next-local-id/) | 다음에 배정할 LOCAL ID (auto increment). 버전 목록 `versions.geul`의 HEAD에 둔다 |

### 정책 (`0x1DEL~0x1E3L`)

| Codec | 이름 | 설명 |
|---|---|---|
| `0x1DEL` | [LICENSE](/ko/grammar/meta/policy/license/) | 라이선스. Reference |
| `0x1DFL` | [ACCESS](/ko/grammar/meta/policy/access/) | 공개 범위 |
| `0x1E0L` | [PRIVACY](/ko/grammar/meta/policy/privacy/) | 개인정보 등급 |
| `0x1E1L` | [RETENTION](/ko/grammar/meta/policy/retention/) | 보존 기한 |
| `0x1E2L` | [CONSENT](/ko/grammar/meta/policy/consent/) | 동의 범위와 근거 |
| `0x1E3L` | [USAGE](/ko/grammar/meta/policy/usage/) | 사용 제한 |

### IMPORT (`0x1E4L`)

| Codec | 이름 | 설명 |
|---|---|---|
| `0x1E4L` | [IMPORT-DOC](/ko/grammar/meta/import/import-doc/) | 외부 문서를 IMPORT ID로 가져온다. 내장 Reference `DOC-POINTER`(코덱 문서는 `CODEC-POINTER`) + IMPORT ID |

### 검증 (`0x1E5L~0x1E9L`)

| Codec | 이름 | 설명 |
|---|---|---|
| `0x1E5L` | [ISSUER-KEY](/ko/grammar/meta/verification/issuer-key/) | 자체 발급 Issuer의 서명 알고리즘 ID와 공개키 선언 |
| `0x1E6L` | [SIGNATURE](/ko/grammar/meta/verification/signature/) | 대상에 대한 서명. 문서에 대한 서명은 내용 해시에 서명한다 (git 서명 커밋·태그) |
| `0x1E7L` | [SIGNED-OFF](/ko/grammar/meta/verification/signed-off/) | 기여 권리 확인. Reference (git `Signed-off-by`, DCO) |
| `0x1E8L` | [CONFIDENCE](/ko/grammar/meta/verification/confidence/) | 신뢰도 |
| `0x1E9L` | [VERDICT](/ko/grammar/meta/verification/verdict/) | 문서 전체의 판정 결과. Pass, Review, Fail. 노드·레코드 단위는 [TOULMIN](/ko/grammar/edge/toulmin/) `VERDICT`(Edge `0x0F8L`) |
