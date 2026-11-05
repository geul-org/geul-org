---
title: "DURATION-SECONDS (0x06DL)"
weight: 109
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-SECONDS는 epoch이 없는 signed 초 단위 경과 시간이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `DURATION-SECONDS` (규격 문서 BIND `DURATION-SECONDS`) |
| TAG ID | `0x06DL` |
| 코덱 ID | `0x000006D0` |
| 규격 문서 | `0x00000000/codecs/0x000006D0/` (DECLARE 대상 `06D0`) |
| 섹션 | 3 `0011` (Value), 섹션 안 오프셋 C = 13 |
| Kind | Value · 계열: TIME |
| TAG WORD | `0000 0110 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | epoch 없는 signed SI-second 경과 시간 |
| Hugo 쪽 | `value/time/duration-seconds.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `seconds` | #2 | 날값 4 WORD |  |  |

DURATION-SECONDS는 epoch이 없는 signed 초 단위 경과 시간이다. instant나 달력의 월·연 기간이 아니다.

## 레이아웃

- 코드: Value 직접 코드 `0x06DL`. 계열 TIME.
- Arrow `Duration(SECOND)`와 같은 고정폭 signed int64 물리 타입을 쓴다.

```
TAG WORD          0x06D4 (0000 0110 1101 0100)  전체 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## 해석과 유효성

- Payload 4 WORD 전체를 big-endian WORD 순서의 64비트 2의 보수 signed count로 읽는다.
- 유효 범위는 `-2^63`~`2^63-1`초다. 부호는 경과 방향이며 특정 epoch의 instant를 가리키지 않는다.
- 작은 값도 항상 4 WORD를 쓴다.

## 길이

- 전체는 TAG 1 WORD와 Payload 4 WORD를 합한 정확히 5 WORD이고 직접 길이 `LLLL=0100`을 쓴다. Length 확장 TAG, descriptor, padding은 없다.
- Payload가 정확히 4 WORD가 아니면 거부한다.

## 예시

- 0초는 Payload `0000 0000 0000 0000`, 전체 5 WORD, `LLLL=0100`이다.
- 1초는 Payload `0000 0000 0000 0001`이다.
- -1초는 Payload `FFFF FFFF FFFF FFFF`이다.

## 표준 근거

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html)은 `Schema.fbs`를 Arrow 표준 데이터 타입의 authoritative source로 지정한다.
- Arrow의 authoritative [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs)에서 `Duration`은 달력과 무관한 절대 경과 시간이며, SECOND 단위를 지원하고 항상 8-byte signed integer로 표현된다. GEUL은 여기에 TAG와 big-endian 16비트 WORD framing만 더한다.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x000006D0/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006D000000000
BODY
#1 DECLARE 0x06D0
#2 FIELD #1 0x0004
#3 BIND #1 "DURATION-SECONDS"
#4 BIND #2 "seconds"
```
