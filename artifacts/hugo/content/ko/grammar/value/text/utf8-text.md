---
title: "UTF8-TEXT"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-TEXT는 언어가 없는 UTF-8 문자열을 담는 Value다. 짝수·홀수 바이트 코드 쌍 0x40/0x41을 쓴다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-TEXT는 RFC 3629의 valid UTF-8 바이트열을 담는 Value다. 식별자, 코드, 파일 이름처럼 언어가 없는 문자열에 쓴다.

## 레이아웃

- 코드: Value 직접 코드 `0x40`(짝수 바이트)·`0x41`(홀수 바이트). 계열 TEXT.
- 바이트 수는 Codec의 최하위 비트와 Payload WORD 수로 정한다. `2 × Payload WORD 수 − 최하위 비트`이며 Byte Count는 두지 않는다([Value](/ko/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x40/0x41
[Length 확장 TAG] 전체 15 WORD 이상일 때
Payload WORD 1st ... Nth          UTF-8 bytes / final zero padding
```

## 해석과 유효성

- 바이트열은 RFC 3629 문법에 맞는 well-formed shortest-form UTF-8이어야 한다. 디코딩 결과는 `U+0000..U+10FFFF` 범위의 Unicode scalar value만 포함하며, surrogate 범위 `U+D800..U+DFFF`는 포함하지 않는다.
- RFC 3629는 문맥에 따른 선두 U+FEFF signature 처리를 설명한다. GEUL canonical profile은 여기에 더해 Payload 선두의 UTF-8 BOM 바이트열 `EF BB BF`를 금지한다. 다른 위치의 U+FEFF는 BOM이 아니라 문자이므로 이 규칙으로 금지하지 않는다.
- Unicode normalization은 강제하지 않는다. 디코딩한 원문 scalar sequence를 그대로 보존한다.
- 유효한 UTF-8 바이트열을 변환 없이 Payload에 둔다. WORD 안에서는 상위 byte가 먼저 온다. 바이트 수가 홀수(홀수 코드)이면 마지막 WORD의 사용하지 않는 하위 byte는 `00`이어야 한다.
- Payload WORD 수는 `ceil(바이트 수/2)`다. 홀수 코드인데 마지막 WORD의 하위 byte가 `00`이 아니면 거부한다.

## 표준 근거

- UTF-8의 scalar 범위, well-formed 바이트열, BOM 처리 의미는 [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629)를 따른다.
- BOM 금지, 홀짝 코드 쌍, zero padding, GEUL TAG/Length와 16비트 WORD 배치는 이 형식의 canonical framing 규칙이다.

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG(있으면)와 Payload를 합한 WORD 수다. 14 WORD 이하는 직접 길이, 15 WORD 이상은 `1110`·`1111` 확장 길이를 쓰며, 확장 TAG도 전체 수에 포함한다([Length](/ko/grammar/record/)).
- 0 byte 문자열은 짝수 코드의 1 WORD 레코드(TAG WORD만)로 쓴다([Value](/ko/grammar/value/)).

## 예시

- `A`(`41`)는 1 byte(홀수)라 `UTF8-TEXT-ODD`(`0x41`), Payload `4100`, 전체 2 WORD, `LLLL=0001`이다. 전체는 `08C1 4100`이다.
- 빈 문자열은 `0840`(`UTF8-TEXT-EVEN`, TAG WORD만) 1 WORD다.
