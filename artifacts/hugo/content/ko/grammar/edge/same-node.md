---
title: "SAME-NODE"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SAME-NODE는 두 Reference가 같은 대상을 지시한다고 선언하는 방향 없는 동일성 서술 Edge다(Codec 0x01)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SAME-NODE는 두 Reference가 같은 referent를 지시한다고 선언하는 방향 없는 동일성 서술 Edge다. Codec `0x01`.

두 Reference 레코드의 byte 인코딩, Codec, ID가 같다는 뜻이 아니다. [REFERENCE-NODE](/ko/grammar/edge/reference-node/)가 `Reference → 레코드`의 방향성 바인딩인 것과 달리, SAME-NODE는 두 Reference 사이의 동일성(referential identity)을 나타낸다.

## 레이아웃

```
TAG WORD          0001 0LLL L000 0001
[Length 확장 TAG]
Edge Id           LOCAL Reference 레코드
Subject           Reference 레코드 1개
Object            Reference 레코드 1개
```

## 해석과 유효성

- Subject와 Object는 이 순서로 직렬화하며, 각각 정확히 하나의 완전한 [Reference](/ko/grammar/reference/) 레코드여야 한다. 각 레코드의 Length로 경계를 찾는다.
- Subject나 Object가 Value, Edge, 불완전한 레코드이면 invalid다.
- SAME-NODE 관계는 반사적·대칭적·추이적이다. wire의 Subject/Object 순서는 framing을 위한 것이며 의미 방향을 만들지 않는다. 구현체는 이 관계를 양방향으로 탐색할 수 있어야 한다.
- 서로 다른 [LOCAL](/ko/grammar/reference/local/) ID는 서로 다른 Reference일 뿐, referent가 같거나 다르다는 증거가 아니다. 두 Reference가 같은 referent를 지시한다는 것은 SAME-NODE로 밝힌다.
- 해석과 추론은 그 Edge를 담은 문서와 판정 그래프의 출처, 시점, world, policy scope를 보존해야 한다. SAME-NODE를 문맥과 무관한 전역 병합의 근거로 쓰지 않는다.
- SAME-NODE가 있어도 원래 Reference 레코드나 계보를 지우거나 덮어쓰지 않는다.
- 같은 쌍에 SAME-NODE와 [DIFFERENT-NODE](/ko/grammar/edge/different-node/)가 함께 있어도 wire가 invalid인 것은 아니다. 각 주장의 문맥을 보존해 충돌로 평가한다.
- Variable Reference를 Identified Reference와 SAME-NODE로 이어 변수를 해소한다([Reference](/ko/grammar/reference/) Variable).

## 길이

```
전체 = 1 + N_len + N_id + N_subject + N_object WORD
```

## 예시 (비규범)

Edge Id `0009`, Subject는 LOCAL 1, Object는 LOCAL 2다.

- Edge는 TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD, `LLLL=0110`이다. TAG는 `0001 0 0110 0000001` = `1301`이다.

```
1301 0088 0009 0088 0001 0088 0002
```

## 관련 페이지

- [Edge](/ko/grammar/edge/), [REFERENCE-NODE](/ko/grammar/edge/reference-node/), [DIFFERENT-NODE](/ko/grammar/edge/different-node/)
- [Reference](/ko/grammar/reference/), [LOCAL](/ko/grammar/reference/local/)
