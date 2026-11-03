---
title: "CODEC"
weight: 31
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "CODEC은 FIELD 하나가 받는 Kind·Codec 하나를 지정하는 서술 Edge다(Codec 0x09EL). 와일드카드와 자리 표지(0x0000 적지 않음, 0x0010 알 수 없음, 0x0020 없음)도 이것으로 선언한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CODEC은 [FIELD](/ko/grammar/edge/field/) 하나가 받는 Kind·Codec 하나를 지정하는 서술 Edge다. Codec `0x09EL`.

[ENUM](/ko/grammar/edge/enum/)이 날값 필드의 코드값 하나에 의미를 붙이듯, CODEC은 필드의 형식 하나를 붙인다. Edge 하나에 하나씩이라 여러 개를 지정할 수 있다. 레이아웃은 디코더에 내장한다([Codec 규격 문서](/ko/grammar/codec-spec/)).

## 레이아웃

```
TAG WORD          0000 1001 1110 LLLL
[Length 확장 TAG]
Edge Id           LOCAL Reference 레코드
필드              FIELD Edge를 가리키는 LOCAL Reference 레코드
대상              1 WORD. 000K KKCC CCCC LLLL (LLLL = 0000 정확, 1111 와일드카드)
```

## 대상 WORD

- TAG WORD의 Kind(`KKK`)와 Codec(`CCCCCC`) 자리를 그대로 둔다. 상위 3비트는 0이다. `LLLL`은 `0000`(정확) 또는 `1111`(와일드카드)이고, 다른 값은 invalid다.
- 정확한 대상(`LLLL = 0000`)을 32비트로 쓴 값이 그 Codec의 코덱 ID다(예: LOCAL `0x0050` → `0x00000050`, COORDINATE-EARTH `0x0440`, UTF8-LANGUAGE-TEXT `0x0580`). 그래서 대상이 곧 그 Codec 규격 문서를 가리킨다([Codec 규격 문서](/ko/grammar/codec-spec/)).
- 홀짝 코드 쌍(텍스트·바이트열)도 정확한 코드로 지정한다. 짝수·홀수를 모두 받으려면 둘 다 둔다. 쌍을 묶어 해석하는 규칙은 두지 않는다(NUMERIC `0x044L`/`0x045L`처럼 쌍이 아닌 인접 코드가 있다).

### 와일드카드 (`LLLL = 1111`)

- `LLLL = 1111`이면 C 값과 무관하게 KKK가 가리키는 Kind 전체를 받는다. 대상의 Kind와 레코드의 Kind가 같은지만 본다. Kind를 넘어 아무 레코드를 받지는 않는다.
- `LLLL = 1111`이면 C=0을 권고한다. 권고이고 강제가 아니다. C≠0이어도 유효하고 C는 보지 않는다.

| 대상 | 뜻 |
|---|---|
| `000F` | 아무 Reference |
| `040F` | 아무 Value |
| `080F` | 아무 Edge (KKK `010`~`110` 전체, EDGE-ISSUER 포함) |
| `1C0F` | 아무 Meta |

- Reference 자리 표지(`0x000L~0x002L`)는 `LLLL = 1111`과 맞지 않는다(`000F`는 ABSENT·UNKNOWN-VALUE·NO-VALUE를 받지 않는다). 한편 Value `0x040L`(BOOL)·Edge `0x080L`(REFERENCE-NODE)처럼 C=0이 배정된 Kind도 `LLLL = 1111`이 그것을 포함한다(BOOL만 받으려면 `LLLL = 0000`인 `0400`).
- `LLLL = 1111`인 대상은 규격 문서를 가리키지 않는다.
- 양화 무관이나 묶음은 CODEC 나열(`LLLL = 0000`)로만 쓴다. 예: WIKIDATA-QID 양화 무관은 `0140`, `0150`, `0160`, `0170`, `0180` 다섯 개다.
- Reference 5Q 체계의 코드에는 양화가 들어 있다. 대상은 양화까지 정확히 지정한다. 여러 Quantifier를 받으려면 CODEC을 여러 개 둔다. REFERENCE-ISSUER의 양화는 Issuer 문서가 정한다.

### 자리 표지 (대상 `0000`, `0010`, `0020`)

[자리 표지](/ko/grammar/reference/slot-marker/)는 예약 Reference 코드 `0x000L~0x002L`의 1 WORD 레코드 묶음이다. 양화가 없다.

| 대상 | 표지 | 뜻 |
|---|---|---|
| `0000` | ABSENT | 적지 않음. 그 필드는 선택 필드다 |
| `0010` | UNKNOWN-VALUE | 알 수 없음. 값이 있다는 단언을 받는다 |
| `0020` | NO-VALUE | 없음. 값이 없다는 단언을 받는다 |

- **수용 규칙:** 표지는 그 필드의 CODEC 목록에 같은 WORD가 정확한 대상으로 있을 때만 유효하다. 와일드카드와 CODEC이 없는 레코드 필드("아무 레코드")는 표지를 받지 않는다. HEAD·BODY 레코드 자리, Edge Id 자리의 표지는 invalid다.
- 표지 대상만 있는 목록(항상 표지)은 invalid다(`0000`만 있는 목록 규칙의 일반화). `LLLL = 1111` 대상이나 정확한 대상과 함께 쓴다(`000F` + `0000` = 아무 Reference 또는 생략).
- 날값 필드에는 표지 대상을 둘 수 없다. 날값은 TAG가 없고 폭이 정해져 있어 1 WORD 표지가 들어갈 자리가 없다.
- 표지의 뜻은 그것을 받는 Codec 규격이 정한다.

### 선택 필드 (대상 `0000`)

- 레코드 필드의 CODEC 목록에 대상 `0000`을 두면 그 필드는 **선택 필드**다. 생략할 때는 그 자리에 WORD `0x0000` 1 WORD를 쓴다. 이 1 WORD 레코드가 자리 표지 ABSENT(적지 않음)다.
- `0x0000`은 Reference, Codec `0x000L`(예약), `LLLL = 0000`(전체 1 WORD)이다. 다른 레코드와 겹치지 않고, 규격을 모르는 디코더도 1 WORD 레코드로 건너뛴다.
- 선택 필드도 자리는 항상 차지한다. 생략하면 반드시 `0x0000`을 쓰고 자리를 비우지 않는다(뒤쪽 필드여도 같다). 그래서 레코드 하나의 표기는 하나뿐이고, 분해는 위치만으로 정해진다. 선택 필드의 위치와 개수, 다른 필드와 목록이 겹치는지는 제약이 없다.
- ABSENT는 선택 필드 자리에서만 유효하다. HEAD·BODY 레코드 자리, 필수 필드 자리, Edge Id 자리의 `0x0000`은 invalid다.
- 생략은 "값이 없음"이 아니라 "적지 않음"이다. 세계에 관해 아무것도 단언하지 않는다. "값이 없다"는 NO-VALUE(`0020`)로 적는다. 생략이 무엇을 뜻하는지(예: TAG의 대상이 없으면 이 버전)는 각 형식의 명세가 정한다.

## 해석과 유효성

- 필드는 같은 문서의 FIELD Edge다. 한 필드에 같은 대상을 두 번 두지 않는다.
- **레코드 필드(폭 0)**: CODEC이 없으면 자리 표지를 뺀 아무 레코드나 받는다. 하나 이상 있으면 닫힌 목록이다. 그 필드의 레코드는 Kind·Codec(Reference는 Quantifier 포함)이 목록 중 하나여야 하고, 아니면 그 레코드는 규격을 따르지 않는다. ENUM이 열린 목록인 것과 다르다.
- **날값 필드(폭 n ≥ 1, 또는 나머지 `0xFFFF`)**: CODEC은 정확한 대상 하나만 둔다(와일드카드 불가). 그 날값은 TAG를 뺀 그 Value의 Payload다. Kind·Codec은 CODEC이, Length는 FIELD 폭이 준다. 홀짝 코드는 지정한 코드가 바이트 수 홀짝을 정한다. 날값이 그 Value 규칙(길이 포함)을 따르지 않으면 그 레코드는 규격을 따르지 않는다.
- 자리 표지는 목록의 정확한 대상으로만 대조한다. 선택 필드(대상 `0000`) 자리에 `0x0000`이 오면 생략이다. 그 밖의 레코드는 표지 대상을 뺀 목록으로 대조한다.
- 날값 필드에 CODEC과 ENUM을 함께 둘 수 있다. CODEC은 형식, ENUM은 코드값의 이름이다(예: rank를 UNSIGNED-INTEGER로 두고 0·1·2를 ENUM으로).
- CODEC의 Edge Id에 BIND로 이름을 붙일 수 있지만 필수가 아니다.
- "Reference 또는 Value" 필드는 CODEC 2개(`000F`, `040F`)로 쓴다.

## 길이

```
전체 = 1 + N_len + N_id + N_field + 1 WORD   (Edge Id·필드가 LOCAL 1 WORD ID면 6 WORD)
```

## 예시

LABEL 규격 문서 `0x00000000/codecs/0x00000840/`에서 Object 필드(FIELD #3)가 UTF8-LANGUAGE-TEXT(짝수·홀수)와 LOCAL을 받는다. Edge Id 7~9.

```
09E5 0051 0007 0051 0003 0580
09E5 0051 0008 0051 0003 0590
09E5 0051 0009 0051 0003 0050
```

- TAG `09E5`(Edge, Codec `0x09EL`, `LLLL = 0101`, 6 WORD), Edge Id `0051 0007`, 필드 `0051 0003`, 대상 `0580`.

## 관련 페이지

- [FIELD](/ko/grammar/edge/field/), [ENUM](/ko/grammar/edge/enum/), [DECLARE](/ko/grammar/edge/declare/), [BIND](/ko/grammar/edge/bind/)
- [Codec 규격 문서](/ko/grammar/codec-spec/), [LABEL](/ko/grammar/edge/label/)
