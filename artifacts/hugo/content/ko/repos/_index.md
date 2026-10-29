---
title: "Repositories"
date: 2026-02-28T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
summary: "GEUL의 공개 GitHub 저장소 목록. Go 라이브러리와 geul CLI, 위키데이터 적재·변환, 탐색 엔진 SILK, v1 이전 코드북, 웹사이트."
image: "/images/og-default.webp"
---

GEUL의 공개 저장소는 [geul-org](https://github.com/geul-org) GitHub 조직에 있다. 문법 명세는 이 사이트의 [GEUL 문법](/ko/grammar/)이 정본이다.

GEUL 문서는 16비트 WORD의 연속이다. 데이터의 단위는 TAG WORD 하나로 시작하는 레코드이고, 레코드들은 문서 하나에 담긴다. 문서는 Issuer가 내고, 버전마다 내용 해시로 고정된다. 아래 저장소들은 이 문서를 쓰고, 읽고, 옮기고, 찾는 도구다.

---

## 라이브러리

### gogeul

GEUL Go 라이브러리와 `geul` 명령줄 도구.

GEUL 문서(`.geul`)를 쓰고, 읽고, 검사하고, 공표한다. 형식 검사, Codec 규격 문서로 레코드 해석, 버전 diff, IMPORT 의존 해석, TOULMIN Codec을 패키지로 제공한다. `geul` CLI는 문서 편집(`new`, `add`)과 공표(`publish`), 조회(`ls`, `log`, `show`, `diff`, `check`), 브라우저 뷰어(`serve`, `build`), pack 아카이브(`pack build`, `pack unpack`)를 다룬다. pack 아카이브는 레코드를 zstd로 압축해 저장할 수 있다.

| | |
|---|---|
| GitHub | [geul-org/gogeul](https://github.com/geul-org/gogeul) |
| 언어 | Go |
| 라이선스 | CC0 |

---

## 위키데이터

### wikigeul

위키데이터 → GEUL 변환(옛 이름 gogeulwiki).

wikipg가 PostgreSQL에 적재한 위키데이터 덤프를 읽어 항목·속성마다 GEUL 문서 하나를 낸다. 레이블, 설명, 별칭, 한정자와 출처가 붙은 진술, 사이트링크를 모든 언어로 담는다. 모든 문서는 Issuer `wikidata.geul.org`(`0x00010000`) 아래 공표된다.

| | |
|---|---|
| GitHub | [geul-org/wikigeul](https://github.com/geul-org/wikigeul) |
| 언어 | Go |
| 라이선스 | CC0 |

### wikipg

위키데이터 JSON 덤프 → PostgreSQL 무손실 적재.

개체, 레이블, 설명, 별칭, 진술, 한정자, 출처, 사이트링크, Lexeme을 덤프 순서대로 저장하고, 덤프의 모든 줄을 원문 그대로 보존한다. 덤프 자체(파일, URL, 크기, 체크섬, 적재기 커밋)도 기록한다. wikipg는 GEUL에 의존하지 않는다.

| | |
|---|---|
| GitHub | [geul-org/wikipg](https://github.com/geul-org/wikipg) |
| 언어 | Go |
| 라이선스 | CC0 |

---

## 탐색

### silk

[SILK](/ko/projects/silk/) — GEUL 전용 색인·탐색 엔진.

GEUL pack 아카이브의 레코드를 파티션·정렬 색인으로 만들어, 문서를 모두 디코드하지 않고 "직업(P106)이 물리학자(Q169470)라고 진술한 문서는?" 같은 질의에 답한다. 코덱북 없이 TAG WORD만으로 레코드와 필드를 가른다. 초기 개발 단계로, 탐색 알고리즘을 검증하고 있으며 첫 릴리스 전까지 형식이 바뀔 수 있다.

| | |
|---|---|
| GitHub | [geul-org/silk](https://github.com/geul-org/silk) |
| 언어 | Go |
| 라이선스 | CC0 |

---

## 코드북 (v1 이전)

아래 두 저장소는 현행 v1 문법 이전에 설계한 자료다. 현 문법과 맞지 않는 부분이 있다.

### sidx

SIDX(Semantic-aligned Index) 배정 연구.

의미가 가까운 개체에 가까운 번호를 주는 의미 주소 SIDX를 위키데이터 사용 통계로 배정하려는 연구 자료다. 옛 Entity 48비트 속성 스키마, 인코더 스크립트, 코드북을 담고 있으며, 아직 SIDX 배정 결과는 없다. SIDX의 규범 정의는 문법의 [GEUL-SIDX](/ko/grammar/reference/geul-sidx/)다.

| | |
|---|---|
| GitHub | [geul-org/sidx](https://github.com/geul-org/sidx) |
| 언어 | Python |
| 라이선스 | CC0 |

### wordnet-verb

WordNet 3.0 기반 동사 16비트 코드북 임시판.

WordNet 3.0의 동사 synset 13,767개에 16비트 코드를 하나씩 주고, 뜻이 가까운 동사에 가까운 코드를 준다. WordNet을 쓰지 않는 코드북으로 대체할 임시판이며, 코드를 GEUL 레코드에 어떻게 담을지는 정하지 않았다.

WordNet에서 파생한 자료가 들어 있어 **CC0 산출물이 아니다.** WordNet 파생 부분은 WordNet 3.0 License를 따르고, 코드와 분류 같은 GEUL 프로젝트 고유 부분만 CC0다.

| | |
|---|---|
| GitHub | [geul-org/wordnet-verb](https://github.com/geul-org/wordnet-verb) |
| 언어 | Python |
| 라이선스 | WordNet 3.0 License(파생 부분) · CC0(고유 부분) |

---

## 웹사이트

### geul-org

이 웹사이트 geul.org의 소스.

Hugo 정적 사이트로 12개 언어를 지원하며, S3 + CloudFront로 배포한다.

| | |
|---|---|
| GitHub | [geul-org/geul-org](https://github.com/geul-org/geul-org) |
| 언어 | Hugo |
| 라이선스 | CC0 |

---

## 관련 저장소

geul-org 조직 밖의 저장소다.

### toulmin

툴민 논증 모델 기반 규칙 엔진(TypeScript, Python, Go, C).

규칙은 함수이고, 예외는 그래프의 공격 관계다. GEUL 문법의 [TOULMIN](/ko/grammar/edge/toulmin/) Edge(직접 코드 `0x60`~`0x7B`)가 이 판정·실행 그래프를 GEUL 문서로 쓴다.

| | |
|---|---|
| GitHub | [park-jun-woo/toulmin](https://github.com/park-jun-woo/toulmin) |
| 라이선스 | MIT |
