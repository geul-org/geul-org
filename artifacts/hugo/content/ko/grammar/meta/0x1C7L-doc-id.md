---
title: "DOC-ID (0x1C7L)"
weight: 455
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "이 문서의 식별자를 선언한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `DOC-ID` (규격 문서 BIND `DOC-ID`) |
| TAG ID | `0x1C7L` |
| 코덱 ID | `0x00001C70` |
| 규격 문서 | `0x00000000/codecs/0x00001C70/` (DECLARE 대상 `1C70`) |
| 섹션 | 14 `1110` (Meta), 섹션 안 오프셋 C = 7 |
| Kind | Meta · 클래스: 정의 |
| TAG WORD | `0001 1100 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 이 문서의 식별자. 내장 Reference `DOC-POINTER`(Issuer, 문서 ID, 버전 0). 코덱 문서는 `CODEC-POINTER`(Issuer, 코덱 ID, 버전 0) |
| Hugo 쪽 | `meta/declaration/doc-id.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #2 | 레코드 | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |

이 문서의 식별자를 선언한다. 다른 문서가 이 문서와 그 안의 대상을 가리키려면 필요하다.

## 레이아웃

```
TAG WORD          0001 1100 0111 LLLL      Codec 0x1C7L
[Length 확장 TAG]
문서              DOC-POINTER Reference 레코드. (Issuer, 문서 ID, 버전 0). 코덱 문서는 CODEC-POINTER
```

- Codec: Meta `0x1C7L`, 정의 클래스
- Payload: 내장 Reference [DOC-POINTER](../reference/0x041L-doc-pointer.md)(Issuer, 문서 ID, 버전 0) 하나
- 개수: 많아야 하나. `docs/<문서 ID>/`·`codecs/<코덱 ID>/` 아래 버전 문서는 필수

## 해석과 유효성

- Payload는 `DOC-POINTER`(Issuer, 문서 ID, 버전 `0`) Reference 레코드 정확히 하나다. 버전 ID는 `0`만 쓴다. 버전은 문서가 아니라 버전 목록이 배정한다. 코덱 문서는 `CODEC-POINTER`(Issuer, 코덱 ID, 버전 `0`)를 쓴다([CODEC-POINTER](../reference/0x042L-codec-pointer.md)).
- 그래서 "이 문서"를 가리키는 표기가 DOC-ID, 버전 목록의 PUBLICATION 레코드, 다른 문서의 인용에서 모두 같다.
- 버전과 무관하게 같은 문서는 같은 `DOC-ID`다. 버전 ID와 내용 해시는 문서에 적지 않는다([버전](../document.md#버전)).
- 문서 이름 주소는 없다([공표 주소와 버전 목록](../publishing.md#문서-이름)). 사람이 읽는 제목은 서술 [LABEL](../edge/0x0A4L-label.md)이 맡는다.
- 없으면 이름 없는 문서이며 내용 해시로만 가리킬 수 있다. 다른 문서가 이 문서의 LOCAL을 지시 Reference로 가리키려면 필요하다.
- 문서를 가져오는 쪽은 받은 문서의 `DOC-ID`가 요청한 Issuer·문서 ID와 같은지 검증한다.
- 문서 ID `0x0000000000000000`은 Issuer의 용어 정의 색인 문서다([Issuer](../issuer.md)). 이 문서도 `docs/<문서 ID>/` 아래 버전 문서이므로 DOC-ID(`DOC-POINTER`(Issuer, `0`, `0`))를 둔다. Issuer 자신은 [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md)가 대표한다.
- `.well-known/geul/` 아래 `<Issuer>/docs/<문서 ID>/`와 `<Issuer>/codecs/<코덱 ID>/`의 버전 문서 `<버전 ID>.geul`(규격 문서 포함)은 `DOC-ID`가 필수다.
- 목록 문서는 예외로 `DOC-ID`를 두지 않는다: 버전 목록 `versions.geul`([PUBLICATION](../edge/0x0B8L-publication.md))과 Issuer 목록 `issuers/`의 버전 `<버전 ID>.geul`([공표 주소와 버전 목록](../publishing.md#목록-문서)). 무엇의 목록인지는 레코드의 DOC-POINTER가 말한다. 목록 문서의 버전은 그 `versions.geul`의 PUBLICATION이 DOC-POINTER(`0x00000000`, 예약 문서 ID, 버전 ID)로 가리킨다. 내용 해시 주소 `<Issuer>/hashes/`는 위 문서들의 사본이라 원본을 따른다.
- 문서 ID `0xFFFFFFFFFFFFFFFF`는 모든 Issuer에서 예약했고(`0x0000000000000000`도 같다), Issuer `0x00000000`의 Issuer 목록에 쓴다. 다른 Issuer는 쓰지 않는다. 목록 문서는 `DOC-ID`가 없으므로 이 값은 `issuers/versions.geul` 레코드의 DOC-POINTER에만 나온다.
- Codec 규격 문서는 GEUL Issuer `0x00000000`의 코덱 문서다. 문서 ID가 없고, `DOC-ID`로 CODEC-POINTER(`0x00000000`, 코덱 ID, `0`)를 둔다. 코덱 ID는 Kind·Codec TAG WORD를 32비트로 쓴 값이다(`0x0B80` → `0x00000B80`)([규격 문서](../codec-spec.md)).

## 예시

- Issuer `0x00000002`, 문서 `0x…0005`: `1C79 0418 0000 0002 0000 0000 0000 0005 0000 0000` (Meta TAG 1 + Reference TAG 1 + Issuer 2 + 문서 ID 4 + 버전 2 = 10 WORD)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001C70/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C7000000000
BODY
#1 DECLARE 0x1C70
#2 FIELD #1 record
#5 CODEC #2 0x0410
#3 BIND #1 "DOC-ID"
#4 BIND #2 "doc"
#6 CODEC #2 0x0420
```
