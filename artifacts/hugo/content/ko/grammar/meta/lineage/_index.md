---
title: "Meta — 계보"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Meta 계보 클래스(상위 3비트 `011`, `0x30`~`0x3F`)는 문서가 무엇에서 어떻게 나왔는지 git 커밋 모델로 적는다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta 계보 클래스(상위 3비트 `011`, Codec `0x30`~`0x3F`)는 문서가 무엇에서 어떻게 나왔는지 적는다. 계보는 git의 커밋 모델을 따르며, 커밋에 해당하는 단위가 문서다.

- **내용 해시**는 문서 한 벌의 내용을 가리킨다(git commit id). 여는 레코드(`DOC-*`)부터 `END` 직전까지의 SHA-256이며 검증 클래스(`100`) 레코드는 계산에서 뺀다.
- **버전 ID**는 이름 있는 문서 안에서 공표 순서대로 1부터 매기는 2 WORD 정수다. `0`은 버전을 적지 않았다는 뜻이다.
- 계보 Meta는 내용 해시로 버전을 가리킨다. 문서 안의 `PARENT`도 해시에 들어가므로 내용 해시는 이력 전체를 잇는 해시 사슬이 된다.
- 이력은 지우지 않는다. 고친 내용은 새 버전으로 낸다. branch처럼 바뀌는 포인터는 문서에 두지 않는다.
- `DELTA-BASE`·`DELTA-REMOVE`는 버전을 기준 버전에 대한 diff로 저장하는 형식이다. 버전은 언제나 스냅숏으로 정의한다.

개정 규칙은 [문서](/ko/grammar/document/)에 있다.
