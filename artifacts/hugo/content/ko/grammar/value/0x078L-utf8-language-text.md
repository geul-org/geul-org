---
title: "UTF8-LANGUAGE-TEXT (0x078L·0x079L)"
weight: 120
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-LANGUAGE-TEXT는 언어 Value 레코드 하나와 UTF-8 텍스트를 한 Value에 담는, 언어가 붙은 텍스트다(Codec 0x078L/0x079L)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-LANGUAGE-TEXT는 언어 Value 레코드 하나와 UTF-8 텍스트를 한 Value에 담는, 언어가 붙은 텍스트다(Codec 0x078L/0x079L).

| 항목 | 값 |
|---|---|
| 이름 | `UTF8-LANGUAGE-TEXT` (홀짝 묶음. 코드별 이름은 아래 구성원 표) |
| TAG ID | `0x078L`·`0x079L` |
| 섹션 | 3 `0011` (Value), 섹션 안 오프셋 C = 24~25 |
| Kind | Value · 계열: TEXT |
| 색인 설명 | 언어가 붙은 텍스트. 언어 Value 레코드(LANGUAGE-SHORT-CODE 또는 LANGUAGE-BCP47-CODE)와 UTF-8 바이트. 텍스트 바이트의 짝수·홀수 |
| Hugo 쪽 | `value/text/utf8-language-text.md` |

## 구성원

이 쪽은 홀짝 쌍 두 코드를 함께 다룬다. 짝수 코드는 바이트 수가 짝수, 홀수 코드는 홀수인 값이다([레코드와 TAG WORD](../record.md#가변-길이-바이트열)). 코덱 문서는 코드마다 하나다. 두 코덱 문서의 필드는 같고 DECLARE 대상과 이름(BIND)만 다르다.

| TAG ID | 이름 | 바이트 수 | 코덱 ID | 규격 문서 | TAG WORD |
|---|---|---|---|---|---|
| `0x078L` | `UTF8-LANGUAGE-TEXT-EVEN` | 짝수 | `0x00000780` | `0x00000000/codecs/0x00000780/` | `0000 0111 1000 LLLL` |
| `0x079L` | `UTF8-LANGUAGE-TEXT-ODD` | 홀수 | `0x00000790` | `0x00000000/codecs/0x00000790/` | `0000 0111 1001 LLLL` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `language` | #2 | 레코드 | `07A0` LANGUAGE-SHORT-CODE, `0760` LANGUAGE-BCP47-CODE-EVEN, `0770` LANGUAGE-BCP47-CODE-ODD |  |
| 2 | `bytes` | #3 | 나머지 날값(`0xFFFF`) |  |  |

UTF8-LANGUAGE-TEXT는 언어가 붙은 텍스트다. 언어 Value 레코드 하나와 UTF-8 바이트열을 한 Value에 담는다.

[UTF8-TEXT](0x072L-utf8-text.md)는 언어가 없는 문자열(식별자, 코드, 파일 이름, 원문 바이트)이고, 이 형식은 언어가 있는 텍스트(이름, 제목, 표어, 문장)다. 둘은 바이트가 같아도 다른 값이다. "Paris"(문자열)와 "Paris"(프랑스어)는 같지 않다. RDF가 `xsd:string`과 `rdf:langString`을 나누는 것과 같다.

## 레이아웃

- 코드: Value 직접 코드 `0x078L`(텍스트 짝수 바이트)·`0x079L`(텍스트 홀수 바이트). 계열 TEXT.

```
TAG WORD          0000 0111 100P LLLL      Codec 0x078L/0x079L (P = 텍스트가 홀수 바이트)
[Length 확장 TAG] 전체 15 WORD 이상일 때
Language          LANGUAGE-SHORT-CODE 또는 LANGUAGE-BCP47-CODE Value 레코드 1개 (TAG 포함)
Text WORD 1st ... Nth             UTF-8 bytes / 홀수면 마지막 0x00
```

## 해석과 유효성

- Payload는 언어 레코드로 시작한다. Payload 첫 WORD를 TAG로 읽어 그 Length만큼이 언어 레코드이고, 나머지가 텍스트 바이트다. 언어 레코드는 필수다. 언어가 없으면 이 형식이 아니라 UTF8-TEXT를 쓴다.
- 언어 레코드는 정확히 하나의 완전한 [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md)(`0x07AL`) 또는 [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md)(`0x076L`·`0x077L`) 레코드다. 다른 Codec이거나 불완전하면 invalid다. 언어 레코드의 유효성은 그 형식의 규칙을 따른다.
- 두 언어 형식 모두 쓸 수 있다. 같은 언어인지 비교하는 규칙은 [LABEL](../edge/0x0A4L-label.md)과 같다. SHORT-CODE와, 레지스트리가 그 번호에 묶은 BCP 47 tag는 같은 언어다.
- `zxx`(언어 내용 없음)는 쓰지 않는다. 그런 문자열은 UTF8-TEXT다. `und`(언어 미정)와 `mul`(여러 언어)은 언어가 있는 텍스트이므로 쓸 수 있다.
- 텍스트 바이트는 UTF8-TEXT와 같은 규칙을 따른다. well-formed UTF-8이어야 하고, 선두 U+FEFF도 문자로 허용하며, 정규화를 강제하지 않고 원문 그대로 보존한다. 비교·색인하는 쪽이 NFC로 맞춰 비교한다.
- 텍스트 바이트 수는 `2 × (Payload WORD 수 − 언어 레코드 WORD 수) − P`다. P(Codec 최하위 비트)는 텍스트 바이트의 홀짝만 나타낸다. 홀수면 마지막 WORD의 하위 byte는 `00`이어야 한다.
- 빈 텍스트(0 byte)는 짝수 코드에 언어 레코드만 둔다.

## 쓰는 곳

- 위키데이터 monolingualtext 값: `{"text":"Bundesrepublik Deutschland","language":"de"}`는 이 형식 하나가 된다. [TRIPLE](../edge/0x0AAL-triple.md)의 Object, [QUALIFIER](../edge/0x0ABL-qualifier.md)의 Value에 그대로 들어간다. 속성·rank·qualifier는 TRIPLE이 맡는다.
- [LABEL](../edge/0x0A4L-label.md)·[ALIAS](../edge/0x0A5L-alias.md)의 Object. 이름과 언어를 이 값 하나가 담는다.
- 법령·논문 제목처럼 언어가 정해진 텍스트.

## 언어 코드 대응 (위키데이터)

- 위키데이터·위키미디어 언어 코드가 모두 BCP 47은 아니다(예: `simple`, `map-bms`). 대응표로 BCP 47 tag로 옮긴다. 옮길 수 없는 코드는 쓰임에 따라 다르게 다룬다.
  - 값(monolingualtext): datavalue 원문을 UTF8-TEXT로 보존한다. 값은 명제의 일부라 버리면 명제가 바뀐다.
  - 레이블·설명·별칭: 건너뛰고 보고서에 남긴다. 이 Edge들은 언어가 있어야 성립하고(언어 없는 텍스트는 invalid), 원문은 원천 데이터에 남는다.
- 옮긴 tag가 GEUL Language Registry에 번호가 있으면 LANGUAGE-SHORT-CODE로, 없으면 LANGUAGE-BCP47-CODE로 쓴다.

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG(있으면), 언어 레코드, 텍스트 WORD를 합한 수다. 14 WORD 이하는 직접 길이, 15 WORD 이상은 확장 길이를 쓴다([Length](../record.md)).
- 언어 레코드는 SHORT-CODE면 2 WORD, BCP 47이면 `ceil(tag 바이트/2) + 1` WORD다(`de` 2 WORD, `zh-Hant` 5 WORD).

## 예시

언어는 모두 LANGUAGE-BCP47-CODE 형식의 예다. `fr`·`ko`·`de`는 레지스트리 번호가 있어 SHORT-CODE(2 WORD)로도 쓸 수 있다.

| 값 | 텍스트 바이트 | 전체 WORD |
|---|---|---|
| "Paris" (fr) | 5 (홀수) | `0795 0761 6672 5061 7269 7300` |
| "" (ko) | 0 | `0782 0761 6B6F` |
| "Bundesrepublik Deutschland" (de) | 26 (짝수) | `078E 0011 0761 6465 4275 6E64 6573 7265 7075 626C 696B 2044 6575 7473 6368 6C61 6E64` |

- "Paris": TAG `0795`(Codec `0x079L`, `LLLL=0101`, 전체 6 WORD), 언어 `0761 6672`(BCP 47 `fr`), 텍스트 `5061 7269 7300`(5 byte, 마지막 `00`).
- 세 번째는 전체 17 WORD라 Length 확장을 쓴다(`078E`의 `LLLL=1110`, 확장 TAG `0011`).

## 표준 근거

- 언어 tag: [RFC 5646 (BCP 47)](https://www.rfc-editor.org/rfc/rfc5646). `zxx`·`und`·`mul`은 IANA Language Subtag Registry의 special 코드다.
- 텍스트: [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- 문자열과 언어가 붙은 텍스트의 구분: [RDF 1.1 Concepts — language-tagged string](https://www.w3.org/TR/rdf11-concepts/#dfn-language-tagged-string).

## 열린 문제

- schema의 BCP 47 tag 문법 검사. 지금은 ASCII이고 비어 있지 않은지만 본다.

## 관련 페이지

- [Value](_index.md), [UTF8-TEXT](0x072L-utf8-text.md), [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md), [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md), [LABEL](../edge/0x0A4L-label.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000780/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000078000000000
BODY
#1 DECLARE 0x0780
#2 FIELD #1 record
#3 FIELD #1 rest
#4 BIND #1 "UTF8-LANGUAGE-TEXT-EVEN"
#5 BIND #2 "language"
#6 BIND #3 "bytes"
#7 CODEC #2 0x07A0
#8 CODEC #2 0x0760
#9 CODEC #2 0x0770
```

위는 `UTF8-LANGUAGE-TEXT-EVEN`(`0x078L`)의 코덱 문서다. 다른 구성원(`UTF8-LANGUAGE-TEXT-ODD`)의 코덱 문서는 DOC-ID의 코덱 ID, DECLARE 대상, `#1`에 묶은 이름(BIND)만 다르다.
