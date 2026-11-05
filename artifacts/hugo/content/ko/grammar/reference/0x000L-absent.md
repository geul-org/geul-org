---
title: "ABSENT (0x000L)"
weight: 0
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "ABSENT는 \"적지 않음\"을 나타내는 자리 표지다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ABSENT는 "적지 않음"을 나타내는 [자리 표지](../slot-marker.md)다. 이 자리를 채우지 않았다는 문서에 관한 말이고, 세계에 관해 아무것도 단언하지 않는다.

| 항목 | 값 |
|---|---|
| 이름 | `ABSENT` (규격 문서 BIND `ABSENT`) |
| TAG ID | `0x000L` |
| 코덱 ID | `0x00000000` |
| 규격 문서 | `0x00000000/codecs/0x00000000/` (DECLARE 대상 `0000`) |
| 섹션 | 0 `0000` (Reference 엔티티), 섹션 안 오프셋 C = 0 |
| Kind | Reference · 분류: 자리 표지 |
| TAG WORD | `0000 0000 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 적지 않음. 선택 필드를 생략했다. 세계에 관해 아무것도 단언하지 않는다 |
| Hugo 쪽 | `reference/slot-marker.md` |

## 레이아웃

```
TAG WORD          0000 0000 0000 0000      WORD 0x0000, 1 WORD
```

- Payload가 없다. 대상 ID도 없고 Quantifier도 없다([자리 표지](../slot-marker.md#레이아웃)).
- `0x000L`에서 Payload가 있는 형태(L ≥ 1)는 Reserved다.
- `geul show`·`geul add`의 텍스트 표기: `ABSENT`.

## 뜻

| 항목 | 적지 않음 |
|---|---|
| 무엇에 관한 말인가 | **문서**: 이 자리를 채우지 않았다 |
| 논리 | 아무것도 단언하지 않는다 |
| 세계 가정 | 열린 세계(정보 없음) |
| 위키데이터 | 해당 snak이 없음 |

## 수용

- CODEC 대상 `0000`을 둔 필드만 받는다. 그 필드는 **선택 필드**다. 선택 필드를 생략할 때는 그 자리에 WORD `0x0000` 하나를 쓴다. 선택 필드도 자리는 항상 차지한다([Codec 규격 문서](../codec-spec.md#선택-필드와-자리-표지)). 예: [SOURCE](../edge/0x0C0L-source.md) Origin, [QUANTITY](../value/0x066L-quantity.md)의 단위·하한·상한.
- 와일드카드, CODEC이 없는 필드, HEAD·BODY 레코드 자리, Edge Id 자리, 날값 필드에서는 쓸 수 없다([자리 표지](../slot-marker.md#수용-규칙) 공통 규칙).

## 읽는 쪽의 의무

- **ABSENT는 세계에 관해 아무 말도 하지 않는다.** UNKNOWN-VALUE나 NO-VALUE로 읽지 않는다.
- 변환기가 옮기지 못한 값(원천에는 있는 값)을 UNKNOWN-VALUE로 쓰는 것은 금지한다. 원천에서는 값을 알고 있기 때문이다. 원천이 말하지 않은 자리(예: 원천을 기술하지 않은 출처의 [SOURCE](../edge/0x0C0L-source.md) Origin)도 변환기는 ABSENT로 쓴다.
- 판정 그래프에서 ABSENT와 서술 없음은 모든 비교 연산자가 미정(U)이다. ABSENT를 empty로 읽으려면 입력 쪽이 닫힌 세계를 선언해야 한다([TOULMIN](../toulmin/_index.md#미상-위에서-판정하기)).

## 예시

`0x0000` 1 WORD. 예: 단위를 적지 않은 QUANTITY의 단위 자리.

## 코덱 문서

코덱 문서는 DECLARE(대상 `0000`) 하나만 둔다. Payload가 없어 FIELD가 없다. 디코더는 표지의 뜻과 수용 규칙을 내장한다([0층](../publishing.md#층)). 표지를 읽는 데 코덱 문서를 조회하지 않는다.

## 관련 페이지

- [자리 표지](../slot-marker.md), [UNKNOWN-VALUE](0x001L-unknown-value.md), [NO-VALUE](0x002L-no-value.md)
- [CODEC](../edge/0x0BEL-codec.md), [Codec 규격 문서](../codec-spec.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000000/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000000000000000
BODY
#1 DECLARE 0x0000
#2 BIND #1 "ABSENT"
```
