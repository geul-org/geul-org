---
title: "PROFILE (0x1C6L)"
weight: 454
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "문서에 적용한 프로파일을 선언한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `PROFILE` (규격 문서 BIND `PROFILE`) |
| TAG ID | `0x1C6L` |
| 코덱 ID | `0x00001C60` |
| 규격 문서 | `0x00000000/codecs/0x00001C60/` (DECLARE 대상 `1C60`) |
| 섹션 | 14 `1110` (Meta), 섹션 안 오프셋 C = 6 |
| Kind | Meta · 클래스: 정의 |
| TAG WORD | `0001 1100 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 적용 프로파일 |
| Hugo 쪽 | `meta/declaration/profile.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `profile` | #2 | 레코드 | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD |  |

문서에 적용한 프로파일을 선언한다. 같은 레코드를 프로파일이 정한 Codec 문서로 해석한다(예: `tangeul-1.0`이면 [TOULMIN](../toulmin/_index.md)).

## 레이아웃

```
TAG WORD          0001 1100 0110 LLLL      Codec 0x1C6L
[Length 확장 TAG]
Payload           UTF8-TEXT Value "<이름>-<major>.<minor>"
```

- Codec: Meta `0x1C6L`, 정의 클래스
- Payload: 내장 Value([UTF8-TEXT](../value/0x072L-utf8-text.md))
- 개수: 많아야 하나

## 해석과 유효성

- major가 다른 프로파일은 거부한다. minor 차이는 허용한다(추가 변경만).
- 프로파일이 없으면 GEUL 기본 문법과 직접 코드 규격만으로 읽는다.

## 예시

- `tangeul-1.0`: `0x1C67 0x0736 7461 6E67 6575 6C2D 312E 3000`

## 열린 문제

- 프로파일 이름 레지스트리(geul.org)와 이름 규칙.
- 프로파일을 문서 ID로 가리킬지(IMPORT), 텍스트로 둘지.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001C60/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C6000000000
BODY
#1 DECLARE 0x1C60
#2 FIELD #1 record
#3 BIND #1 "PROFILE"
#4 BIND #2 "profile"
#5 CODEC #2 0x0720
#6 CODEC #2 0x0730
```
