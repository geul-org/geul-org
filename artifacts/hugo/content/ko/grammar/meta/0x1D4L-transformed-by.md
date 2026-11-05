---
title: "TRANSFORMED-BY (0x1D4L)"
weight: 468
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "다른 표현에서 이 문서로 바꾼 방법을 적는다(예: 위키데이터 변환기, 자연어 인코더)."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `TRANSFORMED-BY` (규격 문서 BIND `TRANSFORMED-BY`) |
| TAG ID | `0x1D4L` |
| 코덱 ID | `0x00001D40` |
| 규격 문서 | `0x00000000/codecs/0x00001D40/` (DECLARE 대상 `1D40`) |
| 섹션 | 14 `1110` (Meta), 섹션 안 오프셋 C = 20 |
| Kind | Meta · 클래스: 계보 |
| TAG WORD | `0001 1101 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 변환 방법. 도구·규칙·버전 |
| Hugo 쪽 | `meta/lineage/transformed-by.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `tool` | #2 | 레코드 | 아무 레코드(자리 표지 제외) |  |
| 2 | `version` | #3 | 레코드 | `07C0` SHA-256-DIGEST, `07D0` SHA1-DIGEST |  |

다른 표현에서 이 문서로 바꾼 방법을 적는다(예: 위키데이터 변환기, 자연어 인코더). Tool은 무엇으로 바꿨는지, Version은 그 도구의 어느 소스로 바꿨는지다. 둘이 있어야 같은 입력에서 같은 문서를 다시 만들 수 있다.

## 레이아웃

```
TAG WORD          0001 1101 0100 LLLL      Codec 0x1D4L
[Length 확장 TAG]
Tool              Reference 레코드 1개 (변환 도구·규칙)
Version           Value 레코드 1개 (SHA-256-DIGEST 또는 SHA1-DIGEST)
```

- Codec: Meta `0x1D4L`, 계보 클래스
- Payload: 내장 Reference(도구) + 내장 Value(소스 버전 다이제스트)
- 개수: 여럿 가능(도구마다 하나)

## 해석과 유효성

- Tool은 정확히 하나의 완전한 Reference 레코드다. 도구를 가리키는 어떤 Reference든 쓸 수 있다.
  - geul.org 도구 문서의 도구: [EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md)(`0x00000000`, 문서 ID `0x0001xxxx xxxxxxxx`, 그 LOCAL). 도구 하나에 문서 하나다([Issuer](../issuer.md) 용어 정의 문서).
  - 코덱이 GEUL 문서이면 그 코덱 문서를 [CODEC-POINTER](../reference/0x042L-codec-pointer.md)로 가리킨다.
- Version은 정확히 하나의 완전한 Value 레코드이며 Tool 소스의 버전 관리 객체 ID다. git이면 커밋 객체 ID 전체다.
  - git 저장소의 객체 형식이 SHA-256이면 [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md)(`0x07CL`, 16 WORD), SHA-1이면 [SHA1-DIGEST](../value/0x07DL-sha1-digest.md)(`0x07DL`, 10 WORD)다. 저장소 형식은 `git rev-parse --show-object-format`으로 확인한다.
  - 축약 ID(`2bd496f` 등)는 쓰지 않는다. 다이제스트 Value는 잘라낸 값을 허용하지 않는다.
  - hex 텍스트(UTF8-TEXT)로 쓰지 않는다. 같은 값이 SHA-1에서 22 WORD(바이너리 11), SHA-256에서 34 WORD(바이너리 18)다.
- Version은 필수다. 소스 버전을 모르는 도구 기록은 재현의 근거가 되지 못한다. 버전 관리 밖의 도구라면 배포물의 SHA-256(SHA-256-DIGEST)을 쓴다.
- Version은 커밋된 소스를 가리킨다. 커밋되지 않은 변경이 있는 작업 트리로 만든 문서에는 그 커밋 ID를 쓰지 않는다(도구가 실행을 거부하는 것을 권한다).
- 도구가 저장소 밖의 코드에 기대면(예: Go `replace`로 가리킨 로컬 라이브러리) 그 코드도 TRANSFORMED-BY로 따로 적는다. 도구의 커밋 ID만으로는 그 코드가 정해지지 않는다.
- 원천을 무손실로 옮겨 담기만 하는 도구(예: 덤프를 원문 그대로 DB에 적재하는 도구)는 문서 내용을 정하지 않으므로 적지 않는다. 무손실이 아닌 적재는 문서를 바꾸므로 도구로 적는다.
- geul.org 규격 문서(`0x1D40`)는 Tool(폭 0, 아무 Reference라 CODEC 없음)과 Version(폭 0, [CODEC](../edge/0x0BEL-codec.md) `07C0`·`07D0`)의 두 레코드 필드로 적는다.

## 길이

```
전체 = 1 + N_len + N_tool + N_version WORD
```

- 마지막 레코드를 모두 읽은 커서는 Meta 끝과 정확히 일치해야 한다.
- Tool이 EXTERNAL-ISSUER-2WORD(8 WORD)이고 Version이 SHA1-DIGEST(11 WORD)면 전체 1 + 1 + 8 + 11 = 21 WORD로 확장 길이를 쓴다. SHA-256-DIGEST(18 WORD)면 28 WORD다.

## 예시

비규범 예시다. 도구는 geul.org 도구 문서 `0x0001000000000001`의 LOCAL 2(`02F7 0000 0000 0001 0000 0000 0001 0002`), 소스는 커밋 `ddc0719974a32aaa7b422ee84221a9721085ce4c`(SHA-1)다.

```
1D4E 0015
02F7 0000 0000 0001 0000 0000 0001 0002
07DA DDC0 7199 74A3 2AAA 7B42 2EE8 4221 A972 1085 CE4C
```

## 열린 문제

- [GENERATED-BY](0x1D3L-generated-by.md)의 버전도 같은 방식(필수 다이제스트 또는 다른 형식)으로 바꿀지. 모델 버전은 커밋 ID가 아니다.

## 관련 페이지

- [Meta](_index.md), [GENERATED-BY](0x1D3L-generated-by.md), [DERIVED-FROM](0x1D2L-derived-from.md)
- [EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md), [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md), [SHA1-DIGEST](../value/0x07DL-sha1-digest.md), [CODEC](../edge/0x0BEL-codec.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001D40/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D4000000000
BODY
#1 DECLARE 0x1D40
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "TRANSFORMED-BY"
#5 BIND #2 "tool"
#6 BIND #3 "version"
#7 CODEC #3 0x07C0
#8 CODEC #3 0x07D0
```
