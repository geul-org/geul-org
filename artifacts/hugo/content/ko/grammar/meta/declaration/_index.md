---
title: "Meta — 정의"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Meta 정의 클래스(상위 3비트 `001`, `0x10`~`0x1F`)는 해석 선언이다. 명세 판, 프로파일, 문서 ID, 시행 기간, 기본 언어를 정한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta 정의 클래스(상위 3비트 `001`, Codec `0x10`~`0x1F`)는 해석 선언이다. 선언은 해석 규칙을 바꾸므로 모든 디코더가 처리해야 한다. 선언의 범위는 그 문서다.

- `SPEC-VERSION`은 나머지 레코드를 어떻게 읽을지 정하므로 내장 Value 없이 정수만 둔다. GEUL v1은 `0x0001`(레코드 `1890 0001`)이다.
- `DOC-ID`는 그 문서 자신을 가리키는 `DOC-POINTER`(Issuer, 문서 ID, 버전 `0`)다. 없으면 이름 없는 문서이며 내용 해시로만 가리킬 수 있다.
- 문서의 주소용 이름은 Meta로 두지 않는다. Issuer의 이름 색인 `documents.geul`이 서술 `BIND`로 붙이고, 사람이 읽는 제목은 `LABEL`로 붙인다([공표 주소와 버전 목록](/ko/grammar/publishing/#문서-이름)).
