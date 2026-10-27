---
title: "SOURCE"
weight: 39
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "SOURCE는 문서 전체의 원천 자료를 Reference 또는 URI와 선택적 다이제스트로 적는 출처 Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

문서 전체의 원천 자료를 적는다. 레코드 단위 원천은 근거 Edge `RECORD-SOURCE`가 맡는다.

## 레이아웃

```
TAG WORD          0001 1LLL L010 0110      Codec 0x26
[Length 확장 TAG]
원천              Reference 또는 URI Value 레코드 1개
다이제스트        SHA-256-DIGEST Value, 또는 생략 표지 0x0000 (선택 필드)
```

- Codec: Meta `0x26`, 출처 클래스(`010`)
- Payload: 원천(Reference 또는 [URI](/ko/grammar/value/text/uri/) Value) + 다이제스트([SHA-256-DIGEST](/ko/grammar/value/binary/sha-256-digest/), 선택)
- 개수: 여럿 가능

## 해석과 유효성

- 외부 자료의 특정 판본에 고정하려면 다이제스트를 둔다(git submodule). 원천이 Reference여도 다이제스트로 그 내용을 고정할 수 있다.
- 다이제스트를 모르거나 두지 않으면 그 자리에 없음 표지 `0x0000`을 쓴다([CODEC](/ko/grammar/edge/codec/) 선택 필드). geul.org 규격 `0x1826`은 원천(`0780`·`0844`·`0845`)과 다이제스트(`0861`·`0000`)의 두 레코드 필드다.
- 원천의 라이선스가 GEUL과 다르면 [LICENSE](/ko/grammar/meta/policy/license/)로 원래 라이선스를 적는다.

## 예시

- 위키데이터 덤프 URI, 다이제스트 생략: `SOURCE  URI 레코드  0000`

## 열린 문제

- SHA-256 말고 다른 다이제스트(SHA1-DIGEST 등)를 받을지.
