---
title: "Edge"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "Edge는 Reference·Value·다른 Edge를 묶어 서술하는 레코드다. 첫 구성요소는 항상 Edge Id이고, Codec 상위 2비트가 계열(서술, 근거, 실행, TOULMIN)이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Edge는 다른 레코드를 구성요소로 묶어 서술하는 레코드다. "Q42는 사람이다", "Q42의 영어 이름은 Douglas Adams다" 같은 서술이 Edge 하나다.

## 레이아웃

```
TAG WORD          0001 0LLL LCCC CCCC
[Length 확장 TAG]
[Codec 확장 TAG]  Issuer 형식일 때
Edge Id           LOCAL Reference 레코드
구성요소          Codec이 정한 순서
```

- `LLLL`은 TAG WORD를 포함한 전체 WORD 수 − 1이다. 디코더는 Codec을 몰라도 Length만으로 다음 레코드로 건너뛴다.
- **첫 구성요소는 항상 Edge Id(LOCAL Reference)다.** LOCAL Reference(`0088` + ID, Quantifier `000`)이므로 코덱을 몰라도 Edge Id를 읽을 수 있다.
- 구성요소는 각자 자기 Length로 경계를 찾는다. 마지막 구성요소를 읽은 위치가 Edge의 끝과 정확히 맞아야 한다.
- 구성요소의 구성(Payload)은 각 Edge Codec 문서가 정한다.
- 하위 형식이 있는 Codec(WORLD, TIMELINE, SCENE)은 Codec별 TAG 1 WORD가 하위 형식을 지정한다.
- Edge 레코드 사이의 순서는 의미가 없다(Codec이 따로 정한 경우 제외. 예: [TOULMIN](/ko/grammar/edge/toulmin/) 문서).
- 다른 Edge는 Edge Id로 가리킨다. 이 문서의 Edge는 LOCAL로, 다른 문서의 Edge는 지시 Reference(`EXTERNAL-POINTER-*`, `EXTERNAL-ISSUER-*`)로 가리킨다.

## 계열

| 상위 2비트 | 계열 | 직접 코드 | 하는 일 |
|---|---|---|---|
| `00` | 서술 | `0x00`~`0x1F` | 세계와 사건에 관한 내용을 구성한다 |
| `01` | 근거 | `0x20`~`0x3F` | 개별 레코드가 어디서, 무엇에서, 얼마나 믿을 만하게 나왔는지 |
| `10` | 실행 | `0x40`~`0x5F` | 실행할 수 있는 프로그램 구조(AST) |
| `11` | [TOULMIN](/ko/grammar/edge/toulmin/) | `0x60`~`0x7B` | 논증 그래프: 주장·반박·예외, 공격 관계, 실행, 판정 결과 |

## 서술 Edge

| Codec | 이름 | 구성요소 |
|---|---|---|
| `0x00` | [REFERENCE-NODE](/ko/grammar/edge/reference-node/) | Subject(Reference)가 Object를 지시한다는 방향성 바인딩 |
| `0x01` | [SAME-NODE](/ko/grammar/edge/same-node/) | 두 Reference가 같은 대상을 지시한다 |
| `0x02` | [DIFFERENT-NODE](/ko/grammar/edge/different-node/) | 두 Reference가 다른 대상을 지시한다 |
| `0x03` | [BIND](/ko/grammar/edge/bind/) | Subject에 기계용 이름(UTF8-TEXT)을 묶는다 |
| `0x04` | [LABEL](/ko/grammar/edge/label/) | Subject의 언어별 이름(UTF8-LANGUAGE-TEXT) |
| `0x05` | [ALIAS](/ko/grammar/edge/alias/) | Subject의 다른 이름. 레이아웃은 LABEL과 같다 |
| `0x06` | [DESCRIPTION](/ko/grammar/edge/description/) | Subject의 언어별 설명. 레이아웃은 LABEL과 같다 |
| `0x08`/`0x09` | VERB-SHORT / VERB | 동사 서술 |
| `0x0A` | [TRIPLE](/ko/grammar/edge/triple/) | 명제 하나(Predicate, Subject, Object)와 rank |
| `0x0B` | [QUALIFIER](/ko/grammar/edge/qualifier/) | 다른 Edge의 명제를 한정하는 조건 하나 |
| `0x10`~`0x12` | WORLD / TIMELINE / SCENE | 세계관, 사건 순서, 장면 구조 |
| `0x18`~`0x1A` | [PUBLICATION](/ko/grammar/edge/publication/) / DEPRECATION / TOMBSTONE | 문서 버전의 공표·폐기 권고·삭제 ([공표 주소와 버전 목록](/ko/grammar/publishing/#버전-목록)) |
| `0x1B`~`0x1E` | [DECLARE](/ko/grammar/edge/declare/) / [FIELD](/ko/grammar/edge/field/) / [ENUM](/ko/grammar/edge/enum/) / [CODEC](/ko/grammar/edge/codec/) | Codec 규격을 쓰는 어휘 ([Codec 규격 문서](/ko/grammar/codec-spec/)) |

- `-SHORT`와 일반형은 짝수·홀수 짝으로 둔다(VERB-SHORT `0x08`/VERB `0x09`). LABEL은 언어를 Object(UTF8-LANGUAGE-TEXT) 안의 언어 레코드로 받으므로 `0x04` 하나만 쓴다.
- PUBLICATION·DEPRECATION·TOMBSTONE은 버전 목록 문서가 쓴다. 버전 목록을 코덱북 없이 읽어야 하므로 디코더에 내장한다([공표 주소와 버전 목록](/ko/grammar/publishing/#층)의 0층).
- DECLARE·FIELD·ENUM·CODEC은 Codec 규격을 쓰는 어휘다. 규격 문서를 코덱북 없이 읽어야 하므로 레이아웃을 디코더에 내장한다(0층). 그 어휘로 쓴 각 Codec 규격 문서는 일반 문서다.

### TRIPLE

자세히: [TRIPLE](/ko/grammar/edge/triple/)

```
TAG WORD          0001 0LLL L000 1010
[Length 확장 TAG]
Edge Id           LOCAL Reference
Predicate         Reference (위키데이터 속성 등)
Subject           Reference
Object            Reference 또는 Value
Rank              1 WORD
```

| Rank | 이름 | 뜻 |
|---|---|---|
| `0` | normal | 기본 |
| `1` | preferred | 현재 값, 가장 권위 있는 값 |
| `2` | deprecated | 틀렸거나 낡았다고 판정됐지만 기록으로 남긴 값 |

- Rank는 위키데이터 statement rank와 같다. rank를 따로 매기지 않는 출처는 `0`을 쓴다.
- **TRIPLE의 의미는 그 Edge Id를 가리키는 QUALIFIER를 모두 모은 것이다.** 읽는 쪽은 TRIPLE을 해석하기 전에 QUALIFIER를 모은다.

예: Q42 — P31(instance of) — Q5(사람), normal, Edge Id 2

```
148A  0088 0002  00A8 001F  00A0 002A  00A0 0005  0000
TAG   #2         P31        Q42        Q5         normal
```

### QUALIFIER

자세히: [QUALIFIER](/ko/grammar/edge/qualifier/)

```
TAG WORD          0001 0LLL L000 1011
[Length 확장 TAG]
Edge Id           LOCAL Reference
Property          Reference
Target            LOCAL Reference (한정하는 Edge의 Edge Id)
Value             Reference 또는 Value
```

- QUALIFIER는 명제의 일부다. 명제에 관한 별도의 주장이 아니라 명제가 참이 되는 조건(시작·종료 시점, 적용 범위 등)을 한정한다.
- 명제에 관한 별도의 주장(누가 주장했나 등)은 TRIPLE로 쓴다.
- Target은 같은 문서의 Edge다. 같은 Target의 QUALIFIER 순서는 문서 안 순서다.

예: Q42 — P69(educated at) — Q691283, 시작(P580) 1971

```
150A 0088 0003 00A8 0045 00A0 002A 0120 000A 8C53 0000   TRIPLE    #3 P69 Q42 Q691283 normal
148B 0088 0004 00A8 0244 0088 0003 0924 3139 3731        QUALIFIER #4 P580 #3 EDTF "1971"
```

### LABEL, ALIAS, DESCRIPTION

자세히: [LABEL](/ko/grammar/edge/label/), [ALIAS](/ko/grammar/edge/alias/), [DESCRIPTION](/ko/grammar/edge/description/)

```
TAG WORD          0001 0LLL L000 0100   (LABEL)
[Length 확장 TAG]
Edge Id           LOCAL Reference
Subject           Reference
Object            UTF8-LANGUAGE-TEXT
```

- 이름과 언어는 Object(UTF8-LANGUAGE-TEXT) 하나에 담는다.
- 같은 Subject·언어의 LABEL은 많아야 하나다. 다른 이름은 ALIAS로 쓴다.
- 언어 없는 기계용 이름은 BIND로 쓴다. LABEL은 언어가 있어야 한다.

### BIND

자세히: [BIND](/ko/grammar/edge/bind/)

- Subject에 기계가 맞추는 이름(UTF8-TEXT)을 묶는다. 언어가 없고 정규화하지 않는다. 바이트가 같아야 같은 이름이다.
- 이름의 범위는 BIND를 담은 문서다. 한 문서에서 같은 이름을 다른 Subject에 묶지 않는다.
- 다른 레코드는 이름이 아니라 LOCAL ID로 가리킨다. 이름은 바깥(호스트 함수, 주소 입력, 사람)과 맞추는 데 쓴다.

### SAME-NODE, DIFFERENT-NODE, REFERENCE-NODE

자세히: [SAME-NODE](/ko/grammar/edge/same-node/), [DIFFERENT-NODE](/ko/grammar/edge/different-node/), [REFERENCE-NODE](/ko/grammar/edge/reference-node/)

- SAME-NODE는 두 Reference가 같은 대상을 가리킨다는 동일성이다. 반사적·대칭적·추이적이다.
- DIFFERENT-NODE는 두 Reference가 다른 대상이라는 비동일성이다.
- REFERENCE-NODE는 Subject(Reference)가 무엇인지 Object로 정의하는 방향성 바인딩이다. 동일성 주장이 아니다. 예: LOCAL 노드가 가리키는 URI를 정의한다.

## 근거 Edge

BODY 안의 개별 레코드에 근거를 붙인다. 문서 전체의 근거는 [Meta](/ko/grammar/meta/)가 맡는다.

- 대상은 BODY 안의 Edge이고 Edge Id로 가리킨다. Reference·Value는 그것을 담은 Edge와 구성요소 위치로 가리킨다. 세부 배치는 각 Codec 문서가 정한다.
- Edge마다 근거 Edge를 붙이면 길어지므로 자주 쓰는 조합은 축약형 Edge를 둘 수 있다.
- 이름에는 `RECORD-` 접두어를 붙여 같은 뜻의 문서 단위 Meta(`SOURCE`, `CONFIDENCE` 등)와 구분한다.
- 레코드 단위의 판정 결과는 TOULMIN `VERDICT`가 맡는다.

| Codec | 이름 | 뜻 |
|---|---|---|
| `0x20` | RECORD-SOURCE-SPAN | 대상이 나온 원문 안의 범위 |
| `0x21` | RECORD-SOURCE | 대상의 원천 자료 |
| `0x22` | RECORD-DERIVED-FROM | 대상이 파생된 다른 레코드·자료 |
| `0x23` | RECORD-GENERATED-BY | 대상을 만든 주체(사람, 모델, 규칙 엔진) |
| `0x24` | RECORD-INTRODUCED-IN | 대상이 처음 들어온 버전의 내용 해시 |
| `0x25` | RECORD-CONFIDENCE | 대상의 신뢰도 |
| `0x26` | RECORD-EFFECTIVE | 대상의 시행 기간(조문별 시행일) |

## 실행 Edge

특정 프로그래밍 언어에 묶이지 않는 프로그램 구조다. 구성요소는 이 문서의 LOCAL ID로 가리킨다.

| 묶음 | Codec |
|---|---|
| 선언 | FUNCTION-DECLARE, TYPE-DECLARE |
| 식 | CONST, UNARY, BINARY, CALL, MEMBER, INDEX, CONSTRUCT, CONDITIONAL |
| 문 | BLOCK, ASSIGN, IF, SWITCH, WHILE, FOREACH, JUMP, RETURN |
| 오류 | RAISE, TRY |

- 외부 언어의 코드를 그대로 담는 형식이 아니다. 외부 언어의 코드는 Issuer 형식으로 둔다.
- 구성요소는 이 문서의 LOCAL ID(REF)로 가리킨다. 식 자리에는 식 Edge 또는 기호를 둔다. REF `0`은 없음이다.
- 식은 값을 내고, 문은 값을 내지 않는다. 식은 BLOCK의 문 자리에 둘 수 있다(값은 버린다).
- C식 `for`는 BLOCK(초기화, WHILE)으로, `else if`는 거짓 자리의 IF로 쓴다.
- 기호는 LOCAL ID이고, 이름은 BIND로 묶는다. 다른 레코드는 이름이 아니라 LOCAL ID로 기호를 가리킨다. 이름이 같아도 LOCAL ID가 다르면 다른 기호다.
- 기호가 무엇인지(변수, 매개변수, 함수, 타입)는 그 기호를 가리키는 레코드가 정한다. 문서 안에 정의가 없는 기호는 바깥(호스트)이 제공하며, CALL의 대상이면 호스트 함수다.

열린 문제: 연산자 코드, 타입 표현, 각 Codec의 Payload 레이아웃.

## TOULMIN Edge

자세히: [TOULMIN](/ko/grammar/edge/toulmin/)

툴민 논증 모델로 판정·실행 그래프를 쓴다. GEUL이 자기 규칙을 GEUL로 서술하고 스스로 고치기 위한 핵심 계열이다.

| 묶음 | Codec |
|---|---|
| 선언 | CASE-DECLARE(사안), [PREDICATE-DECLARE](/ko/grammar/edge/toulmin/expr/)(술어), SPEC-DECLARE(판단 기준), RULE-DECLARE(주장), COUNTER-DECLARE(반박), EXCEPT-DECLARE(예외) — [NODE](/ko/grammar/edge/toulmin/node/) |
| 관계 | ATTACKS(공격), SUPERSEDES(배제) — [LINK](/ko/grammar/edge/toulmin/link/), SUPERSEDE-CHAIN(우선순위 사슬, 레이아웃 미정) |
| 실행 | RUN, DO, DO-ONCE, UNDO, CHECKING — [LINK](/ko/grammar/edge/toulmin/link/), ENTRY, TRIGGER — [NODE](/ko/grammar/edge/toulmin/node/) |
| 결과 | VERDICT(판정 결과: Pass·Review·Fail), EVIDENCE(판정의 증거) — 레이아웃 미정 |

- 원문·구획·보조 노드와 관계는 GEUL Issuer의 ISSUER 형식(`0xC000`~`0xC029`)이다([SOURCE와 구획](/ko/grammar/edge/toulmin/source/)).
- 판정 결과는 판정 대상과 다른 문서에 둔다. 결과 문서가 대상 문서를 가져와 가리킨다. 그래서 판정해도 대상 문서의 내용 해시는 바뀌지 않는다.

## Issuer 형식 Edge

Issuer는 자기 Edge 형식을 정의해 쓸 수 있다(Codec `0x7C`~`0x7F`). 직접 코드 `0x7C`~`0x7F`는 TOULMIN 구간 안에 있지만 공통 ISSUER 코드이며, 계열은 형식 번호의 상위 2비트로 정한다.

| Issuer | 형식 번호 | 이름 | 계열 |
|---|---|---|---|
| `0x0000` GEUL | `0xC000`~`0xC005` | [SOURCE, TEXT, SECTION, CASE-BEGIN, CASE-END, PROSE](/ko/grammar/edge/toulmin/source/) | TOULMIN |
| `0x0000` GEUL | `0xC010`~`0xC014` | [NAMESPACE, FUNC, FIELD, ALIAS, GROUP](/ko/grammar/edge/toulmin/node/) | TOULMIN |
| `0x0000` GEUL | `0xC020`~`0xC029` | [REQUIRES … LABEL](/ko/grammar/edge/toulmin/link/) | TOULMIN |
