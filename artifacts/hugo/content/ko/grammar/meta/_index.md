---
title: "Meta"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance", "lineage", "import"]
summary: "Meta는 세계가 아니라 문서에 관한 레코드다. 구조·정의·출처·계보·검증·정책·IMPORT 일곱 클래스로 나뉘며, 문서의 HEAD에 둔다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
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
- `LLLL`은 TAG WORD를 포함한 전체 WORD 수 − 1이다. 표에 없는 Codec은 예약이다.

## Payload 형식

| 형식 | 언제 | 예 |
|---|---|---|
| 날값 | 형식이 하나로 정해질 때. 다른 레코드 Codec에 기대지 않는다 | `DOC-*` 길이, `SPEC-VERSION`, `ISSUER-KEY` |
| 내장 Value | 여러 형식 중 고를 때. Value TAG가 형식을 알려 준다 | `PROFILE`, `EFFECTIVE-*`, 시각, 내용 해시 |
| 내장 Reference | 사람·조직·도구·문서 같은 대상을 가리킬 때 | `DOC-ID`, `AUTHOR`, `CO-AUTHOR`, `RECORDED-BY`, `SIGNED-OFF`, `SIGNATURE`의 서명자 |
| 없음 | 1 WORD 표지 | `BODY`, `END` |

- 내장 레코드는 독립 레코드가 아니며 그 Meta에 속한다. 각자 Length로 경계를 찾고, 마지막 레코드를 읽은 위치가 Meta의 끝과 정확히 맞아야 한다.
- 한 문서에 하나만 둘 수 있는 Meta와 여럿 둘 수 있는 Meta는 각 Codec 문서의 "개수"가 정한다.

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

- **해석에 필요한 Meta**: 구조, 정의, IMPORT. 지우면 레코드를 읽을 수 없거나 해석이 바뀐다. 모든 디코더가 처리해야 한다. 이 Codec들은 **GEUL 핵심 코덱북**에 속한다.
- **해석을 바꾸지 않는 Meta**: 출처, 계보, 검증, 정책. 지워도 서술 내용은 그대로다. 신뢰 판단과 취급의 재료만 사라진다.
- 개별 레코드의 근거는 Meta가 아니라 BODY의 근거 Edge로 쓴다([Edge](/ko/grammar/edge/)).

## 구조

묶음 문서: [Meta — 구조](/ko/grammar/meta/structure/)

| Codec | 이름 | 뜻 |
|---|---|---|
| `0x00`~`0x02` | [DOC-1WORD / 2WORD / 4WORD](/ko/grammar/meta/structure/doc/) | 전체 길이를 지정해 문서를 연다 |
| `0x0E` | [BODY](/ko/grammar/meta/structure/body/) | HEAD를 끝내고 BODY를 연다 |
| `0x0F` | [END](/ko/grammar/meta/structure/end/) | 문서를 닫는다 |

자세한 규칙은 [문서](/ko/grammar/document/)에 있다.

## 정의

묶음 문서: [Meta — 정의](/ko/grammar/meta/declaration/)

| Codec | 이름 | 뜻 |
|---|---|---|
| `0x10` | [SPEC-VERSION](/ko/grammar/meta/declaration/spec-version/) | 따르는 명세 판. 정수 하나 |
| `0x11` | [PROFILE](/ko/grammar/meta/declaration/profile/) | 적용 프로파일 |
| `0x12` | [DOC-ID](/ko/grammar/meta/declaration/doc-id/) | 이 문서의 식별자. 자기 자신을 가리키는 DOC-POINTER(버전 0) |
| `0x13` | [EFFECTIVE-FROM](/ko/grammar/meta/declaration/effective-from/) | 이 버전의 시행일. 없으면 공표 시각 |
| `0x14` | [EFFECTIVE-UNTIL](/ko/grammar/meta/declaration/effective-until/) | 이 버전의 유효기간 끝(한시법). 없으면 다음 버전이 시행될 때까지 |
| `0x16` | [DEFAULT-LANGUAGE](/ko/grammar/meta/declaration/default-language/) | 기본 언어 |

- 문서의 주소용 이름은 Meta로 두지 않는다. Issuer의 이름 색인 `documents.geul`이 BIND로 붙인다([공표 주소와 버전 목록](/ko/grammar/publishing/#문서-이름)). 사람이 읽는 제목은 BODY의 LABEL로 붙인다.

## 출처

묶음 문서: [Meta — 출처](/ko/grammar/meta/provenance/)

| Codec | 이름 | 뜻 |
|---|---|---|
| `0x20` | [AUTHOR](/ko/grammar/meta/provenance/author/) | 작성자 (Reference) |
| `0x21` | [CO-AUTHOR](/ko/grammar/meta/provenance/co-author/) | 공동 작성자 |
| `0x22` | [CREATED-AT](/ko/grammar/meta/provenance/created-at/) | 작성 시각 |
| `0x23` | [MODIFIED-AT](/ko/grammar/meta/provenance/modified-at/) | 수정 시각 |
| `0x24` | [RECORDED-BY](/ko/grammar/meta/provenance/recorded-by/) | 기록한 주체 |
| `0x25` | [RECORDED-AT](/ko/grammar/meta/provenance/recorded-at/) | 기록한 시각 |
| `0x26` | [SOURCE](/ko/grammar/meta/provenance/source/) | 원천 자료. Reference 또는 URI·해시 |
| `0x27` | [SOURCE-SPAN](/ko/grammar/meta/provenance/source-span/) | 원문 안의 대응 범위 |
| `0x28` | [ACQUIRED-AT](/ko/grammar/meta/provenance/acquired-at/) | 원천 자료를 확보한 시각 |

## 계보

묶음 문서: [Meta — 계보](/ko/grammar/meta/lineage/)

계보는 git의 커밋 모델을 따른다. 커밋에 해당하는 단위가 문서다.

| Codec | 이름 | 뜻 |
|---|---|---|
| `0x30` | [PARENT](/ko/grammar/meta/lineage/parent/) | 직전 버전의 내용 해시. 여럿이면 병합 |
| `0x31` | [DERIVED-FROM](/ko/grammar/meta/lineage/derived-from/) | 다른 계보의 자료에서 파생 |
| `0x32` | [GENERATED-BY](/ko/grammar/meta/lineage/generated-by/) | 생성 주체(사람, 모델, 규칙 엔진) |
| `0x33` | [TRANSFORMED-BY](/ko/grammar/meta/lineage/transformed-by/) | 변환 도구와 그 소스 버전(커밋 다이제스트) |
| `0x34` | [CHERRY-PICKED-FROM](/ko/grammar/meta/lineage/cherry-picked-from/) | 가져온 변경의 원 버전 |
| `0x35` | [REVERTS](/ko/grammar/meta/lineage/reverts/) | 되돌린 대상 버전 |
| `0x36` | [REPLACES](/ko/grammar/meta/lineage/replaces/) | 고쳐 쓴 대상 버전. 원 버전은 지우지 않는다 |
| `0x37` | [SQUASHED-FROM](/ko/grammar/meta/lineage/squashed-from/) | 하나로 합친 원 버전들 |
| `0x38` | [MESSAGE](/ko/grammar/meta/lineage/message/) | 변경 이유. 언어마다 하나 |
| `0x39` | [TAG](/ko/grammar/meta/lineage/tag/) | 버전에 붙인 불변 이름 |
| `0x3A` | [DELTA-BASE](/ko/grammar/meta/lineage/delta-base/) | 이 파일은 기준 버전에 대한 diff다 |
| `0x3B` | [DELTA-REMOVE](/ko/grammar/meta/lineage/delta-remove/) | diff에서 뺄 LOCAL ID 목록 |
| `0x3C` | [NEXT-LOCAL-ID](/ko/grammar/meta/lineage/next-local-id/) | 다음에 배정할 LOCAL ID. 버전 목록 문서에 둔다 |

- 이력은 지우지 않는다. 고친 내용은 새 버전으로 낸다.
- branch처럼 바뀌는 포인터는 문서에 두지 않는다. 저장소와 색인이 관리한다.

## 검증

묶음 문서: [Meta — 검증](/ko/grammar/meta/verification/)

| Codec | 이름 | 뜻 |
|---|---|---|
| `0x40` | [ISSUER-KEY](/ko/grammar/meta/verification/issuer-key/) | 자체 발급 Issuer의 서명 알고리즘과 공개키 |
| `0x41` | [SIGNATURE](/ko/grammar/meta/verification/signature/) | 내용 해시에 대한 서명. 알고리즘, 서명자, 서명 |
| `0x42` | [SIGNED-OFF](/ko/grammar/meta/verification/signed-off/) | 기여 권리 확인 |
| `0x43` | [CONFIDENCE](/ko/grammar/meta/verification/confidence/) | 신뢰도 |
| `0x44` | [VERDICT](/ko/grammar/meta/verification/verdict/) | 문서 전체의 판정 결과(Pass, Review, Fail) |

- 검증 클래스는 내용 해시 계산에서 빠진다. 그래서 서명을 문서 안에 둬도, 서명을 여럿 더해도 내용 해시가 바뀌지 않는다.

## 정책

묶음 문서: [Meta — 정책](/ko/grammar/meta/policy/)

| Codec | 이름 | 뜻 |
|---|---|---|
| `0x50` | [LICENSE](/ko/grammar/meta/policy/license/) | 라이선스 |
| `0x51` | [ACCESS](/ko/grammar/meta/policy/access/) | 공개 범위 |
| `0x52` | [PRIVACY](/ko/grammar/meta/policy/privacy/) | 개인정보 등급 |
| `0x53` | [RETENTION](/ko/grammar/meta/policy/retention/) | 보존 기한 |
| `0x54` | [CONSENT](/ko/grammar/meta/policy/consent/) | 동의 범위와 근거 |
| `0x55` | [USAGE](/ko/grammar/meta/policy/usage/) | 사용 제한 |

- 정책은 해석을 바꾸지 않고 취급 방법을 정한다.

## IMPORT

묶음 문서: [Meta — IMPORT](/ko/grammar/meta/import/)

```
TAG WORD          0001 1LLL L110 0000      IMPORT-DOC (0x60)
[Length 확장 TAG]
문서              DOC-POINTER 레코드 (Issuer, 문서 ID, 버전 ID)
IMPORT ID         나머지. 가장 짧은 폭의 정수
```

- [IMPORT-DOC](/ko/grammar/meta/import/import-doc/)(`0x60`) 하나만 쓴다. IMPORT는 문서만 가져온다. 가져온 문서 안의 대상은 BODY의 `EXTERNAL-POINTER-*`(IMPORT ID, LOCAL ID)로 가리킨다.
- 버전 ID를 적으면 그 판본에, `0`이면 해석 시점의 최신 판본에 묶인다. 공표 문서는 버전을 적는다.
- 한 문서에서 같은 IMPORT ID를 두 번 배정하지 않는다.
- 가져온 문서의 HEAD는 가져오지 않는다. 그 문서의 대상은 그 문서의 선언대로 해석한다.

예: Issuer `0x0001`의 문서 `0x0000000000000002` 최신 버전을 IMPORT ID 1로 가져온다.

```
1CE0 03B8 0001 0000 0000 0000 0002 0000 0000 0001
```
