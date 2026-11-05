---
title: "EVIDENCE (0x119L)"
weight: 281
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EVIDENCE는 TOULMIN Edge Codec이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EVIDENCE는 TOULMIN Edge Codec이다. 뜻: 판정의 증거. 위치, 기대값, 실제값(Fact).

| 항목 | 값 |
|---|---|
| 이름 | `EVIDENCE` (규격 문서 BIND `EVIDENCE`) |
| TAG ID | `0x119L` |
| 코덱 ID | `0x00001190` |
| 규격 문서 | `0x00000000/codecs/0x00001190/` (DECLARE 대상 `1190`) |
| 섹션 | 8 `1000` (Edge TOULMIN), 섹션 안 오프셋 C = 25 |
| Kind | Edge · 계열: TOULMIN, 묶음: 결과 |
| TAG WORD | `0001 0001 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 판정의 증거. 위치, 기대값, 실제값(Fact). 레이아웃 미정 |
| Hugo 쪽 | `edge/toulmin/_index.md` |

## 레이아웃

코드만 배정했고 레이아웃은 아직 없다([TOULMIN](_index.md#열린-문제)).

- 판정 결과는 판정 대상과 다른 문서에 둔다([TOULMIN](_index.md#판정-결과)).

## 코덱 문서

레이아웃이 정해지지 않았다. 코덱 문서는 DECLARE(대상 `1190`)만 둔다. FIELD는 레이아웃이 정해지면 둔다.

## 관련 페이지

- [TOULMIN](_index.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001190/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000119000000000
BODY
#1 DECLARE 0x1190
#2 BIND #1 "EVIDENCE"
```
