---
title: "AUTHOR (0x1CBL)"
weight: 459
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "문서 내용을 쓴 주체를 적는다(git author)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `AUTHOR` (규격 문서 BIND `AUTHOR`) |
| TAG ID | `0x1CBL` |
| 코덱 ID | `0x00001CB0` |
| 규격 문서 | `0x00000000/codecs/0x00001CB0/` (DECLARE 대상 `1CB0`) |
| 섹션 | 14 `1110` (Meta), 섹션 안 오프셋 C = 11 |
| Kind | Meta · 클래스: 출처 |
| TAG WORD | `0001 1100 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 작성자. Reference (git author) |
| Hugo 쪽 | `meta/provenance/author.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `actor` | #2 | 레코드 | 아무 레코드(자리 표지 제외) |  |

문서 내용을 쓴 주체를 적는다(git author).

## 레이아웃

```
TAG WORD          0001 1100 1011 LLLL      Codec 0x1CBL
[Length 확장 TAG]
Payload           Reference 레코드 하나 (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL 등)
```

- Codec: Meta `0x1CBL`, 출처 클래스
- Payload: 내장 Reference
- 개수: 많아야 하나

## 해석과 유효성

- Reference는 Codec을 가리지 않는다. 사람·조직·모델·규칙 엔진 모두 될 수 있다([EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md), [GEUL](../reference/0x00AL-geul.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md), [LOCAL](../reference/0x005L-local.md) 등).
- geul.org 공표 문서에는 자연인을 가리키는 Reference를 두지 않는다([Issuer와 공표](../issuer.md#geulorg-공표)). 조직·Issuer를 가리킨다. 예외로 [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)로 자연인을 가리키는 것은 허용한다.
- LOCAL이면 BODY에서 그 대상을 서술한다.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001CB0/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CB000000000
BODY
#1 DECLARE 0x1CB0
#2 FIELD #1 record
#3 BIND #1 "AUTHOR"
#4 BIND #2 "actor"
```
