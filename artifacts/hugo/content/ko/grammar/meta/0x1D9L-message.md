---
title: "MESSAGE (0x1D9L)"
weight: 473
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "변경 이유를 적는다(git commit message)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `MESSAGE` (규격 문서 BIND `MESSAGE`) |
| TAG ID | `0x1D9L` |
| 코덱 ID | `0x00001D90` |
| 규격 문서 | `0x00000000/codecs/0x00001D90/` (DECLARE 대상 `1D90`) |
| 섹션 | 14 `1110` (Meta), 섹션 안 오프셋 C = 25 |
| Kind | Meta · 클래스: 계보 |
| TAG WORD | `0001 1101 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 변경 이유. UTF8-LANGUAGE-TEXT Value, 언어마다 하나 (git commit message) |
| Hugo 쪽 | `meta/lineage/message.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `message` | #2 | 레코드 | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

변경 이유를 적는다(git commit message).

## 레이아웃

```
TAG WORD          0001 1101 1001 LLLL      Codec 0x1D9L
[Length 확장 TAG]
메시지            UTF8-LANGUAGE-TEXT Value 1개
```

- Codec: Meta `0x1D9L`, 계보 클래스
- Payload: 내장 Value([UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md))
- 개수: 언어마다 많아야 하나

## 해석과 유효성

- 메시지와 언어는 UTF8-LANGUAGE-TEXT 하나에 담는다. 같은 언어의 MESSAGE는 하나다.
- geul.org 규격 문서는 [CODEC](../edge/0x0BEL-codec.md) `0780`·`0790`으로 적는다.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001D90/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D9000000000
BODY
#1 DECLARE 0x1D90
#2 FIELD #1 record
#3 BIND #1 "MESSAGE"
#4 BIND #2 "message"
#5 CODEC #2 0x0780
#6 CODEC #2 0x0790
```
