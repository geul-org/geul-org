---
title: "SSaC — Service Sequences as Code"
weight: 2
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-08T12:00:00+09:00
tags: ["SSaC", "DSL", "SSOT", "Go", "codegen"]
summary: "Go 코멘트에 서비스 로직을 선언하고 구현 코드를 생성한다. 10개의 고정 시퀀스 타입이 서비스 레이어의 모든 이진 분기를 커버한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Service Sequences as Code** — Go 코멘트 DSL에서 서비스 코드를 생성한다.

서비스 로직은 일련의 결정이다: 어떤 모델을 쿼리할지, 무엇을 방어할지, 언제 거부할지, 무엇을 반환할지. 이 결정들은 비즈니스를 이해하는 사람의 것이지만, 보일러플레이트에 매몰되고 레이어에 흩어지고 리라이트에 유실된다.

SSaC는 이 결정들을 선언적 명세로 보존한다. **무엇이** 일어나고 **어떤 순서인지**를 선언하면, 도구가 구현을 생성한다.

```
specs/service/*.go  →  ssac validate  →  ssac gen  →  artifacts/service/*.go
   (코멘트 DSL)         (검증)           (코드 생성)     (gofmt 적용)
```

<a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub 저장소</a>

## 핵심 아이디어

모든 서비스 함수는 스텝의 시퀀스다. 각 스텝은 이진 계약을 따른다: **성공 → 다음 줄, 실패 → 반환**. 이것은 우리가 발명한 추상화가 아니다 — 서비스 로직이 이미 작동하는 방식이다. SSaC는 이를 명시적으로 만든다.

10개의 고정 시퀀스 타입이 이 계약을 따르는 모든 서비스 레이어 작업을 커버한다. 맞지 않는 것은 `call`에 위임한다. 집합은 설계상 닫혀 있다.

LLM 없음, 추론 없음 — 템플릿 기반 순수 심볼릭 코드 생성. 명세가 단일 진실 공급원이다.

## 예시

```go
// @sequence get
// @model Project.FindByID
// @param ProjectID request
// @result project Project

// @sequence guard nil project
// @message "project not found"

// @sequence post
// @model Session.Create
// @param ProjectID request
// @param Command request
// @result session Session

// @sequence response json
// @var session
func CreateSession(w http.ResponseWriter, r *http.Request) {}
```

이 10줄 선언이 다음 코드를 생성한다:

```go
func CreateSession(w http.ResponseWriter, r *http.Request) {
    projectID := r.FormValue("ProjectID")
    command := r.FormValue("Command")

    project, err := projectModel.FindByID(projectID)
    if err != nil {
        http.Error(w, "Project lookup failed", http.StatusInternalServerError)
        return
    }

    if project == nil {
        http.Error(w, "project not found", http.StatusNotFound)
        return
    }

    session, err := sessionModel.Create(projectID, command)
    if err != nil {
        http.Error(w, "Session creation failed", http.StatusInternalServerError)
        return
    }

    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(map[string]interface{}{
        "session": session,
    })
}
```

## 시퀀스 타입 (10)

| 타입 | 역할 |
|---|---|
| `authorize` | 권한 검사 (OPA 등) |
| `get` | 리소스 조회 |
| `guard nil` | null이면 종료 |
| `guard exists` | 존재하면 종료 |
| `post` | 리소스 생성 |
| `put` | 리소스 수정 |
| `delete` | 리소스 삭제 |
| `password` | 비밀번호 비교 |
| `call` | 외부 호출 (@component / @func) |
| `response` | 응답 반환 (json) |

## 검증

내부 검증 (항상):
- 타입별 필수 태그 누락
- `@model` 형식 (`Model.Method`)
- 변수 흐름 (선언 전 참조)

외부 SSOT 교차 검증 (프로젝트 구조 감지 시):
- 모델/메서드 존재 (sqlc 쿼리, Go 인터페이스)
- 요청/응답 필드 존재 (OpenAPI)
- 컴포넌트/함수 존재 (Go 인터페이스)
- 부실 데이터 경고: put/delete 후 re-fetch 없이 response (WARNING)

## 코드 생성 기능

외부 SSOT (심볼 테이블)가 있으면 `ssac gen`이 추가 기능을 제공한다:

- **타입 변환**: DDL 컬럼 타입 → `strconv.ParseInt`, `time.Parse`, 400 Bad Request 조기 반환
- **가드 값 타입**: 타입 인식 제로 체크 (`int` → `== 0`/`> 0`, 포인터 → `== nil`/`!= nil`)
- **소스 해석**: `@param Name currentUser` → `currentUser.Name`
- **모델 인터페이스 도출**: 3개 SSOT 소스 교차 → `<outDir>/model/models_gen.go`

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
      allowed: [room, user]
```

## 라이선스

MIT — <a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub</a>
