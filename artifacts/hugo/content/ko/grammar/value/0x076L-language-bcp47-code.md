---
title: "LANGUAGE-BCP47-CODE (0x076L·0x077L)"
weight: 118
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-BCP47-CODE는 완전한 BCP 47 language tag를 ASCII 바이트열로 담는 Value다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-BCP47-CODE는 완전한 BCP 47 language tag를 ASCII 바이트열로 담는 Value다. 짝수·홀수 바이트 코드 쌍 0x076L/0x077L을 쓴다.

| 항목 | 값 |
|---|---|
| 이름 | `LANGUAGE-BCP47-CODE` (홀짝 묶음. 코드별 이름은 아래 구성원 표) |
| TAG ID | `0x076L`·`0x077L` |
| 섹션 | 3 `0011` (Value), 섹션 안 오프셋 C = 22~23 |
| Kind | Value · 계열: TEXT |
| 색인 설명 | canonical casing의 완전한 BCP 47 language tag ASCII 바이트열. 짝수·홀수 바이트 |
| Hugo 쪽 | `value/text/language-bcp47-code.md` |

## 구성원

이 쪽은 홀짝 쌍 두 코드를 함께 다룬다. 짝수 코드는 바이트 수가 짝수, 홀수 코드는 홀수인 값이다([레코드와 TAG WORD](../record.md#가변-길이-바이트열)). 코덱 문서는 코드마다 하나다. 두 코덱 문서의 필드는 같고 DECLARE 대상과 이름(BIND)만 다르다.

| TAG ID | 이름 | 바이트 수 | 코덱 ID | 규격 문서 | TAG WORD |
|---|---|---|---|---|---|
| `0x076L` | `LANGUAGE-BCP47-CODE-EVEN` | 짝수 | `0x00000760` | `0x00000000/codecs/0x00000760/` | `0000 0111 0110 LLLL` |
| `0x077L` | `LANGUAGE-BCP47-CODE-ODD` | 홀수 | `0x00000770` | `0x00000000/codecs/0x00000770/` | `0000 0111 0111 LLLL` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | 나머지 날값(`0xFFFF`) |  |  |

LANGUAGE-BCP47-CODE는 완전한 BCP 47 language tag를 담는 Value다. script, region, variant까지 언어를 정확히 적을 때 쓴다.

## 레이아웃

- 코드: Value 직접 코드 `0x076L`(짝수 바이트)·`0x077L`(홀수 바이트). 계열 TEXT.
- 바이트 수는 Codec의 최하위 비트와 Payload WORD 수로 정한다. `2 × Payload WORD 수 − 최하위 비트`이며 Byte Count는 두지 않는다([Value](_index.md)).
- Payload는 UTF-8 텍스트가 아니라 BCP 47 tag의 ASCII 바이트열이다.

```
TAG WORD          0000 0111 011P LLLL      Codec 0x076L/0x077L
[Length 확장 TAG] 전체 15 WORD 이상일 때
Payload WORD 1st ... Nth          BCP 47 tag bytes / final zero padding
```

## 해석과 유효성

- 바이트열은 RFC 5646의 well-formed BCP 47 language tag여야 한다. 빈 문자열은 허용하지 않는다.
- Payload는 ASCII 문자, 숫자, hyphen-minus `-`만 쓴다. 구분자는 반드시 ASCII `-`이며 `_`, 공백, 비ASCII 문자는 허용하지 않는다.
- BCP 47 tag 비교는 대소문자를 구분하지 않는다. GEUL canonical profile은 구분자를 모두 `-`로 쓰고, language/extlang/variant/extension/private-use subtag는 소문자, script는 Titlecase, region은 대문자로 직렬화한다.
- well-formed만으로는 충분하지 않다. registered subtag와 grandfathered tag의 유효성은 특정 IANA Language Subtag Registry snapshot을 기준으로 판정하고, 그 snapshot 날짜나 registry version을 함께 보존해야 한다.
- private-use tag와 private-use subtag는 RFC 5646 문법으로 well-formed이면 허용한다. 다만 그 의미는 당사자 합의에 달려 있고 IANA registry가 정의하지 않으므로 공용 상호운용을 보장하지 않는다.
- 같은 snapshot에서 deprecated subtag나 grandfathered tag에 Preferred-Value가 있으면, canonical GEUL form은 그 치환값을 canonical casing으로 쓴다. deprecated 표기 그대로의 tag는 입력으로 해석할 수는 있어도 canonical 저장형은 아니다.
- BCP 47은 ASCII profile이므로 UTF-8 NFC 같은 Unicode normalization 요구는 적용하지 않는다.
- WORD 안에서는 상위 byte가 먼저 온다. 바이트 수가 홀수(홀수 코드)이면 마지막 WORD의 사용하지 않는 하위 byte는 `00`이어야 한다.
- Payload WORD 수는 `ceil(바이트 수/2)`다. 홀수 코드인데 마지막 WORD의 하위 byte가 `00`이 아니면 거부한다.

## 표준 근거

- language tag 문법, 대소문자 무구분 해석, deprecated/Preferred-Value 개념은 [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646)를 따른다.
- tag 유효성을 판정하는 registry는 [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry)다.
- 홀짝 코드 쌍, zero padding, canonical casing 저장 정책과 Length 계산은 GEUL framing 규칙이다.

## 길이

- 전체는 TAG 1 WORD, Length 확장 TAG(있으면)와 Payload를 합한 WORD 수다. 14 WORD 이하는 직접 길이, 15 WORD 이상은 `1110`·`1111` 확장 길이를 쓰며, 확장 TAG도 전체 수에 포함한다([Length](../record.md)).

## LANGUAGE-SHORT-CODE와의 관계

- GEUL Language Registry에 번호가 있는 tag는 [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md) 1 WORD로 쓸 수 있다.
- 레지스트리에 번호가 없는 tag(extension·private-use가 든 tag 포함)는 LANGUAGE-BCP47-CODE로 쓴다. full tag의 원문 보존이 필요한 경우에도 LANGUAGE-BCP47-CODE를 쓴다.
- SHORT-CODE `n`과, 레지스트리가 `n`에 묶은 tag의 LANGUAGE-BCP47-CODE(대소문자 무시)는 같은 언어다.

## 예시

- `ko-KR`은 ASCII 5 byte(홀수)이므로 `LANGUAGE-BCP47-CODE-ODD`(`0x077L`), Payload는 `6B6F 2D4B 5200`이다.
- TAG 1 WORD, Payload 3 WORD로 전체 4 WORD이며 `LLLL=0011`이다. 전체는 `0773 6B6F 2D4B 5200`이다.

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000760/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000076000000000
BODY
#1 DECLARE 0x0760
#2 FIELD #1 rest
#3 BIND #1 "LANGUAGE-BCP47-CODE-EVEN"
#4 BIND #2 "bytes"
```

위는 `LANGUAGE-BCP47-CODE-EVEN`(`0x076L`)의 코덱 문서다. 다른 구성원(`LANGUAGE-BCP47-CODE-ODD`)의 코덱 문서는 DOC-ID의 코덱 ID, DECLARE 대상, `#1`에 묶은 이름(BIND)만 다르다.
