---
title: "TRY (0x0F9L)"
weight: 249
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "TRY는 실행 Edge 오류 묶음의 Codec이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TRY는 실행 Edge 오류 묶음의 Codec이다. 뜻: 오류 처리.

| 항목 | 값 |
|---|---|
| 이름 | `TRY` (규격 문서 BIND `TRY`) |
| TAG ID | `0x0F9L` |
| 코덱 ID | `0x00000F90` |
| 규격 문서 | `0x00000000/codecs/0x00000F90/` (DECLARE 대상 `0F90`) |
| 섹션 | 7 `0111` (Edge 실행), 섹션 안 오프셋 C = 25 |
| Kind | Edge · 계열: 실행, 묶음: 오류 |
| TAG WORD | `0000 1111 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 오류 처리. 본문 BLOCK, 오류 기호, 처리 BLOCK, 마무리 BLOCK(없으면 0) |
| Hugo 쪽 | `edge/_index.md` |

## 구성요소

본문 BLOCK, 오류 기호, 처리 BLOCK, 마무리 BLOCK(없으면 0).

- 구성요소는 이 문서의 LOCAL ID(REF)로 가리킨다. REF `0`은 없음이다. 식 자리에는 식 Edge 또는 기호를 둔다([Edge](_index.md#실행-edge)).
- 연산자 코드, 타입 표현, Payload 레이아웃은 아직 정하지 않았다([Edge](_index.md#실행-edge) 열린 문제).

## 코덱 문서

레이아웃을 아직 정하지 않았다. 코덱 문서는 DECLARE(대상 `0F90`)만 둔다. FIELD는 레이아웃이 정해지면 둔다.

## 관련 페이지

- [Edge — 실행 Edge](_index.md#실행-edge), [RAISE](0x0F8L-raise.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000F90/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F9000000000
BODY
#1 DECLARE 0x0F90
#2 BIND #1 "TRY"
```
