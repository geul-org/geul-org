---
title: "FIELD (0x128L)"
weight: 296
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "FIELD는 TOULMIN 그래프의 노드를 쓰는 NODE Codec이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FIELD는 TOULMIN 그래프의 노드를 쓰는 NODE Codec이다. 뜻: `is required`. 필수 필드.

| 항목 | 값 |
|---|---|
| 이름 | `FIELD` (규격 문서 BIND `FIELD`) |
| TAG ID | `0x128L` |
| 코덱 ID | `0x00001280` |
| 규격 문서 | `0x00000000/codecs/0x00001280/` (DECLARE 대상 `1280`) |
| 섹션 | 9 `1001` (Edge TOULMIN 형식), 섹션 안 오프셋 C = 8 |
| Kind | Edge · 계열: TOULMIN 형식, 레이아웃: NODE |
| TAG WORD | `0001 0010 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | `is required`. 필수 필드 |
| Hugo 쪽 | `edge/toulmin/node.md` |

## 레이아웃

레이아웃은 [NODE](_index.md#node)다. 헤더 1 WORD가 role·level·Claim 형태와 조건부 필드를 정한다.

| 항목 | 값 |
|---|---|
| TANGEUL | `x is required [as Type]` |
| 노드 | 필수 필드 |

- role은 0이어야 한다.
- 공통 필드(ID, REF, SPAN)와 수치 규칙은 [TOULMIN](_index.md#공통-필드)을 따른다.

## 코덱 문서

코덱 문서는 DECLARE(대상 `1280`)를 둔다. NODE 레이아웃의 조건부 필드와 SOURCE가 정하는 SPAN 폭은 FIELD로 선언할 수 없어, 필드 선언은 열린 문제다([TOULMIN](_index.md#열린-문제)).

## 관련 페이지

- [NODE](_index.md#node), [TOULMIN](_index.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001280/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000128000000000
BODY
#1 DECLARE 0x1280
#2 BIND #1 "FIELD"
```
