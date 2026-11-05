---
title: "CASE-BEGIN (0x123L)"
weight: 291
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "CASE-BEGIN은 TOULMIN 문서의 원문·구획 레코드다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CASE-BEGIN은 TOULMIN 문서의 원문·구획 레코드다. 뜻: 사안 범위 시작.

| 항목 | 값 |
|---|---|
| 이름 | `CASE-BEGIN` (규격 문서 BIND `CASE-BEGIN`) |
| TAG ID | `0x123L` |
| 코덱 ID | `0x00001230` |
| 규격 문서 | `0x00000000/codecs/0x00001230/` (DECLARE 대상 `1230`) |
| 섹션 | 9 `1001` (Edge TOULMIN 형식), 섹션 안 오프셋 C = 3 |
| Kind | Edge · 계열: TOULMIN 형식, 레이아웃: ID, REF(사안) |
| TAG WORD | `0001 0010 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 사안 범위 시작 |
| Hugo 쪽 | `edge/toulmin/source.md` |

## 레이아웃

사안 범위의 시작이다.

```
ID
사안             REF(CASE-DECLARE NODE)
```

- 사안의 범위는 같은 사안([CASE-DECLARE](0x100L-case-declare.md) NODE)을 가리키는 CASE-BEGIN과 [CASE-END](0x124L-case-end.md) 사이다.

- ID는 Edge Id, REF는 이 문서 레코드의 Edge Id다([TOULMIN](_index.md#공통-필드) 공통 필드). Issuer와 코덱 번호 칸 없이 TAG 뒤에 Payload가 온다.

## 코덱 문서

코덱 문서는 DECLARE(대상 `1230`)를 둔다. 필드 선언은 TOULMIN Codec 규격 문서와 함께 정한다([TOULMIN](_index.md#열린-문제)).

## 관련 페이지

- [SOURCE와 구획](_index.md#source와-구획), [TOULMIN](_index.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001230/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000123000000000
BODY
#1 DECLARE 0x1230
#2 BIND #1 "CASE-BEGIN"
```
