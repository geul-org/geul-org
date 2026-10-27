---
title: "RECORDED-AT"
weight: 38
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "RECORDED-AT은 문서로 기록한 시각을 TIME Value로 적는 출처 Meta다(git commit date)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

문서로 기록한 시각을 적는다(git commit date).

## 레이아웃

```
TAG WORD          0001 1LLL L010 0101      Codec 0x25
[Length 확장 TAG]
Payload           TIME Value 하나 (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS 등)
```

- Codec: Meta `0x25`, 출처 클래스(`010`)
- Payload: 내장 Value(TIME 계열: [GREGORIAN-DATE](/ko/grammar/value/time/gregorian-date/), [POSIX-TIMESTAMP-SECONDS](/ko/grammar/value/time/posix-timestamp-seconds/) 등)
- 개수: 많아야 하나

## 해석과 유효성

- 형식은 TIME 계열 Value 중 고른다. 정밀도가 필요하면 Issuer가 정의한 나노초 형식(예: [POSIX-TIMESTAMP-NANOSECONDS](/ko/grammar/value/time/posix-timestamp-nanoseconds/))을 쓴다.
- 버전 목록 문서([PUBLICATION](/ko/grammar/edge/publication/))는 이 값을 공표·폐기(deprecate)·삭제 시각으로 쓴다.

## 열린 문제

- 출처 Meta는 내용 해시에 들어간다. 같은 내용을 다른 시각에 기록하면 해시가 달라지는 것을 허용할지.
