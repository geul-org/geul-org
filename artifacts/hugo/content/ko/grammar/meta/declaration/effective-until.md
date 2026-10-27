---
title: "EFFECTIVE-UNTIL"
weight: 21
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "EFFECTIVE-UNTIL은 이 버전의 유효기간 끝(한시법)을 날짜·타임스탬프 Value로 선언하는 정의 Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

이 버전의 유효기간 끝을 선언한다(한시법). 그 시각부터 이 버전은 시행 중이 아니다.

## 레이아웃

```
TAG WORD          0001 1LLL L001 0100      Codec 0x14
[Length 확장 TAG]
Payload           TIME Value 하나
```

- Codec: Meta `0x14`, 정의 클래스(`001`)
- Payload: 내장 Value([GREGORIAN-DATE](/ko/grammar/value/time/gregorian-date/) 또는 [POSIX-TIMESTAMP-SECONDS](/ko/grammar/value/time/posix-timestamp-seconds/))
- 개수: 많아야 하나

## 해석과 유효성

- 없으면 다음 버전이 시행될 때까지 유효하다.
- 유효기간이 지나면 시행 중인 판본이 없다. 옛 판본이 되살아나지 않는다.
