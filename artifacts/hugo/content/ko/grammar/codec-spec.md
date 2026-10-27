---
title: "Codec 규격 문서"
weight: 90
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "codebook", "declare", "field"]
summary: "코덱북도 GEUL 문서다. DECLARE·FIELD·ENUM·CODEC 네 Edge로 Codec 하나의 Payload 구성을 선언하고, 그 문서 하나로 검증·분해·표시를 함께 한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Codec이 Payload를 어떻게 구성하는지는 코덱북이 정한다. GEUL의 코덱북은 별도 형식이 아니라 **GEUL 문서**다. Codec 하나에 규격 문서 하나다.

## 규격 문서의 위치

직접 코드의 규격 문서는 GEUL Issuer(`0x0000`)가 공표한다. 문서 ID는 그 Codec의 TAG WORD(Kind·Codec 자리만, Length는 0)를 4 WORD로 늘린 값이다.

```
/.well-known/geul/0x0000/0x000000000000<TAG>.geul
```

| Codec | TAG | 규격 문서 |
|---|---|---|
| Reference LOCAL | `0008` | `0x0000/0x0000000000000008` |
| Value QUANTITY | `0806` | `0x0000/0x0000000000000806` |
| Edge TRIPLE | `100A` | `0x0000/0x000000000000100A` |
| Edge PUBLICATION | `1018` | `0x0000/0x0000000000001018` |

디코더는 TAG WORD만 보고 규격 문서의 주소를 만든다. 모르는 Codec을 만나면 그 문서를 받아 읽으면 된다.

- `<TAG>`는 대상 TAG WORD의 hex 4자리다. Length 자리는 `0000`이고, Reference는 Quantifier 비트를 `000`으로 둔다(LOCAL은 `0008`).
- Reference Codec `0000`은 예약이라 대상 TAG WORD가 `0x0000`인 규격 문서는 없다. 그래서 규격 문서는 GEUL Issuer의 용어 정의 색인 문서(문서 ID `0`, [Issuer와 공표](/ko/grammar/issuer/#용어-정의-문서))와 겹치지 않는다.
- 규격 문서는 `DOC-ID`로 DOC-POINTER(`0x0000`, `0x000000000000<TAG>`, `0`)를 둔다. 버전 목록 레코드도 이 DOC-POINTER를 쓴다.
- 규격 문서도 다른 문서처럼 GEUL Issuer의 이름 색인 `0x0000/documents.geul`에 소문자 슬러그 이름을 묶는다. 예: `publication` → `geul.org/publication/` = `0x0000/0x0000000000001018/`([공표 주소와 버전 목록](/ko/grammar/publishing/#문서-이름)).
- 버전·정본 주소·서명 규칙은 일반 공표 문서와 같다.

### GEUL Issuer의 문서 ID

| 문서 ID | 쓰임 |
|---|---|
| `0x0000000000000000` | 용어 정의 색인 문서 |
| `0x00000000 0000xxxx` | Codec 규격 문서. `xxxx`는 대상 TAG WORD |
| `0x0001xxxx xxxxxxxx` | geul.org의 용어 정의 문서. 용어 하나에 문서 하나([Issuer와 공표](/ko/grammar/issuer/#용어-정의-문서)) |

- `0x00000000 0000xxxx`는 Codec 규격 문서에 예약한다. GEUL Issuer의 다른 문서(직접 코드가 모자랄 때 두는 GEUL 고유 ISSUER 형식의 문서 등)는 이 구간을 쓰지 않는다.

### 코덱북과 명세 판

- 코덱북 문서는 `IMPORT-DOC`으로 가져오지 않는다. 문서 HEAD의 [SPEC-VERSION](/ko/grammar/meta/declaration/spec-version/)이 어느 코덱북을 따르는지 정한다.
- 모든 디코더는 핵심 코덱북을 내장하거나 이 주소에서 받는다.
- 제안(Prefix `000`)이 표준으로 채택되면 레이아웃은 그대로 두고 Prefix만 `001`로 바뀐다([개요](/ko/grammar/overview/#영역-구조)). 대상 TAG WORD가 달라지므로 채택본은 다른 문서 ID의 새 규격 문서가 되고, 제안 문서는 불변으로 남는다.

## 네 어휘

| Edge | Codec | 하는 일 |
|---|---|---|
| DECLARE | `0x1B` | Codec 하나의 Payload 구성을 선언한다. 대상 TAG WORD 1 WORD |
| FIELD | `0x1C` | Payload 필드 하나. 속한 DECLARE와 폭 |
| ENUM | `0x1D` | 날값 필드의 코드값 하나에 의미를 붙인다 |
| CODEC | `0x1E` | 필드가 받는 Kind·Codec 하나를 지정한다 |

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

필드가 받는 형식을 지정한다. 대상 WORD는 TAG WORD의 Kind·Codec 자리를 그대로 쓴다.

| Length 자리 | 뜻 | 예 |
|---|---|---|
| `0000` | 정확한 Codec | `0810` SIGNED-DECIMAL, `0008` LOCAL |
| `1111` | 와일드카드: 0인 Codec 비트는 무엇이든 맞는다 | `0780` 아무 Reference, `0F80` 아무 Value, `07A0` 위키데이터 QID(양화 무관) |

- 레코드 필드에 CODEC이 없으면 아무 레코드나 받는다. 하나 이상 있으면 그중 하나여야 한다(닫힌 목록).
- 날값 필드에 CODEC을 하나 두면 그 날값을 TAG 없는 그 Value로 해석한다.

### 선택 필드

레코드 필드의 CODEC 목록에 대상 `0000`을 두면 **선택 필드**다.

- 생략할 때는 그 자리에 WORD `0x0000` 하나를 쓴다(없음 표지).
- 선택 필드도 자리는 항상 차지한다. 그래서 레코드 하나의 표기는 하나이고, 분해는 위치만으로 정해진다.
- `0x0000`은 예약 Reference Codec이라 다른 레코드와 겹치지 않고, 규격을 모르는 디코더도 1 WORD 레코드로 건너뛴다.
- 없음 표지는 선택 필드 자리에서만 유효하다. 문서의 레코드 자리나 필수 필드 자리에 오면 거부한다.
- 생략은 "값이 없음"이 아니라 "적지 않음"이다.

## 예: TRIPLE 규격 문서

`0x0000/0x000000000000100A`의 BODY다.

| Edge | 내용 | 이름(BIND) |
|---|---|---|
| #1 DECLARE | 대상 `100A` | `TRIPLE` |
| #2 FIELD | #1의 필드, 레코드 | `predicate` |
| #3 FIELD | #1의 필드, 레코드 | `subject` |
| #4 FIELD | #1의 필드, 레코드 | `object` |
| #5 FIELD | #1의 필드, 날값 1 WORD | `rank` |
| #6~#8 ENUM | #5의 코드값 0, 1, 2 | `normal`, `preferred`, `deprecated` |
| #17 CODEC | #5는 UNSIGNED-INTEGER(`0802`)로 해석 | |
| #18, #19 CODEC | #4는 아무 Reference(`0780`) 또는 아무 Value(`0F80`) | |

이 문서 하나로 디코더는 TRIPLE 레코드를 필드로 나누고, 필드 이름을 붙여 보여 주고, 형식이 맞는지 검사한다.

## 예: QUANTITY 규격 문서

Value QUANTITY(`0806`)는 필드 네 개가 모두 레코드다.

| 필드 | CODEC |
|---|---|
| `amount` | `0810` SIGNED-DECIMAL |
| `unit` | `0780` 아무 Reference, `0000` 선택 |
| `lower` | `0810` SIGNED-DECIMAL, `0000` 선택 |
| `upper` | `0810` SIGNED-DECIMAL, `0000` 선택 |

## 규칙

- 규격 문서 하나에 DECLARE는 하나다. DECLARE의 대상은 문서 ID의 TAG WORD와 같다.
- 한 문서에서 같은 대상을 두 번 선언하지 않는다.
- 필드 구성이 다른 변형은 분기로 쓰지 않는다. Codec마다 따로 선언한다.
- 가변 날값이 둘 이상이거나 날값의 폭이 다른 값에 따라 달라지는 레이아웃은 선언할 수 없다. 그런 부분은 레코드로 감싼다.
- 규격 문서는 다른 문서처럼 버전으로 공표된다. 다만 Codec의 바이너리 레이아웃은 개정하지 않는다. 바꾸려면 새 Codec을 배정한다.

## 열린 문제

- `SPEC-VERSION` 값(v1은 `0x0001`)에서 코덱북 문서 버전으로 가는 대응. 채택본과 제안본을 잇는 계보 Meta.
