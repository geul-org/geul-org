---
title: "SIGNATURE"
weight: 66
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "SIGNATURE는 문서의 내용 해시에 대한 서명을 알고리즘 ID, 서명자, 서명으로 적는 검증 Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

문서의 내용 해시에 대한 서명이다(git 서명 커밋·태그).

## 레이아웃

```
TAG WORD          0001 1LLL L100 0001      Codec 0x41
[Length 확장 TAG]
알고리즘 ID       1 WORD (0x0001 = Ed25519)
서명자            ISSUER-POINTER(Issuer) Reference 레코드
서명              나머지 전부. 폭은 알고리즘이 정한다 (Ed25519 32 WORD)
```

- Codec: Meta `0x41`, 검증 클래스(`100`)
- Payload: 알고리즘 ID(날값 1 WORD) + 서명자(내장 Reference) + 서명(날값, 나머지)
- 개수: 여럿 가능

## 해석과 유효성

- 서명 대상은 내용 해시다. BODY만 서명하지 않는다([서명](/ko/grammar/issuer/#서명)).
- 검증 클래스라 내용 해시에서 빠진다. 서명을 더해도 해시가 같다.
- "서명이 있으면 확인"이 아니라 "정해진 키의 서명이 있어야 한다"로 검증한다.
- 버전 목록 문서는 공표처가 서명한다.
- 서명자는 Issuer 자신을 가리키는 [ISSUER-POINTER](/ko/grammar/reference/issuer-pointer/)(Issuer)다. Reference 레코드라 자기 Length로 끝나므로, 서명 폭이 알고리즘마다 달라도 레이아웃이 하나로 정해진다([DECLARE](/ko/grammar/edge/declare/) 나머지 필드).
- 서명의 WORD 수가 알고리즘이 정한 폭과 다르면 invalid다.

## 열린 문제

- 서명 시각을 함께 서명할지.
