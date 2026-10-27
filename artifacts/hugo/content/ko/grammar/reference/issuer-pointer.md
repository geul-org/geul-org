---
title: "ISSUER-POINTER"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "ISSUER-POINTER는 Issuer 자신을 가리키는 지시선언 Reference다. Payload는 Issuer 하나뿐이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ISSUER-POINTER는 Issuer 자신을 가리키는 지시선언 Reference다. Issuer 이름 `BIND`, `LABEL`, 판정 Edge의 대상이 된다.

## 레이아웃

```
TAG WORD          0000 0LLL L011 0QQQ      CCCC = 0110
[Length 확장 TAG]
Issuer            1/2/4/16 WORD
```

- Issuer 폭은 Payload 전체다. Codec이 폭을 나누지 않는다. 폭이 1, 2, 4, 16 WORD가 아니거나, Issuer 값이 더 좁은 폭에 들어가면 invalid다(Issuer 정규형).
- Issuer가 16 WORD면 전체 17 WORD라 Length 확장 1 WORD가 붙는다.
- Quantifier는 `000`(Identified)만 쓴다. 다른 값은 invalid다.
- Issuer 값은 [Issuer](/ko/grammar/issuer/)의 배정을 따른다.
- Issuer 자신을 가리키는 형식은 ISSUER-POINTER 하나다. `EXTERNAL-ISSUER-*`로 문서 ID `0`, 대상 ID `0`을 써서 Issuer를 가리키는 것은 invalid다.

## 예시

| Issuer | WORD sequence |
|---|---|
| GEUL `0x0000` | `00B0 0000` |
| IEEE `0x0040` | `00B0 0040` |

## 관련 페이지

- [Reference](/ko/grammar/reference/), [DOC-POINTER](/ko/grammar/reference/doc-pointer/), [EXTERNAL-ISSUER](/ko/grammar/reference/external-issuer/), [Issuer와 공표](/ko/grammar/issuer/)
