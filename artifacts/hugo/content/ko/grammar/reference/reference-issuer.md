---
title: "REFERENCE-ISSUER"
weight: 15
date: 2026-11-03T12:00:00+09:00
lastmod: 2026-11-03T12:00:00+09:00
tags: ["grammar", "reference", "issuer"]
summary: "REFERENCE-ISSUER는 Issuer가 정의한 Reference 형식이다. TAG, Issuer, 코덱 번호 2 WORD 뒤의 Payload는 Issuer가 발행한 Codec 문서가 정한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REFERENCE-ISSUER는 Issuer가 정의한 Reference 형식이다. Reference 구역의 끝 세 칸이다. Value·Edge의 ISSUER와 레이아웃이 같다([레코드와 TAG WORD](/ko/grammar/record/#issuer-형식-레코드)).

## 레이아웃

```
TAG WORD          0000 0011 11CC LLLL      Codec 0x03DL / 0x03EL / 0x03FL
[Length 확장 TAG]
Issuer            2/4/16 WORD (Codec이 폭을 정한다)
코덱 번호         2 WORD. Issuer가 정의한다
Payload           Issuer가 발행한 Codec 문서가 정한다
```

| Codec | 이름 | Issuer 폭 |
|---|---|---|
| `0x03DL` | REFERENCE-ISSUER-2WORD | 2 WORD |
| `0x03EL` | REFERENCE-ISSUER-4WORD | 4 WORD |
| `0x03FL` | REFERENCE-ISSUER-16WORD | 16 WORD |

## 해석과 유효성

- GEUL은 Length로 Payload 경계만 안다. Payload는 코덱북 없이 해석하지 않는다.
- 코덱 번호의 뜻과 양화는 Issuer가 정한다. 무엇을 가리키는지도 Issuer가 발행한 Codec 문서가 정한다.
- Reference 공통 규칙은 적용되지 않는다: 대상 ID 최단 폭, 대상 ID `0`의 1 WORD 표기, Quantifier, `C % 5`, `C / 5`, 선언·지시 분류, 가리키는 대상.
- 코덱 번호 2 WORD는 Value·Edge ISSUER와 같다. 번호가 모자라면 Issuer를 하나 더 발급받는다.
- 형식을 모르는 디코더는 Kind, Length, Issuer, 코덱 번호까지 알고 Length로 건너뛴다.
- Issuer 형식의 라이선스는 그 Issuer가 정한다([Issuer와 공표](/ko/grammar/issuer/#라이선스)).

## 관련 페이지

- [Reference](/ko/grammar/reference/), [레코드와 TAG WORD](/ko/grammar/record/), [Issuer와 공표](/ko/grammar/issuer/)
