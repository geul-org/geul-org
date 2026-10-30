---
title: "TOULMIN"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-31T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "TOULMIN Edge(Codec 0x60~0x7B)는 툴민 논증 모델로 판정·실행 그래프를 쓴다. 이 페이지는 TOULMIN 문서 규칙, 공통 필드, 코드 표, 수치 규칙과 자기 개정의 고정 핵심을 정한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TOULMIN 계열 Edge(Codec 상위 2비트 `11`, 직접 코드 `0x60`~`0x7B`)는 툴민 논증 모델로 판정·실행 그래프를 쓴다. 주장·반박·예외의 선언, 공격·배제 관계, 실행 연결, 판정 결과가 모두 Edge다. TANGEUL 문서(toulmin 엔진의 규칙 언어) 하나가 GEUL 문서 하나가 된다. 파일 확장자는 다른 문서와 같은 `.geul`이다.

이 페이지가 정하지 않은 것은 [Edge](/ko/grammar/edge/)와 [레코드와 TAG WORD](/ko/grammar/record/)의 공통 규칙을 따른다.

## 메타 인지와 자기 개정

TOULMIN이 GEUL Codec인 이유는 GEUL이 자기 자신을 메타 인지하기 위해서다. 판정·실행 규칙도 GEUL로 서술되어야 TOULMIN이 그 규칙을 대상으로 삼아 스스로 고칠 수 있다. 그래서 TOULMIN은 응용 프로파일이 아니라 GEUL 운용의 핵심이며, Edge 직접 코드 공간(`0x60`~`0x7B`)에 둔다.

- 자기 서술은 자기 개선을 가능하게 하지만 순환 오류의 위험을 진다. 규칙이 자기 개정을 스스로 판정하면 판정 기준을 느슨하게 만드는 개정도 통과할 수 있다(통과율은 오르고 실제 정확도는 떨어진다).
- 순환은 위험으로 받아들이되 구조로 끊는다.
  - **고정 핵심**: 판정의 의미(Pass·Review·Fail, 공격·배제·우선순위, 아래 [미상 위에서 판정하기](#미상-위에서-판정하기)의 3값 평가와 U → Review)는 이 명세에 고정한다. TOULMIN 문서로 바꿀 수 없다. 디코더에 내장하는 규칙([공표 주소와 버전 목록](/ko/grammar/publishing/#층)의 0층)과 같은 자리다.
  - **판본 분리**: 규칙 문서 v(n)의 개정은 v(n−1) 규칙과 외부 검사로 판정한다. 규칙은 자기 자신을 판정하지 않는다. 판정 결과는 대상과 다른 문서에 둔다(대상의 내용 해시가 바뀌지 않는다).
  - **불변 이력**: 개정은 새 버전으로 쌓인다(`PARENT`, 내용 해시, 서명). 옛 버전이 남으므로 순환 오류를 사후에 찾아 되돌릴 수 있다. 자기 개정의 안전망은 GEUL의 판본 모델이다([문서](/ko/grammar/document/#개정)).
  - **바깥 기준**: 개정 경로가 손댈 수 없는 시험 사례 묶음을 따로 둔다. 개정의 채택은 이 묶음의 결과로 확인한다.
- 반증 시험: 일부러 틀린 규칙을 하나 심는다. 시스템이 그것을 고치고 바깥 기준 점수가 오르면 자기 개선이 작동한다. 통과율만 오르고 바깥 기준 점수가 떨어지면 순환 오류다.

## 코드

TOULMIN 레코드는 세 가지 레이아웃 중 하나를 쓴다. 레이아웃은 Codec(또는 형식 번호)이 정한다.

| 레이아웃 | 쓰임 | 페이지 |
|---|---|---|
| NODE | 사안·규칙·정의·진입점 같은 그래프 노드 | [NODE](/ko/grammar/edge/toulmin/node/) |
| LINK | 노드 사이의 관계(공격, 배제, 실행, 정의) | [LINK](/ko/grammar/edge/toulmin/link/) |
| EXPR | 조건식(술어) | [EXPR](/ko/grammar/edge/toulmin/expr/) |

원문과 구획 레코드(SOURCE, TEXT, SECTION, CASE-BEGIN·CASE-END, PROSE)는 [SOURCE와 구획](/ko/grammar/edge/toulmin/source/)이 정한다.

### 직접 코드

| Codec | 이름 | 레이아웃 | TANGEUL | 뜻 |
|---|---|---|---|---|
| `0x60` | [CASE-DECLARE](/ko/grammar/edge/toulmin/node/) | NODE | `in case of` | 사안 선언. 노드와 관계를 담는 판정 그래프 |
| `0x61` | [PREDICATE-DECLARE](/ko/grammar/edge/toulmin/expr/) | EXPR | Rules의 조건식 | 술어 선언. 판정 식 |
| `0x62` | [SPEC-DECLARE](/ko/grammar/edge/toulmin/node/) | NODE | Definitions 항목 | 판단 기준 선언(Backing). role 비트가 정의 종류 |
| `0x63` | [RULE-DECLARE](/ko/grammar/edge/toulmin/node/) | NODE | general rule, Rules의 규칙 이름 | 주장 선언(Warrant). 공격받을 수 있다 |
| `0x64` | [COUNTER-DECLARE](/ko/grammar/edge/toulmin/node/) | NODE | counter rule | 반박 선언. 자기 결론을 가지고 공격한다. 기본 Level은 Fail |
| `0x65` | [EXCEPT-DECLARE](/ko/grammar/edge/toulmin/node/) | NODE | except rule | 예외 선언. 자기 결론 없이 공격한다. 기본 Level은 Review |
| `0x68` | [ATTACKS](/ko/grammar/edge/toulmin/link/) | LINK | `don't X when Y` | 공격 관계. 공격자의 판정이 대상의 판정을 공격 세기(0~1, 기본 1)만큼 점진적으로 깎는다 |
| `0x69` | [SUPERSEDES](/ko/grammar/edge/toulmin/link/) | LINK | `X supersedes Y` | 배제 관계. 공격자가 Active이면 대상을 집계에서 결정적으로 뺀다. 사슬(`A > B > C`)은 쌍마다 하나씩 쓴다 |
| `0x6A` | SUPERSEDE-CHAIN | — | | 우선순위 사슬 `A > B > C`. 쌍별 SUPERSEDES의 축약. 코드만 배정했고 레이아웃은 아직 없다 |
| `0x70` | [RUN](/ko/grammar/edge/toulmin/link/) | LINK | `run c when n` | 실행 합성. 노드가 Active이면 하위 사안을 실행한다(DAG) |
| `0x71` | [DO](/ko/grammar/edge/toulmin/link/) | LINK | `do fn when n` | 노드가 Active이면 수행하는 동작 |
| `0x72` | [DO-ONCE](/ko/grammar/edge/toulmin/link/) | LINK | `do fn once when n` | 재시도해도 한 번만 수행하는 동작 |
| `0x73` | [UNDO](/ko/grammar/edge/toulmin/link/) | LINK | `undo fn when n` | DO의 보상 동작(saga). 이후 단계가 실패하면 역순으로 수행한다 |
| `0x74` | [CHECKING](/ko/grammar/edge/toulmin/link/) | LINK | `checking c` | 부작용 없이 판정만 하는 연결 |
| `0x75` | [ENTRY](/ko/grammar/edge/toulmin/node/) | NODE | `provides x` | 외부 진입점. 사안을 실행하거나 판정한다 |
| `0x76` | [TRIGGER](/ko/grammar/edge/toulmin/node/) | NODE | `on`, `every`, `until` | 외부 호출 없는 이벤트·주기 진입점 |
| `0x78` | VERDICT | — | | 노드·레코드의 판정 결과. 결과(Pass, Review, Fail), 판정값, Activated, Excluded, Level. 코드만 배정했고 레이아웃은 아직 없다 |
| `0x79` | EVIDENCE | — | | 판정의 증거. 위치, 기대값, 실제값(Fact). 코드만 배정했고 레이아웃은 아직 없다 |
| `0x7C`~`0x7F` | ISSUER-* | | | Issuer가 정의한 형식. 아래 ISSUER 형식 |

- 표에 없는 직접 코드(`0x66`·`0x67`, `0x6B`~`0x6F`, `0x77`, `0x7A`·`0x7B`)는 예약이다.
- Codec 하위 5비트의 상위 2비트가 묶음이다: `00` 선언, `01` 관계, `10` 실행, `11` 결과(`0x7C`~`0x7F`는 ISSUER).
- 문서 전체의 판정은 Meta [VERDICT](/ko/grammar/meta/verification/verdict/)(`0x44`)가, 노드·레코드의 판정은 TOULMIN `VERDICT`(Edge `0x78`)가 맡는다. 둘은 Kind가 다른 별개의 Codec이다.

### ISSUER 형식

직접 코드가 모자란 TOULMIN 레코드는 `ISSUER-1WORD`(`0x7C`), Issuer `0x0000`(GEUL) 아래 형식 번호로 둔다. 형식 번호는 TOULMIN 계열(`0xC000`~`0xFFFF`, 상위 2비트 `11`)이다.

```
TAG WORD          0001 0LLL L111 1100      Edge, Codec 0x7C
[Length 확장 TAG]
Issuer            0x0000
형식 번호         0xC000~0xC029
Edge Id           LOCAL Reference 레코드
구성요소          형식이 정한 레이아웃
```

| 형식 번호 | 이름 | 레이아웃 | 뜻 |
|---|---|---|---|
| `0xC000` | [SOURCE](/ko/grammar/edge/toulmin/source/) | ID, SPAN 폭 WORD, UTF8 Value | 저작 원문 |
| `0xC001` | [TEXT](/ko/grammar/edge/toulmin/source/) | ID, UTF8 Value | 이름·문자열 |
| `0xC002` | [SECTION](/ko/grammar/edge/toulmin/source/) | ID, 섹션 코드 1 WORD | 섹션 시작 |
| `0xC003` | [CASE-BEGIN](/ko/grammar/edge/toulmin/source/) | ID, REF(사안) | 사안 범위 시작 |
| `0xC004` | [CASE-END](/ko/grammar/edge/toulmin/source/) | ID, REF(사안) | 사안 범위 끝 |
| `0xC005` | [PROSE](/ko/grammar/edge/toulmin/source/) | ID, SPAN | 서술 문단 |
| `0xC010` | [NAMESPACE](/ko/grammar/edge/toulmin/node/) | NODE | `this document is` |
| `0xC011` | [FUNC](/ko/grammar/edge/toulmin/node/) | NODE | 함수 참조 |
| `0xC012` | [FIELD](/ko/grammar/edge/toulmin/node/) | NODE | `is required` |
| `0xC013` | [ALIAS](/ko/grammar/edge/toulmin/node/) | NODE | `see … from` |
| `0xC014` | [GROUP](/ko/grammar/edge/toulmin/node/) | NODE | 순서 있는 실행 묶음 |
| `0xC020` | [REQUIRES](/ko/grammar/edge/toulmin/link/) | LINK | 사안 → 필드 |
| `0xC021` | [MEANS](/ko/grammar/edge/toulmin/link/) | LINK | 정의 항목 → 값·타입 |
| `0xC022` | [HAS](/ko/grammar/edge/toulmin/link/) | LINK | 정의 항목 → 필드 |
| `0xC023` | [RUNS](/ko/grammar/edge/toulmin/link/) | LINK | 진입점 → 사안, 실행 |
| `0xC024` | [EVALUATES](/ko/grammar/edge/toulmin/link/) | LINK | 진입점 → 사안, 판정 |
| `0xC025` | [TRIGGERS](/ko/grammar/edge/toulmin/link/) | LINK | 트리거 → 사안 |
| `0xC026` | [UNTIL](/ko/grammar/edge/toulmin/link/) | LINK | 트리거 → 사안(`every … until`) |
| `0xC027` | [SAME-AS](/ko/grammar/edge/toulmin/link/) | LINK | 노드 → 전역 식별자 |
| `0xC028` | [IMPORTED-FROM](/ko/grammar/edge/toulmin/link/) | LINK | 별칭 → 경로(TEXT) |
| `0xC029` | [LABEL](/ko/grammar/edge/toulmin/link/) | LINK | 노드 → TEXT, 이름 표기 |

- 형식 번호 공간은 Kind마다 따로다. Value의 GEUL 형식 `0xC000`(OPAQUE-BYTES-EVEN)과 Edge의 `0xC000`(SOURCE)은 다른 형식이다.
- 형식 번호는 추가만 한다. 배정한 번호는 다른 형식에 다시 쓰지 않는다.

## 문서

`.geul` 파일 하나는 DOC 하나다. DOC 밖에 다른 바이트를 두지 않는다.

```
DOC-1WORD/2WORD/4WORD     전체 길이
  SPEC-VERSION            0x0001 (v1, 내장 Value 없는 정수)
  PROFILE                 UTF8 Value "tangeul-<major>.<minor>". 현재 "tangeul-1.0"
  [DEFAULT-LANGUAGE]      LANGUAGE-BCP47-CODE Value. 작성 로케일("en", "ko")
BODY
  SOURCE                  저작 원문. BODY의 첫 레코드
  문장 레코드 …            문서 선언 순서
END
```

- HEAD: [SPEC-VERSION](/ko/grammar/meta/declaration/spec-version/), [PROFILE](/ko/grammar/meta/declaration/profile/), 선택 [DEFAULT-LANGUAGE](/ko/grammar/meta/declaration/default-language/).
- 디코더는 SPEC-VERSION이 다르거나 PROFILE의 major가 다르면 거부한다. minor가 달라도 읽는다.
- BODY의 첫 레코드는 SOURCE다. 모든 SPAN은 이 원문 안의 범위다.
- 문장 레코드의 순서는 문서 선언 순서와 같다. 실행 순서(`do`·`run` 발화, `undo` 역순 보상)가 이 순서에 기댄다. TOULMIN 문서는 Edge 순서에 의미가 있다([Edge](/ko/grammar/edge/) 순서 규칙의 예외).
- BODY의 모든 레코드는 Edge다. 독립 Value 레코드를 두지 않는다. 값은 Edge Payload에 내장한다.
- 사안의 정체와 가져오기는 Meta [DOC-ID](/ko/grammar/meta/declaration/doc-id/)·[IMPORT-DOC](/ko/grammar/meta/import/import-doc/)을 쓴다(TANGEUL의 Subject·See).

## 공통 필드

| 필드 | 폭 | 설명 |
|---|---|---|
| ID | LOCAL Reference 레코드 | 레코드의 Edge Id. 모든 레코드의 Payload 첫 요소 |
| REF | LOCAL Reference 레코드 | 이 문서의 다른 레코드를 가리키는 Edge Id. `0`은 없음 |
| SPAN | SOURCE가 정한 폭 × 2 | 저작 원문 안의 범위. 시작 바이트, 바이트 수 |

- ID와 REF는 내장 [LOCAL](/ko/grammar/reference/local/) Reference 레코드(`0000 0LLL L000 1000` + 가장 짧은 폭의 ID)다. 폭은 그 레코드의 Length가 정하며 문서 단위로 선언하지 않는다.
- REF `0`(LOCAL `0`)은 "없음"이다. LOCAL `0`을 없음으로 쓰는 Codec 규칙이다([LOCAL](/ko/grammar/reference/local/)).
- Edge Id는 1부터 배정하며 문서 안에서 중복하지 않는다. `0`은 REF의 "없음"이라 Edge Id로 쓰지 않는다.
- 노드는 다른 레코드가 전방 참조하므로 문서 선언 순서로 먼저 번호를 받는다. 그 밖의 레코드(SOURCE, TEXT, LINK, FUNC, 구획 레코드)는 노드 다음 번호부터 인코더가 배정한다.
- 디코더는 Edge Id가 0이 아니고 중복이 없는지만 확인한다. 배정 순서는 해석에 쓰지 않는다.
- 노드와 관계는 Edge Id로 가리킨다.
- 내장 Value는 TAG WORD를 포함한 Value 레코드 그대로다. 길이는 그 TAG가 정한다.

## 수치

- 판정값(−1~1), Qualifier(0~1), 공격 세기(0~1)는 [SIGNED-DECIMAL](/ko/grammar/value/decimal/signed-decimal/) Value다. 고정 소수 형식을 따로 두지 않는다.
- 인코더는 계수의 끝 0을 지운다. 0.8은 `C=8, E=−1`이다. 디코더는 소수 4자리까지 받는다.
- 확신도 게이트(예: `at least 75%`)는 비교 연산자 1 WORD와 퍼센트 [UNSIGNED-DECIMAL](/ko/grammar/value/decimal/unsigned-decimal/) Value(`E=0`)로 쓴다([LINK](/ko/grammar/edge/toulmin/link/) F_GATE).
- 공격 세기는 ATTACKS의 F_FORCE 필드다([LINK](/ko/grammar/edge/toulmin/link/#공격-세기)). 범위를 벗어나면 거부한다.

## 노드 선언의 축

- 노드 선언(RULE·COUNTER·EXCEPT-DECLARE)은 역할(주장·반박·예외), Qualifier(0~1), Level(Unset, Fail, Review)을 가진다. 역할은 Codec과 NODE 헤더의 role이, Qualifier는 F_QUAL이, Level은 헤더의 level이 담는다([NODE](/ko/grammar/edge/toulmin/node/)).
- 강도(Strict, Defeasible, Defeater)는 역할과 별개의 축이다. 강도의 배치는 아직 정하지 않았다.
- 공격 세기(Force)는 노드가 아니라 ATTACKS 간선의 값이다([LINK](/ko/grammar/edge/toulmin/link/#공격-세기) F_FORCE). 강도와 다른 축이다.

## 미상 위에서 판정하기

판정 그래프가 GEUL 사실을 입력으로 받을 때 [자리 표지](/ko/grammar/reference/slot-marker/)의 세 개념(적지 않음, 알 수 없음, 없음)은 다르게 평가한다. [EXPR](/ko/grammar/edge/toulmin/expr/) 비교 연산자의 평가는 다음과 같다.

| 입력 | `is empty` | `is not empty` | `equals` / `is in` / 크기 비교 |
|---|---|---|---|
| 값 v | 거짓 | 참 | v로 평가 |
| NO-VALUE (없음) | **참** | 거짓 | 거짓 |
| UNKNOWN-VALUE (알 수 없음) | 거짓 | **참** | **미정(U)** |
| ABSENT (적지 않음) / 서술 없음 | U (열린 세계) | U | U |

- 논리는 Kleene 강 3값을 쓴다. `NOT U = U`, `거짓 AND U = 거짓`, `참 OR U = 참`. 나머지 조합의 U는 U다.
- `EXISTS any`는 원소 중 하나라도 참이면 참이다. 참은 없고 U가 있으면 U, 모두 거짓이면 거짓이다.
- **술어가 U이면 그 노드의 판정은 Pass·Fail이 아니라 Review다.** 모르면 사람(또는 다음 단계)에게 넘긴다.
- ABSENT를 U가 아니라 empty로 보려면 입력 쪽이 닫힌 세계를 **선언**해야 한다(판단 기준 SPEC으로 주입, 예: "이 사안의 입력은 완전하다"). 선언이 없으면 U다.
- 이 표와 U → Review 대응은 판정의 의미라 **고정 핵심**이다. TOULMIN 문서로 바꿀 수 없다.
- 예: "지금도 유효한 국경만 센다"(`P582 is empty`) 규칙은 P582 = UNKNOWN-VALUE면 거짓이라 제외하고, P582 = NO-VALUE면 참이라 포함하며, P582가 없으면 U라서 Review로 보낸다.

## 판정 결과

- 판정 결과(`VERDICT`, `EVIDENCE`)는 판정 대상과 다른 문서에 둔다. 결과 문서가 대상 문서를 [IMPORT-DOC](/ko/grammar/meta/import/import-doc/)으로 가져와 [EXTERNAL-POINTER-*](/ko/grammar/reference/external-pointer/)로 가리킨다. 그래서 판정해도 대상 문서의 내용 해시는 바뀌지 않는다.
- 문서 전체의 판정은 Meta `VERDICT`, 노드·레코드의 판정은 TOULMIN `VERDICT`다.
- 개정의 적용 판본을 고르는 규칙(경과규정, 행위시법과 신법의 선택)과 해석례·판례도 판정 규칙으로 쓴다([문서](/ko/grammar/document/#개정)).

## 열린 문제

- SUPERSEDE-CHAIN(`0x6A`), VERDICT(`0x78`), EVIDENCE(`0x79`)의 레이아웃. SUPERSEDES를 쌍마다 쓰는 지금 방식으로 사슬이 충분한지.
- 노드 강도(Strict, Defeasible, Defeater)의 배치.
- 공격 세기 1을 적은 ATTACKS와 적지 않은 ATTACKS는 판정이 같지만 바이트가 다르다. 판정이 같은지는 바이트가 아니라 해석한 값으로 비교해야 한다.
- EXPR 안의 노드 수, 라벨 수, 라벨 인덱스는 1 WORD이고 자식 수는 13비트다. 상한이 고정되어 있다.
- PROVENANCE(규칙 출처·전제) 레이아웃.
- 백틱 이름을 TEXT + LABEL(`0xC029`) 대신 서술 [LABEL](/ko/grammar/edge/label/)·[BIND](/ko/grammar/edge/bind/)로 둘지.
- Claim의 predicate·mode 코드값과 FuncRef의 VerbCode 코드값 표.
- 닫힌 세계 선언(ABSENT를 empty로 읽기)을 판단 기준(SPEC)으로 할지 사안 단위로 할지.
- TOULMIN Codec의 [Codec 규격 문서](/ko/grammar/codec-spec/). NODE·LINK의 조건부 필드와 SOURCE가 정하는 SPAN 폭은 FIELD로 선언할 수 없는 레이아웃이다.

## 관련 페이지

- [NODE](/ko/grammar/edge/toulmin/node/), [LINK](/ko/grammar/edge/toulmin/link/), [EXPR](/ko/grammar/edge/toulmin/expr/), [SOURCE와 구획](/ko/grammar/edge/toulmin/source/)
- [Edge](/ko/grammar/edge/), [문서](/ko/grammar/document/), [PROFILE](/ko/grammar/meta/declaration/profile/)
