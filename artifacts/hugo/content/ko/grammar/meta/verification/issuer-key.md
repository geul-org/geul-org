---
title: "ISSUER-KEY"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "ISSUER-KEY는 자체 발급(16 WORD) Issuer의 서명 알고리즘 ID와 공개키를 선언하는 검증 Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

자체 발급(16 WORD) Issuer의 공개키를 선언한다. Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ 알고리즘 ID ‖ 공개키)다([16 WORD Issuer](/ko/grammar/issuer/#16-word-issuer)).

## 레이아웃

```
TAG WORD          0001 1LLL L100 0000      Codec 0x40
[Length 확장 TAG]
알고리즘 ID       1 WORD (0x0001 = Ed25519)
공개키            알고리즘이 정한 폭 (Ed25519 16 WORD)
```

- Codec: Meta `0x40`, 검증 클래스(`100`)
- Payload: 날값(알고리즘 ID + 공개키)
- 개수: 여럿 가능(키 교체)

## 해석과 유효성

- 검증 클래스라 내용 해시에서 빠진다.
- 1·2·4 WORD Issuer는 geul.org에 등록한 키를 쓰므로 필요 없다.
