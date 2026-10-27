---
title: "CHERRY-PICKED-FROM"
weight: 53
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "CHERRY-PICKED-FROM은 다른 계보에서 변경을 가져온 원 버전의 내용 해시를 적는 계보 Meta다(git cherry-pick -x)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

다른 계보의 변경을 가져온 원 버전의 내용 해시를 적는다(git cherry-pick `-x`).

## 레이아웃

```
TAG WORD          0001 1LLL L011 0100      Codec 0x34
[Length 확장 TAG]
Payload           SHA-256-DIGEST Value 하나 (16 WORD)
```

- Codec: Meta `0x34`, 계보 클래스(`011`)
- Payload: 내장 Value([SHA-256-DIGEST](/ko/grammar/value/binary/sha-256-digest/))
- 개수: 여럿 가능

## 해석과 유효성

- 다이제스트 형식을 Value로 내장해 해시 알고리즘을 바꿀 여지를 둔다. 지금 내용 해시는 SHA-256뿐이다.
