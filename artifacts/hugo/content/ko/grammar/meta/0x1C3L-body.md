---
title: "BODY (0x1C3L)"
weight: 451
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "HEAD를 끝내고 BODY를 시작하는 레코드다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `BODY` (규격 문서 BIND `BODY`) |
| TAG ID | `0x1C3L` |
| 코덱 ID | `0x00001C30` |
| 규격 문서 | `0x00000000/codecs/0x00001C30/` (DECLARE 대상 `1C30`) |
| 섹션 | 14 `1110` (Meta), 섹션 안 오프셋 C = 3 |
| Kind | Meta · 클래스: 구조 |
| TAG WORD | `0001 1100 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 1 WORD. 문서의 HEAD를 끝내고 BODY를 시작한다. |
| Hugo 쪽 | `meta/structure/body.md` |

## 필드 (규격 문서)

규격 문서에 FIELD가 없다. Payload 필드를 선언하지 않는다.

HEAD를 끝내고 BODY를 시작하는 레코드다.

## 레이아웃

```
TAG WORD          0001 1100 0011 LLLL      Codec 0x1C3L
[Length 확장 TAG]
```

- Codec: Meta `0x1C3L`, 구조 클래스
- Payload: 없음(1 WORD)
- 개수: 문서마다 많아야 하나

## 해석과 유효성

- HEAD가 비어 있으면 생략한다. `BODY`가 없는 문서는 전부 BODY다. HEAD에 Meta나 HEAD Edge(문서 전체의 [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처)와 그 QUALIFIER)가 있으면 둔다.
- Payload가 없다. 전체 1 WORD다.

## 예시

- `0x1C30`

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001C30/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C3000000000
BODY
#1 DECLARE 0x1C30
#2 BIND #1 "BODY"
```
