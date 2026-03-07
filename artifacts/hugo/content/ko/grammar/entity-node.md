---
title: "엔티티 노드"
weight: 20
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "entity", "SIDX", "quantification"]
summary: "사람·장소·사물·조직 등 개체를 식별하는 고정 길이 4워드(64비트) Node. 3비트 Mode로 양화/수를 표현하고, 6비트 EntityType으로 64개 상위 타입을 분류하며, 48비트 Attributes로 타입별 의미 속성을 인코딩한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Entity Node**는 GEUL 스트림에서 개체(사람, 장소, 사물, 조직, 개념 등)를 식별하는 **고정 길이 4워드(64비트) 패킷**이다.

## SIDX 본질

| 특성 | 설명 |
|------|------|
| **Non-unique** | 같은 SIDX에 여러 개체 가능 |
| **Multi-SIDX** | 한 개체가 여러 SIDX 가능 (시점/역할별) |
| **비트 = 의미** | 비트 위치 자체가 속성을 나타냄 |
| **추상/구체 연속** | Mode와 Attributes 채움 정도로 구분 |

**예시:**
- 트럼프 (부동산 사업가) → SIDX_A
- 트럼프 (대통령) → SIDX_B (다른 SIDX)
- "Human + Male + Korea" → 추상적 "한국 남자"
- "Human + Male + Korea + 1946 + Business + ..." → 거의 특정 인물

## 설계 원칙

**Q아이디 내재 포기:**
- 순수 의미정렬에 비트 전체 투자
- WMS SIMD 필터링 성능 극대화
- Q아이디는 [트리플](../triple-edge/)로 별도 연결: `(Entity_SIDX, P-외부ID, "Q12345")`

**Serial 비트 불필요:**
- WMS 쿼리는 2단계: SIMD 범위 좁히기 → 범위 내 디테일 체크
- Serial은 의미 없는 숫자라 SIMD에 기여 안 함
- 그 비트를 의미정렬에 투자하면 1단계에서 더 좁혀짐

## 비트 레이아웃 (4워드 = 64비트)

```
1st WORD (16비트)
┌─────────┬──────┬────────────┐
│ Prefix  │ Mode │ EntityType │
│  7bit   │ 3bit │   6bit     │
└─────────┴──────┴────────────┘

2nd WORD (16비트)
┌─────────────────────────────┐
│     Attributes 상위 16비트   │
└─────────────────────────────┘

3rd WORD (16비트)
┌─────────────────────────────┐
│     Attributes 중위 16비트   │
└─────────────────────────────┘

4th WORD (16비트)
┌─────────────────────────────┐
│     Attributes 하위 16비트   │
└─────────────────────────────┘
```

| 필드 | 비트 | 크기 | 설명 |
|------|------|------|------|
| Prefix | 1-7 | 7 | `0001001` (Entity Node) |
| Mode | 8-10 | 3 | 8가지 양화/수 모드 |
| EntityType | 11-16 | 6 | 64개 상위 타입 |
| Attributes | 17-64 | **48** | 타입별 가변 스키마 |

## Mode (3비트)

Mode는 개체의 **양화(Quantification)와 수(Number)**를 3비트로 통합 표현한다.

| 코드 | 이진 | 의미 | 예시 |
|------|------|------|------|
| 0 | 000 | **등록 개체** | 이순신, 삼성전자, BTS |
| 1 | 001 | 특정 단수 | "그 사람" |
| 2 | 010 | 특정 소수 | "그 몇몇" |
| 3 | 011 | 특정 다수 | "그 사람들" |
| 4 | 100 | 전칭 | "모든 ~" |
| 5 | 101 | 존재 | "어떤 ~" |
| 6 | 110 | 불특정 | "아무 ~" |
| 7 | 111 | 총칭 | "~ 일반" |

### 등록 개체 (Mode=0)

- 위키데이터 Q아이디, 워드넷 Synset 등 외부 ID와 매핑된 개체
- Q아이디 자체는 트리플로 연결: `(Entity_SIDX, P-외부ID, "Q12345")`
- **수(Number) 개념과 무관**: 삼성전자는 "하나"지만 단수라 하기 애매, BTS는 그룹이지만 하나의 개체

### 대명사/추상 (Mode=1~7)

- EntityType + Attributes로 의미 범위 지정
- 비트가 채워질수록 구체적
- 예: Human(Type) + Male(Attr) + Korea(Attr) = "한국 남자"

## EntityType (6비트 = 64개)

위키데이터 P31(instance of) 빈도 통계 기반으로 64개 상위 타입을 배정한다. 세부 분류는 Attributes 내 소분류 비트로 처리한다.

| 범위 | 카테고리 | 타입 수 | 대표 타입 |
|------|----------|---------|-----------|
| 0x00-0x07 | 생물/인물 | 8 | Human, Taxon, Gene, Protein |
| 0x08-0x0B | 화학/물질 | 4 | Chemical, Compound, Mineral, Drug |
| 0x0C-0x13 | 천체 | 8 | Star, Galaxy, Asteroid, Planet |
| 0x14-0x1B | 지형/자연 | 8 | Mountain, River, Lake, Island |
| 0x1C-0x23 | 장소/행정 | 8 | Settlement, Village, Street, Park |
| 0x24-0x2B | 건축물 | 8 | Building, Church, School, Bridge |
| 0x2C-0x2F | 조직 | 4 | Organization, Business, PoliticalParty |
| 0x30-0x3B | 창작물 | 12 | Painting, Document, Film, Album |
| 0x3C-0x3F | 이벤트/기타 | 4 | SportsSeason, Event, Election, Other |

### 코드 테이블 (64개 전체)

| 코드 | 타입 | Q-ID | 개체수 |
|------|------|------|--------|
| 0x00 | Human | Q5 | 12.5M |
| 0x01 | Taxon | Q16521 | 3.8M |
| 0x02 | Gene | Q7187 | 1.2M |
| 0x03 | Protein | Q8054 | 1.0M |
| 0x04 | CellLine | Q21014462 | 154K |
| 0x05 | FamilyName | Q101352 | 662K |
| 0x06 | GivenName | Q202444 | 128K |
| 0x07 | FictionalCharacter | Q15632617 | 98K |
| 0x08 | Chemical | Q113145171 | 1.3M |
| 0x09 | Compound | Q11173 | 1.1M |
| 0x0A | Mineral | Q7946 | 62K |
| 0x0B | Drug | Q12140 | 45K |
| 0x0C | Star | Q523 | 3.6M |
| 0x0D | Galaxy | Q318 | 2.1M |
| 0x0E | Asteroid | Q3863 | 249K |
| 0x0F | Quasar | Q83373 | 178K |
| 0x10 | Planet | Q634 | 15K |
| 0x11 | Nebula | Q12057 | 8K |
| 0x12 | StarCluster | Q168845 | 5K |
| 0x13 | Moon | Q2537 | 3K |
| 0x14 | Mountain | Q8502 | 518K |
| 0x15 | Hill | Q54050 | 321K |
| 0x16 | River | Q4022 | 427K |
| 0x17 | Lake | Q23397 | 292K |
| 0x18 | Stream | Q47521 | 194K |
| 0x19 | Island | Q23442 | 153K |
| 0x1A | Bay | Q39594 | 25K |
| 0x1B | Cave | Q35509 | 20K |
| 0x1C | Settlement | Q486972 | 580K |
| 0x1D | Village | Q532 | 245K |
| 0x1E | Hamlet | Q5084 | 148K |
| 0x1F | Street | Q79007 | 711K |
| 0x20 | Cemetery | Q39614 | 298K |
| 0x21 | AdminRegion | Q15284 | 100K |
| 0x22 | Park | Q22698 | 45K |
| 0x23 | ProtectedArea | Q473972 | 35K |
| 0x24 | Building | Q41176 | 292K |
| 0x25 | Church | Q16970 | 286K |
| 0x26 | School | Q9842 | 242K |
| 0x27 | House | Q3947 | 235K |
| 0x28 | Structure | Q811979 | 216K |
| 0x29 | SportsVenue | Q1076486 | 145K |
| 0x2A | Castle | Q23413 | 42K |
| 0x2B | Bridge | Q12280 | 38K |
| 0x2C | Organization | Q43229 | 531K |
| 0x2D | Business | Q4830453 | 242K |
| 0x2E | PoliticalParty | Q7278 | 35K |
| 0x2F | SportsTeam | Q847017 | 95K |
| 0x30 | Painting | Q3305213 | 1.1M |
| 0x31 | Document | Q49848 | 45M |
| 0x32 | LiteraryWork | Q7725634 | 395K |
| 0x33 | Film | Q11424 | 335K |
| 0x34 | Album | Q482994 | 303K |
| 0x35 | MusicalWork | Q105543609 | 195K |
| 0x36 | TVEpisode | Q21191270 | 177K |
| 0x37 | VideoGame | Q7889 | 172K |
| 0x38 | TVSeries | Q5398426 | 85K |
| 0x39 | Patent | Q43305660 | 289K |
| 0x3A | Software | Q7397 | 13K |
| 0x3B | Website | Q35127 | 12K |
| 0x3C | SportsSeason | Q27020041 | 183K |
| 0x3D | Event | Q1656682 | 10K |
| 0x3E | Election | Q40231 | 11K |
| 0x3F | Other | - | 확장용 |

## Attributes (48비트)

EntityType마다 다른 의미로 해석되는 **타입별 가변 스키마**이다. 고빈도 속성에 더 많은 비트를 할당하며, WMS SIMD 필터링에 직접 활용한다.

### Human (0x00) Attributes

```
┌──────────┬────────┬────────┬──────┬────────┬────────┬─────────┬──────────┬────────────┬──────────┐
│ 소분류   │ 직업   │ 국적   │ 시대 │ 10년대 │ 성별   │ 저명도  │ 언어     │ 출생지역   │ 활동분야 │
│  5bit    │  6bit  │  8bit  │ 4bit │  4bit  │  2bit  │  3bit   │  6bit    │   6bit     │   4bit   │
└──────────┴────────┴────────┴──────┴────────┴────────┴─────────┴──────────┴────────────┴──────────┘
offset:  0        5       11      19     23      27      29        32         38          44
```

### Star (0x0C) Attributes

```
┌────────────┬────────────┬──────────┬──────────┬────────┬────────┬──────────┬──────────┬────────┬────────┐
│ 별자리     │ 분광형     │ 광도등급 │ 겉보기   │ 적경   │ 적위   │ 플래그   │ 시선속도 │ 적색편이│ 시차   │
│   7bit     │    4bit    │   3bit   │  4bit    │  4bit  │  4bit  │   6bit   │   5bit   │  5bit  │  4bit  │
└────────────┴────────────┴──────────┴──────────┴────────┴────────┴──────────┴──────────┴────────┴────────┘
```

**플래그 비트 정의:**
- bit0: IR (적외선원)
- bit1: Radio (전파원)
- bit2: X-ray (X선원)
- bit3: Binary (쌍성)
- bit4: Variable (변광성)
- bit5: HighPM (고유운동)

## 연산

### Entity 생성

```python
def make_entity(
    mode: int,           # 3비트
    entity_type: int,    # 6비트
    attrs: int           # 48비트
) -> bytes:
    PREFIX = 0b0001001   # 7비트 (Entity Node)

    word1 = (PREFIX << 9) | (mode << 6) | entity_type
    word2 = (attrs >> 32) & 0xFFFF
    word3 = (attrs >> 16) & 0xFFFF
    word4 = attrs & 0xFFFF

    return (
        word1.to_bytes(2, 'big') +
        word2.to_bytes(2, 'big') +
        word3.to_bytes(2, 'big') +
        word4.to_bytes(2, 'big')
    )
```

### Entity 파싱

```python
def parse_entity(data: bytes) -> dict:
    word1 = int.from_bytes(data[0:2], 'big')
    word2 = int.from_bytes(data[2:4], 'big')
    word3 = int.from_bytes(data[4:6], 'big')
    word4 = int.from_bytes(data[6:8], 'big')

    prefix = (word1 >> 9) & 0x7F
    mode = (word1 >> 6) & 0x7
    entity_type = word1 & 0x3F
    attrs = (word2 << 32) | (word3 << 16) | word4

    return {
        'prefix': prefix,
        'mode': mode,
        'entity_type': entity_type,
        'attrs': attrs
    }
```

## 예시

### 등록 개체: 이순신

```python
# 이순신 (Q211789)
yi_sun_sin = make_entity(
    mode=0,              # 등록 개체
    entity_type=0x00,    # Human
    attrs=(
        (0x06 << 43) |   # 소분류: Military
        (0x01 << 37) |   # 직업: Admiral
        (0x52 << 29) |   # 국적: Korea
        (0x5 << 25) |    # 시대: Early Modern
        (0x0 << 21) |    # 10년대: 1540s
        (0x01 << 19) |   # 성별: Male
        (0x7 << 16)      # 저명도: 1000+
    )
)
# Q아이디 연결: Triple(yi_sun_sin_SIDX, P-외부ID, "Q211789")
```

### 추상: "모든 한국 남자"

```python
all_korean_men = make_entity(
    mode=4,              # 전칭 (모든)
    entity_type=0x00,    # Human
    attrs=(
        (0x52 << 29) |   # 국적: Korea
        (0x01 << 19)     # 성별: Male
    )
)
```

## 하위 타입 매핑

위키데이터의 많은 타입이 64개 EntityType의 하위 타입이다. 인코더는 P31 값을 보고 적절한 상위 타입으로 라우팅한다.

| 하위 타입 (P31) | 상위 타입 | 개체수 |
|-----------------|-----------|--------|
| Q13442814 (scholarly article) | Document (0x31) | 45.2M |
| Q67206691 (infrared source) | Star (0x0C) | 2.6M |
| Q13100073 (village of China) | Village (0x1D) | 592K |

## 커버리지

| 항목 | 수치 |
|------|------|
| 위키데이터 전체 개체 | 117,419,925 |
| Wikimedia 내부 (제외) | 8,565,353 (7.3%) |
| SIDX 대상 | 108,854,572 (92.7%) |
| 64개 타입 직접 커버 | 36,295,074 (33.3%) |
| 하위 타입 흡수 | 71,842,429 (66.0%) |
| Other 폴백 | 717,069 (0.7%) |
| **최종 커버리지** | **100%** |
| **충돌률** | **< 0.01%** |

## Q아이디 연결

Entity Node는 Q아이디를 내재하지 않고, [트리플 엣지](../triple-edge/)로 별도 연결한다.

```
Subject:  Entity_SIDX (64비트)
Property: P-외부ID (예: P-Wikidata)
Object:   "Q12345" (문자열 또는 정수)
```
