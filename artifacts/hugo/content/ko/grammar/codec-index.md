---
title: "코드 색인"
weight: 60
date: 2026-11-05T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar"]
summary: "이 페이지는 모든 Codec의 색인이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

이 페이지는 모든 Codec의 색인이다. 이름을 누르면 그 Codec의 상세 문서로 간다. 표에 없는 직접 코드는 Reserved다.

## Kind

TAG WORD는 `000K KKKC CCCC LLLL`다. 상위 4비트 `KKKK`는 섹션, `C`는 섹션 안 5비트 오프셋, `LLLL`은 Length다. 섹션과 `C`를 합친 9비트가 Codec 자리다. TAG ID는 `0x000L`로 쓴다. 앞 세 자리가 이 9비트(`w >> 4`)이고 `L`은 Length 자리다([레코드와 TAG WORD](record.md)).

| 섹션 | TAG ID | 분류 | 설명 |
|---|---|---|---|
| 0~2 | `0x000L~0x05FL` | [Reference](reference/_index.md) | 대상을 가리키는 레코드 |
| 3·4 | `0x060L~0x09FL` | [Value](value/_index.md) | 값 레코드 |
| 5~13 | `0x0A0L~0x1BFL` | [Edge](edge/_index.md) | 구성 레코드 |
| 14·15 | `0x1C0L~0x1FFL` | [Meta](meta/_index.md) | 문서와 레코드에 관한 레코드 |

- 섹션은 `S = w >> 9`(4비트)이고 한 섹션은 32칸이다.
- Kind는 섹션 구간 하나로 판정한다: `w < 0x0600` Reference, `w < 0x0A00` Value, `w < 0x1C00` Edge, 나머지 Meta. 예외는 없다.
- Reference, Value, Edge 구역의 끝 세 칸은 ISSUER다(`..DL` 2 WORD, `..EL` 4 WORD, `..FL` 16 WORD). Meta에는 ISSUER가 없다.

## Reference

`0x000L~0x05FL` — [Reference](reference/_index.md)

### Codec

| TAG ID | 이름 | 분류 | 대상 ID |
|---|---|---|---|
| `0x000L~0x002L` | [자리 표지](slot-marker.md) | 자리 표지 | 대상을 가리키지 않는 1 WORD 표지 묶음(아래 표) |
| `0x005L~0x009L` | [LOCAL](reference/0x005L-local.md) | 선언 | 이 문서가 발급한 ID |
| `0x00AL~0x00EL` | [GEUL](reference/0x00AL-geul.md) | 선언 | geul.org가 CC0로 발급하는 엔티티. 작은 번호를 고빈도 엔티티에 배정한다 |
| `0x00FL~0x013L` | [GEUL-SIDX](reference/0x00FL-geul-sidx.md) | 선언 | GEUL SIDX(Semantic-aligned Index). 비트에 의미를 담은 식별자 |
| `0x014L~0x018L` | [WIKIDATA-QID](reference/0x014L-wikidata-qid.md) | 선언 | 위키데이터 항목. `Q` 뒤의 정수 |
| `0x019L~0x01DL` | [WIKIDATA-PID](reference/0x019L-wikidata-pid.md) | 선언 | 위키데이터 속성. `P` 뒤의 정수 |
| `0x020L~0x024L` | [EXTERNAL-POINTER-1WORD](reference/0x020L-external-pointer-1word.md) | 지시 | `IMPORT-DOC`으로 가져온 문서의 LOCAL ID. IMPORT ID 1 WORD |
| `0x025L~0x029L` | [EXTERNAL-POINTER-2WORD](reference/0x025L-external-pointer-2word.md) | 지시 | 위와 같음. IMPORT ID 2 WORD |
| `0x02AL~0x02EL` | [EXTERNAL-POINTER-4WORD](reference/0x02AL-external-pointer-4word.md) | 지시 | 위와 같음. IMPORT ID 4 WORD |
| `0x02FL~0x033L` | [EXTERNAL-ISSUER-2WORD](reference/0x02FL-external-issuer-2word.md) | 지시선언 | 2 WORD Issuer 문서의 LOCAL ID |
| `0x034L~0x038L` | [EXTERNAL-ISSUER-4WORD](reference/0x034L-external-issuer-4word.md) | 지시선언 | 4 WORD Issuer 문서의 LOCAL ID |
| `0x039L~0x03DL` | [EXTERNAL-ISSUER-16WORD](reference/0x039L-external-issuer-16word.md) | 지시선언 | 16 WORD Issuer 문서의 LOCAL ID |
| `0x040L` | [ISSUER-POINTER](reference/0x040L-issuer-pointer.md) | 지시선언 | Issuer 자신. Payload는 Issuer(2/4/16 WORD)뿐이며 대상 ID가 없다 |
| `0x041L` | [DOC-POINTER](reference/0x041L-doc-pointer.md) | 지시선언 | Issuer 문서의 한 버전. Issuer + 문서 ID 4 WORD + 버전 ID 2 WORD, 대상 ID가 없다 |
| `0x042L` | [CODEC-POINTER](reference/0x042L-codec-pointer.md) | 지시선언 | Issuer 코덱의 한 버전. Issuer + 코덱 ID 2 WORD + 버전 ID 2 WORD, 대상 ID가 없다 |
| `0x05DL` | [REFERENCE-ISSUER-2WORD](reference/0x05DL-reference-issuer-2word.md) | Issuer 형식 | Issuer 2 WORD와 코덱 번호 2 WORD. 분류와 대상은 Issuer 문서가 정한다 |
| `0x05EL` | [REFERENCE-ISSUER-4WORD](reference/0x05EL-reference-issuer-4word.md) | Issuer 형식 | Issuer 4 WORD와 코덱 번호 2 WORD. 위와 같음 |
| `0x05FL` | [REFERENCE-ISSUER-16WORD](reference/0x05FL-reference-issuer-16word.md) | Issuer 형식 | Issuer 16 WORD와 코덱 번호 2 WORD. 위와 같음 |

- Reference는 섹션 세 개다. 섹션 0 엔티티 `0x000L~0x01FL`(자리 표지, 5Q 체계), 섹션 1 EXTERNAL `0x020L~0x03FL`, 섹션 2 기타 `0x040L~0x05FL`(포인터, REFERENCE-ISSUER). Reserved는 `0x003L~0x004L`, `0x01EL~0x01FL`, `0x03EL~0x03FL`, `0x043L~0x05CL`이다.
- 5칸 묶음(LOCAL부터 EXTERNAL-ISSUER-16WORD까지)은 아래 Quantifier 순서로 한 칸씩이다. 예: WIKIDATA-QID Identified `0x014L`, Generic `0x015L`.

### 자리 표지 (`0x000L~0x002L`)

`0x0000`, `0x0010`, `0x0020` — [자리 표지](slot-marker.md). 필드의 CODEC 목록이 그 WORD를 정확히 둘 때만 그 자리에 온다.

| WORD | 이름 | 뜻 | 위키데이터 |
|---|---|---|---|
| `0x0000` | [ABSENT](reference/0x000L-absent.md) | 적지 않음. 선택 필드를 생략했다. 세계에 관해 아무것도 단언하지 않는다 | snak 없음 |
| `0x0010` | [UNKNOWN-VALUE](reference/0x001L-unknown-value.md) | 알 수 없음. 값이 있지만 무엇인지 모른다 | `somevalue` |
| `0x0020` | [NO-VALUE](reference/0x002L-no-value.md) | 없음. 값이 없다 | `novalue` |

### Quantifier

| `C % 5` | 이름 | 의미 | 예시 |
|---|---|---|---|
| `0` | Identified | 식별된 개체 | 일론 머스크, 대한민국 |
| `1` | Generic | 종류 전체에 관한 일반적·정의적 진술. 예외를 허용한다. | 병사는 명령에 복종한다 |
| `2` | Free-choice | 조건을 만족하는 임의의 대상 | 아무 병사나 |
| `3` | Universal | 주어진 범위에 속하는 모든 대상 | 모든 병사 |
| `4` | Variable | 담화 변수 | 그 사람, 이 여자 |

- 양화는 섹션 안 오프셋 `C`로 읽는다. 섹션 0에서 `5 <= C < 30`이면 양화는 `C % 5`, 체계는 `C / 5`(1~5)다. 섹션 1에서 `C < 30`이면 양화는 `C % 5`, 체계는 `6 + C / 5`(6~11)다. 표지(섹션 0, `C < 3`)와 섹션 2(포인터, REFERENCE-ISSUER)에는 쓰지 않는다.
- ISSUER-POINTER, DOC-POINTER, CODEC-POINTER는 양화가 없는 한 칸이다. REFERENCE-ISSUER의 양화는 Issuer가 발행한 Codec 문서가 정한다.

## Issuer

Issuer는 문서와 형식을 정의하는 주체다 — [Issuer와 공표](issuer.md)

| 자리 | 뜻 |
|---|---|
| Reference·Value·Edge ISSUER 코드(각 구역 끝 세 칸) | 그 Issuer가 정의한 형식 |
| Meta `DOC-ID` | 이 문서를 낸 Issuer |
| Meta `IMPORT-DOC` | 가져온 문서를 낸 Issuer |
| Reference `EXTERNAL-ISSUER-*`·`DOC-POINTER`·`CODEC-POINTER` | 가리키는 문서·코덱을 낸 Issuer(2/4/16 WORD) |
| Reference `ISSUER-POINTER` | 가리키는 Issuer 자신(2/4/16 WORD) |

| Issuer 폭 | 발급 |
|---|---|
| 2 WORD | geul.org 등록. 도메인 소유 증명(예: company.com)을 거친 Issuer. geul.org가 표준 제정 단체와 주요 기관에 배정한 번호도 이 폭이다([2 WORD 배정표](issuer.md#2-word-배정표)). |
| 4 WORD | geul.org 등록. 소유 증명 없이 등록한 Issuer |
| 16 WORD | 자체 발급. 등록 없이 공개키에서 계산한다. 아래 생성 규칙을 따른다. |

### 16 WORD Issuer 서명 알고리즘

| 서명 알고리즘 ID | 알고리즘 |
|---|---|
| `0x0001` | Ed25519 |
| 그 외 | Reserved |

## Edge

`0x0A0L~0x1BFL` — [Edge](edge/_index.md)

직접 코드의 계열은 `(코드 − 0xA0) >> 5`다(코드는 TAG ID의 앞 세 자리). 계열은 32칸씩이고 섹션 `w >> 9`에서 5를 뺀 값과 같다. 배정된 직접 코드는 아래 다섯 계열이다. `0x135L~0x1BCL`은 Reserved다(섹션 10~12는 섹션 전체가 Reserved). Issuer 형식에는 계열 규칙이 없다.

| 섹션 | 계열 | 직접 코드 |
|---|---|---|
| 5 | 서술 | `0x0A0L~0x0BFL` |
| 6 | 근거 | `0x0C0L~0x0DFL` |
| 7 | 실행 | `0x0E0L~0x0FFL` |
| 8 | [TOULMIN](toulmin/_index.md) | `0x100L~0x11BL` |
| 9 | [TOULMIN](toulmin/_index.md) 형식 | `0x120L~0x134L` |

- `0x11CL~0x11FL`은 Reserved다.
- `0x1BDL~0x1BFL`(섹션 13의 끝 세 칸)은 EDGE-ISSUER다(아래 Edge ISSUER 형식).

### 서술 (`0x0A0L~0x0BFL`)

| Codec | 이름 | 하위 형식 | 설명 |
|---|---|---|---|
| `0x0A0L` | [REFERENCE-NODE](edge/0x0A0L-reference-node.md) |  | Reference인 Subject가 Object를 지시하는 방향성 바인딩 |
| `0x0A1L` | [SAME-NODE](edge/0x0A1L-same-node.md) |  | 두 Reference가 동일한 대상을 지시하는 동일성 |
| `0x0A2L` | [DIFFERENT-NODE](edge/0x0A2L-different-node.md) |  | 두 Reference가 서로 다른 대상을 지시하는 비동일성 |
| `0x0A3L` | [BIND](edge/0x0A3L-bind.md) |  | Subject에 기계가 맞추는 이름(`UTF8-TEXT-*`)을 묶는다. 범위 안에서 유일하고 정확히 일치해야 하며 언어가 없다 |
| `0x0A4L` | [LABEL](edge/0x0A4L-label.md) |  | Subject의 언어 이름(label) 연결. Object는 UTF8-LANGUAGE-TEXT |
| `0x0A5L` | [ALIAS](edge/0x0A5L-alias.md) |  | Subject의 다른 이름(별칭) 연결. 레이아웃은 LABEL과 같다 |
| `0x0A6L` | [DESCRIPTION](edge/0x0A6L-description.md) |  | Subject의 언어 설명(description) 연결. 레이아웃은 LABEL과 같다 |
| `0x0A7L` | Reserved |  |  |
| `0x0A8L` | [VERB-SHORT](edge/0x0A8L-verb-short.md) |  | 동사 서술 축약 |
| `0x0A9L` | [VERB](edge/0x0A9L-verb.md) |  | 동사 서술 |
| `0x0AAL` | [TRIPLE](edge/0x0AAL-triple.md) |  | Predicate, Subject, Object 순서의 명제와 rank. Object는 값 또는 UNKNOWN-VALUE·NO-VALUE 표지. 의미는 그 Edge Id를 가리키는 QUALIFIER를 모두 모은 것이다 |
| `0x0ABL` | [QUALIFIER](edge/0x0ABL-qualifier.md) |  | 다른 Edge의 명제를 한정하는 조건 하나. Property, Target(Edge Id), Value(값 또는 UNKNOWN-VALUE·NO-VALUE 표지). 명제의 일부다 |
| `0x0ACL~0x0AFL` | Reserved |  |  |
| `0x0B0L` | [WORLD](edge/0x0B0L-world.md) | 있음 | 세계관 표현을 위한 구조 |
| `0x0B1L` | [TIMELINE](edge/0x0B1L-timeline.md) | 있음 | 세계와 사건의 순서를 표현하는 구조 |
| `0x0B2L` | [SCENE](edge/0x0B2L-scene.md) | 있음 | 시나리오 특성의 서술을 위한 장면 구조 |
| `0x0B3L~0x0B7L` | Reserved |  |  |
| `0x0B8L` | [PUBLICATION](edge/0x0B8L-publication.md) |  | 문서 공표. DOC-POINTER, 내용 해시 |
| `0x0B9L` | [DEPRECATION](edge/0x0B9L-deprecation.md) |  | 공표한 버전의 deprecate. DOC-POINTER |
| `0x0BAL` | [TOMBSTONE](edge/0x0BAL-tombstone.md) |  | 공표한 버전의 삭제(묘비). DOC-POINTER, 사유 범주 |
| `0x0BBL` | [DECLARE](edge/0x0BBL-declare.md) |  | Codec 하나의 Payload 구성 선언. 대상 Kind·Codec |
| `0x0BCL` | [FIELD](edge/0x0BCL-field.md) |  | Payload 필드 하나. 속한 DECLARE, 폭: 레코드(TAG의 Length) 또는 날값 n WORD |
| `0x0BDL` | [ENUM](edge/0x0BDL-enum.md) |  | 날값 필드의 코드값 하나. 필드, 코드값 |
| `0x0BEL` | [CODEC](edge/0x0BEL-codec.md) |  | 필드가 받는 Kind·Codec 하나. 필드, 대상 WORD(`000K KKKC CCCC LLLL`, LLLL 0000 정확·1111 와일드카드(그 섹션 32칸 전체), 자리 표지는 정확한 대상 `0000`·`0010`·`0020`로만). 레코드 필드는 여러 개(닫힌 목록), 날값 필드는 하나(TAG 없는 그 Value) |
| `0x0BFL` | Reserved |  |  |

| TAG ID | 묶음 |
|---|---|
| `0x0A0L~0x0A7L` | 지시와 이름 |
| `0x0A8L~0x0AFL` | 명제 |
| `0x0B0L~0x0B7L` | 구조 |
| `0x0B8L~0x0BFL` | 기타 |

### 근거 (`0x0C0L~0x0DFL`)

| Codec | 이름 | 하위 형식 | 설명 |
|---|---|---|---|
| `0x0C0L` | [SOURCE](edge/0x0C0L-source.md) |  | 레코드 하나 또는 문서 전체를 그 원천에 잇는다. Target(BODY Edge Id, HEAD에서는 `0` = 문서 전체), Origin(Reference, ABSENT 또는 UNKNOWN-VALUE). 원천의 성질은 원천을 Subject로 하는 TRIPLE, 인용의 성질(조회일, 위치, 원문 해시)은 SOURCE에 붙는 QUALIFIER. 문서 전체의 SOURCE와 그 QUALIFIER는 HEAD에 둔다 |
| `0x0C1L~0x0DFL` | Reserved |  |  |

- 원문 범위, 만든 주체, 신뢰도, 조문별 시행 기간, 옛 레코드는 QUALIFIER로 쓰고, 처음 들어온 버전은 버전 이력에서 계산한다([SOURCE](edge/0x0C0L-source.md#다른-근거의-표현)).

### 실행 (`0x0E0L~0x0FFL`)

| Codec | 이름 | 설명 |
|---|---|---|
| `0x0E0L` | Reserved |  |
| `0x0E1L` | [FUNCTION-DECLARE](edge/0x0E1L-function-declare.md) | 함수 선언. 기호, 매개변수 기호 목록, 반환 타입, 본문(BLOCK) |
| `0x0E2L` | [TYPE-DECLARE](edge/0x0E2L-type-declare.md) | 타입 선언. 기호와 구성(필드 기호 목록, 열거값, 별칭 대상) |
| `0x0E3L~0x0E7L` | Reserved |  |
| `0x0E8L` | [CONST](edge/0x0E8L-const.md) | 상수식. 내장 Value 하나 |
| `0x0E9L` | [UNARY](edge/0x0E9L-unary.md) | 단항식. 연산자 1 WORD, 피연산자 |
| `0x0EAL` | [BINARY](edge/0x0EAL-binary.md) | 이항식. 연산자 1 WORD, 왼쪽, 오른쪽 |
| `0x0EBL` | [CALL](edge/0x0EBL-call.md) | 호출. 대상 함수, 인자 수, 인자 × 인자 수 |
| `0x0ECL` | [MEMBER](edge/0x0ECL-member.md) | 멤버 접근. 대상, 필드 기호 |
| `0x0EDL` | [INDEX](edge/0x0EDL-index.md) | 색인 접근. 대상, 색인 |
| `0x0EEL` | [CONSTRUCT](edge/0x0EEL-construct.md) | 복합값 생성(목록, 레코드). 타입, 요소 수, 요소 × 요소 수 |
| `0x0EFL` | [CONDITIONAL](edge/0x0EFL-conditional.md) | 조건식. 조건, 참일 때 값, 거짓일 때 값 |
| `0x0F0L` | [BLOCK](edge/0x0F0L-block.md) | 순서 있는 문 묶음. 문 수, 문 × 문 수 |
| `0x0F1L` | [ASSIGN](edge/0x0F1L-assign.md) | 대입. 대상(기호, MEMBER, INDEX), 값 |
| `0x0F2L` | [IF](edge/0x0F2L-if.md) | 조건 분기. 조건, 참 BLOCK, 거짓(BLOCK·IF, 없으면 0) |
| `0x0F3L` | [SWITCH](edge/0x0F3L-switch.md) | 다중 분기. 대상, 갈래 수, (값, BLOCK) × 갈래 수, 기본 BLOCK(없으면 0) |
| `0x0F4L` | [WHILE](edge/0x0F4L-while.md) | 조건 반복. 조건, 본문 BLOCK |
| `0x0F5L` | [FOREACH](edge/0x0F5L-foreach.md) | 순회 반복. 요소 기호, 대상, 본문 BLOCK |
| `0x0F6L` | [JUMP](edge/0x0F6L-jump.md) | 반복 제어. 종류 1 WORD(break, continue), 대상 반복 |
| `0x0F7L` | [RETURN](edge/0x0F7L-return.md) | 반환. 값(없으면 0) |
| `0x0F8L` | [RAISE](edge/0x0F8L-raise.md) | 오류 발생. 오류 값 |
| `0x0F9L` | [TRY](edge/0x0F9L-try.md) | 오류 처리. 본문 BLOCK, 오류 기호, 처리 BLOCK, 마무리 BLOCK(없으면 0) |
| `0x0FAL~0x0FFL` | Reserved |  |

| TAG ID | 묶음 |
|---|---|
| `0x0E0L~0x0E7L` | 선언 |
| `0x0E8L~0x0EFL` | 식 |
| `0x0F0L~0x0F7L` | 문 |
| `0x0F8L~0x0FFL` | 오류 |

### TOULMIN (`0x100L~0x11BL`)

자세히: [TOULMIN](toulmin/_index.md)

| Codec | 이름 | 설명 |
|---|---|---|
| `0x100L` | [CASE-DECLARE](toulmin/0x100L-case-declare.md) | 사안 선언. 노드와 관계를 담는 판정 그래프 |
| `0x101L` | [PREDICATE-DECLARE](toulmin/0x101L-predicate-declare.md) | 술어 선언. 판정 함수·식, 판단 기준(Spec), 사실 계약(Ground) |
| `0x102L` | [SPEC-DECLARE](toulmin/0x102L-spec-declare.md) | 판단 기준 선언. 상수·목록 (Backing) |
| `0x103L` | [RULE-DECLARE](toulmin/0x103L-rule-declare.md) | 주장 선언. 사안 안에서 술어를 일반 규칙(Warrant)으로 둔다. 공격받을 수 있다. |
| `0x104L` | [COUNTER-DECLARE](toulmin/0x104L-counter-declare.md) | 반박 선언. 자기 결론을 가지고 공격한다. 기본 Level은 Fail |
| `0x105L` | [EXCEPT-DECLARE](toulmin/0x105L-except-declare.md) | 예외 선언. 자기 결론 없이 공격한다. 기본 Level은 Review |
| `0x106L~0x107L` | Reserved |  |
| `0x108L` | [ATTACKS](toulmin/0x108L-attacks.md) | 공격 관계. 공격자의 판정이 대상의 판정을 점진적으로 깎는다. |
| `0x109L` | [SUPERSEDES](toulmin/0x109L-supersedes.md) | 배제 관계. 공격자가 Active이면 대상을 집계에서 결정적으로 뺀다. |
| `0x10AL` | [SUPERSEDE-CHAIN](toulmin/0x10AL-supersede-chain.md) | 우선순위 사슬 `A > B > C`. 쌍별 SUPERSEDES의 축약. 레이아웃 미정 |
| `0x10BL~0x10FL` | Reserved |  |
| `0x110L` | [RUN](toulmin/0x110L-run.md) | 실행 합성. 노드가 Active이면 하위 사안을 실행한다(DAG). |
| `0x111L` | [DO](toulmin/0x111L-do.md) | 노드가 Active이면 수행하는 동작 |
| `0x112L` | [DO-ONCE](toulmin/0x112L-do-once.md) | 재시도해도 한 번만 수행하는 동작 |
| `0x113L` | [UNDO](toulmin/0x113L-undo.md) | DO의 보상 동작(saga). 이후 단계가 실패하면 역순으로 수행한다. |
| `0x114L` | [CHECKING](toulmin/0x114L-checking.md) | 부작용 없이 판정만 하는 연결 |
| `0x115L` | [ENTRY](toulmin/0x115L-entry.md) | 외부 진입점. 사안을 실행하거나 판정한다 |
| `0x116L` | [TRIGGER](toulmin/0x116L-trigger.md) | 외부 호출 없는 이벤트·주기 진입점 |
| `0x117L` | Reserved |  |
| `0x118L` | [VERDICT](toulmin/0x118L-verdict.md) | 노드·레코드의 판정 결과. 결과(Pass, Review, Fail), 판정값, Activated, Excluded, Level. 레이아웃 미정. 문서 전체의 판정은 Meta [VERDICT](meta/0x1E9L-verdict.md)(`0x1E9L`) |
| `0x119L` | [EVIDENCE](toulmin/0x119L-evidence.md) | 판정의 증거. 위치, 기대값, 실제값 (Fact). 레이아웃 미정 |
| `0x11AL~0x11BL` | Reserved |  |
| `0x11CL~0x11FL` | Reserved |  |

| TAG ID | 묶음 |
|---|---|
| `0x100L~0x107L` | 선언 |
| `0x108L~0x10FL` | 관계 |
| `0x110L~0x117L` | 실행 |
| `0x118L~0x11FL` | 결과 (`0x11CL~0x11FL`은 Reserved) |

### TOULMIN 형식 (`0x120L~0x134L`)

[TOULMIN](toulmin/_index.md) 문서의 원문·구획·보조 노드와 관계다.

| Codec | 이름 | 설명 |
|---|---|---|
| `0x120L` | [SOURCE](toulmin/0x120L-source.md) | 저작 원문. SPAN 폭과 UTF8 Value |
| `0x121L` | [TEXT](toulmin/0x121L-text.md) | 이름·문자열 |
| `0x122L` | [SECTION](toulmin/0x122L-section.md) | 섹션 시작. 섹션 코드 |
| `0x123L` | [CASE-BEGIN](toulmin/0x123L-case-begin.md) | 사안 범위 시작 |
| `0x124L` | [CASE-END](toulmin/0x124L-case-end.md) | 사안 범위 끝 |
| `0x125L` | [PROSE](toulmin/0x125L-prose.md) | 서술 문단(SPAN) |
| `0x126L` | [NAMESPACE](toulmin/0x126L-namespace.md) | NODE. `this document is` |
| `0x127L` | [FUNC](toulmin/0x127L-func.md) | NODE. 함수 참조 |
| `0x128L` | [FIELD](toulmin/0x128L-field.md) | NODE. `is required` |
| `0x129L` | [ALIAS](toulmin/0x129L-alias.md) | NODE. `see … from` |
| `0x12AL` | [GROUP](toulmin/0x12AL-group.md) | NODE. 순서 있는 실행 묶음 |
| `0x12BL` | [REQUIRES](toulmin/0x12BL-requires.md) | LINK. 사안 → 필드 |
| `0x12CL` | [MEANS](toulmin/0x12CL-means.md) | LINK. 정의 항목 → 값·타입 |
| `0x12DL` | [HAS](toulmin/0x12DL-has.md) | LINK. 정의 항목 → 필드 |
| `0x12EL` | [RUNS](toulmin/0x12EL-runs.md) | LINK. 진입점 → 사안, 실행 |
| `0x12FL` | [EVALUATES](toulmin/0x12FL-evaluates.md) | LINK. 진입점 → 사안, 판정 |
| `0x130L` | [TRIGGERS](toulmin/0x130L-triggers.md) | LINK. 트리거 → 사안 |
| `0x131L` | [UNTIL](toulmin/0x131L-until.md) | LINK. 트리거 → 사안(`every … until`) |
| `0x132L` | [SAME-AS](toulmin/0x132L-same-as.md) | LINK. 노드 → 전역 식별자 |
| `0x133L` | [IMPORTED-FROM](toulmin/0x133L-imported-from.md) | LINK. 별칭 → 경로(TEXT) |
| `0x134L` | [LABEL](toulmin/0x134L-label.md) | LINK. 노드 → TEXT, 이름 표기 |

- `0x135L~0x1BCL`은 Reserved다.

### Edge ISSUER 형식

`0x1BDL`~`0x1BFL`([EDGE-ISSUER-2WORD](edge/0x1BDL-edge-issuer-2word.md), [-4WORD](edge/0x1BEL-edge-issuer-4word.md), [-16WORD](edge/0x1BFL-edge-issuer-16word.md)) 뒤 Codec 확장 TAG에 Issuer와 코덱 번호 2 WORD를 둔다. 지금 등재한 Edge ISSUER 형식은 없다.

## Value

`0x060L~0x09FL` — [Value](value/_index.md)

Value 번호는 계열을 뜻하지 않는다. 직접 코드는 `0x060L~0x081L`에 Reserved 없이 둔다. `0x082L~0x09CL`은 Reserved이고, `0x09DL~0x09FL`은 VALUE-ISSUER다. 계열 이름(NUMERIC, DECIMAL, TIME, TEXT, BINARY)은 주제 묶음이다. 짝수·홀수 쌍은 짝수 코드에서 시작한다.

| 계열 | 직접 코드 |
|---|---|
| [NUMERIC](value/_index.md#numeric) | `0x060L~0x067L` |
| [DECIMAL](value/_index.md#decimal) | `0x068L~0x069L` |
| [TIME](value/_index.md#time) | `0x06AL~0x071L`, `0x081L` |
| [TEXT](value/_index.md#text) | `0x072L~0x07AL` |
| [BINARY](value/_index.md#binary) | `0x07BL~0x080L` |

### 직접 코드

| Codec | 이름 | 계열 | 설명 |
|---|---|---|---|
| `0x060L` | [BOOL](value/0x060L-bool.md) | NUMERIC | 고정 1 WORD의 false 또는 true |
| `0x061L` | [SIGNED-INTEGER](value/0x061L-signed-integer.md) | NUMERIC | 최소 WORD 2의 보수 부호 있는 정수 |
| `0x062L` | [UNSIGNED-INTEGER](value/0x062L-unsigned-integer.md) | NUMERIC | 최소 WORD big-endian unsigned magnitude 정수 |
| `0x063L` | [BINARY-FLOAT](value/0x063L-binary-float.md) | NUMERIC | Payload 1/2/4/8 WORD의 IEEE 754 binary16/32/64/128 scalar |
| `0x064L` | [COORDINATE-EARTH](value/0x064L-coordinate-earth.md) | NUMERIC | 지구(WGS 84) 위도·경도 binary64, 불확도 binary32와 그 단위 Reference(ABSENT = 미상) |
| `0x065L` | [COORDINATE-GEO](value/0x065L-coordinate-geo.md) | NUMERIC | 천체 Reference와 위도·경도 binary64, 불확도 binary32와 그 단위 Reference |
| `0x066L` | [QUANTITY](value/0x066L-quantity.md) | NUMERIC | 수치 Value amount(정수·BINARY-FLOAT·10진수·분수), 단위 Reference, 하한·상한. 단위·경계는 생략 가능(ABSENT `0x0000`) |
| `0x067L` | [FRACTION](value/0x067L-fraction.md) | NUMERIC | 원문 표기를 보존하는 분수: 정수·10진수 분자, 부호 없는 정수·10진수 분모. 약분하지 않음 |
| `0x068L` | [SIGNED-DECIMAL](value/0x068L-signed-decimal.md) | DECIMAL | signed exponent `E`와 최소 WORD 2의 보수 coefficient `C`의 `C×10^E` |
| `0x069L` | [UNSIGNED-DECIMAL](value/0x069L-unsigned-decimal.md) | DECIMAL | signed exponent `E`와 최소 WORD unsigned coefficient `C`의 `C×10^E` |
| `0x06AL` | [GREGORIAN-DATE](value/0x06AL-gregorian-date.md) | TIME | proleptic Gregorian `1970-01-01` 기준 signed 날짜 수 |
| `0x06BL` | [CIVIL-TIME-NANOSECONDS](value/0x06BL-civil-time-nanoseconds.md) | TIME | 민사일 자정 후 unsigned nanosecond 계수 |
| `0x06CL` | [POSIX-TIMESTAMP-SECONDS](value/0x06CL-posix-timestamp-seconds.md) | TIME | Unix/POSIX epoch부터의 signed 초 계수 |
| `0x06DL` | [DURATION-SECONDS](value/0x06DL-duration-seconds.md) | TIME | epoch 없는 signed SI-second 경과 시간 |
| `0x06EL`/`0x06FL` | [EDTF](value/0x06EL-edtf.md) | TIME | EDTF(ISO 8601-2) 날짜 문자열. 짝수·홀수 바이트. GREGORIAN-DATE로 쓸 수 있는 날짜는 쓰지 않는다 |
| `0x070L`/`0x071L` | [GEDCOM-DATE](value/0x070L-gedcom-date.md) | TIME | GEDCOM 7 날짜 값 문자열. 다른 달력(율리우스력 등)의 원본 표기 보존. 짝수·홀수 바이트 |
| `0x072L` | [UTF8-TEXT-EVEN](value/0x072L-utf8-text.md) | TEXT | 정규화를 암시하지 않는 valid UTF-8 바이트열. 짝수 바이트 |
| `0x073L` | [UTF8-TEXT-ODD](value/0x072L-utf8-text.md) | TEXT | 위와 같음. 홀수 바이트 |
| `0x074L` | [URI-EVEN](value/0x074L-uri.md) | TEXT | RFC 3986 `URI` production ASCII 바이트열. 짝수 바이트 |
| `0x075L` | [URI-ODD](value/0x074L-uri.md) | TEXT | 위와 같음. 홀수 바이트 |
| `0x076L` | [LANGUAGE-BCP47-CODE-EVEN](value/0x076L-language-bcp47-code.md) | TEXT | canonical casing의 완전한 BCP 47 language tag ASCII 바이트열. 짝수 바이트 |
| `0x077L` | [LANGUAGE-BCP47-CODE-ODD](value/0x076L-language-bcp47-code.md) | TEXT | 위와 같음. 홀수 바이트 |
| `0x078L`/`0x079L` | [UTF8-LANGUAGE-TEXT](value/0x078L-utf8-language-text.md) | TEXT | 언어가 붙은 텍스트. 언어 Value 레코드(LANGUAGE-SHORT-CODE 또는 LANGUAGE-BCP47-CODE)와 UTF-8 바이트. 텍스트 바이트의 짝수·홀수 |
| `0x07AL` | [LANGUAGE-SHORT-CODE](value/0x07AL-language-short-code.md) | TEXT | GEUL Language Registry 번호로 쓴 BCP 47 tag(Payload 1 WORD) |
| `0x07BL` | [UUID](value/0x07BL-uuid.md) | BINARY | 고정 Payload 8 WORD의 RFC 9562 UUID 128bit |
| `0x07CL` | [SHA-256-DIGEST](value/0x07CL-sha-256-digest.md) | BINARY | 고정 Payload 16 WORD의 SHA-256 결과 |
| `0x07DL` | [SHA1-DIGEST](value/0x07DL-sha1-digest.md) | BINARY | 고정 Payload 10 WORD의 SHA-1 결과. git 객체 ID 같은 식별 용도로만 |
| `0x07EL` | [OPAQUE-BYTES-EVEN](value/0x07EL-opaque-bytes.md) | BINARY | 의미·형식 불명의 바이트열. 짝수 바이트 |
| `0x07FL` | [OPAQUE-BYTES-ODD](value/0x07EL-opaque-bytes.md) | BINARY | 위와 같음. 홀수 바이트 |
| `0x080L` | [BIT-VECTOR](value/0x080L-bit-vector.md) | BINARY | bit-count 뒤에 MSB-first로 저장한 N bit |
| `0x081L` | [DURATION-NANOSECONDS](value/0x081L-duration-nanoseconds.md) | TIME | epoch 없는 signed nanosecond 경과 시간 |
| `0x09DL`~`0x09FL` | [VALUE-ISSUER-2WORD](value/0x09DL-value-issuer-2word.md), [-4WORD](value/0x09EL-value-issuer-4word.md), [-16WORD](value/0x09FL-value-issuer-16word.md) |  | Issuer가 정의한 형식. 아래 Value ISSUER 형식 참조 |

### Value ISSUER 형식

`0x09DL`~`0x09FL`([VALUE-ISSUER-2WORD](value/0x09DL-value-issuer-2word.md), [-4WORD](value/0x09EL-value-issuer-4word.md), [-16WORD](value/0x09FL-value-issuer-16word.md)) 뒤 Codec 확장 TAG에 Issuer와 코덱 번호 2 WORD를 둔다. 코덱 문서는 그 Issuer의 `codecs/` 아래에 레코드의 코덱 번호로 둔다. 예: IETF CRC32C는 `0x00000007/codecs/0x0000C000/`([공표 주소와 버전 목록](publishing.md)).

| Issuer | 코덱 번호 | 이름 | 설명 |
|---|---|---|---|
| `0x00000002` ADHOC | `0x00000000` | BFLOAT16 | 고정 Payload 1 WORD의 BF16 interchange bits |
| `0x00000002` ADHOC | `0x00000500` | [DENSE-I16-VECTOR](value/adhoc.geul.org/dense-i16-vector.md) | 연속 big-endian int16 vector |
| `0x00000002` ADHOC | `0x00000501` | [DENSE-U16-VECTOR](value/adhoc.geul.org/dense-u16-vector.md) | 연속 big-endian uint16 vector |
| `0x00000002` ADHOC | `0x00000502` | [DENSE-I32-VECTOR](value/adhoc.geul.org/dense-i32-vector.md) | 연속 big-endian int32 vector |
| `0x00000002` ADHOC | `0x00000503` | [DENSE-U32-VECTOR](value/adhoc.geul.org/dense-u32-vector.md) | 연속 big-endian uint32 vector |
| `0x00000002` ADHOC | `0x00000504` | [DENSE-I64-VECTOR](value/adhoc.geul.org/dense-i64-vector.md) | 연속 big-endian int64 vector |
| `0x00000002` ADHOC | `0x00000505` | [DENSE-U64-VECTOR](value/adhoc.geul.org/dense-u64-vector.md) | 연속 big-endian uint64 vector |
| `0x00000002` ADHOC | `0x00000506` | [DENSE-BINARY16-VECTOR](value/adhoc.geul.org/dense-binary16-vector.md) | 연속 IEEE 754 binary16 vector |
| `0x00000002` ADHOC | `0x00000507` | [DENSE-BFLOAT16-VECTOR](value/adhoc.geul.org/dense-bfloat16-vector.md) | 연속 BF16 vector |
| `0x00000002` ADHOC | `0x00000508` | [DENSE-BINARY32-VECTOR](value/adhoc.geul.org/dense-binary32-vector.md) | 연속 IEEE 754 binary32 vector |
| `0x00000002` ADHOC | `0x00000509` | [DENSE-BINARY64-VECTOR](value/adhoc.geul.org/dense-binary64-vector.md) | 연속 IEEE 754 binary64 vector |
| `0x00000002` ADHOC | `0x0000050A` | [POINT2-BINARY64](value/adhoc.geul.org/point2-binary64.md) | `(x,y)` 순서의 IEEE binary64 2차원 vector |
| `0x00000002` ADHOC | `0x0000050B` | [POINT3-BINARY64](value/adhoc.geul.org/point3-binary64.md) | `(x,y,z)` 순서의 IEEE binary64 3차원 vector |
| `0x00000002` ADHOC | `0x0000050C` | [BBOX2-BINARY64](value/adhoc.geul.org/bbox2-binary64.md) | `(minX,minY,maxX,maxY)` 순서의 IEEE binary64 vector |
| `0x00000002` ADHOC | `0x00000600` | [DESCRIBED-DENSE-TENSOR](value/adhoc.geul.org/described-dense-tensor.md) | element-format·rank·shape와 C-contiguous dense payload |
| `0x00000002` ADHOC | `0x00000601` | [DESCRIBED-PACKED-TENSOR](value/adhoc.geul.org/described-packed-tensor.md) | packed-format·rank·shape와 octet 내 low-bit-first packed payload |
| `0x00000002` ADHOC | `0x00000700` | [COMPLEX64](value/adhoc.geul.org/complex64.md) | `(real, imag)` 순서의 binary32 두 개 |
| `0x00000002` ADHOC | `0x00000701` | [COMPLEX128](value/adhoc.geul.org/complex128.md) | `(real, imag)` 순서의 binary64 두 개 |
| `0x00000002` ADHOC | `0x00000702` | [RATIONAL-I64](value/adhoc.geul.org/rational-i64.md) | 정규화한 int64 numerator와 양의 int64 denominator |
| `0x00000002` ADHOC | `0x00000703` | [CLOSED-INTERVAL-BINARY64](value/adhoc.geul.org/closed-interval-binary64.md) | `lower ≤ upper`인 binary64 닫힌 구간 |
| `0x00000002` ADHOC | `0x00000704` | [QUATERNION-BINARY32](value/adhoc.geul.org/quaternion-binary32.md) | `(x,y,z,w)` 순서의 binary32 네 개 |
| `0x00000002` ADHOC | `0x0000C000` | [BLAKE3-256-DIGEST](value/adhoc.geul.org/blake3-256-digest.md) | 고정 Payload 16 WORD의 기본 BLAKE3 결과 |
| `0x00000007` IETF | `0x00008000` | [URI-RELATIVE-REF-EVEN](value/ietf.geul.org/uri-relative-ref.md) | RFC 3986 relative-ref ASCII 바이트열. 짝수 바이트 |
| `0x00000007` IETF | `0x00008001` | [URI-RELATIVE-REF-ODD](value/ietf.geul.org/uri-relative-ref.md) | 위와 같음. 홀수 바이트 |
| `0x00000007` IETF | `0x0000C000` | [CRC32C](value/ietf.geul.org/crc32c.md) | 고정 Payload 2 WORD의 Castagnoli CRC-32C 결과 |
| `0x00000007` IETF | `0x0000C001` | [IPV4-ADDRESS](value/ietf.geul.org/ipv4-address.md) | 고정 Payload 2 WORD의 IPv4 주소 32bit |
| `0x00000007` IETF | `0x0000C002` | [IPV6-ADDRESS](value/ietf.geul.org/ipv6-address.md) | 고정 Payload 8 WORD의 IPv6 주소 128bit |
| `0x0000000D` IEEE | `0x00002000` | [IEEE-DECIMAL32-DPD](value/ieee.geul.org/ieee-decimal32-dpd.md) | 고정 Payload 2 WORD의 IEEE 754 decimal32 DPD |
| `0x0000000D` IEEE | `0x00002001` | [IEEE-DECIMAL64-DPD](value/ieee.geul.org/ieee-decimal64-dpd.md) | 고정 Payload 4 WORD의 IEEE 754 decimal64 DPD |
| `0x0000000D` IEEE | `0x00002002` | [IEEE-DECIMAL128-DPD](value/ieee.geul.org/ieee-decimal128-dpd.md) | 고정 Payload 8 WORD의 IEEE 754 decimal128 DPD |
| `0x0000000D` IEEE | `0x00002003` | [IEEE-DECIMAL32-BID](value/ieee.geul.org/ieee-decimal32-bid.md) | 고정 Payload 2 WORD의 IEEE 754 decimal32 BID |
| `0x0000000D` IEEE | `0x00002004` | [IEEE-DECIMAL64-BID](value/ieee.geul.org/ieee-decimal64-bid.md) | 고정 Payload 4 WORD의 IEEE 754 decimal64 BID |
| `0x0000000D` IEEE | `0x00002005` | [IEEE-DECIMAL128-BID](value/ieee.geul.org/ieee-decimal128-bid.md) | 고정 Payload 8 WORD의 IEEE 754 decimal128 BID |
| `0x0000000D` IEEE | `0x00004000` | [POSIX-TIMESTAMP-NANOSECONDS](value/ieee.geul.org/posix-timestamp-nanoseconds.md) | Unix/POSIX epoch부터의 signed nanosecond 계수 |
| `0x0000000D` IEEE | `0x0000C000` | [MAC-48-ADDRESS](value/ieee.geul.org/mac-48-address.md) | 고정 Payload 3 WORD의 IEEE 802 MAC 주소 48bit |
| `0x0000000E` KHRONOS | `0x00000000` | [RGBA8-UNORM](value/khronos.geul.org/rgba8-unorm.md) | R, G, B, A 순서의 고정 4×UNORM8 packed vector |
| `0x0000000E` KHRONOS | `0x00000001` | [BGRA8-UNORM](value/khronos.geul.org/bgra8-unorm.md) | B, G, R, A 순서의 고정 4×UNORM8 packed vector |
| `0x00000010` ONNX | `0x00000000` | FP8-E4M3FN | Payload 상위 octet의 ONNX E4M3FN scalar |
| `0x00000010` ONNX | `0x00000001` | FP8-E4M3FNUZ | Payload 상위 octet의 ONNX E4M3FNUZ scalar |
| `0x00000010` ONNX | `0x00000002` | FP8-E5M2 | Payload 상위 octet의 ONNX E5M2 scalar |
| `0x00000010` ONNX | `0x00000003` | FP8-E5M2FNUZ | Payload 상위 octet의 ONNX E5M2FNUZ scalar |
| `0x00000011` OCP | `0x00000000` | FP8-E8M0FNU | Payload 상위 octet의 unsigned exponent-only E8M0FNU scalar |
| `0x00000011` OCP | `0x00000001` | FP4-E2M1FN | Payload 상위 nibble의 ONNX/DLPack E2M1FN scalar |
| `0x00000013` BIPM | `0x00004000` | [TAI-TIMESTAMP-SECONDS](value/bipm.geul.org/tai-timestamp-seconds.md) | `1970-01-01T00:00:00 TAI`부터의 signed SI-second 계수 |
| `0x00000013` BIPM | `0x00004001` | [TAI-TIMESTAMP-NANOSECONDS](value/bipm.geul.org/tai-timestamp-nanoseconds.md) | 같은 TAI epoch부터의 signed nanosecond 계수 |
| `0x00000015` NIST | `0x0000C000` | [SHA-512-DIGEST](value/nist.geul.org/sha-512-digest.md) | 고정 Payload 32 WORD의 SHA-512 결과 |
| `0x00000015` NIST | `0x0000C001` | [SHA3-256-DIGEST](value/nist.geul.org/sha3-256-digest.md) | 고정 Payload 16 WORD의 SHA3-256 결과 |
| `0x00000016` GPS | `0x00004000` | [GPS-TIMESTAMP-SECONDS](value/gps.geul.org/gps-timestamp-seconds.md) | GPS epoch부터의 signed second 계수 |
| `0x00000016` GPS | `0x00004001` | [GPS-TIMESTAMP-NANOSECONDS](value/gps.geul.org/gps-timestamp-nanoseconds.md) | GPS epoch부터의 signed nanosecond 계수 |

## Meta

`0x1C0L~0x1FFL` — [Meta](meta/_index.md)

Meta 번호는 비트로 클래스를 나타내지 않는다. 클래스는 아래 구간 표로 안다. 검증 클래스는 섹션 15에서 `C >= 5`, 곧 `w >= 0x1E50`인 레코드로, 코덱북 없이 안다. Meta에는 ISSUER 코드가 없다.

| 클래스 | 직접 코드 | 다루는 것 |
|---|---|---|
| [구조](meta/_index.md#구조) | `0x1C0L~0x1C4L` | 문서의 경계와 길이 |
| [정의](meta/_index.md#정의) | `0x1C5L~0x1CAL` | 해석 선언 |
| [출처](meta/_index.md#출처) | `0x1CBL~0x1D0L` | 누가, 언제, 어디서 |
| [계보](meta/_index.md#계보) | `0x1D1L~0x1DDL` | 무엇에서 어떻게 나왔는가 |
| [정책](meta/_index.md#정책) | `0x1DEL~0x1E3L` | 어떻게 취급하는가 |
| [IMPORT](meta/_index.md#import) | `0x1E4L` | 외부 문서를 IMPORT ID로 가져온다 (`IMPORT-DOC`) |
| [검증](meta/_index.md#검증) | `0x1E5L~0x1E9L` | 믿을 수 있는가 |
| Reserved(검증 전용) | `0x1EAL~0x1FFL` |  |

- 번호는 `0x1C0L`부터 Reserved 없이 이어진다. 검증 밖의 새 Meta는 검증 앞에 넣을 수 없다. 뒤 Reserved `0x1EAL~0x1FFL`은 검증 전용이다. 검증 밖의 Meta를 여기에 두면 내용 해시에서 빠진다.

### 구조 (`0x1C0L~0x1C4L`)

| Codec | 이름 | 설명 |
|---|---|---|
| `0x1C0L` | [DOC-1WORD](meta/0x1C0L-doc-1word.md) | 전체 길이를 Payload 1 WORD에 지정한 문서 시작 |
| `0x1C1L` | [DOC-2WORD](meta/0x1C1L-doc-2word.md) | 전체 길이를 Payload 2 WORD에 지정한 문서 시작 |
| `0x1C2L` | [DOC-4WORD](meta/0x1C2L-doc-4word.md) | 전체 길이를 Payload 4 WORD에 지정한 문서 시작 |
| `0x1C3L` | [BODY](meta/0x1C3L-body.md) | 1 WORD. 문서의 HEAD를 끝내고 BODY를 시작한다. |
| `0x1C4L` | [END](meta/0x1C4L-end.md) | 1 WORD. 문서를 닫는다. |

### 정의 (`0x1C5L~0x1CAL`)

| Codec | 이름 | 설명 |
|---|---|---|
| `0x1C5L` | [SPEC-VERSION](meta/0x1C5L-spec-version.md) | 따르는 GEUL 명세 판. Payload가 곧 가장 짧은 폭의 unsigned 정수다. v1은 `0x0001` (레코드 `0x1C51 0x0001`) |
| `0x1C6L` | [PROFILE](meta/0x1C6L-profile.md) | 적용 프로파일 |
| `0x1C7L` | [DOC-ID](meta/0x1C7L-doc-id.md) | 이 문서의 식별자. 내장 Reference `DOC-POINTER`(Issuer, 문서 ID, 버전 0). 코덱 문서는 `CODEC-POINTER`(Issuer, 코덱 ID, 버전 0) |
| `0x1C8L` | [EFFECTIVE-FROM](meta/0x1C8L-effective-from.md) | 이 버전의 시행일. GREGORIAN-DATE 또는 POSIX-TIMESTAMP Value. 없으면 공표 시각 |
| `0x1C9L` | [EFFECTIVE-UNTIL](meta/0x1C9L-effective-until.md) | 이 버전의 유효기간 끝(한시법). 없으면 다음 버전이 시행될 때까지 |
| `0x1CAL` | [DEFAULT-LANGUAGE](meta/0x1CAL-default-language.md) | 기본 언어 |

### 출처 (`0x1CBL~0x1D0L`)

| Codec | 이름 | 설명 |
|---|---|---|
| `0x1CBL` | [AUTHOR](meta/0x1CBL-author.md) | 작성자. Reference (git author) |
| `0x1CCL` | [CO-AUTHOR](meta/0x1CCL-co-author.md) | 공동 작성자. Reference (git `Co-authored-by`) |
| `0x1CDL` | [CREATED-AT](meta/0x1CDL-created-at.md) | 작성 시각. TIME Value (git author date) |
| `0x1CEL` | [MODIFIED-AT](meta/0x1CEL-modified-at.md) | 수정 시각. TIME Value |
| `0x1CFL` | [RECORDED-BY](meta/0x1CFL-recorded-by.md) | 기록한 주체. Reference (git committer) |
| `0x1D0L` | [RECORDED-AT](meta/0x1D0L-recorded-at.md) | 기록한 시각. TIME Value (git commit date) |

- 원천 자료와 그 범위·확보 시각·해시는 Meta가 아니라 HEAD의 근거 Edge [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처)(Target `0`)와 그 QUALIFIER로 쓴다.

### 계보 (`0x1D1L~0x1DDL`)

| Codec | 이름 | 설명 |
|---|---|---|
| `0x1D1L` | [PARENT](meta/0x1D1L-parent.md) | 직전 버전의 내용 해시 (git parent). 없으면 최초 버전이고, 여럿이면 병합이다(git merge commit). |
| `0x1D2L` | [DERIVED-FROM](meta/0x1D2L-derived-from.md) | 다른 계보의 레코드·자료에서 파생. 외부 자료의 특정 버전에 고정할 때는 HEAD의 [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처)에 원문 해시 QUALIFIER(P4092)를 붙인다(git submodule). |
| `0x1D3L` | [GENERATED-BY](meta/0x1D3L-generated-by.md) | 생성 주체. 사람, 모델, 규칙 엔진 |
| `0x1D4L` | [TRANSFORMED-BY](meta/0x1D4L-transformed-by.md) | 변환 방법. 도구·규칙·버전 |
| `0x1D5L` | [CHERRY-PICKED-FROM](meta/0x1D5L-cherry-picked-from.md) | 다른 계보의 변경을 가져온 원 버전의 내용 해시 (git cherry-pick `-x`) |
| `0x1D6L` | [REVERTS](meta/0x1D6L-reverts.md) | 변경을 되돌린 대상 버전의 내용 해시 (git revert) |
| `0x1D7L` | [REPLACES](meta/0x1D7L-replaces.md) | 고쳐 쓴 대상 버전의 내용 해시 (git amend·rebase). 원 버전은 지우지 않는다. |
| `0x1D8L` | [SQUASHED-FROM](meta/0x1D8L-squashed-from.md) | 하나로 합친 원 버전들의 내용 해시 (git squash) |
| `0x1D9L` | [MESSAGE](meta/0x1D9L-message.md) | 변경 이유. UTF8-LANGUAGE-TEXT Value, 언어마다 하나 (git commit message) |
| `0x1DAL` | [TAG](meta/0x1DAL-tag.md) | 버전에 붙인 불변 이름. TEXT Value와 내용 해시 (git annotated tag) |
| `0x1DBL` | [DELTA-BASE](meta/0x1DBL-delta-base.md) | 이 버전 파일은 같은 문서의 기준 버전(2 WORD 버전 ID)에 대한 diff다 (git packfile delta) |
| `0x1DCL` | [DELTA-REMOVE](meta/0x1DCL-delta-remove.md) | diff에서 기준 BODY에서 뺄 LOCAL ID(Edge Id) 목록 |
| `0x1DDL` | [NEXT-LOCAL-ID](meta/0x1DDL-next-local-id.md) | 다음에 배정할 LOCAL ID (auto increment). 버전 목록 `versions.geul`의 HEAD에 둔다 |

### 정책 (`0x1DEL~0x1E3L`)

| Codec | 이름 | 설명 |
|---|---|---|
| `0x1DEL` | [LICENSE](meta/0x1DEL-license.md) | 라이선스. Reference |
| `0x1DFL` | [ACCESS](meta/0x1DFL-access.md) | 공개 범위 |
| `0x1E0L` | [PRIVACY](meta/0x1E0L-privacy.md) | 개인정보 등급 |
| `0x1E1L` | [RETENTION](meta/0x1E1L-retention.md) | 보존 기한 |
| `0x1E2L` | [CONSENT](meta/0x1E2L-consent.md) | 동의 범위와 근거 |
| `0x1E3L` | [USAGE](meta/0x1E3L-usage.md) | 사용 제한 |

### IMPORT (`0x1E4L`)

| Codec | 이름 | 설명 |
|---|---|---|
| `0x1E4L` | [IMPORT-DOC](meta/0x1E4L-import-doc.md) | 외부 문서를 IMPORT ID로 가져온다. 내장 Reference `DOC-POINTER`(코덱 문서는 `CODEC-POINTER`) + IMPORT ID |

### 검증 (`0x1E5L~0x1E9L`)

| Codec | 이름 | 설명 |
|---|---|---|
| `0x1E5L` | [ISSUER-KEY](meta/0x1E5L-issuer-key.md) | 자체 발급 Issuer의 서명 알고리즘 ID와 공개키 선언 |
| `0x1E6L` | [SIGNATURE](meta/0x1E6L-signature.md) | 대상에 대한 서명. 문서에 대한 서명은 내용 해시에 서명한다 (git 서명 커밋·태그) |
| `0x1E7L` | [SIGNED-OFF](meta/0x1E7L-signed-off.md) | 기여 권리 확인. Reference (git `Signed-off-by`, DCO) |
| `0x1E8L` | [CONFIDENCE](meta/0x1E8L-confidence.md) | 신뢰도 |
| `0x1E9L` | [VERDICT](meta/0x1E9L-verdict.md) | 문서 전체의 판정 결과. Pass, Review, Fail. 노드·레코드 단위는 [TOULMIN](toulmin/_index.md) `VERDICT`(Edge `0x118L`) |

## 전체 배정표

배정 227칸, md 176개. 5Q 체계와 홀짝 쌍은 구성원마다 한 행이고, md는 묶음 머리 md다.

| TAG ID | 코덱 ID | 이름 | Kind | 섹션 | md | 묶음 |
|---|---|---|---|---|---|---|
| `0x000L` | `0x00000000` | ABSENT | Reference | 0 | [0x000L-absent.md](reference/0x000L-absent.md) |  |
| `0x001L` | `0x00000010` | UNKNOWN-VALUE | Reference | 0 | [0x001L-unknown-value.md](reference/0x001L-unknown-value.md) |  |
| `0x002L` | `0x00000020` | NO-VALUE | Reference | 0 | [0x002L-no-value.md](reference/0x002L-no-value.md) |  |
| `0x005L` | `0x00000050` | LOCAL-IDENTIFIED | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x006L` | `0x00000060` | LOCAL-GENERIC | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x007L` | `0x00000070` | LOCAL-FREE-CHOICE | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x008L` | `0x00000080` | LOCAL-UNIVERSAL | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x009L` | `0x00000090` | LOCAL-VARIABLE | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x00AL` | `0x000000A0` | GEUL-IDENTIFIED | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00BL` | `0x000000B0` | GEUL-GENERIC | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00CL` | `0x000000C0` | GEUL-FREE-CHOICE | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00DL` | `0x000000D0` | GEUL-UNIVERSAL | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00EL` | `0x000000E0` | GEUL-VARIABLE | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00FL` | `0x000000F0` | GEUL-SIDX-IDENTIFIED | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x010L` | `0x00000100` | GEUL-SIDX-GENERIC | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x011L` | `0x00000110` | GEUL-SIDX-FREE-CHOICE | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x012L` | `0x00000120` | GEUL-SIDX-UNIVERSAL | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x013L` | `0x00000130` | GEUL-SIDX-VARIABLE | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x014L` | `0x00000140` | WIKIDATA-QID-IDENTIFIED | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x015L` | `0x00000150` | WIKIDATA-QID-GENERIC | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x016L` | `0x00000160` | WIKIDATA-QID-FREE-CHOICE | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x017L` | `0x00000170` | WIKIDATA-QID-UNIVERSAL | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x018L` | `0x00000180` | WIKIDATA-QID-VARIABLE | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x019L` | `0x00000190` | WIKIDATA-PID-IDENTIFIED | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01AL` | `0x000001A0` | WIKIDATA-PID-GENERIC | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01BL` | `0x000001B0` | WIKIDATA-PID-FREE-CHOICE | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01CL` | `0x000001C0` | WIKIDATA-PID-UNIVERSAL | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01DL` | `0x000001D0` | WIKIDATA-PID-VARIABLE | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x020L` | `0x00000200` | EXTERNAL-POINTER-1WORD-IDENTIFIED | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x021L` | `0x00000210` | EXTERNAL-POINTER-1WORD-GENERIC | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x022L` | `0x00000220` | EXTERNAL-POINTER-1WORD-FREE-CHOICE | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x023L` | `0x00000230` | EXTERNAL-POINTER-1WORD-UNIVERSAL | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x024L` | `0x00000240` | EXTERNAL-POINTER-1WORD-VARIABLE | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x025L` | `0x00000250` | EXTERNAL-POINTER-2WORD-IDENTIFIED | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x026L` | `0x00000260` | EXTERNAL-POINTER-2WORD-GENERIC | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x027L` | `0x00000270` | EXTERNAL-POINTER-2WORD-FREE-CHOICE | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x028L` | `0x00000280` | EXTERNAL-POINTER-2WORD-UNIVERSAL | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x029L` | `0x00000290` | EXTERNAL-POINTER-2WORD-VARIABLE | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x02AL` | `0x000002A0` | EXTERNAL-POINTER-4WORD-IDENTIFIED | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02BL` | `0x000002B0` | EXTERNAL-POINTER-4WORD-GENERIC | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02CL` | `0x000002C0` | EXTERNAL-POINTER-4WORD-FREE-CHOICE | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02DL` | `0x000002D0` | EXTERNAL-POINTER-4WORD-UNIVERSAL | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02EL` | `0x000002E0` | EXTERNAL-POINTER-4WORD-VARIABLE | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02FL` | `0x000002F0` | EXTERNAL-ISSUER-2WORD-IDENTIFIED | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x030L` | `0x00000300` | EXTERNAL-ISSUER-2WORD-GENERIC | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x031L` | `0x00000310` | EXTERNAL-ISSUER-2WORD-FREE-CHOICE | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x032L` | `0x00000320` | EXTERNAL-ISSUER-2WORD-UNIVERSAL | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x033L` | `0x00000330` | EXTERNAL-ISSUER-2WORD-VARIABLE | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x034L` | `0x00000340` | EXTERNAL-ISSUER-4WORD-IDENTIFIED | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x035L` | `0x00000350` | EXTERNAL-ISSUER-4WORD-GENERIC | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x036L` | `0x00000360` | EXTERNAL-ISSUER-4WORD-FREE-CHOICE | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x037L` | `0x00000370` | EXTERNAL-ISSUER-4WORD-UNIVERSAL | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x038L` | `0x00000380` | EXTERNAL-ISSUER-4WORD-VARIABLE | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x039L` | `0x00000390` | EXTERNAL-ISSUER-16WORD-IDENTIFIED | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03AL` | `0x000003A0` | EXTERNAL-ISSUER-16WORD-GENERIC | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03BL` | `0x000003B0` | EXTERNAL-ISSUER-16WORD-FREE-CHOICE | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03CL` | `0x000003C0` | EXTERNAL-ISSUER-16WORD-UNIVERSAL | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03DL` | `0x000003D0` | EXTERNAL-ISSUER-16WORD-VARIABLE | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x040L` | `0x00000400` | ISSUER-POINTER | Reference | 2 | [0x040L-issuer-pointer.md](reference/0x040L-issuer-pointer.md) |  |
| `0x041L` | `0x00000410` | DOC-POINTER | Reference | 2 | [0x041L-doc-pointer.md](reference/0x041L-doc-pointer.md) |  |
| `0x042L` | `0x00000420` | CODEC-POINTER | Reference | 2 | [0x042L-codec-pointer.md](reference/0x042L-codec-pointer.md) |  |
| `0x05DL` | `0x000005D0` | REFERENCE-ISSUER-2WORD | Reference | 2 | [0x05DL-reference-issuer-2word.md](reference/0x05DL-reference-issuer-2word.md) |  |
| `0x05EL` | `0x000005E0` | REFERENCE-ISSUER-4WORD | Reference | 2 | [0x05EL-reference-issuer-4word.md](reference/0x05EL-reference-issuer-4word.md) |  |
| `0x05FL` | `0x000005F0` | REFERENCE-ISSUER-16WORD | Reference | 2 | [0x05FL-reference-issuer-16word.md](reference/0x05FL-reference-issuer-16word.md) |  |
| `0x060L` | `0x00000600` | BOOL | Value | 3 | [0x060L-bool.md](value/0x060L-bool.md) |  |
| `0x061L` | `0x00000610` | SIGNED-INTEGER | Value | 3 | [0x061L-signed-integer.md](value/0x061L-signed-integer.md) |  |
| `0x062L` | `0x00000620` | UNSIGNED-INTEGER | Value | 3 | [0x062L-unsigned-integer.md](value/0x062L-unsigned-integer.md) |  |
| `0x063L` | `0x00000630` | BINARY-FLOAT | Value | 3 | [0x063L-binary-float.md](value/0x063L-binary-float.md) |  |
| `0x064L` | `0x00000640` | COORDINATE-EARTH | Value | 3 | [0x064L-coordinate-earth.md](value/0x064L-coordinate-earth.md) |  |
| `0x065L` | `0x00000650` | COORDINATE-GEO | Value | 3 | [0x065L-coordinate-geo.md](value/0x065L-coordinate-geo.md) |  |
| `0x066L` | `0x00000660` | QUANTITY | Value | 3 | [0x066L-quantity.md](value/0x066L-quantity.md) |  |
| `0x067L` | `0x00000670` | FRACTION | Value | 3 | [0x067L-fraction.md](value/0x067L-fraction.md) |  |
| `0x068L` | `0x00000680` | SIGNED-DECIMAL | Value | 3 | [0x068L-signed-decimal.md](value/0x068L-signed-decimal.md) |  |
| `0x069L` | `0x00000690` | UNSIGNED-DECIMAL | Value | 3 | [0x069L-unsigned-decimal.md](value/0x069L-unsigned-decimal.md) |  |
| `0x06AL` | `0x000006A0` | GREGORIAN-DATE | Value | 3 | [0x06AL-gregorian-date.md](value/0x06AL-gregorian-date.md) |  |
| `0x06BL` | `0x000006B0` | CIVIL-TIME-NANOSECONDS | Value | 3 | [0x06BL-civil-time-nanoseconds.md](value/0x06BL-civil-time-nanoseconds.md) |  |
| `0x06CL` | `0x000006C0` | POSIX-TIMESTAMP-SECONDS | Value | 3 | [0x06CL-posix-timestamp-seconds.md](value/0x06CL-posix-timestamp-seconds.md) |  |
| `0x06DL` | `0x000006D0` | DURATION-SECONDS | Value | 3 | [0x06DL-duration-seconds.md](value/0x06DL-duration-seconds.md) |  |
| `0x06EL` | `0x000006E0` | EDTF-EVEN | Value | 3 | [0x06EL-edtf.md](value/0x06EL-edtf.md) | 홀짝 `EDTF` |
| `0x06FL` | `0x000006F0` | EDTF-ODD | Value | 3 | [0x06EL-edtf.md](value/0x06EL-edtf.md) | 홀짝 `EDTF` |
| `0x070L` | `0x00000700` | GEDCOM-DATE-EVEN | Value | 3 | [0x070L-gedcom-date.md](value/0x070L-gedcom-date.md) | 홀짝 `GEDCOM-DATE` |
| `0x071L` | `0x00000710` | GEDCOM-DATE-ODD | Value | 3 | [0x070L-gedcom-date.md](value/0x070L-gedcom-date.md) | 홀짝 `GEDCOM-DATE` |
| `0x072L` | `0x00000720` | UTF8-TEXT-EVEN | Value | 3 | [0x072L-utf8-text.md](value/0x072L-utf8-text.md) | 홀짝 `UTF8-TEXT` |
| `0x073L` | `0x00000730` | UTF8-TEXT-ODD | Value | 3 | [0x072L-utf8-text.md](value/0x072L-utf8-text.md) | 홀짝 `UTF8-TEXT` |
| `0x074L` | `0x00000740` | URI-EVEN | Value | 3 | [0x074L-uri.md](value/0x074L-uri.md) | 홀짝 `URI` |
| `0x075L` | `0x00000750` | URI-ODD | Value | 3 | [0x074L-uri.md](value/0x074L-uri.md) | 홀짝 `URI` |
| `0x076L` | `0x00000760` | LANGUAGE-BCP47-CODE-EVEN | Value | 3 | [0x076L-language-bcp47-code.md](value/0x076L-language-bcp47-code.md) | 홀짝 `LANGUAGE-BCP47-CODE` |
| `0x077L` | `0x00000770` | LANGUAGE-BCP47-CODE-ODD | Value | 3 | [0x076L-language-bcp47-code.md](value/0x076L-language-bcp47-code.md) | 홀짝 `LANGUAGE-BCP47-CODE` |
| `0x078L` | `0x00000780` | UTF8-LANGUAGE-TEXT-EVEN | Value | 3 | [0x078L-utf8-language-text.md](value/0x078L-utf8-language-text.md) | 홀짝 `UTF8-LANGUAGE-TEXT` |
| `0x079L` | `0x00000790` | UTF8-LANGUAGE-TEXT-ODD | Value | 3 | [0x078L-utf8-language-text.md](value/0x078L-utf8-language-text.md) | 홀짝 `UTF8-LANGUAGE-TEXT` |
| `0x07AL` | `0x000007A0` | LANGUAGE-SHORT-CODE | Value | 3 | [0x07AL-language-short-code.md](value/0x07AL-language-short-code.md) |  |
| `0x07BL` | `0x000007B0` | UUID | Value | 3 | [0x07BL-uuid.md](value/0x07BL-uuid.md) |  |
| `0x07CL` | `0x000007C0` | SHA-256-DIGEST | Value | 3 | [0x07CL-sha-256-digest.md](value/0x07CL-sha-256-digest.md) |  |
| `0x07DL` | `0x000007D0` | SHA1-DIGEST | Value | 3 | [0x07DL-sha1-digest.md](value/0x07DL-sha1-digest.md) |  |
| `0x07EL` | `0x000007E0` | OPAQUE-BYTES-EVEN | Value | 3 | [0x07EL-opaque-bytes.md](value/0x07EL-opaque-bytes.md) | 홀짝 `OPAQUE-BYTES` |
| `0x07FL` | `0x000007F0` | OPAQUE-BYTES-ODD | Value | 3 | [0x07EL-opaque-bytes.md](value/0x07EL-opaque-bytes.md) | 홀짝 `OPAQUE-BYTES` |
| `0x080L` | `0x00000800` | BIT-VECTOR | Value | 4 | [0x080L-bit-vector.md](value/0x080L-bit-vector.md) |  |
| `0x081L` | `0x00000810` | DURATION-NANOSECONDS | Value | 4 | [0x081L-duration-nanoseconds.md](value/0x081L-duration-nanoseconds.md) |  |
| `0x09DL` | `0x000009D0` | VALUE-ISSUER-2WORD | Value | 4 | [0x09DL-value-issuer-2word.md](value/0x09DL-value-issuer-2word.md) |  |
| `0x09EL` | `0x000009E0` | VALUE-ISSUER-4WORD | Value | 4 | [0x09EL-value-issuer-4word.md](value/0x09EL-value-issuer-4word.md) |  |
| `0x09FL` | `0x000009F0` | VALUE-ISSUER-16WORD | Value | 4 | [0x09FL-value-issuer-16word.md](value/0x09FL-value-issuer-16word.md) |  |
| `0x0A0L` | `0x00000A00` | REFERENCE-NODE | Edge | 5 | [0x0A0L-reference-node.md](edge/0x0A0L-reference-node.md) |  |
| `0x0A1L` | `0x00000A10` | SAME-NODE | Edge | 5 | [0x0A1L-same-node.md](edge/0x0A1L-same-node.md) |  |
| `0x0A2L` | `0x00000A20` | DIFFERENT-NODE | Edge | 5 | [0x0A2L-different-node.md](edge/0x0A2L-different-node.md) |  |
| `0x0A3L` | `0x00000A30` | BIND | Edge | 5 | [0x0A3L-bind.md](edge/0x0A3L-bind.md) |  |
| `0x0A4L` | `0x00000A40` | LABEL | Edge | 5 | [0x0A4L-label.md](edge/0x0A4L-label.md) |  |
| `0x0A5L` | `0x00000A50` | ALIAS | Edge | 5 | [0x0A5L-alias.md](edge/0x0A5L-alias.md) |  |
| `0x0A6L` | `0x00000A60` | DESCRIPTION | Edge | 5 | [0x0A6L-description.md](edge/0x0A6L-description.md) |  |
| `0x0A8L` | `0x00000A80` | VERB-SHORT | Edge | 5 | [0x0A8L-verb-short.md](edge/0x0A8L-verb-short.md) |  |
| `0x0A9L` | `0x00000A90` | VERB | Edge | 5 | [0x0A9L-verb.md](edge/0x0A9L-verb.md) |  |
| `0x0AAL` | `0x00000AA0` | TRIPLE | Edge | 5 | [0x0AAL-triple.md](edge/0x0AAL-triple.md) |  |
| `0x0ABL` | `0x00000AB0` | QUALIFIER | Edge | 5 | [0x0ABL-qualifier.md](edge/0x0ABL-qualifier.md) |  |
| `0x0B0L` | `0x00000B00` | WORLD | Edge | 5 | [0x0B0L-world.md](edge/0x0B0L-world.md) |  |
| `0x0B1L` | `0x00000B10` | TIMELINE | Edge | 5 | [0x0B1L-timeline.md](edge/0x0B1L-timeline.md) |  |
| `0x0B2L` | `0x00000B20` | SCENE | Edge | 5 | [0x0B2L-scene.md](edge/0x0B2L-scene.md) |  |
| `0x0B8L` | `0x00000B80` | PUBLICATION | Edge | 5 | [0x0B8L-publication.md](edge/0x0B8L-publication.md) |  |
| `0x0B9L` | `0x00000B90` | DEPRECATION | Edge | 5 | [0x0B9L-deprecation.md](edge/0x0B9L-deprecation.md) |  |
| `0x0BAL` | `0x00000BA0` | TOMBSTONE | Edge | 5 | [0x0BAL-tombstone.md](edge/0x0BAL-tombstone.md) |  |
| `0x0BBL` | `0x00000BB0` | DECLARE | Edge | 5 | [0x0BBL-declare.md](edge/0x0BBL-declare.md) |  |
| `0x0BCL` | `0x00000BC0` | FIELD | Edge | 5 | [0x0BCL-field.md](edge/0x0BCL-field.md) |  |
| `0x0BDL` | `0x00000BD0` | ENUM | Edge | 5 | [0x0BDL-enum.md](edge/0x0BDL-enum.md) |  |
| `0x0BEL` | `0x00000BE0` | CODEC | Edge | 5 | [0x0BEL-codec.md](edge/0x0BEL-codec.md) |  |
| `0x0C0L` | `0x00000C00` | SOURCE | Edge | 6 | [0x0C0L-source.md](edge/0x0C0L-source.md) |  |
| `0x0E1L` | `0x00000E10` | FUNCTION-DECLARE | Edge | 7 | [0x0E1L-function-declare.md](edge/0x0E1L-function-declare.md) |  |
| `0x0E2L` | `0x00000E20` | TYPE-DECLARE | Edge | 7 | [0x0E2L-type-declare.md](edge/0x0E2L-type-declare.md) |  |
| `0x0E8L` | `0x00000E80` | CONST | Edge | 7 | [0x0E8L-const.md](edge/0x0E8L-const.md) |  |
| `0x0E9L` | `0x00000E90` | UNARY | Edge | 7 | [0x0E9L-unary.md](edge/0x0E9L-unary.md) |  |
| `0x0EAL` | `0x00000EA0` | BINARY | Edge | 7 | [0x0EAL-binary.md](edge/0x0EAL-binary.md) |  |
| `0x0EBL` | `0x00000EB0` | CALL | Edge | 7 | [0x0EBL-call.md](edge/0x0EBL-call.md) |  |
| `0x0ECL` | `0x00000EC0` | MEMBER | Edge | 7 | [0x0ECL-member.md](edge/0x0ECL-member.md) |  |
| `0x0EDL` | `0x00000ED0` | INDEX | Edge | 7 | [0x0EDL-index.md](edge/0x0EDL-index.md) |  |
| `0x0EEL` | `0x00000EE0` | CONSTRUCT | Edge | 7 | [0x0EEL-construct.md](edge/0x0EEL-construct.md) |  |
| `0x0EFL` | `0x00000EF0` | CONDITIONAL | Edge | 7 | [0x0EFL-conditional.md](edge/0x0EFL-conditional.md) |  |
| `0x0F0L` | `0x00000F00` | BLOCK | Edge | 7 | [0x0F0L-block.md](edge/0x0F0L-block.md) |  |
| `0x0F1L` | `0x00000F10` | ASSIGN | Edge | 7 | [0x0F1L-assign.md](edge/0x0F1L-assign.md) |  |
| `0x0F2L` | `0x00000F20` | IF | Edge | 7 | [0x0F2L-if.md](edge/0x0F2L-if.md) |  |
| `0x0F3L` | `0x00000F30` | SWITCH | Edge | 7 | [0x0F3L-switch.md](edge/0x0F3L-switch.md) |  |
| `0x0F4L` | `0x00000F40` | WHILE | Edge | 7 | [0x0F4L-while.md](edge/0x0F4L-while.md) |  |
| `0x0F5L` | `0x00000F50` | FOREACH | Edge | 7 | [0x0F5L-foreach.md](edge/0x0F5L-foreach.md) |  |
| `0x0F6L` | `0x00000F60` | JUMP | Edge | 7 | [0x0F6L-jump.md](edge/0x0F6L-jump.md) |  |
| `0x0F7L` | `0x00000F70` | RETURN | Edge | 7 | [0x0F7L-return.md](edge/0x0F7L-return.md) |  |
| `0x0F8L` | `0x00000F80` | RAISE | Edge | 7 | [0x0F8L-raise.md](edge/0x0F8L-raise.md) |  |
| `0x0F9L` | `0x00000F90` | TRY | Edge | 7 | [0x0F9L-try.md](edge/0x0F9L-try.md) |  |
| `0x100L` | `0x00001000` | CASE-DECLARE | Edge | 8 | [0x100L-case-declare.md](toulmin/0x100L-case-declare.md) |  |
| `0x101L` | `0x00001010` | PREDICATE-DECLARE | Edge | 8 | [0x101L-predicate-declare.md](toulmin/0x101L-predicate-declare.md) |  |
| `0x102L` | `0x00001020` | SPEC-DECLARE | Edge | 8 | [0x102L-spec-declare.md](toulmin/0x102L-spec-declare.md) |  |
| `0x103L` | `0x00001030` | RULE-DECLARE | Edge | 8 | [0x103L-rule-declare.md](toulmin/0x103L-rule-declare.md) |  |
| `0x104L` | `0x00001040` | COUNTER-DECLARE | Edge | 8 | [0x104L-counter-declare.md](toulmin/0x104L-counter-declare.md) |  |
| `0x105L` | `0x00001050` | EXCEPT-DECLARE | Edge | 8 | [0x105L-except-declare.md](toulmin/0x105L-except-declare.md) |  |
| `0x108L` | `0x00001080` | ATTACKS | Edge | 8 | [0x108L-attacks.md](toulmin/0x108L-attacks.md) |  |
| `0x109L` | `0x00001090` | SUPERSEDES | Edge | 8 | [0x109L-supersedes.md](toulmin/0x109L-supersedes.md) |  |
| `0x10AL` | `0x000010A0` | SUPERSEDE-CHAIN | Edge | 8 | [0x10AL-supersede-chain.md](toulmin/0x10AL-supersede-chain.md) |  |
| `0x110L` | `0x00001100` | RUN | Edge | 8 | [0x110L-run.md](toulmin/0x110L-run.md) |  |
| `0x111L` | `0x00001110` | DO | Edge | 8 | [0x111L-do.md](toulmin/0x111L-do.md) |  |
| `0x112L` | `0x00001120` | DO-ONCE | Edge | 8 | [0x112L-do-once.md](toulmin/0x112L-do-once.md) |  |
| `0x113L` | `0x00001130` | UNDO | Edge | 8 | [0x113L-undo.md](toulmin/0x113L-undo.md) |  |
| `0x114L` | `0x00001140` | CHECKING | Edge | 8 | [0x114L-checking.md](toulmin/0x114L-checking.md) |  |
| `0x115L` | `0x00001150` | ENTRY | Edge | 8 | [0x115L-entry.md](toulmin/0x115L-entry.md) |  |
| `0x116L` | `0x00001160` | TRIGGER | Edge | 8 | [0x116L-trigger.md](toulmin/0x116L-trigger.md) |  |
| `0x118L` | `0x00001180` | VERDICT | Edge | 8 | [0x118L-verdict.md](toulmin/0x118L-verdict.md) |  |
| `0x119L` | `0x00001190` | EVIDENCE | Edge | 8 | [0x119L-evidence.md](toulmin/0x119L-evidence.md) |  |
| `0x120L` | `0x00001200` | SOURCE | Edge | 9 | [0x120L-source.md](toulmin/0x120L-source.md) |  |
| `0x121L` | `0x00001210` | TEXT | Edge | 9 | [0x121L-text.md](toulmin/0x121L-text.md) |  |
| `0x122L` | `0x00001220` | SECTION | Edge | 9 | [0x122L-section.md](toulmin/0x122L-section.md) |  |
| `0x123L` | `0x00001230` | CASE-BEGIN | Edge | 9 | [0x123L-case-begin.md](toulmin/0x123L-case-begin.md) |  |
| `0x124L` | `0x00001240` | CASE-END | Edge | 9 | [0x124L-case-end.md](toulmin/0x124L-case-end.md) |  |
| `0x125L` | `0x00001250` | PROSE | Edge | 9 | [0x125L-prose.md](toulmin/0x125L-prose.md) |  |
| `0x126L` | `0x00001260` | NAMESPACE | Edge | 9 | [0x126L-namespace.md](toulmin/0x126L-namespace.md) |  |
| `0x127L` | `0x00001270` | FUNC | Edge | 9 | [0x127L-func.md](toulmin/0x127L-func.md) |  |
| `0x128L` | `0x00001280` | FIELD | Edge | 9 | [0x128L-field.md](toulmin/0x128L-field.md) |  |
| `0x129L` | `0x00001290` | ALIAS | Edge | 9 | [0x129L-alias.md](toulmin/0x129L-alias.md) |  |
| `0x12AL` | `0x000012A0` | GROUP | Edge | 9 | [0x12AL-group.md](toulmin/0x12AL-group.md) |  |
| `0x12BL` | `0x000012B0` | REQUIRES | Edge | 9 | [0x12BL-requires.md](toulmin/0x12BL-requires.md) |  |
| `0x12CL` | `0x000012C0` | MEANS | Edge | 9 | [0x12CL-means.md](toulmin/0x12CL-means.md) |  |
| `0x12DL` | `0x000012D0` | HAS | Edge | 9 | [0x12DL-has.md](toulmin/0x12DL-has.md) |  |
| `0x12EL` | `0x000012E0` | RUNS | Edge | 9 | [0x12EL-runs.md](toulmin/0x12EL-runs.md) |  |
| `0x12FL` | `0x000012F0` | EVALUATES | Edge | 9 | [0x12FL-evaluates.md](toulmin/0x12FL-evaluates.md) |  |
| `0x130L` | `0x00001300` | TRIGGERS | Edge | 9 | [0x130L-triggers.md](toulmin/0x130L-triggers.md) |  |
| `0x131L` | `0x00001310` | UNTIL | Edge | 9 | [0x131L-until.md](toulmin/0x131L-until.md) |  |
| `0x132L` | `0x00001320` | SAME-AS | Edge | 9 | [0x132L-same-as.md](toulmin/0x132L-same-as.md) |  |
| `0x133L` | `0x00001330` | IMPORTED-FROM | Edge | 9 | [0x133L-imported-from.md](toulmin/0x133L-imported-from.md) |  |
| `0x134L` | `0x00001340` | LABEL | Edge | 9 | [0x134L-label.md](toulmin/0x134L-label.md) |  |
| `0x1BDL` | `0x00001BD0` | EDGE-ISSUER-2WORD | Edge | 13 | [0x1BDL-edge-issuer-2word.md](edge/0x1BDL-edge-issuer-2word.md) |  |
| `0x1BEL` | `0x00001BE0` | EDGE-ISSUER-4WORD | Edge | 13 | [0x1BEL-edge-issuer-4word.md](edge/0x1BEL-edge-issuer-4word.md) |  |
| `0x1BFL` | `0x00001BF0` | EDGE-ISSUER-16WORD | Edge | 13 | [0x1BFL-edge-issuer-16word.md](edge/0x1BFL-edge-issuer-16word.md) |  |
| `0x1C0L` | `0x00001C00` | DOC-1WORD | Meta | 14 | [0x1C0L-doc-1word.md](meta/0x1C0L-doc-1word.md) |  |
| `0x1C1L` | `0x00001C10` | DOC-2WORD | Meta | 14 | [0x1C1L-doc-2word.md](meta/0x1C1L-doc-2word.md) |  |
| `0x1C2L` | `0x00001C20` | DOC-4WORD | Meta | 14 | [0x1C2L-doc-4word.md](meta/0x1C2L-doc-4word.md) |  |
| `0x1C3L` | `0x00001C30` | BODY | Meta | 14 | [0x1C3L-body.md](meta/0x1C3L-body.md) |  |
| `0x1C4L` | `0x00001C40` | END | Meta | 14 | [0x1C4L-end.md](meta/0x1C4L-end.md) |  |
| `0x1C5L` | `0x00001C50` | SPEC-VERSION | Meta | 14 | [0x1C5L-spec-version.md](meta/0x1C5L-spec-version.md) |  |
| `0x1C6L` | `0x00001C60` | PROFILE | Meta | 14 | [0x1C6L-profile.md](meta/0x1C6L-profile.md) |  |
| `0x1C7L` | `0x00001C70` | DOC-ID | Meta | 14 | [0x1C7L-doc-id.md](meta/0x1C7L-doc-id.md) |  |
| `0x1C8L` | `0x00001C80` | EFFECTIVE-FROM | Meta | 14 | [0x1C8L-effective-from.md](meta/0x1C8L-effective-from.md) |  |
| `0x1C9L` | `0x00001C90` | EFFECTIVE-UNTIL | Meta | 14 | [0x1C9L-effective-until.md](meta/0x1C9L-effective-until.md) |  |
| `0x1CAL` | `0x00001CA0` | DEFAULT-LANGUAGE | Meta | 14 | [0x1CAL-default-language.md](meta/0x1CAL-default-language.md) |  |
| `0x1CBL` | `0x00001CB0` | AUTHOR | Meta | 14 | [0x1CBL-author.md](meta/0x1CBL-author.md) |  |
| `0x1CCL` | `0x00001CC0` | CO-AUTHOR | Meta | 14 | [0x1CCL-co-author.md](meta/0x1CCL-co-author.md) |  |
| `0x1CDL` | `0x00001CD0` | CREATED-AT | Meta | 14 | [0x1CDL-created-at.md](meta/0x1CDL-created-at.md) |  |
| `0x1CEL` | `0x00001CE0` | MODIFIED-AT | Meta | 14 | [0x1CEL-modified-at.md](meta/0x1CEL-modified-at.md) |  |
| `0x1CFL` | `0x00001CF0` | RECORDED-BY | Meta | 14 | [0x1CFL-recorded-by.md](meta/0x1CFL-recorded-by.md) |  |
| `0x1D0L` | `0x00001D00` | RECORDED-AT | Meta | 14 | [0x1D0L-recorded-at.md](meta/0x1D0L-recorded-at.md) |  |
| `0x1D1L` | `0x00001D10` | PARENT | Meta | 14 | [0x1D1L-parent.md](meta/0x1D1L-parent.md) |  |
| `0x1D2L` | `0x00001D20` | DERIVED-FROM | Meta | 14 | [0x1D2L-derived-from.md](meta/0x1D2L-derived-from.md) |  |
| `0x1D3L` | `0x00001D30` | GENERATED-BY | Meta | 14 | [0x1D3L-generated-by.md](meta/0x1D3L-generated-by.md) |  |
| `0x1D4L` | `0x00001D40` | TRANSFORMED-BY | Meta | 14 | [0x1D4L-transformed-by.md](meta/0x1D4L-transformed-by.md) |  |
| `0x1D5L` | `0x00001D50` | CHERRY-PICKED-FROM | Meta | 14 | [0x1D5L-cherry-picked-from.md](meta/0x1D5L-cherry-picked-from.md) |  |
| `0x1D6L` | `0x00001D60` | REVERTS | Meta | 14 | [0x1D6L-reverts.md](meta/0x1D6L-reverts.md) |  |
| `0x1D7L` | `0x00001D70` | REPLACES | Meta | 14 | [0x1D7L-replaces.md](meta/0x1D7L-replaces.md) |  |
| `0x1D8L` | `0x00001D80` | SQUASHED-FROM | Meta | 14 | [0x1D8L-squashed-from.md](meta/0x1D8L-squashed-from.md) |  |
| `0x1D9L` | `0x00001D90` | MESSAGE | Meta | 14 | [0x1D9L-message.md](meta/0x1D9L-message.md) |  |
| `0x1DAL` | `0x00001DA0` | TAG | Meta | 14 | [0x1DAL-tag.md](meta/0x1DAL-tag.md) |  |
| `0x1DBL` | `0x00001DB0` | DELTA-BASE | Meta | 14 | [0x1DBL-delta-base.md](meta/0x1DBL-delta-base.md) |  |
| `0x1DCL` | `0x00001DC0` | DELTA-REMOVE | Meta | 14 | [0x1DCL-delta-remove.md](meta/0x1DCL-delta-remove.md) |  |
| `0x1DDL` | `0x00001DD0` | NEXT-LOCAL-ID | Meta | 14 | [0x1DDL-next-local-id.md](meta/0x1DDL-next-local-id.md) |  |
| `0x1DEL` | `0x00001DE0` | LICENSE | Meta | 14 | [0x1DEL-license.md](meta/0x1DEL-license.md) |  |
| `0x1DFL` | `0x00001DF0` | ACCESS | Meta | 14 | [0x1DFL-access.md](meta/0x1DFL-access.md) |  |
| `0x1E0L` | `0x00001E00` | PRIVACY | Meta | 15 | [0x1E0L-privacy.md](meta/0x1E0L-privacy.md) |  |
| `0x1E1L` | `0x00001E10` | RETENTION | Meta | 15 | [0x1E1L-retention.md](meta/0x1E1L-retention.md) |  |
| `0x1E2L` | `0x00001E20` | CONSENT | Meta | 15 | [0x1E2L-consent.md](meta/0x1E2L-consent.md) |  |
| `0x1E3L` | `0x00001E30` | USAGE | Meta | 15 | [0x1E3L-usage.md](meta/0x1E3L-usage.md) |  |
| `0x1E4L` | `0x00001E40` | IMPORT-DOC | Meta | 15 | [0x1E4L-import-doc.md](meta/0x1E4L-import-doc.md) |  |
| `0x1E5L` | `0x00001E50` | ISSUER-KEY | Meta | 15 | [0x1E5L-issuer-key.md](meta/0x1E5L-issuer-key.md) |  |
| `0x1E6L` | `0x00001E60` | SIGNATURE | Meta | 15 | [0x1E6L-signature.md](meta/0x1E6L-signature.md) |  |
| `0x1E7L` | `0x00001E70` | SIGNED-OFF | Meta | 15 | [0x1E7L-signed-off.md](meta/0x1E7L-signed-off.md) |  |
| `0x1E8L` | `0x00001E80` | CONFIDENCE | Meta | 15 | [0x1E8L-confidence.md](meta/0x1E8L-confidence.md) |  |
| `0x1E9L` | `0x00001E90` | VERDICT | Meta | 15 | [0x1E9L-verdict.md](meta/0x1E9L-verdict.md) |  |
