---
title: "FUNCTION-DECLARE (0x0E1L)"
weight: 225
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "FUNCTION-DECLARE는 실행 Edge 선언 묶음의 Codec이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FUNCTION-DECLARE는 실행 Edge 선언 묶음의 Codec이다. 뜻: 함수 선언.

| 항목 | 값 |
|---|---|
| 이름 | `FUNCTION-DECLARE` (규격 문서 BIND `FUNCTION-DECLARE`) |
| TAG ID | `0x0E1L` |
| 코덱 ID | `0x00000E10` |
| 규격 문서 | `0x00000000/codecs/0x00000E10/` (DECLARE 대상 `0E10`) |
| 섹션 | 7 `0111` (Edge 실행), 섹션 안 오프셋 C = 1 |
| Kind | Edge · 계열: 실행, 묶음: 선언 |
| TAG WORD | `0000 1110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 함수 선언. 기호, 매개변수 기호 목록, 반환 타입, 본문(BLOCK) |
| Hugo 쪽 | `edge/_index.md` |

## 구성요소

기호, 매개변수 기호 목록, 반환 타입, 본문(BLOCK).

- 구성요소는 이 문서의 LOCAL ID(REF)로 가리킨다. REF `0`은 없음이다. 식 자리에는 식 Edge 또는 기호를 둔다([Edge](_index.md#실행-edge)).
- 연산자 코드, 타입 표현, Payload 레이아웃은 아직 정하지 않았다([Edge](_index.md#실행-edge) 열린 문제).

## 코덱 문서

레이아웃을 아직 정하지 않았다. 코덱 문서는 DECLARE(대상 `0E10`)만 둔다. FIELD는 레이아웃이 정해지면 둔다.

## 관련 페이지

- [Edge — 실행 Edge](_index.md#실행-edge), [TYPE-DECLARE](0x0E2L-type-declare.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000E10/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000E1000000000
BODY
#1 DECLARE 0x0E10
#2 BIND #1 "FUNCTION-DECLARE"
```
