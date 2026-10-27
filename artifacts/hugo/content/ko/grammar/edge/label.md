---
title: "LABEL"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "LABEL은 Subject 대상의 언어별 이름 하나를 UTF8-LANGUAGE-TEXT Object로 연결하는 서술 Edge다(Codec 0x04)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LABEL은 Subject 대상의 특정 언어 이름(label) 하나를 Object로 연결하는 서술 Edge다. Codec `0x04`. 일반 어휘학의 lemma를 나타내는 Edge가 아니다.

이름과 그 언어는 Object 하나, [UTF8-LANGUAGE-TEXT](/ko/grammar/value/text/utf8-language-text/)에 담긴다. 날값 필드가 없다.

## 레이아웃

```
TAG WORD          0001 0LLL L000 0100
[Length 확장 TAG]
Edge Id           LOCAL Reference 레코드
Subject           Reference 레코드 1개
Object            UTF8-LANGUAGE-TEXT Value 또는 LOCAL Reference 레코드 1개
```

## 해석과 유효성

- Subject는 정확히 하나의 완전한 Reference 레코드다. Subject 자체의 Length로 경계를 찾으며, Reference가 아니거나 불완전하면 invalid다.
- Object는 정확히 하나의 완전한 [UTF8-LANGUAGE-TEXT](/ko/grammar/value/text/utf8-language-text/)(`0x4A`·`0x4B`) 레코드다. 언어와 텍스트의 규칙(두 언어 형식 모두 허용, 같은 언어 비교)은 그 형식을 따른다.
- Object에는 LOCAL Reference도 올 수 있다. 이때는 같은 문서의 [REFERENCE-NODE](/ko/grammar/edge/reference-node/) 바인딩으로 UTF8-LANGUAGE-TEXT로 해소되어야 한다. 해소되지 않거나 다른 종류의 대상으로 해소되면 invalid다.
- geul.org 규격 문서는 이 제한을 [CODEC](/ko/grammar/edge/codec/)으로 적는다(Object = `084A`·`084B`·`0008`). LOCAL의 해소 대상은 CODEC으로 나타내지 않는다.
- Object가 위 두 형식 중 하나가 아니거나 레코드가 불완전하면 invalid다. 언어가 없는 텍스트(UTF8-TEXT)는 LABEL이 될 수 없다. 언어 없는 기계용 이름은 [BIND](/ko/grammar/edge/bind/)로 쓴다. 여러 언어에 공통인 이름은 언어 `mul`로 쓴다.
- 같은 Subject·언어의 LABEL은 많아야 하나다. 다른 이름은 [ALIAS](/ko/grammar/edge/alias/)로 쓴다.

## 길이

```
전체 = 1 + N_len + N_id + N_subject + N_object WORD
```

- Object의 언어 레코드와 텍스트 바이트 수는 Edge가 아니라 Object 레코드가 맡는다. 마지막 레코드를 모두 읽은 커서는 Edge 끝과 정확히 맞아야 한다.

## 예시 (비규범)

`en`의 언어 코드는 레지스트리가 아직 봉인되지 않았으므로 `0783`은 확정 코드가 아닌 비규범 값이다.

### LANGUAGE-SHORT-CODE

Edge Id `0007`, Subject Q22686(`00A0 589e`), Object `Donald Trump`(en).

- Object는 언어 `08C8 0783`(SHORT-CODE 2 WORD) + 텍스트 12 byte(짝수, 6 WORD)라 `UTF8-LANGUAGE-TEXT-EVEN`(`0x4A`), 전체 9 WORD `0C4A 08C8 0783 446f 6e61 6c64 2054 7275 6d70`이다.
- Edge는 TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, `LLLL=1101`이다. TAG는 `1684`다.

```
1684 0088 0007 00A0 589e 0C4A 08C8 0783 446f 6e61 6c64 2054 7275 6d70
```

### LANGUAGE-BCP47-CODE

Edge Id `0008`, Subject Q155(`00A0 009b`), Object `Brasil`(pt-BR).

- Object는 언어 `09C7 7074 2d42 5200`(BCP47 `pt-BR`, 4 WORD) + 텍스트 6 byte(짝수, 3 WORD)라 전체 8 WORD `0BCA 09C7 7074 2d42 5200 4272 6173 696c`이다.
- Edge는 TAG 1 + Edge Id 2 + Subject 2 + Object 8 = 13 WORD, `LLLL=1100`이다. TAG는 `1604`다.

```
1604 0088 0008 00A0 009b 0BCA 09C7 7074 2d42 5200 4272 6173 696c
```

## 관련 페이지

- [Edge](/ko/grammar/edge/), [ALIAS](/ko/grammar/edge/alias/), [DESCRIPTION](/ko/grammar/edge/description/), [BIND](/ko/grammar/edge/bind/)
- [UTF8-LANGUAGE-TEXT](/ko/grammar/value/text/utf8-language-text/), [LANGUAGE-SHORT-CODE](/ko/grammar/value/text/language-short-code/), [LANGUAGE-BCP47-CODE](/ko/grammar/value/text/language-bcp47-code/)
- [LOCAL](/ko/grammar/reference/local/), [REFERENCE-NODE](/ko/grammar/edge/reference-node/)
