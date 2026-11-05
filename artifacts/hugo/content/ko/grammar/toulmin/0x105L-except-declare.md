---
title: "EXCEPT-DECLARE (0x105L)"
weight: 261
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EXCEPT-DECLARE는 TOULMIN 그래프의 노드를 쓰는 NODE Codec이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXCEPT-DECLARE는 TOULMIN 그래프의 노드를 쓰는 NODE Codec이다. 뜻: 예외 선언. 자기 결론 없이 공격한다. 기본 Level은 Review.

| 항목 | 값 |
|---|---|
| 이름 | `EXCEPT-DECLARE` (규격 문서 BIND `EXCEPT-DECLARE`) |
| TAG ID | `0x105L` |
| 코덱 ID | `0x00001050` |
| 규격 문서 | `0x00000000/codecs/0x00001050/` (DECLARE 대상 `1050`) |
| 섹션 | 8 `1000` (Edge TOULMIN), 섹션 안 오프셋 C = 5 |
| Kind | Edge · 계열: TOULMIN, 묶음: 선언, 레이아웃: NODE |
| TAG WORD | `0001 0000 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 예외 선언. 자기 결론 없이 공격한다. 기본 Level은 Review |
| Hugo 쪽 | `edge/toulmin/node.md` |

## 레이아웃

레이아웃은 [NODE](_index.md#node)다. 헤더 1 WORD가 role·level·Claim 형태와 조건부 필드를 정한다.

| 항목 | 값 |
|---|---|
| TANGEUL | except rule |
| 노드 | 예외(Defeater) |

- role은 2(except)이어야 한다. level이 0(Unset)이면 엔진 기본값 Review를 쓴다.
- 공통 필드(ID, REF, SPAN)와 수치 규칙은 [TOULMIN](_index.md#공통-필드)을 따른다.

## 코덱 문서

코덱 문서는 DECLARE(대상 `1050`)를 둔다. NODE 레이아웃의 조건부 필드와 SOURCE가 정하는 SPAN 폭은 FIELD로 선언할 수 없어, 필드 선언은 열린 문제다([TOULMIN](_index.md#열린-문제)).

## 관련 페이지

- [NODE](_index.md#node), [TOULMIN](_index.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001050/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000105000000000
BODY
#1 DECLARE 0x1050
#2 BIND #1 "EXCEPT-DECLARE"
```
