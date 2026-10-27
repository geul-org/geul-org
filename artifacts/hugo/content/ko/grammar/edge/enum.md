---
title: "ENUM"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ENUM은 날값 필드의 코드값 하나에 의미를 붙이는 서술 Edge다(Codec 0x1D). 이름은 BIND로 묶는다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ENUM은 날값 필드의 코드값 하나에 의미를 붙이는 서술 Edge다. Codec `0x1D`.

[FIELD](/ko/grammar/edge/field/)와 함께 Codec 규격을 쓰는 어휘다. 레이아웃은 디코더에 내장한다([Codec 규격 문서](/ko/grammar/codec-spec/)).

## 레이아웃

```
TAG WORD          0001 0LLL L001 1101
[Length 확장 TAG]
Edge Id           LOCAL Reference 레코드
필드              FIELD Edge를 가리키는 LOCAL Reference 레코드
코드값            날값. 그 FIELD의 폭과 같은 WORD 수
```

## 해석과 유효성

- 필드는 날값 FIELD(폭 `n ≥ 1`)여야 한다. 레코드 필드에는 ENUM을 붙이지 않는다. 레코드의 의미는 그 레코드의 Codec이 말한다.
- 코드값은 정확히 그 FIELD의 폭만큼이다. ENUM 레코드의 Length로 경계를 확인한다.
- 한 필드에서 같은 코드값을 두 번 선언하지 않는다.
- 코드값의 이름은 ENUM Edge Id에 [BIND](/ko/grammar/edge/bind/)로 묶는다. DECLARE·FIELD·ENUM·CODEC에 붙이는 UTF8-TEXT는 모두 BIND로 하며, LABEL 등 다른 Edge로 붙이지 않는다.
- 선언되지 않은 코드값은 오류가 아니다. 뷰어는 날값 그대로 보여 준다. 허용 값을 닫을지는 Codec 규격의 몫이며, 지금 어휘에는 닫는 표시가 없다.

## 길이

```
전체 = 1 + N_len + N_id + N_field + n WORD
```

## 예시 (비규범)

TOMBSTONE 규격 문서의 사유 범주 필드(FIELD #4, 날값 1 WORD)에 코드 `0x0001`을 선언한다. Edge Id 10. 이름은 BIND로 따로 묶는다. 사유 범주 코드표는 아직 정해지지 않았으므로 코드값은 예시다.

- TAG 1 + Edge Id 2 + 필드 2 + 코드값 1 = 6 WORD, `LLLL = 0101`.

```
129D 0088 000A 0088 0004 0001
```

TRIPLE 규격 문서는 Rank 필드(FIELD #5)에 ENUM 셋(`0`·`1`·`2`)을 두고 각각 `normal`·`preferred`·`deprecated`로 BIND한다([TRIPLE](/ko/grammar/edge/triple/)).

## 관련 페이지

- [DECLARE](/ko/grammar/edge/declare/), [FIELD](/ko/grammar/edge/field/), [CODEC](/ko/grammar/edge/codec/), [BIND](/ko/grammar/edge/bind/)
- [Codec 규격 문서](/ko/grammar/codec-spec/)
