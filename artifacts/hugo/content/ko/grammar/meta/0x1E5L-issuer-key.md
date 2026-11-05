---
title: "ISSUER-KEY (0x1E5L)"
weight: 485
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "자체 발급(16 WORD) Issuer의 공개키를 선언한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `ISSUER-KEY` (규격 문서 BIND `ISSUER-KEY`) |
| TAG ID | `0x1E5L` |
| 코덱 ID | `0x00001E50` |
| 규격 문서 | `0x00000000/codecs/0x00001E50/` (DECLARE 대상 `1E50`) |
| 섹션 | 15 `1111` (Meta), 섹션 안 오프셋 C = 5 |
| Kind | Meta · 클래스: 검증 |
| TAG WORD | `0001 1110 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 자체 발급 Issuer의 서명 알고리즘 ID와 공개키 선언 |
| Hugo 쪽 | `meta/verification/issuer-key.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `algorithm` | #2 | 날값 1 WORD |  | `0x0001` ed25519 |
| 2 | `key` | #3 | 나머지 날값(`0xFFFF`) |  |  |

자체 발급(16 WORD) Issuer의 공개키를 선언한다. Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ 알고리즘 ID ‖ 공개키)다([16 WORD Issuer](../issuer.md#16-word-issuer)).

## 레이아웃

```
TAG WORD          0001 1110 0101 LLLL      Codec 0x1E5L
[Length 확장 TAG]
알고리즘 ID       1 WORD (0x0001 = Ed25519)
공개키            알고리즘이 정한 폭 (Ed25519 16 WORD)
```

- Codec: Meta `0x1E5L`, 검증 클래스
- Payload: 날값(알고리즘 ID + 공개키)
- 개수: 여럿 가능(키 교체)

## 해석과 유효성

- 검증 클래스라 내용 해시에서 빠진다.
- 2·4 WORD Issuer는 geul.org에 등록한 키를 쓰므로 필요 없다.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001E50/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E5000000000
BODY
#1 DECLARE 0x1E50
#2 FIELD #1 0x0001
#3 FIELD #1 rest
#4 ENUM #2 0x0001
#5 BIND #1 "ISSUER-KEY"
#6 BIND #2 "algorithm"
#7 BIND #3 "key"
#8 BIND #4 "ed25519"
```
