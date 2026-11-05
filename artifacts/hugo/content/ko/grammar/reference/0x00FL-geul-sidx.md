---
title: "GEUL-SIDX (0x00FL~0x013L)"
weight: 15
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL-SIDX는 GEUL SIDX(Semantic-aligned Index)로 대상을 가리키는 선언 Reference다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `GEUL-SIDX` (5Q 묶음. 코드별 이름은 아래 구성원 표) |
| TAG ID | `0x00FL~0x013L` |
| 섹션 | 0 `0000` (Reference 엔티티), 섹션 안 오프셋 C = 15~19 |
| Kind | Reference · 분류: 선언 |
| Hugo 쪽 | `reference/geul-sidx.md` |

## 구성원

이 쪽은 5Q 체계 한 벌, 코드 다섯 개를 함께 다룬다. 양화는 섹션 안 오프셋 `C % 5`다([Reference](_index.md#quantifier)). 코덱 문서는 코드마다 하나다. 다섯 코덱 문서의 필드는 같고 DECLARE 대상과 이름(BIND)만 다르다.

| TAG ID | 이름 | 양화 | 코덱 ID | 규격 문서 | TAG WORD |
|---|---|---|---|---|---|
| `0x00FL` | `GEUL-SIDX-IDENTIFIED` | Identified | `0x000000F0` | `0x00000000/codecs/0x000000F0/` | `0000 0000 1111 LLLL` |
| `0x010L` | `GEUL-SIDX-GENERIC` | Generic | `0x00000100` | `0x00000000/codecs/0x00000100/` | `0000 0001 0000 LLLL` |
| `0x011L` | `GEUL-SIDX-FREE-CHOICE` | Free-choice | `0x00000110` | `0x00000000/codecs/0x00000110/` | `0000 0001 0001 LLLL` |
| `0x012L` | `GEUL-SIDX-UNIVERSAL` | Universal | `0x00000120` | `0x00000000/codecs/0x00000120/` | `0000 0001 0010 LLLL` |
| `0x013L` | `GEUL-SIDX-VARIABLE` | Variable | `0x00000130` | `0x00000000/codecs/0x00000130/` | `0000 0001 0011 LLLL` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `sidx` | #2 | 나머지 날값(`0xFFFF`) |  |  |

GEUL-SIDX는 GEUL SIDX(Semantic-aligned Index)로 대상을 가리키는 선언 Reference다. SIDX는 비트 자체에 의미(종류, 속성)를 담은 식별자다.

## 레이아웃

```
TAG WORD          0000 0000 1111 LLLL      Codec 0x00FL~0x013L (Identified 0x00FL)
[Length 확장 TAG]
SIDX              나머지 전부
```

- Quantifier는 다른 선언 Codec과 같다. Variable이면 그 종류의 익명 변수다([Reference](_index.md) Variable). 양화는 5Q 코드(`0x00FL~0x013L`, `C % 5`)로만 한다. SIDX 값에는 양화를 넣지 않는다.
- 규격 문서는 SIDX를 나머지 폭 날값 필드 하나로 선언한다. 폭 규칙이 정해지면 바꾼다.

## 예시

| SIDX | WORD sequence |
|---|---|
| (비규범) 64비트 `0x1234 5678 9ABC DEF0`, Identified | `00F4 1234 5678 9ABC DEF0` |

## 배정 방침

- [GEUL](0x00AL-geul.md)과 역할이 다르다. GEUL은 대체로 순서대로(auto increment) 배정하는 정체성 ID이고, GEUL-SIDX는 의미가 가까운 대상에 가까운 값을 주는 의미 주소다.
- 가까운 정도는 사용 데이터를 쌓아 통계로 정한다. 통계가 모이기 전에는 GEUL ID를 쓰고, SIDX를 배정한 뒤 같은 대상의 GEUL과 GEUL-SIDX를 [SAME-NODE](../edge/0x0A1L-same-node.md)로 잇는다.

## 열린 문제

- **폭.** 통계를 보고 정한다. 4 WORD(64비트)와 16 WORD 등을 검토하고 있다. SIDX는 상위 비트에 의미가 있어 다른 선언 Codec의 "가장 짧은 폭" 규칙(선행 `0x0000` 금지)을 그대로 쓸 수 없다. 그래서 고정 폭(또는 하위 형식별 고정 폭)이 될 것이다. 정해질 때까지 규격 문서는 SIDX를 나머지 폭 날값으로 선언한다.
- **배정의 안정성.** Reference는 정수값이 같으면 같은 대상이고, 배정한 ID를 재사용하지 않는다. 통계가 바뀌어도 이미 배정한 SIDX를 옮기지 않으려면 append-only 배정(의미가 가까운 자리를 남겨 두는 희소 배정)이 필요하다. 옮길 일이 잦으면 SIDX를 영구 식별자가 아니라 레지스트리 판본에 묶인 색인으로 정의할지 정한다.
- **유일성.** SIDX가 비트 의미로 생성되어 충돌할 수 있으면 "정수값이 같으면 같은 대상" 전제와 맞지 않는다. 배정할 때 충돌을 해소해 유일성을 보장한다.
- 코드북과 레지스트리 공개 형식.

## 관련 페이지

- [Reference](_index.md), [GEUL](0x00AL-geul.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x000000F0/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000000F000000000
BODY
#1 DECLARE 0x00F0
#2 FIELD #1 rest
#3 BIND #1 "GEUL-SIDX-IDENTIFIED"
#4 BIND #2 "sidx"
```

위는 `GEUL-SIDX-IDENTIFIED`(`0x00FL`)의 코덱 문서다. 다른 구성원(`GEUL-SIDX-GENERIC`, `GEUL-SIDX-FREE-CHOICE`, `GEUL-SIDX-UNIVERSAL`, `GEUL-SIDX-VARIABLE`)의 코덱 문서는 DOC-ID의 코덱 ID, DECLARE 대상, `#1`에 묶은 이름(BIND)만 다르다.
