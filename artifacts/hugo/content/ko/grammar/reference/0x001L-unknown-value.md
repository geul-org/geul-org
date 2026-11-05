---
title: "UNKNOWN-VALUE (0x001L)"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "UNKNOWN-VALUE는 \"알 수 없음\"을 나타내는 자리 표지다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNKNOWN-VALUE는 "알 수 없음"을 나타내는 [자리 표지](../slot-marker.md)다. 값이 있지만 무엇인지 모른다는 세계에 관한 단언이다.

| 항목 | 값 |
|---|---|
| 이름 | `UNKNOWN-VALUE` (규격 문서 BIND `UNKNOWN-VALUE`) |
| TAG ID | `0x001L` |
| 코덱 ID | `0x00000010` |
| 규격 문서 | `0x00000000/codecs/0x00000010/` (DECLARE 대상 `0010`) |
| 섹션 | 0 `0000` (Reference 엔티티), 섹션 안 오프셋 C = 1 |
| Kind | Reference · 분류: 자리 표지 |
| TAG WORD | `0000 0000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 알 수 없음. 값이 있지만 무엇인지 모른다(위키데이터 `somevalue`) |
| Hugo 쪽 | `reference/slot-marker.md` |

## 레이아웃

```
TAG WORD          0000 0000 0001 0000      WORD 0x0010, 1 WORD
```

- Payload가 없다. 대상 ID도 없고 Quantifier도 없다([자리 표지](../slot-marker.md#레이아웃)).
- `0x001L`에서 Payload가 있는 형태(L ≥ 1)는 Reserved다.
- `geul show`·`geul add`의 텍스트 표기: `UNKNOWN`.

## 뜻

| 항목 | 알 수 없음 |
|---|---|
| 무엇에 관한 말인가 | **세계**: 값이 있다. 무엇인지 모른다 |
| 논리 | `∃x. P(s, x)`, x는 식별되지 않음 |
| 세계 가정 | 존재는 닫힘, 정체는 열림 |
| 위키데이터 | `somevalue` |

## 수용

- CODEC 대상 `0010`을 둔 필드만 받는다. 그 필드는 "알 수 없음"이라는 단언을 받는다. 예: [TRIPLE](../edge/0x0AAL-triple.md) Object, [QUALIFIER](../edge/0x0ABL-qualifier.md) Value, [SOURCE](../edge/0x0C0L-source.md) Origin.
- 와일드카드, CODEC이 없는 필드, HEAD·BODY 레코드 자리, Edge Id 자리, 날값 필드에서는 쓸 수 없다([자리 표지](../slot-marker.md#수용-규칙) 공통 규칙).

## 읽는 쪽의 의무

- **UNKNOWN-VALUE는 값이 아니라 존재 단언이다.** 다른 어떤 값과도 같지 않고, 다르지도 않다(비교 결과 미정). 두 UNKNOWN-VALUE끼리도 같은 값으로 보지 않는다. 출현마다 독립된 존재 양화다(위키데이터 빈 노드와 같다).
- 그래서 바이트가 같은 TRIPLE 두 개(`P40 Q… UNKNOWN` ×2)는 중복이 아니다. 자녀가 둘일 수도, 하나일 수도 있다. UNKNOWN-VALUE를 담은 TRIPLE은 중복 병합하지 않는다.
- 나중에 정체가 밝혀지면 그 TRIPLE을 고친 새 버전을 낸다. UNKNOWN-VALUE는 가리킬 수 없다. 공참조가 필요하면 LOCAL Variable을 쓴다([Reference](_index.md#quantifier) Variable).
- **rank는 똑같이 적용된다.** 대표 값(truthy)을 고를 때 UNKNOWN-VALUE TRIPLE도 후보에 든다.
- **QUALIFIER 값으로 쓰이면 그 한정의 뜻을 바꾼다.** `P582 = UNKNOWN`이면 끝났고 시점을 모른다. 지금도 유효한 명제로 읽지 않는다.
- UNKNOWN-VALUE는 "있다"는 단언이라 원천이 그렇게 말할 때만 쓴다. 옮기지 못한 값을 UNKNOWN-VALUE로 쓰지 않는다.

## 예시

`0x0010` 1 WORD. 예: Q30–Q34266 국경의 종료 시점(P582)을 모른다: `0AB7 0051 0C58 0191 0246 0051 080C 0010`(QUALIFIER, Value 자리가 `0010`).

## 코덱 문서

코덱 문서는 DECLARE(대상 `0010`) 하나만 둔다. Payload가 없어 FIELD가 없다. 디코더는 표지의 뜻과 수용 규칙을 내장한다([0층](../publishing.md#층)). 표지를 읽는 데 코덱 문서를 조회하지 않는다.

## 관련 페이지

- [자리 표지](../slot-marker.md), [ABSENT](0x000L-absent.md), [NO-VALUE](0x002L-no-value.md)
- [CODEC](../edge/0x0BEL-codec.md), [Codec 규격 문서](../codec-spec.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000010/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000001000000000
BODY
#1 DECLARE 0x0010
#2 BIND #1 "UNKNOWN-VALUE"
```
