---
title: "GEUL"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL은 geul.org가 CC0로 발급하는 엔티티 ID로 대상을 가리키는 선언 Reference다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL은 geul.org가 CC0로 발급하는 엔티티를 가리키는 선언 Reference다. 번호에 의미를 담지 않는 일련 ID다. 비트에 의미를 담는 식별자는 별도 Codec [GEUL-SIDX](/ko/grammar/reference/geul-sidx/)(`0011`)가 맡는다.

## 레이아웃

```
TAG WORD          0000 0LLL L001 0QQQ      CCCC = 0010
[Length 확장 TAG]
GEUL ID           가장 짧은 폭의 unsigned big-endian
```

- 작은 번호를 고빈도 엔티티에 배정한다. 1 WORD에 들어가는 ID는 전체 2 WORD다.
- ID 배정과 레지스트리는 geul.org가 관리한다. 레지스트리에는 CC0 원천에서 나온 것만 넣는다.
- Variable이면 그 종류의 익명 변수다([Reference](/ko/grammar/reference/) Variable).

## 예시

| GEUL ID | WORD sequence |
|---|---|
| 1, Identified | `0090 0001` |
| 1, Variable | `0094 0001` |
| 70000, Generic | `0111 0001 1170` |

## 열린 문제

- GEUL ID 배정 규칙과 레지스트리 공개 형식.

## 관련 페이지

- [Reference](/ko/grammar/reference/), [GEUL-SIDX](/ko/grammar/reference/geul-sidx/)
