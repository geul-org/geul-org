---
title: "TAG (0x1DAL)"
weight: 474
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "버전에 붙인 불변 이름을 적는다(git annotated tag)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `TAG` (규격 문서 BIND `TAG`) |
| TAG ID | `0x1DAL` |
| 코덱 ID | `0x00001DA0` |
| 규격 문서 | `0x00000000/codecs/0x00001DA0/` (DECLARE 대상 `1DA0`) |
| 섹션 | 14 `1110` (Meta), 섹션 안 오프셋 C = 26 |
| Kind | Meta · 클래스: 계보 |
| TAG WORD | `0001 1101 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 버전에 붙인 불변 이름. TEXT Value와 내용 해시 (git annotated tag) |
| Hugo 쪽 | `meta/lineage/tag.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `name` | #2 | 레코드 | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD |  |
| 2 | `target` | #7 | 레코드 | `07C0` SHA-256-DIGEST, `0000` ABSENT(선택 필드) |  |

버전에 붙인 불변 이름을 적는다(git annotated tag).

## 레이아웃

```
TAG WORD          0001 1101 1010 LLLL      Codec 0x1DAL
[Length 확장 TAG]
이름              UTF8-TEXT-* Value
대상              SHA-256-DIGEST Value, 또는 생략 표지 0x0000 (선택 필드). 생략하면 이 버전
```

- Codec: Meta `0x1DAL`, 계보 클래스
- Payload: 내장 Value(텍스트 + 선택적 내용 해시)
- 개수: 여럿 가능

## 해석과 유효성

- 이름은 [UTF8-TEXT](../value/0x072L-utf8-text.md), 대상은 [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md)다.
- 대상을 생략하면(ABSENT `0x0000`, [CODEC](../edge/0x0BEL-codec.md) 선택 필드) 이 문서 자신에 붙인 이름이다. 자기 내용 해시는 자기 안에 적을 수 없다. geul.org 규격 `0x1DA0`은 name(`0720`·`0730`)과 target(`07C0`·`0000`)의 두 레코드 필드다.
- 같은 이름을 다른 버전에 다시 쓰지 않는다.

## 예시

- 이름 `v1`, 이 버전: `1DA3 0721 7631 0000`

## 열린 문제

- 버전 ID(순번)가 있는데도 TAG가 필요한지.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001DA0/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DA000000000
BODY
#1 DECLARE 0x1DA0
#2 FIELD #1 record
#3 BIND #1 "TAG"
#4 BIND #2 "name"
#5 CODEC #2 0x0720
#6 CODEC #2 0x0730
#7 FIELD #1 record
#8 BIND #7 "target"
#9 CODEC #7 0x07C0
#10 CODEC #7 0x0000
```
