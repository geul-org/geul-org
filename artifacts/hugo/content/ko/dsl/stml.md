---
title: "STML — SSOT Template Markup Language"
weight: 2
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-08T12:00:00+09:00
tags: ["STML", "DSL", "SSOT", "frontend", "React", "OpenAPI"]
summary: "프레임워크 독립적인 UI 선언 언어. HTML5 data-* 속성으로 페이지가 무엇을 보여주고 무엇을 하는지 정의하고, OpenAPI 대비 심볼릭 검증 후 React 코드를 생성한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**SSOT Template Markup Language** — 프레임워크 독립적인 UI 선언.

프론트엔드 코드는 두 가지를 섞는다: **당신의 결정**과 **프레임워크 배선**. 어떤 API를 호출할지, 어떤 필드를 보여줄지, 어떤 순서로, 어떤 조건에서 — 이 결정들이 React 훅이나 Vue 컴포저블 안에 매몰된다. 프레임워크를 바꾸거나 리팩토링하면 결정이 재해석되거나 유실된다.

STML은 이를 분리한다. 결정은 `data-*` 속성이 붙은 표준 HTML에 남고, 프레임워크 배선은 생성하거나 위임한다.

<a href="https://github.com/geul-org/stml" target="_blank" rel="noopener">GitHub 저장소</a>

## 구조

```
┌─────────────────────────────────┐
│  STML (specs/)                  │  당신의 결정. 프레임워크 독립.
│  무엇을 가져오고, 보여주고,     │  어떤 리라이트도 살아남는다.
│  제출할지                       │
├─────────────────────────────────┤
│  코드 생성 / LLM                │  프레임워크 배선 생성.
│  React, Vue, Svelte, 무엇이든  │  교체 가능.
├─────────────────────────────────┤
│  런타임 (artifacts/)            │  React TSX, Vue SFC 등.
│  훅, 상태, 렌더링               │  생성물. 편집하지 않는다.
└─────────────────────────────────┘
```

## 보존되는 것

STML HTML의 모든 것이 사용자 결정이다:

- **어떤 API 엔드포인트**를 호출할지 (`data-fetch`, `data-action`)
- **어떤 필드**를 표시하거나 수집할지 (`data-bind`, `data-field`)
- **어떤 순서**로 요소가 나타날지 (DOM 구조)
- **어떻게 보일지** (Tailwind 클래스, HTML 태그)
- **어떤 텍스트**를 사용자가 볼지 (제목, 플레이스홀더, 버튼 레이블)
- **어떤 조건**이 가시성을 제어할지 (`data-state`)
- **어떤 컴포넌트**가 특수 UX를 처리할지 (`data-component`)
- **리스트 동작** — 페이지네이션, 정렬, 필터링

React도 아니고 Vue도 아니다. 페이지가 무엇을 하는지, 표준 HTML5로 선언한 것이다.

## 예시

```html
<main class="max-w-4xl mx-auto p-6">
  <h1 class="text-2xl font-bold mb-6">내 예약</h1>

  <section data-fetch="ListMyReservations"
           data-paginate data-sort="StartAt:desc" data-filter="Status">
    <ul data-each="reservations" class="space-y-3">
      <li class="flex justify-between p-4 border rounded">
        <span data-bind="RoomID" class="font-semibold"></span>
        <span data-bind="Status" class="text-sm text-gray-500"></span>
      </li>
    </ul>
    <p data-state="reservations.empty" class="text-gray-400">예약이 없습니다</p>
  </section>

  <div data-action="CreateReservation">
    <input data-field="RoomID" type="number" placeholder="방 번호" />
    <button type="submit">예약</button>
  </div>
</main>
```

같은 파일에서 다른 타겟을 생성할 수 있다:

| 타겟 | 방법 |
|---|---|
| React TSX | `stml gen` (내장 결정적 코드 생성) |
| Vue SFC | STML + OpenAPI를 LLM에게: "Vue로 구현해" |
| Svelte | STML + OpenAPI를 LLM에게: "Svelte로 구현해" |
| Flutter | STML + OpenAPI를 LLM에게: "Flutter로 구현해" |

결정은 보존된다. 프레임워크 배선만 바뀐다.

## 검증

내장 검증기가 코드 생성 전에 STML을 OpenAPI 대비 교차 검증한다:

- operationId가 존재하는가? HTTP 메서드가 맞는가?
- 요청 필드, 응답 필드, 파라미터가 스키마와 일치하는가?
- 정렬/필터/포함 컬럼이 허용 목록 안에 있는가?
- 참조된 컴포넌트가 존재하는가?

프론트엔드-API 불일치를 런타임이 아닌 CI 시점에 잡는다.

```bash
stml validate specs/my-project    # OpenAPI 대비 12가지 심볼릭 검사
```

## data-* 속성

| 속성 | 선언하는 것 |
|---|---|
| `data-fetch` | GET 엔드포인트에서 데이터를 로드 |
| `data-action` | POST/PUT/DELETE 엔드포인트에 데이터를 제출 |
| `data-field` | 요청 본문 필드를 수집하는 입력 |
| `data-bind` | 응답 필드를 표시하는 요소 |
| `data-param-*` | 경로/쿼리 파라미터가 필요한 작업 |
| `data-each` | 배열 필드를 반복하는 컨테이너 |
| `data-state` | 조건부로 표시되는 요소 |
| `data-component` | 커스텀 컴포넌트에 위임하는 요소 |
| `data-paginate` | 페이지네이션되는 리스트 |
| `data-sort` | 정렬 가능한 리스트 (기본 컬럼과 방향) |
| `data-filter` | 필터 가능한 리스트 (어떤 컬럼) |
| `data-include` | 관련 리소스를 포함하는 쿼리 |

## 라이선스

MIT — <a href="https://github.com/geul-org/stml" target="_blank" rel="noopener">GitHub</a>
