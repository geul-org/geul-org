---
title: "SSaC — Service Sequences as Code"
weight: 3
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-10T12:00:00+09:00
tags: ["SSaC", "DSL", "SSOT", "Go", "codegen"]
summary: "Go 코멘트 한 줄이 하나의 시퀀스다. 10개의 고정 시퀀스 타입이 서비스 레이어의 모든 이진 분기를 커버하고, 심볼릭 코드 생성으로 gin 핸들러를 산출한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Service Sequences as Code** — Go 코멘트 한 줄이 하나의 시퀀스다. 선언하면 gin 핸들러가 생성된다.

서비스 로직은 일련의 결정이다: 어떤 모델을 쿼리할지, 무엇을 방어할지, 언제 거부할지, 무엇을 반환할지. 이 결정들은 비즈니스를 이해하는 사람의 것이지만, 보일러플레이트에 매몰되고 레이어에 흩어지고 리라이트에 유실된다.

SSaC는 이 결정들을 선언적 명세로 보존한다. **무엇이** 일어나고 **어떤 순서인지**를 한 줄씩 선언하면, 도구가 구현을 생성한다.

```
specs/service/*.go  →  ssac validate  →  ssac gen  →  artifacts/service/*.go
   (코멘트 DSL)         (검증)           (코드 생성)     (gin + gofmt)
```

<a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub 저장소</a>

## 핵심 아이디어

모든 서비스 함수는 스텝의 시퀀스다. 각 스텝은 이진 계약을 따른다: **성공 → 다음 줄, 실패 → 반환**. 이것은 우리가 발명한 추상화가 아니다 — 서비스 로직이 이미 작동하는 방식이다. SSaC는 이를 명시적으로 만든다.

10개의 고정 시퀀스 타입이 이 계약을 따르는 모든 서비스 레이어 작업을 커버한다. 맞지 않는 것은 `@call`에 위임한다. 집합은 설계상 닫혀 있다.

LLM 없음, 추론 없음 — 템플릿 기반 순수 심볼릭 코드 생성. 명세가 단일 진실 공급원이다.

## 문법 — 한 줄이 하나의 시퀀스

v2부터 각 시퀀스는 한 줄의 코멘트다. `@response`만 여러 줄 블록이다.

**CRUD — 모델 연산**

```go
// @get Type var = Model.Method(args...)        — 조회 (결과 필수)
// @post Type var = Model.Method(args...)       — 생성 (결과 필수)
// @put Model.Method(args...)                   — 수정 (결과 없음)
// @delete Model.Method(args...)                — 삭제 (결과 없음)
```

인자 형식: `source.Field` 또는 `"리터럴"`

- `request.CourseID` — HTTP 요청에서
- `course.InstructorID` — 이전 결과 변수에서
- `currentUser.ID` — 인증 컨텍스트에서
- `"cancelled"` — 문자열 리터럴

**가드**

```go
// @empty target "message"                      — nil/zero이면 실패 (404)
// @exists target "message"                     — nil/zero 아니면 실패 (409)
```

대상: 변수(`course`) 또는 변수.필드(`course.InstructorID`)

**상태 전이**

```go
// @state diagramID {key: var.Field, ...} "transition" "message"
```

**권한 검사 — OPA**

```go
// @auth "action" "resource" {key: var.Field, ...} "message"
```

**외부 호출**

```go
// @call Type var = package.Func(args...)       — 결과 있음
// @call package.Func(args...)                  — 결과 없음
```

**응답 — 필드 매핑 블록**

```go
// @response {
//   fieldName: variable,
//   fieldName: variable.Member,
//   fieldName: "literal"
// }
```

## 예시

```go
package service

import "myapp/auth"

// @auth "cancel" "reservation" {id: request.ReservationID} "권한 없음"
// @get Reservation reservation = Reservation.FindByID(request.ReservationID)
// @empty reservation "예약을 찾을 수 없습니다"
// @state reservation {status: reservation.Status} "cancel" "취소할 수 없습니다"
// @call Refund refund = billing.CalculateRefund(reservation.ID, reservation.StartAt, reservation.EndAt)
// @put Reservation.UpdateStatus(request.ReservationID, "cancelled")
// @get Reservation reservation = Reservation.FindByID(request.ReservationID)
// @response {
//   reservation: reservation,
//   refund: refund
// }
func CancelReservation() {}
```

10줄 선언. 각 줄이 하나의 시퀀스이며, 위에서 아래로 순서대로 실행된다. 권한 → 조회 → 가드 → 상태 전이 → 외부 호출 → 수정 → 재조회 → 응답.

## 시퀀스 타입 (10)

| 타입 | 역할 |
|---|---|
| `@auth` | 권한 검사 (OPA 정책) |
| `@get` | 리소스 조회 |
| `@empty` | nil/zero이면 종료 (404) |
| `@exists` | nil/zero 아니면 종료 (409) |
| `@post` | 리소스 생성 |
| `@put` | 리소스 수정 |
| `@delete` | 리소스 삭제 |
| `@state` | 상태 전이 검증 |
| `@call` | 외부 패키지 함수 호출 |
| `@response` | 응답 반환 (필드 매핑) |

## 검증

내부 검증 (항상):
- 타입별 필수 인자 누락
- `Model.Method` 형식
- 변수 흐름 (선언 전 참조)

외부 SSOT 교차 검증 (프로젝트 구조 감지 시):
- 모델/메서드 존재 (sqlc 쿼리, Go 인터페이스)
- 요청/응답 필드 존재 (OpenAPI)
- 패키지/함수 존재 (Go 인터페이스)
- 부실 데이터 경고: put/delete 후 re-fetch 없이 response (WARNING)
- 상태 다이어그램 존재 및 전이 유효성 검증
- OPA 정책 파일 존재 검증

## 코드 생성 기능

외부 SSOT (심볼 테이블)가 있으면 `ssac gen`이 추가 기능을 제공한다. 생성 코드는 gin 프레임워크를 사용한다.

- **타입 변환**: DDL 컬럼 타입 → `strconv.ParseInt`, `time.Parse`, 400 Bad Request 조기 반환
- **가드 값 타입**: 타입 인식 제로 체크 (`int` → `== 0`/`> 0`, 포인터 → `== nil`/`!= nil`)
- **모델 인터페이스 도출**: 3개 SSOT 소스 교차 → `<outDir>/model/models_gen.go`
- **@state 코드 생성**: 상태 다이어그램 패키지의 `CanTransition` 호출
- **@auth 코드 생성**: `authz.Check(currentUser, "action", "resource", authz.Input{...})` 호출
- **@call 코드 생성**: 결과 없으면 가드 스타일(401), 있으면 값 스타일(500)
- **도메인 폴더 구조**: `service/auth/login.go` → `outDir/auth/login.go`, `package auth`

## OpenAPI x- 확장

인프라 파라미터(페이지네이션, 정렬, 필터링, 관계 포함)는 OpenAPI `x-` 확장에 선언한다. SSaC 명세에는 비즈니스 파라미터만 선언한다. 코드 생성기가 `x-`를 읽고 `QueryOpts`를 자동 구성한다.

```yaml
/api/reservations:
  get:
    operationId: ListReservations
    x-pagination:
      style: offset
      defaultLimit: 20
      maxLimit: 100
    x-sort:
      allowed: [start_at, created_at]
      default: start_at
      direction: desc
    x-filter:
      allowed: [status, room_id]
    x-include:
      allowed: [room_id:rooms.id, user_id:users.id]
```

## 라이선스

MIT — <a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub</a>
