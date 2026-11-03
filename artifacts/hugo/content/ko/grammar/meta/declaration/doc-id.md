---
title: "DOC-ID"
weight: 19
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "DOC-ID는 문서 자신을 가리키는 DOC-POINTER(Issuer, 문서 ID, 버전 0)로 문서의 식별자를 선언하는 정의 Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

이 문서의 식별자를 선언한다. 다른 문서가 이 문서와 그 안의 대상을 가리키려면 필요하다.

## 레이아웃

```
TAG WORD          0001 1100 0111 LLLL      Codec 0x1C7L
[Length 확장 TAG]
문서              DOC-POINTER Reference 레코드. (Issuer, 문서 ID, 버전 0). 코덱 문서는 CODEC-POINTER
```

- Codec: Meta `0x1C7L`, 정의 클래스
- Payload: 내장 Reference [DOC-POINTER](/ko/grammar/reference/doc-pointer/)(Issuer, 문서 ID, 버전 0) 하나
- 개수: 많아야 하나. `docs/<문서 ID>/`·`codecs/<코덱 ID>/` 아래 버전 문서는 필수

## 해석과 유효성

- Payload는 `DOC-POINTER`(Issuer, 문서 ID, 버전 `0`) Reference 레코드 정확히 하나다. 버전 ID는 `0`만 쓴다. 버전은 문서가 아니라 버전 목록이 배정한다. 코덱 문서는 `CODEC-POINTER`(Issuer, 코덱 ID, 버전 `0`)를 쓴다([CODEC-POINTER](/ko/grammar/reference/codec-pointer/)).
- 그래서 "이 문서"를 가리키는 표기가 DOC-ID, 버전 목록의 PUBLICATION 레코드, 다른 문서의 인용에서 모두 같다.
- 버전과 무관하게 같은 문서는 같은 `DOC-ID`다. 버전 ID와 내용 해시는 문서에 적지 않는다([버전](/ko/grammar/document/#버전)).
- 문서 이름 주소는 없다([공표 주소와 버전 목록](/ko/grammar/publishing/#문서-이름)). 사람이 읽는 제목은 서술 [LABEL](/ko/grammar/edge/label/)이 맡는다.
- 없으면 이름 없는 문서이며 내용 해시로만 가리킬 수 있다. 다른 문서가 이 문서의 LOCAL을 지시 Reference로 가리키려면 필요하다.
- 문서를 가져오는 쪽은 받은 문서의 `DOC-ID`가 요청한 Issuer·문서 ID와 같은지 검증한다.
- 문서 ID `0x0000000000000000`은 Issuer의 용어 정의 색인 문서다([Issuer](/ko/grammar/issuer/)). 이 문서도 `docs/<문서 ID>/` 아래 버전 문서이므로 DOC-ID(`DOC-POINTER`(Issuer, `0`, `0`))를 둔다. Issuer 자신은 [ISSUER-POINTER](/ko/grammar/reference/issuer-pointer/)가 대표한다.
- `.well-known/geul/` 아래 `<Issuer>/docs/<문서 ID>/`와 `<Issuer>/codecs/<코덱 ID>/`의 버전 문서 `<버전 ID>.geul`(규격 문서 포함)은 `DOC-ID`가 필수다.
- 목록 문서는 예외로 `DOC-ID`를 두지 않는다: 버전 목록 `versions.geul`([PUBLICATION](/ko/grammar/edge/publication/))과 Issuer 목록 `issuers/`의 버전 `<버전 ID>.geul`([공표 주소와 버전 목록](/ko/grammar/publishing/#목록-문서)). 무엇의 목록인지는 레코드의 DOC-POINTER가 말한다. 목록 문서의 버전은 그 `versions.geul`의 PUBLICATION이 DOC-POINTER(`0x00000000`, 예약 문서 ID, 버전 ID)로 가리킨다. 내용 해시 주소 `<Issuer>/hashes/`는 위 문서들의 사본이라 원본을 따른다.
- 문서 ID `0xFFFFFFFFFFFFFFFF`는 Issuer 목록에 예약했다. 목록 문서는 `DOC-ID`가 없으므로 이 값은 `issuers/versions.geul` 레코드의 DOC-POINTER에만 나온다.
- Codec 규격 문서는 GEUL Issuer `0x00000000`의 코덱 문서다. 문서 ID가 없고, `DOC-ID`로 CODEC-POINTER(`0x00000000`, 코덱 ID, `0`)를 둔다. 코덱 ID는 Kind·Codec TAG WORD를 32비트로 쓴 값이다(`0x0980` → `0x00000980`)([규격 문서](/ko/grammar/codec-spec/)).

## 예시

- Issuer `0x00000002`, 문서 `0x…0005`: `1C79 0048 0000 0002 0000 0000 0000 0005 0000 0000` (Meta TAG 1 + Reference TAG 1 + Issuer 2 + 문서 ID 4 + 버전 2 = 10 WORD)
