---
title: "TAG"
weight: 58
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "TAG는 버전에 붙인 불변 이름을 적는 계보 Meta다(git annotated tag)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

버전에 붙인 불변 이름을 적는다(git annotated tag).

## 레이아웃

```
TAG WORD          0001 1LLL L011 1001      Codec 0x39
[Length 확장 TAG]
이름              UTF8-TEXT-* Value
대상              SHA-256-DIGEST Value, 또는 생략 표지 0x0000 (선택 필드). 생략하면 이 버전
```

- Codec: Meta `0x39`, 계보 클래스(`011`)
- Payload: 내장 Value(텍스트 + 선택적 내용 해시)
- 개수: 여럿 가능

## 해석과 유효성

- 이름은 [UTF8-TEXT](/ko/grammar/value/text/utf8-text/), 대상은 [SHA-256-DIGEST](/ko/grammar/value/binary/sha-256-digest/)다.
- 대상을 생략하면(ABSENT `0x0000`, [CODEC](/ko/grammar/edge/codec/) 선택 필드) 이 문서 자신에 붙인 이름이다. 자기 내용 해시는 자기 안에 적을 수 없다. geul.org 규격 `0x1839`는 name(`0840`·`0841`)과 target(`0861`·`0000`)의 두 레코드 필드다.
- 같은 이름을 다른 버전에 다시 쓰지 않는다.

## 예시

- 이름 `v1`, 이 버전: `19B9 08C0 7631 0000`

## 열린 문제

- 버전 ID(순번)가 있는데도 TAG가 필요한지, 문서 이름(`BIND`)과의 역할 구분.
