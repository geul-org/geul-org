---
title: "CO-AUTHOR (0x1CCL)"
weight: 460
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "문서를 함께 쓴 주체를 적는다(git Co-authored-by)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `CO-AUTHOR` (규격 문서 BIND `CO-AUTHOR`) |
| TAG ID | `0x1CCL` |
| 코덱 ID | `0x00001CC0` |
| 규격 문서 | `0x00000000/codecs/0x00001CC0/` (DECLARE 대상 `1CC0`) |
| 섹션 | 14 `1110` (Meta), 섹션 안 오프셋 C = 12 |
| Kind | Meta · 클래스: 출처 |
| TAG WORD | `0001 1100 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 공동 작성자. Reference (git `Co-authored-by`) |
| Hugo 쪽 | `meta/provenance/co-author.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `actor` | #2 | 레코드 | 아무 레코드(자리 표지 제외) |  |

문서를 함께 쓴 주체를 적는다(git `Co-authored-by`).

## 레이아웃

```
TAG WORD          0001 1100 1100 LLLL      Codec 0x1CCL
[Length 확장 TAG]
Payload           Reference 레코드 하나 (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL 등)
```

- Codec: Meta `0x1CCL`, 출처 클래스
- Payload: 내장 Reference
- 개수: 여럿 가능

## 해석과 유효성

- Reference는 Codec을 가리지 않는다. 사람·조직·모델·규칙 엔진 모두 될 수 있다([EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md), [GEUL](../reference/0x00AL-geul.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md), [LOCAL](../reference/0x005L-local.md) 등).
- geul.org 공표 문서에는 자연인을 가리키는 Reference를 두지 않는다([Issuer와 공표](../issuer.md#geulorg-공표)). 조직·Issuer를 가리킨다. 예외로 [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)로 자연인을 가리키는 것은 허용한다.
- LOCAL이면 BODY에서 그 대상을 서술한다.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001CC0/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CC000000000
BODY
#1 DECLARE 0x1CC0
#2 FIELD #1 record
#3 BIND #1 "CO-AUTHOR"
#4 BIND #2 "actor"
```
