---
title: "EFFECTIVE-UNTIL (0x1C9L)"
weight: 457
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "이 버전의 유효기간 끝을 선언한다(한시법)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `EFFECTIVE-UNTIL` (규격 문서 BIND `EFFECTIVE-UNTIL`) |
| TAG ID | `0x1C9L` |
| 코덱 ID | `0x00001C90` |
| 규격 문서 | `0x00000000/codecs/0x00001C90/` (DECLARE 대상 `1C90`) |
| 섹션 | 14 `1110` (Meta), 섹션 안 오프셋 C = 9 |
| Kind | Meta · 클래스: 정의 |
| TAG WORD | `0001 1100 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 이 버전의 유효기간 끝(한시법). 없으면 다음 버전이 시행될 때까지 |
| Hugo 쪽 | `meta/declaration/effective-until.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `time` | #2 | 레코드 | `06A0` GREGORIAN-DATE, `06C0` POSIX-TIMESTAMP-SECONDS |  |

이 버전의 유효기간 끝을 선언한다(한시법). 그 시각부터 이 버전은 시행 중이 아니다.

## 레이아웃

```
TAG WORD          0001 1100 1001 LLLL      Codec 0x1C9L
[Length 확장 TAG]
Payload           TIME Value 하나
```

- Codec: Meta `0x1C9L`, 정의 클래스
- Payload: 내장 Value([GREGORIAN-DATE](../value/0x06AL-gregorian-date.md) 또는 [POSIX-TIMESTAMP-SECONDS](../value/0x06CL-posix-timestamp-seconds.md))
- 개수: 많아야 하나

## 해석과 유효성

- 없으면 다음 버전이 시행될 때까지 유효하다.
- 유효기간이 지나면 시행 중인 판본이 없다. 옛 판본이 되살아나지 않는다.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001C90/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C9000000000
BODY
#1 DECLARE 0x1C90
#2 FIELD #1 record
#3 BIND #1 "EFFECTIVE-UNTIL"
#4 BIND #2 "time"
#5 CODEC #2 0x06A0
#6 CODEC #2 0x06C0
```
