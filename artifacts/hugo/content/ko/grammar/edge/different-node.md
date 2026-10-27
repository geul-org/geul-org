---
title: "DIFFERENT-NODE"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DIFFERENT-NODE는 두 Reference가 서로 다른 대상을 지시한다는 비동일성 서술 Edge다(Codec 0x02)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DIFFERENT-NODE는 두 Reference가 서로 다른 referent를 지시한다는 비동일성 서술 Edge다. Codec `0x02`.

두 Reference 레코드의 byte 인코딩, Codec, ID가 다르다는 뜻이 아니다. [REFERENCE-NODE](/ko/grammar/edge/reference-node/)의 방향성 바인딩, [SAME-NODE](/ko/grammar/edge/same-node/)의 동일성과 구분한다.

## 레이아웃

```
TAG WORD          0001 0LLL L000 0010
[Length 확장 TAG]
Edge Id           LOCAL Reference 레코드
Subject           Reference 레코드 1개
Object            Reference 레코드 1개
```

## 해석과 유효성

- Subject와 Object는 각각 정확히 하나의 완전한 [Reference](/ko/grammar/reference/) 레코드여야 한다. 각 레코드의 Length로 경계를 찾으며, Value나 Edge이거나 불완전하면 invalid다.
- Subject와 Object는 서로 다른 referent를 지시한다. Reference 레코드의 byte 열, Codec, ID의 차이만으로 referent가 다르다고 추론하지 않는다.
- 특히 서로 다른 [LOCAL](/ko/grammar/reference/local/) ID는 서로 다른 Reference일 뿐, 현실의 referent까지 다르다는 뜻이 아니다. LOCAL ID의 차이만으로 DIFFERENT를 끌어내지 않는다.
- 비동일성은 대칭적이고 비반사적이며 추이적이지 않다. `DIFFERENT(A, B)`는 `DIFFERENT(B, A)`와 같은 관계다. 그러나 `DIFFERENT(A, B)`와 `DIFFERENT(B, C)`로 `DIFFERENT(A, C)`를 추론하지 않는다.
- wire의 Subject/Object 순서는 framing을 위한 직렬화 순서일 뿐 의미 방향을 만들지 않는다. 구현체는 양방향으로 탐색할 수 있어야 한다.
- 두 구성요소를 모두 읽은 커서는 Edge 끝과 정확히 맞아야 한다.

관계 자체는 비반사적이지만, 구조적으로 valid한 `DIFFERENT(A, A)` 주장이나 SAME과 DIFFERENT가 부딪치는 주장을 wire 문법 오류로 지워서는 안 된다. 이런 주장은 문맥과 계보를 보존하고 판정 계층에서 모순으로 다룬다. DIFFERENT를 해석하거나 끌어낼 때는 그 Edge를 담은 문서의 출처, 시점, world, policy scope를 보존하며, 이를 무시한 전역 결론으로 넓히지 않는다.

## 길이

```
전체 = 1 + N_len + N_id + N_subject + N_object WORD
```

## 예시 (비규범)

Edge Id `000a`, Subject는 LOCAL 1, Object는 LOCAL 2다.

- Edge는 TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD, `LLLL=0110`이다. TAG는 `0001 0 0110 0000010` = `1302`다.

```
1302 0088 000a 0088 0001 0088 0002
```

이 예시의 LOCAL ID 차이는 인코딩을 보여 주려는 것일 뿐이다. ID 1과 ID 2가 서로 다른 referent를 지시한다는 주장이 따로 있을 때에만 이 sequence를 DIFFERENT-NODE로 만든다.

## 관련 페이지

- [Edge](/ko/grammar/edge/), [REFERENCE-NODE](/ko/grammar/edge/reference-node/), [SAME-NODE](/ko/grammar/edge/same-node/)
- [Reference](/ko/grammar/reference/), [LOCAL](/ko/grammar/reference/local/)
