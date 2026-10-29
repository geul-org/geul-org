---
title: "LANGUAGE-SHORT-CODE"
weight: 73
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE는 primary language subtag만 1 WORD로 압축해 담는 GEUL 언어 코드 Value다(Codec 0x48)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-SHORT-CODE는 BCP 47 전체 tag가 아니라 primary language subtag만 담는 GEUL 압축 언어 코드다. Payload는 정확히 1 WORD다.

## 레이아웃

- 코드: Value 직접 코드 `0x48`. 계열 TEXT.
- Payload는 정확히 1 WORD의 unsigned 16비트 코드다.

```
TAG WORD          0x08C8 (0000 1000 1100 1000)  전체 2 WORD
Payload WORD 1st (16비트)           GEUL language code (uint16)
```

## 해석과 유효성

- Payload 1 WORD를 unsigned 16비트 정수로 읽는다.
- 이 값은 primary language subtag의 압축 코드다. script, region, variant, extension, private-use는 담지 않는다. 그런 정보가 필요하면 [LANGUAGE-BCP47-CODE](/ko/grammar/value/text/language-bcp47-code/)(`0x46`·`0x47`)를 쓴다.
- `0x0000..0xfffe`는 GEUL Language Registry 배정 범위다. 이 범위 안에서도 해당 registry version에 실제로 배정되지 않은 값은 invalid다.
- 초기 배정 대상은 특정 IANA Language Subtag Registry snapshot의 `Type: language` 가운데 `Scope: private-use`를 뺀 공개 레코드다. collections, macrolanguage, special은 빼지 않는다.
- 초기 배정은 그 공개 레코드를 ASCII subtag 순으로 정렬해 ID를 붙인다. IANA 파일의 물리 순서는 ID 규칙이 아니다.
- 이후 새 `Type: language` subtag는 기존 번호를 바꾸지 않고 끝에 덧붙인다(append-only).
- deprecated language subtag의 ID는 지우거나 재사용하지 않는다. Preferred-Value 관계와 deprecated 상태는 registry metadata로 보존한다.
- `0xffff`는 확장 escape로 예약한다. 확장 형식이 따로 정의되기 전까지 독립 LANGUAGE-SHORT-CODE Value에서는 invalid다. `null`, `unknown`, `und` 같은 뜻으로 쓰지 않는다.
- 장차 다른 Codec 규격이 `0xffff` 뒤의 해석 규칙을 정의할 수는 있다. 그러나 그 규칙이 이 형식의 Payload 길이를 늘리거나 뒤따르는 Payload를 허용한다는 뜻은 아니다.
- Codec 규격은 같은 1 WORD 코드를 TAG 없는 날값 필드로 담을 수 있다(날값 필드의 [CODEC](/ko/grammar/codec-spec/#codec)). 이는 그 Codec 규격의 규칙이며, 독립 Value의 wire form은 언제나 TAG 1 WORD + Payload 1 WORD다.
- 값의 의미를 판정하려면 사용한 GEUL Language Registry version과, 그 version이 고정한 IANA registry snapshot 날짜를 함께 보존해야 한다.

## 표준 근거

- primary language subtag의 원천 registry와 deprecated/Preferred-Value metadata는 [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry)를 따른다.
- BCP 47 language subtag 체계의 기본 의미는 [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646)를 따른다.
- ASCII 정렬 append-only ID 부여, `0xffff` 예약, TAG 없는 날값 필드 embedding과의 구분은 GEUL 규칙이다.

## 길이

- 전체는 TAG 1 WORD와 Payload 1 WORD를 합한 정확히 2 WORD이고 직접 길이 `LLLL=0001`을 쓴다. Length 확장 TAG, descriptor, padding은 없다.
- Payload가 정확히 1 WORD가 아니면 거부한다.

## 예시

- registry snapshot과 실제 코드표가 아직 정해지지 않았으므로, 특정 언어의 숫자 ID 예시는 싣지 않는다.

## 열린 문제

- 초기 IANA snapshot 날짜, GEUL Language Registry version 이름, 전체 매핑표. 정해지기 전까지 구체적인 숫자 예시나 코드표는 확정하지 않는다.
