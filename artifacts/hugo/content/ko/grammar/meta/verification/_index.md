---
title: "Meta — 검증"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Meta 검증 클래스(`0x1E5L~0x1E9L`)는 문서를 믿을 수 있는지 판단할 재료(공개키, 서명, 신뢰도, 판정)를 적는다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta 검증 클래스(Codec `0x1E5L~0x1E9L`)는 문서를 믿을 수 있는지 판단할 재료를 적는다. 자체 발급 Issuer의 공개키, 서명, 기여 권리 확인, 신뢰도, 문서 전체의 판정 결과다.

- 검증 클래스는 내용 해시 계산에서 빠진다. 그래서 서명을 문서 안에 둬도, 서명을 여럿 더해도 내용 해시가 바뀌지 않는다(git `gpgsig`와 같은 방식).
- 검증 클래스는 섹션 15에서 `C >= 5`, 곧 `w >= 0x1E50`인 레코드라 코덱북 없이 해시를 계산할 수 있다. 뒤 빈칸 `0x1EAL~0x1FFL`도 검증 전용이라 해시에서 빠진다.
- 노드·레코드 단위의 판정은 [TOULMIN](/ko/grammar/edge/toulmin/) Edge `VERDICT`(`0x118L`)가 맡는다.
