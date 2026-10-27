---
title: "USAGE"
weight: 86
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "USAGE는 학습 금지, 상업적 이용 금지 같은 사용 제한을 적는 정책 Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

사용 제한을 적는다(예: 학습 금지, 상업적 이용 금지).

## 레이아웃

```
TAG WORD          0001 1LLL L101 0101      Codec 0x55
[Length 확장 TAG]
Payload           사용 제한을 나타내는 텍스트 또는 Reference
```

- Codec: Meta `0x55`, 정책 클래스(`101`)
- Payload: 내장 Value 또는 Reference
- 개수: 여럿 가능

## 열린 문제

- 제한 종류 코드표.
