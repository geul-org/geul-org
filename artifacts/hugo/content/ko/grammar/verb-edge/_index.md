---
title: "동사 엣지"
weight: 10
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "verb", "huffman", "WordNet"]
summary: "13,767개 WordNet 동사를 10개 Primitive → 68개 Sub-primitive로 분류하고 허프만 코딩으로 16비트 코드북을 생성한다. Tiny(2워드)/Short(3워드)/Full(5워드) 3가지 패킷으로 평균 2.16워드 압축을 달성한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Verb Edge는 GEUL 스트림에서 서술/동작을 표현하는 Edge 타입이다. 13,767개 WordNet 동사를 10개 Primitive → 68개 Sub-primitive로 분류하고, **Sub-primitive 단위 허프만 코딩**으로 16비트 코드북을 생성한다.

## 하위 문서

| 문서 | 설명 |
|------|------|
| [참여자 역할](./semantic-role/) | 16개 Semantic Role (4비트 인코딩) |
| [의미 한정자](./qualifier/) | 증거성·서법·시제·상 등 14개 한정자 |

## 동사 계층 구조

```
10 Primitive (최상위 의미 범주)
 ├── BE          ├── PERCEIVE    ├── FEEL
 ├── THINK       ├── CHANGE      ├── CAUSE
 ├── MOVE        ├── COMMUNICATE ├── TRANSFER
 └── SOCIAL
  → 68 Sub-primitive (중간 분류)
    → 559 Root Verb (루트 동사)
      → 13,767 Leaf Verb (WordNet 전체 동사)
```

- Primitive(대분류)는 **개념적 그룹핑**만 담당하며 비트 할당 없음
- Sub-primitive(소분류) 68개에 **빈도 기반 가변 길이 코드** 할당
- 고빈도 동사군일수록 짧은 코드 (4비트 ~ 8비트)

## Verb Edge 패킷 타입

Tiny/Short/Full 3가지 패킷 타입 모두 마지막 워드에 동일한 **16비트 동사 본문**을 공유한다.

| | Tiny | Short | Full |
|--|------|-------|------|
| 워드 | 2 (32bit) | 3 (48bit) | 5 (80bit) |
| 참여자 | 16패턴 | 512패턴 | 19bit 플래그 |
| 한정자 | 7패턴 | 3,640패턴 | 27bit |
| 동사 본문 | 16bit | 16bit | 16bit |
| 예상 비율 | 90% | 7% | 3% |

**평균 패킷 크기:** 0.9×2 + 0.07×3 + 0.03×5 = **2.16워드**

### Tiny Verb Edge (2워드)

```
1st WORD:  [Prefix 5bit] [Target×패턴 11bit]
2nd WORD:  [동사 본문 16bit]
```

- Target×패턴: 18 Target × 113 패턴 = 2,034 조합
- 참여자 16패턴 × 한정자 7패턴 = 112 + 예약 1 = 113
- 커버율 ~90%

### Short Verb Edge (3워드)

```
1st WORD:  [Prefix 6bit] [Type 1bit=0] [참여자패턴 9bit]
2nd WORD:  [Target×한정자패턴 16bit]
3rd WORD:  [동사 본문 16bit]
```

### Full Verb Edge (5워드)

```
1st WORD:  [Prefix 6bit] [Type 1bit=1] [Target참여자 5bit] [참여자플래그 4bit]
2nd+3rd:   [참여자플래그 15bit] [한정자 17bit]
4th WORD:  [한정자 10bit] [예약 6bit]
5th WORD:  [동사 본문 16bit]
```

## 16비트 동사 본문

```
┌─────────────────────────┬────────────────────────────┐
│   sub_primitive code    │     트리 내 DFS index      │
│   (4-8비트, 허프만)      │     (8-12비트)             │
└─────────────────────────┴────────────────────────────┘
```

- **sub_primitive code:** 4~8비트 가변 (허프만 코드)
- **DFS index:** 해당 sub_primitive 내 개별 동사 식별

### 코드 길이 분포

| 코드 길이 | 개수 | 동사 수 합계 | 비율 |
|-----------|------|-------------|------|
| 4비트 | 4개 | 6,388 | 46.4% |
| 5비트 | 4개 | 2,479 | 18.0% |
| 6비트 | 8개 | 2,321 | 16.9% |
| 7비트 | 16개 | 1,786 | 13.0% |
| 8비트 | 36개 | 813 | 5.9% |

### DFS index 비트 계산

| sub_primitive 동사 수 | 필요 비트 |
|----------------------|-----------|
| 1~256 | 8비트 |
| 257~512 | 9비트 |
| 513~1024 | 10비트 |
| 1025~2048 | 11비트 |
| 2049~4096 | 12비트 |

예: CHANGE-TRANSFORM = `0000`(4비트) + 3,063개 동사(12비트) = 16비트.

### 평균 코드 길이

```
평균 = Σ(코드길이 × 동사수) / 총동사수 ≈ 5.14비트
```

| 방식 | 평균 비트 |
|------|-----------|
| 고정 7비트 (68개) | 7.00 |
| 허프만 코딩 | 5.14 |
| **절감** | **1.86비트 (27%)** |

## Primitive 대분류 (10개)

| Primitive | 의미 | Sub-primitive 수 | 동사 수 |
|-----------|------|------------------|---------|
| BE | 상태/존재 | 8 | 899 |
| PERCEIVE | 지각/인지 | 4 | 218 |
| FEEL | 감정 | 6 | 204 |
| THINK | 사고 | 6 | 769 |
| CHANGE | 변화 | 8 | 3,358 |
| CAUSE | 야기/행위 | 14 | 3,739 |
| MOVE | 이동 | 6 | 2,182 |
| COMMUNICATE | 소통 | 6 | 586 |
| TRANSFER | 이전 | 4 | 530 |
| SOCIAL | 사회적 행위 | 6 | 387 |

## 최고빈도 Sub-primitive (4비트 코드)

| Sub-primitive | 코드 | 동사 수 | 비율 | 예시 |
|---------------|------|---------|------|------|
| CHANGE-TRANSFORM | `0000` | 3,063 | 22.2% | "변하다", "되다" |
| CAUSE-USE | `0001` | 1,358 | 9.9% | "쓰다", "사용하다" |
| MOVE-DISPLACE | `0010` | 1,025 | 7.4% | "옮기다" |
| MOVE-GO | `0011` | 942 | 6.8% | "가다" |

상위 4개 Sub-primitive가 전체의 46.4%를 차지한다.

## 설계 철학

### 허프만 코딩 선택 이유

- CHANGE-TRANSFORM(22.2%)이 압도적 고빈도
- 고정 비트 할당 대비 **평균 비트 수 27% 절감**
- 상위 4개 sub_primitive가 전체의 46.4%

### Primitive 비트 제거 이유

- 기존: Primitive 3비트 + Sub_primitive 4비트 = 7비트 고정
- 변경: Sub_primitive 직접 코딩 = 4~8비트 가변
- 고빈도 동사에서 **최대 4비트 절감**

### 의미적 그룹핑 유지

Primitive 분류는 인간 가독성과 LLM 학습 시 의미 클러스터링 힌트를 위해 유지한다.
