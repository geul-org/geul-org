---
title: "TEXT (0x121L)"
weight: 289
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "TEXT는 TOULMIN 문서의 원문·구획 레코드다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TEXT는 TOULMIN 문서의 원문·구획 레코드다. 뜻: 이름·문자열.

| 항목 | 값 |
|---|---|
| 이름 | `TEXT` (규격 문서 BIND `TEXT`) |
| TAG ID | `0x121L` |
| 코덱 ID | `0x00001210` |
| 규격 문서 | `0x00000000/codecs/0x00001210/` (DECLARE 대상 `1210`) |
| 섹션 | 9 `1001` (Edge TOULMIN 형식), 섹션 안 오프셋 C = 1 |
| Kind | Edge · 계열: TOULMIN 형식, 레이아웃: ID, UTF8 Value |
| TAG WORD | `0001 0010 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 이름·문자열 |
| Hugo 쪽 | `edge/toulmin/source.md` |

## 레이아웃

이름·문자열 하나다. NODE의 F_WITH·F_GROUNDS 목록, LINK의 [LABEL](0x134L-label.md)·[IMPORTED-FROM](0x133L-imported-from.md)이 REF로 가리킨다.

```
ID
문자열           UTF8-TEXT Value 레코드
```

- ID는 Edge Id, REF는 이 문서 레코드의 Edge Id다([TOULMIN](_index.md#공통-필드) 공통 필드). Issuer와 코덱 번호 칸 없이 TAG 뒤에 Payload가 온다.

## 코덱 문서

코덱 문서는 DECLARE(대상 `1210`)를 둔다. 필드 선언은 TOULMIN Codec 규격 문서와 함께 정한다([TOULMIN](_index.md#열린-문제)).

## 관련 페이지

- [SOURCE와 구획](_index.md#source와-구획), [TOULMIN](_index.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001210/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000121000000000
BODY
#1 DECLARE 0x1210
#2 BIND #1 "TEXT"
```
