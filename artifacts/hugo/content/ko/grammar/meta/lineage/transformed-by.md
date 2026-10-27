---
title: "TRANSFORMED-BY"
weight: 52
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "TRANSFORMED-BY는 다른 표현에서 이 문서로 바꾼 도구와 그 소스 버전(커밋 다이제스트)을 적는 계보 Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

다른 표현에서 이 문서로 바꾼 방법을 적는다(예: 위키데이터 변환기, 자연어 인코더). Tool은 무엇으로 바꿨는지, Version은 그 도구의 어느 소스로 바꿨는지다. 둘이 있어야 같은 입력에서 같은 문서를 다시 만들 수 있다.

## 레이아웃

```
TAG WORD          0001 1LLL L011 0011      Codec 0x33
[Length 확장 TAG]
Tool              Reference 레코드 1개 (변환 도구·규칙)
Version           Value 레코드 1개 (SHA-256-DIGEST 또는 SHA1-DIGEST)
```

- Codec: Meta `0x33`, 계보 클래스(`011`)
- Payload: 내장 Reference(도구) + 내장 Value(소스 버전 다이제스트)
- 개수: 여럿 가능(도구마다 하나)

## 해석과 유효성

- Tool은 정확히 하나의 완전한 Reference 레코드다. 도구를 가리키는 어떤 Reference든 쓸 수 있다.
  - geul.org 도구 문서의 도구: [EXTERNAL-ISSUER](/ko/grammar/reference/external-issuer/)(`0x0000`, 문서 ID `0x0001xxxx xxxxxxxx`, 그 LOCAL). 도구 하나에 문서 하나다([Issuer](/ko/grammar/issuer/) 용어 정의 문서).
  - 코덱이 GEUL 문서이면 그 문서를 [DOC-POINTER](/ko/grammar/reference/doc-pointer/)로 가리킨다.
- Version은 정확히 하나의 완전한 Value 레코드이며 Tool 소스의 버전 관리 객체 ID다. git이면 커밋 객체 ID 전체다.
  - git 저장소의 객체 형식이 SHA-256이면 [SHA-256-DIGEST](/ko/grammar/value/binary/sha-256-digest/)(`0x61`, 16 WORD), SHA-1이면 [SHA1-DIGEST](/ko/grammar/value/binary/sha1-digest/)(`0x62`, 10 WORD)다. 저장소 형식은 `git rev-parse --show-object-format`으로 확인한다.
  - 축약 ID(`2bd496f` 등)는 쓰지 않는다. 다이제스트 Value는 잘라낸 값을 허용하지 않는다.
  - hex 텍스트(UTF8-TEXT)로 쓰지 않는다. 같은 값이 SHA-1에서 22 WORD(바이너리 11), SHA-256에서 34 WORD(바이너리 18)다.
- Version은 필수다. 소스 버전을 모르는 도구 기록은 재현의 근거가 되지 못한다. 버전 관리 밖의 도구라면 배포물의 SHA-256(SHA-256-DIGEST)을 쓴다.
- Version은 커밋된 소스를 가리킨다. 커밋되지 않은 변경이 있는 작업 트리로 만든 문서에는 그 커밋 ID를 쓰지 않는다(도구가 실행을 거부하는 것을 권한다).
- 도구가 저장소 밖의 코드에 기대면(예: Go `replace`로 가리킨 로컬 라이브러리) 그 코드도 TRANSFORMED-BY로 따로 적는다. 도구의 커밋 ID만으로는 그 코드가 정해지지 않는다.
- 원천을 무손실로 옮겨 담기만 하는 도구(예: 덤프를 원문 그대로 DB에 적재하는 도구)는 문서 내용을 정하지 않으므로 적지 않는다. 무손실이 아닌 적재는 문서를 바꾸므로 도구로 적는다.
- geul.org 규격 문서(`0x1833`)는 Tool(폭 0, 아무 Reference라 CODEC 없음)과 Version(폭 0, [CODEC](/ko/grammar/edge/codec/) `0861`·`0862`)의 두 레코드 필드로 적는다.

## 길이

```
전체 = 1 + N_len + N_tool + N_version WORD
```

- 마지막 레코드를 모두 읽은 커서는 Meta 끝과 정확히 일치해야 한다.
- Tool이 EXTERNAL-ISSUER-1WORD(7 WORD)이고 Version이 SHA1-DIGEST(11 WORD)면 전체 1 + 1 + 7 + 11 = 20 WORD로 확장 길이를 쓴다. SHA-256-DIGEST(18 WORD)면 27 WORD다.

## 예시

비규범 예시다. 도구는 geul.org 도구 문서 `0x0001000000000001`의 LOCAL 2(`0360 0000 0001 0000 0000 0001 0002`), 소스는 커밋 `ddc0719974a32aaa7b422ee84221a9721085ce4c`(SHA-1)다.

```
1F33 0014
0360 0000 0001 0000 0000 0001 0002
0D62 ddc0 7199 74a3 2aaa 7b42 2ee8 4221 a972 1085 ce4c
```

## 열린 문제

- [GENERATED-BY](/ko/grammar/meta/lineage/generated-by/)의 버전도 같은 방식(필수 다이제스트 또는 다른 형식)으로 바꿀지. 모델 버전은 커밋 ID가 아니다.

## 관련 페이지

- [Meta](/ko/grammar/meta/), [GENERATED-BY](/ko/grammar/meta/lineage/generated-by/), [DERIVED-FROM](/ko/grammar/meta/lineage/derived-from/)
- [EXTERNAL-ISSUER](/ko/grammar/reference/external-issuer/), [DOC-POINTER](/ko/grammar/reference/doc-pointer/), [SHA-256-DIGEST](/ko/grammar/value/binary/sha-256-digest/), [SHA1-DIGEST](/ko/grammar/value/binary/sha1-digest/), [CODEC](/ko/grammar/edge/codec/)
