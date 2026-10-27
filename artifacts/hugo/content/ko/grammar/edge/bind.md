---
title: "BIND"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "BIND는 Subject에 기계가 맞추는 이름(언어 없는 UTF8-TEXT)을 묶는 서술 Edge다(Codec 0x03)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIND는 Subject에 기계가 맞추는 이름을 묶는 서술 Edge다. Codec `0x03`.

명명이다. 사람이 읽는 이름(언어별 제목)은 [LABEL](/ko/grammar/edge/label/)이 맡는다. 프로그램 기호의 이름과 문서의 주소용 이름을 같은 레코드로 쓴다.

## 레이아웃

```
TAG WORD          0001 0LLL L000 0011
[Length 확장 TAG]
Edge Id           LOCAL Reference 레코드
Subject           Reference 레코드 1개, 또는 코덱 TAG WORD 1 WORD
이름              UTF8-TEXT-* Value 1개
```

## 해석과 유효성

- Subject는 정확히 하나의 완전한 [Reference](/ko/grammar/reference/) 레코드다. LOCAL이면 이 문서의 대상(기호 등), 지시 Reference면 다른 문서의 대상이다. 문서 자신은 [DOC-POINTER](/ko/grammar/reference/doc-pointer/), Issuer 자신은 [ISSUER-POINTER](/ko/grammar/reference/issuer-pointer/)다.
- 또는 Subject는 코덱 TAG WORD 하나(Kind·Codec만, `LLLL = 0`, Payload 없음)다. 이것은 Payload가 빈 레코드가 아니라 그 직접 코드 자체, 곧 그 규격 문서(GEUL Issuer 문서 `0x000000000000<TAG>`)를 가리킨다([Codec 규격 문서](/ko/grammar/codec-spec/), [DECLARE](/ko/grammar/edge/declare/)). 예: `1018`은 PUBLICATION. 이름 색인에서는 DOC-POINTER Subject를 쓴다. Issuer 형식 코덱은 쓰지 않는다.
- 그 밖의 레코드(Value 등)는 Subject가 될 수 없다. BIND 규격 문서의 FIELD는 Subject를 폭 `0`(레코드)으로만 선언하므로, 이 제약은 BIND 본문 규칙이다.
- 이름은 정확히 하나의 [UTF8-TEXT](/ko/grammar/value/text/utf8-text/) Value다. 언어가 없고 정규화하지 않는다. 바이트가 같아야 같은 이름이다.
- 이름의 범위는 BIND를 담은 문서다. 한 문서에서 같은 이름을 서로 다른 Subject에 묶지 않는다.
- 한 Subject에 이름을 여럿 묶을 수 있다(별칭, 옛 이름). 문서가 따로 정하지 않으면 마지막 BIND가 대표 이름이다.
- 다른 레코드는 이름이 아니라 LOCAL ID로 대상을 가리킨다. 이름은 바깥(호스트 함수, 주소 입력, 사람)과 맞추는 데 쓴다.
- 이름에 쓸 수 있는 문자는 쓰임새가 정한다. 문서 주소용 이름은 geul.org 문서 이름 규칙(소문자 ASCII 슬러그)을 따른다([Issuer와 공표](/ko/grammar/issuer/)).

## 길이

```
전체 = 1 + N_len + N_id + N_subject + N_name WORD
```

## 예시 (비규범)

프로그램 기호: Edge Id `0003`, Subject LOCAL 7, 이름 `main`.

- 이름 `main`은 4 byte(짝수)라 `0940 6d61 696e` 3 WORD다.
- Edge는 TAG 1 + Edge Id 2 + Subject 2 + 이름 3 = 8 WORD, TAG `1383`이다.

```
1383 0088 0003 0088 0007 0940 6d61 696e
```

문서 이름(그 문서의 버전 목록 문서 `0x0000/0xffff000000000002/versions.geul` 안): Edge Id `0005`, Subject `DOC-POINTER`(Issuer `0x0000`, 문서 `0xffff000000000002`, 버전 `0` = 문서 자신), 이름 `this-is-sample-doc`.

- Subject는 TAG `03B8` + Issuer 1 + 문서 ID 4 + 버전 ID 2 = 8 WORD다.
- 이름은 18 byte(짝수)라 TAG `0CC0` + 9 WORD = 10 WORD다.
- Edge는 TAG 1 + Length 확장 1 + Edge Id 2 + Subject 8 + 이름 10 = 22 WORD라 `LLLL=1110`, TAG `1703`, 확장 `0016`이다.

```
1703 0016 0088 0005 03B8 0000 ffff 0000 0000 0002 0000 0000 0CC0 7468 6973 2d69 732d 7361 6d70 6c65 2d64 6f63
```

## 관련 페이지

- [Edge](/ko/grammar/edge/), [LABEL](/ko/grammar/edge/label/), [PUBLICATION](/ko/grammar/edge/publication/) (버전 목록 문서의 문서 이름)
- [LOCAL](/ko/grammar/reference/local/), [DOC-POINTER](/ko/grammar/reference/doc-pointer/), [ISSUER-POINTER](/ko/grammar/reference/issuer-pointer/)
