---
title: "REPLACES"
weight: 55
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "REPLACES는 고쳐 쓴 대상 버전의 내용 해시를 적는 계보 Meta다(git amend·rebase). 원 버전은 지우지 않는다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

고쳐 쓴 대상 버전의 내용 해시를 적는다(git amend·rebase).

## 레이아웃

```
TAG WORD          0001 1LLL L011 0110      Codec 0x36
[Length 확장 TAG]
Payload           SHA-256-DIGEST Value 하나 (16 WORD)
```

- Codec: Meta `0x36`, 계보 클래스(`011`)
- Payload: 내장 Value([SHA-256-DIGEST](/ko/grammar/value/binary/sha-256-digest/))
- 개수: 여럿 가능

## 해석과 유효성

- 원 버전은 지우지 않는다(구법 보존).
- 다이제스트 형식을 Value로 내장해 해시 알고리즘을 바꿀 여지를 둔다. 지금 내용 해시는 SHA-256뿐이다.
