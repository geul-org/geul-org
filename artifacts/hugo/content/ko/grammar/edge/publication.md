---
title: "PUBLICATION"
weight: 25
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "PUBLICATION·DEPRECATION·TOMBSTONE은 문서 버전의 공표·사용 중단 권고·삭제를 기록하는 서술 Edge이고, 이 페이지는 그 Edge로 쓰는 버전 목록 문서의 규격도 정한다(Codec 0x18~0x1A)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

문서의 공표·deprecate·삭제를 기록하는 서술 Edge와, 그 Edge로 쓰는 버전 목록 문서의 규격이다. [공표 주소와 버전 목록](/ko/grammar/publishing/#버전-목록)의 버전 목록 형식을 정한다.

## 코드

| Codec | 이름 | Payload |
|---|---|---|
| `0x18` | PUBLICATION | Edge Id, DOC-POINTER, 내용 해시 |
| `0x19` | DEPRECATION | Edge Id, DOC-POINTER |
| `0x1A` | TOMBSTONE | Edge Id, DOC-POINTER, 사유 범주 |

- 세 코드는 디코더에 내장한다([0층](/ko/grammar/publishing/#층)). 버전 목록은 코덱북을 조회하지 않고 해석된다.
- 하위 형식(Codec별 TAG)을 두지 않는다. Payload 첫 요소가 Edge Id라는 [Edge](/ko/grammar/edge/) 규칙을 그대로 지킨다.

## 레이아웃

```
TAG WORD          Edge, Codec 0x18 / 0x19 / 0x1A
[Length 확장 TAG]
Edge Id           LOCAL Reference 레코드
문서              DOC-POINTER Reference 레코드 (Issuer, 문서 ID, 버전 ID)
내용 해시         16 WORD   (PUBLICATION)
사유 범주         1 WORD    (TOMBSTONE)
```

| 필드 | 폭 | 설명 |
|---|---|---|
| Edge Id | LOCAL Reference 레코드 | 목록 안 순번. 1부터 매기고 이어 붙인다 |
| 문서 | DOC-POINTER 레코드 | 공표한 문서의 한 버전([DOC-POINTER](/ko/grammar/reference/doc-pointer/)). Issuer·문서 ID는 그 목록이 다루는 문서와 같다. 목록 문서가 경로 없이도 무엇의 목록인지 말하게 한다. 버전 ID는 그 문서 안의 순번([문서](/ko/grammar/document/) 버전)이며 `0`(최신)은 쓰지 않는다 |
| 내용 해시 | 16 WORD | 그 버전의 내용 해시(SHA-256, [문서](/ko/grammar/document/) 내용 해시) |
| 사유 범주 | 1 WORD | 삭제 사유의 범주 코드. 코드표는 열린 문제다 |

- DOC-POINTER 뒤의 길이는 코드마다 고정이다(16, 0, 1 WORD). 다르면 거부한다.
- 시각은 레코드에 넣지 않는다. 그 레코드가 처음 실린 목록 문서의 `RECORDED-AT`이 공표·deprecate·삭제 시각이다.

## 버전 목록 문서

공표처는 문서마다 버전 목록 문서 하나를 이어 쓴다: `/<Issuer>/<문서 ID>/versions.geul`. 그 문서가 그 공표처에서 공표된 모든 버전이 한 목록에 들어간다.

```
DOC-1WORD/2WORD/4WORD     전체 길이
  SPEC-VERSION            0x0001 (v1)
  PARENT                  SHA-256-DIGEST Value. 직전 목록 문서의 내용 해시 (첫 목록이면 없음)
  RECORDED-AT             POSIX-TIMESTAMP-SECONDS Value. 이 목록을 낸 시각
  NEXT-LOCAL-ID           다음에 배정할 LOCAL ID (버전이 있으면)
  SIGNATURE               공표처의 서명. 대상은 이 목록 문서의 내용 해시
BODY
  PUBLICATION · DEPRECATION · TOMBSTONE · BIND …
END
```

- HEAD Meta: [SPEC-VERSION](/ko/grammar/meta/declaration/spec-version/), [PARENT](/ko/grammar/meta/lineage/parent/), [RECORDED-AT](/ko/grammar/meta/provenance/recorded-at/), [NEXT-LOCAL-ID](/ko/grammar/meta/lineage/next-local-id/), [SIGNATURE](/ko/grammar/meta/verification/signature/).
- 목록 문서에는 `DOC-ID`를 두지 않는다(이름이 `0x`로 시작하지 않는 문서의 예외, [DOC-ID](/ko/grammar/meta/declaration/doc-id/)). 목록은 공표 문서가 아니라 그 문서에 딸린 기록이다. 어느 문서의 목록인지는 레코드의 문서 ID가 말한다. 그래서 경로 없이(`h/`, 덤프) 받아도 무엇의 목록인지 안다.
- 레코드의 문서 ID는 모두 그 목록이 다루는 문서여야 한다. 다른 문서의 레코드는 거부한다.
- 목록 문서는 IMPORT를 두지 않고 0층 Codec만 쓴다. 다른 목록에 올리지 않는다(목록의 목록 없음).
- 새 목록 문서는 직전 목록 문서의 BODY를 그대로 앞에 두고 레코드를 덧붙인다. 고치거나 지우거나 순서를 바꾸지 않는다.
- 공표처가 목록에 서명한다. geul.org 공표는 geul.org(GEUL Issuer)가, 사설 공표는 그 Issuer가 서명한다.
- 문서 ID `0x0000000000000000`은 Issuer의 용어 정의 색인 문서다([Issuer와 공표](/ko/grammar/issuer/)). Issuer 자신은 [ISSUER-POINTER](/ko/grammar/reference/issuer-pointer/)로 가리킨다.

## 규칙

- PUBLICATION의 버전 ID는 1부터 빠짐없이 오름차순이다. 버전 ID는 공표처가 배정한다.
- 같은 내용 해시를 다시 공표하지 않는다. 이미 있으면 그 버전 ID를 돌려준다.
- DEPRECATION·TOMBSTONE은 앞에 나온 PUBLICATION의 버전 ID만 가리킨다. 없는 버전을 가리키면 거부한다.
- 버전의 상태는 레코드를 차례로 적용해 계산한다. 공표됨 → deprecated → 삭제됨. 삭제된 버전은 다시 공표하지 않고 내주지 않는다.
- 최신 버전은 deprecated도 삭제도 아닌 가장 높은 버전 ID다.
- 버전 ID가 2 WORD 끝에 이르면 그 문서는 더 공표하지 않고 새 문서 ID로 낸다.

## 문서 이름

문서의 주소용 이름은 Issuer의 이름 색인 `/<Issuer>/documents.geul`이 [BIND](/ko/grammar/edge/bind/)로 묶는다([공표 주소와 버전 목록](/ko/grammar/publishing/#문서-이름)). 해석기는 이 색인만 읽는다.

목록 문서에도 같은 BIND를 둘 수 있다(선택). 두면 다음을 지킨다.

- Subject는 `DOC-POINTER`(Issuer, 그 목록의 문서 ID, 버전 `0`)다. 이름은 버전이 아니라 문서에 묶이므로 버전은 `0`이다.
- 앞에 PUBLICATION이 나온 문서에만 묶는다. 공표된 적 없는 문서에 이름을 묶지 않는다.
- 이름은 문서 이름 규칙(소문자 ASCII 슬러그)을 따르고, 이름 색인의 BIND와 같아야 한다.
- 이름을 바꾸면 새 BIND를 덧붙인다. 옛 이름은 그대로 남아 같은 문서를 가리킨다. 대표 이름은 마지막 BIND다.
- 문서 안에는 자기 이름을 적지 않는다.

## 주소

```
/.well-known/geul/<Issuer>/<문서 ID>/versions.geul             최신 목록 문서 (가변)
/.well-known/geul/h/<내용 해시>.geul                           지난 목록 문서 (불변)
```

- 가변인 것은 최신 목록 주소 하나다. 받은 목록은 서명, `RECORDED-AT`, `PARENT` 사슬로 검증한다.
- 지난 목록 문서는 모두 `h/`에 남긴다. `PARENT` 사슬을 따라 어느 시점의 목록이든 되짚을 수 있다.

## 검증

- 목록 문서에 정해진 공표처 키의 `SIGNATURE`가 있어야 한다.
- 레코드의 문서 ID가 요청한 문서 ID와 같아야 한다.
- 잠금 기록에 남은 직전 목록의 내용 해시가 새 목록의 `PARENT` 사슬에 있어야 한다. 그 목록의 BODY는 새 목록 BODY의 앞부분과 같아야 한다.
- 받은 문서의 내용 해시는 그 버전 ID의 PUBLICATION이 적은 값과 같아야 하고, 문서의 `DOC-ID`는 요청한 Issuer·문서 ID와 같아야 한다.

## 열린 문제

- 사유 범주 코드표.
- 서명 알고리즘 기본값과 `SIGNATURE` Payload 레이아웃.
- 목록이 커질 때 Merkle 로그(포함·일관성 증명)로 옮기는 시점과 형식.
- 목록의 BIND와 이름 색인 `documents.geul`을 하나로 합칠지, 색인의 서명.
- Issuer 단위 되감기 방지. 목록이 문서마다 따로 사슬을 이루므로, 한 문서의 목록만 옛것으로 내미는 공격은 그 문서의 사슬로만 막힌다.

## 관련 페이지

- [Edge](/ko/grammar/edge/), [BIND](/ko/grammar/edge/bind/), [DOC-POINTER](/ko/grammar/reference/doc-pointer/)
- [Issuer와 공표](/ko/grammar/issuer/), [공표 주소와 버전 목록](/ko/grammar/publishing/), [문서](/ko/grammar/document/)
