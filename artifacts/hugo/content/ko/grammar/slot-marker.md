---
title: "자리 표지"
weight: 80
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "자리 표지(slot marker)는 레코드 필드 자리를 채우는 1 WORD 레코드다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

자리 표지(slot marker)는 레코드 필드 자리를 채우는 1 WORD 레코드다. 아무것도 가리키지 않는다. Reference 섹션 0의 첫 세 칸 `0x000L~0x002L`에 배정한 코드다. 표지마다 쪽이 있다: [ABSENT](reference/0x000L-absent.md), [UNKNOWN-VALUE](reference/0x001L-unknown-value.md), [NO-VALUE](reference/0x002L-no-value.md).

값 자리에 올 수 있는 말은 셋이다. 값을 적지 않았다, 값이 있지만 무엇인지 모른다, 값이 없다. 셋은 다른 것이다. 자리 표지는 이 셋을 이웃한 세 WORD로 나눠 쓴다.

## 레이아웃

```
TAG WORD          0000 0000 00CC 0000
                  Prefix 000, 섹션 0(Reference), Codec 0~2, LLLL 0000(1 WORD)
```

| WORD | 이름 | 뜻 | 표기 |
|---|---|---|---|
| `0x0000` | [ABSENT](reference/0x000L-absent.md) | 적지 않음 | `ABSENT` |
| `0x0010` | [UNKNOWN-VALUE](reference/0x001L-unknown-value.md) | 알 수 없음: 값이 있다. 무엇인지 모른다 | `UNKNOWN` |
| `0x0020` | [NO-VALUE](reference/0x002L-no-value.md) | 없음: 값이 없다 | `NONE` |
| Codec 0~2, LLLL ≥ `0001` | Reserved | 이 TAG 형태(Payload가 있는 표지)는 배정하지 않았다 | |

- 표지에는 **Quantifier가 없다.** 양화는 5Q 체계(섹션 0의 `5 <= C < 30`, 섹션 1의 `C < 30`)에서만 읽는다. `0x0010` UNKNOWN-VALUE를 `C % 5`로 읽어 Generic으로 해석하지 않는다([Reference](reference/_index.md) Quantifier).
- Payload가 없다. 대상 ID도 없다.
- 코덱북이 없는 디코더도 TAG WORD만 보고 Kind Reference, 1 WORD임을 알아 건너뛴다. "WORD 값이 `0x0000`, `0x0010`, `0x0020`이면 자리 표지"는 `w & 0xF == 0 && w <= 0x0020`으로 안다.
- 표기 `ABSENT`·`UNKNOWN`·`NONE`은 `geul show`·`geul add`의 텍스트 표기다.

## 세 가지 구분

| | 적지 않음 (ABSENT) | 알 수 없음 (UNKNOWN-VALUE) | 없음 (NO-VALUE) |
|---|---|---|---|
| 무엇에 관한 말인가 | **문서**: 이 자리를 채우지 않았다 | **세계**: 값이 있다. 무엇인지 모른다 | **세계**: 값이 없다 |
| 논리 | 아무것도 단언하지 않는다 | `∃x. P(s, x)`, x는 식별되지 않음 | `¬∃x. P(s, x)` |
| 세계 가정 | 열린 세계 (정보 없음) | 존재는 닫힘, 정체는 열림 | (s, P, 한정 조건)에 대해 닫힌 세계 |
| 위키데이터 | 해당 snak이 없음 | `somevalue` | `novalue` |
| 어디에 쓰나 | CODEC 대상 `0000`을 둔 선택 필드 (SOURCE Origin 등) | CODEC 대상 `0010`을 둔 필드 (TRIPLE Object, QUALIFIER Value, SOURCE Origin) | CODEC 대상 `0020`을 둔 필드 (TRIPLE Object, QUALIFIER Value) |
| "자녀(P40)는 몇인가" | 모름 | 1 이상 | 0 |
| "종료 시점(P582)이 있나" | 모름 → 지금도 유효한지 모름 | 끝났다. 언제인지 모름 | 끝나지 않았다(단언) |

명제 단위에서도 같은 구분이 선다. **TRIPLE이 문서에 없음**은 적지 않음이다. GEUL 문서는 열린 세계라서, 서술이 없다고 해서 사실이 없는 것은 아니다. "없다"는 NO-VALUE로 **적어야만** 말할 수 있다.

## 수용 규칙

- 자리 표지는 그 필드의 [CODEC](edge/0x0BEL-codec.md) 목록에 **같은 WORD가 정확한 대상으로 있을 때만** 유효하다. 대상 `0000`은 "선택 필드", `0010`은 "알 수 없음을 받는다", `0020`은 "없음을 받는다"는 뜻이다.
- 와일드카드(`000F`, `060F` 등, `L=1111`)는 표지를 받지 않는다. 아무 Reference(`000F`·`020F`·`040F`)도 표지와 겹치지 않는다.
- CODEC이 없는 레코드 필드("아무 레코드")도 표지를 받지 않는다.
- HEAD·BODY 레코드 자리, Edge Id 자리의 표지는 invalid다.
- 날값 필드에는 표지를 쓸 수 없다. 날값은 TAG가 없어 1 WORD 표지가 들어갈 자리가 없다.
- 표지 대상만 있는 CODEC 목록(항상 표지)은 invalid다.
- 표지의 뜻(무엇이 있고 무엇이 없는지)은 그 표지를 받는 Edge 규격이 정한다. 양화와 부정은 Reference가 아니라 Edge가 정한다는 원칙과 같다.
- 표지의 뜻과 수용 규칙은 [0층](publishing.md#층)(디코더 내장)이다. 셋 다 Payload가 없어 내장 비용도 없다. 그래도 코드마다 코덱 문서를 둔다. 코덱 문서는 DECLARE만 두고 FIELD가 없다.

## 읽는 쪽의 의무

표지마다 쪽에 적는다. 요지는 다음과 같다.

- [UNKNOWN-VALUE](reference/0x001L-unknown-value.md#읽는-쪽의-의무)는 값이 아니라 존재 단언이다. 어떤 값과도 같지도 다르지도 않고, 그 TRIPLE은 중복 병합하지 않는다.
- [NO-VALUE](reference/0x002L-no-value.md#읽는-쪽의-의무)는 그 명제의 한정 조건 안에서 닫힌다.
- 두 표지 모두 rank가 똑같이 적용되고, QUALIFIER 값으로 쓰이면 그 한정의 뜻을 바꾼다.
- [ABSENT](reference/0x000L-absent.md#읽는-쪽의-의무)는 세계에 관해 아무 말도 하지 않는다. 옮기지 못한 값을 UNKNOWN-VALUE로 쓰지 않는다.

## 다른 "없음"과의 차이

- [LOCAL](reference/0x005L-local.md) `0`을 "없음"으로 쓰는 Codec 규칙([TOULMIN](toulmin/_index.md) REF 등)은 그 Codec 안의 약속이다. 자리 표지와 다르다.
- Identified LOCAL을 null·sentinel로 쓰지 않는다. 미상·부재를 적으려면 자리 표지를 받는 필드에 표지를 쓴다.

## 예시

Q30(미국)–Q34266(러시아 제국) 국경, 종료 시점을 모른다. Edge Id는 설명용이다.

```
0AA9 0051 080C 0191 002F 0141 001E 0141 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
0AB7 0051 0C58 0191 0246 0051 080C 0010                #3160 QUALIFIER P582 #2060 UNKNOWN
```

Q30 중앙은행, 1811~1816년에는 없었다.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000           #3161 TRIPLE P1304 Q30 NONE normal
0AB9 0051 0C5A 0191 0244 0051 0C59 06E2 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
0AB9 0051 0C5B 0191 0246 0051 0C59 06E2 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

- 표지 자리는 1 WORD다. TRIPLE은 9 WORD(`0AA8`), QUALIFIER는 8 WORD(`0AB7`)가 된다.
- 단순한 형태로 "자녀(P40) 없음"은 `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000`이다.

## 관련 페이지

- [ABSENT](reference/0x000L-absent.md), [UNKNOWN-VALUE](reference/0x001L-unknown-value.md), [NO-VALUE](reference/0x002L-no-value.md)
- [Reference](reference/_index.md), [CODEC](edge/0x0BEL-codec.md), [Codec 규격 문서](codec-spec.md)
- [TRIPLE](edge/0x0AAL-triple.md), [QUALIFIER](edge/0x0ABL-qualifier.md), [TOULMIN](toulmin/_index.md)
