---
title: "DERIVED-FROM"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DERIVED-FROM은 이 문서가 파생한 다른 계보의 문서·자료를 적는 계보 Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

이 문서가 다른 계보의 문서·자료에서 파생했음을 적는다.

## 레이아웃

```
TAG WORD          0001 1LLL L011 0001      Codec 0x31
[Length 확장 TAG]
Payload           Reference, 또는 SHA-256-DIGEST(내용 해시), 또는 URI Value
```

- Codec: Meta `0x31`, 계보 클래스(`011`)
- Payload: 내장 Reference 또는 Value
- 개수: 여럿 가능

## 해석과 유효성

- GEUL 문서에서 파생했으면 그 내용 해시([SHA-256-DIGEST](/ko/grammar/value/binary/sha-256-digest/))를, 외부 자료면 [SOURCE](/ko/grammar/meta/provenance/source/)처럼 [URI](/ko/grammar/value/text/uri/)(+다이제스트)를 둔다.
- 레코드 단위 파생은 근거 Edge `RECORD-DERIVED-FROM`이 맡는다.
