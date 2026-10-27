---
title: "IPV4-ADDRESS"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV4-ADDRESS는 IPv4 주소 32bit를 network byte order 그대로 담는 고정 5 WORD IETF Issuer 형식이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV4-ADDRESS는 IPv4 주소의 32bit 값을 담는 고정 폭 Value다. Value `ISSUER-1WORD`(`0x7C`), Issuer `0x0020` IETF, 형식 번호 `0xC001`, 계열 BINARY다. Payload는 정확히 2 WORD(32bit)다.

## 레이아웃

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  전체 5 WORD
Issuer            1 WORD  0x0020 (IETF)
형식 번호         1 WORD  0xC001
Payload           2 WORD  address octet 1–2 │ address octet 3–4
```

## 해석과 유효성

- 주소 octet을 network byte order 그대로 둔다. 각 WORD에서 먼저 오는 octet이 상위 8bit, 다음 octet이 하위 8bit다.
- Payload는 주소 하나의 32bit만 담는다. CIDR prefix length, port, transport protocol은 담지 않는다.
- 모든 32bit pattern을 표현할 수 있다. unspecified·특수·예약·멀티캐스트 같은 pattern의 운용 의미와 사용 가능성은 외부 문맥에서 판단하며 구조적 유효성을 제한하지 않는다.
- IPV4-ADDRESS와 IPV6-ADDRESS는 별개 형식이다. IPv4-mapped IPv6 주소를 이 형식으로 자동 변환하거나 같은 값으로 정규화하지 않는다.
- 이 Value를 Reference의 식별자 구성요소로 쓸 수 있지만, 그 참조 정책과 수명은 주소 bit pattern에 들어 있지 않다.
- Payload가 정확히 2 WORD가 아니면 거부한다.

## 표준 근거

- [RFC 791 — Internet Protocol](https://www.rfc-editor.org/rfc/rfc791.html)은 IPv4 주소를 4 octet(32bit) 고정 길이로 정의하고 Source Address와 Destination Address를 각각 32bit field로 정의한다. Appendix B의 octet 전송 순서와 각 octet의 most-significant-bit-first 규칙을 Payload에 보존한다.
- GEUL TAG, Issuer 배정, 16bit WORD 묶음, Length는 RFC 791의 일부가 아니라 이 형식이 더하는 framing 규칙이다.

## 길이

- 전체는 TAG 1 WORD, Issuer 1 WORD, 형식 번호 1 WORD, Payload 2 WORD를 합한 정확히 5 WORD이고 직접 길이 `LLLL=0100`을 쓴다. Length 확장 TAG, descriptor, padding은 없다.
- Payload가 정확히 2 WORD가 아니면 거부한다.

## 예시

IPv4 주소 `1.2.3.4`:

```
0a7c 0020 c001 0102 0304
```
