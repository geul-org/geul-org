---
title: "END (0x1C4L)"
weight: 452
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "문서를 닫는 레코드다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `END` (규격 문서 BIND `END`) |
| TAG ID | `0x1C4L` |
| 코덱 ID | `0x00001C40` |
| 규격 문서 | `0x00000000/codecs/0x00001C40/` (DECLARE 대상 `1C40`) |
| 섹션 | 14 `1110` (Meta), 섹션 안 오프셋 C = 4 |
| Kind | Meta · 클래스: 구조 |
| TAG WORD | `0001 1100 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 1 WORD. 문서를 닫는다. |
| Hugo 쪽 | `meta/structure/end.md` |

## 필드 (규격 문서)

규격 문서에 FIELD가 없다. Payload 필드를 선언하지 않는다.

문서를 닫는 레코드다.

## 레이아웃

```
TAG WORD          0001 1100 0100 LLLL      Codec 0x1C4L
[Length 확장 TAG]
```

- Codec: Meta `0x1C4L`, 구조 클래스
- Payload: 없음(1 WORD)
- 개수: 문서마다 하나, 맨 끝

## 해석과 유효성

- 필수다. 위치는 [DOC](0x1C0L-doc-1word.md)(`DOC-*`)의 길이로 확인한다.
- END 없이 입력이 끝나면 잘린 문서다. 잘린 문서의 내용을 유효로 볼지는 디코더 정책이다.
- 뒤에 아무것도 오지 않는다.

## 예시

- `0x1C40`

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001C40/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C4000000000
BODY
#1 DECLARE 0x1C40
#2 BIND #1 "END"
```
