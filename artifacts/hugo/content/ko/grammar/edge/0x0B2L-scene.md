---
title: "SCENE (0x0B2L)"
weight: 178
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "SCENE은 장면 구조를 쓰는 서술 Edge다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SCENE은 장면 구조를 쓰는 서술 Edge다. 뜻: 시나리오 특성의 서술을 위한 장면 구조.

| 항목 | 값 |
|---|---|
| 이름 | `SCENE` (규격 문서 BIND `SCENE`) |
| TAG ID | `0x0B2L` |
| 코덱 ID | `0x00000B20` |
| 규격 문서 | `0x00000000/codecs/0x00000B20/` (DECLARE 대상 `0B20`) |
| 섹션 | 5 `0101` (Edge 서술), 섹션 안 오프셋 C = 18 |
| Kind | Edge · 계열: 서술, 묶음: 구조 |
| TAG WORD | `0000 1011 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 시나리오 특성의 서술을 위한 장면 구조 |
| Hugo 쪽 | `edge/_index.md` |

## 레이아웃

```
TAG WORD          0000 1011 0010 LLLL      Codec 0x0B2L
[Length 확장 TAG]
Codec별 TAG       1 WORD. 하위 형식
Edge Id           LOCAL Reference 레코드
구성요소          하위 형식이 정한다
```

- 하위 형식이 있는 Codec이다. Codec별 TAG 1 WORD가 하위 형식을 지정한다([레코드와 TAG WORD](../record.md#레코드-레이아웃)).
- 하위 형식과 구성요소는 아직 정하지 않았다.

## 코덱 문서

레이아웃을 아직 정하지 않았다. 코덱 문서는 DECLARE(대상 `0B20`)만 둔다. FIELD는 레이아웃이 정해지면 둔다.

## 관련 페이지

- [WORLD](0x0B0L-world.md), [TIMELINE](0x0B1L-timeline.md), [Edge](_index.md)
- [DECLARE](0x0BBL-declare.md#열린-문제)(하위 형식을 가진 Codec의 선언 방법)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000B20/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000B2000000000
BODY
#1 DECLARE 0x0B20
#2 BIND #1 "SCENE"
```
