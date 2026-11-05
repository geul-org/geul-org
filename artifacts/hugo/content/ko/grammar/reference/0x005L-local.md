---
title: "LOCAL (0x005L~0x009L)"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "LOCAL은 이 문서가 발급한 ID로 대상을 가리키는 선언 Reference다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `LOCAL` (5Q 묶음. 코드별 이름은 아래 구성원 표) |
| TAG ID | `0x005L~0x009L` |
| 섹션 | 0 `0000` (Reference 엔티티), 섹션 안 오프셋 C = 5~9 |
| Kind | Reference · 분류: 선언 |
| Hugo 쪽 | `reference/local.md` |

## 구성원

이 쪽은 5Q 체계 한 벌, 코드 다섯 개를 함께 다룬다. 양화는 섹션 안 오프셋 `C % 5`다([Reference](_index.md#quantifier)). 코덱 문서는 코드마다 하나다. 다섯 코덱 문서의 필드는 같고 DECLARE 대상과 이름(BIND)만 다르다.

| TAG ID | 이름 | 양화 | 코덱 ID | 규격 문서 | TAG WORD |
|---|---|---|---|---|---|
| `0x005L` | `LOCAL-IDENTIFIED` | Identified | `0x00000050` | `0x00000000/codecs/0x00000050/` | `0000 0000 0101 LLLL` |
| `0x006L` | `LOCAL-GENERIC` | Generic | `0x00000060` | `0x00000000/codecs/0x00000060/` | `0000 0000 0110 LLLL` |
| `0x007L` | `LOCAL-FREE-CHOICE` | Free-choice | `0x00000070` | `0x00000000/codecs/0x00000070/` | `0000 0000 0111 LLLL` |
| `0x008L` | `LOCAL-UNIVERSAL` | Universal | `0x00000080` | `0x00000000/codecs/0x00000080/` | `0000 0000 1000 LLLL` |
| `0x009L` | `LOCAL-VARIABLE` | Variable | `0x00000090` | `0x00000000/codecs/0x00000090/` | `0000 0000 1001 LLLL` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `local-id` | #2 | 나머지 날값(`0xFFFF`) |  |  |

LOCAL은 이 문서가 발급한 ID로 대상을 가리키는 선언 Reference다. 외부 Issuer 없이 문서 안의 대상을 참조한다. 문서 밖에서 가리키려면 문서에 Meta [DOC-ID](../meta/0x1C7L-doc-id.md)를 두고, 다른 문서가 지시 Reference로 가리킨다.

## 레이아웃

```
TAG WORD          0000 0000 0101 LLLL      Codec 0x005L~0x009L (Identified 0x005L)
[Length 확장 TAG]
LOCAL ID          가장 짧은 폭의 unsigned big-endian
```

| LOCAL ID | 전체 | TAG WORD (Identified) |
|---|---|---|
| `0..65535` | 2 WORD | `0x0051` |
| `65536..2^32-1` | 3 WORD | `0x0052` |
| `2^32..2^48-1` | 4 WORD | `0x0053` |
| `2^48..2^64-1` | 5 WORD | `0x0054` |

- Codec은 `0x005L`(Identified), `0x006L`(Generic), `0x007L`(Free-choice), `0x008L`(Universal), `0x009L`(Variable)이다. Identified의 TAG WORD는 `0000 0000 0101 LLLL`이다.
- 대상 ID를 가장 짧은 WORD 수로 쓰는 Reference 공통 규칙을 따른다.

## Edge Id

- Edge Payload의 첫 요소인 LOCAL이 그 Edge의 Edge Id 선언이다([Edge](../edge/_index.md)). Edge Id를 선언하는 LOCAL은 Identified(`0x005L`)만 쓴다.
- Edge Payload의 그 밖의 자리에 있는 LOCAL은 언급이다. 이 문서의 대상은 언급할 때마다 LOCAL로 쓴다. 이 문서의 대상을 가리키는 지시 코드는 따로 없다.

## 식별자 할당

- ID는 정수이며 인코더가 배정한다. 숫자의 크기와 할당 순서는 동일성 말고는 아무 뜻이 없다.
- **UNIQUE(필수).** 한 문서에서 LOCAL ID 하나는 대상 하나만 가리킨다. Edge Id는 문서마다 한 번만 선언한다(HEAD Edge와 BODY Edge가 한 번호 공간). 같은 Edge Id를 선언하는 Edge가 둘 이상이면 invalid다.
- **AUTO INCREMENT(권고).** 새 ID는 그 문서에서 지금까지 배정한 ID의 최댓값 + 1로 배정하고, 문서 순서대로 늘어나게 둔다. 버전을 넘어서도 같다(삭제한 ID보다 큰 값으로 새로 만든다). 권고일 뿐 유효성 조건이 아니며, 증가하지 않는 문서도 valid다. 디코더는 ID의 크기나 연속성에 기대지 않는다.
- ID `0`은 배정하지 않는다. 어떤 대상도 가리키지 않으며 Edge Id로도 쓰지 않는다. 대상 ID는 `1`부터 배정한다.
- 문서는 그 문서 안에서든 밖에서든 [DOC-POINTER](0x041L-doc-pointer.md) 하나로만 가리킨다(자기 자신은 자기 `DOC-ID`의 DOC-POINTER). 문서에도 `BIND`·`LABEL`·판정 Edge를 붙일 수 있다.
- Issuer 자신은 [ISSUER-POINTER](0x040L-issuer-pointer.md)로 가리킨다. 문서 ID `0`은 Issuer의 용어 정의 색인 문서다.
- 구성요소 자리의 `0`에 뜻을 주는 Codec([TOULMIN](../toulmin/_index.md) REF·실행 Edge의 "없음", HEAD [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) Target의 "문서 전체")은 그 Codec 규칙을 따른다. 이것은 [자리 표지](../slot-marker.md)와 다른, 그 Codec 안의 약속이다.
- 한 번 할당한 ID는 같은 문서에서 재사용하지 않는다.
- 항상 값을 표현할 수 있는 최소 폭을 쓴다.

## 동일성과 범위

- 같은 문서에서 LOCAL ID의 정수값이 같으면 같은 대상이다. 인코딩 폭은 동일성의 일부가 아니다.
- Identified LOCAL은 식별된 대상을 나타낸다. 익명·미지정·null·sentinel 용도로 쓰지 않는다. 값이 있지만 모르거나(UNKNOWN-VALUE) 값이 없다(NO-VALUE)는 말은 그 표지를 받는 필드에 [자리 표지](../slot-marker.md)로 쓴다.
- 서로 다른 LOCAL ID는 서로 다른 Reference일 뿐, 현실의 대상까지 서로 다르다는 뜻은 아니다.
- LOCAL의 동일성을 문서 밖으로 넓히지 않는다. 다른 문서의 같은 숫자는 무관하다.
- Variable(`0x009L`) LOCAL은 이름 있는 담화 변수다([Reference](_index.md) Variable).

## 병합

여러 문서를 하나로 병합할 때는 원본 문서마다 `old ID → new ID` 대응표를 만들고, 모든 LOCAL ID를 새 문서의 ID로 다시 배정해 참조를 전부 바꾼다.

- 같은 원본 문서에서 같았던 ID는 병합 뒤에도 같아야 한다.
- 서로 다른 원본 문서의 같은 숫자는 무관하며, 자동으로 같은 Reference로 합치지 않는다.
- 바꾸지 못한 LOCAL이 하나라도 있으면 병합을 거부한다.

## 유효성

다음 인코딩이나 할당은 invalid다.

- 선행 `0x0000` WORD가 있는 non-minimal 인코딩(값 0의 `0x0000` 1 WORD는 예외)
- Edge Id 선언 자리의 Codec이 Identified(`0x005L`)가 아니거나 ID가 `0`인 경우
- 같은 문서에서 ID 하나를 서로 다른 대상에 겹쳐 할당한 경우
- 같은 문서에서 같은 Edge Id를 두 번 이상 선언한 경우

## 예시

| LOCAL ID | WORD sequence |
|---:|---|
| 1 | `0051 0001` |
| 65535 | `0051 FFFF` |
| 65536 | `0052 0001 0000` |
| 4294967295 | `0052 FFFF FFFF` |
| 1, Variable | `0091 0001` |

## 관련 페이지

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [EXTERNAL-POINTER](0x020L-external-pointer-1word.md)
- [Edge](../edge/_index.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000050/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000005000000000
BODY
#1 DECLARE 0x0050
#2 FIELD #1 rest
#3 BIND #1 "LOCAL-IDENTIFIED"
#4 BIND #2 "local-id"
```

위는 `LOCAL-IDENTIFIED`(`0x005L`)의 코덱 문서다. 다른 구성원(`LOCAL-GENERIC`, `LOCAL-FREE-CHOICE`, `LOCAL-UNIVERSAL`, `LOCAL-VARIABLE`)의 코덱 문서는 DOC-ID의 코덱 ID, DECLARE 대상, `#1`에 묶은 이름(BIND)만 다르다.
