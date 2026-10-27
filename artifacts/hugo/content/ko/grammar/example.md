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

문서는 Issuer `0x00010000`의 문서 `0x510000000000002a`이고, 전체 63 WORD(126바이트)다.

## 전체

```
1880 003f 1890 0001 1c92 0438 0001 0000 5100 0000 0000 002a 0000 0000
180e
1704 0010 0088 0001 00a0 002a 0ccb 08c6 656e 446f 7567 6c61 7320 4164 616d 7300
148a 0088 0002 00a8 001f 00a0 002a 00a0 0005 0000
150a 0088 0003 00a8 0045 00a0 002a 0120 000a 8c53 0000
148b 0088 0004 00a8 0244 0088 0003 0924 3139 3731
180f
```

## HEAD

```
1880 003f
```

`1880`은 Meta(`11`), Length 2 WORD, Codec `0x00`(DOC-1WORD)다. 값 `003f`(63)가 문서 전체 WORD 수다. 디코더는 이 값으로 문서 끝을 미리 안다.

```
1890 0001
```

Meta `0x10` SPEC-VERSION. 이 문서가 따르는 명세 판이다. v1은 `0001`이다.

```
1c92 0438 0001 0000 5100 0000 0000 002a 0000 0000
```

Meta `0x12` DOC-ID, 전체 10 WORD. Payload는 DOC-POINTER Reference 하나다.

| WORD | 뜻 |
|---|---|
| `0438` | Reference, 9 WORD, Codec `0111`(DOC-POINTER), Quantifier `000` |
| `0001 0000` | Issuer `0x00010000` (2 WORD) |
| `5100 0000 0000 002a` | 문서 ID `0x510000000000002a` |
| `0000 0000` | 버전 `0` (자기 자신) |

```
180e
```

BODY. HEAD가 끝나고 BODY가 시작된다.

## BODY

### #1 LABEL — 영어 이름

```
1704 0010 0088 0001 00a0 002a 0ccb 08c6 656e 446f 7567 6c61 7320 4164 616d 7300
```

| WORD | 뜻 |
|---|---|
| `1704` | Edge, Length `1110`(확장), Codec `0x04` LABEL |
| `0010` | 확장 길이: 전체 16 WORD |
| `0088 0001` | Edge Id: LOCAL 1 |
| `00a0 002a` | Subject: 위키데이터 Q42 |
| `0ccb` | Object: UTF8-LANGUAGE-TEXT, 10 WORD, 홀수 바이트(`0x4B`) |
| `08c6 656e` | 언어: BCP 47 `en` |
| `446f … 7300` | `Douglas Adams` 13바이트 + 패딩 `00` |

### #2 TRIPLE — Q42는 사람이다

```
148a 0088 0002 00a8 001f 00a0 002a 00a0 0005 0000
```

| WORD | 뜻 |
|---|---|
| `148a` | Edge, 10 WORD, Codec `0x0A` TRIPLE |
| `0088 0002` | Edge Id: LOCAL 2 |
| `00a8 001f` | Predicate: P31 (instance of) |
| `00a0 002a` | Subject: Q42 |
| `00a0 0005` | Object: Q5 (사람) |
| `0000` | Rank: normal |

### #3 TRIPLE — Q42는 St John's College에서 교육받았다

```
150a 0088 0003 00a8 0045 00a0 002a 0120 000a 8c53 0000
```

| WORD | 뜻 |
|---|---|
| `150a` | Edge, 11 WORD, TRIPLE |
| `0088 0003` | Edge Id: LOCAL 3 |
| `00a8 0045` | Predicate: P69 (educated at) |
| `00a0 002a` | Subject: Q42 |
| `0120 000a 8c53` | Object: Q691283. 값이 16비트를 넘어 3 WORD Reference다 |
| `0000` | Rank: normal |

### #4 QUALIFIER — 시작 시점 1971년

```
148b 0088 0004 00a8 0244 0088 0003 0924 3139 3731
```

| WORD | 뜻 |
|---|---|
| `148b` | Edge, 10 WORD, Codec `0x0B` QUALIFIER |
| `0088 0004` | Edge Id: LOCAL 4 |
| `00a8 0244` | Property: P580 (start time) |
| `0088 0003` | Target: #3 (위의 TRIPLE) |
| `0924 3139 3731` | Value: EDTF `1971` (연 정밀도라 GREGORIAN-DATE가 아니라 EDTF) |

#3의 의미는 #3 자체와 #3을 가리키는 QUALIFIER를 모두 모은 것이다: "Q42는 1971년부터 St John's College에서 교육받았다."

```
180f
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
0x4f05137f92de70951f581156cf90f15471c254c7e87ad1ba100bf91dd705ebc1
```
