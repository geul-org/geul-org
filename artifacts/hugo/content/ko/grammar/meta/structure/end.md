---
title: "END"
weight: 16
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "END는 문서를 닫는 1 WORD 구조 Meta다. 모든 문서에 필수다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

문서를 닫는 레코드다.

## 레이아웃

```
TAG WORD          0001 1LLL L000 1111      Codec 0x0F
[Length 확장 TAG]
```

- Codec: Meta `0x0F`, 구조 클래스(`000`)
- Payload: 없음(1 WORD)
- 개수: 문서마다 하나, 맨 끝

## 해석과 유효성

- 필수다. 위치는 [DOC](/ko/grammar/meta/structure/doc/)(`DOC-*`)의 길이로 확인한다.
- END 없이 입력이 끝나면 잘린 문서다. 잘린 문서의 내용을 유효로 볼지는 디코더 정책이다.
- 뒤에 아무것도 오지 않는다.

## 예시

- `0x180F`
