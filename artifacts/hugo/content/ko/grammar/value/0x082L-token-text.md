---
title: "TOKEN-TEXT (0x082L)"
weight: 130
date: 2026-11-07T21:00:00+09:00
lastmod: 2026-11-07T21:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "TOKEN-TEXT는 텍스트를 GEUL 토큰열로 적는 Value다. Payload는 TAG를 포함한 TOKEN-0·TOKEN-1 레코드를 순서대로 이은 것이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `TOKEN-TEXT` (규격 문서 BIND `TOKEN-TEXT`) |
| TAG ID | `0x082L` |
| 코덱 ID | `0x00000820` |
| 규격 문서 | `0x00000000/codecs/0x00000820/` (DECLARE 대상 `0820`) |
| 섹션 | 4 `0100` (Value), 섹션 안 오프셋 C = 2 |
| Kind | Value · 계열: TEXT |
| TAG WORD | `0000 1000 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 텍스트를 TOKEN-0·TOKEN-1 레코드열로 적는다(레코드마다 TAG 포함 2 WORD) |
| Hugo 쪽 | `value/text/token-text.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `tokens` | #2 | 나머지 날값(`0xFFFF`) |  |  |

TOKEN-TEXT는 텍스트 하나를 GEUL 토큰열로 적는 Value다. Payload는 [TOKEN-0·TOKEN-1](../reference/0x043L-token.md) 레코드를 순서대로 이은 것이고, 레코드마다 TAG를 그대로 둔다. 토큰의 바이트열을 순서대로 이으면 원래 텍스트가 된다.

- 토큰 ID만 날값으로 적으면 토큰당 1 WORD로 줄지만, TAG를 함께 적는다. 레코드 하나하나가 그대로 TOKEN Reference라서 따로 떼어 읽거나 가리킬 수 있고, TOKEN-0과 TOKEN-1을 섞어 쓸 수 있다.
- 레코드열은 [Codec 규격 문서](../codec-spec.md)의 FIELD로 반복을 선언할 수 없어, 규격 문서에는 나머지 날값 하나로 선언한다. 그 날값을 TOKEN 레코드열로 읽는 것은 이 Codec의 규칙이다.

## 레이아웃

```
TAG WORD          0000 1000 0010 LLLL      Codec 0x082L
[Length 확장 TAG]                          전체 15 WORD 이상일 때
Payload           TOKEN 레코드 × N         레코드마다 2 WORD
  TOKEN-0         0x0431 + 토큰 ID         (토큰 ID 0~65,535)
  TOKEN-1         0x0441 + 토큰 ID − 65,536 (토큰 ID 65,536~131,071)
```

- 코드: Value 직접 코드 `0x082L`. 계열 TEXT.
- 토큰 수 N은 따로 적지 않는다. Payload WORD 수 ÷ 2다.
- 토큰 0개(빈 텍스트)는 TAG 1 WORD(`0x0820`)다.

## 해석과 유효성

- Payload를 앞에서부터 2 WORD씩 읽는다. 각 2 WORD는 TAG WORD `0x0431`(TOKEN-0) 또는 `0x0441`(TOKEN-1)로 시작하는 완전한 TOKEN 레코드여야 한다. 다른 레코드, 다른 Length, 홀수 WORD의 Payload는 invalid다.
- 각 토큰 ID는 그 TOKEN 코덱의 규칙을 따른다. 어휘 규격 문서에 ENUM이 없는 토큰 ID는 invalid다.
- **텍스트:** 토큰의 바이트열을 순서대로 이은 바이트가 이 Value의 텍스트다. 이 바이트는 올바른 UTF-8이어야 한다. 바이트 토큰 여러 개가 이어져 글자 하나를 이루는 것은 허용하지만, 이은 결과가 UTF-8이 아니면 invalid다.
- **같음:** 두 TOKEN-TEXT는 이은 바이트가 같으면 같은 텍스트다. 토큰열이 달라도 같을 수 있다(어휘 판에 따라 나뉘는 방식이 다르다).
- **정규화:** 정규화를 암시하지 않는다. 바이트를 그대로 보존한다([UTF8-TEXT](0x072L-utf8-text.md)와 같다).
- **언어:** 언어를 담지 않는다. 언어가 필요한 자리는 [UTF8-LANGUAGE-TEXT](0x078L-utf8-language-text.md)를 쓰거나, 이 Value를 담은 진술에 언어 한정(예: P407)을 붙인다.
- **어휘 판:** 디코딩에는 판이 필요 없다(어휘는 덧붙이기만 한다). 어느 판으로 나눴는지 밝혀야 할 때는 그 판([CODEC-POINTER](../reference/0x042L-codec-pointer.md)(`0x00000000`, `0x00000430`, 버전 ID `n`))을 함께 남긴다.
- **쓰는 자리:** 섹션 4 Value를 받는 필드에 쓸 수 있다. [TRIPLE](../edge/0x0AAL-triple.md)의 object와 [QUALIFIER](../edge/0x0ABL-qualifier.md)의 value는 Value 섹션 전체를 받으므로 이 Value를 받는다(예: 인용 P1683). 이름 자리([BIND](../edge/0x0A3L-bind.md)의 이름, [LABEL](../edge/0x0A4L-label.md)의 텍스트)는 받지 않는다.

## 길이

- 전체 WORD 수는 1 + 2N이다(Length 확장 TAG를 쓰면 그만큼 더한다). 전체 14 WORD(토큰 6개)까지는 직접 길이를 쓰고, 그보다 길면 Length 확장 TAG를 쓴다([레코드와 TAG WORD](../record.md)).
- Payload WORD 수가 홀수면 거부한다.

## 예시

어휘 판 1(TOKEN-0 규격 문서 버전 1)의 토큰으로 적은 예다. 인코딩 정규형은 아직 정하지 않았으므로(열린 문제), 같은 텍스트가 다른 토큰열로 적힐 수도 있다.

| 텍스트 | 토큰 ID | 전체 WORD |
|---|---|---|
| (빈 텍스트) | 없음 | `0820` |
| ` the` | `0x2DE5` | `0822 0431 2DE5` |
| `한국어` | `0xD0B8` | `0822 0431 D0B8` |
| `가` + ` the` | `0x021B`, `0x2DE5` | `0824 0431 021B 0431 2DE5` |

- TAG WORD의 Length 자리는 전체 WORD 수 − 1이다. 토큰 1개는 전체 3 WORD라 `0x0822`, 토큰 2개는 5 WORD라 `0x0824`다.
- ` the`는 앞에 공백이 붙은 토큰이다. 공백 없는 `the`는 다른 토큰(`0x328D`)이다.

## 열린 문제

- 인코딩 정규형. 같은 텍스트의 토큰열을 하나로 정할지(분할 규칙과 병합 순서를 규격에 적는 방법은 [TOKEN](../reference/0x043L-token.md)의 열린 문제와 같다).
- 레코드 반복 필드. FIELD로 레코드열을 선언할 수 없어 나머지 날값으로 선언했다. 반복을 선언하는 방법이 생기면 그쪽으로 옮길지.
- 이름 자리(BIND, LABEL)에서 이 Value를 받을지.

## 관련 페이지

- [TOKEN-0·TOKEN-1](../reference/0x043L-token.md), [UTF8-TEXT](0x072L-utf8-text.md), [UTF8-LANGUAGE-TEXT](0x078L-utf8-language-text.md)
- [Codec 규격 문서](../codec-spec.md), [레코드와 TAG WORD](../record.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000820/`은 아직 공표 전이다. 꼴은 다음과 같다(설명용).

```
BODY
#1 DECLARE 0x0820
#2 FIELD #1 0xFFFF
#3 BIND #1 "TOKEN-TEXT"
#4 BIND #2 "tokens"
```
