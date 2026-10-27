---
title: "DOC"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "DOC-1WORD·DOC-2WORD·DOC-4WORD는 문서 전체 WORD 수를 지정해 문서를 여는 구조 Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

문서를 여는 레코드다. 문서 전체의 WORD 수를 Payload에 지정한다. `DOC-1WORD`(`0x00`), `DOC-2WORD`(`0x01`), `DOC-4WORD`(`0x02`)를 이 페이지에서 함께 다룬다.

## 레이아웃

```
TAG WORD          0001 1LLL L000 0000      Codec 0x00
[Length 확장 TAG]
Payload           전체 WORD 수. Codec이 폭을 정한다: DOC-1WORD 1, DOC-2WORD 2, DOC-4WORD 4
```

- Codec: Meta `0x00`~`0x02`, 구조 클래스(`000`)
- Payload: 날값(문서 전체 WORD 수, unsigned)
- 개수: 문서마다 하나, 맨 앞

## 해석과 유효성

- 길이는 여는 레코드의 시작부터 [END](/ko/grammar/meta/structure/end/)의 끝까지다.
- 값이 들어가는 가장 좁은 폭을 쓴다. 넓은 폭으로 인코딩하면 비정규 인코딩으로 거부한다.
- 길이가 입력 전체와 같아야 한다. 문서 하나가 입력 하나다.
- 디코더는 이 길이로 문서 전체를 건너뛸 수 있다. 길이를 모르는 채로 여는 Codec은 없다.
- 내용 해시를 계산할 때는 검증 클래스 Meta를 뺀 길이와 그에 맞는 폭으로 다시 쓴다([내용 해시](/ko/grammar/document/#내용-해시)).

## 예시

- `0x1880 0x0017`: DOC-1WORD, 전체 23 WORD
