---
title: "BOOL (0x060L)"
weight: 96
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BOOL은 논리값 false와 true를 나타내는 Value다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `BOOL` (규격 문서 BIND `BOOL`) |
| TAG ID | `0x060L` |
| 코덱 ID | `0x00000600` |
| 규격 문서 | `0x00000000/codecs/0x00000600/` (DECLARE 대상 `0600`) |
| 섹션 | 3 `0011` (Value), 섹션 안 오프셋 C = 0 |
| Kind | Value · 계열: NUMERIC |
| TAG WORD | `0000 0110 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 고정 1 WORD의 false 또는 true |
| Hugo 쪽 | `value/numeric/bool.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | 날값 1 WORD |  | `0x0000` false, `0x0001` true |

BOOL은 논리값 false와 true를 나타내는 Value다. Value 직접 코드 `0x060L`, 계열 NUMERIC이다. 숫자 0과 1을 담는 SIGNED-INTEGER·UNSIGNED-INTEGER와는 다른 타입이다.

## 레이아웃

```
TAG WORD          0x0601 (0000 0110 0000 0001)  전체 2 WORD
Payload           1 WORD  Boolean Code
```

## 해석과 유효성

- Payload `0000`은 false, `0001`은 true다.
- padding이나 descriptor는 없다.
- Payload는 정확히 `0000` 또는 `0001`이다. 그 밖의 16비트 값은 invalid로 거부한다.
- 다른 Length 표현은 모두 invalid로 거부한다.

## 길이

- 전체는 TAG 1 WORD와 Payload 1 WORD를 합한 정확히 2 WORD이고 직접 길이 `LLLL=0001`을 쓴다. Length 확장 TAG, descriptor, padding은 없다.
- Payload가 정확히 1 WORD가 아니면 거부한다.

## 예시

| 전체 레코드 (TAG + Payload) | Payload | 판정 |
|---|---|---|
| `0601 0000` | `0000` | false, 정규 |
| `0601 0001` | `0001` | true, 정규 |
| `0601 0002` | `0002` | invalid |
| `0601 FFFF` | `FFFF` | invalid |
| Length가 `0001`이 아닌 TAG + `0000` 또는 `0001` | `0000` 또는 `0001` | invalid |

## 형식 지위

- `0000`/`0001`의 16비트 code word와 GEUL TAG를 묶은 이 표현은 GEUL 고유 scalar profile이다.
- 논리값 자체는 보편적이지만, 이 1 WORD 표현에 대응하는 단일 산업표준을 주장하지 않는다.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000600/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000060000000000
BODY
#1 DECLARE 0x0600
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 BIND #1 "BOOL"
#6 BIND #2 "code"
#7 BIND #3 "false"
#8 BIND #4 "true"
```
