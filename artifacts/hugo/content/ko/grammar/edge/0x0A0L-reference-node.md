---
title: "REFERENCE-NODE (0x0A0L)"
weight: 160
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "REFERENCE-NODE는 Reference 하나를 Object 레코드 하나에 연결해, 그 Reference가 무엇인지 정의하거나 바인딩하는 방향성 서술 Edge다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `REFERENCE-NODE` (규격 문서 BIND `REFERENCE-NODE`) |
| TAG ID | `0x0A0L` |
| 코덱 ID | `0x00000A00` |
| 규격 문서 | `0x00000000/codecs/0x00000A00/` (DECLARE 대상 `0A00`) |
| 섹션 | 5 `0101` (Edge 서술), 섹션 안 오프셋 C = 0 |
| Kind | Edge · 계열: 서술, 묶음: 지시와 이름 |
| TAG WORD | `0000 1010 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | Reference인 Subject가 Object를 지시하는 방향성 바인딩 |
| Hugo 쪽 | `edge/reference-node.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)). Edge의 Edge Id는 FIELD로 선언하지 않는다.

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | 레코드 | 아무 레코드(자리 표지 제외) |  |
| 2 | `object` | #3 | 레코드 | `000F` 섹션 0 전체(와일드카드, Reference), `020F` 섹션 1 전체(와일드카드, Reference), `040F` 섹션 2 전체(와일드카드, Reference), `060F` 섹션 3 전체(와일드카드, Value), `080F` 섹션 4 전체(와일드카드, Value) |  |

REFERENCE-NODE는 Reference 하나를 Object 레코드 하나에 연결해, 그 Reference가 무엇인지 정의하거나 바인딩하는 방향성 서술 Edge다. Codec `0x0A0L`.

Subject가 Object를 지시한다. 이 바인딩은 의미상 동일성을 주장하는 [SAME-NODE](0x0A1L-same-node.md)가 아니며, 두 레코드의 byte가 같다는 뜻도 아니다.

## 레이아웃

```
TAG WORD          0000 1010 0000 LLLL
[Length 확장 TAG]
Edge Id           LOCAL Reference 레코드
Subject           Reference 레코드 1개
Object            Reference 또는 Value 레코드 1개
```

## 해석과 유효성

- Subject는 정확히 하나의 완전한 [Reference](../reference/_index.md) 레코드여야 한다. Subject 자체의 Length로 경계를 찾으며, Reference가 아니거나 불완전하면 invalid다.
- Object는 정확히 하나의 완전한 Reference 또는 Value 레코드여야 한다. Object 자체의 Length로 경계를 찾으며, Edge·Meta이거나 불완전하면 invalid다.
- Object가 Reference이면, REFERENCE-NODE 바인딩으로 따라가는 Reference 사슬은 순환하지 않아야 하며 LOCAL은 끝내 해소되어야 한다. 해소 순환과 dangling LOCAL은 invalid다.
- 같은 문서에서 LOCAL ID 하나가 서로 충돌하는 Object로 바인딩되면 invalid다. LOCAL의 범위, ID, 최소 폭과 병합 규칙은 [LOCAL](../reference/0x005L-local.md)을 따른다.
- 모든 Reference가 REFERENCE-NODE로 바인딩되어야 하는 것은 아니다.
- 대표 용례는 `LOCAL → UTF8-LANGUAGE-TEXT`다. [LABEL](0x0A4L-label.md)의 Object에 LOCAL을 두었을 때, 같은 문서의 이 바인딩으로 텍스트를 해소한다.

Subject가 Object를 지시하는 방향을 거꾸로 해석해서는 안 된다. SAME과 DIFFERENT의 의미와 세부 규칙은 각 형식이 따로 정한다.

## 길이

```
전체 = 1 + N_len + N_id + N_subject + N_object WORD
```

`N_len`은 Length 확장 TAG WORD 수, `N_id`는 Edge Id LOCAL 레코드의 WORD 수, `N_subject`·`N_object`는 각 레코드의 전체 WORD 수다. Subject와 Object를 모두 읽은 커서는 Edge 끝과 정확히 맞아야 한다.

## 예시 (비규범)

Edge Id `0008`, Subject는 LOCAL 1, Object는 `Donald Trump`(en)의 [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)다.

- Edge Id는 `0051 0008`로 2 WORD다.
- Subject는 `0051 0001`로 2 WORD다.
- Object는 언어 `0761 656E`(BCP47 `en`) + 텍스트 12 byte(짝수)라 `UTF8-LANGUAGE-TEXT-EVEN`(`0x078L`), 전체 9 WORD다. TAG는 `0788`이다.
- Edge는 TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, `LLLL=1101`이다. TAG는 `0A0D`다.

```
0A0D 0051 0008 0051 0001 0788 0761 656E 446F 6E61 6C64 2054 7275 6D70
```

## 관련 페이지

- [Edge](_index.md), [SAME-NODE](0x0A1L-same-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md), [LABEL](0x0A4L-label.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md), [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000A00/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A0000000000
BODY
#1 DECLARE 0x0A00
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "REFERENCE-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x000F
#9 CODEC #3 0x020F
#10 CODEC #3 0x040F
#8 CODEC #3 0x060F
#11 CODEC #3 0x080F
```
