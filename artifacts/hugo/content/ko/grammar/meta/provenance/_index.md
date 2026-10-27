---
title: "Meta — 출처"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "Meta 출처 클래스(상위 3비트 `010`, `0x20`~`0x2F`)는 문서를 누가, 언제, 어디서 만들고 기록했는지 적는다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta 출처 클래스(상위 3비트 `010`, Codec `0x20`~`0x2F`)는 문서를 누가, 언제, 어디서 만들고 기록했는지 적는다.

- 작성자·기록자와 그 시각은 git의 author·committer 모델을 따른다(`AUTHOR`·`CREATED-AT`, `RECORDED-BY`·`RECORDED-AT`).
- 원천 자료는 `SOURCE`, 원문 안의 대응 범위는 `SOURCE-SPAN`, 확보 시각은 `ACQUIRED-AT`이다.
- 출처는 지워도 서술 내용이 바뀌지 않는다. 신뢰 판단의 재료만 사라진다.
- 개별 레코드의 출처는 BODY의 근거 Edge로 쓴다([Edge](/ko/grammar/edge/)).
