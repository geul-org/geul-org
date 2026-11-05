---
title: "SQUASHED-FROM (0x1D8L)"
weight: 472
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "하나로 합친 원 버전들의 내용 해시를 적는다(git squash)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `SQUASHED-FROM` (규격 문서 BIND `SQUASHED-FROM`) |
| TAG ID | `0x1D8L` |
| 코덱 ID | `0x00001D80` |
| 규격 문서 | `0x00000000/codecs/0x00001D80/` (DECLARE 대상 `1D80`) |
| 섹션 | 14 `1110` (Meta), 섹션 안 오프셋 C = 24 |
| Kind | Meta · 클래스: 계보 |
| TAG WORD | `0001 1101 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 하나로 합친 원 버전들의 내용 해시 (git squash) |
| Hugo 쪽 | `meta/lineage/squashed-from.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | 레코드 | `07C0` SHA-256-DIGEST |  |

하나로 합친 원 버전들의 내용 해시를 적는다(git squash).

## 레이아웃

```
TAG WORD          0001 1101 1000 LLLL      Codec 0x1D8L
[Length 확장 TAG]
Payload           SHA-256-DIGEST Value 하나 (16 WORD)
```

- Codec: Meta `0x1D8L`, 계보 클래스
- Payload: 내장 Value([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))
- 개수: 여럿 가능(원 버전마다 하나)

## 해석과 유효성

- 다이제스트 형식을 Value로 내장해 해시 알고리즘을 바꿀 여지를 둔다. 지금 내용 해시는 SHA-256뿐이다.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001D80/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D8000000000
BODY
#1 DECLARE 0x1D80
#2 FIELD #1 record
#5 CODEC #2 0x07C0
#3 BIND #1 "SQUASHED-FROM"
#4 BIND #2 "digest"
```
