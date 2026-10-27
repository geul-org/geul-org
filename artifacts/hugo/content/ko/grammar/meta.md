---
title: "Meta"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance", "lineage", "import"]
summary: "Meta는 세계가 아니라 문서에 관한 레코드다. 구조·정의·출처·계보·검증·정책·IMPORT 일곱 클래스로 나뉘며, 문서의 HEAD에 둔다."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Meta는 세계에 관한 내용이 아니라 문서에 관한 레코드다. 문서 구조 레코드(DOC·BODY·END)를 빼면 모두 문서의 HEAD에 둔다.

## 레이아웃

```
TAG WORD          0001 1LLL LCCC CCCC
[Length 확장 TAG]
Payload           날값 또는 내장 Value·Reference 레코드
```

- Meta에는 Issuer 형식이 없다. Meta는 모든 Issuer가 따르는 공통 규격이며 GEUL만 정의한다.
- 형식이 하나로 정해진 값은 날값으로(`DOC-*` 길이, `SPEC-VERSION`), 여러 형식 중 고르는 값은 내장 레코드로(날짜·타임스탬프, 텍스트, Reference) 둔다.

## 클래스

Codec의 상위 3비트가 클래스다.

| 상위 3비트 | 클래스 | 직접 코드 | 다루는 것 |
|---|---|---|---|
| `000` | 구조 | `0x00`~`0x0F` | 문서의 경계와 길이 |
| `001` | 정의 | `0x10`~`0x1F` | 해석 선언 |
| `010` | 출처 | `0x20`~`0x2F` | 누가, 언제, 어디서 |
| `011` | 계보 | `0x30`~`0x3F` | 무엇에서 어떻게 나왔는가 |
| `100` | 검증 | `0x40`~`0x4F` | 믿을 수 있는가 |
| `101` | 정책 | `0x50`~`0x5F` | 어떻게 취급하는가 |
| `110` | IMPORT | `0x60`~`0x6F` | 외부 문서를 가져온다 |
| `111` | 예약 | `0x70`~`0x7F` | |

- **해석에 필요한 Meta**: 구조, 정의, IMPORT. 지우면 레코드를 읽을 수 없거나 해석이 바뀐다. 모든 디코더가 처리해야 한다.
- **해석을 바꾸지 않는 Meta**: 출처, 계보, 검증, 정책. 지워도 서술 내용은 그대로다. 신뢰 판단과 취급의 재료만 사라진다.
- 개별 레코드의 근거는 Meta가 아니라 BODY의 근거 Edge로 쓴다([Edge](/ko/grammar/edge/)).

## 구조

| Codec | 이름 | 뜻 |
|---|---|---|
| `0x00`~`0x02` | DOC-1WORD / 2WORD / 4WORD | 전체 길이를 지정해 문서를 연다 |
| `0x0E` | BODY | HEAD를 끝내고 BODY를 연다 |
| `0x0F` | END | 문서를 닫는다 |

자세한 규칙은 [문서](/ko/grammar/document/)에 있다.

## 정의

| Codec | 이름 | 뜻 |
|---|---|---|
| `0x10` | SPEC-VERSION | 따르는 명세 판. 정수 하나 |
| `0x11` | PROFILE | 적용 프로파일 |
| `0x12` | DOC-ID | 이 문서의 식별자. 자기 자신을 가리키는 DOC-POINTER(버전 0) |
| `0x13` | EFFECTIVE-FROM | 이 버전의 시행일. 없으면 공표 시각 |
| `0x14` | EFFECTIVE-UNTIL | 이 버전의 유효기간 끝(한시법). 없으면 다음 버전이 시행될 때까지 |
| `0x16` | DEFAULT-LANGUAGE | 기본 언어 |

- 문서의 주소용 이름은 Meta로 두지 않는다. 공표처의 이름 색인이 BIND로 붙인다. 사람이 읽는 제목은 BODY의 LABEL로 붙인다.

## 출처

| Codec | 이름 | 뜻 |
|---|---|---|
| `0x20` | AUTHOR | 작성자 (Reference) |
| `0x21` | CO-AUTHOR | 공동 작성자 |
| `0x22` | CREATED-AT | 작성 시각 |
| `0x23` | MODIFIED-AT | 수정 시각 |
| `0x24` | RECORDED-BY | 기록한 주체 |
| `0x25` | RECORDED-AT | 기록한 시각 |
| `0x26` | SOURCE | 원천 자료. Reference 또는 URI·해시 |
| `0x27` | SOURCE-SPAN | 원문 안의 대응 범위 |
| `0x28` | ACQUIRED-AT | 원천 자료를 확보한 시각 |

## 계보

계보는 git의 커밋 모델을 따른다. 커밋에 해당하는 단위가 문서다.

| Codec | 이름 | 뜻 |
|---|---|---|
| `0x30` | PARENT | 직전 버전의 내용 해시. 여럿이면 병합 |
| `0x31` | DERIVED-FROM | 다른 계보의 자료에서 파생 |
| `0x32` | GENERATED-BY | 생성 주체(사람, 모델, 규칙 엔진) |
| `0x33` | TRANSFORMED-BY | 변환 도구와 그 소스 버전(커밋 다이제스트) |
| `0x34` | CHERRY-PICKED-FROM | 가져온 변경의 원 버전 |
| `0x35` | REVERTS | 되돌린 대상 버전 |
| `0x36` | REPLACES | 고쳐 쓴 대상 버전. 원 버전은 지우지 않는다 |
| `0x37` | SQUASHED-FROM | 하나로 합친 원 버전들 |
| `0x38` | MESSAGE | 변경 이유. 언어마다 하나 |
| `0x39` | TAG | 버전에 붙인 불변 이름 |
| `0x3A` | DELTA-BASE | 이 파일은 기준 버전에 대한 diff다 |
| `0x3B` | DELTA-REMOVE | diff에서 뺄 LOCAL ID 목록 |
| `0x3C` | NEXT-LOCAL-ID | 다음에 배정할 LOCAL ID. 버전 목록 문서에 둔다 |

- 이력은 지우지 않는다. 고친 내용은 새 버전으로 낸다.
- branch처럼 바뀌는 포인터는 문서에 두지 않는다. 저장소와 색인이 관리한다.

## 검증

| Codec | 이름 | 뜻 |
|---|---|---|
| `0x40` | ISSUER-KEY | 자체 발급 Issuer의 서명 알고리즘과 공개키 |
| `0x41` | SIGNATURE | 내용 해시에 대한 서명. 알고리즘, 서명자, 서명 |
| `0x42` | SIGNED-OFF | 기여 권리 확인 |
| `0x43` | CONFIDENCE | 신뢰도 |
| `0x44` | VERDICT | 문서 전체의 판정 결과(Pass, Review, Fail) |

- 검증 클래스는 내용 해시 계산에서 빠진다. 그래서 서명을 문서 안에 둬도, 서명을 여럿 더해도 내용 해시가 바뀌지 않는다.

## 정책

| Codec | 이름 | 뜻 |
|---|---|---|
| `0x50` | LICENSE | 라이선스 |
| `0x51` | ACCESS | 공개 범위 |
| `0x52` | PRIVACY | 개인정보 등급 |
| `0x53` | RETENTION | 보존 기한 |
| `0x54` | CONSENT | 동의 범위와 근거 |
| `0x55` | USAGE | 사용 제한 |

- 정책은 해석을 바꾸지 않고 취급 방법을 정한다.

## IMPORT

```
TAG WORD          0001 1LLL L110 0000      IMPORT-DOC (0x60)
[Length 확장 TAG]
문서              DOC-POINTER 레코드 (Issuer, 문서 ID, 버전 ID)
IMPORT ID         나머지. 가장 짧은 폭의 정수
```

- IMPORT는 문서만 가져온다. 가져온 문서 안의 대상은 BODY의 `EXTERNAL-POINTER-*`(IMPORT ID, LOCAL ID)로 가리킨다.
- 버전 ID를 적으면 그 판본에, `0`이면 해석 시점의 최신 판본에 묶인다. 공표 문서는 버전을 적는다.
- 한 문서에서 같은 IMPORT ID를 두 번 배정하지 않는다.
- 가져온 문서의 HEAD는 가져오지 않는다. 그 문서의 대상은 그 문서의 선언대로 해석한다.

예: Issuer `0x0001`의 문서 `0x0000000000000002` 최신 버전을 IMPORT ID 1로 가져온다.

```
1CE0 03B8 0001 0000 0000 0000 0002 0000 0000 0001
```
