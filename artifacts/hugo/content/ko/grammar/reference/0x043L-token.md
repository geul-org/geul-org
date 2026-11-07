---
title: "TOKEN-0·TOKEN-1 (0x043L·0x044L)"
weight: 67
date: 2026-11-07T12:00:00+09:00
lastmod: 2026-11-07T20:00:00+09:00
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
| 1 | `token-id` | #2 | 날값 1 WORD |  | ENUM 60,536개(토큰 ID `0x0000`~`0xEC77`). 예: `0x0000` `<0x00>`, `0x021B` 가, `0x2DE5` ` the`, `0xE75E` 한국 … |

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
- 토큰의 정식 표현은 그 코덱의 규격 문서다. 토큰 ID마다 FIELD `token-id`에 [ENUM](../edge/0x0BDL-enum.md)이 하나 있고, 그 ENUM Edge Id에 [BIND](../edge/0x0A3L-bind.md)로 묶인 이름이 토큰의 바이트열이다. TOKEN-1의 ENUM 코드값은 Payload 값(토큰 ID − 65,536)이다.
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

어휘 판 1(규격 문서 `0x00000000/codecs/0x00000430` 버전 1)의 번호다. 토큰 60,536개를 배정했다: 바이트 256, 기본 글자 283(공백·줄바꿈·탭, ASCII, 한글 자모, 기호), 한글 음절 11,172(`0x021B` 가 ~ `0x2DBE` 힣), 병합 48,825. `0xEC78`~`0xFFFF`는 덧붙일 자리로 비워 두었다.

| 토큰(바이트열) | 토큰 ID | 전체 WORD |
|---|---|---|
| 바이트 `0xE3` | `0x00E3` | `0431 00E3` |
| `가` | `0x021B` | `0431 021B` |
| ` the`(앞에 공백) | `0x2DE5` | `0431 2DE5` |
| ` GEUL`(앞에 공백) | `0x377F` | `0431 377F` |
| `한국어` | `0xD0B8` | `0431 D0B8` |

- 규격 문서에서 ` the`는 `ENUM #2 0x2DE5`와 그 Edge Id에 묶인 `BIND " the"`다.
- 공백은 뒤 단어에 붙는다. 그래서 ` the`와 `the`(`0x328D`)는 다른 토큰이다.

## 열린 문제

- 토큰열을 문서에 담는 형식. 어느 Edge나 Value 필드가 TOKEN 레코드 열을 받는지 정하지 않았다.
- 인코딩 정규형. 분할 규칙과 병합 순서를 규격 문서에 어떻게 적을지, 같은 텍스트의 토큰열을 하나로 정할지.
- 판 사이 해석. 읽는 쪽이 가진 판보다 새 토큰 ID를 만났을 때 invalid로 버릴지, 원값을 보존한 채 "모르는 토큰"으로 다룰지.

## 관련 페이지

- [Reference](_index.md), [CODEC-POINTER](0x042L-codec-pointer.md)
- [Codec 규격 문서](../codec-spec.md), [ENUM](../edge/0x0BDL-enum.md), [BIND](../edge/0x0A3L-bind.md), [SOURCE](../edge/0x0C0L-source.md)
- 같은 꼴의 레지스트리: [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000430/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자). HEAD의 두 SOURCE는 어휘 파일과 학습 기록의 SHA-256이다.

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000043000000000
#121077 SOURCE #0 ABSENT
#121078 QUALIFIER P4092 #121077 SHA-256-DIGEST(0xE4DEEA8BA9FE74BEAAD836FEBE06CF4DAC32B30D1E9A85308D0A6E0A9CB6A417)
#121079 SOURCE #0 ABSENT
#121080 QUALIFIER P4092 #121079 SHA-256-DIGEST(0x5B2C82701BCFFD3589DC9640B398B3F07F0AC7F18E483486AF5221C3D30D4D9C)
BODY
#1 DECLARE 0x0430
#2 FIELD #1 0x0001
#3 BIND #1 "TOKEN-0"
#4 BIND #2 "token-id"
#5 ENUM #2 0x0000
#6 BIND #5 "<0x00>"
#7 ENUM #2 0x0001
#8 BIND #7 "<0x01>"
… (ENUM·BIND 121,064줄 생략)
#121073 ENUM #2 0xEC76
#121074 BIND #121073 "etap"
#121075 ENUM #2 0xEC77
#121076 BIND #121075 " Aman"
```
