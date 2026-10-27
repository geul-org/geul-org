---
title: "자리 표지"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "자리 표지는 예약 Reference Codec 0000에 둔 1 WORD 레코드 묶음이다. 0x0000 ABSENT(적지 않음), 0x0001 UNKNOWN-VALUE(알 수 없음), 0x0002 NO-VALUE(없음)가 레코드 필드 자리를 채운다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

자리 표지(slot marker)는 레코드 필드 자리를 채우는 1 WORD 레코드다. 아무것도 가리키지 않는다. 예약 Reference Codec `0000`에 둔다.

값 자리에 올 수 있는 말은 셋이다. 값을 적지 않았다, 값이 있지만 무엇인지 모른다, 값이 없다. 셋은 다른 것이다. 자리 표지는 이 셋을 이웃한 세 WORD로 나눠 쓴다.

## 레이아웃

```
TAG WORD          0000 0000 0000 0MMM
                  Prefix 000, Kind 00(Reference), LLLL 0000(1 WORD), CCCC 0000, MMM = 표지 번호
```

| WORD | 이름 | 뜻 | 표기 |
|---|---|---|---|
| `0x0000` | ABSENT | 적지 않음 | `ABSENT` |
| `0x0001` | UNKNOWN-VALUE | 알 수 없음: 값이 있다. 무엇인지 모른다 | `UNKNOWN` |
| `0x0002` | NO-VALUE | 없음: 값이 없다 | `NONE` |
| `0x0003`~`0x0007` | 예약 | | |
| CCCC `0000`, LLLL ≥ `0001` | 예약 | Payload가 있는 표지는 뒤에 정한다 | |

- 하위 3비트 `MMM`은 **Quantifier가 아니라 표지 번호**다. 다른 Reference Codec의 `QQQ`와 이름만 같은 자리일 뿐 뜻이 이어지지 않는다([Reference](/ko/grammar/reference/) Quantifier 예외).
- Payload가 없다. 대상 ID도 없다.
- 코덱북이 없는 디코더도 TAG WORD만 보고 Kind Reference, 1 WORD임을 알아 건너뛴다. "WORD 값이 `0`~`7`이면 자리 표지"는 비트 검사 하나(`w & 0xFFF8 == 0`)로 안다.
- 표기 `ABSENT`·`UNKNOWN`·`NONE`은 `geul show`·`geul add`의 텍스트 표기다.

## 세 가지 구분

| | 적지 않음 (ABSENT) | 알 수 없음 (UNKNOWN-VALUE) | 없음 (NO-VALUE) |
|---|---|---|---|
| 무엇에 관한 말인가 | **문서**: 이 자리를 채우지 않았다 | **세계**: 값이 있다. 무엇인지 모른다 | **세계**: 값이 없다 |
| 논리 | 아무것도 단언하지 않는다 | `∃x. P(s, x)`, x는 식별되지 않음 | `¬∃x. P(s, x)` |
| 세계 가정 | 열린 세계 (정보 없음) | 존재는 닫힘, 정체는 열림 | (s, P, 한정 조건)에 대해 닫힌 세계 |
| 위키데이터 | 해당 snak이 없음 | `somevalue` | `novalue` |
| 어디에 쓰나 | CODEC 대상 `0000`을 둔 선택 필드 (SOURCE Origin 등) | CODEC 대상 `0001`을 둔 필드 (TRIPLE Object, QUALIFIER Value, SOURCE Origin) | CODEC 대상 `0002`를 둔 필드 (TRIPLE Object, QUALIFIER Value) |
| "자녀(P40)는 몇인가" | 모름 | 1 이상 | 0 |
| "종료 시점(P582)이 있나" | 모름 → 지금도 유효한지 모름 | 끝났다. 언제인지 모름 | 끝나지 않았다(단언) |

명제 단위에서도 같은 구분이 선다. **TRIPLE이 문서에 없음**은 적지 않음이다. GEUL 문서는 열린 세계라서, 서술이 없다고 해서 사실이 없는 것은 아니다. "없다"는 NO-VALUE로 **적어야만** 말할 수 있다.

## 수용 규칙

- 자리 표지는 그 필드의 [CODEC](/ko/grammar/edge/codec/) 목록에 **같은 WORD가 정확한 대상으로 있을 때만** 유효하다. 대상 `0000`은 "선택 필드", `0001`은 "알 수 없음을 받는다", `0002`는 "없음을 받는다"는 뜻이다.
- 와일드카드(`0780`, `0781`, `0F80` 등)는 표지를 받지 않는다. Reference 와일드카드도 Codec `0000`과 겹치지 않는다.
- CODEC이 없는 레코드 필드("아무 레코드")도 표지를 받지 않는다.
- HEAD·BODY 레코드 자리, Edge Id 자리의 표지는 invalid다.
- 날값 필드에는 표지를 쓸 수 없다. 날값은 TAG가 없어 1 WORD 표지가 들어갈 자리가 없다.
- 표지 대상만 있는 CODEC 목록(항상 표지)은 invalid다.
- 표지의 뜻(무엇이 있고 무엇이 없는지)은 그 표지를 받는 Edge 규격이 정한다. 양화와 부정은 Reference가 아니라 Edge가 정한다는 원칙과 같다.
- 자리 표지는 Codec 규격 문서가 없다. [0층](/ko/grammar/publishing/#층)(디코더 내장)이다. DECLARE의 Reference 대상은 Quantifier 자리를 0으로 두므로 `0x0001`·`0x0002`의 규격 문서는 만들 수 없고, 셋 다 Payload가 없어 내장 비용도 없다.

## 읽는 쪽의 의무

1. **UNKNOWN-VALUE는 값이 아니라 존재 단언이다.** 다른 어떤 값과도 같지 않고, 다르지도 않다(비교 결과 미정). 두 UNKNOWN-VALUE끼리도 같은 값으로 보지 않는다. 출현마다 독립된 존재 양화다(위키데이터 빈 노드와 같다).
   - 그래서 바이트가 같은 TRIPLE 두 개(`P40 Q… UNKNOWN` ×2)는 중복이 아니다. 자녀가 둘일 수도, 하나일 수도 있다. UNKNOWN-VALUE를 담은 TRIPLE은 중복 병합하지 않는다.
   - 나중에 정체가 밝혀지면 그 TRIPLE을 고친 새 버전을 낸다. UNKNOWN-VALUE는 가리킬 수 없다. 공참조가 필요하면 LOCAL Variable을 쓴다([Reference](/ko/grammar/reference/) Variable).
2. **NO-VALUE는 그 명제의 한정 조건 안에서 닫힌다.** QUALIFIER가 붙으면 그 범위에서만 닫힌다. Q30 P1304 NO-VALUE(P580 1811, P582 1816)는 1811~1816년에만 중앙은행이 없었다는 뜻이고, 같은 속성의 값 TRIPLE(연방준비제도, preferred)과 모순되지 않는다.
   - 같은 Subject·Predicate에 NO-VALUE와 값 TRIPLE이 같은 rank로, 한정 조건이 구별되지 않은 채 함께 있으면 모순이다. 검사기는 경고를 낸다. 거부하지는 않는다. 위키데이터에도 있는 상태이고, 읽는 쪽이 rank로 고른다.
3. **rank는 똑같이 적용된다.** 대표 값(truthy)을 고를 때 UNKNOWN-VALUE·NO-VALUE TRIPLE도 후보에 든다. preferred가 있으면 preferred만 남는다.
4. **QUALIFIER 값으로 쓰이면 그 한정의 뜻을 바꾼다.** `P582 = UNKNOWN`이면 끝났고 시점을 모른다. 지금도 유효한 명제로 읽지 않는다. `P582 = NONE`이면 끝나지 않았다고 단언한다. P582 QUALIFIER가 아예 없으면 끝났는지 모른다.
5. **ABSENT는 세계에 관해 아무 말도 하지 않는다.** UNKNOWN-VALUE나 NO-VALUE로 읽지 않는다. 반대로 변환기가 옮기지 못한 값(원천에는 있는 값)을 UNKNOWN-VALUE로 쓰는 것은 금지한다. 원천에서는 값을 알고 있기 때문이다. 원천이 말하지 않은 자리(예: 원천을 기술하지 않은 출처의 [SOURCE](/ko/grammar/edge/source/) Origin)도 변환기는 ABSENT로 쓴다. UNKNOWN-VALUE는 "있다"는 단언이라 원천이 그렇게 말할 때만 쓴다.

## 다른 "없음"과의 차이

- [LOCAL](/ko/grammar/reference/local/) `0`을 "없음"으로 쓰는 Codec 규칙([TOULMIN](/ko/grammar/edge/toulmin/) REF 등)은 그 Codec 안의 약속이다. 자리 표지와 다르다.
- Identified LOCAL을 null·sentinel로 쓰지 않는다. 미상·부재를 적으려면 자리 표지를 받는 필드에 표지를 쓴다.

## 예시

Q30(미국)–Q34266(러시아 제국) 국경, 종료 시점을 모른다. Edge Id는 설명용이다.

```
148A 0088 080C 00A8 002F 00A0 001E 00A0 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
138B 0088 0C58 00A8 0246 0088 080C 0001                #3160 QUALIFIER P582 #2060 UNKNOWN
```

Q30 중앙은행, 1811~1816년에는 없었다.

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000           #3161 TRIPLE P1304 Q30 NONE normal
148B 0088 0C5A 00A8 0244 0088 0C59 0924 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
148B 0088 0C5B 00A8 0246 0088 0C59 0924 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

- 표지 자리는 1 WORD다. TRIPLE은 9 WORD(`140A`), QUALIFIER는 8 WORD(`138B`)가 된다.
- 단순한 형태로 "자녀(P40) 없음"은 `140A 0088 <Edge Id> 00A8 0028 <Subject> 0002 0000`이다.

## 관련 페이지

- [Reference](/ko/grammar/reference/), [CODEC](/ko/grammar/edge/codec/), [Codec 규격 문서](/ko/grammar/codec-spec/)
- [TRIPLE](/ko/grammar/edge/triple/), [QUALIFIER](/ko/grammar/edge/qualifier/), [TOULMIN](/ko/grammar/edge/toulmin/)
