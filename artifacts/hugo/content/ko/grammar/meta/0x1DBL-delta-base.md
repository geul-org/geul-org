---
title: "DELTA-BASE (0x1DBL)"
weight: 475
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "이 버전 파일이 스냅숏이 아니라 같은 문서의 기준 버전에 대한 diff라는 표지다(git packfile의 delta)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `DELTA-BASE` (규격 문서 BIND `DELTA-BASE`) |
| TAG ID | `0x1DBL` |
| 코덱 ID | `0x00001DB0` |
| 규격 문서 | `0x00000000/codecs/0x00001DB0/` (DECLARE 대상 `1DB0`) |
| 섹션 | 14 `1110` (Meta), 섹션 안 오프셋 C = 27 |
| Kind | Meta · 클래스: 계보 |
| TAG WORD | `0001 1101 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 이 버전 파일은 같은 문서의 기준 버전(2 WORD 버전 ID)에 대한 diff다 (git packfile delta) |
| Hugo 쪽 | `meta/lineage/delta-base.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `version` | #2 | 날값 2 WORD | `0620` UNSIGNED-INTEGER |  |

이 버전 파일이 스냅숏이 아니라 같은 문서의 기준 버전에 대한 **diff**라는 표지다(git packfile의 delta). 버전 자체는 여전히 스냅숏으로 정의된다. 내용 해시, 버전 목록, 서명은 모두 diff를 적용해 복원한 스냅숏 기준이다([diff 저장](../document.md#diff-저장)).

## 레이아웃

```
TAG WORD          0001 1101 1011 LLLL      Codec 0x1DBL
버전 ID           2 WORD unsigned (같은 문서의 기준 버전)
```

- Codec: Meta `0x1DBL`, 계보 클래스
- Payload: 2 WORD 버전 ID(날값)
- 개수: 많아야 하나

## 해석과 유효성

- [DOC-ID](0x1C7L-doc-id.md)가 있는 문서에만 쓴다. `DOC-ID`를 두지 않는 버전 목록 `versions.geul`, 목록 문서(`issuers/`의 버전)와 이름 없는 문서는 diff를 두지 않는다.
- 기준 버전은 같은 `DOC-ID`의 공표된 버전이고 이 버전보다 앞선다. `0`(버전 없음)은 invalid다.
- 복원한 스냅숏의 내용 해시가 버전 목록([PUBLICATION](../edge/0x0B8L-publication.md))의 이 버전 해시와 같아야 한다. 다르면 이 diff는 invalid다. 그래서 diff 안에 결과 해시를 따로 적지 않는다.
- BODY의 모든 레코드가 Edge(Edge Id가 있는 레코드)인 문서만 diff로 둘 수 있다. diff 단위가 LOCAL ID(Edge Id)이기 때문이다.
- 스냅숏 복원 규칙은 [diff 저장](../document.md#diff-저장)을 따른다. 삭제는 [DELTA-REMOVE](0x1DCL-delta-remove.md)가 맡는다.
- 추가·개정 표지는 따로 두지 않는다. diff BODY의 Edge Id가 기준에 있으면 개정, 없으면 추가다. 추가는 버전 목록의 [NEXT-LOCAL-ID](0x1DDL-next-local-id.md)부터 번호를 받는다. 삭제한 LOCAL ID를 다시 쓰면 invalid다([개정](../document.md#개정)).

## 예시

기준 버전 3에 대한 diff:

```
1DB2 0000 0003
```

- TAG `1DB2`(Meta `0x1DBL`, `LLLL=0010`, 3 WORD), 버전 ID `0000 0003`.

## 열린 문제

1. 스냅숏 간격: 몇 버전마다 전체 스냅숏을 둘지(diff 사슬 길이와 복원 비용).
2. 기준 버전을 직전 버전으로 제한할지.
3. diff 파일의 저장 위치: 버전 파일 자리(`<버전 ID>.geul`)에 둘지, 내용 해시 주소 `<Issuer>/hashes/`와의 관계(`hashes/`는 스냅숏의 내용 해시로 찾는다).

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001DB0/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DB000000000
BODY
#1 DECLARE 0x1DB0
#2 FIELD #1 0x0002
#3 BIND #1 "DELTA-BASE"
#4 BIND #2 "version"
#5 CODEC #2 0x0620
```
