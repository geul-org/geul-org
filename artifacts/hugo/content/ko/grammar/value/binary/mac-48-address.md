---
title: "MAC-48-ADDRESS"
weight: 1007
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "MAC-48-ADDRESS는 48bit IEEE 802 MAC 주소를 octet 순서 그대로 담는 고정 6 WORD IEEE Issuer 형식이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

MAC-48-ADDRESS는 48-bit IEEE 802 MAC 주소 값을 담는 고정 폭 Value다. Value `ISSUER-1WORD`(`0x7C`), Issuer `0x0040` IEEE, 형식 번호 `0xC000`, 계열 BINARY다. Payload는 정확히 3 WORD(6 octet, 48bit)다.

## 레이아웃

```
TAG WORD          0x0AFC (0000 1010 1111 1100)  전체 6 WORD
Issuer            1 WORD  0x0040 (IEEE)
형식 번호         1 WORD  0xC000
Payload           3 WORD  octet 0 → 1 │ octet 2 → 3 │ octet 4 → 5
```

## 해석과 유효성

- 48-bit MAC 주소의 여섯 octet을 표기 문자열과 LAN 전송의 octet 순서 그대로 둔다. octet 0–1, 2–3, 4–5를 각각 WORD의 상위 octet에서 하위 octet 순서로 묶는다.
- IEEE 802 매체에서는 각 octet의 least-significant bit가 먼저 전송되지만, 이를 이유로 octet 안의 bit를 뒤집지 않는다. I/G와 U/L은 octet 0의 least-significant bit와 그다음 bit에 그대로 남는다.
- I/G=0은 individual 주소이며 destination에서 unicast로, I/G=1은 group 주소이며 multicast나 broadcast로 쓰인다. U/L=0은 universally administered, U/L=1은 locally administered 주소다.
- I/G나 U/L 값 때문에 구조적으로 배제하는 pattern은 없다. universally/locally administered, individual/group 주소를 모두 표현하며, locally administered·randomized·spoofed·virtual MAC 주소도 48bit 값으로 표현할 수 있다.
- 이 값은 관측되거나 제시된 주소의 48bit만 보존한다. 특정 기기의 영구 주소, 전 세계적 유일성, 기기·사용자 인증, 소유권, 같은 기기와의 지속적 결합을 보장하지 않는다.
- 이 형식은 정확히 48bit인 IEEE 802 MAC 주소만 다룬다. EUI-64와 다른 64-bit MAC 주소는 담지 않는다. IEEE RA는 역사적 용어 `MAC-48`을 obsolete로 설명하지만, 모든 48-bit MAC 주소를 EUI-48이라 부를 수 있는 것은 아니므로 이 형식을 EUI-48과 자동 동일시하지 않는다.
- Payload가 정확히 3 WORD가 아니면 거부한다.

## 표준 근거

- IEEE Registration Authority의 [Standard Group MAC Addresses](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/macgrp.pdf)는 48-bit LAN MAC 주소를 전송 순서의 여섯 octet으로 표기하고, 각 octet이 least-significant bit부터 전송되며 I/G와 U/L이 첫 octet의 두 least-significant bit임을 설명한다. 이 형식은 octet과 bit 위치를 그대로 보존한다.
- IEEE Registration Authority의 [Guidelines for Use of EUI, OUI, and CID](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/eui.pdf)는 I/G=0/1을 individual/group, U/L=0/1을 universal/local administration으로 정의하고 local 주소가 전역 유일하지 않음을 설명한다. `MAC-48`과 EUI-48의 역사적 용어 관계와 차이도 설명한다.
- [IEEE SA — MAC Addresses](https://standards.ieee.org/products-programs/regauth/mac/)는 EUI-48·EUI-64가 MAC 주소 등으로 쓰일 수 있음을 설명한다. 이는 EUI-64를 이 48-bit 레코드에 넣는다는 뜻이 아니다.
- [RFC 9724 — State of Affairs for Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9724.html)와 [RFC 9797 — Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9797.html)는 실제 장치가 locally administered MAC 주소를 무작위로 만들고 바꿀 수 있음을 기록한다. 그래서 MAC 값만으로 영구적인 기기 identity를 추론하지 않는다.
- GEUL TAG, Issuer 배정, 직접 Length, 16bit WORD framing은 IEEE 802나 위 자료의 일부가 아니라 이 형식이 더하는 규칙이다.

## 길이

- 전체는 TAG 1 WORD, Issuer 1 WORD, 형식 번호 1 WORD, Payload 3 WORD를 합한 정확히 6 WORD이고 직접 길이 `LLLL=0101`을 쓴다. Length 확장 TAG, descriptor, padding은 없다.
- Payload가 정확히 3 WORD가 아니면 거부한다.

## 예시

locally administered individual(unicast) 주소 `02:00:5e:10:00:00`(첫 octet `0x02`의 I/G=0, U/L=1):

```
0afc 0040 c000 0200 5e10 0000
```
