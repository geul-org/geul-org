---
title: "트리플 엣지"
weight: 30
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "triple", "property"]
summary: "(Subject, Property, Object) 형태의 관계와 속성을 표현하는 Edge 타입. 기본 모드 4워드와 확장 모드 5워드의 이중 구조로 Top 63 고빈도 속성을 최적화한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Triple Edge는 `(Subject, Property, Object)` 형태의 **관계/속성**을 표현하는 Edge 타입이다.

## 이중 모드 설계

- **기본 모드 (4워드):** PropCode 0~62 (Top 63 속성)
- **확장 모드 (5워드):** PropCode=63이면 전체 P-ID 커버 (의미정렬 16비트)

## 기본 모드 (4워드 = 64비트)

```
1st WORD (16비트)
┌────────────────────┬────────────────────┐
│      Prefix        │     PropCode       │
│      10bit         │       6bit         │
└────────────────────┴────────────────────┘

2nd WORD: Edge TID (16비트)
3rd WORD: Subject TID (16비트)
4th WORD: Object TID (16비트)
```

| 필드 | 비트 | 설명 |
|------|------|------|
| Prefix | 10 | `1100 000 001` |
| PropCode | 6 | 0~62: Top 63 속성, 63: 확장 모드 |
| Edge TID | 16 | 이 Edge의 TID |
| Subject TID | 16 | 주어 Entity/Node TID |
| Object TID | 16 | 목적어 Entity/Node/Quantity TID |

## 확장 모드 (5워드 = 80비트)

PropCode가 63이면 3rd 워드에 16비트 P-ID가 추가된다.

```
1st WORD: [Prefix 10bit] + [PropCode=63 6bit]
2nd WORD: Edge TID (16비트)
3rd WORD: P-ID 의미정렬 (16비트)
4th WORD: Subject TID (16비트)
5th WORD: Object TID (16비트)
```

## Top 63 속성 (PropCode 0~62)

위키데이터 사용 빈도 기반으로 선정된 속성들이다.

### 분류/타입 (Code 0~7)

| Code | P-ID | 속성명 | 설명 |
|------|------|--------|------|
| 0 | P31 | instance of | ~의 인스턴스 |
| 1 | P279 | subclass of | ~의 하위 클래스 |
| 2 | P361 | part of | ~의 부분 |
| 3 | P527 | has part | ~을 포함 |
| 4 | P1552 | has quality | 속성/특성 |
| 5 | P460 | same as | 동일 |
| 6 | P1889 | different from | 다름 |
| 7 | P156 | followed by | 후속 |

### 공간/위치 (Code 8~15)

| Code | P-ID | 속성명 | 설명 |
|------|------|--------|------|
| 8 | P17 | country | 국가 |
| 9 | P131 | located in | 위치 (행정구역) |
| 10 | P276 | location | 위치 (장소) |
| 11 | P625 | coordinate | 좌표 |
| 12 | P30 | continent | 대륙 |
| 13 | P36 | capital | 수도 |
| 14 | P150 | contains | 포함 (지역) |
| 15 | P206 | located next to | 인접 수역 |

### 시간 (Code 16~23)

| Code | P-ID | 속성명 | 설명 |
|------|------|--------|------|
| 16 | P569 | date of birth | 생년월일 |
| 17 | P570 | date of death | 사망일 |
| 18 | P571 | inception | 설립일 |
| 19 | P576 | dissolved | 해산일 |
| 20 | P577 | publication date | 발표일 |
| 21 | P580 | start time | 시작 시점 |
| 22 | P582 | end time | 종료 시점 |
| 23 | P585 | point in time | 시점 |

### 인물 기본 (Code 24~31)

| Code | P-ID | 속성명 | 설명 |
|------|------|--------|------|
| 24 | P19 | place of birth | 출생지 |
| 25 | P20 | place of death | 사망지 |
| 26 | P21 | sex or gender | 성별 |
| 27 | P27 | citizenship | 국적 |
| 28 | P735 | given name | 이름 |
| 29 | P734 | family name | 성 |
| 30 | P1559 | name in native language | 본명 |
| 31 | P742 | pseudonym | 필명/예명 |

### 관계/소속 (Code 32~39)

| Code | P-ID | 속성명 | 설명 |
|------|------|--------|------|
| 32 | P22 | father | 아버지 |
| 33 | P25 | mother | 어머니 |
| 34 | P26 | spouse | 배우자 |
| 35 | P40 | child | 자녀 |
| 36 | P3373 | sibling | 형제자매 |
| 37 | P463 | member of | 소속 |
| 38 | P108 | employer | 고용주 |
| 39 | P1027 | conferred by | 수여 기관 |

### 직업/활동 (Code 40~47)

| Code | P-ID | 속성명 | 설명 |
|------|------|--------|------|
| 40 | P106 | occupation | 직업 |
| 41 | P39 | position held | 직위 |
| 42 | P69 | educated at | 학력 |
| 43 | P101 | field of work | 분야 |
| 44 | P1344 | participant in | 참가 (이벤트) |
| 45 | P166 | award received | 수상 |
| 46 | P800 | notable work | 대표작 |
| 47 | P1412 | languages spoken | 사용 언어 |

### 미디어/식별 (Code 48~55)

| Code | P-ID | 속성명 | 설명 |
|------|------|--------|------|
| 48 | P18 | image | 이미지 |
| 49 | P154 | logo | 로고 |
| 50 | P41 | flag image | 국기/기 |
| 51 | P373 | Commons category | 위키미디어 |
| 52 | P856 | official website | 공식 웹사이트 |
| 53 | P214 | VIAF ID | VIAF |
| 54 | P227 | GND ID | GND |
| 55 | P213 | ISNI | ISNI |

### 작품/창작 (Code 56~62)

| Code | P-ID | 속성명 | 설명 |
|------|------|--------|------|
| 56 | P50 | author | 저자 |
| 57 | P57 | director | 감독 |
| 58 | P86 | composer | 작곡가 |
| 59 | P175 | performer | 연주자/가수 |
| 60 | P136 | genre | 장르 |
| 61 | P364 | original language | 원어 |
| 62 | P123 | publisher | 출판사 |

Code 63은 **확장 모드 표시자**로 예약되어 있다.

## PropCode 요약

```
┌─────────────────────────────────────────────┐
│  0~7:   분류/타입 (P31, P279, ...)          │
│  8~15:  공간/위치 (P17, P131, ...)          │
│  16~23: 시간 (P569, P570, ...)              │
│  24~31: 인물 기본 (P19, P20, ...)           │
│  32~39: 관계/소속 (P22, P25, ...)           │
│  40~47: 직업/활동 (P106, P39, ...)          │
│  48~55: 미디어/식별 (P18, P856, ...)        │
│  56~62: 작품/창작 (P50, P57, ...)           │
├─────────────────────────────────────────────┤
│  63: 확장 모드 표시자                        │
└─────────────────────────────────────────────┘
```

## 예시

### 기본 모드: "Apple은 회사이다"

```
P31 (instance of) → PropCode = 0

Triple Edge:
  1st: [1100 000 001] + [000000]  - Prefix + PropCode 0
  2nd: [TID: 0x0101]              - Edge TID
  3rd: [TID: 0x0010]              - Apple (Subject)
  4th: [TID: 0x0020]              - 회사 (Object)

총: 4워드
```

### 확장 모드: "에펠탑의 높이는 330m"

```
P2048 (height) → Top 63 외 → 확장 모드

Triple Edge:
  1st: [1100 000 001] + [111111]  - Prefix + Ext(63)
  2nd: [TID: 0x0102]              - Edge TID
  3rd: [0xA800]                   - P2048 의미정렬
  4th: [TID: 0x0030]              - 에펠탑 (Subject)
  5th: [TID: 0x0050]              - 330m Quantity (Object)

총: 5워드
```

## 파싱

```python
def parse_triple_edge(data: bytes) -> dict:
    word1 = int.from_bytes(data[0:2], 'big')

    prefix = word1 >> 6
    assert prefix == 0b1100000001, "Not Triple Edge"

    prop_code = word1 & 0x3F

    if prop_code < 63:
        # 기본 모드 (4워드)
        return {
            'mode': 'basic',
            'prop_code': prop_code,
            'edge_tid': int.from_bytes(data[2:4], 'big'),
            'subject_tid': int.from_bytes(data[4:6], 'big'),
            'object_tid': int.from_bytes(data[6:8], 'big'),
            'words': 4
        }
    else:
        # 확장 모드 (5워드)
        return {
            'mode': 'extended',
            'p_id': int.from_bytes(data[4:6], 'big'),
            'edge_tid': int.from_bytes(data[2:4], 'big'),
            'subject_tid': int.from_bytes(data[6:8], 'big'),
            'object_tid': int.from_bytes(data[8:10], 'big'),
            'words': 5
        }
```
