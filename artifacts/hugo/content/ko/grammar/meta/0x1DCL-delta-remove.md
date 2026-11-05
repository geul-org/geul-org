---
title: "DELTA-REMOVE (0x1DCL)"
weight: 476
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "diff(DELTA-BASE)에서 기준 스냅숏의 BODY에서 뺄 레코드의 LOCAL ID(Edge Id)를 적는다(\"제X조 삭제\")."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `DELTA-REMOVE` (규격 문서 BIND `DELTA-REMOVE`) |
| TAG ID | `0x1DCL` |
| 코덱 ID | `0x00001DC0` |
| 규격 문서 | `0x00000000/codecs/0x00001DC0/` (DECLARE 대상 `1DC0`) |
| 섹션 | 14 `1110` (Meta), 섹션 안 오프셋 C = 28 |
| Kind | Meta · 클래스: 계보 |
| TAG WORD | `0001 1101 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | diff에서 기준 BODY에서 뺄 LOCAL ID(Edge Id) 목록 |
| Hugo 쪽 | `meta/lineage/delta-remove.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `ids` | #2 | 나머지 날값(`0xFFFF`) |  |  |

diff([DELTA-BASE](0x1DBL-delta-base.md))에서 기준 스냅숏의 BODY에서 뺄 레코드의 LOCAL ID(Edge Id)를 적는다("제X조 삭제").

## 레이아웃

```
TAG WORD          0001 1101 1100 LLLL      Codec 0x1DCL
[Length 확장 TAG]
삭제할 LOCAL ID    LOCAL Reference 레코드 × 1 이상
```

- Codec: Meta `0x1DCL`, 계보 클래스
- Payload: [LOCAL](../reference/0x005L-local.md) Reference 레코드 하나 이상
- 개수: 많아야 하나

## 해석과 유효성

- `DELTA-BASE`가 있는 문서에만 둔다.
- 각 LOCAL ID는 기준 스냅숏 BODY에 있는 Edge Id여야 한다. 없으면 invalid다. 같은 ID를 두 번 두면 invalid다.
- 같은 diff의 BODY에 같은 Edge Id를 다시 두면 invalid다(삭제와 개정을 함께 할 수 없다).
- 삭제한 LOCAL ID는 이후 버전에서 다른 대상에 다시 배정하지 않는다([개정](../document.md#개정)).
- diff BODY에 레코드가 없다는 것은 "바뀌지 않음"이다. 그래서 삭제는 이 Meta로만 표현한다.
- HEAD Edge(문서 전체의 [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처)와 그 QUALIFIER)는 적지 않는다. HEAD는 diff의 HEAD로 통째로 바뀐다([diff 저장](../document.md#diff-저장)).

## 예시

LOCAL `#7`과 `#12` 삭제:

```
1DC4 0051 0007 0051 000C
```

- TAG `1DC4`(Meta `0x1DCL`, `LLLL=0100`, 5 WORD), LOCAL Reference `0051 0007`, `0051 000C`.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001DC0/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DC000000000
BODY
#1 DECLARE 0x1DC0
#2 FIELD #1 rest
#3 BIND #1 "DELTA-REMOVE"
#4 BIND #2 "ids"
```
