---
title: "Repositories"
date: 2026-02-28T12:00:00+09:00
summary: "GEUL 프로젝트를 구성하는 GitHub 저장소 목록. 언어 명세, 문법 코드북, 아키텍처, 웹사이트."
image: "/images/og-default.webp"
---

모든 저장소는 [geul-org](https://github.com/geul-org) GitHub 조직에 있다.

---

## 언어

### geul

AI를 위한 의미정렬 인공 언어이자 바이너리 스트림 포맷.

인간과 AI가 모호성 없이 소통하기 위해 설계된 2바이트(65,536종) 기반 언어 체계다. 모든 서술에 출처, 시점, 확신도가 있고, 모든 개체에 고유 식별자가 있다. 16비트 단위의 스트림 포맷으로, 10비트 Prefix 체계 아래 10종의 패킷 타입(Verb Edge, Entity Node, Triple Edge 등)을 정의한다.

| | |
|---|---|
| GitHub | [geul-org/geul](https://github.com/geul-org/geul) |
| 언어 | Go, Python |
| 라이선스 | MIT |

---

## 문법

### geul-verb

동사 SIDX 16비트 코드북 (WordNet 기반).

WordNet 동사 synset을 16비트 코드로 매핑하여 GEUL Verb Edge 패킷에서 사용한다. 스트림 포맷이 소비하는 동사 어휘를 제공한다.

| | |
|---|---|
| GitHub | [geul-org/geul-verb](https://github.com/geul-org/geul-verb) |
| 언어 | Python |
| 라이선스 | MIT |

### geul-entity

엔티티 SIDX 48비트 코드북 (Wikidata 기반).

위키데이터 엔티티를 48비트 구조화 식별자로 인코딩한다. 엔티티 타입을 정의하고, 타입별 속성 스키마를 설계하고, SILK이 소비하는 코드북을 빌드한다.

| | |
|---|---|
| GitHub | [geul-org/geul-entity](https://github.com/geul-org/geul-entity) |
| 언어 | Python |
| 라이선스 | MIT |

### geul-quantities

수량 노드 코드북.

GEUL Quantity Node 패킷에서 사용하는 수량 값 — 단위가 있는 숫자, 범위, 정밀도 — 의 인코딩 체계를 정의한다.

| | |
|---|---|
| GitHub | [geul-org/geul-quantities](https://github.com/geul-org/geul-quantities) |
| 언어 | Python |
| 라이선스 | MIT |

### geul-ast

AST 엣지 코드북.

추상 구문 트리 엣지의 인코딩 체계를 정의하여, GEUL 스트림 포맷 내에서 구조화된 코드 표현을 가능하게 한다.

| | |
|---|---|
| GitHub | [geul-org/geul-ast](https://github.com/geul-org/geul-ast) |
| 언어 | Python |
| 라이선스 | MIT |

---

## 검색

### silk

SILK(Symbolic Index for LLM Knowledge) — 뉴로-심볼릭 검색 아키텍처.

64비트 정수로 검색한다. 벡터 DB, ANN 그래프, 임베딩 모델이 필요 없다. NumPy 비트 AND 한 줄로 1억 건을 검색하며, Python만으로 최적화된 C++/Rust 벡터 검색을 이긴다는 것이 핵심 주장이다. 코드북 룩업과 LLM 보조를 결합한 하이브리드 쿼리 파이프라인을 제공한다.

| | |
|---|---|
| GitHub | [geul-org/silk](https://github.com/geul-org/silk) |
| 언어 | Python |
| 라이선스 | MIT |

---

## DSL

### ssac

Service Sequences as Code — Go 주석에서 선언적 서비스 로직을 파싱하여 Go 구현 코드를 CLI로 생성한다.

Go 소스 파일의 구조화된 주석으로 서비스 흐름을 정의한다. CLI가 이 선언을 읽고 대응하는 구현 코드를 생성하여, 보일러플레이트를 제거하면서 로직의 가독성과 버전 관리를 유지한다.

| | |
|---|---|
| GitHub | [geul-org/ssac](https://github.com/geul-org/ssac) |
| 언어 | Go |
| 라이선스 | MIT |

---

## 웹사이트

### geul-org

이 웹사이트의 소스 코드.

Hugo 정적 사이트 제너레이터로 12개 언어를 지원한다. S3 + CloudFront로 배포하며, CloudFront Function으로 언어 감지와 clean URL을 처리한다.

| | |
|---|---|
| GitHub | [geul-org/geul-org](https://github.com/geul-org/geul-org) |
| 언어 | Hugo (Go Templates), CSS |
| 라이선스 | MIT |
