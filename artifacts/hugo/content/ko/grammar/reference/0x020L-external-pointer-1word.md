---
title: "EXTERNAL-POINTER-1WORD (0x020L~0x024L)"
weight: 32
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-POINTER는 HEAD의 IMPORT-DOC으로 가져온 문서의 LOCAL ID를 가리키는 지시 Reference다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-POINTER는 HEAD의 IMPORT-DOC으로 가져온 문서의 LOCAL ID를 가리키는 지시 Reference다.

| 항목 | 값 |
|---|---|
| 이름 | `EXTERNAL-POINTER-1WORD` (5Q 묶음. 코드별 이름은 아래 구성원 표) |
| TAG ID | `0x020L~0x024L` |
| 섹션 | 1 `0001` (Reference EXTERNAL), 섹션 안 오프셋 C = 0~4 |
| Kind | Reference · 분류: 지시 |
| Hugo 쪽 | `reference/external-pointer.md` (그 쪽은 [EXTERNAL-POINTER-2WORD](0x025L-external-pointer-2word.md), [EXTERNAL-POINTER-4WORD](0x02AL-external-pointer-4word.md)도 함께 다룬다) |

## 구성원

이 쪽은 5Q 체계 한 벌, 코드 다섯 개를 함께 다룬다. 양화는 섹션 안 오프셋 `C % 5`다([Reference](_index.md#quantifier)). 코덱 문서는 코드마다 하나다. 다섯 코덱 문서의 필드는 같고 DECLARE 대상과 이름(BIND)만 다르다.

| TAG ID | 이름 | 양화 | 코덱 ID | 규격 문서 | TAG WORD |
|---|---|---|---|---|---|
| `0x020L` | `EXTERNAL-POINTER-1WORD-IDENTIFIED` | Identified | `0x00000200` | `0x00000000/codecs/0x00000200/` | `0000 0010 0000 LLLL` |
| `0x021L` | `EXTERNAL-POINTER-1WORD-GENERIC` | Generic | `0x00000210` | `0x00000000/codecs/0x00000210/` | `0000 0010 0001 LLLL` |
| `0x022L` | `EXTERNAL-POINTER-1WORD-FREE-CHOICE` | Free-choice | `0x00000220` | `0x00000000/codecs/0x00000220/` | `0000 0010 0010 LLLL` |
| `0x023L` | `EXTERNAL-POINTER-1WORD-UNIVERSAL` | Universal | `0x00000230` | `0x00000000/codecs/0x00000230/` | `0000 0010 0011 LLLL` |
| `0x024L` | `EXTERNAL-POINTER-1WORD-VARIABLE` | Variable | `0x00000240` | `0x00000000/codecs/0x00000240/` | `0000 0010 0100 LLLL` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `import-id` | #2 | 날값 1 WORD |  |  |
| 2 | `target-id` | #3 | 나머지 날값(`0xFFFF`) |  |  |

EXTERNAL-POINTER는 HEAD의 [IMPORT-DOC](../meta/0x1E4L-import-doc.md)으로 가져온 문서의 LOCAL ID를 가리키는 지시 Reference다.

## 레이아웃

```
TAG WORD          0000 001C CCCC LLLL      Codec 0x020L~0x02EL (섹션 1)
[Length 확장 TAG]
IMPORT ID         Codec이 정한 폭 (1/2/4 WORD)
대상 ID           나머지 전부. 가져온 문서의 LOCAL ID, 가장 짧은 폭
```

| Codec (Identified, Generic, Free-choice, Universal, Variable) | 이름 | IMPORT ID 폭 |
|---|---|---|
| `0x020L~0x024L` | EXTERNAL-POINTER-1WORD | 1 WORD |
| `0x025L~0x029L` | EXTERNAL-POINTER-2WORD | 2 WORD |
| `0x02AL~0x02EL` | EXTERNAL-POINTER-4WORD | 4 WORD |

- 폭은 체계 번호로 정해진다: 체계 − 6(섹션 안 오프셋 `C`의 `C / 5`)이 0, 1, 2이면 1, 2, 4 WORD다. 양화는 `C % 5`다.

- IMPORT ID 값이 들어가는 가장 좁은 Codec을 쓴다.
- IMPORT ID는 이 문서의 `IMPORT-DOC`이 배정한 값이다. EXTERNAL-POINTER에는 Issuer를 적지 않는다. Issuer와 문서 ID는 그 `IMPORT-DOC`에서 얻는다. 버전도 그 `IMPORT-DOC`이 정한다(고정 또는 최신).
- 가져온 문서의 같은 LOCAL ID면, 그 문서 안에서 LOCAL로 쓰든 여기서 EXTERNAL-POINTER로 쓰든 같은 대상이다.
- Variable이면 가져온 문서의 LOCAL 변수다.

## 유효성

- 이 문서에 그 IMPORT ID를 배정한 `IMPORT-DOC`이 없으면 invalid다.
- IMPORT ID가 더 좁은 Codec에 들어가는데 넓은 Codec을 쓰면 non-minimal로 거부한다.
- 대상 ID가 `0`이면 invalid다. 가져온 문서 자신은 [DOC-POINTER](0x041L-doc-pointer.md)로 가리킨다.
- 대상 ID의 선행 `0x0000` WORD는 금지한다.

## 예시

| 대상 | WORD sequence |
|---|---|
| IMPORT ID 1의 LOCAL 5 | `0202 0001 0005` |
| IMPORT ID 1의 LOCAL 65536 | `0203 0001 0001 0000` |
| IMPORT ID 70000의 LOCAL 5 | `0253 0001 1170 0005` |

## 관련 페이지

- [Reference](_index.md), [LOCAL](0x005L-local.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [DOC-POINTER](0x041L-doc-pointer.md)
- [IMPORT-DOC](../meta/0x1E4L-import-doc.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000200/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000020000000000
BODY
#1 DECLARE 0x0200
#2 FIELD #1 0x0001
#3 FIELD #1 rest
#4 BIND #1 "EXTERNAL-POINTER-1WORD-IDENTIFIED"
#5 BIND #2 "import-id"
#6 BIND #3 "target-id"
```

위는 `EXTERNAL-POINTER-1WORD-IDENTIFIED`(`0x020L`)의 코덱 문서다. 다른 구성원(`EXTERNAL-POINTER-1WORD-GENERIC`, `EXTERNAL-POINTER-1WORD-FREE-CHOICE`, `EXTERNAL-POINTER-1WORD-UNIVERSAL`, `EXTERNAL-POINTER-1WORD-VARIABLE`)의 코덱 문서는 DOC-ID의 코덱 ID, DECLARE 대상, `#1`에 묶은 이름(BIND)만 다르다.
