---
title: "CHECKING (0x114L)"
weight: 276
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CHECKING은 TOULMIN 그래프의 관계를 쓰는 LINK Codec이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CHECKING은 TOULMIN 그래프의 관계를 쓰는 LINK Codec이다. 뜻: 부작용 없이 판정만 하는 연결.

| 항목 | 값 |
|---|---|
| 이름 | `CHECKING` (규격 문서 BIND `CHECKING`) |
| TAG ID | `0x114L` |
| 코덱 ID | `0x00001140` |
| 규격 문서 | `0x00000000/codecs/0x00001140/` (DECLARE 대상 `1140`) |
| 섹션 | 8 `1000` (Edge TOULMIN), 섹션 안 오프셋 C = 20 |
| Kind | Edge · 계열: TOULMIN, 묶음: 실행, 레이아웃: LINK |
| TAG WORD | `0001 0001 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 부작용 없이 판정만 하는 연결 |
| Hugo 쪽 | `edge/toulmin/link.md` |

## 레이아웃

레이아웃은 [LINK](_index.md#link)다(ID, src, dst, flags, 조건부 필드, SPAN).

| 항목 | 값 |
|---|---|
| TANGEUL | `checking c` |
| src → dst | 규칙 → 사안. 부작용 없는 판정 |

- dst는 노드의 REF다.
- F_FORCE는 쓰지 않는다(켜져 있으면 거부한다).
- 공통 필드(ID, REF, SPAN)와 수치 규칙은 [TOULMIN](_index.md#공통-필드)을 따른다.

## 코덱 문서

코덱 문서는 DECLARE(대상 `1140`)를 둔다. LINK 레이아웃의 조건부 필드와 SOURCE가 정하는 SPAN 폭은 FIELD로 선언할 수 없어, 필드 선언은 열린 문제다([TOULMIN](_index.md#열린-문제)).

## 관련 페이지

- [LINK](_index.md#link), [TOULMIN](_index.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001140/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000114000000000
BODY
#1 DECLARE 0x1140
#2 BIND #1 "CHECKING"
```
