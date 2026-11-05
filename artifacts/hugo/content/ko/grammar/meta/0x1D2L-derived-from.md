---
title: "DERIVED-FROM (0x1D2L)"
weight: 466
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "이 문서가 다른 계보의 문서·자료에서 파생했음을 적는다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `DERIVED-FROM` (규격 문서 BIND `DERIVED-FROM`) |
| TAG ID | `0x1D2L` |
| 코덱 ID | `0x00001D20` |
| 규격 문서 | `0x00000000/codecs/0x00001D20/` (DECLARE 대상 `1D20`) |
| 섹션 | 14 `1110` (Meta), 섹션 안 오프셋 C = 18 |
| Kind | Meta · 클래스: 계보 |
| TAG WORD | `0001 1101 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 다른 계보의 레코드·자료에서 파생. 외부 자료의 특정 버전에 고정할 때는 HEAD의 [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처)에 원문 해시 QUALIFIER(P4092)를 붙인다(git submodule). |
| Hugo 쪽 | `meta/lineage/derived-from.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `source` | #2 | 레코드 | `000F` 섹션 0 전체(와일드카드, Reference), `020F` 섹션 1 전체(와일드카드, Reference), `040F` 섹션 2 전체(와일드카드, Reference), `07C0` SHA-256-DIGEST, `0740` URI-EVEN, `0750` URI-ODD |  |

이 문서가 다른 계보의 문서·자료에서 파생했음을 적는다.

## 레이아웃

```
TAG WORD          0001 1101 0010 LLLL      Codec 0x1D2L
[Length 확장 TAG]
Payload           Reference, 또는 SHA-256-DIGEST(내용 해시), 또는 URI Value
```

- Codec: Meta `0x1D2L`, 계보 클래스
- Payload: 내장 Reference 또는 Value
- 개수: 여럿 가능

## 해석과 유효성

- GEUL 문서에서 파생했으면 그 내용 해시([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))를, 외부 자료면 [URI](../value/0x074L-uri.md)를 둔다. 외부 자료의 판본을 해시로 고정하려면 HEAD의 [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처)에 원문 해시 QUALIFIER(P4092)를 붙인다.
- 레코드 단위 원천은 근거 Edge [SOURCE](../edge/0x0C0L-source.md)가, 이동·분할·통합 전의 옛 레코드는 대상 Edge의 QUALIFIER P1365(값은 옛 Edge Id)가 맡는다.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001D20/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D2000000000
BODY
#1 DECLARE 0x1D20
#2 FIELD #1 record
#3 BIND #1 "DERIVED-FROM"
#4 BIND #2 "source"
#5 CODEC #2 0x000F
#9 CODEC #2 0x020F
#10 CODEC #2 0x040F
#6 CODEC #2 0x07C0
#7 CODEC #2 0x0740
#8 CODEC #2 0x0750
```
