---
title: "RECORDED-BY"
weight: 37
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "RECORDED-BY는 문서로 기록한 주체를 Reference로 적는 출처 Meta다(git committer)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

문서로 기록한 주체를 적는다(git committer).

## 레이아웃

```
TAG WORD          0001 1LLL L010 0100      Codec 0x24
[Length 확장 TAG]
Payload           Reference 레코드 하나 (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL 등)
```

- Codec: Meta `0x24`, 출처 클래스(`010`)
- Payload: 내장 Reference
- 개수: 많아야 하나

## 해석과 유효성

- Reference는 Codec을 가리지 않는다. 사람·조직·모델·규칙 엔진 모두 될 수 있다([EXTERNAL-ISSUER](/ko/grammar/reference/external-issuer/), [GEUL](/ko/grammar/reference/geul/), [WIKIDATA-QID](/ko/grammar/reference/wikidata-qid/), [LOCAL](/ko/grammar/reference/local/) 등).
- geul.org 공표 문서에는 자연인을 가리키는 Reference를 두지 않는다([Issuer와 공표](/ko/grammar/issuer/#geulorg-공표)). 조직·Issuer를 가리킨다. 예외로 [WIKIDATA-QID](/ko/grammar/reference/wikidata-qid/)로 자연인을 가리키는 것은 허용한다.
- LOCAL이면 BODY에서 그 대상을 서술한다.
