---
title: "DOC-POINTER (0x041L)"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "DOC-POINTER는 Issuer가 공표한 문서의 한 버전을 가리키는 지시선언 Reference다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `DOC-POINTER` (규격 문서 BIND `DOC-POINTER`) |
| TAG ID | `0x041L` |
| 코덱 ID | `0x00000410` |
| 규격 문서 | `0x00000000/codecs/0x00000410/` (DECLARE 대상 `0410`) |
| 섹션 | 2 `0010` (Reference 기타), 섹션 안 오프셋 C = 1 |
| Kind | Reference · 분류: 지시선언 |
| TAG WORD | `0000 0100 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Hugo 쪽 | `reference/doc-pointer.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | 나머지 날값(`0xFFFF`) |  |  |
| 2 | `doc` | #3 | 날값 4 WORD |  |  |
| 3 | `version` | #4 | 날값 2 WORD |  |  |

DOC-POINTER는 Issuer가 공표한 문서의 한 버전을 가리키는 지시선언 Reference다. 문서 공표·deprecate·삭제, 인용 판본, 문서에 대한 서술의 대상이 된다.

## 레이아웃

```
TAG WORD          0000 0100 0001 LLLL      Codec 0x041L
[Length 확장 TAG]
Issuer            2/4/16 WORD
문서 ID           4 WORD
버전 ID           2 WORD
```

## 해석과 유효성

- Issuer 폭은 Payload에서 문서 ID와 버전 ID 6 WORD를 뺀 나머지다. Codec이 폭을 나누지 않는다. 폭이 2, 4, 16 WORD가 아니거나, Issuer 값이 더 좁은 폭에 들어가면 invalid다(Issuer 정규형).
- 버전 ID는 생략하지 않는다. 생략을 허용하면 Payload 길이만으로 Issuer 폭을 정할 수 없다(Issuer 4 WORD·버전 없음과 Issuer 2 WORD·버전 있음이 같은 8 WORD).
- 버전 ID `0`은 최신 버전이다. 해석하는 시점의 현행 버전에 묶인다. 그 밖의 값은 그 버전에 고정된다([PUBLICATION](../edge/0x0B8L-publication.md)).
- 문서 ID `0`은 Issuer의 용어 정의 색인 문서다. Issuer 자신은 [ISSUER-POINTER](0x040L-issuer-pointer.md)로 가리킨다.
- 모든 Issuer는 문서 ID `0x0000000000000000`과 `0xFFFFFFFFFFFFFFFF`를 예약한다([Issuer와 공표](../issuer.md#용어-정의-문서)). `0xFFFFFFFFFFFFFFFF`는 Issuer `0x00000000`의 Issuer 목록 `issuers/`에 쓰고, 다른 Issuer는 쓰지 않는다. `issuers/versions.geul`의 PUBLICATION·DEPRECATION·TOMBSTONE이 이 값으로 목록 버전을 가리킨다([공표 주소와 버전 목록](../publishing.md#목록-문서)).
- Codec `0x041L` 한 칸이다. 양화가 없다(Identified).
- Issuer의 문서를 가리키는 형식은 DOC-POINTER 하나다. `EXTERNAL-ISSUER-*`(Issuer, 문서 ID, 대상 ID `0`)나 `EXTERNAL-POINTER-*`(IMPORT ID, 대상 ID `0`)로 문서를 가리키는 것은 invalid다.
- 쓰는 곳: Meta [DOC-ID](../meta/0x1C7L-doc-id.md)·[IMPORT-DOC](../meta/0x1E4L-import-doc.md), 버전 목록의 PUBLICATION·DEPRECATION·TOMBSTONE.
- 코덱 문서는 문서 ID가 없다. 코덱 문서와 그 버전은 [CODEC-POINTER](0x042L-codec-pointer.md)로 가리킨다.

## 예시

GEUL Issuer `0x00000000`의 문서 `0xFFFF000000000001`.

| 버전 | WORD sequence |
|---|---|
| 1 | `0418 0000 0000 FFFF 0000 0000 0001 0000 0001` |
| 최신 (`0`) | `0418 0000 0000 FFFF 0000 0000 0001 0000 0000` |

- TAG 1 + Issuer 2 + 문서 ID 4 + 버전 ID 2 = 9 WORD, `LLLL=1000`이다. TAG는 `0000 0100 0001 1000` = `0418`이다.

## 관련 페이지

- [Reference](_index.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [PUBLICATION](../edge/0x0B8L-publication.md)
- [Issuer와 공표](../issuer.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000410/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000041000000000
BODY
#1 DECLARE 0x0410
#2 FIELD #1 rest
#3 FIELD #1 0x0004
#4 FIELD #1 0x0002
#5 BIND #1 "DOC-POINTER"
#6 BIND #2 "issuer"
#7 BIND #3 "doc"
#8 BIND #4 "version"
```
