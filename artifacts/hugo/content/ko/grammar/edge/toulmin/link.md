---
title: "LINK"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-31T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LINK는 TOULMIN 노드 사이의 관계(공격, 배제, 실행, 판정 연결, 정의, 이름)를 쓰는 레이아웃이다. src·dst REF와 flag WORD, 선택 확신도 게이트, 선택 공격 세기, SPAN으로 이루어진다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LINK는 TOULMIN 그래프에서 노드 사이의 관계를 쓰는 레이아웃이다. 관계의 종류는 Codec(또는 GEUL ISSUER 형식 번호)이 정한다.

## Codec

| Codec | 이름 | TANGEUL | src → dst |
|---|---|---|---|
| `0x68` | ATTACKS | `don't X when Y` | 규칙 → 규칙. 판정을 공격 세기만큼 점진적으로 깎는다 |
| `0x69` | SUPERSEDES | `X supersedes Y` | 규칙 → 규칙. Active이면 대상을 집계에서 뺀다 |
| `0x70` | RUN | `run c when n` | 규칙 → 사안 |
| `0x71` | DO | `do fn when n` | 규칙 → FuncRef |
| `0x72` | DO-ONCE | `do fn once when n` | 규칙 → FuncRef |
| `0x73` | UNDO | `undo fn when n` | 규칙 → FuncRef |
| `0x74` | CHECKING | `checking c` | 규칙 → 사안. 부작용 없는 판정 |
| ISSUER `0x0000`/`0xC020` | REQUIRES | `f is required` | 사안 → 필드 |
| ISSUER `0x0000`/`0xC021` | MEANS | Definitions `means` | 정의 항목 → 값·타입 |
| ISSUER `0x0000`/`0xC022` | HAS | Definitions `has` | 정의 항목 → 필드 |
| ISSUER `0x0000`/`0xC023` | RUNS | 진입점 `run c` | 진입점 → 사안(실행) |
| ISSUER `0x0000`/`0xC024` | EVALUATES | 진입점 `check c` | 진입점 → 사안(판정) |
| ISSUER `0x0000`/`0xC025` | TRIGGERS | 트리거 `run c` | 트리거 → 사안 |
| ISSUER `0x0000`/`0xC026` | UNTIL | `every … until c` | 트리거 → 사안 |
| ISSUER `0x0000`/`0xC027` | SAME-AS | | 노드 → 전역 식별자 |
| ISSUER `0x0000`/`0xC028` | IMPORTED-FROM | `see a from path` | 별칭 → 경로(TEXT) |
| ISSUER `0x0000`/`0xC029` | LABEL | 백틱 이름 | 노드 → TEXT. 이름 표기 |

## 레이아웃

```
ID               LOCAL Reference 레코드 (Edge Id)
src              REF
dst              REF. DO·DO-ONCE·UNDO는 FuncRef
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED, b4 F_FORCE
[F_GATE]         연산자 1 WORD(상위 2비트) + UNSIGNED-DECIMAL Value(퍼센트)
[F_FORCE]        SIGNED-DECIMAL Value. 공격 세기(0~1). ATTACKS만
SPAN             SOURCE가 정한 폭 × 2
```

| flag | 뜻 |
|---|---|
| b0 F_ONCE | 한 번만 수행한다(UNDO의 `once`) |
| b1 F_GATE | 확신도 게이트 필드가 있다 |
| b2 F_STRIKE | 취소선으로 지운 관계다 |
| b3 F_ORDERED | `1.` 순서 목록에 속한다 |
| b4 F_FORCE | 공격 세기 필드가 있다. ATTACKS만 |

| 게이트 연산자 | 뜻 |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

- 조건부 필드는 flag 순서(F_GATE, F_FORCE)로 둔다. flag가 꺼진 필드는 자리를 차지하지 않는다.

## 공격 세기

공격 세기(Force)는 ATTACKS 간선 하나가 대상을 얼마나 세게 공격하는지를 나타낸다. 범위는 0~1이고 F_FORCE가 없으면 1이다.

- 판정에서 공격자 판정값 v의 기여 `(v+1)/2`에 세기 F를 곱한다. 반박(COUNTER) 공격은 분모 항 `F·(v+1)/2`로, 예외(EXCEPT) 공격은 게이트 `Π(1 − F·(v+1)/2)`로 들어간다. F가 0이면 공격이 판정에 영향을 주지 않는다.
- 값은 [TOULMIN](/ko/grammar/edge/toulmin/#수치) 수치 규칙을 따른다. 인코더는 계수의 끝 0을 지운다(0.5는 `C=5, E=−1`, 1.0은 `C=1, E=0`). 디코더는 소수 4자리까지 받는다.
- 세기를 적지 않은 표면(`don't X when Y`, `` `Y` 면 `X` 는 무효다``)은 F_FORCE를 끈다.
- 세기를 적은 표면(`` `Y` 면 `X` 를 0.5의 세기로 공격한다``)은 F_FORCE를 켜고 그 값을 담는다. `1.0의 세기로`처럼 1을 적어도 F_FORCE를 켜고 1을 담는다. 그래서 원문 표면이 그대로 돌아온다.
- 공격 세기는 노드의 강도(Strict, Defeasible, Defeater)와 다른 축이다. 강도는 노드에, 공격 세기는 ATTACKS 간선에 붙는다.

### 예시

`` `Y` 면 `X` 를 0.5의 세기로 공격한다``. Edge Id 5, 공격자 Y는 Edge Id 3, 대상 X는 Edge Id 2, SPAN 폭 1 WORD.

```
16E8                  TAG WORD: Edge, 전체 14 WORD, Codec 0x68 (ATTACKS)
0088 0005             ID      LOCAL 5
0088 0003             src     LOCAL 3 (Y, 공격자)
0088 0002             dst     LOCAL 2 (X, 대상)
0010                  flags   F_FORCE
0990 FFFF FFFF 0005   F_FORCE SIGNED-DECIMAL, E=−1, C=5 (0.5)
0040 001A             SPAN    시작 바이트 0x40, 바이트 수 0x1A
```

세기를 적지 않은 같은 간선은 flags가 `0000`이고 F_FORCE 필드가 없다. TAG WORD는 `14E8`(전체 10 WORD)이다.

## 해석과 유효성

- REF는 이 문서 레코드의 Edge Id다([TOULMIN](/ko/grammar/edge/toulmin/#공통-필드) 공통 필드).
- dst의 형태는 Codec이 정한다. DO·DO-ONCE·UNDO는 FuncRef(REF(ALIAS, 없으면 0) + VerbCode 1 WORD, [NODE](/ko/grammar/edge/toulmin/node/#필드)), LABEL·IMPORTED-FROM은 TEXT 레코드의 REF, 나머지는 노드의 REF다.
- `do … once`는 DO-ONCE Codec이 나타낸다. DO-ONCE의 flags에는 F_ONCE를 쓰지 않는다(켜져 있으면 거부한다). UNDO의 `once`는 F_ONCE로 쓴다.
- 게이트 연산자는 연산자 WORD의 상위 2비트이고 나머지 14비트는 0이다. 퍼센트는 `E=0`인 UNSIGNED-DECIMAL Value이며 0~100이다.
- flags의 b5~b15는 예약이며 0이어야 한다. 아니면 거부한다.
- F_FORCE는 ATTACKS에서만 쓴다. 다른 Codec(SUPERSEDES, 실행·판정 연결, ISSUER 형식 관계)에서 켜져 있으면 거부한다.
- 공격 세기가 SIGNED-DECIMAL Value가 아니거나, 0~1 밖이거나, 소수 4자리로 정확히 나타낼 수 없으면 거부한다.
- SUPERSEDES의 사슬 `A > B > C`는 쌍마다 SUPERSEDES를 하나씩 쓴다.

## 관련 페이지

- [TOULMIN](/ko/grammar/edge/toulmin/), [NODE](/ko/grammar/edge/toulmin/node/), [SOURCE와 구획](/ko/grammar/edge/toulmin/source/)
- [UNSIGNED-DECIMAL](/ko/grammar/value/decimal/unsigned-decimal/), [SIGNED-DECIMAL](/ko/grammar/value/decimal/signed-decimal/)
