---
title: "SIGNED-OFF (0x1E7L)"
weight: 487
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "기여 권리 확인이다(git Signed-off-by, DCO)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `SIGNED-OFF` (규격 문서 BIND `SIGNED-OFF`) |
| TAG ID | `0x1E7L` |
| 코덱 ID | `0x00001E70` |
| 규격 문서 | `0x00000000/codecs/0x00001E70/` (DECLARE 대상 `1E70`) |
| 섹션 | 15 `1111` (Meta), 섹션 안 오프셋 C = 7 |
| Kind | Meta · 클래스: 검증 |
| TAG WORD | `0001 1110 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 기여 권리 확인. Reference (git `Signed-off-by`, DCO) |
| Hugo 쪽 | `meta/verification/signed-off.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `signer` | #2 | 레코드 | 아무 레코드(자리 표지 제외) |  |

기여 권리 확인이다(git `Signed-off-by`, DCO).

## 레이아웃

```
TAG WORD          0001 1110 0111 LLLL      Codec 0x1E7L
[Length 확장 TAG]
Payload           Reference 하나
```

- Codec: Meta `0x1E7L`, 검증 클래스
- Payload: 내장 Reference
- 개수: 여럿 가능

## 해석과 유효성

- geul.org 공표 문서에는 자연인을 가리키는 Reference를 두지 않는다([Issuer와 공표](../issuer.md#geulorg-공표)). 조직·Issuer를 가리킨다. 예외로 [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)로 자연인을 가리키는 것은 허용한다.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001E70/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E7000000000
BODY
#1 DECLARE 0x1E70
#2 FIELD #1 record
#3 BIND #1 "SIGNED-OFF"
#4 BIND #2 "signer"
```
