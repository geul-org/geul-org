---
title: "참여자 역할"
weight: 10
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "participant", "semantic-role"]
summary: "사건 내부의 의미적 역할을 정의하는 16개 Participant. 4비트 인코딩으로 Agent, Theme, Recipient 등 핵심 역할부터 Cause, Purpose 등 부가 역할까지 표현한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**참여자(Participant)**는 서술 내에서 사건에 관여하는 개체의 **의미적 역할**을 명시하는 Edge이다.

```
Event Node (동사)
    ├─ PARTICIPANT Edge (role=Agent) ──→ Entity Node
    ├─ PARTICIPANT Edge (role=Theme) ──→ Entity Node
    └─ PARTICIPANT Edge (role=Instrument) ──→ Entity Node
```

## 설계 원칙

### 분리 원칙

| 구분 | 소속 | 예시 |
|------|------|------|
| **참여자** | Event 레벨 | Agent, Theme, Recipient |
| **화용 정보** | Context/Claim 레벨 | Speaker, Listener, Evidentiality |

Speaker(화자), Listener(청자), Source(정보출처)는 참여자가 아닌 **[의미 한정자](../qualifier/)** 또는 Context/Claim에서 처리한다.

### 인코딩

- **4비트** (0x0~0xF), 최대 16개 의미역
- SIMD 비트 연산으로 패턴 매칭 가능

## 의미역 목록 (16개)

### 핵심 참여자 (Core Participants)

| ID | 코드 | 역할 | 정의 | 예시 |
|----|------|------|------|------|
| 0x0 | **AGT** | Agent (행위자) | 의도적으로 행동을 수행하는 주체 | "**철수가** 공을 찼다" |
| 0x1 | **EXP** | Experiencer (경험자) | 감정/인지/지각을 경험하는 주체 | "**영희가** 슬펐다" |
| 0x2 | **THM** | Theme (대상) | 이동하거나 상태가 기술되는 대상 | "철수가 **공을** 찼다" |
| 0x3 | **PAT** | Patient (피영향자) | 행동에 의해 상태가 변하는 대상 | "**유리창이** 깨졌다" |
| 0x4 | **RCP** | Recipient (수혜자) | 무언가를 받는 대상 | "**영희에게** 책을 줬다" |
| 0x5 | **BNF** | Beneficiary (수익자) | 행동의 이익을 얻는 대상 | "**아이를 위해** 만들었다" |

### 도구/수단 (Instruments & Means)

| ID | 코드 | 역할 | 정의 | 예시 |
|----|------|------|------|------|
| 0x6 | **INS** | Instrument (도구) | 행동 수행에 사용되는 도구 | "**망치로** 못을 박았다" |
| 0x7 | **MNR** | Manner (방식) | 행동이 수행되는 방식 | "**빠르게** 달렸다" |

### 공간/이동 (Spatial)

| ID | 코드 | 역할 | 정의 | 예시 |
|----|------|------|------|------|
| 0x8 | **LOC** | Location (장소) | 사건이 발생하는 위치 | "**서울에서** 살았다" |
| 0x9 | **SRC** | Source (출발점) | 이동의 시작점 | "**집에서** 출발했다" |
| 0xA | **DST** | Destination (목적지) | 이동의 도착점 | "**학교로** 갔다" |
| 0xB | **PTH** | Path (경로) | 이동의 경유지 | "**공원을 지나** 갔다" |

### 원인/목적 (Causal)

| ID | 코드 | 역할 | 정의 | 예시 |
|----|------|------|------|------|
| 0xC | **CAU** | Cause (원인) | 사건의 원인 | "**비 때문에** 취소됐다" |
| 0xD | **PRP** | Purpose (목적) | 행동의 목적 | "**운동하러** 갔다" |

### 기타 (Others)

| ID | 코드 | 역할 | 정의 | 예시 |
|----|------|------|------|------|
| 0xE | **COM** | Comitative (동반) | 함께하는 대상 | "**친구와** 갔다" |
| 0xF | **ATR** | Attribute (속성) | 상태/속성 서술 | "하늘이 **파랗다**" |

## Participant Edge 구조

```
PARTICIPANT Edge {
    source:     Event SIDX       // 동사 노드
    target:     Entity SIDX      // 개체 노드
    role:       4-bit            // 의미역 (0x0~0xF)
    gram_role:  2-bit (optional) // 문법적 역할 (주어/목적어/보어)
    focus:      4-bit (optional) // 강조도 (0~15 → 0.0~1.0)
    quant_ref:  TID (optional)   // 한정자 참조
}
```

| 필드 | 비트 | 설명 |
|------|------|------|
| role | 4 | 의미역 (필수) |
| gram_role | 2 | 0=미지정, 1=주어, 2=목적어, 3=보어 |
| focus | 4 | 정보적 중요도 (0=배경, 15=핵심 강조) |
| quant_ref | 16 | "모든", "대부분" 등 한정자 TID |

## Theme vs Patient

| 역할 | 상태 변화 | 예시 |
|------|----------|------|
| Theme | 없음 (이동/기술) | "공을 **던졌다**" (공은 그대로) |
| Patient | 있음 (영향받음) | "유리를 **깼다**" (유리 상태 변화) |

실용적으로는 Theme으로 통합하고, 필요시 동사 의미로 구분할 수 있다.

## 예시

### 단순문: "철수가 영희에게 책을 줬다"

```
Event: give.v.01
├─ PARTICIPANT (AGT) → 철수
├─ PARTICIPANT (THM) → 책
└─ PARTICIPANT (RCP) → 영희
```

### 복합문: "비 때문에 친구와 함께 집에서 학교로 빠르게 뛰어갔다"

```
Event: run.v.01
├─ PARTICIPANT (AGT) → [화자]
├─ PARTICIPANT (CAU) → 비
├─ PARTICIPANT (COM) → 친구
├─ PARTICIPANT (SRC) → 집
├─ PARTICIPANT (DST) → 학교
└─ PARTICIPANT (MNR) → 빠르게
```

### 상태 서술: "하늘이 매우 파랗다"

```
Event: be.v.01
├─ PARTICIPANT (THM) → 하늘
└─ PARTICIPANT (ATR) → 파랗다 (focus=15)
```

## 능동/수동 정규화

| 표면형 | Agent | Theme |
|--------|-------|-------|
| "Apple이 Tesla를 인수했다" | Apple | Tesla |
| "Tesla가 Apple에 인수됐다" | Apple | Tesla |

파싱 단계에서 정규화하여 동일 패턴으로 처리한다.
