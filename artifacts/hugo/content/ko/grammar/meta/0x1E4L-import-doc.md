---
title: "IMPORT-DOC (0x1E4L)"
weight: 484
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "외부 문서를 IMPORT ID로 가져온다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 항목 | 값 |
|---|---|
| 이름 | `IMPORT-DOC` (규격 문서 BIND `IMPORT-DOC`) |
| TAG ID | `0x1E4L` |
| 코덱 ID | `0x00001E40` |
| 규격 문서 | `0x00000000/codecs/0x00001E40/` (DECLARE 대상 `1E40`) |
| 섹션 | 15 `1111` (Meta), 섹션 안 오프셋 C = 4 |
| Kind | Meta · 클래스: IMPORT |
| TAG WORD | `0001 1110 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| 색인 설명 | 외부 문서를 IMPORT ID로 가져온다. 내장 Reference `DOC-POINTER`(코덱 문서는 `CODEC-POINTER`) + IMPORT ID |
| Hugo 쪽 | `meta/import/import-doc.md` |

## 필드 (규격 문서)

FIELD의 문서 안 순서가 Payload 필드 순서다([Codec 규격 문서](../codec-spec.md)).

| 순서 | 필드(BIND) | FIELD | 폭 | 받는 형식(CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #4 | 레코드 | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |
| 2 | `import-id` | #2 | 나머지 날값(`0xFFFF`) |  |  |

외부 문서를 IMPORT ID로 가져온다. 가져올 문서는 [DOC-POINTER](../reference/0x041L-doc-pointer.md)가 가리키고, Issuer 폭도 DOC-POINTER가 담는다.

## 레이아웃

```
TAG WORD          0001 1110 0100 LLLL      Codec 0x1E4L
[Length 확장 TAG]
문서              DOC-POINTER Reference 레코드 (Issuer, 문서 ID, 버전 ID. 버전 0이면 최신). 코덱 문서는 CODEC-POINTER
IMPORT ID         나머지 전부. 가장 짧은 폭의 unsigned
```

- Codec: Meta `0x1E4L`, IMPORT 클래스
- Payload: 내장 Reference `DOC-POINTER`(Issuer, 문서 ID, 버전 ID) + IMPORT ID 날값
- 개수: 여럿 가능(IMPORT ID마다 하나)

## 해석과 유효성

- 문서는 정확히 하나의 DOC-POINTER 레코드다. 코덱 문서를 가져올 때는 [CODEC-POINTER](../reference/0x042L-codec-pointer.md)(Issuer, 코덱 ID, 버전 ID) 레코드다. 자기 Length로 끝나며, 나머지가 IMPORT ID다.
- IMPORT ID는 1 WORD 이상, 가장 짧은 폭이다. IMPORT ID의 폭은 여기서는 레코드 길이로, [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md)에서는 Codec으로 정해진다.
- 한 문서에서 같은 IMPORT ID를 두 번 배정하지 않는다.
- 버전 ID를 적으면 그 판본에, `0`이면 해석 시점의 최신(또는 지정한 시점에 시행 중인) 판본에 바인딩된다([개정](../document.md#개정)).
- BODY의 [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md)가 IMPORT ID로 가져온 문서의 LOCAL을 가리킨다. 가져온 문서 자신은 DOC-POINTER로 가리킨다.
- 가져온 문서의 HEAD는 가져오지 않는다. 그 문서의 대상은 그 문서의 선언대로 해석한다.
- IMPORT ID로는 문서를 건너 검색할 수 없다. 여러 문서를 적재하는 저장소는 IMPORT ID를 전체 경로(Issuer, 문서 ID, 버전 ID, LOCAL ID)로 풀어 저장한다.

## 예시

- IMPORT ID 1, Issuer `0x00000002`, 문서 `0x…0002`, 최신: `1E4A 0418 0000 0002 0000 0000 0000 0002 0000 0000 0001` (Meta TAG 1 + DOC-POINTER 9 + IMPORT ID 1 = 11 WORD)

## 규격 문서 원문

규격 문서 `0x00000000/codecs/0x00001E40/latest.geul`을 `geul show`로 읽은 모습이다(16진은 대문자).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E4000000000
BODY
#1 DECLARE 0x1E40
#4 FIELD #1 record
#10 CODEC #4 0x0410
#2 FIELD #1 rest
#6 BIND #1 "IMPORT-DOC"
#7 BIND #2 "import-id"
#9 BIND #4 "doc"
#11 CODEC #4 0x0420
```
