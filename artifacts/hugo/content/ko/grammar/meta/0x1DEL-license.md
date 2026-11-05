---
title: "LICENSE (0x1DEL)"
weight: 478
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "이 문서와 바이트열 안 저작물의 라이선스를 적는다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `LICENSE` (규격 문서 BIND `LICENSE`) |
| TAG ID | `0x1DEL` |
| 코덱 ID | `0x00001DE0` |
| 규격 문서 | `0x00000000/codecs/0x00001DE0/` (DECLARE 대상 `1DE0`) |
| 섹션 | 14 `1110` (Meta), 섹션 안 오프셋 C = 30 |
| Kind | Meta · 클래스: 정책 |
| TAG WORD | `0001 1101 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 라이선스. Reference |
| Hugo 쪽 | `meta/policy/license.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `license` | #2 | 레코드 | `000F` 섹션 0 전체(와일드카드, Reference), `020F` 섹션 1 전체(와일드카드, Reference), `040F` 섹션 2 전체(와일드카드, Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0740` URI-EVEN, `0750` URI-ODD |  |

이 문서와 바이트열 안 저작물의 라이선스를 적는다.

## 레이아웃

```
TAG WORD          0001 1101 1110 LLLL      Codec 0x1DEL
[Length 확장 TAG]
Payload           라이선스를 가리키는 Reference, 또는 SPDX 식별자 UTF8-TEXT, 또는 URI Value
```

- Codec: Meta `0x1DEL`, 정책 클래스
- Payload: 내장 Reference 또는 Value([UTF8-TEXT](../value/0x072L-utf8-text.md), [URI](../value/0x074L-uri.md))
- 개수: 많아야 하나

## 해석과 유효성

- geul.org 공표 문서는 CC0다. 사설 공표는 Issuer가 정한다([Issuer](../issuer.md)).
- 원천 저작물의 원래 라이선스를 기록한다.

## 열린 문제

- SPDX 식별자를 텍스트로 둘지, GEUL 엔티티 Reference로 둘지.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001DE0/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DE000000000
BODY
#1 DECLARE 0x1DE0
#2 FIELD #1 record
#3 BIND #1 "LICENSE"
#4 BIND #2 "license"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0740
#9 CODEC #2 0x0750
```
