---
title: "GPS-TIMESTAMP-SECONDS"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GPS-TIMESTAMP-SECONDS는 GPS epoch 1980-01-06T00:00:00 GPS부터의 signed second 수를 담는 Value다(GPS Issuer 형식 0x4000)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GPS-TIMESTAMP-SECONDS는 GPS epoch `1980-01-06T00:00:00 GPS`부터의 signed second 수다. GPS week 번호로 나누거나 broadcast field의 week rollover 폭으로 자르지 않는다.

이 누적 count 표현은 IS-GPS-200 broadcast wire format이 아니라, GPS 시간척도를 고정폭 signed int64에 매핑한 GEUL 고유 profile이다.

## 레이아웃

- 코드: Value `ISSUER-1WORD`(`0x7C`), Issuer `0x0063` GPS, 형식 번호 `0x4000`. 계열 TIME.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  전체 7 WORD
Issuer            1 WORD  0x0063 (GPS)
형식 번호         1 WORD  0x4000
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## 해석과 유효성

- Payload 4 WORD 전체를 big-endian WORD 순서의 64비트 2의 보수 signed count로 읽는다.
- 유효 범위는 `-2^63`~`2^63-1`초다. 음수는 GPS epoch 이전의 GPS-time instant다.
- count는 epoch부터 이어지는 연속값이다. broadcast week-number field의 truncation이나 rollover를 적용하지 않는다.
- 작은 값도 항상 4 WORD를 쓴다. UTC 변환 파라미터는 담지 않는다.

## 길이

- 전체는 TAG 1 WORD, Issuer 1 WORD, 형식 번호 1 WORD와 Payload 4 WORD를 합한 정확히 7 WORD이고 직접 길이 `LLLL=0110`을 쓴다. Length 확장 TAG, descriptor, padding은 없다.
- Payload가 정확히 4 WORD가 아니면 거부한다.

## 예시

- GPS epoch는 Payload `0000 0000 0000 0000`, 전체 7 WORD, `LLLL=0110`이다.
- epoch 뒤 1초는 Payload `0000 0000 0000 0001`이다.
- epoch 1초 전은 Payload `ffff ffff ffff ffff`이다.

## 표준 근거와 형식 지위

- [GPS.gov Technical Documentation](https://www.gps.gov/technical-documentation)은 GPS 인터페이스 규격의 공식 배포처다.
- [IS-GPS-200N](https://archive.gps.gov/technical/icwg/IS-GPS-200N.pdf)은 GPS time이 연속 시간척도이고 week 0이 1980-01-06 자정에 시작함을 정하며, GPS week number와 time-of-week/Z-count broadcast field를 정의한다.
- IS-GPS-200은 현행 epoch 누적 signed int64 wire representation을 정의하지 않는다. rollover를 적용하지 않는 연속 count, signed int64와 GEUL big-endian WORD 배치는 GEUL 고유 매핑이다.
