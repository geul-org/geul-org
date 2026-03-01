---
title: "절 엣지"
weight: 40
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "clause", "RST", "discourse"]
summary: "서술, 사건, 관계 간의 논리적·담화적 관계를 표현하는 4워드 고정 Edge. RST 기반 16개 관계 타입으로 인과, 시간, 대조, 논증 관계를 인코딩한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Clause Edge는 서술([동사 엣지](../verb-edge/)), 사건([이벤트6 엣지](../event6-edge/)), 관계([트리플 엣지](../triple-edge/)), 또는 다른 Clause 간의 **논리적/담화적 관계**를 표현하는 Edge 타입이다.

RST(Rhetorical Structure Theory)의 담화 관계를 기반으로 설계되었다.

## 패킷 구조 (4워드, 64비트)

```
1st WORD (16비트):
┌─────────────────────┬────────────┬────────┐
│      Prefix         │  관계타입   │  예약   │
│       10비트         │   4비트    │  2비트  │
└─────────────────────┴────────────┴────────┘
 [1100 000 010]        [RRRR]       [xx]

2nd WORD: Edge TID (16비트)
3rd WORD: TID 1 (16비트) - 첫 번째 절
4th WORD: TID 2 (16비트) - 두 번째 절
```

| 필드 | 비트 | 설명 |
|------|------|------|
| Prefix | 10 | `1100 000 010` |
| 관계타입 | 4 | 16개 RST 관계 |
| 예약 | 2 | 미래 확장용 |
| Edge TID | 16 | 이 Edge의 고유 식별자 |
| TID 1 | 16 | 첫 번째 절 참조 |
| TID 2 | 16 | 두 번째 절 참조 |

## 관계 타입 (4비트 = 16개)

### 인과 관계

| 코드 | 타입 | 설명 | 예시 |
|------|------|------|------|
| 0000 | CAUSE | 원인→결과 | "비가 와서 집에 있었다" |
| 0001 | RESULT | 결과←원인 | "집에 있었다, 비가 왔기에" |
| 0010 | CONDITION | 조건→귀결 | "비가 오면 안 간다" |
| 0011 | PURPOSE | 목적 | "살기 위해 먹는다" |

### 시간/순서 관계

| 코드 | 타입 | 설명 | 예시 |
|------|------|------|------|
| 0100 | SEQUENCE | 시간순 | "밥 먹고 잤다" |
| 0101 | PARALLEL | 동시/병렬 | "웃으면서 말했다" |

### 대조/양보 관계

| 코드 | 타입 | 설명 | 예시 |
|------|------|------|------|
| 0110 | CONTRAST | 대조 | "A는 크고 B는 작다" |
| 0111 | CONCESSION | 양보 | "어렵지만 했다" |

### 부연/배경 관계

| 코드 | 타입 | 설명 | 예시 |
|------|------|------|------|
| 1000 | ELABORATION | 상세화 | "구체적으로 말하면" |
| 1001 | BACKGROUND | 배경 정보 | "참고로, 당시 상황은" |

### 논증 관계

| 코드 | 타입 | 설명 | 예시 |
|------|------|------|------|
| 1010 | EVIDENCE | 증거 제시 | "왜냐하면... 때문이다" |
| 1011 | EVALUATION | 평가 | "이것은 좋다/나쁘다" |

### 기타 관계

| 코드 | 타입 | 설명 | 예시 |
|------|------|------|------|
| 1100 | SOLUTIONHOOD | 문제→해결 | "문제는 X, 해결책은 Y" |
| 1101 | ALTERNATIVE | 선택/대안 | "가거나 말거나" |
| 1110 | MEANS | 수단 | "이렇게 해서 달성했다" |
| 1111 | RESERVED | 예약 | 미래 확장용 |

## TID 순서 규칙

방향은 TID 순서로 결정된다.

| 관계 | TID 1 | TID 2 |
|------|-------|-------|
| CAUSE | 원인 | 결과 |
| RESULT | 결과 | 원인 |
| CONDITION | 조건 | 귀결 |
| PURPOSE | 행위 | 목적 |
| SEQUENCE | 선행 | 후행 |
| EVIDENCE | 증거 | 주장 |
| ELABORATION | 핵심 | 부연 |

## Multinuclear vs Nucleus-Satellite

RST 구분을 따른다.

### Nucleus-Satellite (비대칭)

| 관계 | TID 1 | TID 2 |
|------|-------|-------|
| CAUSE | 원인 (Satellite) | 결과 (Nucleus) |
| CONDITION | 조건 (Satellite) | 귀결 (Nucleus) |
| EVIDENCE | 증거 (Satellite) | 주장 (Nucleus) |
| ELABORATION | 핵심 (Nucleus) | 부연 (Satellite) |

### Multinuclear (대칭)

| 관계 | TID 1 | TID 2 |
|------|-------|-------|
| SEQUENCE | 선행 | 후행 |
| PARALLEL | 첫 번째 | 두 번째 |
| CONTRAST | 첫 번째 | 두 번째 |
| ALTERNATIVE | 첫 번째 | 두 번째 |

대칭 관계에서 TID 순서는 의미적 우선순위를 나타내지 않는다.

## 예시

### 단순 인과: "비가 와서 집에 있었다"

```
Verb Edge E01: rain(비) | TID=0x0001
Verb Edge E02: stay(나, 집) | TID=0x0002

Clause Edge:
  1st: [1100 000 010] [0000] [00]  - Prefix + CAUSE + 예약
  2nd: [0x0100]                    - Edge TID
  3rd: [0x0001]                    - TID 1 (원인: E01)
  4th: [0x0002]                    - TID 2 (결과: E02)
```

### 중첩 Clause: "비가 와서 집에 있었고, 그래서 공부했다"

```
Verb Edge E01: rain(비) | TID=0x0001
Verb Edge E02: stay(나, 집) | TID=0x0002
Verb Edge E03: study(나) | TID=0x0003

Clause Edge C01:
  1st: [1100 000 010] [0000] [00]  - Prefix + CAUSE
  2nd: [0x0100]                    - Edge TID
  3rd: [0x0001]                    - E01
  4th: [0x0002]                    - E02

Clause Edge C02:
  1st: [1100 000 010] [0001] [00]  - Prefix + RESULT
  2nd: [0x0101]                    - Edge TID
  3rd: [0x0100]                    - C01 (Clause TID 참조!)
  4th: [0x0003]                    - E03
```

## 설계 근거

### RST 기반 이유

- 30년 이상의 연구 축적
- 다양한 코퍼스 검증
- 담화 파싱 도구 존재
- 언어 독립적

### 4비트(16개) 이유

- RST 핵심 관계 12개 이상 커버
- 확장 여유 확보
- 3비트(8개)는 부족

### 4워드 간소화 이유

- 방향: TID 순서로 결정 (별도 비트 불필요)
- 확신도: 별도 메타데이터로 처리
- 2비트 예약: 향후 확장
