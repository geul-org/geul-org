---
title: "Fullend — Full-stack SSOT Orchestrator"
weight: 1
date: 2026-03-09T12:00:00+09:00
lastmod: 2026-03-13T12:00:00+09:00
tags: ["Fullend", "DSL", "SSOT", "cross-validation", "vibe-coding"]
summary: "10개 SSOT의 교차 정합성을 검증하고 코드를 산출하는 CLI. 바이브 코딩의 균열을 구조로 메운다."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Full-stack SSOT Orchestrator** — 10개 SSOT의 정합성을 한 번에 검증하고 코드를 산출하는 CLI.

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
결정: "예약 취소 시 권한 검사 → 조회 → 상태 전이 검증 → 환불 계산 → 상태 변경 → 응답"
```

이 한 줄의 결정이 React 훅, Go 핸들러, SQL 쿼리, API 스키마, Terraform 리소스에 흩어진다. 각각의 프레임워크 문법으로 감싸지고, 에러 처리와 타입 변환이 덧붙는다.

10만 줄의 코드 중 결정은 12,500줄이다. 나머지 87,500줄은 배선이다.

AI 에이전트는 컨텍스트 윈도우가 유한하다. 열 번째 기능을 추가할 때 앞의 아홉 번을 기억하지 못한다. 10만 줄을 통째로 읽을 수 없기 때문이다.

결정만 분리하면 12,500줄이다. 200K 토큰 컨텍스트의 55%. AI가 한 번에 읽을 수 있는 크기다.

## 10개 SSOT

Fullend는 소프트웨어의 모든 결정을 10개의 선언형 명세로 분리한다. 각 명세가 해당 관심사의 단일 진실 공급원(SSOT)이 된다.

| 관심사 | SSOT | 선언 내용 |
|---|---|---|
| 프로젝트 설정 | fullend.yaml | 기술 스택, 미들웨어, 모듈 경로 |
| 화면 | [STML](/ko/dsl/stml/) (HTML5 + data-*) | 뭘 보여주고 뭘 하는가 |
| API 계약 | OpenAPI 3.x | 어떤 요청을 받고 어떤 응답을 주는가 |
| 서비스 흐름 | [SSaC](/ko/dsl/ssac/) (.ssac DSL) | 어떤 순서로 처리하는가 |
| 데이터 구조 | SQL DDL + sqlc | 뭘 저장하는가 |
| 외부 함수 | Func Spec (Go) | 커스텀 로직의 인터페이스와 구현 |
| 상태 전이 | Mermaid stateDiagram | 리소스가 어떤 상태를 거치는가 |
| 권한 정책 | OPA Rego | 누가 무엇을 할 수 있는가 |
| 시나리오 | Gherkin (.feature) | 엔드포인트 간 비즈니스 흐름 검증 |
| 인프라 | Terraform HCL | 어디서 돌리는가 |

OpenAPI, SQL DDL, Terraform은 업계 표준이다. 나머지 관심사는 해당하는 SSOT DSL이 없었다. 서비스 흐름은 Go 핸들러에 흩어지고, 화면 결정은 React 훅에 매몰되고, 상태 전이는 if-else 분기에 숨고, 권한은 미들웨어에 하드코딩되었다. 그래서 STML, SSaC, Func Spec, stateDiagram 연동, OPA 연동, Gherkin 연동을 설계했다. 이 프로젝트에서 만든 DSL과 연동이다.

```
specs/my-project/
├── fullend.yaml             → 프로젝트 설정
├── api/openapi.yaml         → OpenAPI 3.x
├── db/*.sql                 → SQL DDL + sqlc queries
├── service/**/*.ssac        → SSaC (.ssac 확장자)
├── model/*.go               → Go structs (// @dto)
├── func/<pkg>/*.go          → Func Spec
├── states/*.md              → Mermaid stateDiagram
├── policy/*.rego            → OPA Rego
├── scenario/*.feature       → Gherkin
├── frontend/*.html          → STML
└── terraform/*.tf           → HCL
```

`specs/`가 진실이다. `artifacts/`는 언제든 재생성할 수 있다.

## 개별 검증은 이미 있다

여러 레이어의 검증 도구는 이미 존재한다.

- sqlc가 DDL과 쿼리의 정합성을 검사한다.
- OpenAPI 검증기가 스키마의 유효성을 검사한다.
- Terraform이 HCL의 구문과 의존성을 검사한다.

STML과 SSaC에도 각각 내장 검증기를 만들었다. SSaC는 서비스 흐름의 내부 일관성을, STML은 UI 선언과 OpenAPI의 일치를 검사한다.

각 SSOT는 자기 안에서 검증할 수 있다. 문제는 **사이**에서 발생한다.

프론트엔드가 `data-bind="memo"`로 필드를 표시하는데, API 응답 스키마에 `memo`가 없다. SSaC가 `@delete Reservation.SoftDelete(request.ReservationID)`를 호출하는데, sqlc 쿼리에 `SoftDelete` 메서드가 없다. 상태 다이어그램에서 `PublishCourse` 전이를 정의했는데, SSaC에 해당 함수가 없다. OPA 정책에서 `course` 리소스의 소유권을 `courses.instructor_id`로 조회하는데, DDL에 해당 컬럼이 없다.

개별 도구는 자기 레이어만 본다. 레이어 사이의 균열은 보이지 않는다.

## 구조를 숨기기

"그래도 10개 DSL을 배워야 하잖아?"

맞다. 하지만 구조는 사용자에게 보여줄 필요가 없다.

에이전트의 시스템 프롬프트에 기술 스택과 SSOT 규칙을 미리 넣어두면, 사용자는 "예약 기능 만들어"라고만 하면 된다. 에이전트가 알아서 OpenAPI에 엔드포인트를 추가하고, DDL에 테이블을 만들고, SSaC에 서비스 흐름을 선언하고, 상태 다이어그램을 그리고, OPA 정책을 작성하고, STML에 화면을 그리고, `fullend validate`를 돌려서 정합성을 확인한다.

사용자가 보는 것은 결과뿐이다. 구조는 에이전트가 소비하는 것이지, 사용자가 학습해야 하는 것이 아니다.

바이브 코딩의 경험은 그대로다. 달라지는 것은 뒤에서 깨지지 않는다는 것.

## Fullend의 역할

Fullend는 교차 검증기다. 개별 도구를 재발명하지 않는다. 각 도구를 호출하고, SSOT 간 경계를 검사한다.

```bash
fullend validate <specs-dir>
fullend validate --skip states,terraform <specs-dir>
```

10개 SSOT를 개별 검증한 뒤 교차 검증한다. Func은 `func/` 디렉토리가 있을 때만 검증한다. `--skip`으로 특정 SSOT를 제외할 수 있다.

```
✓ Config       my-project, go/gin, typescript/react
✓ OpenAPI      7 endpoints
✓ DDL          3 tables, 18 columns
✓ SSaC         7 service functions
✓ Model        3 files
✓ STML         4 pages, 6 bindings
✓ States       1 diagrams, 3 transitions
✓ Policy       1 files, 5 rules, 3 ownership mappings
✓ Scenario     4 features, 5 scenarios
✓ Func         3 funcs
✓ Terraform    2 files
✓ Cross        0 mismatches

All SSOT sources are consistent.
```

하나라도 실패하면:

```
✓ DDL          3 tables, 18 columns
✓ OpenAPI      7 endpoints
✗ SSaC         CancelReservation
               @delete Reservation.SoftDelete — method not found in sqlc queries
✗ States       course: PublishCourse transition → no SSaC function
✗ Cross        2 mismatches

FAILED: Fix errors before codegen.
```

검증이 통과하면 코드를 산출한다. `--skip` 옵션은 validate와 동일하게 사용한다.

```bash
fullend gen <specs-dir> <artifacts-dir>
fullend gen --skip terraform <specs-dir> <artifacts-dir>
```

sqlc가 DB 모델을 생성하고, oapi-codegen이 API 타입을 생성하고, SSaC가 gin 핸들러를 생성하고, STML이 React 컴포넌트를 생성하고, 상태 머신 패키지와 OPA Authorizer가 생성되고, Gherkin에서 Hurl 테스트가 생성되고, Fullend가 이들을 연결하는 글루 코드를 생성한다.

### gen-model

외부 OpenAPI 문서에서 Go 모델 파일(인터페이스 + 타입 + HTTP 클라이언트)을 생성한다. 로컬 파일이나 URL을 입력으로 받는다.

```bash
fullend gen-model <openapi-source> <output-dir>
fullend gen-model https://api.stripe.com/openapi.yaml ./external/
```

### chain

하나의 API 오퍼레이션에 연결된 모든 SSOT 노드를 추적한다. operationId 하나를 넣으면 전 레이어의 file:line 맵이 나온다.

```bash
fullend chain <operationId> <specs-dir>
```

```
── Feature Chain: AcceptProposal ──

  OpenAPI    api/openapi.yaml:296                          POST /proposals/{id}/accept
  SSaC       service/proposal/accept_proposal.ssac:19      @get @empty @auth @state @put @call @post @response
  DDL        db/gigs.sql:1                                 CREATE TABLE gigs
  DDL        db/proposals.sql:1                            CREATE TABLE proposals
  DDL        db/transactions.sql:1                         CREATE TABLE transactions
  Rego       policy/authz.rego:3                           resource: gig
  StateDiag  states/gig.md:7                               diagram: gig → AcceptProposal
  StateDiag  states/proposal.md:6                          diagram: proposal → AcceptProposal
  FuncSpec   func/billing/hold_escrow.go:8                 @func billing.HoldEscrow
  Gherkin    scenario/gig_lifecycle.feature:4              Scenario: Happy Path - Full Gig Lifecycle
```

### status

감지된 SSOT의 요약 현황을 보여준다.

```bash
fullend status <specs-dir>
```

```
SSOT Status:
  OpenAPI      api/openapi.yaml               7 endpoints
  DDL          db                             3 tables, 18 columns
  SSaC         service                        7 functions
  STML         frontend                       4 pages
  States       states                         1 diagrams, 3 transitions
  Policy       policy                         1 files, 5 rules
  Scenario     scenario                       4 features, 5 scenarios
  Func         func                           3 funcs
```

## 내장 함수와 모델

Fullend는 자주 쓰이는 함수 구현과 모델 인터페이스를 내장하고 있다. SSaC에서 `@call`로 호출할 수 있다.

### Default Functions (pkg/)

| 패키지 | 함수 | 설명 |
|---|---|---|
| `auth` | `hashPassword` | bcrypt 패스워드 해싱 |
| `auth` | `verifyPassword` | bcrypt 패스워드 검증 |
| `auth` | `issueToken` | JWT 액세스 토큰 생성 (24h) |
| `auth` | `verifyToken` | JWT 토큰 검증 + 클레임 추출 |
| `auth` | `refreshToken` | 리프레시 토큰 생성 (7일) |
| `auth` | `generateResetToken` | 패스워드 리셋용 랜덤 hex 토큰 |
| `crypto` | `encrypt` | AES-256-GCM 대칭 암호화 |
| `crypto` | `decrypt` | AES-256-GCM 복호화 |
| `crypto` | `generateOTP` | TOTP 시크릿 + QR 프로비저닝 URL |
| `crypto` | `verifyOTP` | TOTP 코드 검증 |
| `storage` | `uploadFile` | S3 호환 파일 업로드 |
| `storage` | `deleteFile` | S3 호환 파일 삭제 |
| `storage` | `presignURL` | S3 presigned 다운로드 URL |
| `mail` | `sendEmail` | SMTP 플레인 텍스트 이메일 |
| `mail` | `sendTemplateEmail` | Go 템플릿 HTML 이메일 (SMTP) |
| `text` | `generateSlug` | 유니코드 → URL-safe slug |
| `text` | `sanitizeHTML` | XSS 방지 HTML 새니타이징 |
| `text` | `truncateText` | 유니코드 안전 텍스트 절단 |
| `image` | `ogImage` | OG 이미지 생성 (1200x630, PNG) |
| `image` | `thumbnail` | 썸네일 생성 (200x200, PNG) |

프로젝트에서 `specs/<project>/func/<pkg>/`에 동일한 이름의 구현을 두면 오버라이드된다.

### Built-in Models (pkg/)

DDL로 정의하지 않는 비-관계형 I/O를 위한 패키지 접두사 @model 인터페이스다. `fullend.yaml`에서 백엔드를 설정한다.

| 패키지 | 인터페이스 | 백엔드 | SSaC 사용 |
|---|---|---|---|
| `session` | `SessionModel` (Set/Get/Delete + TTL) | PostgreSQL, Memory | `session.Session.Get({key: ...})` |
| `cache` | `CacheModel` (Set/Get/Delete + TTL) | PostgreSQL, Memory | `cache.Cache.Set({key: ..., value: ..., ttl: ...})` |
| `file` | `FileModel` (Upload/Download/Delete) | S3, LocalFile | `file.File.Upload({key: ..., body: ...})` |
| `queue` | Singleton Pub/Sub (Publish/Subscribe) | PostgreSQL, Memory | `@publish "topic" {payload}` |

### Middleware (생성)

Fullend는 `fullend.yaml`의 claims 설정에서 프로젝트별 `internal/middleware/bearerauth.go`를 생성한다.

| 미들웨어 | 트리거 | 설명 |
|---|---|---|
| `BearerAuth(secret)` | `securitySchemes.bearerAuth` + `backend.auth.claims` | JWT에서 `*model.CurrentUser`를 추출하여 gin 컨텍스트에 설정 |

OpenAPI `security` 필드로 라우트 그룹이 결정된다. `security: [{bearerAuth: []}]`가 있는 오퍼레이션은 auth 그룹, 없는 오퍼레이션은 public 그룹이 된다.

## 교차 검증 규칙

Fullend의 고유 가치는 교차 검증에 있다. 개별 도구가 자기 레이어를 검증한 뒤, Fullend가 SSOT 간 불일치를 잡는다.

**fullend.yaml ↔ OpenAPI**

| 검증 대상 | 규칙 |
|---|---|
| 미들웨어 이름 | securitySchemes 키와 매칭되는가 |

**OpenAPI ↔ DDL**

| 검증 대상 | 규칙 |
|---|---|
| x-sort.allowed | 해당 컬럼이 테이블에 존재하는가 |
| x-sort ↔ DDL index | 해당 컬럼에 인덱스가 있는가 (WARNING) |
| x-filter.allowed | 해당 컬럼이 테이블에 존재하는가 |
| x-include.allowed | FK 관계로 연결된 테이블인가 |

**SSaC ↔ DDL**

| 검증 대상 | 규칙 |
|---|---|
| Model.Method | sqlc 쿼리에 해당 메서드가 존재하는가 |
| @result Type | DDL 테이블에서 파생된 타입과 일치하는가 |
| 인자 필드 | DDL 컬럼으로 변환 가능한가 |

**SSaC ↔ OpenAPI**

| 검증 대상 | 규칙 |
|---|---|
| 함수명 | operationId와 매칭되는가 |
| request 인자 | 요청 스키마에 필드가 있는가 |
| @response 필드 | 응답 스키마에 필드가 있는가 |

**States ↔ SSaC ↔ OpenAPI ↔ DDL**

| 검증 대상 | 규칙 |
|---|---|
| 전이 이벤트 | SSaC 함수명과 매칭되는가 |
| 전이 이벤트 | OpenAPI operationId와 매칭되는가 |
| SSaC @state | 참조하는 stateDiagram이 존재하는가 |
| @state 필드 | DDL 컬럼으로 존재하는가 |

**Policy ↔ SSaC ↔ DDL ↔ States**

| 검증 대상 | 규칙 |
|---|---|
| allow (action, resource) | SSaC @auth와 매칭되는가 |
| @ownership table.column | DDL에 존재하는가 |
| @ownership via join | 조인 테이블 FK가 DDL에 존재하는가 |
| 상태 전이 이벤트 | @auth가 있는 전이에 매칭되는 Rego 규칙이 있는가 |

**Func ↔ SSaC**

| 검증 대상 | 규칙 |
|---|---|
| @call 참조 | 대응하는 Func 구현이 있는가 |
| 인자 개수 | @call 인자와 Request 필드 수가 일치하는가 |
| 인자 타입 | 위치별 타입이 DDL/OpenAPI를 통해 일치하는가 |
| 결과/응답 | result/response 일관성이 있는가 |
| 함수 본문 | TODO 스텁이 아닌가 (WARNING) |

**Scenario ↔ OpenAPI ↔ States**

| 검증 대상 | 규칙 |
|---|---|
| operationId | OpenAPI에 존재하는가 |
| HTTP method | OpenAPI 메서드와 일치하는가 |
| JSON 필드 | 요청 스키마에 존재하는가 |
| 스텝 순서 | 상태 전이 규칙을 따르는가 |

**Queue (Pub/Sub)**

| 검증 대상 | 규칙 |
|---|---|
| @publish topic | 매칭되는 @subscribe 함수가 있는가 |
| payload/message 필드 | 일관성이 있는가 |
| queue 설정 | fullend.yaml에 queue config가 있는가 |

**STML ↔ SSaC** — 둘 다 같은 OpenAPI operationId를 참조한다. 양쪽 검증이 통과하면 프론트엔드가 호출하는 API와 백엔드가 처리하는 API의 일치가 자동으로 보장된다.

## 런타임 테스팅

`fullend gen`은 OpenAPI 스펙과 Gherkin 시나리오에서 [Hurl](https://hurl.dev) 테스트를 생성한다.

```bash
# 서버를 시작한 뒤:
hurl --test --variable host=http://localhost:8080 artifacts/my-project/tests/*.hurl
```

생성되는 테스트:

- **smoke.hurl** — OpenAPI 엔드포인트 스모크 테스트 (자동 생성)
- **scenario-*.hurl** — 비즈니스 시나리오 테스트 (.feature 파일에서 생성)
- **invariant-*.hurl** — 엔드포인트 간 불변식 테스트 (.feature 파일에서 생성)

## 에이전트를 위한 설계

Fullend는 AI 에이전트를 위해 설계되었다.

에이전트가 spec을 작성하려면 SSaC의 10개 시퀀스 타입, STML의 data-* 속성, OpenAPI x- 확장, stateDiagram 규칙, OPA 정책 패턴, Gherkin 시나리오 문법, Func Spec 규칙, 이름 매칭 규칙을 알아야 한다. 이를 위해 약 830줄의 AI용 매뉴얼을 제공한다. 에이전트의 시스템 프롬프트에 한 번 넣으면 된다.

spec 작성 이후의 검증 루프는 단순하다.

```
에이전트 워크플로우:
1. specs/ 수정
2. fullend validate specs/my-project
3. 에러가 있으면 → 해당 SSOT 수정 → 2번으로
4. 에러 0 → fullend gen specs/my-project artifacts/my-project
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

10개의 시퀀스 타입으로 안 되는 것은 `@call`로 빠진다. data-* 속성으로 안 되는 것은 `custom.ts`로 빠진다. 이 escape hatch가 전체의 20%를 넘으면 구조화의 의미가 퇴색된다.

그러나 예외는 격리되는 순간 관찰 가능해진다. 많은 프로젝트가 Fullend로 구조화되면, `@call`과 `custom.ts`에 반복되는 패턴이 드러날 것이다.

SSaC의 10개 시퀀스 타입도 처음부터 설계된 것이 아니다. 서비스 코드를 수백 개 관찰한 결과 10개로 수렴했다. 같은 원리가 escape hatch에서 반복될 것이라 기대한다. 자주 등장하는 `@call` 패턴은 새로운 시퀀스 타입이 되고, 자주 등장하는 `custom.ts` 패턴은 새로운 data-* 속성이 된다.

예외가 줄어드는 것이 아니라, 예외에서 구조가 자란다.

## 기술 스택 확장

현재 Fullend는 Go(gin) + React + PostgreSQL + Terraform으로 고정되어 있다. 의도적이다. PoC 단계에서 하나의 스택을 끝까지 관통하는 것이 먼저다.

그러나 10개 SSOT 중 상당수(OpenAPI, SQL DDL, Terraform, Mermaid, OPA Rego, Gherkin)는 이미 언어 독립적이다. SSaC의 시퀀스 타입 10개는 언어에 종속되지 않는 패턴이다 — Go 코멘트로 표현할 뿐이다. STML은 HTML5 data-* 속성이라 프레임워크에 무관하다.

확장은 코드 생성 백엔드를 추가하는 문제다. 검증 로직과 교차 검증 규칙은 그대로 유지된다.

## GEUL과의 관계

10개 SSOT가 소프트웨어의 전체 결정을 구성한다. SSOT는 구조화된 데이터다. 구조화된 데이터는 그래프다. 그래프는 GEUL로 인코딩할 수 있다.

STML의 `data-fetch="ListReservations"`는 엔티티 간 관계다. SSaC의 `@get → @empty → @state → @call → @put → @response`는 이벤트 시퀀스다. stateDiagram의 전이는 상태 그래프다. OPA 정책은 권한 관계다. OpenAPI의 엔드포인트 정의는 계약이다. 전부 GEUL의 트리플 엣지, 이벤트6 엣지, 엔티티 노드로 표현할 수 있는 의미 구조다.

Fullend가 10개 SSOT 사이의 교차 검증을 수행하는 방식 — 심볼릭 매칭, 타입 정합성 검사, 참조 무결성 확인 — 은 GEUL 스트림에서의 기계적 검증과 동일한 원리다.

## 라이선스

MIT — <a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">GitHub</a>
