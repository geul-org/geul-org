---
title: "LANGUAGE-BCP47-CODE"
weight: 71
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-BCP47-CODE는 완전한 BCP 47 language tag를 ASCII 바이트열로 담는 Value다. 짝수·홀수 바이트 코드 쌍 0x46/0x47을 쓴다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-BCP47-CODE는 완전한 BCP 47 language tag를 담는 Value다. script, region, variant까지 언어를 정확히 적을 때 쓴다.

## 레이아웃

- 코드: Value 직접 코드 `0x46`(짝수 바이트)·`0x47`(홀수 바이트). 계열 TEXT.
- 바이트 수는 Codec의 최하위 비트와 Payload WORD 수로 정한다. `2 × Payload WORD 수 − 최하위 비트`이며 Byte Count는 두지 않는다([Value](/ko/grammar/value/)).
- Payload는 UTF-8 텍스트가 아니라 BCP 47 tag의 ASCII 바이트열이다.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x46/0x47
[Length 확장 TAG] 전체 15 WORD 이상일 때
Payload WORD 1st ... Nth          BCP 47 tag bytes / final zero padding
```

## 해석과 유효성

- 바이트열은 RFC 5646의 well-formed BCP 47 language tag여야 한다. 빈 문자열은 허용하지 않는다.
- Payload는 ASCII 문자, 숫자, hyphen-minus `-`만 쓴다. 구분자는 반드시 ASCII `-`이며 `_`, 공백, 비ASCII 문자는 허용하지 않는다.
- BCP 47 tag 비교는 대소문자를 구분하지 않는다. GEUL canonical profile은 구분자를 모두 `-`로 쓰고, language/extlang/variant/extension/private-use subtag는 소문자, script는 Titlecase, region은 대문자로 직렬화한다.
- well-formed만으로는 충분하지 않다. registered subtag와 grandfathered tag의 유효성은 특정 IANA Language Subtag Registry snapshot을 기준으로 판정하고, 그 snapshot 날짜나 registry version을 함께 보존해야 한다.
- private-use tag와 private-use subtag는 RFC 5646 문법으로 well-formed이면 허용한다. 다만 그 의미는 당사자 합의에 달려 있고 IANA registry가 정의하지 않으므로 공용 상호운용을 보장하지 않는다.
- 같은 snapshot에서 deprecated subtag나 grandfathered tag에 Preferred-Value가 있으면, canonical GEUL form은 그 치환값을 canonical casing으로 쓴다. deprecated 표기 그대로의 tag는 입력으로 해석할 수는 있어도 canonical 저장형은 아니다.
- BCP 47은 ASCII profile이므로 UTF-8 NFC 같은 Unicode normalization 요구는 적용하지 않는다.
- WORD 안에서는 상위 byte가 먼저 온다. 바이트 수가 홀수(홀수 코드)이면 마지막 WORD의 사용하지 않는 하위 byte는 `00`이어야 한다.
- Payload WORD 수는 `ceil(바이트 수/2)`다. 홀수 코드인데 마지막 WORD의 하위 byte가 `00`이 아니면 거부한다.

## 표준 근거

- language tag 문법, 대소문자 무구분 해석, deprecated/Preferred-Value 개념은 [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646)를 따른다.
- tag 유효성을 판정하는 registry는 [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry)다.
- 홀짝 코드 쌍, zero padding, canonical casing 저장 정책과 Length 계산은 GEUL framing 규칙이다.

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG(있으면)와 Payload를 합한 WORD 수다. 14 WORD 이하는 직접 길이, 15 WORD 이상은 `1110`·`1111` 확장 길이를 쓰며, 확장 TAG도 전체 수에 포함한다([Length](/ko/grammar/record/)).

## LANGUAGE-SHORT-CODE와의 관계

- primary language subtag만 짧게 담으려면 [LANGUAGE-SHORT-CODE](/ko/grammar/value/text/language-short-code/)를 쓴다.
- script, region, variant, extension, private-use가 필요하면 LANGUAGE-BCP47-CODE를 쓴다.
- LANGUAGE-SHORT-CODE registry에 아직 배정되지 않은 언어, `0xffff` escape가 필요한 경우, full tag의 원문 보존이 필요한 경우에도 LANGUAGE-BCP47-CODE를 쓴다.

## 예시

- `ko-KR`은 ASCII 5 byte(홀수)이므로 `LANGUAGE-BCP47-CODE-ODD`(`0x47`), Payload는 `6b6f 2d4b 5200`이다.
- TAG 1 WORD, Payload 3 WORD로 전체 4 WORD이며 `LLLL=0011`이다. 전체는 `09C7 6b6f 2d4b 5200`이다.
