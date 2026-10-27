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
TAG WORD          0000 0LLL L11W WQQQ      CCCC = 11WW
[Length 확장 TAG]
Issuer            WW가 정한 폭 (00=1, 01=2, 10=4, 11=16 WORD)
문서 ID           4 WORD
대상 ID           나머지 전부. 그 문서의 LOCAL ID, 가장 짧은 폭
```

| CCCC | 이름 | Issuer 폭 |
|---|---|---|
| `1100` | EXTERNAL-ISSUER-1WORD | 1 WORD (geul.org 배정) |
| `1101` | EXTERNAL-ISSUER-2WORD | 2 WORD (geul.org 등록, 도메인 증명) |
| `1110` | EXTERNAL-ISSUER-4WORD | 4 WORD (geul.org 등록, 증명 없음) |
| `1111` | EXTERNAL-ISSUER-16WORD | 16 WORD (공개키에서 계산) |

- Issuer ID는 정수값이다. 값이 같으면 같은 Issuer다. Issuer는 값이 들어가는 가장 짧은 폭으로 쓰고, 그 폭의 Codec을 고른다(값이 `0xFFFF`를 넘을 때만 2 WORD, `2^32` 이상일 때만 4 WORD, `2^64` 이상일 때만 16 WORD). 더 넓은 폭의 표기는 invalid다([Issuer](/ko/grammar/issuer/)).
- Issuer 등록과 관리는 geul.org가 맡는다.
- 버전은 적지 않으며 최신 버전을 따른다. 버전을 고정하려면 [IMPORT-DOC](/ko/grammar/meta/import/import-doc/)과 [EXTERNAL-POINTER](/ko/grammar/reference/external-pointer/)를 쓴다.
- 위치는 geul.org의 위치 해석 규칙으로 찾는다([Issuer와 공표](/ko/grammar/issuer/)).
- 문서의 LOCAL만 가리킨다. 문서 자신은 [DOC-POINTER](/ko/grammar/reference/doc-pointer/), Issuer 자신은 [ISSUER-POINTER](/ko/grammar/reference/issuer-pointer/)로 가리킨다. 그래서 대상 ID는 `0`이 아니다. 문서 ID `0`은 Issuer의 용어 정의 색인 문서다.

## 유효성

- Issuer 폭이 Codec과 맞지 않거나, 값이 더 좁은 폭에 들어가면 invalid다.
- 대상 ID가 `0`이면 invalid다. 대상 ID `0`(문서 자신)은 DOC-POINTER가 맡는다.
- 대상 ID의 선행 `0x0000` WORD는 금지한다.

## 예시

| 대상 | WORD sequence |
|---|---|
| Issuer `0x0001`, 문서 `0x…0002`, LOCAL 7 | `0360 0001 0000 0000 0000 0002 0007` |
| Issuer `0x00012345`, 문서 `0x…0002`, LOCAL 7 | `03E8 0001 2345 0000 0000 0000 0002 0007` |

## 관련 페이지

- [Reference](/ko/grammar/reference/), [DOC-POINTER](/ko/grammar/reference/doc-pointer/), [ISSUER-POINTER](/ko/grammar/reference/issuer-pointer/), [EXTERNAL-POINTER](/ko/grammar/reference/external-pointer/)
- [Issuer와 공표](/ko/grammar/issuer/)
