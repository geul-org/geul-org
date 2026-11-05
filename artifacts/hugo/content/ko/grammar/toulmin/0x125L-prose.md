---
title: "PROSE (0x125L)"
weight: 293
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "PROSE는 TOULMIN 문서의 원문·구획 레코드다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PROSE는 TOULMIN 문서의 원문·구획 레코드다. 뜻: 서술 문단.

| 항목 | 값 |
|---|---|
| 이름 | `PROSE` (규격 문서 BIND `PROSE`) |
| TAG ID | `0x125L` |
| 코덱 ID | `0x00001250` |
| 규격 문서 | `0x00000000/codecs/0x00001250/` (DECLARE 대상 `1250`) |
| 섹션 | 9 `1001` (Edge TOULMIN 형식), 섹션 안 오프셋 C = 5 |
| Kind | Edge · 계열: TOULMIN 형식, 레이아웃: ID, SPAN |
| TAG WORD | `0001 0010 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 서술 문단 |
| Hugo 쪽 | `edge/toulmin/source.md` |

## 레이아웃

규칙이 아닌 서술 문단이다. 원문의 범위(SPAN)만 가리킨다.

```
ID
SPAN             SOURCE가 정한 폭 × 2 (시작 바이트, 바이트 수)
```

- ID는 Edge Id, REF는 이 문서 레코드의 Edge Id다([TOULMIN](_index.md#공통-필드) 공통 필드). Issuer와 코덱 번호 칸 없이 TAG 뒤에 Payload가 온다.

## 코덱 문서

코덱 문서는 DECLARE(대상 `1250`)를 둔다. SPAN 폭을 SOURCE가 정해 FIELD로 선언할 수 없어, 필드 선언은 열린 문제다([TOULMIN](_index.md#열린-문제)).

## 관련 페이지

- [SOURCE와 구획](_index.md#source와-구획), [TOULMIN](_index.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001250/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000125000000000
BODY
#1 DECLARE 0x1250
#2 BIND #1 "PROSE"
```
