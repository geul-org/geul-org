---
title: "왜 주석이 인덱스여야 하는가"
weight: 20
date: 2026-03-01T15:00:00+09:00
lastmod: 2026-03-01T15:00:00+09:00
tags: ["인덱스", "주석", "코드", "AST", "디자인패턴"]
summary: "주석은 사람을 위해 쓴다. 그러나 함수가 10,000개일 때 기계도 읽어야 한다. 주석을 서사에서 인덱스로 바꾸면, 풀스캔이 즉시 검색이 된다."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

주석은 사람을 위해 쓴다.

```go
// GetUser retrieves a user by ID from the database.
func GetUser(id string) (*User, error) {
```

이 주석은 사람이 읽으면 도움이 된다. 그런데 기계가 읽으면 아무것도 모른다. "retrieves"가 Read인지 Search인지 모른다. "user"가 어떤 엔티티인지 모른다. 이 함수가 Service 패턴인지 Repository 패턴인지 모른다.

주석이 서사이기 때문이다.

---

## 함수가 10,000개일 때

함수가 10개일 때는 상관없다. 사람이 전부 읽으면 된다.

함수가 10,000개일 때는 다르다. "결제 관련 함수 전부 보여줘"라고 했을 때, 사람도 못 찾고 기계도 못 찾는다. 이름에 "payment"가 들어간 것만 찾는다. 이름에 안 들어가 있으면 놓친다.

AI 에이전트가 코드를 수정할 때도 같다. Claude Code에게 "PaymentFailed 에러 처리 수정해"라고 하면, 에이전트는 전체 코드를 다시 읽는다. 매번. 함수 10,000개를 매번 처음부터 파악한다. 어제 읽은 코드를 오늘 또 읽는다. 주석이 있어도 똑같다. 주석이 사람용 서사니까. 기계가 서사에서 의미를 추출하려면 추론이 필요하다. 비싸다.

---

## 주석이 인덱스면

```go
// CreateOrder processes a new order creation.
//
// # Pattern: Service, Transactional
// # Entity: Order
// # Action: Create
// # Input: CreateOrderRequest {items:[]Item, userID:string}
//          pre: items>0 userID!=''
// # Output: *OrderResponse, error
//          errs: [StockInsufficient, PaymentFailed]
// # Deps: InventorySvc, PaymentGateway
func (s *OrderService) CreateOrder(req CreateOrderRequest) (*OrderResponse, error) {
```

이 주석은 사람도 읽을 수 있고, 기계도 읽을 수 있다.

"Service 패턴인 모든 함수" → Pattern 필드 검색. 즉시.
"Order 엔티티 관련 모든 함수" → Entity 필드 검색. 즉시.
"PaymentFailed를 발생시키는 함수" → errs 필드 검색. 즉시.

풀스캔이 인덱스 검색으로 바뀐다. O(n)이 O(1)이 된다.

---

## 사람이 쓸 필요가 없다

이 인덱스를 사람이 작성할 필요가 없다.

코드가 수정되면 자동으로 감지한다. 파일 워칭.
수정된 함수를 AST로 분리한다. 기계적.
함수 본체를 소형 LLM에 넘긴다. "이 함수의 패턴, 엔티티, 액션을 판단해라."
판단 결과를 정해진 포맷으로 삽입한다. 기계적.

사람은 아무것도 하지 않는다. 코드만 쓰면 된다. 인덱스는 자동으로 붙는다.

전체 파이프라인에서 LLM이 개입하는 지점은 딱 하나 — 함수의 의미를 판단하는 것. 나머지는 전부 결정적 코드다.

---

## 추론에서 규칙으로

여기서 한 단계 더 간다.

소형 LLM이 같은 패턴에 같은 인덱스를 반복적으로 붙이면 — 그 반복을 감지한다. "Service suffix에 receiver method면 Pattern:Service"가 100번 반복됐으면, 규칙으로 굳힌다. 이후 LLM을 호출하지 않는다. 규칙이 처리한다.

LLM 호출이 점점 줄어든다. 규칙이 점점 늘어난다. 비용이 0에 수렴한다.

주석이 서사에서 인덱스로 바뀌고,
인덱스가 수동에서 자동으로 바뀌고,
자동이 추론에서 규칙으로 바뀐다.

---

## 왜 가능한가: 디자인 패턴이라는 코드북

이것이 가능한 이유가 있다.

프로그래밍에는 이미 표준화된 의미 어휘가 있다. 디자인 패턴이다.

Singleton, Factory, Observer, MVC, Service. GoF가 1994년에 23개 패턴을 정리한 이후, 소프트웨어 업계는 30년간 이 어휘를 확장하고 표준화해왔다.

GoF 23패턴. Enterprise Application Patterns. Cloud Design Patterns. Go Concurrency Patterns. 전부 이미 정리되어 있다.

이 어휘들은 모호하지 않다. Singleton은 Singleton이다. 개발자마다 다르게 해석하지 않는다. 정의가 합의되어 있고, 구현 조건이 명확하고, 위반하면 코드 리뷰에서 잡힌다.

이 어휘 체계가 인덱스의 코드북이 된다. 새로 만들 필요가 없다. 이미 있다.

자연어에는 이것이 없다. "위대하다"는 사전에 정의가 있지만 사람마다 다르게 쓴다. 코드에서는 Service가 사람마다 다르게 쓰이지 않는다.

---

## 왜 코드가 가장 쉬운 도메인인가

GEUL의 컨텍스트 파이프라인 — [명확화](/ko/why/clarification/), [인덱싱](/ko/why/semantically-aligned-index/), [검증](/ko/why/mechanical-verification/), [필터링](/ko/why/filter/), [정합성](/ko/why/consistency-check/), [탐색](/ko/why/exploration/) — 을 자연어에 적용하는 것은 어렵다. 코드에 적용하는 것은 쉽다.

명확화: 자연어는 모호하다. 코드는 컴파일러가 통과시켰으면 의미가 확정된 것이다.
인덱싱: 자연어의 엔티티는 문맥을 봐야 안다. 코드의 엔티티는 AST가 이미 파싱해놓았다.
검증: 자연어의 유효성은 정의할 수 없다. 코드의 유효성은 컴파일러가 판단한다.
필터링: 자연어의 관련성은 LLM이 판단해야 한다. 코드의 관련성은 호출 그래프로 기계적으로 판단할 수 있다.
정합성: 자연어의 모순은 추론해야 발견된다. 코드의 모순은 타입 시스템과 테스트가 잡아준다.
탐색: 자연어 지식은 평면적이다. 코드는 패키지 → 파일 → 타입 → 메서드의 계층 구조가 이미 있다.

같은 파이프라인이, 코드 도메인에서는 훨씬 적은 비용으로 작동한다. 가장 쉬운 곳에서 먼저 증명하고, 어려운 곳으로 확장하는 것. 이것이 공학이다.

---

## 정리

주석은 원래 사람을 위한 것이었다.
이제 기계를 위한 것이기도 해야 한다.
사람이 읽을 수 있되, 기계가 검색할 수 있는 주석.
서사이되 인덱스인 주석.

코드는 이미 의미가 있고, 이미 구조가 있고, 이미 어휘가 있다.
없는 것은 인덱스뿐이다.
주석이 그 인덱스가 되면 된다.
