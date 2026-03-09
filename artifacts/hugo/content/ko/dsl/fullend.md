---
title: "Fullend — Full-stack SSOT Orchestrator"
weight: 1
date: 2026-03-09T12:00:00+09:00
lastmod: 2026-03-09T12:00:00+09:00
tags: ["Fullend", "DSL", "SSOT", "cross-validation", "vibe-coding"]
summary: "5개 SSOT(STML, OpenAPI, SSaC, SQL DDL, Terraform)의 교차 정합성을 검증하고 코드를 산출하는 CLI. 바이브 코딩의 균열을 구조로 메운다."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Full-stack SSOT Orchestrator** — 5개 SSOT의 정합성을 한 번에 검증하고 코드를 산출하는 CLI.

<a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">GitHub 저장소</a>

## 바이브 코딩의 균열

바이브 코딩이 대중화되면서 패턴이 보이기 시작했다.

AI에게 "예약 기능 만들어"라고 하면 만든다. "취소 기능 추가해"라고 하면 추가한다. 다섯 번째 기능을 추가할 때 두 번째 기능이 깨진다. API 스키마를 바꿨는데 프론트엔드를 안 고쳤다. DB 컬럼을 추가했는데 서비스 레이어가 모른다.

원인은 단순하다. AI가 전체 코드를 기억하지 못하기 때문이다.

그래서 사람들이 하는 일: 깨진 부분을 발견하면 AI에게 "이것도 고쳐"라고 한다. 고치면 다른 데가 깨진다. "그것도 고쳐." 이 루프가 반복된다. 프로젝트가 커질수록 루프가 길어지고, 어느 시점에서 "처음부터 다시 만드는 게 빠르겠다"가 된다.

## 코드는 왜 커지는가

코드에는 두 가지가 섞여 있다.

**결정**: 뭘 보여줄지, 어떤 API를 호출할지, 어떤 순서로 처리할지, 뭘 저장할지.
**배선**: 그 결정을 특정 프레임워크에서 구현하는 코드.

예약 시스템을 만든다고 하자.

```
결정: "예약 생성 시 방을 조회하고, 없으면 404, 있으면 생성"
```

이 한 줄의 결정이 React 훅, Go 핸들러, SQL 쿼리, API 스키마, Terraform 리소스에 흩어진다. 각각의 프레임워크 문법으로 감싸지고, 에러 처리와 타입 변환이 덧붙는다.

10만 줄의 코드 중 결정은 12,500줄이다. 나머지 87,500줄은 배선이다.

AI 에이전트는 컨텍스트 윈도우가 유한하다. 열 번째 기능을 추가할 때 앞의 아홉 번을 기억하지 못한다. 10만 줄을 통째로 읽을 수 없기 때문이다.

결정만 분리하면 12,500줄이다. 200K 토큰 컨텍스트의 55%. AI가 한 번에 읽을 수 있는 크기다.

## 5개 SSOT

Fullend는 소프트웨어를 구성하는 5개 레이어에 각각 하나의 DSL을 대응시킨다. 각 DSL이 해당 레이어의 단일 진실 공급원(SSOT)이 된다.

| 레이어 | DSL | 선언 내용 |
|---|---|---|
| 화면 | STML (HTML5 + data-*) | 뭘 보여주고 뭘 하는가 |
| API 계약 | OpenAPI 3.x | 어떤 요청을 받고 어떤 응답을 주는가 |
| 서비스 흐름 | SSaC (Go comment DSL) | 어떤 순서로 처리하는가 |
| 데이터 구조 | SQL DDL + sqlc | 뭘 저장하는가 |
| 인프라 | Terraform HCL | 어디서 돌리는가 |

OpenAPI, SQL DDL, Terraform은 업계 표준이다. 화면과 서비스 흐름은 해당하는 SSOT DSL이 없었다. 프론트엔드 결정은 React 훅에 매몰되고, 서비스 흐름은 Go 핸들러에 흩어졌다. 그래서 [STML](/ko/dsl/stml/)과 [SSaC](/ko/dsl/ssac/)를 설계했다. 이 프로젝트에서 만든 DSL이다.

```
specs/
├── frontend/*.html        → STML
├── api/openapi.yaml       → OpenAPI 3.x
├── service/*.go           → SSaC
├── db/*.sql               → SQL DDL + sqlc queries
└── terraform/*.tf         → HCL
```

`specs/`가 진실이다. `artifacts/`는 언제든 재생성할 수 있다.

## 개별 검증은 이미 있다

3개 레이어의 검증 도구는 이미 존재한다.

- sqlc가 DDL과 쿼리의 정합성을 검사한다.
- OpenAPI 검증기가 스키마의 유효성을 검사한다.
- Terraform이 HCL의 구문과 의존성을 검사한다.

STML과 SSaC에도 각각 내장 검증기를 만들었다. SSaC는 서비스 흐름의 내부 일관성을, STML은 UI 선언과 OpenAPI의 일치를 검사한다.

5개 레이어 각각은 자기 안에서 검증할 수 있다. 문제는 **사이**에서 발생한다.

프론트엔드가 `data-bind="memo"`로 필드를 표시하는데, API 응답 스키마에 `memo`가 없다. SSaC가 `@model Reservation.SoftDelete`를 호출하는데, sqlc 쿼리에 `SoftDelete` 메서드가 없다. OpenAPI에 `x-sort: [created_at]`을 선언했는데, DDL 테이블에 해당 컬럼 인덱스가 없다.

개별 도구는 자기 레이어만 본다. 레이어 사이의 균열은 보이지 않는다.

## 구조를 숨기기

"그래도 5개 DSL을 배워야 하잖아?"

맞다. 하지만 구조는 사용자에게 보여줄 필요가 없다.

에이전트의 시스템 프롬프트에 기술 스택과 SSOT 규칙을 미리 넣어두면, 사용자는 "예약 기능 만들어"라고만 하면 된다. 에이전트가 알아서 OpenAPI에 엔드포인트를 추가하고, DDL에 테이블을 만들고, SSaC에 서비스 흐름을 선언하고, STML에 화면을 그리고, `fullend validate`를 돌려서 정합성을 확인한다.

사용자가 보는 것은 결과뿐이다. 구조는 에이전트가 소비하는 것이지, 사용자가 학습해야 하는 것이 아니다.

바이브 코딩의 경험은 그대로다. 달라지는 것은 뒤에서 깨지지 않는다는 것.

## Fullend의 역할

Fullend는 교차 검증기다. 개별 도구를 재발명하지 않는다. 각 도구를 호출하고, 레이어 간 경계를 검사한다.

```bash
fullend validate specs/
```

```
✓ DDL          3 tables, 18 columns
✓ OpenAPI      7 endpoints
✓ SSaC         7 service functions
✓ STML         4 pages, 6 bindings
✓ Cross        0 mismatches

All SSOT sources are consistent.
```

하나라도 실패하면:

```
✓ DDL          3 tables, 18 columns
✓ OpenAPI      7 endpoints
✗ SSaC         CancelReservation
               @model Reservation.SoftDelete — method not found in sqlc queries
✗ Cross        1 mismatch

FAILED: Fix errors before codegen.
```

검증이 통과하면 코드를 산출한다.

```bash
fullend gen specs/ artifacts/
```

sqlc가 DB 모델을 생성하고, oapi-codegen이 API 타입을 생성하고, SSaC가 서비스 함수를 생성하고, STML이 React 컴포넌트를 생성하고, Fullend가 이들을 연결하는 글루 코드를 생성한다.

## 교차 검증 규칙

Fullend의 고유 가치는 교차 검증에 있다.

**OpenAPI ↔ DDL**

| 검증 대상 | 규칙 |
|---|---|
| x-sort.allowed | 해당 컬럼이 테이블에 존재하는가 |
| x-filter.allowed | 해당 컬럼이 테이블에 존재하는가 |
| x-include.allowed | FK 관계로 연결된 테이블인가 |

**SSaC ↔ DDL**

| 검증 대상 | 규칙 |
|---|---|
| @model Model.Method | sqlc 쿼리에 해당 메서드가 존재하는가 |
| @result Type | DDL 테이블에서 파생된 타입과 일치하는가 |
| @param 이름 | DDL 컬럼으로 변환 가능한가 |

**SSaC ↔ OpenAPI**

| 검증 대상 | 규칙 |
|---|---|
| 함수명 | operationId와 매칭되는가 |
| @param request | 요청 스키마에 필드가 있는가 |
| @result + response | 응답 스키마에 필드가 있는가 |

**STML ↔ SSaC** — 둘 다 같은 OpenAPI operationId를 참조한다. 양쪽 검증이 통과하면 프론트엔드가 호출하는 API와 백엔드가 처리하는 API의 일치가 자동으로 보장된다.

## 에이전트를 위한 설계

Fullend는 AI 에이전트를 위해 설계되었다.

에이전트가 spec을 작성하려면 SSaC의 10개 시퀀스 타입, STML의 12개 data-* 속성, OpenAPI x- 확장, 이름 매칭 규칙을 알아야 한다. 이를 위해 약 350줄의 AI용 매뉴얼을 제공한다. 에이전트의 시스템 프롬프트에 한 번 넣으면 된다.

spec 작성 이후의 검증 루프는 단순하다.

```
에이전트 워크플로우:
1. specs/ 수정
2. fullend validate specs/
3. 에러가 있으면 → 해당 SSOT 수정 → 2번으로
4. 에러 0 → fullend gen specs/ artifacts/
```

전체 시스템을 이해할 필요 없다. validate가 가리키는 곳만 고치면 정합성이 복원된다. 똑똑한 모델은 한 번에 맞추고, 작은 모델은 세 번 만에 맞춘다. 결과는 같다.

## 규모별 SSOT 크기

| 규모 | 예시 | SSOT | 구현 코드 | 컨텍스트 점유율 |
|---|---|---|---|---|
| 소형 | 미용실 예약 | ~1,500줄 | ~1만 줄 | ~8% |
| 중형 | Jira, Notion급 | ~12,500줄 | ~10만 줄 | ~55% |
| 대형 | Shopify급 | ~30,000줄 | ~30만 줄 | ~90% |

200K 토큰 컨텍스트 기준. 중형 SaaS까지 에이전트가 전체 설계를 한 번에 읽을 수 있다.

## 예외의 패턴화

10개의 시퀀스 타입으로 안 되는 것은 `call`로 빠진다. data-* 속성으로 안 되는 것은 `custom.ts`로 빠진다. 이 escape hatch가 전체의 20%를 넘으면 구조화의 의미가 퇴색된다.

그러나 예외는 격리되는 순간 관찰 가능해진다. 많은 프로젝트가 Fullend로 구조화되면, `call`과 `custom.ts`에 반복되는 패턴이 드러날 것이다.

SSaC의 10개 시퀀스 타입도 처음부터 설계된 것이 아니다. 서비스 코드를 수백 개 관찰한 결과 10개로 수렴했다. 같은 원리가 escape hatch에서 반복될 것이라 기대한다. 자주 등장하는 `call` 패턴은 새로운 시퀀스 타입이 되고, 자주 등장하는 `custom.ts` 패턴은 새로운 data-* 속성이 된다.

예외가 줄어드는 것이 아니라, 예외에서 구조가 자란다.

## 기술 스택 확장

현재 Fullend는 Go + React + PostgreSQL + Terraform으로 고정되어 있다. 의도적이다. PoC 단계에서 하나의 스택을 끝까지 관통하는 것이 먼저다.

그러나 5개 SSOT 중 3개(OpenAPI, SQL DDL, Terraform)는 이미 언어 독립적이다. SSaC의 시퀀스 타입 10개는 언어에 종속되지 않는 패턴이다 — Go 코멘트로 표현할 뿐이다. STML은 HTML5 data-* 속성이라 프레임워크에 무관하다.

확장은 코드 생성 백엔드를 추가하는 문제다. 검증 로직과 교차 검증 규칙은 그대로 유지된다.

## GEUL과의 관계

5개 DSL이 소프트웨어의 SSOT를 구성한다. SSOT는 구조화된 데이터다. 구조화된 데이터는 그래프다. 그래프는 GEUL로 인코딩할 수 있다.

STML의 `data-fetch="ListReservations"`는 엔티티 간 관계다. SSaC의 `@sequence get → @model → @guard → @response`는 이벤트 시퀀스다. OpenAPI의 엔드포인트 정의는 계약이다. 전부 GEUL의 트리플 엣지, 이벤트6 엣지, 엔티티 노드로 표현할 수 있는 의미 구조다.

Fullend가 5개 DSL 사이의 교차 검증을 수행하는 방식 — 심볼릭 매칭, 타입 정합성 검사, 참조 무결성 확인 — 은 GEUL 스트림에서의 기계적 검증과 동일한 원리다.

## 라이선스

MIT — <a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">GitHub</a>
