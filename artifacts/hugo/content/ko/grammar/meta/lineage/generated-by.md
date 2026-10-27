---
title: "GENERATED-BY"
weight: 51
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "GENERATED-BY는 문서를 만든 주체(사람, 모델, 규칙 엔진)와 그 버전을 적는 계보 Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

문서를 만든 주체를 적는다. 사람, 모델, 규칙 엔진이 모두 될 수 있다.

## 레이아웃

```
TAG WORD          0001 1LLL L011 0010      Codec 0x32
[Length 확장 TAG]
생성 주체         Reference (사람, 모델, 규칙 엔진)
버전              UTF8-TEXT Value, 또는 생략 표지 0x0000 (선택 필드)
```

- Codec: Meta `0x32`, 계보 클래스(`011`)
- Payload: 내장 Reference + 버전 텍스트(선택)
- 개수: 여럿 가능

## 해석과 유효성

- 모델이면 모델 버전을 함께 적는다.
- 버전을 모르거나 두지 않으면 그 자리를 생략하고 ABSENT(`0x0000`)를 쓴다([CODEC](/ko/grammar/edge/codec/) 선택 필드). geul.org 규격 `0x1832`는 agent(CODEC 없음)와 version(`0840`·`0841`·`0000`)의 두 레코드 필드다.
- 프로그램의 소스 버전(커밋)은 [TRANSFORMED-BY](/ko/grammar/meta/lineage/transformed-by/)의 형식(다이제스트, 필수)이 더 정확하다. GENERATED-BY의 버전은 모델 이름·버전처럼 커밋 ID가 아닌 것을 텍스트로 적는다.
- geul.org 공표 문서에는 자연인을 가리키는 Reference를 두지 않는다([Issuer와 공표](/ko/grammar/issuer/#geulorg-공표)). 조직·Issuer를 가리킨다. 예외로 [WIKIDATA-QID](/ko/grammar/reference/wikidata-qid/)로 자연인을 가리키는 것은 허용한다.
