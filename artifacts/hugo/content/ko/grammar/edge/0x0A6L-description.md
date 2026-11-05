---
title: "DESCRIPTION (0x0A6L)"
weight: 166
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DESCRIPTION은 Subject 대상의 특정 언어 설명 하나를 Object로 연결하는 서술 Edge다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `DESCRIPTION` (규격 문서 BIND `DESCRIPTION`) |
| TAG ID | `0x0A6L` |
| 코덱 ID | `0x00000A60` |
| 규격 문서 | `0x00000000/codecs/0x00000A60/` (DECLARE 대상 `0A60`) |
| 섹션 | 5 `0101` (Edge 서술), 섹션 안 오프셋 C = 6 |
| Kind | Edge · 계열: 서술, 묶음: 지시와 이름 |
| TAG WORD | `0000 1010 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | Subject의 언어 설명(description) 연결. 레이아웃은 LABEL과 같다 |
| Hugo 쪽 | `edge/description.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)). Edge의 Edge Id는 FIELD로 선언하지 않는다.

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | 레코드 | 아무 레코드(자리 표지 제외) |  |
| 2 | `object` | #3 | 레코드 | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

DESCRIPTION은 Subject 대상의 특정 언어 설명 하나를 Object로 연결하는 서술 Edge다. Codec `0x0A6L`.

설명은 대상을 구별하는 짧은 문구다(위키데이터 description, 예: "독일의 수도이자 최대 도시"). 대상의 정의나 주장이 아니다. 대상에 대한 명제는 [TRIPLE](0x0AAL-triple.md)로 쓴다. 레이아웃은 [LABEL](0x0A4L-label.md)과 같다. 설명과 그 언어는 Object 하나, [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)에 담긴다. 날값 필드가 없다.

## 레이아웃

```
TAG WORD          0000 1010 0110 LLLL
[Length 확장 TAG]
Edge Id           LOCAL Reference 레코드
Subject           Reference 레코드 1개
Object            UTF8-LANGUAGE-TEXT Value 또는 LOCAL Reference 레코드 1개
```

## 해석과 유효성

- Subject와 Object의 규칙은 [LABEL](0x0A4L-label.md)과 같다. Subject는 정확히 하나의 완전한 Reference 레코드다. Object는 정확히 하나의 완전한 UTF8-LANGUAGE-TEXT(`0x078L`·`0x079L`) 레코드이거나, 같은 문서의 [REFERENCE-NODE](0x0A0L-reference-node.md) 바인딩으로 UTF8-LANGUAGE-TEXT로 해소되는 LOCAL Reference다.
- 언어가 없는 텍스트(UTF8-TEXT)는 DESCRIPTION이 될 수 없다. 설명은 언어마다 하나라서, 언어가 있어야 그 규칙이 선다. 여러 언어에 공통인 설명은 언어 `mul`로 쓴다.
- 같은 Subject·언어의 DESCRIPTION은 많아야 하나다.
- 설명은 같은 이름의 다른 대상과 구별하는 데 쓴다. 같은 언어에서 LABEL과 DESCRIPTION의 짝이 두 대상에 겹치지 않는 것이 좋지만, 규격은 이를 검사하지 않는다(위키데이터도 권고일 뿐 강제하지 않는다).
- geul.org 규격 문서는 Object를 [CODEC](0x0BEL-codec.md)으로 제한한다(`0780`·`0790`·`0050`, LABEL과 같다).

## 길이

```
전체 = 1 + N_len + N_id + N_subject + N_object WORD
```

- Object의 언어 레코드와 텍스트 바이트 수는 Object 레코드가 맡는다. 마지막 레코드를 모두 읽은 커서는 Edge 끝과 정확히 맞아야 한다.
- 설명은 레이블보다 길어 Object와 Edge 모두 15 WORD를 넘기 쉽다. 그때는 Length 확장을 쓴다([레코드](../record.md)).

## 예시 (비규범)

Edge Id `0009`, Subject Q64(`0141 0040`), Object `capital and largest city of Germany`(en). 언어는 LANGUAGE-BCP47-CODE 형식의 예다(`en`은 레지스트리 번호 `0x0784`가 있어 SHORT-CODE로도 쓸 수 있다).

- Object는 언어 `0761 656E`(BCP47 `en`, 2 WORD) + 텍스트 35 byte(홀수, 18 WORD)라 `0x079L`, TAG 1 + 확장 TAG 1 + 20 = 22 WORD, `079E 0016 …`이다.
- Edge는 TAG 1 + 확장 TAG 1 + Edge Id 2 + Subject 2 + Object 22 = 28 WORD라 `LLLL=1110`, TAG `0A6E`, 확장 TAG `001C`다.

```
0A6E 001C 0051 0009 0141 0040
079E 0016 0761 656E 6361 7069 7461 6C20 616E 6420 6C61 7267 6573 7420 6369 7479 206F 6620 4765 726D 616E 7900
```

## 위키데이터 대응

- 항목의 `descriptions`(언어별 하나) → 언어마다 DESCRIPTION 하나. 언어 코드는 LABEL과 같은 언어 코드 대응표로 옮긴다.

## 열린 문제

- 언어 없는 UTF8-TEXT 설명을 허용할 사례가 있는지(지금은 허용하지 않는다).

## 관련 페이지

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [CODEC](0x0BEL-codec.md)
- [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md), [LOCAL](../reference/0x005L-local.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00000A60/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A6000000000
BODY
#1 DECLARE 0x0A60
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "DESCRIPTION"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
