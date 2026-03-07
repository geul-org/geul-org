---
title: "이벤트6 엣지"
weight: 50
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "event6", "5W1H"]
summary: "6하원칙(Who, What, Whom, When, Where, Why)을 한 번에 표현하는 가변 길이 사건 Edge. Presence 비트마스크로 3~8워드 가변 구조를 실현한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Event6 Edge는 **6하원칙**(Who, What, Whom, When, Where, Why)을 한 번에 표현하는 사건 Edge 타입이다.

## 6하원칙 요소

| 요소 | 영문 | 비트 | 의미 | TID 참조 대상 |
|------|------|------|------|---------------|
| Who | Agent | 0 | 행위자 | [엔티티 노드](../entity-node/) |
| What | Action | 1 | 행위/동작 | [동사 엣지](../verb-edge/) |
| Whom | Patient | 2 | 대상/피행위자 | [엔티티 노드](../entity-node/) |
| When | Time | 3 | 시간 | Quantity/Entity |
| Where | Location | 4 | 장소 | [엔티티 노드](../entity-node/) |
| Why | Reason | 5 | 이유/목적 | [절 엣지](../clause-edge/)/Entity |

## 패킷 구조

```
1st WORD (16비트)
┌────────────────────┬────────────────────┐
│      Prefix        │     Presence       │
│      10bit         │       6bit         │
└────────────────────┴────────────────────┘

2nd WORD (16비트)
┌────────────────────────────────────────────┐
│                Edge TID                    │
└────────────────────────────────────────────┘

3rd+ WORD: 요소 TID들 (Presence 순서대로)
```

### Presence 비트마스크 (6비트)

| 비트 | 요소 | 있으면 |
|------|------|--------|
| 0 | Who | 해당 TID 포함 |
| 1 | What | 해당 TID 포함 |
| 2 | Whom | 해당 TID 포함 |
| 3 | When | 해당 TID 포함 |
| 4 | Where | 해당 TID 포함 |
| 5 | Why | 해당 TID 포함 |

총 워드 = 2 (헤더 + Edge TID) + popcount(Presence). 범위는 3~8워드(48~128비트)이다.

## 모드별 구조

### 최소 모드 (3워드)

```
예: "비가 왔다" (What만)

1st: [Prefix] + [000010]      - What만 존재
2nd: [Edge TID]
3rd: [What TID]               - "rain" Verb Edge
```

### 핵심 모드 (5워드)

Who + What + Whom. 가장 빈번한 구성이다.

```
예: "철수가 영희를 때렸다"

1st: [Prefix] + [000111]      - Who, What, Whom
2nd: [Edge TID]
3rd: [Who TID]                - 철수
4th: [What TID]               - "hit" Verb Edge
5th: [Whom TID]               - 영희
```

### 표준 모드 (6워드)

```
예: "철수가 어제 영희를 만났다"

1st: [Prefix] + [001111]      - Who, What, Whom, When
2nd: [Edge TID]
3rd: [Who TID]                - 철수
4th: [What TID]               - "meet" Verb Edge
5th: [Whom TID]               - 영희
6th: [When TID]               - 어제
```

### 완전 모드 (8워드)

```
예: "철수가 사랑 때문에 어제 학교에서 영희에게 선물을 줬다"

1st: [Prefix] + [111111]      - 전체
2nd: [Edge TID]
3rd: [Who TID]                - 철수
4th: [What TID]               - "give" Verb Edge
5th: [Whom TID]               - 영희
6th: [When TID]               - 어제
7th: [Where TID]              - 학교
8th: [Why TID]                - 사랑 (이유)
```

## 요소 상세

### What (행위)

What은 [동사 엣지](../verb-edge/) TID를 참조한다. 해당 Verb Edge에 시제, 상 등 한정자 정보가 담긴다.

### Why (이유)

단순한 이유는 Entity TID("사랑")로, 복잡한 이유는 [절 엣지](../clause-edge/) TID("비가 와서")로 표현한다.

## Event6 vs Verb Edge 비교

| | Verb Edge | Event6 Edge |
|--|-----------|-------------|
| **초점** | 서술/동작 | 완결된 사건 |
| **참여자** | Participant 구조 | 6하원칙 TID |
| **시공간** | 별도 표현 | When/Where 내장 |
| **이유** | 별도 Clause | Why 내장 |
| **워드** | 2~5 | 3~8 |
| **용도** | 서술 표현 | 사건 저장 |

**선택 가이드:** 서술/문장 분석에는 Verb Edge, 사건/기록 저장에는 Event6 Edge, 간단한 사실에는 [트리플 엣지](../triple-edge/)를 사용한다.

## 예시

### "Apple이 Tesla를 인수했다"

```
Who:  Apple (Q312)     → Entity TID 0x0001
What: acquire          → Verb Edge TID 0x0100
Whom: Tesla (Q478214)  → Entity TID 0x0002

Event6 Edge:
  1st: [1100 000 011] + [000111]  - Prefix + Who,What,Whom
  2nd: [TID: 0x0200]              - Edge TID
  3rd: [TID: 0x0001]              - Apple (Who)
  4th: [TID: 0x0100]              - acquire (What)
  5th: [TID: 0x0002]              - Tesla (Whom)

총: 5워드
```

### "이순신이 1598년 노량해전에서 전사했다"

```
Who:   이순신           → Entity TID 0x0010
What:  die (전사)       → Verb Edge TID 0x0101
When:  1598            → Entity TID 0x0011
Where: 노량해전         → Entity TID 0x0012

Event6 Edge:
  1st: [1100 000 011] + [011011]  - Who,What,When,Where
  2nd: [TID: 0x0202]
  3rd: [TID: 0x0010]              - 이순신
  4th: [TID: 0x0101]              - die
  5th: [TID: 0x0011]              - 1598
  6th: [TID: 0x0012]              - 노량해전

총: 6워드
```

## 파싱

```python
def parse_event6(data: bytes) -> dict:
    word1 = int.from_bytes(data[0:2], 'big')

    prefix = word1 >> 6
    assert prefix == 0b1100000011, "Not Event6 Edge"

    presence = word1 & 0x3F
    edge_tid = int.from_bytes(data[2:4], 'big')

    elements = {}
    element_names = ['who', 'what', 'whom', 'when', 'where', 'why']
    offset = 4

    for i, name in enumerate(element_names):
        if presence & (1 << i):
            tid = int.from_bytes(data[offset:offset+2], 'big')
            elements[name] = tid
            offset += 2

    return {
        'presence': presence,
        'edge_tid': edge_tid,
        'elements': elements,
        'words': 2 + bin(presence).count('1')
    }
```
