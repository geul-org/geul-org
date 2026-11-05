---
title: "CONSTRUCT (0x0EEL)"
weight: 238
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "CONSTRUCT는 실행 Edge 식 묶음의 Codec이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CONSTRUCT는 실행 Edge 식 묶음의 Codec이다. 뜻: 복합값 생성(목록, 레코드).

| 항목 | 값 |
|---|---|
| 이름 | `CONSTRUCT` (규격 문서 BIND `CONSTRUCT`) |
| TAG ID | `0x0EEL` |
| 코덱 ID | `0x00000EE0` |
| 규격 문서 | `0x00000000/codecs/0x00000EE0/` (DECLARE 대상 `0EE0`) |
| 섹션 | 7 `0111` (Edge 실행), 섹션 안 오프셋 C = 14 |
| Kind | Edge · 계열: 실행, 묶음: 식 |
| TAG WORD | `0000 1110 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 복합값 생성(목록, 레코드). 타입, 요소 수, 요소 × 요소 수 |
| Hugo 쪽 | `edge/_index.md` |

## 구성요소

타입, 요소 수, 요소 × 요소 수.

- 구성요소는 이 문서의 LOCAL ID(REF)로 가리킨다. REF `0`은 없음이다. 식 자리에는 식 Edge 또는 기호를 둔다([Edge](_index.md#실행-edge)).
- 연산자 코드, 타입 표현, Payload 레이아웃은 아직 정하지 않았다([Edge](_index.md#실행-edge) 열린 문제).

## 코덱 문서

레이아웃을 아직 정하지 않았다. 코덱 문서는 DECLARE(대상 `0EE0`)만 둔다. FIELD는 레이아웃이 정해지면 둔다.

## 관련 페이지

- [Edge — 실행 Edge](_index.md#실행-edge), [CONST](0x0E8L-const.md), [UNARY](0x0E9L-unary.md), [BINARY](0x0EAL-binary.md), [CALL](0x0EBL-call.md), [MEMBER](0x0ECL-member.md), [INDEX](0x0EDL-index.md), [CONDITIONAL](0x0EFL-conditional.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000EE0/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000EE000000000
BODY
#1 DECLARE 0x0EE0
#2 BIND #1 "CONSTRUCT"
```
