---
title: "Issuer와 공표"
weight: 80
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "Issuer는 문서와 형식을 정의하는 주체다. 폭(1·2·4·16 WORD)에 따라 발급 방식이 다르다. 공표한 문서는 버전 목록과 서명으로 고정되고 고정 주소로 서비스된다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL은 식별 체계를 한곳에 모으지 않는다. 각 Issuer가 대상과 형식을 정의하고, 다른 문서는 공표된 정의를 가져다 쓴다.

## Issuer가 정의하는 것

| 대상 | 방법 |
|---|---|
| 대상(엔티티, 개념, 용어) | 자기 문서의 LOCAL로 선언한다 |
| Value 형식 | Issuer 코드 아래 형식 번호로 정의한다 |
| Edge 형식 | Issuer 코드 아래 형식 번호로 정의한다 |

## Issuer 등급

| 폭 | 값 범위 | 발급 |
|---|---|---|
| 1 WORD | `0x0000`~`0xFFFF` | geul.org가 표준 제정 단체와 주요 기관에 배정 |
| 2 WORD | `0x00010000`~`0xFFFFFFFF` | geul.org 등록. 도메인 소유 증명을 거친다 |
| 4 WORD | `2^32`~`2^64−1` | geul.org 등록. 소유 증명이 없다 |
| 16 WORD | `2^64` 이상 | 자체 발급. 공개키에서 계산한다 |

- **Issuer ID는 정수값이다.** 값이 같으면 같은 Issuer다.
- **정규형은 가장 짧은 폭이다.** 값이 들어가는 가장 짧은 폭으로 쓰고, 더 넓은 폭의 표기는 거부한다.

### 1 WORD Issuer 예

| Issuer | 이름 | 대표 형식 |
|---|---|---|
| `0x0000` | GEUL | GEUL 고유 형식, 코덱북 |
| `0x0001` | ADHOC | 제정 단체가 없는 관례 형식 |
| `0x0010` | ISO | ISO 8601, ISO 4217, ISO 3166 |
| `0x0020` | IETF | URI, UUID, CRC32C, IP 주소 |
| `0x0021` | IANA | 미디어 타입, 언어 부태그 |
| `0x0022` | W3C | XML Schema, RDF |
| `0x0024` | UNICODE | 문자 인코딩, 정규화 |
| `0x0040` | IEEE | IEEE 754, MAC 주소 |
| `0x0060` | BIPM | SI 단위, TAI |
| `0x0062` | NIST | SHA-2, SHA-3 |

표준 단체가 GEUL 형식 번호를 직접 관리하지 않으면 geul.org가 대신 번호를 등재하고 표준 문서 식별자를 함께 기록한다.

### 16 WORD Issuer

```
Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ 서명 알고리즘 ID(2바이트) ‖ 공개키)
```

- 결과 32바이트를 16 WORD에 상위 바이트부터 쓴다.
- 등록 없이 누구나 만들 수 있다. 소유는 그 개인키의 서명으로 증명한다.
- 공개키와 알고리즘은 문서 HEAD의 `ISSUER-KEY`로 선언한다. 서명 알고리즘 `0x0001`은 Ed25519다.

## 문서 공개 방식

| 방식 | 대상 | 라이선스 | 존속 |
|---|---|---|---|
| geul.org 공표 | 1·2 WORD Issuer | CC0 | geul.org가 보존 |
| 사설 공표 | 모든 Issuer | Issuer가 정한다 | Issuer에 달림 |
| 대외비 | 모든 Issuer | 내부 | Issuer에 달림 |

- geul.org에 공표한 문서는 CC0다. 등록한 버전은 바꾸거나 지우지 않으며, Issuer가 사라져도 문서는 남는다.
- CC0가 아닌 라이선스로 공표하려면 자체 도메인에서 사설 공표한다. 라이선스는 HEAD의 `LICENSE`로 선언한다.
- 대외비 정의를 받지 못한 쪽은 그 레코드를 해석하지 못하고 건너뛴다.

## 공표 주소

GEUL은 문자열 URL이 아니라 ID(Issuer, 문서 ID, 버전 ID)로 문서를 가리킨다. 주소는 ID에서 정해진다.

```
/.well-known/geul/<Issuer>/<문서 ID>.geul              최신 버전 (정본 주소로 보낸다)
/.well-known/geul/<Issuer>/<문서 ID>/<버전 ID>.geul    문서 한 벌 (불변, 정본 주소)
/.well-known/geul/<Issuer>/<문서 ID>/versions.geul     버전 목록 (서명)
/.well-known/geul/h/<내용 해시>.geul                   내용 해시로 조회 (불변)
```

- ID는 소문자 `0x` + 폭 × 4자리 hex로 쓴다. 예: Issuer `0x0001`, 문서 ID `0x0000000000000002`, 버전 ID `0x00000003`.
- geul.org와 사설 공표가 같은 경로를 쓴다.
- 불변 주소는 영구히 캐시할 수 있다. 받은 쪽은 버전 목록의 내용 해시로 검증한다.
- 도메인을 증명한 Issuer는 `<Issuer>` 자리에 도메인을 쓸 수 있다(ID 주소로 보낸다).

## 버전 목록

공표처는 문서마다 버전 목록 문서 하나를 이어 쓴다.

```
DOC-*
  SPEC-VERSION
  PARENT          직전 목록 문서의 내용 해시
  RECORDED-AT     이 목록을 낸 시각
  NEXT-LOCAL-ID   다음에 배정할 LOCAL ID
  SIGNATURE       공표처의 서명
BODY
  PUBLICATION     #1  문서@1  내용 해시
  PUBLICATION     #2  문서@2  내용 해시
  DEPRECATION     #3  문서@1
  …
END
```

| Edge | 뜻 |
|---|---|
| PUBLICATION | 문서의 한 버전과 그 내용 해시를 공표한다 |
| DEPRECATION | 공표한 버전에 사용 중단 권고를 표시한다. 계속 해석된다 |
| TOMBSTONE | 공표한 버전을 삭제한다(법적·직권 삭제). 사유 범주를 적는다 |

- 새 목록은 직전 목록의 BODY를 그대로 앞에 두고 레코드를 덧붙인다. 고치거나 지우거나 순서를 바꾸지 않는다. 목록끼리 해시 사슬로 이어진다.
- 버전 ID는 1부터 빠짐없이 오름차순이다. 같은 내용을 다시 공표하지 않는다.
- 최신 버전은 폐기 권고도 삭제도 아닌 가장 높은 버전이다.
- 레코드에는 시각을 넣지 않는다. 그 레코드가 처음 실린 목록의 `RECORDED-AT`이 공표 시각이다.
- 문서 이름은 이름 색인 문서가 BIND로 문서에 묶는다. 이름은 공표된 문서에만 묶고, 한 이름은 한 문서에만 묶는다.

## 서명

- 서명은 공표 문서에 필수다. HEAD에 `SIGNATURE`로 둔다.
- 서명 대상은 문서의 **내용 해시**다. BODY만 서명하지 않는다. HEAD의 IMPORT·LICENSE·PARENT까지 함께 지켜야 하기 때문이다.
- 서명 키 확인:
  - 1·2·4 WORD Issuer: geul.org에 등록한 키. geul.org는 검증키 목록을 서명해 공개하고, 키 변경 기록을 추가만 가능한 로그로 남긴다.
  - 16 WORD Issuer: 같은 문서의 `ISSUER-KEY`. 그 공개키로 계산한 Issuer ID가 서명자와 같아야 한다.
- 서명이 없는 문서도 유효한 GEUL 문서다. 읽는 쪽은 서명이 없으면 신뢰도를 낮추고, 검증에 실패하면 더 크게 낮춘다.

## 용어 정의 문서

- Issuer가 정의한 용어(도구, 역할, 조직 안의 개념)는 **용어 하나에 문서 하나**로 둔다. 용어는 그 문서의 LOCAL이고, 이름은 BIND로, 가리키는 외부 대상(URI 등)은 REFERENCE-NODE로 잇는다.
- 다른 문서는 `EXTERNAL-ISSUER-*`(Issuer, 문서 ID, LOCAL ID)로 용어를 가리킨다. 같은 정의를 문서마다 반복하지 않는다.
- 외부 대상을 가리키는 순서: (1) 맞는 Reference Codec이 있으면 그것(위키데이터 등), (2) 그 대상을 정의한 GEUL 문서가 있으면 그것, (3) 없으면 자기 용어 정의 문서에 정의하고 가리킨다.
