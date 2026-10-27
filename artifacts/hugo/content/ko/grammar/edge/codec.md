---
title: "CODEC"
weight: 31
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "CODEC은 FIELD 하나가 받는 Kind·Codec 하나를 지정하는 서술 Edge다(Codec 0x1E). 와일드카드와 자리 표지(0x0000 적지 않음, 0x0001 알 수 없음, 0x0002 없음)도 이것으로 선언한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CODEC은 [FIELD](/ko/grammar/edge/field/) 하나가 받는 Kind·Codec 하나를 지정하는 서술 Edge다. Codec `0x1E`.

[ENUM](/ko/grammar/edge/enum/)이 날값 필드의 코드값 하나에 의미를 붙이듯, CODEC은 필드의 형식 하나를 붙인다. Edge 하나에 하나씩이라 여러 개를 지정할 수 있다. 레이아웃은 디코더에 내장한다([Codec 규격 문서](/ko/grammar/codec-spec/)).

## 레이아웃

```
TAG WORD          0001 0LLL L001 1110
[Length 확장 TAG]
Edge Id           LOCAL Reference 레코드
필드              FIELD Edge를 가리키는 LOCAL Reference 레코드
대상              1 WORD. 000K KLLL LCCC CCCC (LLLL = 0000 정확, 1111 와일드카드)
```

## 대상 WORD

- TAG WORD의 Kind(`KK`)와 Codec(`CCCCCCC`) 자리를 그대로 둔다. 상위 3비트는 0이다. `LLLL`은 `0000`(정확) 또는 `1111`(와일드카드)이고, 다른 값은 invalid다.
- 정확한 대상(`LLLL = 0000`)은 Codec 규격 문서 ID와 같은 값이다(예: LOCAL `0x0008`, COORDINATE-EARTH `0x0804`, UTF8-LANGUAGE-TEXT `0x084A`). 그래서 대상이 곧 그 Codec 규격 문서를 가리킨다.
- 홀짝 코드 쌍(텍스트·바이트열)도 정확한 코드로 지정한다. 짝수·홀수를 모두 받으려면 둘 다 둔다. 쌍을 묶어 해석하는 규칙은 두지 않는다(NUMERIC `0x04`/`0x05`처럼 쌍이 아닌 인접 코드가 있다).

### 와일드카드 (`LLLL = 1111`)

- Kind는 같아야 하고, **0인 Codec 비트 묶음은 무엇이든 맞는다**. Reference는 `CCCC`(Codec)와 `QQQ`(Quantifier)가 따로 묶음이고, 다른 Kind는 7비트 전체가 한 묶음이다.

| 대상 | 뜻 |
|---|---|
| `0780` | 아무 Reference |
| `07A0` | WIKIDATA-QID, Quantifier 무관 |
| `0781` | 아무 Reference Codec, Quantifier Generic(`001`) |
| `0F80` | 아무 Value |
| `1780`, `1F80` | 아무 Edge, 아무 Meta |

- 맞출 것이 없는 와일드카드는 invalid다. Value·Edge·Meta는 Codec이 0이어야 하고, Reference는 `CCCC`나 `QQQ` 중 하나가 0이어야 한다. Reference `CCCC = 0000`(자리 표지)은 예약 Codec이라 **어떤 와일드카드와도 맞지 않는다**(`0780`은 ABSENT·UNKNOWN-VALUE·NO-VALUE를 받지 않는다). 한편 Value `0x00`(BOOL)·Edge `0x00`(REFERENCE-NODE)처럼 Codec 0이 배정된 Kind도 와일드카드가 그것을 포함한다(BOOL만 받으려면 `LLLL = 0000`).
- 와일드카드는 규격 문서를 가리키지 않는다.
- "Identified만의 아무 Reference"처럼 0이 아닌 묶음 하나만 고정하고 0인 묶음을 고정하는 표현은 없다. 그런 목록은 정확한 대상을 나열한다.
- Reference의 Codec 7비트에는 Quantifier(`QQQ`)가 들어 있다. 대상은 Quantifier까지 정확히 지정한다. 여러 Quantifier를 받으려면 CODEC을 여러 개 둔다.

### 자리 표지 (대상 `0000`~`0002`)

[자리 표지](/ko/grammar/reference/slot-marker/)는 예약 Reference Codec `0000`의 1 WORD 레코드 묶음이다. 하위 3비트가 표지 번호다(Quantifier가 아니다).

| 대상 | 표지 | 뜻 |
|---|---|---|
| `0000` | ABSENT | 적지 않음. 그 필드는 선택 필드다 |
| `0001` | UNKNOWN-VALUE | 알 수 없음. 값이 있다는 단언을 받는다 |
| `0002` | NO-VALUE | 없음. 값이 없다는 단언을 받는다 |
| `0003`~`0007` | 예약 | |

- **수용 규칙:** 표지는 그 필드의 CODEC 목록에 같은 WORD가 정확한 대상으로 있을 때만 유효하다. 와일드카드와 CODEC이 없는 레코드 필드("아무 레코드")는 표지를 받지 않는다. HEAD·BODY 레코드 자리, Edge Id 자리의 표지는 invalid다.
- 표지 대상만 있는 목록(항상 표지)은 invalid다(`0000`만 있는 목록 규칙의 일반화). 와일드카드나 정확한 대상과 함께 쓴다(`0780` + `0000` = 아무 Reference 또는 생략).
- 날값 필드에는 표지 대상을 둘 수 없다. 날값은 TAG가 없고 폭이 정해져 있어 1 WORD 표지가 들어갈 자리가 없다.
- 표지의 뜻은 그것을 받는 Codec 규격이 정한다.

### 선택 필드 (대상 `0000`)

- 레코드 필드의 CODEC 목록에 대상 `0000`을 두면 그 필드는 **선택 필드**다. 생략할 때는 그 자리에 WORD `0x0000` 1 WORD를 쓴다. 이 1 WORD 레코드가 자리 표지 ABSENT(적지 않음)다.
- `0x0000`은 Reference Codec `0000`(예약), 표지 번호 `000`, `LLLL = 0000`(전체 1 WORD)이다. 다른 레코드와 겹치지 않고, 규격을 모르는 디코더도 1 WORD 레코드로 건너뛴다.
- 선택 필드도 자리는 항상 차지한다. 생략하면 반드시 `0x0000`을 쓰고 자리를 비우지 않는다(뒤쪽 필드여도 같다). 그래서 레코드 하나의 표기는 하나뿐이고, 분해는 위치만으로 정해진다. 선택 필드의 위치와 개수, 다른 필드와 목록이 겹치는지는 제약이 없다.
- ABSENT는 선택 필드 자리에서만 유효하다. HEAD·BODY 레코드 자리, 필수 필드 자리, Edge Id 자리의 `0x0000`은 invalid다.
- 생략은 "값이 없음"이 아니라 "적지 않음"이다. 세계에 관해 아무것도 단언하지 않는다. "값이 없다"는 NO-VALUE(`0002`)로 적는다. 생략이 무엇을 뜻하는지(예: TAG의 대상이 없으면 이 버전)는 각 형식의 명세가 정한다.

## 해석과 유효성

- 필드는 같은 문서의 FIELD Edge다. 한 필드에 같은 대상을 두 번 두지 않는다.
- **레코드 필드(폭 0)**: CODEC이 없으면 자리 표지를 뺀 아무 레코드나 받는다. 하나 이상 있으면 닫힌 목록이다. 그 필드의 레코드는 Kind·Codec(Reference는 Quantifier 포함)이 목록 중 하나여야 하고, 아니면 그 레코드는 규격을 따르지 않는다. ENUM이 열린 목록인 것과 다르다.
- **날값 필드(폭 n ≥ 1, 또는 나머지 `0xFFFF`)**: CODEC은 정확한 대상 하나만 둔다(와일드카드 불가). 그 날값은 TAG를 뺀 그 Value의 Payload다. Kind·Codec은 CODEC이, Length는 FIELD 폭이 준다. 홀짝 코드는 지정한 코드가 바이트 수 홀짝을 정한다. 날값이 그 Value 규칙(길이 포함)을 따르지 않으면 그 레코드는 규격을 따르지 않는다.
- 자리 표지는 목록의 정확한 대상으로만 대조한다. 선택 필드(대상 `0000`) 자리에 `0x0000`이 오면 생략이다. 그 밖의 레코드는 표지 대상을 뺀 목록으로 대조한다.
- 날값 필드에 CODEC과 ENUM을 함께 둘 수 있다. CODEC은 형식, ENUM은 코드값의 이름이다(예: rank를 UNSIGNED-INTEGER로 두고 0·1·2를 ENUM으로).
- CODEC의 Edge Id에 BIND로 이름을 붙일 수 있지만 필수가 아니다.
- "Reference 또는 Value" 필드는 CODEC 2개(`0780`, `0F80`)로 쓴다.

## 길이

```
전체 = 1 + N_len + N_id + N_field + 1 WORD   (Edge Id·필드가 LOCAL 1 WORD ID면 6 WORD)
```

## 예시

LABEL 규격 문서 `geul.org/label`에서 Object 필드(FIELD #3)가 UTF8-LANGUAGE-TEXT(짝수·홀수)와 LOCAL을 받는다. Edge Id 7~9.

```
129E 0088 0007 0088 0003 084A
129E 0088 0008 0088 0003 084B
129E 0088 0009 0088 0003 0008
```

- TAG `129E`(Edge, Codec `0x1E`, `LLLL = 0101`, 6 WORD), Edge Id `0088 0007`, 필드 `0088 0003`, 대상 `084A`.

## 관련 페이지

- [FIELD](/ko/grammar/edge/field/), [ENUM](/ko/grammar/edge/enum/), [DECLARE](/ko/grammar/edge/declare/), [BIND](/ko/grammar/edge/bind/)
- [Codec 규격 문서](/ko/grammar/codec-spec/), [LABEL](/ko/grammar/edge/label/)
