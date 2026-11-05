---
title: "DIFFERENT-NODE (0x0A2L)"
weight: 162
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DIFFERENT-NODE는 두 Reference가 서로 다른 referent를 지시한다는 비동일성 서술 Edge다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `DIFFERENT-NODE` (규격 문서 BIND `DIFFERENT-NODE`) |
| TAG ID | `0x0A2L` |
| 코덱 ID | `0x00000A20` |
| 규격 문서 | `0x00000000/codecs/0x00000A20/` (DECLARE 대상 `0A20`) |
| 섹션 | 5 `0101` (Edge 서술), 섹션 안 오프셋 C = 2 |
| Kind | Edge · 계열: 서술, 묶음: 지시와 이름 |
| TAG WORD | `0000 1010 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 두 Reference가 서로 다른 대상을 지시하는 비동일성 |
| Hugo 쪽 | `edge/different-node.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)). Edge의 Edge Id는 FIELD로 선언하지 않는다.

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | 레코드 | 아무 레코드(자리 표지 제외) |  |
| 2 | `object` | #3 | 레코드 | 아무 레코드(자리 표지 제외) |  |

DIFFERENT-NODE는 두 Reference가 서로 다른 referent를 지시한다는 비동일성 서술 Edge다. Codec `0x0A2L`.

두 Reference 레코드의 byte 인코딩, Codec, ID가 다르다는 뜻이 아니다. [REFERENCE-NODE](0x0A0L-reference-node.md)의 방향성 바인딩, [SAME-NODE](0x0A1L-same-node.md)의 동일성과 구분한다.

## 레이아웃

```
TAG WORD          0000 1010 0010 LLLL
[Length 확장 TAG]
Edge Id           LOCAL Reference 레코드
Subject           Reference 레코드 1개
Object            Reference 레코드 1개
```

## 해석과 유효성

- Subject와 Object는 각각 정확히 하나의 완전한 [Reference](../reference/_index.md) 레코드여야 한다. 각 레코드의 Length로 경계를 찾으며, Value나 Edge이거나 불완전하면 invalid다.
- Subject와 Object는 서로 다른 referent를 지시한다. Reference 레코드의 byte 열, Codec, ID의 차이만으로 referent가 다르다고 추론하지 않는다.
- 특히 서로 다른 [LOCAL](../reference/0x005L-local.md) ID는 서로 다른 Reference일 뿐, 현실의 referent까지 다르다는 뜻이 아니다. LOCAL ID의 차이만으로 DIFFERENT를 끌어내지 않는다.
- 비동일성은 대칭적이고 비반사적이며 추이적이지 않다. `DIFFERENT(A, B)`는 `DIFFERENT(B, A)`와 같은 관계다. 그러나 `DIFFERENT(A, B)`와 `DIFFERENT(B, C)`로 `DIFFERENT(A, C)`를 추론하지 않는다.
- wire의 Subject/Object 순서는 framing을 위한 직렬화 순서일 뿐 의미 방향을 만들지 않는다. 구현체는 양방향으로 탐색할 수 있어야 한다.
- 두 구성요소를 모두 읽은 커서는 Edge 끝과 정확히 맞아야 한다.

관계 자체는 비반사적이지만, 구조적으로 valid한 `DIFFERENT(A, A)` 주장이나 SAME과 DIFFERENT가 부딪치는 주장을 wire 문법 오류로 지워서는 안 된다. 이런 주장은 문맥과 계보를 보존하고 판정 계층에서 모순으로 다룬다. DIFFERENT를 해석하거나 끌어낼 때는 그 Edge를 담은 문서의 출처, 시점, world, policy scope를 보존하며, 이를 무시한 전역 결론으로 넓히지 않는다.

## 길이

```
전체 = 1 + N_len + N_id + N_subject + N_object WORD
```

## 예시 (비규범)

Edge Id `000A`, Subject는 LOCAL 1, Object는 LOCAL 2다.

- Edge는 TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD, `LLLL=0110`이다. TAG는 `0000 1010 0010 0110` = `0A26`다.

```
0A26 0051 000A 0051 0001 0051 0002
```

이 예시의 LOCAL ID 차이는 인코딩을 보여 주려는 것일 뿐이다. ID 1과 ID 2가 서로 다른 referent를 지시한다는 주장이 따로 있을 때에만 이 sequence를 DIFFERENT-NODE로 만든다.

## 관련 페이지

- [Edge](_index.md), [REFERENCE-NODE](0x0A0L-reference-node.md), [SAME-NODE](0x0A1L-same-node.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000A20/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A2000000000
BODY
#1 DECLARE 0x0A20
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "DIFFERENT-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
```
