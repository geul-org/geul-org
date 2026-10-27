---
title: "UUID"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "UUID는 RFC 9562 UUID의 128bit 값을 canonical 16 octet 그대로 담는 고정 9 WORD Value다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UUID는 RFC 9562 UUID의 128bit 값을 담는 고정 폭 Value다. Value 직접 코드 `0x60`, 계열 BINARY다. Payload는 정확히 8 WORD(16 octet, 128bit)다.

## 레이아웃

```
TAG WORD          0x0C60 (0000 1100 0110 0000)  전체 9 WORD
Payload           8 WORD (128비트)  UUID octet 0 → octet 15
```

## 해석과 유효성

- RFC 9562의 canonical UUID octet 0부터 octet 15까지를 순서대로 두 octet씩 묶는다. 먼저 오는 octet이 WORD의 상위 8bit다. UUID의 field, version bit, variant bit를 재배열하거나 다시 encode하지 않는다.
- `8-4-4-4-12` hex-and-dash 문자열은 입출력 표현일 뿐이다. 대소문자나 dash는 Payload에 들어가지 않고, 파싱 결과인 16 octet만 저장한다.
- 이 UUID Value는 128bit pattern을 손실 없이 보존한다. RFC 9562 variant `10xx`에서 version 1, 3, 4, 5, 6, 7은 표준 layout이고 version 8은 custom UUID format이다. version 2는 DCE Security용으로 예약되어 RFC가 layout을 정하지 않으며, version 0은 unused, version 9–15는 future definition용 예약이다. 다른 variant도 호환 또는 미래 정의용으로 예약되어 있다.
- Nil UUID는 128bit all-zero, Max UUID는 128bit all-one인 특수값이다. 예약·unused version/variant를 포함한 128bit pattern도 구조적으로 배제하지 않으며, 그 pattern의 의미와 상호운용 가능성은 적용 표준과 외부 문맥에서 판단한다.
- UUID 동일성은 Payload의 128bit 값이 같은지로 판단한다. 같은 값이라는 사실은 대상의 인증, 소유권, 현재 존재, 해결 가능성, 접근 권한을 보장하지 않는다.
- Microsoft COM GUID를 저장할 때 mixed-endian 메모리·직렬화 표현을 그대로 복사하지 않는다. 먼저 RFC 9562 canonical field/octet 순서의 16 octet으로 바꾼다.
- Payload가 정확히 8 WORD가 아니면 거부한다.

## 표준 근거

- [RFC 9562 — Universally Unique IDentifiers (UUIDs)](https://www.rfc-editor.org/rfc/rfc9562.html)은 UUID를 16 octet(128bit)으로 정의하고, field를 most-significant-byte-first로 encode해 binary format에서 big-endian field 순서로 잇게 한다. variant는 octet 8의 상위 bit, version은 octet 6의 상위 4bit에 있으며 이 형식은 그 위치를 그대로 보존한다.
- RFC 9562 Sections 4.1–5.10은 variant와 version 1–8, Nil, Max, 예약 범위를 구분한다. RFC 9562는 RFC 4122를 대체하므로 이 형식의 현행 규범은 RFC 9562다.
- RFC 9562의 hex-and-dash ABNF는 text 표현이며, COM GUID little-endian caveat도 따로 밝힌다. GEUL은 RFC UUID의 canonical 16 octet만 Payload에 넣는다.
- GEUL TAG, 직접 Length, 16bit WORD framing은 RFC 9562의 일부가 아니라 이 형식이 더하는 규칙이다.

## 길이

- 전체는 TAG 1 WORD와 Payload 8 WORD를 합한 정확히 9 WORD이고 직접 길이 `LLLL=1000`을 쓴다. Length 확장 TAG, descriptor, padding은 없다.
- Payload가 정확히 8 WORD가 아니면 거부한다.

## 예시

RFC 9562 Appendix A.6의 UUIDv7 test vector `017f22e2-79b0-7cc3-98c4-dc0c0c07398f`:

```
0c60 017f 22e2 79b0 7cc3 98c4 dc0c 0c07 398f
```

- TAG `0c60`, Payload `017f 22e2 79b0 7cc3 98c4 dc0c 0c07 398f`.
