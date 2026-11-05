---
title: "WIKIDATA-QID (0x014L~0x018L)"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-QID는 위키데이터 항목(Item)을 가리키는 선언 Reference다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `WIKIDATA-QID` (5Q 묶음. 코드별 이름은 아래 구성원 표) |
| TAG ID | `0x014L~0x018L` |
| 섹션 | 0 `0000` (Reference 엔티티), 섹션 안 오프셋 C = 20~24 |
| Kind | Reference · 분류: 선언 |
| Hugo 쪽 | `reference/wikidata-qid.md` |

## 구성원

이 쪽은 5Q 체계 한 벌, 코드 다섯 개를 함께 다룬다. 양화는 섹션 안 오프셋 `C % 5`다([Reference](_index.md#quantifier)). 코덱 문서는 코드마다 하나다. 다섯 코덱 문서의 필드는 같고 DECLARE 대상과 이름(BIND)만 다르다.

| TAG ID | 이름 | 양화 | 코덱 ID | 규격 문서 | TAG WORD |
|---|---|---|---|---|---|
| `0x014L` | `WIKIDATA-QID-IDENTIFIED` | Identified | `0x00000140` | `0x00000000/codecs/0x00000140/` | `0000 0001 0100 LLLL` |
| `0x015L` | `WIKIDATA-QID-GENERIC` | Generic | `0x00000150` | `0x00000000/codecs/0x00000150/` | `0000 0001 0101 LLLL` |
| `0x016L` | `WIKIDATA-QID-FREE-CHOICE` | Free-choice | `0x00000160` | `0x00000000/codecs/0x00000160/` | `0000 0001 0110 LLLL` |
| `0x017L` | `WIKIDATA-QID-UNIVERSAL` | Universal | `0x00000170` | `0x00000000/codecs/0x00000170/` | `0000 0001 0111 LLLL` |
| `0x018L` | `WIKIDATA-QID-VARIABLE` | Variable | `0x00000180` | `0x00000000/codecs/0x00000180/` | `0000 0001 1000 LLLL` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `qid` | #2 | 나머지 날값(`0xFFFF`) |  |  |

WIKIDATA-QID는 위키데이터 항목(Item)을 가리키는 선언 Reference다. Q아이디에서 `Q`를 뺀 숫자 부분을 부호 없는 정수로 쓴다.

## 레이아웃

```
TAG WORD          0000 0001 0100 LLLL      Codec 0x014L~0x018L (Identified 0x014L)
[Length 확장 TAG]
QID               가장 짧은 폭의 unsigned big-endian
```

- QID는 가장 짧은 폭으로 쓴다. `Q1`~`Q65535`는 전체 2 WORD, 그 위는 3 WORD다.
- 위키데이터 데이터는 CC0다.
- Variable이면 그 항목이 가리키는 종류의 익명 변수다([Reference](_index.md) Variable).

## 예시

| 항목 | WORD sequence |
|---|---|
| `Q5` (human) | `0141 0005` |
| `Q76` (Barack Obama) | `0141 004C` |
| `Q884` (South Korea) | `0141 0374` |
| `Q317521` (Elon Musk) | `0142 0004 D851` |
| `Q30461` (president), Variable | `0181 76FD` |

## 관련 페이지

- [Reference](_index.md), [WIKIDATA-PID](0x019L-wikidata-pid.md), [TRIPLE](../edge/0x0AAL-triple.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000140/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000014000000000
BODY
#1 DECLARE 0x0140
#2 FIELD #1 rest
#3 BIND #1 "WIKIDATA-QID-IDENTIFIED"
#4 BIND #2 "qid"
```

위는 `WIKIDATA-QID-IDENTIFIED`(`0x014L`)의 코덱 문서다. 다른 구성원(`WIKIDATA-QID-GENERIC`, `WIKIDATA-QID-FREE-CHOICE`, `WIKIDATA-QID-UNIVERSAL`, `WIKIDATA-QID-VARIABLE`)의 코덱 문서는 DOC-ID의 코덱 ID, DECLARE 대상, `#1`에 묶은 이름(BIND)만 다르다.
