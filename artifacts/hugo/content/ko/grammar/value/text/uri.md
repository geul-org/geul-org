---
title: "URI"
weight: 69
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI는 RFC 3986 URI(scheme 포함 절대 URI) 문법의 ASCII 바이트열을 담는 Value다. 짝수·홀수 바이트 코드 쌍 0x44/0x45를 쓴다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI는 RFC 3986 `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` 문법의 ASCII 바이트열을 담는 Value다. scheme을 포함하므로 해석에 base URI가 필요 없다.

## 레이아웃

- 코드: Value 직접 코드 `0x44`(짝수 바이트)·`0x45`(홀수 바이트). 계열 TEXT.
- 바이트 수는 Codec의 최하위 비트와 Payload WORD 수로 정한다. `2 × Payload WORD 수 − 최하위 비트`이며 Byte Count는 두지 않는다([Value](/ko/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x44/0x45
[Length 확장 TAG] 전체 15 WORD 이상일 때
Payload WORD 1st ... Nth          URI bytes / final zero padding
```

## 해석과 유효성

- 바이트열은 RFC 3986의 `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` 문법에 맞아야 한다. query와 fragment를 포함할 수 있다.
- URI 문법의 terminal은 US-ASCII 문자다. 허용된 ASCII 문자는 그대로 저장하고, octet을 percent-encoding할 때는 `pct-encoded = "%" HEXDIG HEXDIG` 형식을 쓴다. 비ASCII 문자를 literal byte로 직접 넣어서는 안 된다.
- `scheme`과 `:`을 반드시 포함한다. 상대 참조는 [URI-RELATIVE-REF](/ko/grammar/value/text/uri-relative-ref/)(IETF 형식 번호 `0x8000`·`0x8001`)를 쓴다.
- RFC 3986의 URI production은 빈 문자열을 허용하지 않는다. 0 byte 레코드는 유효하지 않다.
- WORD 안에서는 상위 byte가 먼저 온다. 바이트 수가 홀수(홀수 코드)이면 마지막 WORD의 사용하지 않는 하위 byte는 `00`이어야 한다.
- Payload WORD 수는 `ceil(바이트 수/2)`다. 홀수 코드인데 마지막 WORD의 하위 byte가 `00`이 아니면 거부한다.

## 표준 근거

- `URI`, URI 문자와 percent-encoding 문법은 [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986)를 따른다.
- 홀짝 코드 쌍, zero padding, GEUL TAG/Length와 16비트 WORD 배치는 이 형식의 framing 규칙이다.

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG(있으면)와 Payload를 합한 WORD 수다. 14 WORD 이하는 직접 길이, 15 WORD 이상은 `1110`·`1111` 확장 길이를 쓰며, 확장 TAG도 전체 수에 포함한다([Length](/ko/grammar/record/)).

## 예시

- `https://example.com/`은 ASCII 20 byte(짝수)이므로 `URI-EVEN`(`0x44`)이다.
- Payload는 `6874 7470 733a 2f2f 6578 616d 706c 652e 636f 6d2f`의 10 WORD다.
- TAG 1 WORD와 Payload 10 WORD를 합쳐 전체 11 WORD이므로 `LLLL=1010`이다. 전체는 `0D44 6874 7470 733a 2f2f 6578 616d 706c 652e 636f 6d2f`다.

## GEUL Archive URI

`archive.geul.org`는 GEUL에서 외부 바이너리·문서 같은 대형 콘텐츠를 참조하기 위한 불변 콘텐츠 저장소다. 권장 주소 형식은 `https://archive.geul.org/sha256/{digest}`다. 같은 바이트열은 같은 URI를 가져야 하며, 게시한 뒤 같은 URI의 바이트를 바꿔서는 안 된다.

URI Value는 외부 콘텐츠의 위치나 주소 문자열을 나타낼 뿐, 대상 자체의 동일성이나 불변성을 보장하지 않는다. 인라인 Value의 최대 범위를 넘는 바이너리와 텍스트는 archive URI로 참조할 수 있다. 저장 객체의 메타데이터에는 다음 항목을 기록해야 한다.

- 원본 URI와 수집 시각
- SHA-256과 Byte Length
- MIME type
- license identifier와 version
- 저작자, 출처와 고지
- 라이선스 근거 URI와, 필요하면 수집 당시의 근거 사본

수집 가능 여부는 무료로 접근할 수 있는지가 아니라 재배포 권한이 명시적으로 확인되는지로 판단한다. 저작자 표시, 비영리, 변경 금지, 동일 조건 등 적용되는 라이선스 조건을 지켜야 한다. 문서와 콘텐츠에는 Creative Commons 같은 명시적 라이선스를 기록하고, 소프트웨어에는 가능하면 SPDX License ID를 쓴다.

권리 문제나 정정으로 제공을 중단하더라도 기존 URI에 다른 바이트를 넣어서는 안 된다. 그 URI는 중단 사유와 시각을 담은 tombstone을 반환하고, 원본 digest와 감사 기록을 보존해야 한다. 다만 법적 의무가 감사 기록의 보존을 금지하면 그 의무를 우선한다.

archive URI는 접근 위치와 콘텐츠 digest를 함께 제공한다. 이 content-address와 불변성 규칙은 GEUL Archive profile의 정책이며, URI Value의 일반 문법은 `archive.geul.org`에 종속되지 않는다.
