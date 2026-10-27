---
title: "Meta — 구조"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "Meta 구조 클래스(상위 3비트 `000`, `0x00`~`0x0F`)는 문서의 경계와 길이를 정한다. DOC-1WORD/2WORD/4WORD로 열고, BODY로 HEAD를 끝내며, END로 닫는다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta 구조 클래스(상위 3비트 `000`, Codec `0x00`~`0x0F`)는 문서의 경계와 길이를 정한다. GEUL 데이터의 단위는 문서 하나다.

```
DOC-*                  ← HEAD 시작
  정의·출처·계보·검증·정책·IMPORT Meta
BODY                   ← BODY 시작
  Reference, Value, Edge
END                    ← 문서를 닫음
```

- 모든 문서는 `DOC-1WORD/2WORD/4WORD`로 전체 길이를 지정해 연다. 디코더는 이 길이로 문서 전체를 한 번에 건너뛸 수 있다.
- `BODY`와 `END`는 Payload가 없는 1 WORD 레코드다. `END`는 필수다.
- 문서는 중첩하지 않는다. 다른 문서는 IMPORT로 가리킨다.
- HEAD가 비어 있으면 `BODY`를 생략한다. `BODY`는 문서마다 한 번만 둘 수 있다.

문서 구조 전체는 [문서](/ko/grammar/document/)에 있다.
