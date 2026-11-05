---
title: "GEUL (0x00AL~0x00EL)"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL은 geul.org가 CC0로 발급하는 엔티티를 가리키는 선언 Reference다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `GEUL` (5Q 묶음. 코드별 이름은 아래 구성원 표) |
| TAG ID | `0x00AL~0x00EL` |
| 섹션 | 0 `0000` (Reference 엔티티), 섹션 안 오프셋 C = 10~14 |
| Kind | Reference · 분류: 선언 |
| Hugo 쪽 | `reference/geul.md` |

## 구성원

이 쪽은 5Q 체계 한 벌, 코드 다섯 개를 함께 다룬다. 양화는 섹션 안 오프셋 `C % 5`다([Reference](_index.md#quantifier)). 코덱 문서는 코드마다 하나다. 다섯 코덱 문서의 필드는 같고 DECLARE 대상과 이름(BIND)만 다르다.

| TAG ID | 이름 | 양화 | 코덱 ID | 규격 문서 | TAG WORD |
|---|---|---|---|---|---|
| `0x00AL` | `GEUL-IDENTIFIED` | Identified | `0x000000A0` | `0x00000000/codecs/0x000000A0/` | `0000 0000 1010 LLLL` |
| `0x00BL` | `GEUL-GENERIC` | Generic | `0x000000B0` | `0x00000000/codecs/0x000000B0/` | `0000 0000 1011 LLLL` |
| `0x00CL` | `GEUL-FREE-CHOICE` | Free-choice | `0x000000C0` | `0x00000000/codecs/0x000000C0/` | `0000 0000 1100 LLLL` |
| `0x00DL` | `GEUL-UNIVERSAL` | Universal | `0x000000D0` | `0x00000000/codecs/0x000000D0/` | `0000 0000 1101 LLLL` |
| `0x00EL` | `GEUL-VARIABLE` | Variable | `0x000000E0` | `0x00000000/codecs/0x000000E0/` | `0000 0000 1110 LLLL` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `geul-id` | #2 | 나머지 날값(`0xFFFF`) |  |  |

GEUL은 geul.org가 CC0로 발급하는 엔티티를 가리키는 선언 Reference다. 번호에 의미를 담지 않는 일련 ID다. 비트에 의미를 담는 식별자는 별도 Codec [GEUL-SIDX](0x00FL-geul-sidx.md)(`0x00FL~0x013L`)가 맡는다.

## 레이아웃

```
TAG WORD          0000 0000 1010 LLLL      Codec 0x00AL~0x00EL (Identified 0x00AL)
[Length 확장 TAG]
GEUL ID           가장 짧은 폭의 unsigned big-endian
```

- 작은 번호를 고빈도 엔티티에 배정한다. 1 WORD에 들어가는 ID는 전체 2 WORD다.
- ID 배정과 레지스트리는 geul.org가 관리한다. 레지스트리에는 CC0 원천에서 나온 것만 넣는다.
- Variable이면 그 종류의 익명 변수다([Reference](_index.md) Variable).

## 예시

| GEUL ID | WORD sequence |
|---|---|
| 1, Identified | `00A1 0001` |
| 1, Variable | `00E1 0001` |
| 70000, Generic | `00B2 0001 1170` |

## 열린 문제

- GEUL ID 배정 규칙과 레지스트리 공개 형식.

## 관련 페이지

- [Reference](_index.md), [GEUL-SIDX](0x00FL-geul-sidx.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x000000A0/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000000A000000000
BODY
#1 DECLARE 0x00A0
#2 FIELD #1 rest
#3 BIND #1 "GEUL-IDENTIFIED"
#4 BIND #2 "geul-id"
```

위는 `GEUL-IDENTIFIED`(`0x00AL`)의 코덱 문서다. 다른 구성원(`GEUL-GENERIC`, `GEUL-FREE-CHOICE`, `GEUL-UNIVERSAL`, `GEUL-VARIABLE`)의 코덱 문서는 DOC-ID의 코덱 ID, DECLARE 대상, `#1`에 묶은 이름(BIND)만 다르다.
