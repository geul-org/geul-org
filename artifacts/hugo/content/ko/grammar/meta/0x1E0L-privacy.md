---
title: "PRIVACY (0x1E0L)"
weight: 480
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "문서의 개인정보 등급을 적는다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `PRIVACY` (규격 문서 BIND `PRIVACY`) |
| TAG ID | `0x1E0L` |
| 코덱 ID | `0x00001E00` |
| 규격 문서 | `0x00000000/codecs/0x00001E00/` (DECLARE 대상 `1E00`) |
| 섹션 | 15 `1111` (Meta), 섹션 안 오프셋 C = 0 |
| Kind | Meta · 클래스: 정책 |
| TAG WORD | `0001 1110 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 개인정보 등급 |
| Hugo 쪽 | `meta/policy/privacy.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `level` | #2 | 날값 1 WORD |  |  |

문서의 개인정보 등급을 적는다.

## 레이아웃

```
TAG WORD          0001 1110 0000 LLLL      Codec 0x1E0L
[Length 확장 TAG]
등급              1 WORD
```

- Codec: Meta `0x1E0L`, 정책 클래스
- Payload: 날값(등급 1 WORD)
- 개수: 많아야 하나

## 해석과 유효성

- 해석을 바꾸지 않는다. 취급만 정한다.

## 열린 문제

- 등급 코드표(개인정보 보호법 분류와의 대응).

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001E00/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E0000000000
BODY
#1 DECLARE 0x1E00
#2 FIELD #1 0x0001
#3 BIND #1 "PRIVACY"
#4 BIND #2 "level"
```
