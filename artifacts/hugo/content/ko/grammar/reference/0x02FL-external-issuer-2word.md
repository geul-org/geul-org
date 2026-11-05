---
title: "EXTERNAL-ISSUER-2WORD (0x02FL~0x033L)"
weight: 47
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-ISSUER는 Issuer가 공표한 문서의 LOCAL ID를 IMPORT 없이 레코드 하나로 인용하는 지시선언 Reference다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-ISSUER는 Issuer가 공표한 문서의 LOCAL ID를 IMPORT 없이 레코드 하나로 인용하는 지시선언 Reference다.

| 항목 | 값 |
|---|---|
| 이름 | `EXTERNAL-ISSUER-2WORD` (5Q 묶음. 코드별 이름은 아래 구성원 표) |
| TAG ID | `0x02FL~0x033L` |
| 섹션 | 1 `0001` (Reference EXTERNAL), 섹션 안 오프셋 C = 15~19 |
| Kind | Reference · 분류: 지시선언 |
| Hugo 쪽 | `reference/external-issuer.md` (그 쪽은 [EXTERNAL-ISSUER-4WORD](0x034L-external-issuer-4word.md), [EXTERNAL-ISSUER-16WORD](0x039L-external-issuer-16word.md)도 함께 다룬다) |

## 구성원

이 쪽은 5Q 체계 한 벌, 코드 다섯 개를 함께 다룬다. 양화는 섹션 안 오프셋 `C % 5`다([Reference](_index.md#quantifier)). 코덱 문서는 코드마다 하나다. 다섯 코덱 문서의 필드는 같고 DECLARE 대상과 이름(BIND)만 다르다.

| TAG ID | 이름 | 양화 | 코덱 ID | 규격 문서 | TAG WORD |
|---|---|---|---|---|---|
| `0x02FL` | `EXTERNAL-ISSUER-2WORD-IDENTIFIED` | Identified | `0x000002F0` | `0x00000000/codecs/0x000002F0/` | `0000 0010 1111 LLLL` |
| `0x030L` | `EXTERNAL-ISSUER-2WORD-GENERIC` | Generic | `0x00000300` | `0x00000000/codecs/0x00000300/` | `0000 0011 0000 LLLL` |
| `0x031L` | `EXTERNAL-ISSUER-2WORD-FREE-CHOICE` | Free-choice | `0x00000310` | `0x00000000/codecs/0x00000310/` | `0000 0011 0001 LLLL` |
| `0x032L` | `EXTERNAL-ISSUER-2WORD-UNIVERSAL` | Universal | `0x00000320` | `0x00000000/codecs/0x00000320/` | `0000 0011 0010 LLLL` |
| `0x033L` | `EXTERNAL-ISSUER-2WORD-VARIABLE` | Variable | `0x00000330` | `0x00000000/codecs/0x00000330/` | `0000 0011 0011 LLLL` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | 날값 2 WORD |  |  |
| 2 | `doc` | #3 | 날값 4 WORD |  |  |
| 3 | `target-id` | #4 | 나머지 날값(`0xFFFF`) |  |  |

EXTERNAL-ISSUER는 Issuer가 공표한 문서의 LOCAL ID를 IMPORT 없이 인용하는 지시선언 Reference다. 레코드 하나로 뜻이 완결되며 최신 버전을 따른다.

## 레이아웃

```
TAG WORD          0000 001C CCCC LLLL      Codec 0x02FL~0x03DL (섹션 1)
[Length 확장 TAG]
Issuer            Codec이 정한 폭 (2/4/16 WORD)
문서 ID           4 WORD
대상 ID           나머지 전부. 그 문서의 LOCAL ID, 가장 짧은 폭
```

| Codec (Identified, Generic, Free-choice, Universal, Variable) | 이름 | Issuer 폭 |
|---|---|---|
| `0x02FL~0x033L` | EXTERNAL-ISSUER-2WORD | 2 WORD (geul.org 등록, 도메인 증명) |
| `0x034L~0x038L` | EXTERNAL-ISSUER-4WORD | 4 WORD (geul.org 등록, 증명 없음) |
| `0x039L~0x03DL` | EXTERNAL-ISSUER-16WORD | 16 WORD (공개키에서 계산) |

- 폭은 체계 번호로 정해진다: 체계 − 9(섹션 안 오프셋 `C`의 `C / 5 − 3`)가 0, 1, 2이면 2, 4, 16 WORD다. 양화는 `C % 5`다.
- Issuer ID는 정수값이다. 값이 같으면 같은 Issuer다. Issuer는 값이 들어가는 가장 짧은 폭으로 쓰고, 그 폭의 Codec을 고른다(`2^32` 이상일 때만 4 WORD, `2^64` 이상일 때만 16 WORD). 더 넓은 폭의 표기는 invalid다([Issuer](../issuer.md)).
- Issuer 등록과 관리는 geul.org가 맡는다.
- 버전은 적지 않으며 최신 버전을 따른다. 버전을 고정하려면 [IMPORT-DOC](../meta/0x1E4L-import-doc.md)과 [EXTERNAL-POINTER](0x020L-external-pointer-1word.md)를 쓴다.
- 위치는 공표 주소 규칙으로 찾는다([공표 주소와 버전 목록](../publishing.md)).
- 그 문서의 같은 LOCAL ID면, 그 문서 안에서 LOCAL로 쓰든 다른 문서에서 EXTERNAL-ISSUER로 쓰든(또는 IMPORT 뒤 EXTERNAL-POINTER로 쓰든) 같은 대상이다.
- 문서의 LOCAL만 가리킨다. 문서 자신은 [DOC-POINTER](0x041L-doc-pointer.md), Issuer 자신은 [ISSUER-POINTER](0x040L-issuer-pointer.md)로 가리킨다. 그래서 대상 ID는 `0`이 아니다. 문서 ID `0`은 Issuer의 용어 정의 색인 문서다.

## 유효성

- Issuer 폭이 Codec과 맞지 않거나, 값이 더 좁은 폭에 들어가면 invalid다.
- 대상 ID가 `0`이면 invalid다. 대상 ID `0`(문서 자신)은 DOC-POINTER가 맡는다.
- 대상 ID의 선행 `0x0000` WORD는 금지한다.

## 예시

| 대상 | WORD sequence |
|---|---|
| Issuer `0x00000002`, 문서 `0x…0002`, LOCAL 7 | `02F7 0000 0002 0000 0000 0000 0002 0007` |
| Issuer `0x00012345`, 문서 `0x…0002`, LOCAL 7 | `02F7 0001 2345 0000 0000 0000 0002 0007` |

## 관련 페이지

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [EXTERNAL-POINTER](0x020L-external-pointer-1word.md)
- [Issuer와 공표](../issuer.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x000002F0/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000002F000000000
BODY
#1 DECLARE 0x02F0
#2 FIELD #1 0x0002
#3 FIELD #1 0x0004
#4 FIELD #1 rest
#5 BIND #1 "EXTERNAL-ISSUER-2WORD-IDENTIFIED"
#6 BIND #2 "issuer"
#7 BIND #3 "doc"
#8 BIND #4 "target-id"
```

위는 `EXTERNAL-ISSUER-2WORD-IDENTIFIED`(`0x02FL`)의 코덱 문서다. 다른 구성원(`EXTERNAL-ISSUER-2WORD-GENERIC`, `EXTERNAL-ISSUER-2WORD-FREE-CHOICE`, `EXTERNAL-ISSUER-2WORD-UNIVERSAL`, `EXTERNAL-ISSUER-2WORD-VARIABLE`)의 코덱 문서는 DOC-ID의 코덱 ID, DECLARE 대상, `#1`에 묶은 이름(BIND)만 다르다.
