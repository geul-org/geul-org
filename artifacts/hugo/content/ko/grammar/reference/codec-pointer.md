---
title: "CODEC-POINTER"
weight: 14
date: 2026-11-03T12:00:00+09:00
lastmod: 2026-11-03T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "CODEC-POINTER는 Issuer가 공표한 코덱의 한 버전을 가리키는 지시선언 Reference다. Issuer, 코덱 ID, 버전 ID를 담고 버전 ID 0은 최신 버전이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CODEC-POINTER는 Issuer가 공표한 코덱 문서의 한 버전을 가리키는 지시선언 Reference다. 코덱 문서는 문서 ID가 없고, CODEC-POINTER로 자기와 버전을 가리킨다.

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
- 코덱 ID는 32비트다. GEUL 직접 코드의 코덱 ID는 그 TAG WORD(L=0)를 32비트로 쓴 값이다(TRIPLE `0x0AAL` → `0x00000AA0`). Issuer 코덱의 코덱 ID는 레코드의 코덱 번호이고, Issuer가 Kind와 상관없이 자기 `codecs/` 안에서 겹치지 않게 정한다([공표 주소와 버전 목록](/ko/grammar/publishing/#id-표기)).
- 버전 ID `0`은 최신 버전이다. 그 밖의 값은 그 버전에 고정된다.
- Codec `0x042L` 한 칸이다. 양화가 없다(Identified). 섹션 2라 양화·체계로 읽지 않는다.
- 쓰는 곳: 코덱 문서의 Meta [DOC-ID](/ko/grammar/meta/declaration/doc-id/), 코덱 버전 목록의 [PUBLICATION](/ko/grammar/edge/publication/)·DEPRECATION·TOMBSTONE, 코덱 문서를 가져오는 [IMPORT-DOC](/ko/grammar/meta/import/import-doc/). 이 자리들에서 DOC-POINTER를 대신한다.
- 공표 주소는 `/.well-known/geul/<Issuer>/codecs/<코덱 ID>/<버전 ID>.geul`이다([공표 주소와 버전 목록](/ko/grammar/publishing/#공표-주소)).

## 예시

GEUL Issuer `0x00000000`의 TRIPLE 코덱(코덱 ID `0x00000AA0`).

| 버전 | WORD sequence |
|---|---|
| 1 | `0426 0000 0000 0000 0AA0 0000 0001` |
| 최신 (`0`) | `0426 0000 0000 0000 0AA0 0000 0000` |

- TAG 1 + Issuer 2 + 코덱 ID 2 + 버전 ID 2 = 7 WORD, `LLLL=0110`이다. TAG는 `0000 0100 0010 0110` = `0426`이다.

## 관련 페이지

- [Reference](/ko/grammar/reference/), [DOC-POINTER](/ko/grammar/reference/doc-pointer/), [ISSUER-POINTER](/ko/grammar/reference/issuer-pointer/), [Codec 규격 문서](/ko/grammar/codec-spec/)
- [공표 주소와 버전 목록](/ko/grammar/publishing/)
