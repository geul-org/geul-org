---
title: "PARENT"
weight: 49
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "PARENT는 직전 버전의 내용 해시를 적는 계보 Meta다(git parent). 여럿이면 병합이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

직전 버전의 내용 해시를 적는다(git parent).

## 레이아웃

```
TAG WORD          0001 1LLL L011 0000      Codec 0x30
[Length 확장 TAG]
Payload           SHA-256-DIGEST Value 하나 (16 WORD)
```

- Codec: Meta `0x30`, 계보 클래스(`011`)
- Payload: 내장 Value([SHA-256-DIGEST](/ko/grammar/value/binary/sha-256-digest/))
- 개수: 여럿 가능(병합)

## 해석과 유효성

- 없으면 최초 버전이고, 여럿이면 병합이다(git merge commit).
- [내용 해시](/ko/grammar/document/#내용-해시)에 들어가므로 이력 전체가 해시 사슬이 된다.
- 버전 목록 문서는 직전 목록 문서를 가리킨다([PUBLICATION](/ko/grammar/edge/publication/)).
- 다이제스트 형식을 Value로 내장해 해시 알고리즘을 바꿀 여지를 둔다. 지금 내용 해시는 SHA-256뿐이다.

## 예시

- `0x1F30 0x0014 0x0F61 0x0012 <16 WORD>` (Meta 20 WORD = TAG + Length 확장 + 내장 Value 18 WORD)
