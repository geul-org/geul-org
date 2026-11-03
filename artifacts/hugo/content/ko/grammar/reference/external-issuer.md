---
title: "EXTERNAL-ISSUER"
weight: 13
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-ISSUER는 Issuer가 공표한 문서의 LOCAL ID를 IMPORT 없이 레코드 하나로 인용하는 지시선언 Reference다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-ISSUER는 Issuer가 공표한 문서의 LOCAL ID를 IMPORT 없이 인용하는 지시선언 Reference다. 레코드 하나로 뜻이 완결되며 최신 버전을 따른다.

## 레이아웃

```
TAG WORD          0000 00CC CCCC LLLL      Codec 0x02DL~0x03BL
[Length 확장 TAG]
Issuer            Codec이 정한 폭 (2/4/16 WORD)
문서 ID           4 WORD
대상 ID           나머지 전부. 그 문서의 LOCAL ID, 가장 짧은 폭
```

| Codec (Identified, Generic, Free-choice, Universal, Variable) | 이름 | Issuer 폭 |
|---|---|---|
| `0x02DL~0x031L` | EXTERNAL-ISSUER-2WORD | 2 WORD (geul.org 등록, 도메인 증명) |
| `0x032L~0x036L` | EXTERNAL-ISSUER-4WORD | 4 WORD (geul.org 등록, 증명 없음) |
| `0x037L~0x03BL` | EXTERNAL-ISSUER-16WORD | 16 WORD (공개키에서 계산) |

- 폭은 체계 번호로 정해진다: `C / 5 − 9`가 0, 1, 2이면 2, 4, 16 WORD다. 양화는 `C % 5`다.
- Issuer ID는 정수값이다. 값이 같으면 같은 Issuer다. Issuer는 값이 들어가는 가장 짧은 폭으로 쓰고, 그 폭의 Codec을 고른다(`2^32` 이상일 때만 4 WORD, `2^64` 이상일 때만 16 WORD). 더 넓은 폭의 표기는 invalid다([Issuer](/ko/grammar/issuer/)).
- Issuer 등록과 관리는 geul.org가 맡는다.
- 버전은 적지 않으며 최신 버전을 따른다. 버전을 고정하려면 [IMPORT-DOC](/ko/grammar/meta/import/import-doc/)과 [EXTERNAL-POINTER](/ko/grammar/reference/external-pointer/)를 쓴다.
- 위치는 공표 주소 규칙으로 찾는다([공표 주소와 버전 목록](/ko/grammar/publishing/)).
- 그 문서의 같은 LOCAL ID면, 그 문서 안에서 LOCAL로 쓰든 다른 문서에서 EXTERNAL-ISSUER로 쓰든(또는 IMPORT 뒤 EXTERNAL-POINTER로 쓰든) 같은 대상이다.
- 문서의 LOCAL만 가리킨다. 문서 자신은 [DOC-POINTER](/ko/grammar/reference/doc-pointer/), Issuer 자신은 [ISSUER-POINTER](/ko/grammar/reference/issuer-pointer/)로 가리킨다. 그래서 대상 ID는 `0`이 아니다. 문서 ID `0`은 Issuer의 용어 정의 색인 문서다.

## 유효성

- Issuer 폭이 Codec과 맞지 않거나, 값이 더 좁은 폭에 들어가면 invalid다.
- 대상 ID가 `0`이면 invalid다. 대상 ID `0`(문서 자신)은 DOC-POINTER가 맡는다.
- 대상 ID의 선행 `0x0000` WORD는 금지한다.

## 예시

| 대상 | WORD sequence |
|---|---|
| Issuer `0x00000002`, 문서 `0x…0002`, LOCAL 7 | `02D7 0000 0002 0000 0000 0000 0002 0007` |
| Issuer `0x00012345`, 문서 `0x…0002`, LOCAL 7 | `02D7 0001 2345 0000 0000 0000 0002 0007` |

## 관련 페이지

- [Reference](/ko/grammar/reference/), [DOC-POINTER](/ko/grammar/reference/doc-pointer/), [ISSUER-POINTER](/ko/grammar/reference/issuer-pointer/), [EXTERNAL-POINTER](/ko/grammar/reference/external-pointer/)
- [Issuer와 공표](/ko/grammar/issuer/)
