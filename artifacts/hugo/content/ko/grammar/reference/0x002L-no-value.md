---
title: "NO-VALUE (0x002L)"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "NO-VALUE는 \"없음\"을 나타내는 자리 표지다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NO-VALUE는 "없음"을 나타내는 [자리 표지](../slot-marker.md)다. 값이 없다는 세계에 관한 단언이다.

| 항목 | 값 |
|---|---|
| 이름 | `NO-VALUE` (규격 문서 BIND `NO-VALUE`) |
| TAG ID | `0x002L` |
| 코덱 ID | `0x00000020` |
| 규격 문서 | `0x00000000/codecs/0x00000020/` (DECLARE 대상 `0020`) |
| 섹션 | 0 `0000` (Reference 엔티티), 섹션 안 오프셋 C = 2 |
| Kind | Reference · 분류: 자리 표지 |
| TAG WORD | `0000 0000 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 없음. 값이 없다(위키데이터 `novalue`) |
| Hugo 쪽 | `reference/slot-marker.md` |

## 레이아웃

```
TAG WORD          0000 0000 0010 0000      WORD 0x0020, 1 WORD
```

- Payload가 없다. 대상 ID도 없고 Quantifier도 없다([자리 표지](../slot-marker.md#레이아웃)).
- `0x002L`에서 Payload가 있는 형태(L ≥ 1)는 Reserved다.
- `geul show`·`geul add`의 텍스트 표기: `NONE`.

## 뜻

| 항목 | 없음 |
|---|---|
| 무엇에 관한 말인가 | **세계**: 값이 없다 |
| 논리 | `¬∃x. P(s, x)` |
| 세계 가정 | (s, P, 한정 조건)에 대해 닫힌 세계 |
| 위키데이터 | `novalue` |

## 수용

- CODEC 대상 `0020`을 둔 필드만 받는다. 그 필드는 "없음"이라는 단언을 받는다. 예: [TRIPLE](../edge/0x0AAL-triple.md) Object, [QUALIFIER](../edge/0x0ABL-qualifier.md) Value.
- 와일드카드, CODEC이 없는 필드, HEAD·BODY 레코드 자리, Edge Id 자리, 날값 필드에서는 쓸 수 없다([자리 표지](../slot-marker.md#수용-규칙) 공통 규칙).

## 읽는 쪽의 의무

- **NO-VALUE는 그 명제의 한정 조건 안에서 닫힌다.** QUALIFIER가 붙으면 그 범위에서만 닫힌다. Q30 P1304 NO-VALUE(P580 1811, P582 1816)는 1811~1816년에만 중앙은행이 없었다는 뜻이고, 같은 속성의 값 TRIPLE(연방준비제도, preferred)과 모순되지 않는다.
- 같은 Subject·Predicate에 NO-VALUE와 값 TRIPLE이 같은 rank로, 한정 조건이 구별되지 않은 채 함께 있으면 모순이다. 검사기는 경고를 낸다. 거부하지는 않는다. 위키데이터에도 있는 상태이고, 읽는 쪽이 rank로 고른다.
- **rank는 똑같이 적용된다.** 대표 값(truthy)을 고를 때 NO-VALUE TRIPLE도 후보에 든다.
- **QUALIFIER 값으로 쓰이면 그 한정의 뜻을 바꾼다.** `P582 = NONE`이면 끝나지 않았다고 단언한다. P582 QUALIFIER가 아예 없으면 끝났는지 모른다.
- "없다"는 NO-VALUE로 **적어야만** 말할 수 있다. TRIPLE이 문서에 없는 것은 적지 않음이다(열린 세계).

## 예시

`0x0020` 1 WORD. 예: 자녀(P40) 없음은 `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000`이다(TRIPLE, Object 자리가 `0020`).

## 코덱 문서

코덱 문서는 DECLARE(대상 `0020`) 하나만 둔다. Payload가 없어 FIELD가 없다. 디코더는 표지의 뜻과 수용 규칙을 내장한다([0층](../publishing.md#층)). 표지를 읽는 데 코덱 문서를 조회하지 않는다.

## 관련 페이지

- [자리 표지](../slot-marker.md), [ABSENT](0x000L-absent.md), [UNKNOWN-VALUE](0x001L-unknown-value.md)
- [CODEC](../edge/0x0BEL-codec.md), [Codec 규격 문서](../codec-spec.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000020/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000002000000000
BODY
#1 DECLARE 0x0020
#2 BIND #1 "NO-VALUE"
```
