---
title: "SIGNED-OFF"
weight: 67
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "SIGNED-OFF는 기여 권리 확인을 Reference로 적는 검증 Meta다(git Signed-off-by, DCO)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

기여 권리 확인이다(git `Signed-off-by`, DCO).

## 레이아웃

```
TAG WORD          0001 1LLL L100 0010      Codec 0x42
[Length 확장 TAG]
Payload           Reference 하나
```

- Codec: Meta `0x42`, 검증 클래스(`100`)
- Payload: 내장 Reference
- 개수: 여럿 가능

## 해석과 유효성

- geul.org 공표 문서에는 자연인을 가리키는 Reference를 두지 않는다([Issuer와 공표](/ko/grammar/issuer/#geulorg-공표)). 조직·Issuer를 가리킨다. 예외로 [WIKIDATA-QID](/ko/grammar/reference/wikidata-qid/)로 자연인을 가리키는 것은 허용한다.
