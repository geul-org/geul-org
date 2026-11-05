---
title: "REPLACES (0x1D7L)"
weight: 471
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "고쳐 쓴 대상 버전의 내용 해시를 적는다(git amend·rebase)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `REPLACES` (규격 문서 BIND `REPLACES`) |
| TAG ID | `0x1D7L` |
| 코덱 ID | `0x00001D70` |
| 규격 문서 | `0x00000000/codecs/0x00001D70/` (DECLARE 대상 `1D70`) |
| 섹션 | 14 `1110` (Meta), 섹션 안 오프셋 C = 23 |
| Kind | Meta · 클래스: 계보 |
| TAG WORD | `0001 1101 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 고쳐 쓴 대상 버전의 내용 해시 (git amend·rebase). 원 버전은 지우지 않는다. |
| Hugo 쪽 | `meta/lineage/replaces.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | 레코드 | `07C0` SHA-256-DIGEST |  |

고쳐 쓴 대상 버전의 내용 해시를 적는다(git amend·rebase).

## 레이아웃

```
TAG WORD          0001 1101 0111 LLLL      Codec 0x1D7L
[Length 확장 TAG]
Payload           SHA-256-DIGEST Value 하나 (16 WORD)
```

- Codec: Meta `0x1D7L`, 계보 클래스
- Payload: 내장 Value([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))
- 개수: 여럿 가능

## 해석과 유효성

- 원 버전은 지우지 않는다(구법 보존).
- 다이제스트 형식을 Value로 내장해 해시 알고리즘을 바꿀 여지를 둔다. 지금 내용 해시는 SHA-256뿐이다.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001D70/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D7000000000
BODY
#1 DECLARE 0x1D70
#2 FIELD #1 record
#5 CODEC #2 0x07C0
#3 BIND #1 "REPLACES"
#4 BIND #2 "digest"
```
