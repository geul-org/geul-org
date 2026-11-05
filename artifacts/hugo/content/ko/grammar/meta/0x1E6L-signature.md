---
title: "SIGNATURE (0x1E6L)"
weight: 486
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "문서의 내용 해시에 대한 서명이다(git 서명 커밋·태그)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `SIGNATURE` (규격 문서 BIND `SIGNATURE`) |
| TAG ID | `0x1E6L` |
| 코덱 ID | `0x00001E60` |
| 규격 문서 | `0x00000000/codecs/0x00001E60/` (DECLARE 대상 `1E60`) |
| 섹션 | 15 `1111` (Meta), 섹션 안 오프셋 C = 6 |
| Kind | Meta · 클래스: 검증 |
| TAG WORD | `0001 1110 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 대상에 대한 서명. 문서에 대한 서명은 내용 해시에 서명한다 (git 서명 커밋·태그) |
| Hugo 쪽 | `meta/verification/signature.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `algorithm` | #2 | 날값 1 WORD |  | `0x0001` ed25519 |
| 2 | `signer` | #3 | 레코드 | `0400` ISSUER-POINTER |  |
| 3 | `signature` | #4 | 나머지 날값(`0xFFFF`) |  |  |

문서의 내용 해시에 대한 서명이다(git 서명 커밋·태그).

## 레이아웃

```
TAG WORD          0001 1110 0110 LLLL      Codec 0x1E6L
[Length 확장 TAG]
알고리즘 ID       1 WORD (0x0001 = Ed25519)
서명자            ISSUER-POINTER(Issuer) Reference 레코드
서명              나머지 전부. 폭은 알고리즘이 정한다 (Ed25519 32 WORD)
```

- Codec: Meta `0x1E6L`, 검증 클래스
- Payload: 알고리즘 ID(날값 1 WORD) + 서명자(내장 Reference) + 서명(날값, 나머지)
- 개수: 여럿 가능

## 해석과 유효성

- 서명 대상은 내용 해시다. BODY만 서명하지 않는다([서명](../issuer.md#서명)).
- 검증 클래스라 내용 해시에서 빠진다. 서명을 더해도 해시가 같다.
- "서명이 있으면 확인"이 아니라 "정해진 키의 서명이 있어야 한다"로 검증한다.
- 버전 목록 문서는 공표처가 서명한다.
- 서명자는 Issuer 자신을 가리키는 [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md)(Issuer)다. Reference 레코드라 자기 Length로 끝나므로, 서명 폭이 알고리즘마다 달라도 레이아웃이 하나로 정해진다([DECLARE](../edge/0x0BBL-declare.md) 나머지 필드).
- 서명의 WORD 수가 알고리즘이 정한 폭과 다르면 invalid다.

## 열린 문제

- 서명 시각을 함께 서명할지.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001E60/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E6000000000
BODY
#1 DECLARE 0x1E60
#2 FIELD #1 0x0001
#3 FIELD #1 record
#11 CODEC #3 0x0400
#4 FIELD #1 rest
#5 ENUM #2 0x0001
#6 BIND #1 "SIGNATURE"
#7 BIND #2 "algorithm"
#8 BIND #3 "signer"
#9 BIND #4 "signature"
#10 BIND #5 "ed25519"
```
