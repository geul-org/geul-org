---
title: "DOC-POINTER"
weight: 8
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "DOC-POINTER는 Issuer가 공표한 문서의 한 버전을 가리키는 지시선언 Reference다. 버전 ID 0은 최신 버전이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DOC-POINTER는 Issuer가 공표한 문서의 한 버전을 가리키는 지시선언 Reference다. 문서 공표·deprecate·삭제, 인용 판본, 문서에 대한 서술의 대상이 된다.

## 레이아웃

```
TAG WORD          0000 0LLL L011 1QQQ      CCCC = 0111
[Length 확장 TAG]
Issuer            1/2/4/16 WORD
문서 ID           4 WORD
버전 ID           2 WORD
```

## 해석과 유효성

- Issuer 폭은 Payload에서 문서 ID와 버전 ID 6 WORD를 뺀 나머지다. Codec이 폭을 나누지 않는다. 폭이 1, 2, 4, 16 WORD가 아니거나, Issuer 값이 더 좁은 폭에 들어가면 invalid다(Issuer 정규형).
- 버전 ID는 생략하지 않는다. 생략을 허용하면 Payload 길이만으로 Issuer 폭을 정할 수 없다(Issuer 4 WORD·버전 없음과 Issuer 2 WORD·버전 있음이 같은 8 WORD).
- 버전 ID `0`은 최신 버전이다. 해석하는 시점의 현행 버전에 묶인다. 그 밖의 값은 그 버전에 고정된다([PUBLICATION](/ko/grammar/edge/publication/)).
- 문서 ID `0`은 Issuer의 용어 정의 색인 문서다. Issuer 자신은 [ISSUER-POINTER](/ko/grammar/reference/issuer-pointer/)로 가리킨다.
- Quantifier는 `000`(Identified)만 쓴다. 다른 값은 invalid다.
- Issuer의 문서를 가리키는 형식은 DOC-POINTER 하나다. `EXTERNAL-ISSUER-*`(Issuer, 문서 ID, 대상 ID `0`)나 `EXTERNAL-POINTER-*`(IMPORT ID, 대상 ID `0`)로 문서를 가리키는 것은 invalid다.
- 쓰는 곳: Meta [DOC-ID](/ko/grammar/meta/declaration/doc-id/)·[IMPORT-DOC](/ko/grammar/meta/import/import-doc/), 버전 목록의 PUBLICATION·DEPRECATION·TOMBSTONE과 BIND Subject, 이름 색인 `documents.geul`의 BIND Subject.

## 예시

GEUL Issuer `0x0000`의 문서 `0xffff000000000001`.

| 버전 | WORD sequence |
|---|---|
| 1 | `03B8 0000 ffff 0000 0000 0001 0000 0001` |
| 최신 (`0`) | `03B8 0000 ffff 0000 0000 0001 0000 0000` |

- TAG 1 + Issuer 1 + 문서 ID 4 + 버전 ID 2 = 8 WORD, `LLLL=0111`이다. TAG는 `0000 0 0111 0111 000` = `03B8`이다.

## 관련 페이지

- [Reference](/ko/grammar/reference/), [ISSUER-POINTER](/ko/grammar/reference/issuer-pointer/), [EXTERNAL-ISSUER](/ko/grammar/reference/external-issuer/), [PUBLICATION](/ko/grammar/edge/publication/)
- [Issuer와 공표](/ko/grammar/issuer/)
