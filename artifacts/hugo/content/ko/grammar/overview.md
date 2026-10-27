---
title: "개요"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "overview"]
summary: "GEUL v1은 16비트 워드로 된 레코드의 연속이다. 레코드는 Reference, Value, Edge, Meta 네 가지이고, 레코드들은 문서 하나에 담긴다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL(General Encoding Unified Language)은 사람과 AI가 모호하지 않게 주고받기 위한 인공 언어이자 바이너리 형식이다. 이 문서는 GEUL v1의 문법을 정의한다.

## 한눈에 보기

- 모든 데이터는 **16비트 워드(WORD)**의 연속이다. 빅 엔디언으로 쓴다.
- 데이터의 단위는 **레코드**다. 레코드는 TAG WORD 하나로 시작하고, 그 TAG WORD가 레코드의 종류와 길이를 말한다.
- 레코드는 네 가지(**Kind**)다.

| Kind | 하는 일 | 예 |
|---|---|---|
| Reference | 대상을 가리킨다 | 위키데이터 Q42, 이 문서 안의 #7 |
| Value | 값 자체를 담는다 | 날짜, 수량, 언어가 붙은 텍스트 |
| Edge | 다른 레코드를 묶어 서술한다 | "Q42는 사람이다", "Q42의 영어 이름은 Douglas Adams다" |
| Meta | 문서에 관해 말한다 | 명세 판, 문서 ID, 작성자, 서명 |

- 레코드들은 **문서** 하나에 담긴다. 문서는 HTML처럼 HEAD(Meta)와 BODY(Reference·Value·Edge)로 나뉜다.
- 문서는 **Issuer**(발급 주체)가 내고, 버전마다 내용 해시로 고정된다. 공표한 버전은 바꾸지 않는다.

## 설계 원칙

1. **코덱북 없이 건너뛸 수 있다.** 레코드의 종류와 길이는 TAG WORD 16비트에 있다. 해석 방법(코덱북)을 모르는 디코더도 레코드를 세고 건너뛸 수 있다.
2. **사실이 아니라 서술을 담는다.** 문서는 누가, 언제, 무엇에서 나온 서술인지를 Meta와 근거 Edge로 함께 적는다.
3. **식별은 Reference로 한다.** 이름이 아니라 ID로 가리킨다. 이름은 Edge로 붙인다.
4. **공표한 것은 바꾸지 않는다.** 고친 내용은 새 버전으로 낸다. 문서 안의 ID는 버전을 넘어 같은 대상을 가리킨다.
5. **비워 둔다.** 비트 공간의 대부분을 미래에 남긴다. 직접 코드는 회수할 수 없으므로 빈도가 확인된 것만 배정한다.

## 영역 구조

TAG WORD의 상위 비트는 영역을 나눈다.

| Prefix | 영역 | 비율 | 정의 |
|---|---|---|---|
| `1` | 먼 미래 | 50% | 먼 미래를 위한 예약. 쓰지 않는다 |
| `01` | 미래 | 25% | 가까운 미래를 위한 예약. 쓰지 않는다 |
| `001` | 표준 | 12.5% | 공식 채택되어 운용되는 문법 |
| `000` | 자유·제안 | 12.5% | 현재 문법. 채택되면 레이아웃을 그대로 두고 Prefix만 `001`로 옮긴다 |

현재 문법은 모두 `000` 영역에 있다. 이 명세의 모든 TAG WORD는 `000`으로 시작한다.

- v1 디코더는 Prefix가 `000`이 아닌 TAG WORD를 거부한다. 다른 영역은 뒤의 판이 정한다.
- `000` 영역은 제안 공간이다. 지금은 등록이나 보호가 적용되지 않는다. 다만 Issuer 형식 레이아웃은 공식 표준 출범 이후의 등록 체계를 전제로 예약한다.

## 코덱북 없이 알 수 있는 것

| 정보 | 코덱북 없이 | 근거 |
|---|---|---|
| Kind | 안다 | TAG WORD |
| 레코드 전체 길이, 다음 레코드 위치 | 안다 | TAG WORD의 Length |
| Codec 번호 | 안다 | TAG WORD (Issuer 형식이면 확장 TAG의 Issuer와 형식 번호) |
| 계열·클래스 | 안다 | Codec 번호 또는 형식 번호의 상위 비트 |
| Edge의 Edge Id | 안다 | Edge의 첫 구성요소는 항상 LOCAL Reference |
| 자리 표지(적지 않음·알 수 없음·없음) | 안다 | WORD 값이 `0`~`7`(Reference Codec `0000`, 1 WORD). [자리 표지](/ko/grammar/reference/slot-marker/) |
| Codec별 TAG 길이, Payload 시작 위치 | 모른다 | 코덱북 |
| Payload 해석, Edge 구성요소의 역할 | 모른다 | 코덱북 |

- 코덱북이 없는 디코더는 레코드를 건너뛰며 Kind와 Codec별로 셀 수 있지만, 그래프 구조를 따라가지는 못한다.
- 모든 디코더는 Meta 구조·정의·IMPORT 클래스를 처리해야 한다. 이 Codec들은 GEUL 핵심 코덱북에 속한다([Meta](/ko/grammar/meta/)).

코덱북은 GEUL 문서로 공표된다([Codec 규격 문서](/ko/grammar/codec-spec/)). 그래서 디코더는 필요한 규격 문서를 받아 읽으면 된다.

## 하위 문서

| 문서 | 내용 |
|---|---|
| [레코드와 TAG WORD](/ko/grammar/record/) | TAG WORD 레이아웃, Length, Codec, 확장 TAG |
| [문서](/ko/grammar/document/) | DOC·HEAD·BODY·END, 문서 ID, 내용 해시, 버전과 개정 |
| [Reference](/ko/grammar/reference/) | 대상 식별, LOCAL, 외부 참조, Quantifier, 자리 표지 |
| [Value](/ko/grammar/value/) | 값 계열, 직접 코드, 텍스트·수량·날짜 |
| [Edge](/ko/grammar/edge/) | 서술·근거·실행·TOULMIN 계열, TRIPLE·QUALIFIER·LABEL |
| [Meta](/ko/grammar/meta/) | 구조·정의·출처·계보·검증·정책·IMPORT |
| [Issuer와 공표](/ko/grammar/issuer/) | Issuer 등급, 1 WORD 배정표, 공개 방식, 서명, 검증키 |
| [공표 주소와 버전 목록](/ko/grammar/publishing/) | ID 표기, 공표 주소, 형식 지정, 이름 색인, 버전 목록, 신뢰 층 |
| [Codec 규격 문서](/ko/grammar/codec-spec/) | DECLARE·FIELD·ENUM·CODEC으로 쓰는 코덱북 |
| [예시: 위키데이터 항목](/ko/grammar/example/) | 문서 하나를 워드 단위로 읽기 |

## 열린 문제

- 경계 사례의 Kind. 진술에 대한 진술처럼 Reference·Value·Edge·Meta 어느 쪽에 둘지 갈리는 경우.
