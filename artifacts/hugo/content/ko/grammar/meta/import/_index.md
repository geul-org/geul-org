---
title: "Meta — IMPORT"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "Meta IMPORT 클래스(상위 3비트 `110`, `0x60`~`0x6F`)는 외부 문서를 IMPORT ID로 가져온다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta IMPORT 클래스(상위 3비트 `110`, Codec `0x60`~`0x6F`)는 외부 문서를 IMPORT ID로 가져온다. Codec은 `IMPORT-DOC`(`0x60`) 하나다.

- IMPORT는 문서만 가져온다. 가져온 문서 안의 대상은 BODY의 Reference `EXTERNAL-POINTER-*`(IMPORT ID, LOCAL ID)로 가리킨다([Reference](/ko/grammar/reference/)).
- 버전 ID를 적으면 그 판본에, `0`이면 해석 시점의 최신 판본에 묶인다. 공표 문서는 버전을 적는다.
- 가져온 문서의 HEAD는 가져오지 않는다. Reference·Value 레코드는 가져오지 않고 복사한다.
