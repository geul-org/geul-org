---
title: "ACCESS (0x1DFL)"
weight: 479
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "문서의 공개 범위를 적는다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `ACCESS` (규격 문서 BIND `ACCESS`) |
| TAG ID | `0x1DFL` |
| 코덱 ID | `0x00001DF0` |
| 규격 문서 | `0x00000000/codecs/0x00001DF0/` (DECLARE 대상 `1DF0`) |
| 섹션 | 14 `1110` (Meta), 섹션 안 오프셋 C = 31 |
| Kind | Meta · 클래스: 정책 |
| TAG WORD | `0001 1101 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 공개 범위 |
| Hugo 쪽 | `meta/policy/access.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `level` | #2 | 날값 1 WORD |  | `0x0000` public, `0x0001` internal, `0x0002` confidential |

문서의 공개 범위를 적는다.

## 레이아웃

```
TAG WORD          0001 1101 1111 LLLL      Codec 0x1DFL
[Length 확장 TAG]
등급              1 WORD (0 공개, 1 내부, 2 대외비, 그 밖 Reserved)
```

- Codec: Meta `0x1DFL`, 정책 클래스
- Payload: 날값(등급 1 WORD)
- 개수: 많아야 하나

## 해석과 유효성

- 대외비 문서는 공표하지 않는다([Issuer](../issuer.md)).
- 해석을 바꾸지 않는다. 취급만 정한다.

## 열린 문제

- 등급 코드표.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001DF0/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DF000000000
BODY
#1 DECLARE 0x1DF0
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 ENUM #2 0x0002
#6 BIND #1 "ACCESS"
#7 BIND #2 "level"
#8 BIND #3 "public"
#9 BIND #4 "internal"
#10 BIND #5 "confidential"
```
