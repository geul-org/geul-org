---
title: "컨텍스트 엣지"
weight: 60
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "context", "worldview", "modal-logic"]
summary: "'어느 세계관/맥락에서 이 주장이 참인가'를 표현하는 3워드 경량 Edge. 출처, 세계관, 허구, 시점 등 64개 타입으로 진리의 조건을 인코딩한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Context Edge는 **"어느 세계관/맥락에서 이 Claim이 참인가"**를 표현한다.

Modal Logic의 가능 세계에 대응하는 개념으로, 같은 Subject에 대해 세계관마다 다른 사실이 존재할 수 있다.

```
Context "현실":        (지구, 나이, 46억년)
Context "젊은지구론":   (지구, 나이, 6000년)
Context "해리포터":     (마법, exists, true)
```

## 패킷 구조 (3워드, 48비트)

```
1st WORD (16비트):
┌─────────────────────┬─────────────────┐
│       Prefix        │  Context Type   │
│       10비트        │     6비트       │
└─────────────────────┴─────────────────┘
 [1100 000 100]        [TTTTTT]

2nd WORD: Context TID (16비트)
3rd WORD: Target TID (16비트)
```

| 필드 | 비트 | 설명 |
|------|------|------|
| Prefix | 10 | `1100 000 100` |
| Context Type | 6 | 0=미지정, 1~62=타입, 63=확장(예약) |
| Context TID | 16 | 이 Context의 고유 식별자 |
| Target TID | 16 | 대상 Claim ([트리플](../triple-edge/)/[동사](../verb-edge/)/[이벤트6](../event6-edge/)/[절](../clause-edge/) TID) |

## Context Type (6비트 = 64개)

### 출처 (Source) — Code 1~20

| Code | 타입 | 설명 | 예시 |
|------|------|------|------|
| 1 | SYSTEM | 시스템 자동 생성 | 위키데이터 동기화 |
| 2 | USER | 사용자 직접 입력 | 수동 작성 |
| 3 | DOCUMENT | 일반 문서 | PDF, Word |
| 4 | NEWS | 뉴스 기사 | 로이터, AP |
| 5 | ACADEMIC | 학술 논문 | arXiv, Nature |
| 6 | GOVERNMENT | 정부/공공 기관 | SEC, 통계청 |
| 7 | WIKI | 위키피디아/위키데이터 | Q42, P31 |
| 8 | API | 외부 API | 금융, 날씨 |
| 9 | ORG | 기관/조직 발표 | 기업 IR |
| 10 | BOOK | 서적 | ISBN 기반 |
| 11 | INTERVIEW | 인터뷰/증언 | 직접 인용 |
| 12 | DATASET | 데이터셋 | Kaggle |
| 13 | SOCIAL | 소셜 미디어 | Twitter |
| 14 | LEGAL | 법률/판례 | 법원 판결 |
| 15 | ARCHIVE | 아카이브 | archive.org |
| 16 | MULTIMEDIA | 영상/음성 | YouTube |
| 17 | DATABASE | 데이터베이스 | IMDB, Freebase |
| 18 | ENCYCLOPEDIA | 백과사전 | 브리태니커 |
| 19 | MANUAL | 매뉴얼/가이드 | 기술 문서 |
| 20 | STANDARD | 표준 문서 | ISO, RFC |

### 파생/추론 (Derived) — Code 21~30

| Code | 타입 | 설명 | 예시 |
|------|------|------|------|
| 21 | MODEL | AI 모델 생성 | GPT, Claude |
| 22 | INFERENCE | 논리적 추론 | 규칙 기반 |
| 23 | AGGREGATION | 집계/통합 | 다중 출처 종합 |
| 24 | CALCULATION | 계산 결과 | 공식 적용 |
| 25 | TRANSLATION | 번역 | 원문→번역 |
| 26 | EXTRACTION | 추출 | NER, RE |
| 27 | CORRECTION | 수정/정정 | 오류 교정 |
| 28 | HEARSAY | 전언/소문 | 미확인 |
| 29 | ESTIMATION | 추정 | 근사값 |
| 30 | PREDICTION | 예측 | 미래 전망 |

### 세계관/신념 (Worldview) — Code 31~45

| Code | 타입 | 설명 | 예시 |
|------|------|------|------|
| 31 | RELIGION | 종교적 세계관 | 개신교, 불교 |
| 32 | PHILOSOPHY | 철학적 관점 | 실존주의 |
| 33 | SCIENCE | 과학적 합의 | 현대 물리학 |
| 34 | POLITICS | 정치적 관점 | 보수, 진보 |
| 35 | CULTURE | 문화적 관점 | 동양, 서양 |
| 36 | MYTHOLOGY | 신화 체계 | 그리스 신화 |
| 37 | FOLKLORE | 민담/전승 | 지역 설화 |
| 38 | IDEOLOGY | 이념 체계 | 자본주의 |
| 39 | THEORY | 이론 | 상대성이론 |
| 40 | HYPOTHESIS | 가설 | 검증 전 |
| 41 | TRADITION | 전통/관습 | 유교 전통 |
| 42 | CONSENSUS | 합의/통설 | 학계 정설 |
| 43 | MAINSTREAM | 주류 견해 | 다수 의견 |
| 44 | ALTERNATIVE | 대안적 견해 | 소수 의견 |
| 45 | FRINGE | 비주류/이단 | 사이비 |

### 허구/창작 (Fiction) — Code 46~55

| Code | 타입 | 설명 | 예시 |
|------|------|------|------|
| 46 | NOVEL | 소설 세계관 | 반지의 제왕 |
| 47 | FILM | 영화 세계관 | MCU |
| 48 | GAME | 게임 세계관 | 젤다 |
| 49 | COMICS | 만화 세계관 | DC 유니버스 |
| 50 | ANIMATION | 애니 세계관 | 지브리 |
| 51 | DRAMA | 드라마 세계관 | 왕좌의 게임 |
| 52 | THEATER | 연극 세계관 | 햄릿 |
| 53 | FANFIC | 2차 창작 | 팬픽션 |
| 54 | LEGEND | 전설 | 아서왕 |
| 55 | FAIRYTALE | 동화 | 신데렐라 |

### 시점/화자 (Perspective) — Code 56~62

| Code | 타입 | 설명 | 예시 |
|------|------|------|------|
| 56 | NARRATOR | 서술자 시점 | 전지적 화자 |
| 57 | PROTAGONIST | 주인공 시점 | 히어로 관점 |
| 58 | ANTAGONIST | 적대자 시점 | 빌런 관점 |
| 59 | AUTHOR | 저자 의도 | 작가 해설 |
| 60 | EXPERT | 전문가 견해 | 학자 의견 |
| 61 | LAYMAN | 일반인 인식 | 대중 인식 |
| 62 | SATIRICAL | 풍자/아이러니 | 반어적 표현 |

Code 0은 UNSPECIFIED(미지정), Code 63은 EXTENDED(확장, 예약)이다.

## 메타데이터 확장

Context 자체에 대한 부가 정보(출처, 신뢰도, 세계관명)는 [트리플 엣지](../triple-edge/)로 표현한다.

```
(Context TID, P:source_entity, Reuters_Entity)  - 출처 기관
(Context TID, P:confidence, 0.95)               - 신뢰도
(Context TID, P:universe_name, "해리포터")       - 세계관 이름
(Context TID, P:perspective_holder, 빌런_Entity)  - 시점 주체
```

## 예시

### 출처: "로이터 보도"

```
Context Edge:
  1st: [1100 000 100] + [000100]  - NEWS (4)
  2nd: [0x0300]                   - Context TID
  3rd: [0x0001]                   - Target: Triple "Apple acquired Tesla"

추가 Triple:
  (0x0300, P:source_entity, Reuters)
  (0x0300, P:date, 2026-01-29)
```

### 허구: "해리포터 세계관"

```
Context Edge:
  1st: [1100 000 100] + [101110]  - NOVEL (46)
  2nd: [0x0302]                   - Context TID
  3rd: [0x0003]                   - Target: Triple "호그와트 is_a 학교"

추가 Triple:
  (0x0302, P:universe_name, "해리포터")
  (0x0302, P:author, J.K.롤링)
```

### AI 추론: "Claude가 추론"

```
Context Edge:
  1st: [1100 000 100] + [010101]  - MODEL (21)
  2nd: [0x0304]                   - Context TID
  3rd: [0x0005]                   - Target: Triple "X causes Y"

추가 Triple:
  (0x0304, P:model, Claude_Entity)
  (0x0304, P:confidence, 0.75)
```

## 설계 근거

- **Context Edge 단독 타입**: 세계관은 Triple/Clause와 다른 메타 레이어이다. RDF Quad의 G(Graph)에 대응한다.
- **6비트 Context Type**: 별도 Triple 없이 즉시 분류 가능. 62개 타입으로 대부분 커버한다.
- **3워드 경량 구조**: Context 연결은 대량 발생하므로 최소 크기로 저장 효율을 확보한다.
