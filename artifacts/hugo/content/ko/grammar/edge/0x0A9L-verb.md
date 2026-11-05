---
title: "VERB (0x0A9L)"
weight: 169
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "VERB는 동사 서술 Edge다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERB는 동사 서술 Edge다. 축약형은 [VERB-SHORT](0x0A8L-verb-short.md)(`0x0A8L`)다([Edge](_index.md#서술-edge)).

| 항목 | 값 |
|---|---|
| 이름 | `VERB` (규격 문서 BIND `VERB`) |
| TAG ID | `0x0A9L` |
| 코덱 ID | `0x00000A90` |
| 규격 문서 | `0x00000000/codecs/0x00000A90/` (DECLARE 대상 `0A90`) |
| 섹션 | 5 `0101` (Edge 서술), 섹션 안 오프셋 C = 9 |
| Kind | Edge · 계열: 서술, 묶음: 명제 |
| TAG WORD | `0000 1010 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 동사 서술 |
| Hugo 쪽 | `edge/_index.md` |

## 레이아웃

레이아웃은 아직 정하지 않았다. Edge 공통 레이아웃(TAG, [Length 확장 TAG], Edge Id, 구성요소)을 따른다([Edge](_index.md#레이아웃)).

## 코덱 문서

레이아웃을 아직 정하지 않았다. 코덱 문서는 DECLARE(대상 `0A90`)만 둔다. FIELD는 레이아웃이 정해지면 둔다.

## 관련 페이지

- [VERB-SHORT](0x0A8L-verb-short.md), [Edge](_index.md), [TRIPLE](0x0AAL-triple.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000A90/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A9000000000
BODY
#1 DECLARE 0x0A90
#2 BIND #1 "VERB"
```
