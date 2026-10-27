---
title: "SOURCE와 구획"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "TOULMIN 문서의 저작 원문(SOURCE), 문자열(TEXT), 섹션·사안 구획(SECTION, CASE-BEGIN, CASE-END), 서술 문단(PROSE)을 쓰는 GEUL ISSUER 형식 0xC000~0xC005다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TOULMIN 문서의 원문과 구획을 쓰는 레코드다. 모두 `ISSUER-1WORD`(`0x7C`), Issuer `0x0000`(GEUL) 아래 형식 번호를 쓰는 Edge다([TOULMIN](/ko/grammar/edge/toulmin/#issuer-형식)).

## 형식

| 형식 번호 | 이름 | 레이아웃 |
|---|---|---|
| `0xC000` | SOURCE | ID, SPAN 폭 WORD, UTF8 Value |
| `0xC001` | TEXT | ID, UTF8 Value |
| `0xC002` | SECTION | ID, 섹션 코드 1 WORD |
| `0xC003` | CASE-BEGIN | ID, REF(사안) |
| `0xC004` | CASE-END | ID, REF(사안) |
| `0xC005` | PROSE | ID, SPAN |

- ID는 Edge Id, REF는 이 문서 레코드의 Edge Id다([TOULMIN](/ko/grammar/edge/toulmin/#공통-필드) 공통 필드).
- UTF8 Value는 [UTF8-TEXT](/ko/grammar/value/text/utf8-text/) Value 레코드다. 바이트를 그대로 담는다.

## SOURCE

저작 원문 전체다. 모든 SPAN은 이 원문 안의 바이트 범위다.

```
ID
SPAN 폭 WORD     상위 2비트 = 폭(00=1, 01=2, 10=4, 11=8 WORD), 나머지 14비트 = 0
원문             UTF8-TEXT Value 레코드
```

- SOURCE는 BODY의 첫 레코드다. 문서에 하나다.
- SPAN은 시작 바이트와 바이트 수, 두 필드다. 각 필드는 SPAN 폭 WORD가 정한 폭(1/2/4/8 WORD)의 unsigned 정수다.

## TEXT

이름·문자열 하나다. NODE의 F_WITH·F_GROUNDS 목록, LINK의 LABEL·IMPORTED-FROM이 REF로 가리킨다.

## SECTION

섹션의 시작이다. 섹션 코드는 1 WORD다.

| 코드 | 섹션 | TANGEUL |
|---|---|---|
| 1 | Subject | `this document is x` |
| 2 | See | `see a from path` |
| 3 | Definitions | `means`, `has` |
| 4 | Rules | 조건식 규칙 |
| 5 | Cases | `in case of x` |
| 6 | Provides | `provides x` |
| 7 | Internal | `on`, `every` |

- `0`은 쓰지 않는다. 섹션은 이 코드 순서로 선언된다.
- 섹션 제목은 SECTION 바로 다음의 PROSE다.

## CASE-BEGIN, CASE-END

- 사안의 범위는 같은 사안(CASE-DECLARE NODE)을 가리키는 CASE-BEGIN과 CASE-END 사이다.

## PROSE

규칙이 아닌 서술 문단이다. 원문의 범위(SPAN)만 가리킨다.

## 관련 페이지

- [TOULMIN](/ko/grammar/edge/toulmin/), [NODE](/ko/grammar/edge/toulmin/node/), [LINK](/ko/grammar/edge/toulmin/link/)
