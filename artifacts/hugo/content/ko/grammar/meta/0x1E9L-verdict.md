---
title: "VERDICT (0x1E9L)"
weight: 489
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "문서 전체의 판정 결과를 적는다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `VERDICT` (규격 문서 BIND `VERDICT`) |
| TAG ID | `0x1E9L` |
| 코덱 ID | `0x00001E90` |
| 규격 문서 | `0x00000000/codecs/0x00001E90/` (DECLARE 대상 `1E90`) |
| 섹션 | 15 `1111` (Meta), 섹션 안 오프셋 C = 9 |
| Kind | Meta · 클래스: 검증 |
| TAG WORD | `0001 1110 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 문서 전체의 판정 결과. Pass, Review, Fail. 노드·레코드 단위는 [TOULMIN](../toulmin/_index.md) `VERDICT`(Edge `0x118L`) |
| Hugo 쪽 | `meta/verification/verdict.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `verdict` | #2 | 날값 1 WORD |  | `0x0000` pass, `0x0001` review, `0x0002` fail |

문서 전체의 판정 결과를 적는다. 노드·레코드 단위 판정은 [TOULMIN](../toulmin/_index.md) `VERDICT`(Edge `0x118L`)가 맡는다.

## 레이아웃

```
TAG WORD          0001 1110 1001 LLLL      Codec 0x1E9L
[Length 확장 TAG]
판정              1 WORD (0 Pass, 1 Review, 2 Fail)
```

- Codec: Meta `0x1E9L`, 검증 클래스
- Payload: 날값(판정 1 WORD)
- 개수: 많아야 하나

## 해석과 유효성

- 검증 클래스라 내용 해시에서 빠진다.
- 다른 문서에 대한 판정은 판정 대상과 다른 문서의 BODY에 둔다.

## 열린 문제

- 판정 주체와 근거를 함께 적을지.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001E90/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E9000000000
BODY
#1 DECLARE 0x1E90
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 ENUM #2 0x0002
#6 BIND #1 "VERDICT"
#7 BIND #2 "verdict"
#8 BIND #3 "pass"
#9 BIND #4 "review"
#10 BIND #5 "fail"
```
