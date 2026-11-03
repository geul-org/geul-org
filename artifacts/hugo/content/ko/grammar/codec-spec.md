---
title: "Codec 규격 문서"
weight: 90
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "codebook", "declare", "field"]
summary: "코덱북도 GEUL 문서다. DECLARE·FIELD·ENUM·CODEC 네 Edge로 Codec 하나의 Payload 구성을 선언하고, 그 문서 하나로 검증·분해·표시를 함께 한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Codec이 Payload를 어떻게 구성하는지는 코덱북이 정한다. GEUL의 코덱북은 별도 형식이 아니라 **GEUL 문서**다. Codec 하나에 규격 문서 하나다.

## 규격 문서의 위치

직접 코드의 규격 문서는 GEUL Issuer(`0x00000000`)가 공표한다. 규격 문서는 코덱 문서이고 문서 ID가 없다. 코덱 ID는 그 Codec의 TAG WORD(섹션과 `C`의 Codec 자리만, Length는 0)를 32비트로 쓴 값이다.

```
/.well-known/geul/0x00000000/codecs/0x0000<TAG>/<버전 ID>.geul
```

| Codec | TAG | 규격 문서 |
|---|---|---|
| Reference LOCAL | `0050` | `0x00000000/codecs/0x00000050` |
| Value QUANTITY | `0660` | `0x00000000/codecs/0x00000660` |
| Edge TRIPLE | `0AA0` | `0x00000000/codecs/0x00000AA0` |
| Edge PUBLICATION | `0B80` | `0x00000000/codecs/0x00000B80` |

디코더는 TAG WORD만 보고 규격 문서의 주소를 만든다. 모르는 Codec을 만나면 그 문서를 받아 읽으면 된다.

- `<TAG>`는 대상 TAG WORD의 hex 4자리(대문자)다. Length 자리는 `0000`이다. 코덱 문서는 코드마다 하나다. Reference 5Q 체계도 양화 코드마다 따로 둔다(LOCAL Identified `0050`, LOCAL Generic `0060`). 직접 코드와 Issuer 코덱이 같은 주소 규칙 `<Issuer>/codecs/<코덱 ID>/`를 쓴다([공표 주소와 버전 목록](/ko/grammar/publishing/#공표-주소)).
- [자리 표지](/ko/grammar/reference/slot-marker/)(`0x0000`, `0x0010`, `0x0020`)도 규격 문서를 둔다. Payload가 없어 DECLARE만 두고 FIELD가 없다. 표지의 뜻과 수용 규칙은 디코더에 내장한다([0층](/ko/grammar/publishing/#층)). 레이아웃을 아직 정하지 않은 Codec도 DECLARE만 둔 규격 문서로 시작한다.
- 규격 문서는 `DOC-ID`로 [CODEC-POINTER](/ko/grammar/reference/codec-pointer/)(`0x00000000`, `0x0000<TAG>`, `0`)를 둔다. 버전 목록 레코드도 이 CODEC-POINTER를 쓴다.
- 버전·정본 주소·서명 규칙은 일반 공표 문서와 같다.

### 코덱북과 명세 판

- 코덱 문서도 [IMPORT-DOC](/ko/grammar/meta/import/import-doc/)으로 가져올 수 있다. 그때 문서 자리에는 DOC-POINTER 대신 [CODEC-POINTER](/ko/grammar/reference/codec-pointer/)를 쓴다. 문서 HEAD의 [SPEC-VERSION](/ko/grammar/meta/declaration/spec-version/)이 어느 코덱북을 따르는지 정한다.
- 모든 디코더는 핵심 코덱북을 내장하거나 이 주소에서 받는다.
- 제안(Prefix `000`)이 표준으로 채택되면 레이아웃은 그대로 두고 Prefix만 `001`로 바뀐다([개요](/ko/grammar/overview/#영역-구조)). 대상 TAG WORD가 달라지므로 채택본은 다른 코덱 ID의 새 규격 문서가 되고, 제안 문서는 불변으로 남는다.

## 네 어휘

| Edge | Codec | 하는 일 |
|---|---|---|
| DECLARE | `0x0BBL` | Codec 하나의 Payload 구성을 선언한다. 대상 TAG WORD 1 WORD |
| FIELD | `0x0BCL` | Payload 필드 하나. 속한 DECLARE와 폭 |
| ENUM | `0x0BDL` | 날값 필드의 코드값 하나에 의미를 붙인다 |
| CODEC | `0x0BEL` | 필드가 받는 Kind·Codec 하나를 지정한다 |

- 네 Edge의 레이아웃은 디코더에 내장한다([0층](/ko/grammar/publishing/#층)). 규격 문서를 코덱북 없이 읽어야 하기 때문이다. 규격 문서를 읽는 데 다른 규격 문서가 필요 없다.
- 이름(Codec 이름, 필드 이름, 코드값 이름)은 모두 BIND로 묶는다.

### FIELD

```
Edge Id           LOCAL
DECLARE           LOCAL (이 필드가 속한 DECLARE)
폭                1 WORD: 0 = 레코드, n = 날값 n WORD, 0xFFFF = 나머지 날값
```

- 같은 DECLARE를 가리키는 FIELD들의 **문서 안 순서**가 Payload 필드 순서다.
- 레코드 필드는 TAG WORD로 시작하고 그 Length만큼 읽는다.
- 날값 필드는 정해진 WORD 수만큼 읽는 부호 없는 정수다. 부호·소수·날짜처럼 해석이 필요한 값은 날값이 아니라 Value 레코드로 둔다.
- 나머지 날값(`0xFFFF`)은 하나만 둘 수 있고, 그 뒤에는 고정 폭 날값만 온다.
- Edge의 Edge Id는 FIELD로 선언하지 않는다. 모든 Edge의 첫 요소라 암묵적이다.
- 필드를 차례로 읽은 위치는 레코드 끝과 정확히 맞아야 한다.

### CODEC

필드가 받는 형식을 지정한다. 대상 WORD는 TAG WORD의 Codec 자리(섹션 `KKKK`와 `C`)를 그대로 쓴다.

| Length 자리 | 뜻 | 예 |
|---|---|---|
| `0000` | 정확한 Codec | `0680` SIGNED-DECIMAL, `0050` LOCAL |
| `1111` | 와일드카드: `C` 값과 무관하게 그 섹션 `KKKK`(32칸) 전체다. 섹션 첫 칸(`C = 0`)을 권고한다 | `000F` 섹션 0 전체, `060F` 섹션 3 전체 |

- Kind가 여러 섹션에 걸치면 섹션마다 CODEC을 나열한다. 아무 Reference는 `000F`·`020F`·`040F`, 아무 Value는 `060F`·`080F`다.
- 양화 무관이나 묶음은 정확한 Codec을 나열한다. 위키데이터 QID(양화 무관)는 `0140`, `0150`, `0160`, `0170`, `0180` 다섯 개다.

- 레코드 필드에 CODEC이 없으면 아무 레코드나 받는다(자리 표지는 빼고). 하나 이상 있으면 그중 하나여야 한다(닫힌 목록).
- 날값 필드에 CODEC을 하나 두면 그 날값을 TAG 없는 그 Value로 해석한다.

### 선택 필드와 자리 표지

[자리 표지](/ko/grammar/reference/slot-marker/)는 Reference 섹션 0의 첫 세 칸 `0x000L~0x002L`에 배정한 1 WORD 레코드 묶음이다. 필드의 CODEC 목록이 그 WORD를 정확한 대상으로 둘 때만 그 자리에 올 수 있다.

| CODEC 대상 | 표지 | 그 필드는 |
|---|---|---|
| `0000` | ABSENT, 적지 않음 | **선택 필드**다. 생략할 수 있다 |
| `0010` | UNKNOWN-VALUE, 알 수 없음 | 값이 있지만 무엇인지 모른다는 단언을 받는다 |
| `0020` | NO-VALUE, 없음 | 값이 없다는 단언을 받는다 |

- **수용 규칙:** 표지는 그 필드의 CODEC 목록에 같은 WORD가 정확한 대상으로 있을 때만 유효하다. 와일드카드(`000F`, `060F` …)와 CODEC이 없는 필드("아무 레코드")는 표지를 받지 않는다. HEAD·BODY 레코드 자리, Edge Id 자리에서는 invalid다.
- 선택 필드를 생략할 때는 그 자리에 WORD `0x0000` 하나(ABSENT)를 쓴다. 선택 필드도 자리는 항상 차지한다. 그래서 레코드 하나의 표기는 하나이고, 분해는 위치만으로 정해진다.
- 표지는 자기 Reference 코드를 가져 다른 레코드와 겹치지 않고, 규격을 모르는 디코더도 1 WORD 레코드로 건너뛴다.
- 세 표지는 다른 말이다. ABSENT는 문서에 관한 말(이 자리를 채우지 않았다)이라 세계에 관해 아무것도 단언하지 않는다. UNKNOWN-VALUE는 값이 있다는 단언(`∃x`), NO-VALUE는 값이 없다는 단언(`¬∃x`, 한정 조건 안에서)이다. 생략은 "값이 없음"이 아니라 "적지 않음"이다.
- 표지가 무엇을 뜻하는지는 그 표지를 받는 Codec 규격이 정한다([TRIPLE](/ko/grammar/edge/triple/), [QUALIFIER](/ko/grammar/edge/qualifier/)).

## 예: TRIPLE 규격 문서

`0x00000000/codecs/0x00000AA0`의 BODY다.

| Edge | 내용 | 이름(BIND) |
|---|---|---|
| #1 DECLARE | 대상 `0AA0` | `TRIPLE` |
| #2 FIELD | #1의 필드, 레코드 | `predicate` |
| #3 FIELD | #1의 필드, 레코드 | `subject` |
| #4 FIELD | #1의 필드, 레코드 | `object` |
| #5 FIELD | #1의 필드, 날값 1 WORD | `rank` |
| #6~#8 ENUM | #5의 코드값 0, 1, 2 | `normal`, `preferred`, `deprecated` |
| #17 CODEC | #5는 UNSIGNED-INTEGER(`0620`)로 해석 | |
| #18~#22 CODEC | #4는 아무 Reference(`000F`·`020F`·`040F`) 또는 아무 Value(`060F`·`080F`) | |
| #23, #24 CODEC | #4는 UNKNOWN-VALUE(`0010`), NO-VALUE(`0020`)도 받는다 | |
| #25~#27 CODEC | #2는 아무 Reference(`000F`·`020F`·`040F`) | |
| #28~#30 CODEC | #3은 아무 Reference(`000F`·`020F`·`040F`) | |

이 문서 하나로 디코더는 TRIPLE 레코드를 필드로 나누고, 필드 이름을 붙여 보여 주고, 형식이 맞는지 검사한다.

## 예: QUANTITY 규격 문서

Value QUANTITY(`0660`)는 필드 네 개가 모두 레코드다.

| 필드 | CODEC |
|---|---|
| `amount` | `0610` SIGNED-INTEGER, `0620` UNSIGNED-INTEGER, `0630` BINARY-FLOAT(유한한 값만), `0670` FRACTION, `0680` SIGNED-DECIMAL, `0690` UNSIGNED-DECIMAL |
| `unit` | `000F`·`020F`·`040F` 아무 Reference, `0000` 선택 |
| `lower` | `0610`·`0620`·`0630`·`0670`·`0680`·`0690`(amount와 같음), `0000` 선택 |
| `upper` | `0610`·`0620`·`0630`·`0670`·`0680`·`0690`(amount와 같음), `0000` 선택 |

## 규칙

- 규격 문서 하나에 DECLARE는 하나다. DECLARE의 대상은 코덱 ID의 TAG WORD와 같다.
- 한 문서에서 같은 대상을 두 번 선언하지 않는다.
- 필드 구성이 다른 변형은 분기로 쓰지 않는다. Codec마다 따로 선언한다.
- 가변 날값이 둘 이상이거나 날값의 폭이 다른 값에 따라 달라지는 레이아웃은 선언할 수 없다. 그런 부분은 레코드로 감싼다.
- 규격 문서는 다른 문서처럼 버전으로 공표된다. 다만 Codec의 바이너리 레이아웃은 개정하지 않는다. 바꾸려면 새 Codec을 배정한다.

## 열린 문제

- `SPEC-VERSION` 값(v1은 `0x0001`)에서 코덱북 문서 버전으로 가는 대응. 채택본과 제안본을 잇는 계보 Meta.
