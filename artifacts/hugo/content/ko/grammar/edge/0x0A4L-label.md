---
title: "LABEL (0x0A4L)"
weight: 164
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "LABEL은 Subject 대상의 특정 언어 이름(label) 하나를 Object로 연결하는 서술 Edge다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `LABEL` (규격 문서 BIND `LABEL`) |
| TAG ID | `0x0A4L` |
| 코덱 ID | `0x00000A40` |
| 규격 문서 | `0x00000000/codecs/0x00000A40/` (DECLARE 대상 `0A40`) |
| 섹션 | 5 `0101` (Edge 서술), 섹션 안 오프셋 C = 4 |
| Kind | Edge · 계열: 서술, 묶음: 지시와 이름 |
| TAG WORD | `0000 1010 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | Subject의 언어 이름(label) 연결. Object는 UTF8-LANGUAGE-TEXT |
| Hugo 쪽 | `edge/label.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)). Edge의 Edge Id는 FIELD로 선언하지 않는다.

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | 레코드 | 아무 레코드(자리 표지 제외) |  |
| 2 | `object` | #3 | 레코드 | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

LABEL은 Subject 대상의 특정 언어 이름(label) 하나를 Object로 연결하는 서술 Edge다. Codec `0x0A4L`. 일반 어휘학의 lemma를 나타내는 Edge가 아니다.

이름과 그 언어는 Object 하나, [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)에 담긴다. 날값 필드가 없다.

## 레이아웃

```
TAG WORD          0000 1010 0100 LLLL
[Length 확장 TAG]
Edge Id           LOCAL Reference 레코드
Subject           Reference 레코드 1개
Object            UTF8-LANGUAGE-TEXT Value 또는 LOCAL Reference 레코드 1개
```

## 해석과 유효성

- Subject는 정확히 하나의 완전한 Reference 레코드다. Subject 자체의 Length로 경계를 찾으며, Reference가 아니거나 불완전하면 invalid다.
- Object는 정확히 하나의 완전한 [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)(`0x078L`·`0x079L`) 레코드다. 언어와 텍스트의 규칙(두 언어 형식 모두 허용, 같은 언어 비교)은 그 형식을 따른다.
- Object에는 LOCAL Reference도 올 수 있다. 이때는 같은 문서의 [REFERENCE-NODE](0x0A0L-reference-node.md) 바인딩으로 UTF8-LANGUAGE-TEXT로 해소되어야 한다. 해소되지 않거나 다른 종류의 대상으로 해소되면 invalid다.
- geul.org 규격 문서는 이 제한을 [CODEC](0x0BEL-codec.md)으로 적는다(Object = `0780`·`0790`·`0050`). LOCAL의 해소 대상은 CODEC으로 나타내지 않는다.
- Object가 위 두 형식 중 하나가 아니거나 레코드가 불완전하면 invalid다. 언어가 없는 텍스트(UTF8-TEXT)는 LABEL이 될 수 없다. 언어 없는 기계용 이름은 [BIND](0x0A3L-bind.md)로 쓴다. 여러 언어에 공통인 이름은 언어 `mul`로 쓴다.
- 같은 Subject·언어의 LABEL은 많아야 하나다. 다른 이름은 [ALIAS](0x0A5L-alias.md)로 쓴다.

## 길이

```
전체 = 1 + N_len + N_id + N_subject + N_object WORD
```

- Object의 언어 레코드와 텍스트 바이트 수는 Edge가 아니라 Object 레코드가 맡는다. 마지막 레코드를 모두 읽은 커서는 Edge 끝과 정확히 맞아야 한다.

## 예시 (비규범)

`en`의 언어 코드 `0784`는 GEUL Language Registry v2(규격 문서 `0x00000000/codecs/0x000007A0` 버전 2)의 번호다.

### LANGUAGE-SHORT-CODE

Edge Id `0007`, Subject Q22686(`0141 589E`), Object `Donald Trump`(en).

- Object는 언어 `07A1 0784`(SHORT-CODE 2 WORD) + 텍스트 12 byte(짝수, 6 WORD)라 `UTF8-LANGUAGE-TEXT-EVEN`(`0x078L`), 전체 9 WORD `0788 07A1 0784 446F 6E61 6C64 2054 7275 6D70`이다.
- Edge는 TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, `LLLL=1101`이다. TAG는 `0A4D`다.

```
0A4D 0051 0007 0141 589E 0788 07A1 0784 446F 6E61 6C64 2054 7275 6D70
```

### LANGUAGE-BCP47-CODE

Edge Id `0008`, Subject Q155(`0141 009B`), Object `Brasil`(pt-BR).

- Object는 언어 `0773 7074 2D42 5200`(BCP47 `pt-BR`, 4 WORD) + 텍스트 6 byte(짝수, 3 WORD)라 전체 8 WORD `0787 0773 7074 2D42 5200 4272 6173 696C`이다.
- Edge는 TAG 1 + Edge Id 2 + Subject 2 + Object 8 = 13 WORD, `LLLL=1100`이다. TAG는 `0A4C`다.

```
0A4C 0051 0008 0141 009B 0787 0773 7074 2D42 5200 4272 6173 696C
```

## 관련 페이지

- [Edge](_index.md), [ALIAS](0x0A5L-alias.md), [DESCRIPTION](0x0A6L-description.md), [BIND](0x0A3L-bind.md)
- [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md), [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md), [LANGUAGE-BCP47-CODE](../value/0x076L-language-bcp47-code.md)
- [LOCAL](../reference/0x005L-local.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000A40/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A4000000000
BODY
#1 DECLARE 0x0A40
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "LABEL"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
