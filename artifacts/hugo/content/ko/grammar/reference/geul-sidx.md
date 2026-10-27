---
title: "GEUL-SIDX"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL-SIDX는 비트 자체에 의미를 담은 GEUL SIDX(Semantic-aligned Index)로 대상을 가리키는 선언 Reference다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL-SIDX는 GEUL SIDX(Semantic-aligned Index)로 대상을 가리키는 선언 Reference다. SIDX는 비트 자체에 의미(종류, 속성)를 담은 식별자다.

## 레이아웃

```
TAG WORD          0000 0LLL L001 1QQQ      CCCC = 0011
[Length 확장 TAG]
SIDX              나머지 전부
```

- Quantifier는 다른 선언 Codec과 같다. Variable이면 그 종류의 익명 변수다([Reference](/ko/grammar/reference/) Variable). 양화는 `QQQ`로만 한다. SIDX 값에는 양화를 넣지 않는다.
- 규격 문서는 SIDX를 나머지 폭 날값 필드 하나로 선언한다. 폭 규칙이 정해지면 바꾼다.

## 예시

| SIDX | WORD sequence |
|---|---|
| (비규범) 64비트 `0x1234 5678 9abc def0`, Identified | `0218 1234 5678 9abc def0` |

## 배정 방침

- [GEUL](/ko/grammar/reference/geul/)과 역할이 다르다. GEUL은 대체로 순서대로(auto increment) 배정하는 정체성 ID이고, GEUL-SIDX는 의미가 가까운 대상에 가까운 값을 주는 의미 주소다.
- 가까운 정도는 사용 데이터를 쌓아 통계로 정한다. 통계가 모이기 전에는 GEUL ID를 쓰고, SIDX를 배정한 뒤 같은 대상의 GEUL과 GEUL-SIDX를 [SAME-NODE](/ko/grammar/edge/same-node/)로 잇는다.

## 열린 문제

- **폭.** 통계를 보고 정한다. 4 WORD(64비트)와 16 WORD 등을 검토하고 있다. SIDX는 상위 비트에 의미가 있어 다른 선언 Codec의 "가장 짧은 폭" 규칙(선행 `0x0000` 금지)을 그대로 쓸 수 없다. 그래서 고정 폭(또는 하위 형식별 고정 폭)이 될 것이다. 정해질 때까지 규격 문서는 SIDX를 나머지 폭 날값으로 선언한다.
- **배정의 안정성.** Reference는 정수값이 같으면 같은 대상이고, 배정한 ID를 재사용하지 않는다. 통계가 바뀌어도 이미 배정한 SIDX를 옮기지 않으려면 append-only 배정(의미가 가까운 자리를 남겨 두는 희소 배정)이 필요하다. 옮길 일이 잦으면 SIDX를 영구 식별자가 아니라 레지스트리 판본에 묶인 색인으로 정의할지 정한다.
- **유일성.** SIDX가 비트 의미로 생성되어 충돌할 수 있으면 "정수값이 같으면 같은 대상" 전제와 맞지 않는다. 배정할 때 충돌을 해소해 유일성을 보장한다.
- 코드북과 레지스트리 공개 형식.

## 관련 페이지

- [Reference](/ko/grammar/reference/), [GEUL](/ko/grammar/reference/geul/)
