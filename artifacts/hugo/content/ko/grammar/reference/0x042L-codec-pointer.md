---
title: "CODEC-POINTER (0x042L)"
weight: 66
date: 2026-11-03T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "CODEC-POINTER는 Issuer가 공표한 코덱 문서의 한 버전을 가리키는 지시선언 Reference다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CODEC-POINTER는 Issuer가 공표한 코덱 문서의 한 버전을 가리키는 지시선언 Reference다. 코덱 문서는 문서 ID가 없고, CODEC-POINTER로 자기와 버전을 가리킨다.

| 항목 | 값 |
|---|---|
| 이름 | `CODEC-POINTER` (규격 문서 BIND `CODEC-POINTER`) |
| TAG ID | `0x042L` |
| 코덱 ID | `0x00000420` |
| 규격 문서 | `0x00000000/codecs/0x00000420/` (DECLARE 대상 `0420`) |
| 섹션 | 2 `0010` (Reference 기타), 섹션 안 오프셋 C = 2 |
| Kind | Reference · 분류: 지시선언 |
| TAG WORD | `0000 0100 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | Issuer 코덱의 한 버전. Issuer + 코덱 ID 2 WORD + 버전 ID 2 WORD, 대상 ID가 없다 |
| Hugo 쪽 | `reference/codec-pointer.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | 나머지 날값(`0xFFFF`) |  |  |
| 2 | `codec` | #3 | 날값 2 WORD |  |  |
| 3 | `version` | #4 | 날값 2 WORD |  |  |

## 레이아웃

```
TAG WORD          0000 0100 0010 LLLL      Codec 0x042L
[Length 확장 TAG]
Issuer            2/4/16 WORD
코덱 ID           2 WORD
버전 ID           2 WORD
```

## 해석과 유효성

- Issuer 폭은 Payload에서 코덱 ID와 버전 ID 4 WORD를 뺀 나머지다. Payload는 6, 8, 20 WORD 중 하나이고, 그 밖의 길이는 invalid다. Issuer 값이 더 좁은 폭에 들어가면 invalid다(Issuer 정규형).
- Issuer가 16 WORD면 전체 21 WORD라 Length 확장 1 WORD가 붙는다.
- 코덱 ID는 32비트다. GEUL 직접 코드의 코덱 ID는 그 TAG WORD(L=0)를 32비트로 쓴 값이다(TRIPLE `0x0AAL` → `0x00000AA0`). Issuer 코덱의 코덱 ID는 레코드의 코덱 번호이고, Issuer가 Kind와 상관없이 자기 `codecs/` 안에서 겹치지 않게 정한다([공표 주소와 버전 목록](../publishing.md#id-표기)).
- 버전 ID `0`은 최신 버전이다. 그 밖의 값은 그 버전에 고정된다.
- Codec `0x042L` 한 칸이다. 양화가 없다(Identified). 섹션 2라 양화·체계로 읽지 않는다.
- 쓰는 곳: 코덱 문서의 Meta [DOC-ID](../meta/0x1C7L-doc-id.md), 코덱 버전 목록의 [PUBLICATION](../edge/0x0B8L-publication.md)·DEPRECATION·TOMBSTONE, 코덱 문서를 가져오는 [IMPORT-DOC](../meta/0x1E4L-import-doc.md). 이 자리들에서 DOC-POINTER를 대신한다.
- 공표 주소는 `/.well-known/geul/<Issuer>/codecs/<코덱 ID>/<버전 ID>.geul`이다([공표 주소와 버전 목록](../publishing.md#공표-주소)).

## 예시

GEUL Issuer `0x00000000`의 TRIPLE 코덱(코덱 ID `0x00000AA0`).

| 버전 | WORD sequence |
|---|---|
| 1 | `0426 0000 0000 0000 0AA0 0000 0001` |
| 최신 (`0`) | `0426 0000 0000 0000 0AA0 0000 0000` |

- TAG 1 + Issuer 2 + 코덱 ID 2 + 버전 ID 2 = 7 WORD, `LLLL=0110`이다. TAG는 `0000 0100 0010 0110` = `0426`이다.

## 관련 페이지

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [Codec 규격 문서](../codec-spec.md)
- [공표 주소와 버전 목록](../publishing.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000420/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000042000000000
BODY
#1 DECLARE 0x0420
#2 FIELD #1 rest
#3 FIELD #1 0x0002
#4 FIELD #1 0x0002
#5 BIND #1 "CODEC-POINTER"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "version"
```
