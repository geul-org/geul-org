---
title: "ALIAS (0x0A5L)"
weight: 165
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ALIAS는 Subject 대상의 다른 이름(별칭) 하나를 Object로 연결하는 서술 Edge다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `ALIAS` (규격 문서 BIND `ALIAS`) |
| TAG ID | `0x0A5L` |
| 코덱 ID | `0x00000A50` |
| 규격 문서 | `0x00000000/codecs/0x00000A50/` (DECLARE 대상 `0A50`) |
| 섹션 | 5 `0101` (Edge 서술), 섹션 안 오프셋 C = 5 |
| Kind | Edge · 계열: 서술, 묶음: 지시와 이름 |
| TAG WORD | `0000 1010 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | Subject의 다른 이름(별칭) 연결. 레이아웃은 LABEL과 같다 |
| Hugo 쪽 | `edge/alias.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)). Edge의 Edge Id는 FIELD로 선언하지 않는다.

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | 레코드 | 아무 레코드(자리 표지 제외) |  |
| 2 | `object` | #3 | 레코드 | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

ALIAS는 Subject 대상의 다른 이름(별칭) 하나를 Object로 연결하는 서술 Edge다. Codec `0x0A5L`.

[LABEL](0x0A4L-label.md)은 그 언어의 대표 이름(언어마다 많아야 하나)이고, ALIAS는 같은 대상의 다른 이름이다(언어마다 여럿, 위키데이터 "also known as"). 주로 검색에 쓴다. 레이아웃과 유효성은 LABEL과 같다.

## 레이아웃

```
TAG WORD          0000 1010 0101 LLLL
[Length 확장 TAG]
Edge Id           LOCAL Reference 레코드
Subject           Reference 레코드 1개
Object            UTF8-LANGUAGE-TEXT Value 또는 LOCAL Reference 레코드 1개
```

## 해석과 유효성

- Subject, Object의 규칙은 [LABEL](0x0A4L-label.md)과 같다(Object는 [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) 또는 그것으로 해소되는 LOCAL).
- 같은 Subject·언어에 ALIAS를 여럿 둘 수 있다. 순서는 문서 안 순서다.
- 같은 Subject·언어의 LABEL과 같은 텍스트를 ALIAS로 두지 않는다(대표 이름은 LABEL 하나로 충분하다). 이 규칙은 권고다.
- geul.org 규격 문서는 Object를 [CODEC](0x0BEL-codec.md)으로 제한한다(`0780`·`0790`·`0050`, LABEL과 같다).

## 예시 (비규범)

Edge Id `0003`, Subject Q42(`0141 002A`), Object `DNA`(en): 언어 `0761 656E`(BCP47 `en`) + 텍스트 3 byte(홀수) → `UTF8-LANGUAGE-TEXT-ODD`(`0x079L`), `0794 0761 656E 444E 4100`.

- TAG 1 + Edge Id 2 + Subject 2 + Object 5 = 10 WORD, `LLLL=1001`. TAG는 `0A59`다.

```
0A59 0051 0003 0141 002A 0794 0761 656E 444E 4100
```

## 관련 페이지

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [DESCRIPTION](0x0A6L-description.md), [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000A50/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A5000000000
BODY
#1 DECLARE 0x0A50
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "ALIAS"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
