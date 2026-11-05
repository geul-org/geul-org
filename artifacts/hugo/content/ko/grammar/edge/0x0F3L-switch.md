---
title: "SWITCH (0x0F3L)"
weight: 243
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "SWITCH는 실행 Edge 문 묶음의 Codec이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SWITCH는 실행 Edge 문 묶음의 Codec이다. 뜻: 다중 분기.

| 항목 | 값 |
|---|---|
| 이름 | `SWITCH` (규격 문서 BIND `SWITCH`) |
| TAG ID | `0x0F3L` |
| 코덱 ID | `0x00000F30` |
| 규격 문서 | `0x00000000/codecs/0x00000F30/` (DECLARE 대상 `0F30`) |
| 섹션 | 7 `0111` (Edge 실행), 섹션 안 오프셋 C = 19 |
| Kind | Edge · 계열: 실행, 묶음: 문 |
| TAG WORD | `0000 1111 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 다중 분기. 대상, 갈래 수, (값, BLOCK) × 갈래 수, 기본 BLOCK(없으면 0) |
| Hugo 쪽 | `edge/_index.md` |

## 구성요소

대상, 갈래 수, (값, BLOCK) × 갈래 수, 기본 BLOCK(없으면 0).

- 구성요소는 이 문서의 LOCAL ID(REF)로 가리킨다. REF `0`은 없음이다. 식 자리에는 식 Edge 또는 기호를 둔다([Edge](_index.md#실행-edge)).
- 연산자 코드, 타입 표현, Payload 레이아웃은 아직 정하지 않았다([Edge](_index.md#실행-edge) 열린 문제).

## 코덱 문서

레이아웃을 아직 정하지 않았다. 코덱 문서는 DECLARE(대상 `0F30`)만 둔다. FIELD는 레이아웃이 정해지면 둔다.

## 관련 페이지

- [Edge — 실행 Edge](_index.md#실행-edge), [BLOCK](0x0F0L-block.md), [ASSIGN](0x0F1L-assign.md), [IF](0x0F2L-if.md), [WHILE](0x0F4L-while.md), [FOREACH](0x0F5L-foreach.md), [JUMP](0x0F6L-jump.md), [RETURN](0x0F7L-return.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000F30/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F3000000000
BODY
#1 DECLARE 0x0F30
#2 BIND #1 "SWITCH"
```
