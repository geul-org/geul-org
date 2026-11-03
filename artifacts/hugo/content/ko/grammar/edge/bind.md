---
title: "BIND"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "BIND는 Subject에 기계가 맞추는 이름(언어 없는 UTF8-TEXT)을 묶는 서술 Edge다(Codec 0x0A3L)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIND는 Subject에 기계가 맞추는 이름을 묶는 서술 Edge다. Codec `0x0A3L`.

명명이다. 사람이 읽는 이름(언어별 제목)은 [LABEL](/ko/grammar/edge/label/)이 맡는다. 프로그램 기호의 이름과 Issuer 목록의 도메인 이름을 같은 레코드로 쓴다.

## 레이아웃

```
TAG WORD          0000 1010 0011 LLLL
[Length 확장 TAG]
Edge Id           LOCAL Reference 레코드
Subject           Reference 레코드 1개, 또는 코덱 TAG WORD 1 WORD
이름              UTF8-TEXT-* Value 1개
```

## 해석과 유효성

- Subject는 정확히 하나의 완전한 [Reference](/ko/grammar/reference/) 레코드다. LOCAL이면 이 문서의 대상(기호 등), 지시 Reference면 다른 문서의 대상이다. 문서 자신은 [DOC-POINTER](/ko/grammar/reference/doc-pointer/), Issuer 자신은 [ISSUER-POINTER](/ko/grammar/reference/issuer-pointer/)다.
- 또는 Subject는 코덱 TAG WORD 하나(Kind·Codec만, `LLLL = 0`, Payload 없음)다. 이것은 Payload가 빈 레코드가 아니라 그 직접 코드 자체, 곧 그 규격 문서(GEUL Issuer 코덱 `0x0000<TAG>`)를 가리킨다([Codec 규격 문서](/ko/grammar/codec-spec/), [DECLARE](/ko/grammar/edge/declare/)). 예: `0B80`은 PUBLICATION. Issuer 형식 코덱은 이 형태로 가리키지 않는다.
- 그 밖의 레코드(Value 등)는 Subject가 될 수 없다. BIND 규격 문서의 FIELD는 Subject를 폭 `0`(레코드)으로만 선언하므로, 이 제약은 BIND 본문 규칙이다.
- 이름은 정확히 하나의 [UTF8-TEXT](/ko/grammar/value/text/utf8-text/) Value다. 언어가 없고 정규화하지 않는다. 바이트가 같아야 같은 이름이다.
- 이름의 범위는 BIND를 담은 문서다. 한 문서에서 같은 이름을 서로 다른 Subject에 묶지 않는다.
- 한 Subject에 이름을 여럿 묶을 수 있다(별칭, 옛 이름). 문서가 따로 정하지 않으면 마지막 BIND가 대표 이름이다.
- 다른 레코드는 이름이 아니라 LOCAL ID로 대상을 가리킨다. 이름은 바깥(호스트 함수, 주소 입력, 사람)과 맞추는 데 쓴다.
- 이름에 쓸 수 있는 문자는 쓰임새가 정한다. Issuer 목록의 도메인 이름은 도메인 규칙(소문자, IDNA)을 따른다([공표 주소와 버전 목록](/ko/grammar/publishing/#issuer-목록)).
- 버전 목록에는 BIND를 두지 않는다. 문서 이름 주소는 없다([공표 주소와 버전 목록](/ko/grammar/publishing/#문서-이름)).

## 길이

```
전체 = 1 + N_len + N_id + N_subject + N_name WORD
```

## 예시 (비규범)

프로그램 기호: Edge Id `0003`, Subject LOCAL 7, 이름 `main`.

- 이름 `main`은 4 byte(짝수)라 `0722 6d61 696e` 3 WORD다.
- Edge는 TAG 1 + Edge Id 2 + Subject 2 + 이름 3 = 8 WORD, TAG `0A37`이다.

```
0a37 0051 0003 0051 0007 0722 6d61 696e
```

## 관련 페이지

- [Edge](/ko/grammar/edge/), [LABEL](/ko/grammar/edge/label/), [공표 주소와 버전 목록](/ko/grammar/publishing/#issuer-목록) (Issuer 목록의 도메인 이름)
- [LOCAL](/ko/grammar/reference/local/), [DOC-POINTER](/ko/grammar/reference/doc-pointer/), [ISSUER-POINTER](/ko/grammar/reference/issuer-pointer/)
