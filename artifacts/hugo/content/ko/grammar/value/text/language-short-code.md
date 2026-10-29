---
title: "LANGUAGE-SHORT-CODE"
weight: 73
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE는 GEUL Language Registry가 번호를 준 BCP 47 tag 하나를 1 WORD로 담는 GEUL 언어 코드 Value다(Codec 0x48). 레지스트리는 이 Codec 규격 문서의 ENUM이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-SHORT-CODE는 GEUL Language Registry에 번호가 배정된 BCP 47 tag 하나를 1 WORD로 담는 GEUL 압축 언어 코드다. Payload는 정확히 1 WORD다.

## 레이아웃

- 코드: Value 직접 코드 `0x48`. 계열 TEXT.
- Payload는 정확히 1 WORD의 unsigned 16비트 코드다.

```
TAG WORD          0x08C8 (0000 1000 1100 1000)  전체 2 WORD
Payload WORD 1st (16비트)           GEUL Language Registry 번호 (uint16)
```

## 해석과 유효성

- Payload 1 WORD를 unsigned 16비트 정수로 읽는다.
- 이 값은 GEUL Language Registry가 배정한 tag 하나다. 레지스트리의 정식 표현은 이 Codec의 규격 문서 `0x0000/0x0000000000000848`이다. 코드값마다 FIELD `code`에 [ENUM](/ko/grammar/edge/enum/)이 하나 있고, 그 ENUM Edge Id에 [BIND](/ko/grammar/edge/bind/)로 묶인 이름이 정규 대소문자의 BCP 47 tag다.
- 레지스트리는 닫힌 목록이다. 규격 문서에 ENUM이 없는 값은 invalid다. ENUM 일반 규칙("선언되지 않은 코드값은 오류가 아니다")보다 이 Codec 규칙이 앞선다.
- 배정 대상은 다음 셋이다.
  - IANA Language Subtag Registry의 `Type: language` 레코드 가운데 `Scope: private-use`(`qaa..qtz`)를 뺀 것. collection, macrolanguage, special(`mul`·`und`·`zxx`·`mis`)은 빼지 않는다.
  - IANA가 통째로 등록한 tag: grandfathered와 redundant(`zh-Hans`, `sr-Latn`, `zh-min-nan` 등).
  - 공개 CC0 원천에서 관측된 유효한 조합 tag(`pt-BR`, `en-GB`, `be-tarask` 등). language·extlang·script·region·variant subtag로만 된 tag다. extension(`-u-`·`-t-`)과 private-use(`-x-`)가 든 tag는 받지 않는다.
- 번호가 없는 tag는 이 형식으로 쓸 수 없다. [LANGUAGE-BCP47-CODE](/ko/grammar/value/text/language-bcp47-code/)(`0x46`·`0x47`)로 쓴다. SHORT-CODE 안에는 escape 경로가 없다.
- `0x0000`과 `0xffff`는 영구히 배정하지 않는다. 이 Value에서 둘은 invalid다. 둘 다 `null`·`unknown`·`und`의 뜻으로 쓰지 않는다.
- 값의 구간은 배정 관례다. 디코더는 값의 범위로 tag의 종류를 추정하지 않는다. 값의 뜻은 규격 문서에서만 온다.

| 구간 | 쓰임 |
|---|---|
| `0x0000` | 비배정(invalid) |
| `0x0001`–`0x3fff` | language subtag 하나인 tag |
| `0x4000`–`0x7fff` | subtag 둘 이상인 tag(IANA 통째 tag, 관측된 조합 tag) |
| `0x8000`–`0xfffe` | 넘침. 위 블록이 차면 여기서 이어 배정한다 |
| `0xffff` | 비배정(invalid) |

- 초기판은 블록 안에서 tag의 소문자 ASCII순으로 번호를 준다. `0x4000` 블록은 IANA 통째 tag(grandfathered·redundant를 섞은 ASCII순) 다음에 관측된 조합 tag(ASCII순)가 온다. IANA 파일의 물리 순서와 사용 빈도는 번호 규칙이 아니다.
- 배정은 덧붙이기만 한다(append-only). 새 tag는 블록 끝에 덧붙이고, 블록이 차면 넘침 구간에 덧붙인다. 한 번 준 번호의 tag(대소문자 무시)는 바꾸지 않고, 지우거나 재사용하지 않는다.
- 새 tag는 규격 문서의 새 버전에 ENUM과 BIND를 덧붙여 넣는다. 기존 ENUM·BIND는 고치지 않는다. 그래서 어느 버전이든 앞 버전의 상위집합이다.
- 65,534개가 모두 차면 더 배정하지 않는다. 그 뒤의 새 tag는 LANGUAGE-BCP47-CODE로 쓴다. 표현력은 줄지 않고 압축 이득만 없다.
- 같은 언어: SHORT-CODE `n`과, 레지스트리가 `n`에 묶은 tag의 LANGUAGE-BCP47-CODE(대소문자 무시)는 같은 언어다.
- 레지스트리 판은 규격 문서의 버전이다. 각 판은 근거로 삼은 IANA registry 파일(File-Date, SHA-256)을 규격 문서 HEAD의 [SOURCE](/ko/grammar/edge/source/)로 적는다. 값을 해석한 판을 밝혀야 할 때는 그 버전(`0x0000/0x0000000000000848@n`)을 함께 남긴다.
- Codec 규격은 같은 1 WORD 코드를 TAG 없는 날값 필드로 담을 수 있다(날값 필드의 [CODEC](/ko/grammar/codec-spec/#codec)). 이는 그 Codec 규격의 규칙이며, 독립 Value의 wire form은 언제나 TAG 1 WORD + Payload 1 WORD다.

## 표준 근거

- tag의 뜻과 subtag 유효성은 [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry)와 [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646)를 따른다. IANA·IETF는 프로토콜 레지스트리에 대한 권리를 CC0 1.0으로 둔다([IANA Licensing Terms](https://www.iana.org/help/licensing-terms)).
- 레지스트리 번호(ASCII순 append-only 배정, 블록 구성, `0x0000`·`0xffff` 비배정, 닫힌 목록), 규격 문서 ENUM이 정식 표현이라는 것, TAG 없는 날값 필드 embedding과의 구분은 GEUL 규칙이다.

## 길이

- 전체는 TAG 1 WORD와 Payload 1 WORD를 합한 정확히 2 WORD이고 직접 길이 `LLLL=0001`을 쓴다. Length 확장 TAG, descriptor, padding은 없다.
- Payload가 정확히 1 WORD가 아니면 거부한다.

## 예시

레지스트리 v2(규격 문서 `0x0000/0x0000000000000848` 버전 2, IANA File-Date 2026-09-17)의 번호다. 8,678개를 배정했다(language 8,275, grandfathered 26, redundant 67, 관측 조합 310).

| tag | 코드 | 전체 WORD |
|---|---|---|
| `en` | `0x0784` | `08C8 0784` |
| `ko` | `0x0d06` | `08C8 0D06` |
| `zh-Hans` | `0x404c` | `08C8 404C` |
| `pt-BR` | `0x4130` | `08C8 4130` |

- 규격 문서에서 `en`은 `ENUM #2 0x0784`와 그 Edge Id에 묶인 `BIND "en"`이다.
- `de-x-formal`(private-use), `nl-u-sd-bebru`(extension)는 번호가 없으므로 LANGUAGE-BCP47-CODE로 쓴다.

## 열린 문제

- 판 사이 해석: 읽는 쪽이 가진 판보다 새 번호를 만났을 때 invalid로 버릴지, 원값을 보존한 채 "모르는 코드"로 다룰지. append-only라 최신판 하나면 늘 충분하지만, 오프라인 디코더를 위한 규칙이 필요하다.
- 정규형: 번호가 있는 tag를 SHORT-CODE로 써야(SHOULD/MUST) 하는가. MUST면 표기가 하나로 정해지지만, 새 판이 나오면 앞서 쓴 문서가 정규형이 아니게 된다.
- deprecated tag와 Preferred-Value를 규격 문서에 나타내는 방법(지금 판에는 없다).
- 관측 조합 tag를 덧붙이는 절차(원천, 관측 하한).

## 관련 페이지

- [LANGUAGE-BCP47-CODE](/ko/grammar/value/text/language-bcp47-code/), [UTF8-LANGUAGE-TEXT](/ko/grammar/value/text/utf8-language-text/), [LABEL](/ko/grammar/edge/label/)
- [Codec 규격 문서](/ko/grammar/codec-spec/), [ENUM](/ko/grammar/edge/enum/), [BIND](/ko/grammar/edge/bind/), [SOURCE](/ko/grammar/edge/source/)
