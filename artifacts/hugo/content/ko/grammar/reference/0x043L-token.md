---
title: "TOKEN-0·TOKEN-1 (0x043L·0x044L)"
weight: 67
date: 2026-11-07T12:00:00+09:00
lastmod: 2026-11-07T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "TOKEN은 GEUL 토큰 어휘의 항목 하나를 가리키는 2 WORD Reference다. 이어 쓴 TOKEN 레코드의 바이트를 이으면 원래 텍스트가 된다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | TOKEN-0 | TOKEN-1 |
|---|---|---|
| 이름 | `TOKEN-0` (규격 문서 BIND `TOKEN-0`) | `TOKEN-1` (규격 문서 BIND `TOKEN-1`) |
| TAG ID | `0x043L` | `0x044L` |
| 코덱 ID | `0x00000430` | `0x00000440` |
| 규격 문서 | `0x00000000/codecs/0x00000430/` (DECLARE 대상 `0430`) | `0x00000000/codecs/0x00000440/` (DECLARE 대상 `0440`) |
| 섹션 | 2 `0010` (Reference 기타), 섹션 안 오프셋 C = 3 | 2 `0010`, C = 4 |
| Kind | Reference · 분류: 선언 | Reference · 분류: 선언 |
| TAG WORD | `0000 0100 0011 LLLL` | `0000 0100 0100 LLLL` |
| 토큰 ID | `0`~`65,535` | `65,536`~`131,071` |
| Hugo 쪽 | `reference/token.md` | `reference/token.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | 날값 1 WORD |  | 토큰마다 하나. 어휘 판 1을 공표할 때 채운다 |

TOKEN은 GEUL 토큰 어휘의 항목 하나를 가리키는 Reference다. 어휘는 한국어와 영어를 대상으로 학습한 BPE(Byte Pair Encoding) 어휘이고, 항목 하나는 바이트열 하나다. 이어 쓴 TOKEN 레코드의 바이트열을 순서대로 이으면 원래 텍스트의 바이트가 된다.

- 어휘가 65,536개 안이면 TOKEN-0만 쓴다. 그보다 커지면 넘치는 항목을 TOKEN-1에 둔다. TOKEN-1을 쓰지 않아도 첫 코덱의 이름은 TOKEN-0이다.
- 토큰 하나를 레코드 하나로 쓴다. 크기가 2 WORD로 고정이라, 토큰열의 k번째 레코드는 시작에서 4k바이트 떨어진 곳에 있다.

## 레이아웃

```
TAG WORD          0x0431 (0000 0100 0011 0001)  TOKEN-0, 전체 2 WORD
Payload WORD 1st (16비트)           토큰 ID (uint16)

TAG WORD          0x0441 (0000 0100 0100 0001)  TOKEN-1, 전체 2 WORD
Payload WORD 1st (16비트)           토큰 ID − 65,536 (uint16)
```

- 코드: Reference 직접 코드 `0x043L`·`0x044L`(섹션 2).
- Payload는 대상 ID다. [Reference 공통 레이아웃](_index.md)대로 부호 없는 빅 엔디언 정수를 가장 짧은 폭으로 쓰는데, 대상 ID가 늘 `0`~`65,535`라 Payload는 늘 1 WORD다(`0`은 `0x0000`).
- 양화가 없다(양화는 5Q 체계에서만 읽는다).

## 해석과 유효성

- 각 코덱의 대상 ID는 Payload 값이다. 어휘 전체의 토큰 ID는 TOKEN-0이면 대상 ID, TOKEN-1이면 65,536 + 대상 ID다.
- 토큰의 정식 표현은 그 코덱의 규격 문서다. 토큰 ID마다 FIELD `code`에 [ENUM](../edge/0x0BDL-enum.md)이 하나 있고, 그 ENUM Edge Id에 [BIND](../edge/0x0A3L-bind.md)로 묶인 이름이 토큰의 바이트열이다. TOKEN-1의 ENUM 코드값은 Payload 값(토큰 ID − 65,536)이다.
- 어휘는 닫힌 목록이다. 규격 문서에 ENUM이 없는 토큰 ID는 invalid다. ENUM 일반 규칙("선언되지 않은 코드값은 오류가 아니다")보다 이 Codec 규칙이 앞선다.
- **바이트 토큰:** 토큰 ID `0`~`255`는 바이트 하나다. 토큰 ID가 곧 바이트 값이다. 한국어·영어 밖의 문자처럼 어휘에 없는 글자는 그 UTF-8 바이트를 바이트 토큰으로 적는다. 바이트 토큰의 BIND 이름은 기계 이름 `<0x00>`~`<0xFF>`이고, 뜻은 이 규칙이 정한다.
- **그 밖의 토큰:** 바이트열이 올바른 UTF-8이고, BIND 이름이 그 바이트열 그대로다.
- **디코딩:** TOKEN 레코드 열을 앞에서부터 읽어 각 토큰의 바이트열을 잇는다. 바이트 토큰이 이어져 만든 UTF-8 글자도 이 이음으로 복원된다. 결과는 인코딩 전 텍스트와 바이트까지 같다.
- **인코딩:** 텍스트를 토큰열로 나누는 방법(분할 규칙과 병합 순서)은 어휘 판에 딸린다. 같은 텍스트라도 어휘 판이 다르면 토큰열이 다를 수 있다. 디코딩 결과는 판과 상관없이 같다.
- **판:** 어휘 판은 규격 문서의 버전이다. 각 판은 어휘 파일과 학습 기록의 해시를 규격 문서 HEAD의 [SOURCE](../edge/0x0C0L-source.md)로 적는다. 토큰열을 만든 판을 밝혀야 할 때는 그 버전([CODEC-POINTER](0x042L-codec-pointer.md)(`0x00000000`, `0x00000430`, 버전 ID `n`))을 함께 남긴다.
- **덧붙이기만:** 새 판은 ENUM과 BIND를 뒤에 덧붙이기만 한다. 한 번 준 토큰 ID의 바이트열은 바꾸지 않고, 지우거나 다시 쓰지 않는다. 그래서 어느 판이든 앞 판의 상위집합이고, 앞 판으로 만든 토큰열은 뒤 판으로도 똑같이 디코딩된다. 어휘를 처음부터 다시 학습해 뜻이 바뀌면 이 코덱을 쓰지 않고 새 코덱 번호를 받는다.
- 토큰은 Reference라서 [BIND](../edge/0x0A3L-bind.md), [LABEL](../edge/0x0A4L-label.md), [TRIPLE](../edge/0x0AAL-triple.md)의 주어가 될 수 있다(예: 토큰의 출현 빈도, 언어).

## 길이

- 전체는 TAG 1 WORD와 Payload 1 WORD를 합한 정확히 2 WORD이고 직접 길이 `LLLL=0001`을 쓴다. Length 확장 TAG, Codec 확장 TAG, Codec별 TAG는 없다.
- Payload가 정확히 1 WORD가 아니면 거부한다.

## 예시

어휘 판 1이 공표되기 전이라 일반 토큰의 번호는 아직 없다. 바이트 토큰은 규칙으로 번호가 정해져 있다.

| 토큰 | 토큰 ID | 전체 WORD |
|---|---|---|
| 바이트 `0xE3` | `227` | `0431 00E3` |
| 바이트 `0x80` | `128` | `0431 0080` |

## 열린 문제

- 어휘 판 1의 공표. 학습과 검증을 마친 뒤 규격 문서에 ENUM과 BIND를 채운다.
- 토큰열을 문서에 담는 형식. 어느 Edge나 Value 필드가 TOKEN 레코드 열을 받는지 정하지 않았다.
- 인코딩 정규형. 분할 규칙과 병합 순서를 규격 문서에 어떻게 적을지, 같은 텍스트의 토큰열을 하나로 정할지.
- 판 사이 해석. 읽는 쪽이 가진 판보다 새 토큰 ID를 만났을 때 invalid로 버릴지, 원값을 보존한 채 "모르는 토큰"으로 다룰지.

## 관련 페이지

- [Reference](_index.md), [CODEC-POINTER](0x042L-codec-pointer.md)
- [Codec 규격 문서](../codec-spec.md), [ENUM](../edge/0x0BDL-enum.md), [BIND](../edge/0x0A3L-bind.md), [SOURCE](../edge/0x0C0L-source.md)
- 같은 꼴의 레지스트리: [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000430/`은 어휘 판 1과 함께 공표한다. 아직 공표 전이다. 꼴은 다음과 같다(설명용).

```
BODY
#1 DECLARE 0x0430
#2 FIELD #1 0x0001
#3 BIND #1 "TOKEN-0"
#4 BIND #2 "code"
#5 ENUM #2 0x0000
#6 BIND #5 "<0x00>"
…
```
