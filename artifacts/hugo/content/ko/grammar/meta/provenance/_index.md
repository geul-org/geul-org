---
title: "Meta — 출처"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "Meta 출처 클래스(상위 3비트 `010`, `0x20`~`0x2F`)는 문서를 누가, 언제 만들고 기록했는지 적는다. 원천 자료는 근거 Edge SOURCE로 쓴다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta 출처 클래스(상위 3비트 `010`, Codec `0x20`~`0x2F`)는 문서를 누가, 언제 만들고 기록했는지 적는다.

- 작성자·기록자와 그 시각은 git의 author·committer 모델을 따른다(`AUTHOR`·`CREATED-AT`, `RECORDED-BY`·`RECORDED-AT`).
- 출처는 지워도 서술 내용이 바뀌지 않는다. 신뢰 판단의 재료만 사라진다.
- 원천 자료는 이 클래스에 없다. 문서 전체의 원천은 HEAD에, 개별 레코드의 원천은 BODY에 근거 Edge [SOURCE](/ko/grammar/edge/source/)로 쓴다. 원문 안의 대응 범위, 확보 시각, 원문 해시는 그 SOURCE에 붙는 QUALIFIER다(쪽 P304·절 P958, 조회일 P813, 체크섬 P4092).
- 원천에 딸린 성질(원문 범위, 확보 시각)을 Meta로 두면 원천이 여럿일 때 어느 원천의 것인지 정할 수 없다. 그래서 SOURCE를 Target으로 하는 QUALIFIER로 쓴다. Codec `0x26`~`0x2F`는 예약이다.
