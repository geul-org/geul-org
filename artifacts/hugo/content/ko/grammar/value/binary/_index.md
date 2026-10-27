---
title: "Value — 바이너리"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BINARY 계열(Codec `0x60`~`0x7B`, 형식 번호 `0xC000`~`0xFFFF`)의 형식: UUID, 다이제스트, CRC, 네트워크 주소, 불명 바이트열, 비트 벡터."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BINARY 계열은 바이트열 형식이다. 직접 코드 `0x60`~`0x7B`, Issuer 형식 번호 `0xC000`~`0xFFFF`에 둔다.

- UUID, SHA-256, SHA-1은 직접 코드다. 나머지 다이제스트, CRC32C, IPv4·IPv6·MAC 주소, 불명 바이트열, 비트 벡터는 Issuer 형식이다.
- 고정 크기 값(UUID, 다이제스트, 주소)은 크기가 정해져 있어 짝수·홀수 쌍을 두지 않는다.
- 바이트열 안의 저작물은 원래 라이선스를 따른다. 출처와 라이선스는 Meta로 기록한다.
