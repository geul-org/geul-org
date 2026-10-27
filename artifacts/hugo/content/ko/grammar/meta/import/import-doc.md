---
title: "IMPORT-DOC"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "IMPORT-DOC은 외부 문서를 DOC-POINTER로 가리켜 IMPORT ID를 배정하는 IMPORT Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

외부 문서를 IMPORT ID로 가져온다. 가져올 문서는 [DOC-POINTER](/ko/grammar/reference/doc-pointer/)가 가리키고, Issuer 폭도 DOC-POINTER가 담는다.

## 레이아웃

```
TAG WORD          0001 1LLL L110 0000      Codec 0x60
[Length 확장 TAG]
문서              DOC-POINTER Reference 레코드 (Issuer, 문서 ID, 버전 ID. 버전 0이면 최신)
IMPORT ID         나머지 전부. 가장 짧은 폭의 unsigned
```

- Codec: Meta `0x60`, IMPORT 클래스(`110`)
- Payload: 내장 Reference `DOC-POINTER`(Issuer, 문서 ID, 버전 ID) + IMPORT ID 날값
- 개수: 여럿 가능(IMPORT ID마다 하나)

## 해석과 유효성

- 문서는 정확히 하나의 DOC-POINTER 레코드다. 자기 Length로 끝나며, 나머지가 IMPORT ID다.
- IMPORT ID는 1 WORD 이상, 가장 짧은 폭이다. IMPORT ID의 폭은 여기서는 레코드 길이로, [EXTERNAL-POINTER-*](/ko/grammar/reference/external-pointer/)에서는 Codec으로 정해진다. IMPORT ID는 그 문서 안에서만 유효하다.
- 한 문서에서 같은 IMPORT ID를 두 번 배정하지 않는다.
- 버전 ID를 적으면 그 판본에, `0`이면 해석 시점의 최신(또는 지정한 시점에 시행 중인) 판본에 바인딩된다([개정](/ko/grammar/document/#개정)).
- BODY의 [EXTERNAL-POINTER-*](/ko/grammar/reference/external-pointer/)가 IMPORT ID로 가져온 문서의 LOCAL을 가리킨다. 가져온 문서 자신은 DOC-POINTER로 가리킨다.
- 가져온 문서의 HEAD는 가져오지 않는다. 그 문서의 대상은 그 문서의 선언대로 해석한다.
- IMPORT ID로는 문서를 건너 검색할 수 없다. 여러 문서를 적재하는 저장소는 IMPORT ID를 전체 경로(Issuer, 문서 ID, 버전 ID, LOCAL ID)로 풀어 저장한다.

## 예시

- IMPORT ID 1, Issuer `0x0001`, 문서 `0x…0002`, 최신: `1CE0 03B8 0001 0000 0000 0000 0002 0000 0000 0001` (Meta TAG 1 + DOC-POINTER 8 + IMPORT ID 1 = 10 WORD)
