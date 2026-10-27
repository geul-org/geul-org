---
title: "IPV6-ADDRESS"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV6-ADDRESS는 IPv6 주소 128bit를 순서 그대로 담는 고정 11 WORD IETF Issuer 형식이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV6-ADDRESS는 IPv6 주소의 128bit 값을 담는 고정 폭 Value다. Value `ISSUER-1WORD`(`0x7C`), Issuer `0x0020` IETF, 형식 번호 `0xC002`, 계열 BINARY다. Payload는 정확히 8 WORD(128bit)다.

## 레이아웃

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  전체 11 WORD
Issuer            1 WORD  0x0020 (IETF)
형식 번호         1 WORD  0xC002
Payload           8 WORD (128비트)  IPv6 address, high-order bit → low-order bit
```

## 해석과 유효성

- 여덟 Payload WORD를 상위 WORD부터 이어 붙여 IPv6 주소 field의 128bit를 순서 그대로 읽는다. 각 WORD에서 먼저 오는 octet이 상위 8bit다.
- Payload는 주소 하나의 128bit만 담는다. CIDR prefix length, port, transport protocol은 담지 않는다.
- zone identifier는 주소의 128bit에 들어 있지 않으므로 Payload에 넣지 않는다. zone이 필요한 scoped address는 interface나 Edge·Reference·Profile 같은 외부 문맥으로 준다.
- 모든 128bit pattern을 표현할 수 있다. unspecified·loopback·multicast·특수·예약 pattern의 운용 의미와 사용 가능성은 외부 문맥에서 판단하며 구조적 유효성을 제한하지 않는다.
- IPV4-ADDRESS와 IPV6-ADDRESS는 별개 형식이다. IPv4-mapped IPv6 주소도 128bit IPv6 값으로 보존하며 IPV4-ADDRESS와 자동 동일시하거나 서로 정규화하지 않는다.
- 이 Value를 Reference의 식별자 구성요소로 쓸 수 있지만, scope와 참조 정책은 주소 bit pattern에 들어 있지 않다.

## 표준 근거

- [RFC 4291 — IP Version 6 Addressing Architecture](https://www.rfc-editor.org/rfc/rfc4291.html)은 IPv6 주소를 128bit identifier로 정의하고 unicast·anycast·multicast, IPv4-mapped IPv6를 포함한 주소 bit format을 정한다. 이 형식은 그 128bit를 재해석하지 않고 보존한다.
- [RFC 8200 — Internet Protocol, Version 6 (IPv6) Specification](https://www.rfc-editor.org/rfc/rfc8200.html)은 IPv6 packet의 Source Address와 Destination Address를 각각 128bit field로 정의한다. Payload WORD는 그 주소 field의 high-order bit부터 low-order bit까지의 순서를 보존한다.
- [RFC 4007 — IPv6 Scoped Address Architecture](https://www.rfc-editor.org/rfc/rfc4007.html)은 non-global address의 zone이 주소 자체에 encode되지 않고 context로 정해진다고 밝힌다. 그래서 zone identifier는 Payload 밖에 둔다.
- RFC 4291의 문자열 표기는 설명과 입출력에만 쓸 수 있다. [RFC 5952 — A Recommendation for IPv6 Address Text Representation](https://www.rfc-editor.org/rfc/rfc5952.html)는 내부 저장 형식을 정하지 않으므로 그 문자열 canonicalization을 이 binary 레코드의 canonicalization으로 쓰지 않는다.
- GEUL TAG, Issuer 배정, 직접 Length, 16bit WORD framing은 이 RFC들의 일부가 아니라 이 형식이 더하는 규칙이다.

## 길이

- 전체는 TAG 1 WORD, Issuer 1 WORD, 형식 번호 1 WORD, Payload 8 WORD를 합한 정확히 11 WORD이고 직접 길이 `LLLL=1010`을 쓴다. Length 확장 TAG, descriptor, padding은 없다.
- Payload가 정확히 8 WORD가 아니면 거부한다.

## 예시

IPv6 주소 `2001:db8::1`:

```
0d7c 0020 c002 2001 0db8 0000 0000 0000 0000 0000 0001
```

- 문자열의 축약 표기는 Payload에 영향을 주지 않는다.
