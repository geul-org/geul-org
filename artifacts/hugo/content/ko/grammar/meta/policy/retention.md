---
title: "RETENTION"
weight: 84
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "RETENTION은 문서의 보존 기한을 만료 시각 또는 기간 Value로 적는 정책 Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

문서의 보존 기한을 적는다.

## 레이아웃

```
TAG WORD          0001 1LLL L101 0011      Codec 0x53
[Length 확장 TAG]
Payload           만료 시각(GREGORIAN-DATE 등) 또는 기간(DURATION-SECONDS)
```

- Codec: Meta `0x53`, 정책 클래스(`101`)
- Payload: 내장 Value(TIME 계열: [GREGORIAN-DATE](/ko/grammar/value/time/gregorian-date/) 등, 또는 [DURATION-SECONDS](/ko/grammar/value/time/duration-seconds/))
- 개수: 많아야 하나

## 해석과 유효성

- 기간이면 [RECORDED-AT](/ko/grammar/meta/provenance/recorded-at/)부터 센다.
