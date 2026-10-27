---
title: "NODE"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "NODE는 TOULMIN 그래프의 노드(사안, 규칙, 정의, 진입점, 트리거, 함수, 필드, 별칭, 묶음)를 쓰는 레이아웃이다. 헤더 1 WORD의 flag가 뒤따르는 조건부 필드를 정한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NODE는 TOULMIN 판정·실행 그래프의 노드를 쓰는 레이아웃이다. 노드 종류는 Codec(또는 GEUL ISSUER 형식 번호)이 정하고, 헤더 1 WORD가 역할·Level·Claim 형태와 조건부 필드를 정한다.

## Codec

| Codec | 이름 | TANGEUL | 노드 |
|---|---|---|---|
| `0x60` | CASE-DECLARE | `in case of` | 사안 |
| `0x62` | SPEC-DECLARE | Definitions 항목(`means`, `has`) | 판단 기준(Backing). role이 정의 종류 |
| `0x63` | RULE-DECLARE | general rule | 주장(Warrant) |
| `0x64` | COUNTER-DECLARE | counter rule | 반박(Rebuttal) |
| `0x65` | EXCEPT-DECLARE | except rule | 예외(Defeater) |
| `0x75` | ENTRY | `provides x` | 외부 진입점 |
| `0x76` | TRIGGER | `on`, `every`, `until` | 이벤트·주기 진입점 |
| ISSUER `0x0000`/`0xC010` | NAMESPACE | `this document is` | 문서 이름공간 |
| ISSUER `0x0000`/`0xC011` | FUNC | 함수 참조 | 바깥 함수(예: `bank.withdraw`) |
| ISSUER `0x0000`/`0xC012` | FIELD | `x is required [as Type]` | 필수 필드 |
| ISSUER `0x0000`/`0xC013` | ALIAS | `see a from path` | 가져온 패키지 별칭 |
| ISSUER `0x0000`/`0xC014` | GROUP | `1.` 순서 목록 | 순서 있는 실행 묶음 |

ISSUER 형식은 `ISSUER-1WORD`(`0x7C`) 뒤 Codec 확장 TAG에 Issuer `0x0000`과 형식 번호를 둔다([TOULMIN](/ko/grammar/edge/toulmin/)).

## 레이아웃

```
ID               LOCAL Reference 레코드 (Edge Id)
헤더 1 WORD      role 2b | 예약 2b | F_GROUNDS 1b | level 2b | object 종류 2b | flags 7b
[F_FUNC]         FuncRef: REF(ALIAS, 없으면 0) + VerbCode 1 WORD
[F_QUAL]         SIGNED-DECIMAL Value. Qualifier
[F_CHECK]        REF(사안)
[F_CLAIM]        Claim: REF(subject) + predicate 1 WORD + object + mode 1 WORD
[F_VERDICT]      SIGNED-DECIMAL Value. 판정값 초기값
[F_WITH]         개수(UNSIGNED-INTEGER Value) + REF(TEXT) × 개수
[F_GROUNDS]      개수(UNSIGNED-INTEGER Value) + REF(TEXT) × 개수
SPAN             SOURCE가 정한 폭 × 2 (시작 바이트, 바이트 수)
```

### 헤더 WORD

| 비트 | 필드 | 값 |
|---|---|---|
| 15–14 | role | 0 general, 1 counter, 2 except |
| 13–12 | 예약 | 0 |
| 11 | F_GROUNDS | 근거 목록이 있다 |
| 10–9 | level | 0 Unset, 1 Fail, 2 Review (3 예약) |
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

## 필드

| 필드 | 설명 |
|---|---|
| FuncRef | 함수 자리. REF는 그 함수를 가져온 ALIAS 레코드이고, 이 문서의 함수면 `0`이다. VerbCode는 1 WORD 코드이며 아직 배정하지 않았다(`0x0000` 허용). 함수의 원문 표기는 TEXT + [LABEL](/ko/grammar/edge/toulmin/link/)로 따로 쓴다 |
| Qualifier | 노드의 확신도(0~1) |
| 사안 | F_CHECK: 이 노드가 판정만 하는 사안(`checking c`) |
| Claim | 노드가 담는 명제. subject REF, predicate 1 WORD, object, mode 1 WORD. object의 형태는 헤더의 object 종류가 정한다 |
| 판정값 | 판정값의 초기값(−1~1) |
| F_WITH | 선언 시점의 판정 기준(`기준으로 하는`). TEXT 레코드 REF 목록 |
| F_GROUNDS | 평가 시점에 해석하는 외부 사실 이름(`근거로 하는`). TEXT 레코드 REF 목록 |
| SPAN | 이 선언이 나온 원문 범위 |

- 판정값·Qualifier의 표기는 [TOULMIN](/ko/grammar/edge/toulmin/#수치) 수치 규칙을 따른다.
- 목록의 개수는 내장 [UNSIGNED-INTEGER](/ko/grammar/value/numeric/unsigned-integer/) Value 레코드다.
- 서술 Claim의 기본 형태는 subject·predicate가 `0`이고 object가 SPAN(object 종류 2)이다. 원문 표기에 고정한다.

## 해석과 유효성

- role은 RULE·COUNTER·EXCEPT-DECLARE에서 Codec과 같아야 한다(0 general, 1 counter, 2 except). SPEC-DECLARE에서는 정의 종류다. 그 밖의 Codec에서는 0이다.
- level이 0(Unset)이면 엔진의 기본값을 쓴다: COUNTER-DECLARE는 Fail, EXCEPT-DECLARE는 Review.
- TANGEUL `tangl:규칙`의 호스트 함수 규칙(`쓰는 규칙이다`)은 사안 밖의 RULE-DECLARE NODE로 쓴다. 함수는 F_FUNC, 기준은 F_WITH, 근거는 F_GROUNDS다. 조건식 규칙만 앞에 [PREDICATE-DECLARE](/ko/grammar/edge/toulmin/expr/)를 둔다.
- 예약 비트(13–12)는 0이어야 한다. 예약 비트가 켜졌거나 role이 Codec과 맞지 않으면 거부한다.

## 관련 페이지

- [TOULMIN](/ko/grammar/edge/toulmin/), [LINK](/ko/grammar/edge/toulmin/link/), [EXPR](/ko/grammar/edge/toulmin/expr/), [SOURCE와 구획](/ko/grammar/edge/toulmin/source/)
- [LOCAL](/ko/grammar/reference/local/), [SIGNED-DECIMAL](/ko/grammar/value/decimal/signed-decimal/)
