---
title: "GENERATED-BY (0x1D3L)"
weight: 467
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "문서를 만든 주체를 적는다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `GENERATED-BY` (규격 문서 BIND `GENERATED-BY`) |
| TAG ID | `0x1D3L` |
| 코덱 ID | `0x00001D30` |
| 규격 문서 | `0x00000000/codecs/0x00001D30/` (DECLARE 대상 `1D30`) |
| 섹션 | 14 `1110` (Meta), 섹션 안 오프셋 C = 19 |
| Kind | Meta · 클래스: 계보 |
| TAG WORD | `0001 1101 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 생성 주체. 사람, 모델, 규칙 엔진 |
| Hugo 쪽 | `meta/lineage/generated-by.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `agent` | #2 | 레코드 | 아무 레코드(자리 표지 제외) |  |
| 2 | `version` | #5 | 레코드 | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0000` ABSENT(선택 필드) |  |

문서를 만든 주체를 적는다. 사람, 모델, 규칙 엔진이 모두 될 수 있다.

## 레이아웃

```
TAG WORD          0001 1101 0011 LLLL      Codec 0x1D3L
[Length 확장 TAG]
생성 주체         Reference (사람, 모델, 규칙 엔진)
버전              UTF8-TEXT Value, 또는 생략 표지 0x0000 (선택 필드)
```

- Codec: Meta `0x1D3L`, 계보 클래스
- Payload: 내장 Reference + 버전 텍스트(선택)
- 개수: 여럿 가능

## 해석과 유효성

- 모델이면 모델 버전을 함께 적는다.
- 버전을 모르거나 두지 않으면 그 자리를 생략하고 ABSENT(`0x0000`)를 쓴다([CODEC](../edge/0x0BEL-codec.md) 선택 필드). geul.org 규격 `0x1D30`은 agent(CODEC 없음)와 version(`0720`·`0730`·`0000`)의 두 레코드 필드다.
- 프로그램의 소스 버전(커밋)은 [TRANSFORMED-BY](0x1D4L-transformed-by.md)의 형식(다이제스트, 필수)이 더 정확하다. GENERATED-BY의 버전은 모델 이름·버전처럼 커밋 ID가 아닌 것을 텍스트로 적는다.
- geul.org 공표 문서에는 자연인을 가리키는 Reference를 두지 않는다([Issuer와 공표](../issuer.md#geulorg-공표)). 조직·Issuer를 가리킨다. 예외로 [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)로 자연인을 가리키는 것은 허용한다.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001D30/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D3000000000
BODY
#1 DECLARE 0x1D30
#2 FIELD #1 record
#3 BIND #1 "GENERATED-BY"
#4 BIND #2 "agent"
#5 FIELD #1 record
#6 BIND #5 "version"
#7 CODEC #5 0x0720
#8 CODEC #5 0x0730
#9 CODEC #5 0x0000
```
