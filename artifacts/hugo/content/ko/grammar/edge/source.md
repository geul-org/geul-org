---
title: "SOURCE"
weight: 33
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SOURCE는 레코드 하나 또는 문서 전체를 그 원천에 잇는 근거 Edge다(Codec 0x20). 원천의 성질은 원천을 Subject로 하는 TRIPLE로, 인용의 성질(조회일, 원천 안의 위치, 원문 해시)은 SOURCE에 붙는 QUALIFIER로 쓴다. 문서 전체의 SOURCE는 HEAD에 둔다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SOURCE는 레코드 하나(대상) 또는 문서 전체를 그것이 나온 원천에 잇는 근거 Edge다. Codec `0x20`. 근거 계열(`01`)의 유일한 직접 코드다.

위키데이터 reference(출처 묶음) 하나가 SOURCE 하나다. 레코드 하나에 출처가 여럿이면 SOURCE도 여럿이다.

## 레이아웃

```
TAG WORD          0001 0LLL L010 0000
[Length 확장 TAG]
Edge Id           LOCAL Reference 레코드
Target            LOCAL Reference 레코드 (BODY에서는 근거를 붙이는 Edge의 Edge Id, HEAD에서는 0 = 문서 전체)
Origin            Reference 레코드, 또는 자리 표지 0x0000 ABSENT·0x0001 UNKNOWN-VALUE
```

- Origin은 원천을 가리킨다. 원천에 맞는 Reference가 있으면 그것(WIKIDATA-QID, GEUL 문서의 DOC-POINTER·EXTERNAL-ISSUER 등), 없으면 이 문서의 LOCAL 노드다.
- 출처가 원천을 기술하지 않으면(예: 위키데이터 "imported from"(P143)·조회일만 있는 출처) Origin은 [ABSENT](/ko/grammar/reference/slot-marker/)(적지 않음)다. 쓰는 쪽은 원천을 적지 않았을 뿐, 원천에 관해 아무것도 단언하지 않는다. 출처의 나머지는 QUALIFIER에 그대로 있다.
- 쓰는 쪽이 "원천이 있지만 무엇인지 모른다"고 단언할 때만 [UNKNOWN-VALUE](/ko/grammar/reference/slot-marker/)를 쓴다(사람이 쓰는 기록 등). 원천 자료에서 옮기는 변환기는 원천이 말하지 않은 것을 단언하지 않으므로 ABSENT를 쓴다.
- ABSENT·UNKNOWN-VALUE인 Origin은 출현마다 독립이다. 두 SOURCE의 원천을 같다고 읽지 않는다.

## 두 층

출처에 관한 정보는 둘로 나뉜다. 섞지 않는다.

| 층 | 무엇 | 쓰는 법 | 예 |
|---|---|---|---|
| 원천 | 원천 자체의 성질. 누가 인용하든 같다 | 원천을 Subject로 하는 [TRIPLE](/ko/grammar/edge/triple/) (rank normal) | URL(P854), 제목(P1476), 저자(P50·P2093), 발행일(P577), 게재지(P1433), 발행처(P123), 언어(P407) |
| 인용 | 이 레코드가 원천을 인용한 행위의 성질 | SOURCE의 Edge Id를 Target으로 하는 [QUALIFIER](/ko/grammar/edge/qualifier/) | 조회일(P813), 원천 안의 위치(쪽 P304, 절 P958, 외부 식별자 P227·P1417), 가져온 곳(P143), 추론 방법(P887), 원문 해시(P4092) |

- **SOURCE의 의미는 그 Edge Id를 가리키는 QUALIFIER를 모두 모은 것이다.** 같은 원천을 다른 날 조회한 두 출처는 원천은 같고 QUALIFIER가 다르다.
- 원천 TRIPLE은 원천에 관한 단언이다. 어느 층인지 정하지 못한 성질은 인용 쪽(QUALIFIER)에 둔다. 원천에 관해 단언하지 않는 쪽이 안전하다.
- 문서 안에서 같은 원천은 LOCAL 하나로 한 번만 선언하고 여러 SOURCE가 함께 가리킨다.
- URL 하나로만 기술되는 원천은 [REFERENCE-NODE](/ko/grammar/edge/reference-node/)(LOCAL → URI)로 정의한다. sitelink 문서 페이지와 같은 방식이다.

## 해석과 유효성

- Target, Origin은 각각 정확히 하나의 완전한 레코드다. Origin을 읽은 커서는 Edge 끝과 맞아야 한다.
- Target은 LOCAL Reference다. BODY의 SOURCE는 같은 문서 BODY의 Edge Id를 가리킨다. `0`(문서 전체)은 HEAD의 SOURCE만 쓴다([문서 전체의 출처](#문서-전체의-출처)). BODY에 Target `0`인 SOURCE가 있으면 invalid다. 다른 문서의 레코드에는 그 문서 안에서 근거를 붙인다.
- Origin은 Reference다. 자리 표지는 `0x0000`(ABSENT)·`0x0001`(UNKNOWN-VALUE)만 받는다. NO-VALUE(`0x0002`)·Value는 받지 않는다.
- geul.org 규격 문서 `0x0000/0x0000000000001020`(이름 `source`)은 Target에 [CODEC](/ko/grammar/edge/codec/) LOCAL(`0008`), Origin에 CODEC `0780`(아무 Reference)·`0000`(ABSENT, 선택)·`0001`(UNKNOWN-VALUE)을 둔다.
- 같은 Target의 SOURCE 사이 순서는 의미가 없다. 출처 하나 안의 항목 순서도 의미가 없다(같은 속성의 값 순서는 문서 순서로 남는다).
- SOURCE는 대상의 참·거짓을 바꾸지 않는다. 대상이 어디서 왔는지 적을 뿐이다. 판정 결과는 [TOULMIN](/ko/grammar/edge/toulmin/) `VERDICT`가 맡는다.

## 문서 전체의 출처

문서 전체의 원천(원본 덤프, 판본, 원문 파일)은 **HEAD에 Target `0`인 SOURCE**로 쓴다. 그 SOURCE를 Target으로 하는 QUALIFIER(원문 해시 P4092, 받은 시각 P813, 원문 범위 등)도 HEAD에 둔다([문서](/ko/grammar/document/#head와-body)).

- HEAD에 둘 수 있는 Edge는 이 둘뿐이다. 그 밖의 Edge는 BODY에 둔다.
- HEAD의 QUALIFIER는 그것이 가리키는 HEAD SOURCE 뒤에 둔다. 디코더가 앞에서부터 읽으며 HEAD와 BODY를 가른다.
- HEAD SOURCE를 Target으로 하는 QUALIFIER를 BODY에 두면 invalid다. BODY의 SOURCE·QUALIFIER는 HEAD의 Edge를 가리키지 않는다.
- **Edge Id는 HEAD와 BODY가 한 번호 공간을 쓴다.** 문서 안에서 유일하고, 다른 Edge처럼 [NEXT-LOCAL-ID](/ko/grammar/meta/lineage/next-local-id/)에서 받으며, 다시 만들 때 같은 내용이면 같은 번호를 이어받는다. HEAD Edge가 빠진 버전에서도 그 번호는 다시 쓰지 않는다.
- Origin이 LOCAL이면 그 정의(REFERENCE-NODE, 원천 TRIPLE)는 BODY에 둔다. LOCAL은 문서 전체가 범위다.
- HEAD Edge는 검증 클래스 Meta가 아니므로 [내용 해시](/ko/grammar/document/#내용-해시)에 들어간다. diff에서는 HEAD와 함께 통째로 바뀐다(`DELTA-REMOVE`에 적지 않는다).
- 문서 전체의 출처를 위한 Meta는 따로 없다. Meta로 적은 원문 범위·확보 시각은 원천이 여럿일 때 어느 원천에 관한 것인지 정할 수 없다. SOURCE에 붙는 QUALIFIER는 Target으로 그것을 정한다.

예: 위키데이터 덤프에서 옮긴 Q42 문서의 HEAD(Edge Id는 설명용).

```
SPEC-VERSION  0x0001
DOC-ID        0x00010000/0x510000000000002a
TRANSFORMED-BY …
#1738 SOURCE     #0     #1735                                         개체 판(revision)
#1741 SOURCE     #0     #1740                                         덤프 파일
#1742 QUALIFIER  P4092  #1741  SHA-256-DIGEST(0xa249…0774)            파일 해시
#1743 QUALIFIER  P813   #1741  POSIX-TIMESTAMP-SECONDS(1792996483)    받은 시각
BODY
#1736 TRIPLE     P577   #1735  POSIX-TIMESTAMP-SECONDS(1792210885) normal                      판 저장 시각
#1737 TRIPLE     P854   #1735  <https://www.wikidata.org/w/index.php?oldid=2557857485> normal  판 영구 주소
#1739 REFERENCE-NODE    #1740  <https://dumps.wikimedia.org/wikidatawiki/entities/20261019/wikidata-20261019-all.json.bz2>
…
```

- 판과 덤프는 다른 원천이라 SOURCE를 둘 둔다. 판은 내용의 원천이고(영구 주소로 같은 내용을 다시 받을 수 있다), 덤프는 그 판을 받은 파일이다. 파일 해시와 받은 시각은 덤프 파일에 관한 인용 쪽 성질이라 덤프 SOURCE에 붙는다.

## 다른 근거의 표현

근거 계열에는 SOURCE만 둔다. 다른 근거는 QUALIFIER로 쓴다.

| 근거 | 쓰는 법 | Property |
|---|---|---|
| 원문 안의 범위 | SOURCE에 QUALIFIER. 범위 하나에 SOURCE 하나 | 쪽 P304, 절 P958, 인용문 P1683. 글자 범위는 GEUL 용어(미정) |
| 원천 자료를 받은 시각 | SOURCE에 QUALIFIER | 조회일 P813 |
| 원문 바이트 해시(판본 고정) | SOURCE에 QUALIFIER | 체크섬 P4092, 값은 [SHA-256-DIGEST](/ko/grammar/value/binary/sha-256-digest/) 등 |
| 만든 주체(사람, 모델, 규칙 엔진) | SOURCE(인용을 만든 주체) 또는 대상에 QUALIFIER | GEUL 용어(미정) |
| 신뢰도 | 대상에 QUALIFIER | GEUL 용어(미정), 값은 Meta [CONFIDENCE](/ko/grammar/meta/verification/confidence/)처럼 0~1 |
| 조문별 시행 기간 | 대상에 QUALIFIER | 시작 P580, 끝 P582 |
| 이동·분할·통합 전의 옛 레코드 | 대상에 QUALIFIER, 값은 옛 Edge Id(LOCAL) | P1365(replaces) |
| 처음 들어온 버전 | 저장하지 않는다. 버전 이력에서 계산한다(git blame) | |

## 예시 (비규범)

Q42 P19(출생지) Q350, 대상 TRIPLE `#178`. 2026-10-19 위키데이터 덤프에서 이 명제의 출처는 다섯이고, 그중 셋을 보인다. ③ 텔레그래프 기사(`#1358`~`#1367`)는 ②와, ⑤ Store norske leksikon(Q746368)은 ①과 같은 꼴이라 뺐다.

```
SOURCE     #1347  #178   Q5375741                     ① 브리태니커: 원천 기술 없이 P248 하나
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"

TRIPLE     #1350  P50    #1349  Q18145749  normal     ② 가디언 기사 #1349
TRIPLE     #1351  P407   #1349  Q1860      normal
TRIPLE     #1352  P577   #1349  GREGORIAN-DATE(2001-05-15)  normal
TRIPLE     #1353  P854   #1349  <http://www.theguardian.com/news/2001/may/15/guardianobituaries.books>  normal
TRIPLE     #1354  P1433  #1349  Q5614018   normal
TRIPLE     #1355  P1476  #1349  "Obituary: Douglas Adams"@en  normal
SOURCE     #1356  #178   #1349
QUALIFIER  #1357  P813   #1356  GREGORIAN-DATE(2013-12-07)

SOURCE     #1368  #178   #1158                        ④ GND: 앞에서 선언한 LOCAL #1158(P248 Q36578, P407 Q188)
QUALIFIER  #1369  P227   #1368  "119033364"
QUALIFIER  #1370  P813   #1368  GREGORIAN-DATE(2022-10-09)
```

- ①은 원천 기술이 없고 P248이 하나라 원천이 그 항목이다. `#1347`은 TAG 1 + Edge Id 2 + Target 2 + Q5375741 3 = 8 WORD, TAG `13A0`.

```
13A0 0088 0543 0088 00B2 0120 0052 06FD
```

- URL 하나뿐인 출처: `REFERENCE-NODE #1383 #1384 <http://www.eskimo.com/~rkj/weekly/aa051701a.htm>`, `SOURCE #1385 #180 #1384`.
- "imported from" 영어 위키백과만 있는 출처: `SOURCE #n #t ABSENT`, `QUALIFIER P143 #n Q328`. Origin `0x0000` 1 WORD.

## 열린 문제

- 글자 범위, 만든 주체, 신뢰도를 나타낼 GEUL 용어(용어 정의 문서와 ID).
- 원천 기술이 원천을 식별하지 못할 때(언어만 있는 출처 등) 같은 기술을 LOCAL 하나로 공유하면 다른 원천을 같다고 단언하게 된다.
- 위키데이터 밖의 출처(법령, 웹 인용)를 위한 원천·인용 속성 목록.
- 출처의 출처(사슬): 원천 LOCAL에 다시 SOURCE를 붙일지.

## 관련 페이지

- [Edge](/ko/grammar/edge/), [TRIPLE](/ko/grammar/edge/triple/), [QUALIFIER](/ko/grammar/edge/qualifier/), [REFERENCE-NODE](/ko/grammar/edge/reference-node/), [자리 표지](/ko/grammar/reference/slot-marker/)
- [문서](/ko/grammar/document/)(HEAD와 BODY), [Meta — 출처](/ko/grammar/meta/provenance/)
