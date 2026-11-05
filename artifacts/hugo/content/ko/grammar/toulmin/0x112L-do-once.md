---
title: "DO-ONCE (0x112L)"
weight: 274
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "DO-ONCE는 TOULMIN 그래프의 관계를 쓰는 LINK Codec이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DO-ONCE는 TOULMIN 그래프의 관계를 쓰는 LINK Codec이다. 뜻: 재시도해도 한 번만 수행하는 동작.

| 항목 | 값 |
|---|---|
| 이름 | `DO-ONCE` (규격 문서 BIND `DO-ONCE`) |
| TAG ID | `0x112L` |
| 코덱 ID | `0x00001120` |
| 규격 문서 | `0x00000000/codecs/0x00001120/` (DECLARE 대상 `1120`) |
| 섹션 | 8 `1000` (Edge TOULMIN), 섹션 안 오프셋 C = 18 |
| Kind | Edge · 계열: TOULMIN, 묶음: 실행, 레이아웃: LINK |
| TAG WORD | `0001 0001 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 재시도해도 한 번만 수행하는 동작 |
| Hugo 쪽 | `edge/toulmin/link.md` |

## 레이아웃

레이아웃은 [LINK](_index.md#link)다(ID, src, dst, flags, 조건부 필드, SPAN).

| 항목 | 값 |
|---|---|
| TANGEUL | `do fn once when n` |
| src → dst | 규칙 → FuncRef |

- dst는 FuncRef다. `do … once`는 이 Codec이 나타낸다. flags에 F_ONCE를 쓰지 않는다(켜져 있으면 거부한다).
- F_FORCE는 쓰지 않는다(켜져 있으면 거부한다).
- 공통 필드(ID, REF, SPAN)와 수치 규칙은 [TOULMIN](_index.md#공통-필드)을 따른다.

## 코덱 문서

코덱 문서는 DECLARE(대상 `1120`)를 둔다. LINK 레이아웃의 조건부 필드와 SOURCE가 정하는 SPAN 폭은 FIELD로 선언할 수 없어, 필드 선언은 열린 문제다([TOULMIN](_index.md#열린-문제)).

## 관련 페이지

- [LINK](_index.md#link), [TOULMIN](_index.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001120/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000112000000000
BODY
#1 DECLARE 0x1120
#2 BIND #1 "DO-ONCE"
```
