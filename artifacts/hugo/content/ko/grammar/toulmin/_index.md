---
title: "TOULMIN"
weight: 130
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "툴민 논증 모델로 판정·실행 그래프를 쓴다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

툴민 논증 모델로 판정·실행 그래프를 쓴다. GEUL이 자기 규칙을 GEUL로 서술하고 스스로 고치기 위한 핵심 계열이다.

| 묶음 | Codec |
|---|---|
| 선언 | [CASE-DECLARE](0x100L-case-declare.md)(사안), [PREDICATE-DECLARE](0x101L-predicate-declare.md)(술어), [SPEC-DECLARE](0x102L-spec-declare.md)(판단 기준), [RULE-DECLARE](0x103L-rule-declare.md)(주장), [COUNTER-DECLARE](0x104L-counter-declare.md)(반박), [EXCEPT-DECLARE](0x105L-except-declare.md)(예외) — [NODE](#node) |
| 관계 | [ATTACKS](0x108L-attacks.md)(공격), [SUPERSEDES](0x109L-supersedes.md)(배제) — [LINK](#link), [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md)(우선순위 사슬, 레이아웃 미정) |
| 실행 | [RUN](0x110L-run.md), [DO](0x111L-do.md), [DO-ONCE](0x112L-do-once.md), [UNDO](0x113L-undo.md), [CHECKING](0x114L-checking.md) — [LINK](#link), [ENTRY](0x115L-entry.md), [TRIGGER](0x116L-trigger.md) — [NODE](#node) |
| 결과 | [VERDICT](0x118L-verdict.md)(판정 결과: Pass·Review·Fail), [EVIDENCE](0x119L-evidence.md)(판정의 증거) — 레이아웃 미정 |

- 원문·구획·보조 노드와 관계는 TOULMIN 형식 계열 직접 코드 `0x120L~0x134L`이다([SOURCE와 구획](#source와-구획), [TOULMIN](#toulmin-형식)).
- 판정 결과는 판정 대상과 다른 문서에 둔다. 결과 문서가 대상 문서를 가져와 가리킨다. 그래서 판정해도 대상 문서의 내용 해시는 바뀌지 않는다.

TOULMIN 계열 Edge(직접 코드 `0x100L~0x11BL`, 보조 레코드는 TOULMIN 형식 계열 `0x120L~0x134L`)는 툴민 논증 모델로 판정·실행 그래프를 쓴다. 주장·반박·예외의 선언, 공격·배제 관계, 실행 연결, 판정 결과가 모두 Edge다. TANGEUL 문서(toulmin 엔진의 규칙 언어) 하나가 GEUL 문서 하나가 된다. 파일 확장자는 다른 문서와 같은 `.geul`이다.

이 문서가 정하지 않은 것은 [Edge](../edge/_index.md) 공통 규칙과 [레코드와 TAG WORD](../record.md)를 따른다.

## 메타 인지와 자기 개정

TOULMIN이 GEUL Codec인 이유는 GEUL이 자기 자신을 메타 인지하기 위해서다. 판정·실행 규칙도 GEUL로 서술되어야 TOULMIN이 그 규칙을 대상으로 삼아 스스로 고칠 수 있다. 그래서 TOULMIN은 응용 프로파일이 아니라 GEUL 운용의 핵심이며, Edge 직접 코드 공간(`0x100L~0x11BL`)에 둔다.

- 자기 서술은 자기 개선을 가능하게 하지만 순환 오류의 위험을 진다. 규칙이 자기 개정을 스스로 판정하면 판정 기준을 느슨하게 만드는 개정도 통과할 수 있다(통과율은 오르고 실제 정확도는 떨어진다).
- 순환은 위험으로 받아들이되 구조로 끊는다.
  - **고정 핵심**: 판정의 의미(Pass·Review·Fail, 공격·배제·우선순위, 아래 [미상 위에서 판정하기](#미상-위에서-판정하기)의 3값 평가와 U → Review)는 이 명세에 고정한다. TOULMIN 문서로 바꿀 수 없다. 디코더에 내장하는 규칙([공표 주소와 버전 목록](../publishing.md#층)의 0층)과 같은 자리다.
  - **판본 분리**: 규칙 문서 v(n)의 개정은 v(n−1) 규칙과 외부 검사로 판정한다. 규칙은 자기 자신을 판정하지 않는다. 판정 결과는 대상과 다른 문서에 둔다(대상의 내용 해시가 바뀌지 않는다).
  - **불변 이력**: 개정은 새 버전으로 쌓인다(`PARENT`, 내용 해시, 서명). 옛 버전이 남으므로 순환 오류를 사후에 찾아 되돌릴 수 있다. 자기 개정의 안전망은 GEUL의 판본 모델이다([문서](../document.md#개정)).
  - **바깥 기준**: 개정 경로가 손댈 수 없는 시험 사례 묶음을 따로 둔다. 개정의 채택은 이 묶음의 결과로 확인한다.
- 반증 시험: 일부러 틀린 규칙을 하나 심는다. 시스템이 그것을 고치고 바깥 기준 점수가 오르면 자기 개선이 작동한다. 통과율만 오르고 바깥 기준 점수가 떨어지면 순환 오류다.

## 코드

TOULMIN 레코드는 세 가지 레이아웃 중 하나를 쓴다. 레이아웃은 Codec이 정한다.

| 레이아웃 | 쓰임 | 페이지 |
|---|---|---|
| NODE | 사안·규칙·정의·진입점 같은 그래프 노드 | [NODE](#node) |
| LINK | 노드 사이의 관계(공격, 배제, 실행, 정의) | [LINK](#link) |
| EXPR | 조건식(술어) | [EXPR](0x101L-predicate-declare.md) |

원문과 구획 레코드(SOURCE, TEXT, SECTION, CASE-BEGIN·CASE-END, PROSE)는 [SOURCE와 구획](#source와-구획)이 정한다.

### 직접 코드

| Codec | 이름 | 레이아웃 | TANGEUL | 뜻 |
|---|---|---|---|---|
| `0x100L` | [CASE-DECLARE](0x100L-case-declare.md) | NODE | `in case of` | 사안 선언. 노드와 관계를 담는 판정 그래프 |
| `0x101L` | [PREDICATE-DECLARE](0x101L-predicate-declare.md) | EXPR | Rules의 조건식 | 술어 선언. 판정 식 |
| `0x102L` | [SPEC-DECLARE](0x102L-spec-declare.md) | NODE | Definitions 항목 | 판단 기준 선언(Backing). role 비트가 정의 종류 |
| `0x103L` | [RULE-DECLARE](0x103L-rule-declare.md) | NODE | general rule, Rules의 규칙 이름 | 주장 선언(Warrant). 공격받을 수 있다 |
| `0x104L` | [COUNTER-DECLARE](0x104L-counter-declare.md) | NODE | counter rule | 반박 선언. 자기 결론을 가지고 공격한다. 기본 Level은 Fail |
| `0x105L` | [EXCEPT-DECLARE](0x105L-except-declare.md) | NODE | except rule | 예외 선언. 자기 결론 없이 공격한다. 기본 Level은 Review |
| `0x108L` | [ATTACKS](0x108L-attacks.md) | LINK | `don't X when Y` | 공격 관계. 공격자의 판정이 대상의 판정을 공격 세기(0~1, 기본 1)만큼 점진적으로 깎는다 |
| `0x109L` | [SUPERSEDES](0x109L-supersedes.md) | LINK | `X supersedes Y` | 배제 관계. 공격자가 Active이면 대상을 집계에서 결정적으로 뺀다. 사슬(`A > B > C`)은 쌍마다 하나씩 쓴다 |
| `0x10AL` | [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) | — | | 우선순위 사슬 `A > B > C`. 쌍별 SUPERSEDES의 축약. 코드만 배정했고 레이아웃은 아직 없다 |
| `0x110L` | [RUN](0x110L-run.md) | LINK | `run c when n` | 실행 합성. 노드가 Active이면 하위 사안을 실행한다(DAG) |
| `0x111L` | [DO](0x111L-do.md) | LINK | `do fn when n` | 노드가 Active이면 수행하는 동작 |
| `0x112L` | [DO-ONCE](0x112L-do-once.md) | LINK | `do fn once when n` | 재시도해도 한 번만 수행하는 동작 |
| `0x113L` | [UNDO](0x113L-undo.md) | LINK | `undo fn when n` | DO의 보상 동작(saga). 이후 단계가 실패하면 역순으로 수행한다 |
| `0x114L` | [CHECKING](0x114L-checking.md) | LINK | `checking c` | 부작용 없이 판정만 하는 연결 |
| `0x115L` | [ENTRY](0x115L-entry.md) | NODE | `provides x` | 외부 진입점. 사안을 실행하거나 판정한다 |
| `0x116L` | [TRIGGER](0x116L-trigger.md) | NODE | `on`, `every`, `until` | 외부 호출 없는 이벤트·주기 진입점 |
| `0x118L` | [VERDICT](0x118L-verdict.md) | — | | 노드·레코드의 판정 결과. 결과(Pass, Review, Fail), 판정값, Activated, Excluded, Level. 코드만 배정했고 레이아웃은 아직 없다 |
| `0x119L` | [EVIDENCE](0x119L-evidence.md) | — | | 판정의 증거. 위치, 기대값, 실제값(Fact). 코드만 배정했고 레이아웃은 아직 없다 |
| `0x11CL~0x11FL` | Reserved | | | |

- 표에 없는 직접 코드(`0x106L`·`0x107L`, `0x10BL`~`0x10FL`, `0x117L`, `0x11AL`·`0x11BL`)는 Reserved다.
- 묶음은 `0x100L~0x107L` 선언, `0x108L~0x10FL` 관계, `0x110L~0x117L` 실행, `0x118L~0x11FL` 결과다(`0x11CL~0x11FL`은 Reserved).
- 문서 전체의 판정은 Meta [VERDICT](../meta/0x1E9L-verdict.md)(`0x1E9L`)가, 노드·레코드의 판정은 TOULMIN `VERDICT`(Edge `0x118L`)가 맡는다. 둘은 Kind가 다른 별개의 Codec이다.

### TOULMIN 형식

원문·구획·보조 노드와 관계는 Edge TOULMIN 형식 계열 직접 코드 `0x120L~0x134L`에 둔다. Issuer와 코덱 번호 칸이 없고 TAG 뒤에 Payload가 바로 온다.

```
TAG WORD          0001 0010 0000 LLLL      Edge, Codec 0x120L (SOURCE). 다른 코드도 같은 자리
[Length 확장 TAG]
Edge Id           LOCAL Reference 레코드
구성요소          형식이 정한 레이아웃
```

| Codec | 이름 | 레이아웃 | 뜻 |
|---|---|---|---|
| `0x120L` | [SOURCE](0x120L-source.md) | ID, SPAN 폭 WORD, UTF8 Value | 저작 원문 |
| `0x121L` | [TEXT](0x121L-text.md) | ID, UTF8 Value | 이름·문자열 |
| `0x122L` | [SECTION](0x122L-section.md) | ID, 섹션 코드 1 WORD | 섹션 시작 |
| `0x123L` | [CASE-BEGIN](0x123L-case-begin.md) | ID, REF(사안) | 사안 범위 시작 |
| `0x124L` | [CASE-END](0x124L-case-end.md) | ID, REF(사안) | 사안 범위 끝 |
| `0x125L` | [PROSE](0x125L-prose.md) | ID, SPAN | 서술 문단 |
| `0x126L` | [NAMESPACE](0x126L-namespace.md) | NODE | `this document is` |
| `0x127L` | [FUNC](0x127L-func.md) | NODE | 함수 참조 |
| `0x128L` | [FIELD](0x128L-field.md) | NODE | `is required` |
| `0x129L` | [ALIAS](0x129L-alias.md) | NODE | `see … from` |
| `0x12AL` | [GROUP](0x12AL-group.md) | NODE | 순서 있는 실행 묶음 |
| `0x12BL` | [REQUIRES](0x12BL-requires.md) | LINK | 사안 → 필드 |
| `0x12CL` | [MEANS](0x12CL-means.md) | LINK | 정의 항목 → 값·타입 |
| `0x12DL` | [HAS](0x12DL-has.md) | LINK | 정의 항목 → 필드 |
| `0x12EL` | [RUNS](0x12EL-runs.md) | LINK | 진입점 → 사안, 실행 |
| `0x12FL` | [EVALUATES](0x12FL-evaluates.md) | LINK | 진입점 → 사안, 판정 |
| `0x130L` | [TRIGGERS](0x130L-triggers.md) | LINK | 트리거 → 사안 |
| `0x131L` | [UNTIL](0x131L-until.md) | LINK | 트리거 → 사안(`every … until`) |
| `0x132L` | [SAME-AS](0x132L-same-as.md) | LINK | 노드 → 전역 식별자 |
| `0x133L` | [IMPORTED-FROM](0x133L-imported-from.md) | LINK | 별칭 → 경로(TEXT) |
| `0x134L` | [LABEL](0x134L-label.md) | LINK | 노드 → TEXT, 이름 표기 |

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

- HEAD: [SPEC-VERSION](../meta/0x1C5L-spec-version.md), [PROFILE](../meta/0x1C6L-profile.md), 선택 [DEFAULT-LANGUAGE](../meta/0x1CAL-default-language.md).
- 디코더는 SPEC-VERSION이 다르거나 PROFILE의 major가 다르면 거부한다. minor가 달라도 읽는다.
- BODY의 첫 레코드는 SOURCE다. 모든 SPAN은 이 원문 안의 범위다.
- 문장 레코드의 순서는 문서 선언 순서와 같다. 실행 순서(`do`·`run` 발화, `undo` 역순 보상)가 이 순서에 기댄다. TOULMIN 문서는 Edge 순서에 의미가 있다([Edge 레이아웃](../edge/_index.md#레이아웃) 순서 규칙의 예외).
- BODY의 모든 레코드는 Edge다. 독립 Value 레코드를 두지 않는다. 값은 Edge Payload에 내장한다.
- 사안의 정체와 가져오기는 Meta [DOC-ID](../meta/0x1C7L-doc-id.md)·[IMPORT-DOC](../meta/0x1E4L-import-doc.md)을 쓴다(TANGEUL의 Subject·See).

## 공통 필드

| 필드 | 폭 | 설명 |
|---|---|---|
| ID | LOCAL Reference 레코드 | 레코드의 Edge Id. 모든 레코드의 Payload 첫 요소 |
| REF | LOCAL Reference 레코드 | 이 문서의 다른 레코드를 가리키는 Edge Id. `0`은 없음 |
| SPAN | SOURCE가 정한 폭 × 2 | 저작 원문 안의 범위. 시작 바이트, 바이트 수 |

- ID와 REF는 내장 [LOCAL](../reference/0x005L-local.md) Reference 레코드(`0000 0000 0101 LLLL` + 가장 짧은 폭의 ID)다. 폭은 그 레코드의 Length가 정하며 문서 단위로 선언하지 않는다.
- REF `0`(LOCAL `0`)은 "없음"이다. LOCAL `0`을 없음으로 쓰는 Codec 규칙이다([LOCAL](../reference/0x005L-local.md)).
- Edge Id는 1부터 배정하며 문서 안에서 중복하지 않는다. `0`은 REF의 "없음"이라 Edge Id로 쓰지 않는다.
- 노드는 다른 레코드가 전방 참조하므로 문서 선언 순서로 먼저 번호를 받는다. 그 밖의 레코드(SOURCE, TEXT, LINK, FUNC, 구획 레코드)는 노드 다음 번호부터 인코더가 배정한다.
- 디코더는 Edge Id가 0이 아니고 중복이 없는지만 확인한다. 배정 순서는 해석에 쓰지 않는다.
- 노드와 관계는 Edge Id로 가리킨다.
- 내장 Value는 TAG WORD를 포함한 Value 레코드 그대로다. 길이는 그 TAG가 정한다.

## 수치

- 판정값(−1~1), Qualifier(0~1), 공격 세기(0~1)는 [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md) Value다. 고정 소수 형식을 따로 두지 않는다.
- 인코더는 계수의 끝 0을 지운다. 0.8은 `C=8, E=−1`이다. 디코더는 소수 4자리까지 받는다.
- 확신도 게이트(예: `at least 75%`)는 비교 연산자 1 WORD와 퍼센트 [UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md) Value(`E=0`)로 쓴다([LINK](#link) F_GATE).
- 공격 세기는 ATTACKS의 F_FORCE 필드다([LINK](#공격-세기)). 범위를 벗어나면 거부한다.

## 노드 선언의 축

- 노드 선언(RULE·COUNTER·EXCEPT-DECLARE)은 역할(주장·반박·예외), Qualifier(0~1), Level(Unset, Fail, Review)을 가진다. 역할은 Codec과 NODE 헤더의 role이, Qualifier는 F_QUAL이, Level은 헤더의 level이 담는다([NODE](#node)).
- 강도(Strict, Defeasible, Defeater)는 역할과 별개의 축이다. 강도의 배치는 아직 정하지 않았다.
- 공격 세기(Force)는 노드가 아니라 ATTACKS 간선의 값이다([LINK](#공격-세기) F_FORCE). 강도와 다른 축이다.

## 미상 위에서 판정하기

판정 그래프가 GEUL 사실을 입력으로 받을 때 [자리 표지](../slot-marker.md)의 세 개념(적지 않음, 알 수 없음, 없음)은 다르게 평가한다. [EXPR](0x101L-predicate-declare.md) 비교 연산자의 평가는 다음과 같다.

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

- 판정 결과(`VERDICT`, `EVIDENCE`)는 판정 대상과 다른 문서에 둔다. 결과 문서가 대상 문서를 [IMPORT-DOC](../meta/0x1E4L-import-doc.md)으로 가져와 [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md)로 가리킨다. 그래서 판정해도 대상 문서의 내용 해시는 바뀌지 않는다.
- 문서 전체의 판정은 Meta `VERDICT`, 노드·레코드의 판정은 TOULMIN `VERDICT`다.
- 개정의 적용 판본을 고르는 규칙(경과규정, 행위시법과 신법의 선택)과 해석례·판례도 판정 규칙으로 쓴다([문서](../document.md#개정)).

## 열린 문제

- SUPERSEDE-CHAIN(`0x10AL`), VERDICT(`0x118L`), EVIDENCE(`0x119L`)의 레이아웃. SUPERSEDES를 쌍마다 쓰는 지금 방식으로 사슬이 충분한지.
- 노드 강도(Strict, Defeasible, Defeater)의 배치.
- 공격 세기 1을 적은 ATTACKS와 적지 않은 ATTACKS는 판정이 같지만 바이트가 다르다. 판정이 같은지는 바이트가 아니라 해석한 값으로 비교해야 한다.
- EXPR 안의 노드 수, 라벨 수, 라벨 인덱스는 1 WORD이고 자식 수는 13비트다. 상한이 고정되어 있다.
- PROVENANCE(규칙 출처·전제) 레이아웃.
- 백틱 이름을 TEXT + LABEL(`0x134L`) 대신 서술 [LABEL](../edge/0x0A4L-label.md)·[BIND](../edge/0x0A3L-bind.md)로 둘지.
- Claim의 predicate·mode 코드값과 FuncRef의 VerbCode 코드값 표.
- 닫힌 세계 선언(ABSENT를 empty로 읽기)을 판단 기준(SPEC)으로 할지 사안 단위로 할지.
- TOULMIN Codec의 [Codec 규격 문서](../codec-spec.md). NODE·LINK의 조건부 필드와 SOURCE가 정하는 SPAN 폭은 FIELD로 선언할 수 없는 레이아웃이다.

## 관련 페이지

- [NODE](#node), [LINK](#link), [EXPR](0x101L-predicate-declare.md), [SOURCE와 구획](#source와-구획)
- [문서](../document.md), [PROFILE](../meta/0x1C6L-profile.md)

## NODE

NODE는 TOULMIN 판정·실행 그래프의 노드를 쓰는 레이아웃이다. 노드 종류는 Codec이 정하고, 헤더 1 WORD가 역할·Level·Claim 형태와 조건부 필드를 정한다.

### Codec

| Codec | 이름 | TANGEUL | 노드 |
|---|---|---|---|
| `0x100L` | [CASE-DECLARE](0x100L-case-declare.md) | `in case of` | 사안 |
| `0x102L` | [SPEC-DECLARE](0x102L-spec-declare.md) | Definitions 항목(`means`, `has`) | 판단 기준(Backing). role이 정의 종류 |
| `0x103L` | [RULE-DECLARE](0x103L-rule-declare.md) | general rule | 주장(Warrant) |
| `0x104L` | [COUNTER-DECLARE](0x104L-counter-declare.md) | counter rule | 반박(Rebuttal) |
| `0x105L` | [EXCEPT-DECLARE](0x105L-except-declare.md) | except rule | 예외(Defeater) |
| `0x115L` | [ENTRY](0x115L-entry.md) | `provides x` | 외부 진입점 |
| `0x116L` | [TRIGGER](0x116L-trigger.md) | `on`, `every`, `until` | 이벤트·주기 진입점 |
| `0x126L` | [NAMESPACE](0x126L-namespace.md) | `this document is` | 문서 이름공간 |
| `0x127L` | [FUNC](0x127L-func.md) | 함수 참조 | 바깥 함수(예: `bank.withdraw`) |
| `0x128L` | [FIELD](0x128L-field.md) | `x is required [as Type]` | 필수 필드 |
| `0x129L` | [ALIAS](0x129L-alias.md) | `see a from path` | 가져온 패키지 별칭 |
| `0x12AL` | [GROUP](0x12AL-group.md) | `1.` 순서 목록 | 순서 있는 실행 묶음 |

`0x126L~0x12AL`은 Edge TOULMIN 형식 계열 직접 코드다([TOULMIN](#toulmin-형식)).

### 레이아웃

```
ID               LOCAL Reference 레코드 (Edge Id)
헤더 1 WORD      role 2b | Reserved 2b | F_GROUNDS 1b | level 2b | object 종류 2b | flags 7b
[F_FUNC]         FuncRef: REF(ALIAS, 없으면 0) + VerbCode 1 WORD
[F_QUAL]         SIGNED-DECIMAL Value. Qualifier
[F_CHECK]        REF(사안)
[F_CLAIM]        Claim: REF(subject) + predicate 1 WORD + object + mode 1 WORD
[F_VERDICT]      SIGNED-DECIMAL Value. 판정값 초기값
[F_WITH]         개수(UNSIGNED-INTEGER Value) + REF(TEXT) × 개수
[F_GROUNDS]      개수(UNSIGNED-INTEGER Value) + REF(TEXT) × 개수
SPAN             SOURCE가 정한 폭 × 2 (시작 바이트, 바이트 수)
```

#### 헤더 WORD

| 비트 | 필드 | 값 |
|---|---|---|
| 15–14 | role | 0 general, 1 counter, 2 except |
| 13–12 | Reserved | 0 |
| 11 | F_GROUNDS | 근거 목록이 있다 |
| 10–9 | level | 0 Unset, 1 Fail, 2 Review (3 Reserved) |
| 8–7 | object 종류 | Claim object의 형태. 0 REF, 1 UNSIGNED-INTEGER Value, 2 SPAN |
| 6–0 | flags | 아래 표 |

| 비트 | flag | 뜻 |
|---|---|---|
| b0 | F_FUNC | FuncRef 필드가 있다 |
| b1 | F_QUAL | Qualifier 필드가 있다 |
| b2 | F_CHECK | `checking` 대상 사안 필드가 있다 |
| b3 | F_CLAIM | Claim 필드가 있다 |
| b4 | F_VERDICT | 판정값 초기값 필드가 있다 |
| b5 | F_STRIKE | 취소선으로 지운 선언이다. 필드가 없다 |
| b6 | F_WITH | 기준 목록 필드가 있다 |

- 조건부 필드는 flag 순서(F_FUNC, F_QUAL, F_CHECK, F_CLAIM, F_VERDICT, F_WITH, F_GROUNDS)로 둔다. flag가 꺼진 필드는 자리를 차지하지 않는다.
- flag가 켜졌는데 필드가 없으면 거부한다. 필드를 차례로 읽은 위치는 SPAN 뒤에서 레코드 끝과 정확히 맞아야 한다.

### 필드

| 필드 | 설명 |
|---|---|
| FuncRef | 함수 자리. REF는 그 함수를 가져온 ALIAS 레코드이고, 이 문서의 함수면 `0`이다. VerbCode는 1 WORD 코드이며 아직 배정하지 않았다(`0x0000` 허용). 함수의 원문 표기는 TEXT + [LABEL](#link)로 따로 쓴다 |
| Qualifier | 노드의 확신도(0~1) |
| 사안 | F_CHECK: 이 노드가 판정만 하는 사안(`checking c`) |
| Claim | 노드가 담는 명제. subject REF, predicate 1 WORD, object, mode 1 WORD. object의 형태는 헤더의 object 종류가 정한다 |
| 판정값 | 판정값의 초기값(−1~1) |
| F_WITH | 선언 시점의 판정 기준(`기준으로 하는`). TEXT 레코드 REF 목록 |
| F_GROUNDS | 평가 시점에 해석하는 외부 사실 이름(`근거로 하는`). TEXT 레코드 REF 목록 |
| SPAN | 이 선언이 나온 원문 범위 |

- 판정값·Qualifier의 표기는 [TOULMIN](#수치) 수치 규칙을 따른다.
- 목록의 개수는 내장 [UNSIGNED-INTEGER](../value/0x062L-unsigned-integer.md) Value 레코드다.
- 서술 Claim의 기본 형태는 subject·predicate가 `0`이고 object가 SPAN(object 종류 2)이다. 원문 표기에 고정한다.

### 해석과 유효성

- role은 RULE·COUNTER·EXCEPT-DECLARE에서 Codec과 같아야 한다(0 general, 1 counter, 2 except). SPEC-DECLARE에서는 정의 종류다. 그 밖의 Codec에서는 0이다.
- level이 0(Unset)이면 엔진의 기본값을 쓴다: COUNTER-DECLARE는 Fail, EXCEPT-DECLARE는 Review.
- TANGEUL `tangl:규칙`의 호스트 함수 규칙(`쓰는 규칙이다`)은 사안 밖의 RULE-DECLARE NODE로 쓴다. 함수는 F_FUNC, 기준은 F_WITH, 근거는 F_GROUNDS다. 조건식 규칙만 앞에 [PREDICATE-DECLARE](0x101L-predicate-declare.md)를 둔다.
- Reserved 비트(13–12)는 0이어야 한다. Reserved 비트가 켜졌거나 role이 Codec과 맞지 않으면 거부한다.

### 관련 페이지

- [TOULMIN](_index.md), [LINK](#link), [EXPR](0x101L-predicate-declare.md), [SOURCE와 구획](#source와-구획)
- [LOCAL](../reference/0x005L-local.md), [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md)

## LINK

LINK는 TOULMIN 그래프에서 노드 사이의 관계를 쓰는 레이아웃이다. 관계의 종류는 Codec이 정한다.

### Codec

| Codec | 이름 | TANGEUL | src → dst |
|---|---|---|---|
| `0x108L` | [ATTACKS](0x108L-attacks.md) | `don't X when Y` | 규칙 → 규칙. 판정을 공격 세기만큼 점진적으로 깎는다 |
| `0x109L` | [SUPERSEDES](0x109L-supersedes.md) | `X supersedes Y` | 규칙 → 규칙. Active이면 대상을 집계에서 뺀다 |
| `0x110L` | [RUN](0x110L-run.md) | `run c when n` | 규칙 → 사안 |
| `0x111L` | [DO](0x111L-do.md) | `do fn when n` | 규칙 → FuncRef |
| `0x112L` | [DO-ONCE](0x112L-do-once.md) | `do fn once when n` | 규칙 → FuncRef |
| `0x113L` | [UNDO](0x113L-undo.md) | `undo fn when n` | 규칙 → FuncRef |
| `0x114L` | [CHECKING](0x114L-checking.md) | `checking c` | 규칙 → 사안. 부작용 없는 판정 |
| `0x12BL` | [REQUIRES](0x12BL-requires.md) | `f is required` | 사안 → 필드 |
| `0x12CL` | [MEANS](0x12CL-means.md) | Definitions `means` | 정의 항목 → 값·타입 |
| `0x12DL` | [HAS](0x12DL-has.md) | Definitions `has` | 정의 항목 → 필드 |
| `0x12EL` | [RUNS](0x12EL-runs.md) | 진입점 `run c` | 진입점 → 사안(실행) |
| `0x12FL` | [EVALUATES](0x12FL-evaluates.md) | 진입점 `check c` | 진입점 → 사안(판정) |
| `0x130L` | [TRIGGERS](0x130L-triggers.md) | 트리거 `run c` | 트리거 → 사안 |
| `0x131L` | [UNTIL](0x131L-until.md) | `every … until c` | 트리거 → 사안 |
| `0x132L` | [SAME-AS](0x132L-same-as.md) | | 노드 → 전역 식별자 |
| `0x133L` | [IMPORTED-FROM](0x133L-imported-from.md) | `see a from path` | 별칭 → 경로(TEXT) |
| `0x134L` | [LABEL](0x134L-label.md) | 백틱 이름 | 노드 → TEXT. 이름 표기 |

### 레이아웃

```
ID               LOCAL Reference 레코드 (Edge Id)
src              REF
dst              REF. DO·DO-ONCE·UNDO는 FuncRef
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED, b4 F_FORCE
[F_GATE]         연산자 1 WORD(상위 2비트) + UNSIGNED-DECIMAL Value(퍼센트)
[F_FORCE]        SIGNED-DECIMAL Value. 공격 세기(0~1). ATTACKS만
SPAN             SOURCE가 정한 폭 × 2
```

| flag | 뜻 |
|---|---|
| b0 F_ONCE | 한 번만 수행한다(UNDO의 `once`) |
| b1 F_GATE | 확신도 게이트 필드가 있다 |
| b2 F_STRIKE | 취소선으로 지운 관계다 |
| b3 F_ORDERED | `1.` 순서 목록에 속한다 |
| b4 F_FORCE | 공격 세기 필드가 있다. ATTACKS만 |

| 게이트 연산자 | 뜻 |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

- 조건부 필드는 flag 순서(F_GATE, F_FORCE)로 둔다. flag가 꺼진 필드는 자리를 차지하지 않는다.

### 공격 세기

공격 세기(F_FORCE)는 [ATTACKS](0x108L-attacks.md#공격-세기)만 쓴다. 판정 식, 표기, 예시는 그 쪽에 있다.

### 해석과 유효성

- REF는 이 문서 레코드의 Edge Id다([TOULMIN](#공통-필드) 공통 필드).
- dst의 형태는 Codec이 정한다. DO·DO-ONCE·UNDO는 FuncRef(REF(ALIAS, 없으면 0) + VerbCode 1 WORD, [NODE](#필드)), LABEL·IMPORTED-FROM은 TEXT 레코드의 REF, 나머지는 노드의 REF다.
- `do … once`는 DO-ONCE Codec이 나타낸다. DO-ONCE의 flags에는 F_ONCE를 쓰지 않는다(켜져 있으면 거부한다). UNDO의 `once`는 F_ONCE로 쓴다.
- 게이트 연산자는 연산자 WORD의 상위 2비트이고 나머지 14비트는 0이다. 퍼센트는 `E=0`인 UNSIGNED-DECIMAL Value이며 0~100이다.
- flags의 b5~b15는 Reserved이며 0이어야 한다. 아니면 거부한다.
- F_FORCE는 ATTACKS에서만 쓴다. 다른 Codec(SUPERSEDES, 실행·판정 연결, TOULMIN 형식 관계)에서 켜져 있으면 거부한다.
- 공격 세기가 SIGNED-DECIMAL Value가 아니거나, 0~1 밖이거나, 소수 4자리로 정확히 나타낼 수 없으면 거부한다.
- SUPERSEDES의 사슬 `A > B > C`는 쌍마다 SUPERSEDES를 하나씩 쓴다.

### 관련 페이지

- [TOULMIN](_index.md), [NODE](#node), [SOURCE와 구획](#source와-구획)
- [UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md), [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md)

## SOURCE와 구획

TOULMIN 문서의 원문과 구획을 쓰는 레코드다. 모두 Edge TOULMIN 형식 계열 직접 코드 `0x120L~0x125L`이다([TOULMIN](#toulmin-형식)). Issuer와 코덱 번호 칸 없이 TAG 뒤에 Payload가 온다.

### 형식

| Codec | 이름 | 레이아웃 |
|---|---|---|
| `0x120L` | [SOURCE](0x120L-source.md) | ID, SPAN 폭 WORD, UTF8 Value |
| `0x121L` | [TEXT](0x121L-text.md) | ID, UTF8 Value |
| `0x122L` | [SECTION](0x122L-section.md) | ID, 섹션 코드 1 WORD |
| `0x123L` | [CASE-BEGIN](0x123L-case-begin.md) | ID, REF(사안) |
| `0x124L` | [CASE-END](0x124L-case-end.md) | ID, REF(사안) |
| `0x125L` | [PROSE](0x125L-prose.md) | ID, SPAN |

- ID는 Edge Id, REF는 이 문서 레코드의 Edge Id다([TOULMIN](#공통-필드) 공통 필드).
- UTF8 Value는 [UTF8-TEXT](../value/0x072L-utf8-text.md) Value 레코드다. 바이트를 그대로 담는다.

### 형식별 쪽

레이아웃, 섹션 코드 표, 해석은 형식마다 따로 쪽이 있다.

- [SOURCE](0x120L-source.md): 저작 원문. BODY의 첫 레코드이고 SPAN 폭을 정한다
- [TEXT](0x121L-text.md): 이름·문자열
- [SECTION](0x122L-section.md): 섹션 시작과 섹션 코드
- [CASE-BEGIN](0x123L-case-begin.md), [CASE-END](0x124L-case-end.md): 사안 범위
- [PROSE](0x125L-prose.md): 서술 문단

### 관련 페이지

- [TOULMIN](_index.md), [NODE](#node), [LINK](#link)
