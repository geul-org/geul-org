---
title: "SUPERSEDE-CHAIN (0x10AL)"
weight: 266
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SUPERSEDE-CHAIN은 TOULMIN Edge Codec이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SUPERSEDE-CHAIN은 TOULMIN Edge Codec이다. 뜻: 우선순위 사슬 `A > B > C`. 쌍별 SUPERSEDES의 축약.

| 항목 | 값 |
|---|---|
| 이름 | `SUPERSEDE-CHAIN` (규격 문서 BIND `SUPERSEDE-CHAIN`) |
| TAG ID | `0x10AL` |
| 코덱 ID | `0x000010A0` |
| 규격 문서 | `0x00000000/codecs/0x000010A0/` (DECLARE 대상 `10A0`) |
| 섹션 | 8 `1000` (Edge TOULMIN), 섹션 안 오프셋 C = 10 |
| Kind | Edge · 계열: TOULMIN, 묶음: 관계 |
| TAG WORD | `0001 0000 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 우선순위 사슬 `A > B > C`. 쌍별 SUPERSEDES의 축약. 레이아웃 미정 |
| Hugo 쪽 | `edge/toulmin/_index.md` |

## 레이아웃

코드만 배정했고 레이아웃은 아직 없다([TOULMIN](_index.md#열린-문제)).

- 지금은 [SUPERSEDES](0x109L-supersedes.md)를 쌍마다 하나씩 쓴다. 그것으로 사슬이 충분한지는 열린 문제다.

## 코덱 문서

레이아웃이 정해지지 않았다. 코덱 문서는 DECLARE(대상 `10A0`)만 둔다. FIELD는 레이아웃이 정해지면 둔다.

## 관련 페이지

- [TOULMIN](_index.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x000010A0/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000010A000000000
BODY
#1 DECLARE 0x10A0
#2 BIND #1 "SUPERSEDE-CHAIN"
```
