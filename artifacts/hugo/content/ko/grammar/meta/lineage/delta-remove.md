---
title: "DELTA-REMOVE"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DELTA-REMOVE는 diff에서 기준 스냅숏 BODY에서 뺄 LOCAL ID(Edge Id) 목록을 적는 계보 Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

diff([DELTA-BASE](/ko/grammar/meta/lineage/delta-base/))에서 기준 스냅숏의 BODY에서 뺄 레코드의 LOCAL ID(Edge Id)를 적는다("제X조 삭제").

## 레이아웃

```
TAG WORD          0001 1LLL L011 1011      Codec 0x3B
[Length 확장 TAG]
삭제할 LOCAL ID    LOCAL Reference 레코드 × 1 이상
```

- Codec: Meta `0x3B`, 계보 클래스(`011`)
- Payload: [LOCAL](/ko/grammar/reference/local/) Reference 레코드 하나 이상
- 개수: 많아야 하나

## 해석과 유효성

- `DELTA-BASE`가 있는 문서에만 둔다.
- 각 LOCAL ID는 기준 스냅숏 BODY에 있는 Edge Id여야 한다. 없으면 invalid다. 같은 ID를 두 번 두면 invalid다.
- 같은 diff의 BODY에 같은 Edge Id를 다시 두면 invalid다(삭제와 개정을 함께 할 수 없다).
- 삭제한 LOCAL ID는 이후 버전에서 다른 대상에 다시 배정하지 않는다([개정](/ko/grammar/document/#개정)).
- diff BODY에 레코드가 없다는 것은 "바뀌지 않음"이다. 그래서 삭제는 이 Meta로만 표현한다.
- HEAD Edge(문서 전체의 [SOURCE](/ko/grammar/edge/source/#문서-전체의-출처)와 그 QUALIFIER)는 적지 않는다. HEAD는 diff의 HEAD로 통째로 바뀐다([diff 저장](/ko/grammar/document/#diff-저장)).

## 예시

LOCAL `#7`과 `#12` 삭제:

```
1A3B 0088 0007 0088 000C
```

- TAG `1A3B`(Meta `0x3B`, `LLLL=0100`, 5 WORD), LOCAL Reference `0088 0007`, `0088 000C`.
