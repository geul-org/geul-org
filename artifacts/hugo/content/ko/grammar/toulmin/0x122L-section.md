---
title: "SECTION (0x122L)"
weight: 290
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SECTION은 TOULMIN 문서의 원문·구획 레코드다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SECTION은 TOULMIN 문서의 원문·구획 레코드다. 뜻: 섹션 시작.

| 항목 | 값 |
|---|---|
| 이름 | `SECTION` (규격 문서 BIND `SECTION`) |
| TAG ID | `0x122L` |
| 코덱 ID | `0x00001220` |
| 규격 문서 | `0x00000000/codecs/0x00001220/` (DECLARE 대상 `1220`) |
| 섹션 | 9 `1001` (Edge TOULMIN 형식), 섹션 안 오프셋 C = 2 |
| Kind | Edge · 계열: TOULMIN 형식, 레이아웃: ID, 섹션 코드 1 WORD |
| TAG WORD | `0001 0010 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 섹션 시작 |
| Hugo 쪽 | `edge/toulmin/source.md` |

## 레이아웃

섹션의 시작이다. 섹션 코드는 1 WORD다.

```
ID
섹션 코드        1 WORD
```

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
- 섹션 제목은 SECTION 바로 다음의 [PROSE](0x125L-prose.md)다.

- ID는 Edge Id, REF는 이 문서 레코드의 Edge Id다([TOULMIN](_index.md#공통-필드) 공통 필드). Issuer와 코덱 번호 칸 없이 TAG 뒤에 Payload가 온다.

## 코덱 문서

코덱 문서는 DECLARE(대상 `1220`)를 둔다. 필드 선언은 TOULMIN Codec 규격 문서와 함께 정한다([TOULMIN](_index.md#열린-문제)).

## 관련 페이지

- [SOURCE와 구획](_index.md#source와-구획), [TOULMIN](_index.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001220/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000122000000000
BODY
#1 DECLARE 0x1220
#2 BIND #1 "SECTION"
```
