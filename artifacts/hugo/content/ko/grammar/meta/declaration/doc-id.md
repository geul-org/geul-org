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
TAG WORD          0001 1LLL L001 0010      Codec 0x12
[Length 확장 TAG]
문서              DOC-POINTER Reference 레코드. (Issuer, 문서 ID, 버전 0)
```

- Codec: Meta `0x12`, 정의 클래스(`001`)
- Payload: 내장 Reference [DOC-POINTER](/ko/grammar/reference/doc-pointer/)(Issuer, 문서 ID, 버전 0) 하나
- 개수: 많아야 하나. 이름이 `0x`로 시작하는 문서는 필수

## 해석과 유효성

- Payload는 `DOC-POINTER`(Issuer, 문서 ID, 버전 `0`) Reference 레코드 정확히 하나다. 버전 ID는 `0`만 쓴다. 버전은 문서가 아니라 버전 목록이 배정한다. Quantifier는 `000`이다.
- 그래서 "이 문서"를 가리키는 표기가 DOC-ID, `documents.geul`의 [BIND](/ko/grammar/edge/bind/) Subject, 다른 문서의 인용에서 모두 같다.
- 버전과 무관하게 같은 문서는 같은 `DOC-ID`다. 버전 ID와 내용 해시는 문서에 적지 않는다([버전](/ko/grammar/document/#버전)).
- 주소용 이름은 버전 목록의 서술 `BIND`가, 사람이 읽는 제목은 서술 [LABEL](/ko/grammar/edge/label/)이 맡는다.
- 없으면 이름 없는 문서이며 내용 해시로만 가리킬 수 있다. 다른 문서가 이 문서의 LOCAL을 지시 Reference로 가리키려면 필요하다.
- 문서를 가져오는 쪽은 받은 문서의 `DOC-ID`가 요청한 Issuer·문서 ID와 같은지 검증한다.
- 문서 ID `0x0000000000000000`은 Issuer의 용어 정의 색인 문서다([Issuer](/ko/grammar/issuer/)). 이 문서도 이름이 `0x`로 시작하므로 DOC-ID(`DOC-POINTER`(Issuer, `0`, `0`))를 둔다. Issuer 자신은 [ISSUER-POINTER](/ko/grammar/reference/issuer-pointer/)가 대표한다.
- `.well-known/geul/` 아래 이름이 `0x`로 시작하는 문서(버전 문서 `<버전 ID>.geul`, 규격 문서)는 `DOC-ID`가 필수다.
- 이름이 `0x`로 시작하지 않는 문서는 예외로 `DOC-ID`를 두지 않는다: 버전 목록 `versions.geul`([PUBLICATION](/ko/grammar/edge/publication/)), 문서 이름 색인 `documents.geul`, Issuer 이름 색인 `issuers.geul`([Issuer](/ko/grammar/issuer/)). 내용 해시 저장소 `h/`는 위 문서들의 사본이라 원본을 따른다.
- Codec 규격 문서는 GEUL Issuer `0x0000`의 문서다. 문서 ID는 Kind·Codec TAG WORD를 4 WORD로 늘린 값이다(`0x1018` → `0x0000000000001018`). Reference `0000`은 예약이라 문서 ID `0`이 되지 않는다([규격 문서](/ko/grammar/codec-spec/)).

## 예시

- Issuer `0x0001`, 문서 `0x…0005`: `1C12 03B8 0001 0000 0000 0000 0005 0000 0000` (Meta TAG 1 + Reference TAG 1 + Issuer 1 + 문서 ID 4 + 버전 2 = 9 WORD)
