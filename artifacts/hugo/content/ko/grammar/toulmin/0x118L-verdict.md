---
title: "VERDICT (0x118L)"
weight: 280
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "VERDICT는 TOULMIN Edge Codec이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERDICT는 TOULMIN Edge Codec이다. 뜻: 노드·레코드의 판정 결과. 결과(Pass, Review, Fail), 판정값, Activated, Excluded, Level.

| 항목 | 값 |
|---|---|
| 이름 | `VERDICT` (규격 문서 BIND `VERDICT`) |
| TAG ID | `0x118L` |
| 코덱 ID | `0x00001180` |
| 규격 문서 | `0x00000000/codecs/0x00001180/` (DECLARE 대상 `1180`) |
| 섹션 | 8 `1000` (Edge TOULMIN), 섹션 안 오프셋 C = 24 |
| Kind | Edge · 계열: TOULMIN, 묶음: 결과 |
| TAG WORD | `0001 0001 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 노드·레코드의 판정 결과. 결과(Pass, Review, Fail), 판정값, Activated, Excluded, Level. 레이아웃 미정 |
| Hugo 쪽 | `edge/toulmin/_index.md` |

## 레이아웃

코드만 배정했고 레이아웃은 아직 없다([TOULMIN](_index.md#열린-문제)).

- 문서 전체의 판정은 Meta [VERDICT](../meta/0x1E9L-verdict.md)(`0x1E9L`)가 맡는다. 둘은 Kind가 다른 별개의 Codec이다.
- 판정 결과는 판정 대상과 다른 문서에 둔다([TOULMIN](_index.md#판정-결과)).

## 코덱 문서

레이아웃이 정해지지 않았다. 코덱 문서는 DECLARE(대상 `1180`)만 둔다. FIELD는 레이아웃이 정해지면 둔다.

## 관련 페이지

- [TOULMIN](_index.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001180/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000118000000000
BODY
#1 DECLARE 0x1180
#2 BIND #1 "VERDICT"
```
