---
title: "NEXT-LOCAL-ID"
weight: 61
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "NEXT-LOCAL-ID는 문서의 다음 버전이 새 서술에 배정할 LOCAL ID를 버전 목록에 적는 계보 Meta다(auto increment)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

그 문서의 다음 버전이 새 서술에 배정할 LOCAL ID를 적는다(DBMS의 auto increment, MySQL `AUTO_INCREMENT`). 문서의 어떤 버전에서든 배정한 LOCAL ID는 모두 이 값보다 작다.

## 레이아웃

```
TAG WORD          0001 1LLL L011 1100      Codec 0x3C
Payload           다음에 배정할 LOCAL ID, 가장 짧은 폭의 unsigned 정수
```

- Codec: Meta `0x3C`, 계보 클래스(`011`)
- Payload: 날값(가장 짧은 폭의 unsigned 정수)
- 개수: 많아야 하나
- 놓는 곳: 버전 목록 문서 `versions.geul`의 HEAD([PUBLICATION](/ko/grammar/edge/publication/))

## 해석과 유효성

- LOCAL ID(Edge Id 포함)는 버전을 넘는 정체성이다([개정](/ko/grammar/document/#개정)). 새 서술은 이 값을 받고 값은 1 늘어난다. 삭제한 LOCAL ID는 다시 쓰지 않는다. 그래서 최댓값을 가진 서술이 삭제되어도 이 값은 줄지 않는다.
- LOCAL ID `0`은 배정하지 않으므로 처음 값은 `1`이다. 아직 버전이 없으면 이 Meta를 두지 않고, 다음 번호는 `1`이다.
- 공표처가 버전을 공표할 때 새 목록 문서에 갱신해 적는다. 공표한 버전에 쓰인 어떤 LOCAL ID보다 커야 한다. 작거나 같으면 invalid다.
- 값은 늘기만 한다. 직전 목록 문서([PARENT](/ko/grammar/meta/lineage/parent/))의 값보다 작으면 invalid다.
- 버전 관리를 하지 않는 문서(`versions.geul`이 없는 문서, 이름 없는 문서)에는 없다. 그런 문서는 diff([DELTA-BASE](/ko/grammar/meta/lineage/delta-base/))도 두지 않는다.
- 문서 본문(버전 문서)에는 두지 않는다. 번호 기억은 문서 내용이 아니라 문서를 이어 쓰는 공표처의 상태다(git의 커밋이 아니라 refs 쪽).

## 예시

다음 배정 번호 524:

```
18BC 020C
```

- TAG `18BC`(Meta `0x3C`, `LLLL=0001`, 2 WORD), Payload `020C`.
