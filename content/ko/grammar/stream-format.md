---
title: "스트림 포맷"
weight: 100
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "stream", "TID"]
summary: "GEUL 스트림은 Meta Node로 시작하고 끝나는 패킷 시퀀스이다. TID 스코핑, 순방향 참조, 패킷 순서 규칙을 정의한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

GEUL 스트림은 **Meta Node로 시작하고 끝나는 패킷 시퀀스**이며, 하나의 완결된 GEUL 문서이다.

## 핵심 특징

- **경계 명시:** STREAM_START / STREAM_END (Meta Node)
- **TID 스코프:** 스트림 내에서만 유효
- **순방향 참조:** 선언된 TID만 참조 가능
- **Big Endian:** Network Byte Order

## 스트림 구조

```
┌─────────────────────────────────────┐
│          STREAM_START               │  ← 필수 (Meta Node)
│          (TID 폭 선언)               │     0xC000 (16비트 TID)
├─────────────────────────────────────┤
│          메타데이터 (선택)            │
│          - VERSION    (0xC014)      │
│          - CREATED_AT (0xC008)      │
│          - CREATOR    (0xC010)      │
├─────────────────────────────────────┤
│          본문 패킷들                  │
│          - Entity Node              │
│          - Quantity Node            │
│          - Verb Edge                │
│          - Triple Edge              │
│          - Event6 Edge              │
│          - Clause Edge              │
│          - Context Edge             │
│          - Group Edge               │
│          - Faber Edge               │
├─────────────────────────────────────┤
│          STREAM_END                 │  ← 선택 (권장)
└─────────────────────────────────────┘
```

최소 스트림은 `STREAM_START`(1워드) + `STREAM_END`(1워드) = 2워드(4바이트)이며, 빈 스트림도 유효하다.

## TID 할당 원칙

| 규칙 | 설명 |
|------|------|
| **필수성** | 스트림 내 모든 Edge/Node는 TID를 가진다 |
| **유일성** | 스트림 내에서 TID는 유일하다 |
| **스코프** | TID는 해당 스트림 내에서만 유효하다 |
| **순방향** | 참조 시점에 이미 선언된 TID만 참조 가능 |

### TID 위치

| 타입 | TID 위치 | 참조 위치 |
|------|----------|-----------|
| **Meta Node** | 없음 | 없음 |
| **Entity Node** | 마지막 워드 | 없음 |
| **Quantity Node** | 마지막 워드 | 없음 |
| **Tiny Verb Edge** | 없음 | 없음 (인라인) |
| **Verb Edge** | Header 영역 | Payload 이후 |
| **Triple Edge** | Header 영역 | Payload 이후 |
| **Event6 Edge** | Header 영역 | Payload 이후 |
| **Clause Edge** | Header 영역 | Payload 이후 |
| **Context Edge** | Header 영역 | Payload 이후 |
| **Group Edge** | 2nd 워드 | 3rd+ 워드 |

**Node**는 자기 자신만 정의하므로 TID가 마지막에, **Edge**는 다른 TID를 참조하므로 TID가 참조보다 앞에 위치한다.

### 예약 TID

| TID | 용도 |
|-----|------|
| 0x0000 | **종결 마커** ([그룹 엣지](../group-edge/) 등) |
| 0xFFFF | 예약 (16비트 기준) |

## 패킷 순서 규칙

### 선언-참조 순서

```
✅ 올바름:
  [Entity: 철수, TID=0x0001]
  [Entity: 영희, TID=0x0002]
  [Verb Edge: 만나다, Subject=0x0001, Object=0x0002]

❌ 잘못됨:
  [Verb Edge: 만나다, Subject=0x0001, Object=0x0002]  ← 0x0001 미선언
  [Entity: 철수, TID=0x0001]
  [Entity: 영희, TID=0x0002]
```

### 권장 순서

```
1. STREAM_START
2. 메타데이터 (VERSION, CREATED_AT, CREATOR)
3. Entity Node들 (개체 선언)
4. Quantity Node들 (수량/리터럴)
5. Group Edge들 (그룹 정의)
6. Tiny Verb Edge들 (인라인 서술)
7. Verb Edge들 (일반 서술)
8. Triple Edge들 (속성/관계)
9. Event6 Edge들 (사건)
10. Clause Edge들 (담화 관계)
11. Context Edge들 (맥락)
12. Faber Edge들 (코드/AST)
13. STREAM_END
```

권장 순서일 뿐, 선언-참조 규칙만 지키면 자유롭게 배치할 수 있다.

### 순환 참조 금지

A → B → A 형태의 순환 참조는 불가능하다. 순환 관계가 필요한 경우 별도 Edge로 표현한다.

```
✅ 가능:
  [Entity A, TID=0x0001]
  [Entity B, TID=0x0002]
  [Edge: A→B, TID=0x0003]
  [Edge: B→A, TID=0x0004]
```

## 스트림 예시

### "철수가 영희를 만났다"

```
1. STREAM_START (TID 16비트)
   0xC0 0x00

2. Entity: 철수 (TID=0x0001)
   [Entity 패킷...] 0x00 0x01

3. Entity: 영희 (TID=0x0002)
   [Entity 패킷...] 0x00 0x02

4. Verb Edge: meet (TID=0x0100)
   Subject: 0x0001
   Object: 0x0002

5. STREAM_END
   0xC0 0x04
```

### "철수와 영희가 학교에서 만났다"

```
1. STREAM_START
   0xC0 0x00

2. Entity: 철수 (TID=0x0001)
3. Entity: 영희 (TID=0x0002)
4. Entity: 학교 (TID=0x0003)

5. Group Edge: AND (TID=0x0010)
   멤버: 0x0001, 0x0002, 0x0000 (종결)

6. Verb Edge: meet (TID=0x0100)
   Subject: 0x0010 (그룹)
   Location: 0x0003

7. STREAM_END
   0xC0 0x04
```

## 스트림 검증

### 필수 검증

| 항목 | 검증 |
|------|------|
| 시작 | STREAM_START로 시작하는가? |
| TID 유일성 | 중복 TID가 없는가? |
| 참조 유효성 | 참조된 TID가 모두 선언되었는가? |
| 순방향 | 참조 시점에 TID가 이미 선언되었는가? |

### 검증 코드

```python
def validate_stream(packets: list) -> dict:
    """스트림 유효성 검증"""
    errors = []
    declared_tids = set()

    # 시작 검증
    if not packets or packets[0].type != "STREAM_START":
        errors.append("스트림이 STREAM_START로 시작하지 않음")

    for packet in packets:
        # TID 유일성 검증
        if packet.tid is not None:
            if packet.tid in declared_tids:
                errors.append(f"중복 TID: {packet.tid}")
            declared_tids.add(packet.tid)

        # 참조 유효성 검증
        for ref_tid in packet.references:
            if ref_tid not in declared_tids:
                errors.append(f"미선언 TID 참조: {ref_tid}")

    return {
        "valid": len(errors) == 0,
        "errors": errors,
        "tid_count": len(declared_tids)
    }
```

## 다중 스트림

각 스트림은 독립적이며, TID 스코프는 스트림별로 분리된다. Stream A의 TID=0x0001과 Stream B의 TID=0x0001은 다른 개체이다.

스트림 간 참조(Cross-reference)는 현재 미지원이며, 향후 스트림 ID 도입과 Import/Export 메커니즘으로 확장할 수 있다.
