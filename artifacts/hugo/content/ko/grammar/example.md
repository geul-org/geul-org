---
title: "예시: 위키데이터 항목"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "example", "wikidata"]
summary: "위키데이터 Q42(Douglas Adams)의 이름 하나, 명제 둘, 한정 조건 하나를 담은 GEUL 문서 63 WORD를 처음부터 끝까지 읽는다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

위키데이터 항목 Q42(Douglas Adams)에 관한 작은 문서를 처음부터 끝까지 읽어 본다. 담은 내용은 다음과 같다.

- 영어 이름: Douglas Adams
- Q42는 사람(Q5)의 인스턴스다(P31).
- Q42는 St John's College(Q691283)에서 교육받았다(P69). 시작 시점(P580)은 1971년이다.

문서는 Issuer `0x00000001`의 문서 `0x510000000000002A`이고, 전체 63 WORD(126바이트)다.

## 전체

```
1C01 003F 1C51 0001 1C79 0418 0000 0001 5100 0000 0000 002A 0000 0000
1C30
0A4E 0010 0051 0001 0141 002A 0799 0761 656E 446F 7567 6C61 7320 4164 616D 7300
0AA9 0051 0002 0191 001F 0141 002A 0141 0005 0000
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731
1C40
```

## HEAD

```
1C01 003F
```

`1C01`은 Meta(섹션 14), Codec `0x1C0L`(DOC-1WORD), Length 2 WORD다. 값 `003F`(63)가 문서 전체 WORD 수다. 디코더는 이 값으로 문서 끝을 미리 안다.

```
1C51 0001
```

Meta `0x1C5L` SPEC-VERSION. 이 문서가 따르는 명세 판이다. v1은 `0001`이다.

```
1C79 0418 0000 0001 5100 0000 0000 002A 0000 0000
```

Meta `0x1C7L` DOC-ID, 전체 10 WORD. Payload는 DOC-POINTER Reference 하나다.

| WORD | 뜻 |
|---|---|
| `0418` | Reference, Codec `0x041L`(DOC-POINTER), 9 WORD |
| `0000 0001` | Issuer `0x00000001` (2 WORD) |
| `5100 0000 0000 002A` | 문서 ID `0x510000000000002A` |
| `0000 0000` | 버전 `0` (자기 자신) |

```
1C30
```

BODY. HEAD가 끝나고 BODY가 시작된다.

## BODY

### #1 LABEL — 영어 이름

```
0A4E 0010 0051 0001 0141 002A 0799 0761 656E 446F 7567 6C61 7320 4164 616D 7300
```

| WORD | 뜻 |
|---|---|
| `0A4E` | Edge, Codec `0x0A4L` LABEL, Length `1110`(확장) |
| `0010` | 확장 길이: 전체 16 WORD |
| `0051 0001` | Edge Id: LOCAL 1 |
| `0141 002A` | Subject: 위키데이터 Q42 |
| `0799` | Object: UTF8-LANGUAGE-TEXT, 홀수 바이트(`0x079L`), 10 WORD |
| `0761 656E` | 언어: BCP 47 `en` |
| `446F … 7300` | `Douglas Adams` 13바이트 + 패딩 `00` |

### #2 TRIPLE — Q42는 사람이다

```
0AA9 0051 0002 0191 001F 0141 002A 0141 0005 0000
```

| WORD | 뜻 |
|---|---|
| `0AA9` | Edge, Codec `0x0AAL` TRIPLE, 10 WORD |
| `0051 0002` | Edge Id: LOCAL 2 |
| `0191 001F` | Predicate: P31 (instance of) |
| `0141 002A` | Subject: Q42 |
| `0141 0005` | Object: Q5 (사람) |
| `0000` | Rank: normal |

### #3 TRIPLE — Q42는 St John's College에서 교육받았다

```
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000
```

| WORD | 뜻 |
|---|---|
| `0AAA` | Edge, TRIPLE, 11 WORD |
| `0051 0003` | Edge Id: LOCAL 3 |
| `0191 0045` | Predicate: P69 (educated at) |
| `0141 002A` | Subject: Q42 |
| `0142 000A 8C53` | Object: Q691283. 값이 16비트를 넘어 3 WORD Reference다 |
| `0000` | Rank: normal |

### #4 QUALIFIER — 시작 시점 1971년

```
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731
```

| WORD | 뜻 |
|---|---|
| `0AB9` | Edge, Codec `0x0ABL` QUALIFIER, 10 WORD |
| `0051 0004` | Edge Id: LOCAL 4 |
| `0191 0244` | Property: P580 (start time) |
| `0051 0003` | Target: #3 (위의 TRIPLE) |
| `06E2 3139 3731` | Value: EDTF `1971` (연 정밀도라 GREGORIAN-DATE가 아니라 EDTF) |

#3의 의미는 #3 자체와 #3을 가리키는 QUALIFIER를 모두 모은 것이다: "Q42는 1971년부터 St John's College에서 교육받았다."

```
1C40
```

END. 여기까지가 63 WORD다.

## 코덱북 없이 읽으면

코덱북을 모르는 디코더도 다음을 안다.

- 문서가 63 WORD이고, HEAD에 Meta 2개, BODY에 Edge 4개가 있다.
- 각 Edge의 Codec(LABEL, TRIPLE, TRIPLE, QUALIFIER)과 Edge Id(1, 2, 3, 4).
- 레코드마다 다음 레코드의 위치.

구성요소의 역할(Predicate, Subject, Object, Rank)은 각 Codec의 [규격 문서](/ko/grammar/codec-spec/)를 읽어야 안다.

## 내용 해시

이 문서의 내용 해시(SHA-256)는 다음과 같다. 공표하면 버전 목록에 이 해시가 버전 ID와 함께 기록된다.

```
0x561C157203D51AF8C754D53E20AD190F17E73ACDC4235BA47C87F608C946737F
```
