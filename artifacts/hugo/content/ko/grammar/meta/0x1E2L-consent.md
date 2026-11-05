---
title: "CONSENT (0x1E2L)"
weight: 482
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "동의 범위와 근거를 적는다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `CONSENT` (규격 문서 BIND `CONSENT`) |
| TAG ID | `0x1E2L` |
| 코덱 ID | `0x00001E20` |
| 규격 문서 | `0x00000000/codecs/0x00001E20/` (DECLARE 대상 `1E20`) |
| 섹션 | 15 `1111` (Meta), 섹션 안 오프셋 C = 2 |
| Kind | Meta · 클래스: 정책 |
| TAG WORD | `0001 1110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 동의 범위와 근거 |
| Hugo 쪽 | `meta/policy/consent.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `consent` | #2 | 레코드 | `000F` 섹션 0 전체(와일드카드, Reference), `020F` 섹션 1 전체(와일드카드, Reference), `040F` 섹션 2 전체(와일드카드, Reference), `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT |  |

동의 범위와 근거를 적는다.

## 레이아웃

```
TAG WORD          0001 1110 0010 LLLL      Codec 0x1E2L
[Length 확장 TAG]
Payload           동의 근거를 가리키는 Reference 또는 텍스트
```

- Codec: Meta `0x1E2L`, 정책 클래스
- Payload: 내장 Reference 또는 Value
- 개수: 여럿 가능

## 열린 문제

- 범위 표현(목적·기간·제3자 제공)의 구조.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001E20/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E2000000000
BODY
#1 DECLARE 0x1E20
#2 FIELD #1 record
#3 BIND #1 "CONSENT"
#4 BIND #2 "consent"
#5 CODEC #2 0x000F
#10 CODEC #2 0x020F
#11 CODEC #2 0x040F
#6 CODEC #2 0x0720
#7 CODEC #2 0x0730
#8 CODEC #2 0x0780
#9 CODEC #2 0x0790
```
