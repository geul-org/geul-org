---
title: "Repositories"
date: 2026-02-28T12:00:00+09:00
summary: "GEUL 프로젝트를 구성하는 GitHub 저장소 목록. 언어 설계, 인코딩 파이프라인, 검색 엔진, 웹사이트."
image: "/images/og-default.webp"
---

GEUL 프로젝트는 네 개의 저장소로 구성된다.

언어를 설계하고(geul), 세계의 개체를 64비트로 인코딩하고(geul-sidx), 그 인덱스 위에서 검색하고(silk), 왜 이 모든 것이 필요한지를 설명한다(geul-org).

---

## geul

AI를 위한 의미정렬 인공 언어이자 바이너리 스트림 포맷.

인간과 AI가 모호성 없이 소통하기 위해 설계된 2바이트(65,536종) 기반 언어 체계다. 모든 서술에 출처, 시점, 확신도가 있고, 모든 개체에 고유 식별자가 있다. 16비트 단위의 스트림 포맷으로, 10비트 Prefix 체계 아래 10종의 패킷 타입(Verb Edge, Entity Node, Triple Edge 등)을 정의한다.

| | |
|---|---|
| GitHub | [park-jun-woo/geul](https://github.com/park-jun-woo/geul) |
| 언어 | Go, Python |
| 라이선스 | MIT |

---

## geul-sidx

SIDX(Semantic-aligned Index) 코드북 빌더 & 인코딩 파이프라인.

위키데이터 108.8M 엔티티를 64비트 구조화 식별자로 인코딩한다. 63개 엔티티 타입을 정의하고, 타입별 48비트 속성 스키마를 설계하고, 코드북을 빌드하고, 인코딩 결과를 검증(VALID)한다. SILK이 소비하는 인덱스와 코드북의 생산자다.

| | |
|---|---|
| GitHub | [park-jun-woo/geul-sidx](https://github.com/park-jun-woo/geul-sidx) |
| 언어 | Python |
| 라이선스 | MIT |

---

## silk

SILK(Symbolic Index for LLM Knowledge) — 뉴로-심볼릭 검색 아키텍처.

64비트 정수로 검색한다. 벡터 DB, ANN 그래프, 임베딩 모델이 필요 없다. NumPy 비트 AND 한 줄로 1억 건을 검색하며, Python만으로 최적화된 C++/Rust 벡터 검색을 이긴다는 것이 핵심 주장이다. 코드북 룩업과 LLM 보조를 결합한 하이브리드 쿼리 파이프라인을 제공한다.

| | |
|---|---|
| GitHub | [park-jun-woo/silk](https://github.com/park-jun-woo/silk) |
| 언어 | Python |
| 라이선스 | MIT |

---

## geul-org

이 웹사이트의 소스 코드.

Hugo 정적 사이트 제너레이터로 12개 언어를 지원한다. S3 + CloudFront로 배포하며, CloudFront Function으로 언어 감지와 clean URL을 처리한다.

| | |
|---|---|
| GitHub | [park-jun-woo/geul-org](https://github.com/park-jun-woo/geul-org) |
| 언어 | Hugo (Go Templates), CSS |
| 라이선스 | MIT |
