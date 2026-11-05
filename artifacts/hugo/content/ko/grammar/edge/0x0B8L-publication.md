---
title: "PUBLICATION (0x0B8L)"
weight: 184
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "PUBLICATION·DEPRECATION·TOMBSTONE은 문서 버전의 공표·사용 중단 권고·삭제를 기록하는 서술 Edge이고, 이 페이지는 그 Edge로 쓰는 버전 목록 문서의 규격도 정한다(Codec 0x0B8L~0x0BAL)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PUBLICATION·DEPRECATION·TOMBSTONE은 문서 버전의 공표·사용 중단 권고·삭제를 기록하는 서술 Edge이고, 이 페이지는 그 Edge로 쓰는 버전 목록 문서의 규격도 정한다(Codec 0x0B8L~0x0BAL).

| 항목 | 값 |
|---|---|
| 이름 | `PUBLICATION` (규격 문서 BIND `PUBLICATION`) |
| TAG ID | `0x0B8L` |
| 코덱 ID | `0x00000B80` |
| 규격 문서 | `0x00000000/codecs/0x00000B80/` (DECLARE 대상 `0B80`) |
| 섹션 | 5 `0101` (Edge 서술), 섹션 안 오프셋 C = 24 |
| Kind | Edge · 계열: 서술, 묶음: 기타 |
| TAG WORD | `0000 1011 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 문서 공표. DOC-POINTER, 내용 해시 |
| Hugo 쪽 | `edge/publication.md` (그 쪽은 [DEPRECATION](0x0B9L-deprecation.md), [TOMBSTONE](0x0BAL-tombstone.md)도 함께 다룬다) |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)). Edge의 Edge Id는 FIELD로 선언하지 않는다.

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #2 | 레코드 | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |
| 2 | `hash` | #4 | 날값 16 WORD |  |  |

문서의 공표·deprecate·삭제를 기록하는 서술 Edge와, 그 Edge로 쓰는 버전 목록 문서의 규격이다. [공표 주소와 버전 목록](../publishing.md#버전-목록)의 버전 목록 형식을 정한다.

## 코드

| Codec | 이름 | Payload |
|---|---|---|
| `0x0B8L` | PUBLICATION | Edge Id, DOC-POINTER, 내용 해시 |
| `0x0B9L` | DEPRECATION | Edge Id, DOC-POINTER |
| `0x0BAL` | TOMBSTONE | Edge Id, DOC-POINTER, 사유 범주 |

- 세 코드는 디코더에 내장한다([0층](../publishing.md#층)). 버전 목록은 코덱북을 조회하지 않고 해석된다.
- 하위 형식(Codec별 TAG)을 두지 않는다. Payload 첫 요소가 Edge Id라는 [Edge](_index.md) 규칙을 그대로 지킨다.

## 레이아웃

```
TAG WORD          Edge, Codec 0x0B8L / 0x0B9L / 0x0BAL
[Length 확장 TAG]
Edge Id           LOCAL Reference 레코드
문서              DOC-POINTER Reference 레코드 (Issuer, 문서 ID, 버전 ID). 코덱 버전 목록은 CODEC-POINTER
내용 해시         16 WORD   (PUBLICATION)
사유 범주         1 WORD    (TOMBSTONE)
```

| 필드 | 폭 | 설명 |
|---|---|---|
| Edge Id | LOCAL Reference 레코드 | 목록 안 순번. 1부터 매기고 이어 붙인다 |
| 문서 | DOC-POINTER 레코드 | 공표한 문서의 한 버전([DOC-POINTER](../reference/0x041L-doc-pointer.md)). Issuer·문서 ID는 그 목록이 다루는 문서와 같다. 목록 문서가 경로 없이도 무엇의 목록인지 말하게 한다. 버전 ID는 그 문서 안의 순번([문서](../document.md) 버전)이며 `0`(최신)은 쓰지 않는다. 코덱의 버전 목록은 [CODEC-POINTER](../reference/0x042L-codec-pointer.md)(Issuer, 코덱 ID, 버전 ID)를 쓴다 |
| 내용 해시 | 16 WORD | 그 버전의 내용 해시(SHA-256, [문서](../document.md) 내용 해시) |
| 사유 범주 | 1 WORD | 삭제 사유의 범주 코드. 코드표는 열린 문제다 |

- DOC-POINTER 뒤의 길이는 코드마다 고정이다(16, 0, 1 WORD). 다르면 거부한다.
- 시각은 레코드에 넣지 않는다. 그 레코드가 처음 실린 목록 문서의 `RECORDED-AT`이 공표·deprecate·삭제 시각이다.

## 버전 목록 문서

공표처는 문서마다 버전 목록 문서 하나를 이어 쓴다: `/<Issuer>/docs/<문서 ID>/versions.geul`(코덱은 `/<Issuer>/codecs/<코덱 ID>/versions.geul`, Issuer 목록은 [아래](#목록-문서의-버전-목록)). 그 문서가 그 공표처에서 공표된 모든 버전이 한 목록에 들어간다.

```
DOC-1WORD/2WORD/4WORD     전체 길이
  SPEC-VERSION            0x0001 (v1)
  PARENT                  SHA-256-DIGEST Value. 직전 목록 문서의 내용 해시 (첫 목록이면 없음)
  RECORDED-AT             POSIX-TIMESTAMP-SECONDS Value. 이 목록을 낸 시각
  NEXT-LOCAL-ID           다음에 배정할 LOCAL ID (버전이 있으면)
  SIGNATURE               공표처의 서명. 대상은 이 목록 문서의 내용 해시
BODY
  PUBLICATION · DEPRECATION · TOMBSTONE …
END
```

- HEAD Meta: [SPEC-VERSION](../meta/0x1C5L-spec-version.md), [PARENT](../meta/0x1D1L-parent.md), [RECORDED-AT](../meta/0x1D0L-recorded-at.md), [NEXT-LOCAL-ID](../meta/0x1DDL-next-local-id.md), [SIGNATURE](../meta/0x1E6L-signature.md).
- 버전 목록 문서에는 `DOC-ID`를 두지 않는다(목록 문서의 예외, [DOC-ID](../meta/0x1C7L-doc-id.md)). 목록은 공표 문서가 아니라 그 문서에 딸린 기록이다. 어느 문서의 목록인지는 레코드의 DOC-POINTER(문서 ID)가 말한다. 그래서 경로 없이(`hashes/`, 덤프) 받아도 무엇의 목록인지 안다.
- 레코드의 문서 ID는 모두 그 목록이 다루는 문서여야 한다. 다른 문서의 레코드는 거부한다.
- 버전 목록 문서는 IMPORT를 두지 않고 0층 Codec만 쓴다. BODY에는 PUBLICATION·DEPRECATION·TOMBSTONE만 둔다. 문서 이름 BIND를 두지 않는다([공표 주소와 버전 목록](../publishing.md#문서-이름)).
- 새 목록 문서는 직전 목록 문서의 BODY를 그대로 앞에 두고 레코드를 덧붙인다. 고치거나 지우거나 순서를 바꾸지 않는다.
- 공표처가 목록에 서명한다. geul.org 공표는 geul.org(GEUL Issuer)가, 사설 공표는 그 Issuer가 서명한다.
- 문서 ID `0x0000000000000000`은 Issuer의 용어 정의 색인 문서다([Issuer와 공표](../issuer.md)). Issuer 자신은 [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md)로 가리킨다.

## 목록 문서의 버전 목록

목록 문서는 Issuer 목록 `issuers/` 하나다([공표 주소와 버전 목록](../publishing.md#목록-문서)). Issuer 목록도 버전 1부터이고 버전 목록 `issuers/versions.geul`을 둔다. 레코드는 예약 문서 ID의 DOC-POINTER(`0x00000000`, `0xFFFFFFFFFFFFFFFF`, 버전 ID)로 목록 버전을 가리킨다.

- 레코드 형식은 위와 같다. 그래서 `hashes/`로 받아도 무엇의 목록인지 안다.
- 목록 문서 자신(`<버전 ID>.geul`)도 `DOC-ID`를 두지 않는다.
- 문서 ID `0xFFFFFFFFFFFFFFFF`는 어느 Issuer에서도 `<Issuer>/docs/<문서 ID>/` 주소로 받지 않는다(404).
- 목록의 `latest.geul`은 저장하지 않는 별칭이다. 이 버전 목록에서 가장 최근 버전을 찾아 그 바이트를 낸다.

## 규칙

- PUBLICATION의 버전 ID는 1부터 빠짐없이 오름차순이다. 버전 ID는 공표처가 배정한다.
- 같은 내용 해시를 다시 공표하지 않는다. 이미 있으면 그 버전 ID를 돌려준다.
- DEPRECATION·TOMBSTONE은 앞에 나온 PUBLICATION의 버전 ID만 가리킨다. 없는 버전을 가리키면 거부한다.
- 버전의 상태는 레코드를 차례로 적용해 계산한다. 공표됨 → deprecated → 삭제됨. 삭제된 버전은 다시 공표하지 않고 내주지 않는다.
- 최신 버전은 deprecated도 삭제도 아닌 가장 높은 버전 ID다.
- 버전 ID가 2 WORD 끝에 이르면 그 문서는 더 공표하지 않고 새 문서 ID로 낸다.

## 주소

```
/.well-known/geul/<Issuer>/docs/<문서 ID>/versions.geul        최신 목록 문서 (가변)
/.well-known/geul/<Issuer>/codecs/<코덱 ID>/versions.geul      코덱의 최신 목록 문서 (가변)
/.well-known/geul/issuers/versions.geul                       Issuer 목록의 최신 버전 목록 (가변)
/.well-known/geul/<Issuer>/hashes/<내용 해시>.geul             지난 목록 문서 (불변)
```

- 가변인 것은 최신 목록 주소다. 받은 목록은 서명, `RECORDED-AT`, `PARENT` 사슬로 검증한다.
- 지난 목록 문서는 모두 `<Issuer>/hashes/`에 남긴다. `PARENT` 사슬을 따라 어느 시점의 목록이든 되짚을 수 있다.

## 검증

- 목록 문서에 정해진 공표처 키의 `SIGNATURE`가 있어야 한다.
- 레코드의 문서 ID가 요청한 문서 ID와 같아야 한다.
- 잠금 기록에 남은 직전 목록의 내용 해시가 새 목록의 `PARENT` 사슬에 있어야 한다. 그 목록의 BODY는 새 목록 BODY의 앞부분과 같아야 한다.
- 받은 문서의 내용 해시는 그 버전 ID의 PUBLICATION이 적은 값과 같아야 하고, 문서의 `DOC-ID`는 요청한 Issuer·문서 ID와 같아야 한다. 목록 문서는 `DOC-ID`가 없다.

## 열린 문제

- 사유 범주 코드표.
- 서명 알고리즘 기본값과 `SIGNATURE` Payload 레이아웃.
- 목록이 커질 때 Merkle 로그(포함·일관성 증명)로 옮기는 시점과 형식.
- Issuer 단위 되감기 방지. 목록이 문서마다 따로 사슬을 이루므로, 한 문서의 목록만 옛것으로 내미는 공격은 그 문서의 사슬로만 막힌다.

## 관련 페이지

- [Edge](_index.md), [BIND](0x0A3L-bind.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md)
- [Issuer와 공표](../issuer.md), [공표 주소와 버전 목록](../publishing.md), [문서](../document.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000B80/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000B8000000000
BODY
#1 DECLARE 0x0B80
#2 FIELD #1 record
#9 CODEC #2 0x0410
#4 FIELD #1 0x0010
#5 BIND #1 "PUBLICATION"
#6 BIND #2 "doc"
#8 BIND #4 "hash"
#10 CODEC #2 0x0420
```
