---
title: "SOURCE-SPAN"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "SOURCE-SPAN은 바로 앞 SOURCE가 가리키는 원천 자료 안의 대응 범위(시작, 길이)를 적는 출처 Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

원천 자료 안의 대응 범위를 적는다. 예: 원문 문장의 10~25번째 byte.

## 레이아웃

```
TAG WORD          0001 1LLL L010 0111      Codec 0x27
[Length 확장 TAG]
시작              UNSIGNED-INTEGER Value (byte 오프셋)
길이              UNSIGNED-INTEGER Value (byte 수)
```

- Codec: Meta `0x27`, 출처 클래스(`010`)
- Payload: 내장 Value([UNSIGNED-INTEGER](/ko/grammar/value/numeric/unsigned-integer/) 둘)
- 개수: [SOURCE](/ko/grammar/meta/provenance/source/)마다 하나

## 해석과 유효성

- 바로 앞의 `SOURCE`를 가리킨다.

## 열린 문제

- 단위(byte, 문자, 줄)와 원천 종류별 기준.
- 앞의 SOURCE에 묶는 방식을 Payload 안 참조로 바꿀지.
