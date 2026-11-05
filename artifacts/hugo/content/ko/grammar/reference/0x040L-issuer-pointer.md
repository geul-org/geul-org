---
title: "ISSUER-POINTER (0x040L)"
weight: 64
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "ISSUER-POINTER는 Issuer 자신을 가리키는 지시선언 Reference다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `ISSUER-POINTER` (규격 문서 BIND `ISSUER-POINTER`) |
| TAG ID | `0x040L` |
| 코덱 ID | `0x00000400` |
| 규격 문서 | `0x00000000/codecs/0x00000400/` (DECLARE 대상 `0400`) |
| 섹션 | 2 `0010` (Reference 기타), 섹션 안 오프셋 C = 0 |
| Kind | Reference · 분류: 지시선언 |
| TAG WORD | `0000 0100 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Hugo 쪽 | `reference/issuer-pointer.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | 나머지 날값(`0xFFFF`) |  |  |

ISSUER-POINTER는 Issuer 자신을 가리키는 지시선언 Reference다. Issuer 이름 `BIND`, `LABEL`, 판정 Edge의 대상이 된다.

## 레이아웃

```
TAG WORD          0000 0100 0000 LLLL      Codec 0x040L
[Length 확장 TAG]
Issuer            2/4/16 WORD
```

- Issuer 폭은 Payload 전체다. Codec이 폭을 나누지 않는다. 폭이 2, 4, 16 WORD가 아니거나, Issuer 값이 더 좁은 폭에 들어가면 invalid다(Issuer 정규형).
- Issuer가 16 WORD면 전체 17 WORD라 Length 확장 1 WORD가 붙는다.
- Codec `0x040L` 한 칸이다. 양화가 없다(Identified).
- Issuer 값은 [Issuer](../issuer.md)의 배정을 따른다.
- 쓰임: Issuer 목록 `issuers/`의 BIND Subject([공표 주소와 버전 목록](../publishing.md#issuer-목록)), Issuer 표시 이름 LABEL, Issuer에 대한 판정, 서명자 등 Issuer 자신이 대상인 자리.
- Issuer 자신을 가리키는 형식은 ISSUER-POINTER 하나다. `EXTERNAL-ISSUER-*`로 문서 ID `0`, 대상 ID `0`을 써서 Issuer를 가리키는 것은 invalid다.

## 예시

| Issuer | WORD sequence |
|---|---|
| GEUL `0x00000000` | `0402 0000 0000` |
| IEEE `0x0000000D` | `0402 0000 000D` |

## 관련 페이지

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [Issuer와 공표](../issuer.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000400/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000040000000000
BODY
#1 DECLARE 0x0400
#2 FIELD #1 rest
#3 BIND #1 "ISSUER-POINTER"
#4 BIND #2 "issuer"
```
