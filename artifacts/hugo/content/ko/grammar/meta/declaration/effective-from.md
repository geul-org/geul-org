---
title: "EFFECTIVE-FROM"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "EFFECTIVE-FROM은 이 버전의 시행일을 날짜·타임스탬프 Value로 선언하는 정의 Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

이 버전의 시행일을 선언한다. 시행일은 공표 시각과 다르다([개정](/ko/grammar/document/#개정)).

## 레이아웃

```
TAG WORD          0001 1LLL L001 0011      Codec 0x13
[Length 확장 TAG]
Payload           TIME Value 하나
```

- Codec: Meta `0x13`, 정의 클래스(`001`)
- Payload: 내장 Value([GREGORIAN-DATE](/ko/grammar/value/time/gregorian-date/) 또는 [POSIX-TIMESTAMP-SECONDS](/ko/grammar/value/time/posix-timestamp-seconds/))
- 개수: 많아야 하나

## 해석과 유효성

- 없으면 공표 시각부터 시행한다.
- [EFFECTIVE-UNTIL](/ko/grammar/meta/declaration/effective-until/)이 있으면 그보다 앞서야 한다.
- 조문별로 시행일이 다르면 근거 Edge `RECORD-EFFECTIVE`로 따로 적는다.
- 문서를 특정 시점 기준으로 해석할 때 이 값을 읽는다.

## 예시

- 1970-01-02 시행: `0x1993 0x0920 0x0000 0x0001`
