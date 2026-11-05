---
title: "CALL (0x0EBL)"
weight: 235
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "CALL은 실행 Edge 식 묶음의 Codec이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CALL은 실행 Edge 식 묶음의 Codec이다. 뜻: 호출.

| 항목 | 값 |
|---|---|
| 이름 | `CALL` (규격 문서 BIND `CALL`) |
| TAG ID | `0x0EBL` |
| 코덱 ID | `0x00000EB0` |
| 규격 문서 | `0x00000000/codecs/0x00000EB0/` (DECLARE 대상 `0EB0`) |
| 섹션 | 7 `0111` (Edge 실행), 섹션 안 오프셋 C = 11 |
| Kind | Edge · 계열: 실행, 묶음: 식 |
| TAG WORD | `0000 1110 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 호출. 대상 함수, 인자 수, 인자 × 인자 수 |
| Hugo 쪽 | `edge/_index.md` |

## 구성요소

대상 함수, 인자 수, 인자 × 인자 수.

- 구성요소는 이 문서의 LOCAL ID(REF)로 가리킨다. REF `0`은 없음이다. 식 자리에는 식 Edge 또는 기호를 둔다([Edge](_index.md#실행-edge)).
- 연산자 코드, 타입 표현, Payload 레이아웃은 아직 정하지 않았다([Edge](_index.md#실행-edge) 열린 문제).

## 코덱 문서

레이아웃을 아직 정하지 않았다. 코덱 문서는 DECLARE(대상 `0EB0`)만 둔다. FIELD는 레이아웃이 정해지면 둔다.

## 관련 페이지

- [Edge — 실행 Edge](_index.md#실행-edge), [CONST](0x0E8L-const.md), [UNARY](0x0E9L-unary.md), [BINARY](0x0EAL-binary.md), [MEMBER](0x0ECL-member.md), [INDEX](0x0EDL-index.md), [CONSTRUCT](0x0EEL-construct.md), [CONDITIONAL](0x0EFL-conditional.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000EB0/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000EB000000000
BODY
#1 DECLARE 0x0EB0
#2 BIND #1 "CALL"
```
