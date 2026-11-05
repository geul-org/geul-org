---
title: "SOURCE (0x120L)"
weight: 288
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SOURCE는 TOULMIN 문서의 원문·구획 레코드다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SOURCE는 TOULMIN 문서의 원문·구획 레코드다. 뜻: 저작 원문.

| 항목 | 값 |
|---|---|
| 이름 | `SOURCE` (규격 문서 BIND `SOURCE`) |
| TAG ID | `0x120L` |
| 코덱 ID | `0x00001200` |
| 규격 문서 | `0x00000000/codecs/0x00001200/` (DECLARE 대상 `1200`) |
| 섹션 | 9 `1001` (Edge TOULMIN 형식), 섹션 안 오프셋 C = 0 |
| Kind | Edge · 계열: TOULMIN 형식, 레이아웃: ID, SPAN 폭 WORD, UTF8 Value |
| TAG WORD | `0001 0010 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 저작 원문 |
| Hugo 쪽 | `edge/toulmin/source.md` |

## 레이아웃

저작 원문 전체다. 모든 SPAN은 이 원문 안의 바이트 범위다.

```
ID
SPAN 폭 WORD     상위 2비트 = 폭(00=1, 01=2, 10=4, 11=8 WORD), 나머지 14비트 = 0
원문             UTF8-TEXT Value 레코드
```

- SOURCE는 BODY의 첫 레코드다. 문서에 하나다.
- SPAN은 시작 바이트와 바이트 수, 두 필드다. 각 필드는 SPAN 폭 WORD가 정한 폭(1/2/4/8 WORD)의 unsigned 정수다.
- 근거 Edge [SOURCE](../edge/0x0C0L-source.md)(`0x0C0L`)와 다른 Codec이다.

- ID는 Edge Id, REF는 이 문서 레코드의 Edge Id다([TOULMIN](_index.md#공통-필드) 공통 필드). Issuer와 코덱 번호 칸 없이 TAG 뒤에 Payload가 온다.

## 코덱 문서

코덱 문서는 DECLARE(대상 `1200`)를 둔다. 필드 선언은 TOULMIN Codec 규격 문서와 함께 정한다([TOULMIN](_index.md#열린-문제)).

## 관련 페이지

- [SOURCE와 구획](_index.md#source와-구획), [TOULMIN](_index.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001200/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000120000000000
BODY
#1 DECLARE 0x1200
#2 BIND #1 "SOURCE"
```
