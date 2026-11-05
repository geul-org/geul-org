---
title: "USAGE (0x1E3L)"
weight: 483
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "사용 제한을 적는다(예: 학습 금지, 상업적 이용 금지)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `USAGE` (규격 문서 BIND `USAGE`) |
| TAG ID | `0x1E3L` |
| 코덱 ID | `0x00001E30` |
| 규격 문서 | `0x00000000/codecs/0x00001E30/` (DECLARE 대상 `1E30`) |
| 섹션 | 15 `1111` (Meta), 섹션 안 오프셋 C = 3 |
| Kind | Meta · 클래스: 정책 |
| TAG WORD | `0001 1110 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 사용 제한 |
| Hugo 쪽 | `meta/policy/usage.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `usage` | #2 | 레코드 | `000F` 섹션 0 전체(와일드카드, Reference), `020F` 섹션 1 전체(와일드카드, Reference), `040F` 섹션 2 전체(와일드카드, Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

사용 제한을 적는다(예: 학습 금지, 상업적 이용 금지).

## 레이아웃

```
TAG WORD          0001 1110 0011 LLLL      Codec 0x1E3L
[Length 확장 TAG]
Payload           사용 제한을 나타내는 텍스트 또는 Reference
```

- Codec: Meta `0x1E3L`, 정책 클래스
- Payload: 내장 Value 또는 Reference
- 개수: 여럿 가능

## 열린 문제

- 제한 종류 코드표.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001E30/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E3000000000
BODY
#1 DECLARE 0x1E30
#2 FIELD #1 record
#3 BIND #1 "USAGE"
#4 BIND #2 "usage"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0780
#9 CODEC #2 0x0790
```
