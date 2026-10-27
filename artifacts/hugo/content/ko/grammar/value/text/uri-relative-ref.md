---
title: "URI-RELATIVE-REF"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI-RELATIVE-REF는 RFC 3986 relative-ref 문법의 ASCII 바이트열을 담는 Value다. IETF Issuer의 형식 번호 0x8000/0x8001을 쓴다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI-RELATIVE-REF는 RFC 3986 `relative-ref` 문법의 ASCII 바이트열을 담는 Value다. base URI와 resolve된 결과는 Payload에 넣지 않는다.

## 레이아웃

- 코드: Value `ISSUER-1WORD`(`0x7C`), Issuer `0x0020` IETF, 형식 번호 `0x8000`(짝수 바이트)·`0x8001`(홀수 바이트). 계열 TEXT.
- 바이트 수는 형식 번호의 최하위 비트와 Payload WORD 수로 정한다. `2 × Payload WORD 수 − 최하위 비트`이며 Byte Count는 두지 않는다([Value](/ko/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length 확장 TAG] 전체 15 WORD 이상일 때
Issuer            1 WORD  0x0020 (IETF)
형식 번호         1 WORD  0x8000/0x8001
Payload WORD 1st ... Nth          relative-ref bytes / final zero padding
```

## 해석과 유효성

- 바이트열은 RFC 3986의 `relative-ref = relative-part [ "?" query ] [ "#" fragment ]` 문법에 맞아야 한다.
- URI 문법의 terminal은 US-ASCII 문자다. 허용된 ASCII 문자는 그대로 저장하고, octet을 percent-encoding할 때는 `pct-encoded = "%" HEXDIG HEXDIG` 형식을 쓴다. 비ASCII 문자를 literal byte로 직접 넣어서는 안 된다.
- `relative-part`가 `path-empty`일 수 있으므로 빈 바이트열도 문법상 유효한 `relative-ref`다.
- base URI, resolution context와 resolve 결과는 이 형식 바깥의 문맥이다.
- WORD 안에서는 상위 byte가 먼저 온다. 바이트 수가 홀수(홀수 코드)이면 마지막 WORD의 사용하지 않는 하위 byte는 `00`이어야 한다.
- Payload WORD 수는 `ceil(바이트 수/2)`다. 홀수 코드인데 마지막 WORD의 하위 byte가 `00`이 아니면 거부한다.

## 표준 근거

- `relative-ref`, URI 문자와 percent-encoding 문법은 [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986)를 따른다.
- 홀짝 코드 쌍, zero padding, GEUL TAG/Length와 16비트 WORD 배치는 이 형식의 framing 규칙이다. base URI와 참조 해석 결과는 RFC의 문맥이지만 Payload에는 넣지 않는다.

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG(있으면), Issuer 1 WORD, 형식 번호 1 WORD와 Payload를 합한 WORD 수다. 14 WORD 이하는 직접 길이, 15 WORD 이상은 `1110`·`1111` 확장 길이를 쓰며, 확장 TAG도 전체 수에 포함한다([Length](/ko/grammar/record/)).
- 0 byte는 빈 `relative-ref`로 의미상 허용되며 Payload WORD가 없다. 그 물리 배치는 아래 열린 문제다.

## 예시

- `a/b?x=1`은 7 byte(홀수)라 형식 번호 `0x8001`, Payload `612f 623f 783d 3100`이다. 전체 7 WORD이므로 `LLLL=0110`이다. 전체는 `0B7C 0020 8001 612f 623f 783d 3100`이다.

## 열린 문제

- 빈 `relative-ref`(0 byte)의 물리 배치. Payload가 없는 레코드가 "최소 Payload 1 WORD" 규칙과 맞지 않아 아직 정하지 않았다.
