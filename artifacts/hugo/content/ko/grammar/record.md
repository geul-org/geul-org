---
title: "레코드와 TAG WORD"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "record", "TAG"]
summary: "모든 레코드는 TAG WORD 16비트로 시작한다. Prefix 3비트, Kind 2비트, Length 4비트, Codec 7비트로 레코드의 종류와 길이를 정한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL 데이터는 레코드의 연속이다. 모든 레코드는 TAG WORD 하나로 시작한다.

## 레코드 레이아웃

```
TAG WORD (16비트)
┌──────────┬─────────┬──────────┬─────────────────────┐
│  Prefix  │  Kind   │  Length  │        Codec        │
│   3bit   │  2bit   │   4bit   │        7bit         │
│   000    │   KK    │   LLLL   │       CCCCCCC       │
└──────────┴─────────┴──────────┴─────────────────────┘
[Length 확장 TAG]
[Codec 확장 TAG]
[Codec별 TAG]
Payload
```

- TAG WORD는 `000K KLLL LCCC CCCC`다.
- 확장 TAG는 위 순서대로만 둔다. Length 확장 TAG는 항상 TAG WORD 바로 다음이다.
- Codec별 TAG와 Payload의 구성은 각 Codec 규격이 정한다.

## 바이트 순서

- 정규 직렬화는 빅 엔디언이다.
- 비트 필드는 최상위 비트부터 배치한다.
- WORD 안에서는 상위 바이트를 먼저, 여러 WORD로 된 값은 상위 WORD를 먼저 쓴다.
- 메모리 안의 표현은 구현이 자유롭게 정한다.

## Kind (2비트)

| 값 | Kind | TAG WORD | 정의 |
|---|---|---|---|
| `00` | Reference | `0000 0LLL LCCC CQQQ` | 대상을 가리킨다. Codec과 대상 ID로 대상을 식별한다 |
| `01` | Value | `0000 1LLL LCCC CCCC` | 값 자체를 담는다. Codec이 Payload의 해석을 정한다 |
| `10` | Edge | `0001 0LLL LCCC CCCC` | 다른 레코드를 구성요소로 묶는다. Codec이 구성요소의 역할과 순서를 정한다 |
| `11` | Meta | `0001 1LLL LCCC CCCC` | 문서와 레코드에 관해 말한다 |

- Kind는 Codec의 불변 속성이다. 한 번 배정한 Codec은 Kind를 옮기지 않는다.
- Value와 Edge는 같은 "Codec + Payload" 형식이다. Edge만 다른 레코드를 구성요소로 가진다.
- Reference는 Codec 7비트를 Codec 4비트와 Quantifier 3비트로 나눠 쓴다([Reference](/ko/grammar/reference/)).

## Length (4비트)

Length는 레코드가 차지하는 **전체 WORD 수**다. TAG WORD, 확장 TAG, Payload, 마지막 WORD의 패딩을 모두 포함한다.

| 값 | 의미 |
|---|---|
| `0000`~`1101` | 1~14 WORD (값 + 1) |
| `1110` | 확장 길이 1: 다음 1 WORD에 전체 WORD 수 (15~65,535) |
| `1111` | 확장 길이 2: 다음 2 WORD에 전체 WORD 수 (65,536~2³²−1) |

- 1~14 WORD는 반드시 직접 길이로 쓴다. 더 넓은 표기는 정규형이 아니다.
- 확장 길이의 전체 WORD 수에는 Length 확장 TAG 자신도 들어간다.
- 2³²−1 WORD를 넘는 레코드는 없다.
- 1 WORD 레코드는 Payload 없이 TAG WORD 하나다. Codec 규격이 허용할 때만 쓴다(예: Meta `BODY`, `END`).
- 코덱북이 없어도 `다음 레코드 위치 = 현재 레코드 시작 + Length`로 레코드를 건너뛸 수 있다.

## Codec (7비트)

| 값 | 이름 | 뜻 |
|---|---|---|
| `0x00`~`0x7B` | 직접 코드 | TAG WORD만으로 Codec이 정해진다 |
| `0x7C` | ISSUER-1WORD | Codec 확장 TAG에 Issuer 1 WORD와 형식 번호 1 WORD |
| `0x7D` | ISSUER-2WORD | Codec 확장 TAG에 Issuer 2 WORD와 형식 번호 1 WORD |
| `0x7E` | ISSUER-4WORD | Codec 확장 TAG에 Issuer 4 WORD와 형식 번호 1 WORD |
| `0x7F` | ISSUER-16WORD | Codec 확장 TAG에 Issuer 16 WORD와 형식 번호 1 WORD |

- Codec 번호 공간은 Kind마다 따로 있다. 같은 번호라도 Kind가 다르면 다른 Codec이다.
- 직접 코드가 아닌 Codec은 `(Issuer, 형식 번호)` 쌍이다. 형식 번호는 그 Issuer가 정의한다([Issuer와 공표](/ko/grammar/issuer/)).
- Issuer 형식은 Value와 Edge에만 있다. Reference는 Codec 4비트를 쓰고, Meta는 GEUL만 정의하는 공통 규격이다.
- Codec과 형식 번호의 상위 비트는 계열(Value·Edge) 또는 클래스(Meta)를 나타낸다. 코덱북 없이도 계열을 안다.
- 직접 코드는 회수할 수 없다. 빈도가 확인된 형식만 직접 코드에 둔다.

## Issuer 형식 레코드

```
TAG WORD          Codec = 0x7C~0x7F
[Length 확장 TAG]
Issuer            1/2/4/16 WORD (Codec이 폭을 정한다)
형식 번호         1 WORD. 상위 비트가 계열
Payload           형식이 정한 값
```

- 형식을 모르는 디코더는 형식 번호의 계열만 알고 Payload를 건너뛴다.

## 가변 길이 바이트열

텍스트, URI, 언어 태그, 불명 바이트열처럼 길이가 바이트 단위인 값은 Codec(또는 형식 번호)을 **짝수·홀수 쌍**으로 배정한다.

- Codec의 최하위 비트가 `0`이면 바이트 수가 짝수, `1`이면 홀수다.
- 바이트 수 = `2 × Payload WORD 수 − 최하위 비트`. Byte Count 필드는 없다.
- 홀수면 마지막 WORD의 하위 바이트는 `0x00` 패딩이다. `0x00`이 아니면 거부한다.
- 빈 바이트열은 짝수 Codec의 1 WORD 레코드(TAG WORD만)다.
- UUID·다이제스트·주소처럼 크기가 정해진 값은 쌍을 두지 않는다.

## 예: TAG WORD 읽기

`148A`를 읽어 보자.

```
0x148A = 0001 0100 1000 1010
         000 | 10 | 1001 | 0001010
Prefix 000, Kind 10(Edge), Length 1001(10 WORD), Codec 0x0A(TRIPLE)
```

이 레코드는 10 WORD짜리 Edge이고 Codec은 TRIPLE이다. 코덱북이 없어도 다음 레코드가 10 WORD 뒤에 있다는 것을 안다.

## 정규형

같은 내용은 같은 바이트가 되어야 한다. 그래야 내용 해시와 서명이 하나로 정해진다.

- 길이는 가장 짧은 표기를 쓴다(1~14 WORD는 직접 길이).
- 정수는 가장 짧은 폭으로 쓴다. 각 Codec 규격이 정한 정규형을 따른다.
- 정규형이 아닌 레코드는 거부한다.
