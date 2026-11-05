---
title: "DOC-2WORD (0x1C1L)"
weight: 449
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "DOC-1WORD·DOC-2WORD·DOC-4WORD는 문서 전체 WORD 수를 지정해 문서를 여는 구조 Meta다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DOC-1WORD·DOC-2WORD·DOC-4WORD는 문서 전체 WORD 수를 지정해 문서를 여는 구조 Meta다.

| 항목 | 값 |
|---|---|
| 이름 | `DOC-2WORD` (규격 문서 BIND `DOC-2WORD`) |
| TAG ID | `0x1C1L` |
| 코덱 ID | `0x00001C10` |
| 규격 문서 | `0x00000000/codecs/0x00001C10/` (DECLARE 대상 `1C10`) |
| 섹션 | 14 `1110` (Meta), 섹션 안 오프셋 C = 1 |
| Kind | Meta · 클래스: 구조 |
| TAG WORD | `0001 1100 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 전체 길이를 Payload 2 WORD에 지정한 문서 시작 |
| Hugo 쪽 | `meta/structure/doc.md` (그 쪽은 [DOC-1WORD](0x1C0L-doc-1word.md), [DOC-4WORD](0x1C2L-doc-4word.md)도 함께 다룬다) |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `count` | #2 | 날값 2 WORD |  |  |

문서를 여는 레코드다. 문서 전체의 WORD 수를 Payload에 지정한다. `DOC-1WORD`(`0x1C0L`), `DOC-2WORD`(`0x1C1L`), `DOC-4WORD`(`0x1C2L`)를 이 페이지에서 함께 다룬다.

## 레이아웃

```
TAG WORD          0001 1100 0000 LLLL      Codec 0x1C0L
[Length 확장 TAG]
Payload           전체 WORD 수. Codec이 폭을 정한다: DOC-1WORD 1, DOC-2WORD 2, DOC-4WORD 4
```

- Codec: Meta `0x1C0L~0x1C2L`, 구조 클래스
- Payload: 날값(문서 전체 WORD 수, unsigned)
- 개수: 문서마다 하나, 맨 앞

## 해석과 유효성

- 길이는 여는 레코드의 시작부터 [END](0x1C4L-end.md)의 끝까지다.
- 값이 들어가는 가장 좁은 폭을 쓴다. 넓은 폭으로 인코딩하면 비정규 인코딩으로 거부한다.
- 길이가 입력 전체와 같아야 한다. 문서 하나가 입력 하나다.
- 디코더는 이 길이로 문서 전체를 건너뛸 수 있다. 길이를 모르는 채로 여는 Codec은 없다.
- 내용 해시를 계산할 때는 검증 클래스 Meta를 뺀 길이와 그에 맞는 폭으로 다시 쓴다([내용 해시](../document.md#내용-해시)).

## 예시

- `0x1C01 0x0017`: DOC-1WORD, 전체 23 WORD

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001C10/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C1000000000
BODY
#1 DECLARE 0x1C10
#2 FIELD #1 0x0002
#3 BIND #1 "DOC-2WORD"
#4 BIND #2 "count"
```
