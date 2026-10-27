---
title: "DELTA-BASE"
weight: 59
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DELTA-BASE는 이 버전 파일이 같은 문서의 기준 버전에 대한 diff임을 표시하는 계보 Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

이 버전 파일이 스냅숏이 아니라 같은 문서의 기준 버전에 대한 **diff**라는 표지다(git packfile의 delta). 버전 자체는 여전히 스냅숏으로 정의된다. 내용 해시, 버전 목록, 서명은 모두 diff를 적용해 복원한 스냅숏 기준이다([diff 저장](/ko/grammar/document/#diff-저장)).

## 레이아웃

```
TAG WORD          0001 1LLL L011 1010      Codec 0x3A
버전 ID           2 WORD unsigned (같은 문서의 기준 버전)
```

- Codec: Meta `0x3A`, 계보 클래스(`011`)
- Payload: 2 WORD 버전 ID(날값)
- 개수: 많아야 하나

## 해석과 유효성

- [DOC-ID](/ko/grammar/meta/declaration/doc-id/)가 있는 문서(버전 목록으로 버전을 관리하는 문서)에만 쓴다. 버전 관리를 하지 않는 `versions.geul`·`documents.geul`·`issuers.geul`과 이름 없는 문서는 diff를 두지 않는다.
- 기준 버전은 같은 `DOC-ID`의 공표된 버전이고 이 버전보다 앞선다. `0`(버전 없음)은 invalid다.
- 복원한 스냅숏의 내용 해시가 버전 목록([PUBLICATION](/ko/grammar/edge/publication/))의 이 버전 해시와 같아야 한다. 다르면 이 diff는 invalid다. 그래서 diff 안에 결과 해시를 따로 적지 않는다.
- BODY의 모든 레코드가 Edge(Edge Id가 있는 레코드)인 문서만 diff로 둘 수 있다. diff 단위가 LOCAL ID(Edge Id)이기 때문이다.
- 스냅숏 복원 규칙은 [diff 저장](/ko/grammar/document/#diff-저장)을 따른다. 삭제는 [DELTA-REMOVE](/ko/grammar/meta/lineage/delta-remove/)가 맡는다.
- 추가·개정 표지는 따로 두지 않는다. diff BODY의 Edge Id가 기준에 있으면 개정, 없으면 추가다. 추가는 버전 목록의 [NEXT-LOCAL-ID](/ko/grammar/meta/lineage/next-local-id/)부터 번호를 받는다. 삭제한 LOCAL ID를 다시 쓰면 invalid다([개정](/ko/grammar/document/#개정)).

## 예시

기준 버전 3에 대한 diff:

```
193A 0000 0003
```

- TAG `193A`(Meta `0x3A`, `LLLL=0010`, 3 WORD), 버전 ID `0000 0003`.

## 열린 문제

1. 스냅숏 간격: 몇 버전마다 전체 스냅숏을 둘지(diff 사슬 길이와 복원 비용).
2. 기준 버전을 직전 버전으로 제한할지.
3. diff 파일의 저장 위치: 버전 파일 자리(`<버전 ID>.geul`)에 둘지, 내용 주소 저장소 `h/`와의 관계(`h/`는 스냅숏의 내용 해시로 찾는다).
