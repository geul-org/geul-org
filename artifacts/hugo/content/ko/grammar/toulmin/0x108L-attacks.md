---
title: "ATTACKS (0x108L)"
weight: 264
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "ATTACKS는 TOULMIN 그래프의 관계를 쓰는 LINK Codec이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ATTACKS는 TOULMIN 그래프의 관계를 쓰는 LINK Codec이다. 뜻: 공격 관계. 공격자의 판정이 대상의 판정을 공격 세기(0~1, 기본 1)만큼 점진적으로 깎는다.

| 항목 | 값 |
|---|---|
| 이름 | `ATTACKS` (규격 문서 BIND `ATTACKS`) |
| TAG ID | `0x108L` |
| 코덱 ID | `0x00001080` |
| 규격 문서 | `0x00000000/codecs/0x00001080/` (DECLARE 대상 `1080`) |
| 섹션 | 8 `1000` (Edge TOULMIN), 섹션 안 오프셋 C = 8 |
| Kind | Edge · 계열: TOULMIN, 묶음: 관계, 레이아웃: LINK |
| TAG WORD | `0001 0000 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 공격 관계. 공격자의 판정이 대상의 판정을 공격 세기(0~1, 기본 1)만큼 점진적으로 깎는다 |
| Hugo 쪽 | `edge/toulmin/link.md` |

## 레이아웃

레이아웃은 [LINK](_index.md#link)다(ID, src, dst, flags, 조건부 필드, SPAN).

| 항목 | 값 |
|---|---|
| TANGEUL | `don't X when Y` |
| src → dst | 규칙 → 규칙. 판정을 공격 세기만큼 점진적으로 깎는다 |

- dst는 노드의 REF다.
- F_FORCE(공격 세기)는 이 Codec만 쓴다. 아래 [공격 세기](#공격-세기).
- 공통 필드(ID, REF, SPAN)와 수치 규칙은 [TOULMIN](_index.md#공통-필드)을 따른다.

## 공격 세기

공격 세기(Force)는 ATTACKS 간선 하나가 대상을 얼마나 세게 공격하는지를 나타낸다. 범위는 0~1이고 F_FORCE가 없으면 1이다.

- 판정에서 공격자 판정값 v의 기여 `(v+1)/2`에 세기 F를 곱한다. 반박(COUNTER) 공격은 분모 항 `F·(v+1)/2`로, 예외(EXCEPT) 공격은 게이트 `Π(1 − F·(v+1)/2)`로 들어간다. F가 0이면 공격이 판정에 영향을 주지 않는다.
- 값은 [TOULMIN](_index.md#수치) 수치 규칙을 따른다. 인코더는 계수의 끝 0을 지운다(0.5는 `C=5, E=−1`, 1.0은 `C=1, E=0`). 디코더는 소수 4자리까지 받는다.
- 세기를 적지 않은 표면(`don't X when Y`, `` `Y` 면 `X` 는 무효다``)은 F_FORCE를 끈다.
- 세기를 적은 표면(`` `Y` 면 `X` 를 0.5의 세기로 공격한다``)은 F_FORCE를 켜고 그 값을 담는다. `1.0의 세기로`처럼 1을 적어도 F_FORCE를 켜고 1을 담는다. 그래서 원문 표면이 그대로 돌아온다.
- 공격 세기는 노드의 강도(Strict, Defeasible, Defeater)와 다른 축이다. 강도는 노드에, 공격 세기는 ATTACKS 간선에 붙는다.

### 공격 세기 예시

`` `Y` 면 `X` 를 0.5의 세기로 공격한다``. Edge Id 5, 공격자 Y는 Edge Id 3, 대상 X는 Edge Id 2, SPAN 폭 1 WORD.

```
108D                  TAG WORD: Edge, Codec 0x108L (ATTACKS), 전체 14 WORD
0051 0005             ID      LOCAL 5
0051 0003             src     LOCAL 3 (Y, 공격자)
0051 0002             dst     LOCAL 2 (X, 대상)
0010                  flags   F_FORCE
0683 FFFF FFFF 0005   F_FORCE SIGNED-DECIMAL, E=−1, C=5 (0.5)
0040 001A             SPAN    시작 바이트 0x40, 바이트 수 0x1A
```

세기를 적지 않은 같은 간선은 flags가 `0000`이고 F_FORCE 필드가 없다. TAG WORD는 `1089`(전체 10 WORD)이다.

## 코덱 문서

코덱 문서는 DECLARE(대상 `1080`)를 둔다. LINK 레이아웃의 조건부 필드와 SOURCE가 정하는 SPAN 폭은 FIELD로 선언할 수 없어, 필드 선언은 열린 문제다([TOULMIN](_index.md#열린-문제)).

## 관련 페이지

- [LINK](_index.md#link), [TOULMIN](_index.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001080/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000108000000000
BODY
#1 DECLARE 0x1080
#2 BIND #1 "ATTACKS"
```
