---
title: "PROFILE"
weight: 18
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "PROFILE은 문서에 적용한 프로파일을 이름과 버전 텍스트로 선언하는 정의 Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

문서에 적용한 프로파일을 선언한다. 같은 레코드를 프로파일이 정한 Codec 문서로 해석한다(예: `tangeul-1.0`이면 [TOULMIN](/ko/grammar/edge/toulmin/)).

## 레이아웃

```
TAG WORD          0001 1LLL L001 0001      Codec 0x11
[Length 확장 TAG]
Payload           UTF8-TEXT Value "<이름>-<major>.<minor>"
```

- Codec: Meta `0x11`, 정의 클래스(`001`)
- Payload: 내장 Value([UTF8-TEXT](/ko/grammar/value/text/utf8-text/))
- 개수: 많아야 하나

## 해석과 유효성

- major가 다른 프로파일은 거부한다. minor 차이는 허용한다(추가 변경만).
- 프로파일이 없으면 GEUL 기본 문법과 직접 코드 규격만으로 읽는다.

## 예시

- `tangeul-1.0`: `0x1B91 0x0B41 7461 6e67 6575 6c2d 312e 3000`

## 열린 문제

- 프로파일 이름 레지스트리(geul.org)와 이름 규칙.
- 프로파일을 문서 ID로 가리킬지(IMPORT), 텍스트로 둘지.
