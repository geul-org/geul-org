---
title: "ACQUIRED-AT"
weight: 41
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "ACQUIRED-AT은 원천 자료를 확보한 시각을 TIME Value로 적는 출처 Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

원천 자료를 확보한 시각을 적는다.

## 레이아웃

```
TAG WORD          0001 1LLL L010 1000      Codec 0x28
[Length 확장 TAG]
Payload           TIME Value 하나 (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS 등)
```

- Codec: Meta `0x28`, 출처 클래스(`010`)
- Payload: 내장 Value(TIME 계열: [GREGORIAN-DATE](/ko/grammar/value/time/gregorian-date/), [POSIX-TIMESTAMP-SECONDS](/ko/grammar/value/time/posix-timestamp-seconds/) 등)
- 개수: 많아야 하나

## 해석과 유효성

- 형식은 TIME 계열 Value 중 고른다. 정밀도가 필요하면 Issuer가 정의한 나노초 형식(예: [POSIX-TIMESTAMP-NANOSECONDS](/ko/grammar/value/time/posix-timestamp-nanoseconds/))을 쓴다.
