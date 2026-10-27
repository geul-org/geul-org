---
title: "문서"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "document", "version", "hash"]
summary: "GEUL 데이터의 단위는 문서다. 문서는 길이를 지정해 열고 END로 닫으며, HEAD(Meta와 문서 전체의 출처)와 BODY(Reference·Value·Edge)로 나뉜다. 버전마다 내용 해시로 고정된다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL 데이터의 단위는 문서(DOC) 하나다. 파일 하나(`.geul`, 미디어 타입 `application/vnd.geul`)가 문서 하나다.

## 구조

```
DOC-*            ← 문서를 연다 (전체 길이)
  Meta …         ← HEAD: 문서에 관한 레코드
  SOURCE …       ←   (문서 전체의 출처와 그 QUALIFIER)
BODY             ← HEAD를 끝내고 BODY를 연다
  Reference, Value, Edge …
END              ← 문서를 닫는다
```

| 레코드 | TAG | 뜻 |
|---|---|---|
| DOC-1WORD | `1880` + 1 WORD | 전체 길이를 1 WORD로 지정해 문서를 연다 |
| DOC-2WORD | `1901` + 2 WORD | 전체 길이를 2 WORD로 |
| DOC-4WORD | `1A02` + 4 WORD | 전체 길이를 4 WORD로 |
| BODY | `180E` | 1 WORD. HEAD를 끝내고 BODY를 시작한다 |
| END | `180F` | 1 WORD. 문서를 닫는다 |

- DOC-*의 값은 여는 레코드의 시작부터 END의 끝까지 전체 WORD 수다. 값이 들어가는 가장 좁은 폭을 쓴다.
- END는 필수다. END의 위치가 DOC-*의 길이와 맞지 않으면 거부한다. END 없이 입력이 끝나면 잘린 문서다.
- 디코더는 DOC-*의 길이로 문서 전체를 한 번에 건너뛸 수 있다.
- 길이를 모르는 채로 여는 방법은 없다. 끝을 미리 알 수 없는 실시간 데이터는 길이를 아는 단위로 끊어 문서 여러 개로 보낸다.
- HEAD가 비어 있으면 BODY를 생략한다. BODY 레코드가 없는 문서는 전부 BODY다. BODY는 한 번만 둔다. HEAD에 레코드(Meta 또는 HEAD Edge)가 하나라도 있으면 BODY를 둔다.
- 문서는 중첩하지 않는다. 다른 문서는 [IMPORT](/ko/grammar/meta/)나 지시 Reference로 가리킨다.

## HEAD와 BODY

- HEAD에는 Meta와 **HEAD Edge** 둘만 둔다. 모두 그것을 담은 **문서**에 대한 서술이다.
  - Meta: 문서의 구조·정의·출처·계보·검증·정책·IMPORT.
  - HEAD Edge: 문서 전체의 원천을 적는 근거 Edge [SOURCE](/ko/grammar/edge/source/#문서-전체의-출처)(Target `0`), 그리고 그 SOURCE를 Target으로 하는 [QUALIFIER](/ko/grammar/edge/qualifier/)(원문 해시, 받은 시각, 원문 범위 등). QUALIFIER는 그 SOURCE 뒤에 둔다.
- BODY에는 Reference, Value, Edge만 둔다. 개별 레코드의 출처는 BODY 안의 근거 Edge [SOURCE](/ko/grammar/edge/source/)로, 신뢰도 같은 다른 근거는 그 레코드에 붙는 QUALIFIER로 쓴다. Target `0`인 SOURCE와 HEAD SOURCE를 Target으로 하는 QUALIFIER는 BODY에 둘 수 없다.
- 디코더는 HEAD를 앞에서부터 읽으며 가른다. Meta는 HEAD다. Target `0`인 SOURCE는 HEAD이고 그 Edge Id를 기억한다. 기억한 SOURCE를 Target으로 하는 QUALIFIER는 HEAD다. 그 밖의 레코드가 오면, HEAD가 비어 있으면 BODY가 생략된 것이고(그 레코드부터 BODY), 아니면 BODY 누락으로 invalid다.
- **Edge Id는 HEAD와 BODY가 한 번호 공간을 쓴다.** 문서 안에서 유일하고, BODY의 Edge처럼 [NEXT-LOCAL-ID](/ko/grammar/meta/lineage/next-local-id/)에서 받는다. HEAD Edge의 Origin이 LOCAL이면 그 정의는 BODY에 둔다(LOCAL은 문서 전체가 범위).
- Meta는 Payload 안에 Value 레코드를 품을 수 있다. 품은 Value는 독립 레코드가 아니라 그 Meta의 일부다.
- 선언(Meta 정의 클래스)의 범위는 그 문서다.

## 기본 선언

두 선언은 모두 많아야 하나다. 어느 문서에 반드시 있어야 하는지는 아래 조건이 정한다.

| Meta | 뜻 | 있어야 하는 문서 |
|---|---|---|
| [SPEC-VERSION](/ko/grammar/meta/declaration/spec-version/) | 따르는 명세 판. 나머지 레코드를 어떻게 읽을지 정한다. 모르는 판이면 거부하거나 경고한다. v1 문서의 값은 `0x0001`이다 | 공표 문서. 없으면 디코더가 아는 판으로 읽는다 |
| [DOC-ID](/ko/grammar/meta/declaration/doc-id/) | 문서 자신의 식별자. 문서 밖에서 이 문서와 그 안의 대상을 가리키려면 있어야 한다 | `.well-known/geul/` 아래 이름이 `0x`로 시작하는 문서(버전 문서, 규격 문서). 버전 목록·이름 색인에는 두지 않는다 |

- `SPEC-VERSION`은 어느 판의 디코더든 읽을 수 있게 정수 하나만 담는다(v1은 `1890 0001`). Value 코드에 기대지 않는다.
- `DOC-ID`는 자기 자신을 가리키는 DOC-POINTER(Issuer, 문서 ID, 버전 `0`)다. 문서 ID는 4 WORD다.
- `DOC-ID`가 없는 문서는 이름 없는 문서다. 내용 해시로만 가리킬 수 있다.

## 내용 해시

문서 한 벌은 **내용 해시**로 가리킨다(git의 커밋 ID와 같은 역할).

- 여는 레코드(DOC-*)부터 END 직전까지의 SHA-256이다. 16 WORD.
- 검증 클래스 Meta(서명 등)는 계산에서 뺀다. 그래서 서명을 문서 안에 둬도 순환이 생기지 않는다.
- 계산할 때 DOC-*의 길이는 검증 레코드를 뺀 길이로 바꾸고, 폭도 그 길이에 맞는 가장 좁은 폭으로 바꾼다. 그래서 서명을 붙이기 전과 후의 내용 해시가 같다.
- 내용 해시는 문서에 기록하지 않고 계산한다. 다른 버전을 가리킬 때만 값으로 적는다(`PARENT` 등).
- 문서 안의 `PARENT`도 계산에 들어가므로 내용 해시는 이력 전체를 잇는 해시 사슬이 된다.
- 문서 밖에서 나중에 붙인 Meta(별도 저장소의 주석 등)는 내용 해시를 바꾸지 않는다(git notes와 같다).
- 문서는 바이너리가 정본이다. 내용 해시와 서명은 바이너리로만 계산한다.

## 버전

이름 있는 문서(`DOC-ID`가 있는 문서)는 버전을 가진다.

- **버전 ID**는 문서 하나 안에서 공표 순서대로 1부터 매기는 2 WORD 정수다. `0`은 "버전을 적지 않음"이며 최신 버전으로 다룬다.
- 버전 ID는 공표처가 공표할 때 배정한다. 버전 ID와 내용 해시의 대응은 공표처가 서명한 버전 목록에 둔다([공표 주소와 버전 목록](/ko/grammar/publishing/#버전-목록)).
- 같은 내용을 다시 공표하지 않는다. 이미 있는 내용 해시면 그 버전 ID를 돌려준다.
- 2 WORD를 다 쓰면 새 문서 ID로 낸다.
- v2 이후 버전은 HEAD에 `PARENT`(직전 버전의 내용 해시)를 적는다. 내용 해시에 들어가므로 버전들이 해시 사슬로 이어진다. 최초 버전에는 두지 않는다.

## 개정

GEUL 문서는 법령처럼 개정된다.

- **버전은 불변이다.** 공표한 버전은 바꾸거나 지우지 않는다. 예외는 법적 삭제와 직권 삭제뿐이다([TOMBSTONE](/ko/grammar/edge/publication/)).
- 이력은 지우지 않는다. 고친 내용은 새 버전으로 내고, 원 버전을 덮어쓰지 않는다(구법 보존). 고쳐 쓴 버전은 [REPLACES](/ko/grammar/meta/lineage/replaces/)로 원 버전을 잇는다.
- branch, HEAD, reflog처럼 바뀌는 포인터는 문서에 두지 않는다. 문서 밖(저장소·인덱스)에서 관리한다.
- 새 버전은 정의를 신설·개정·삭제할 수 있다. 이전 버전과의 호환을 약속하지 않는다. 같은 용어의 정의가 바뀌는 것도 개정이다(예: 민법 "성년" 20세 → 19세, 형법 강간죄 객체 "부녀" → "사람").
- **LOCAL ID는 버전을 넘는 정체성이다**(조문 번호처럼). 같은 LOCAL ID는 버전이 달라도 같은 대상을 가리킨다.
  - 신설: 새 LOCAL ID를 받는다. ID에는 순서 의미가 없으므로 "제X조의2" 같은 끼워 넣기가 필요 없다. 새 번호는 버전 목록의 `NEXT-LOCAL-ID`에서 받는다(auto increment).
  - 개정: 같은 LOCAL ID의 내용을 바꾼다.
  - 삭제: 그 LOCAL ID를 새 버전에서 뺀다. **삭제한 ID는 다시 쓰지 않는다.**
  - 이동·분할·통합: 새 LOCAL ID를 받고, 새 레코드에 QUALIFIER P1365(replaces, 값은 옛 LOCAL ID)를 붙여 옛 ID를 잇는다. 옛 ID는 다시 쓰지 않으므로 이전 버전의 그 레코드를 가리킨다.
- 원천 자료에서 문서를 다시 만드는 도구도 이 규칙을 지킨다. 직전 버전과 같은 서술에는 같은 LOCAL ID를 주고, 바뀌거나 새로 생긴 서술에만 새 번호를 준다. 번호를 매번 1부터 다시 매기면 안 된다.
- 인용은 판본을 특정한다. 버전을 고정한 인용은 그 버전에, 최신(버전 `0`) 인용은 해석 시점의 현행 버전에 묶인다. 과거 사건을 다루는 문서는 그 시점에 시행 중이던 버전을 고정해 인용한다.
- 공표와 시행은 다르다. 공표 시각은 버전 목록이, 시행 기간은 문서가 적는다.
  - [EFFECTIVE-FROM](/ko/grammar/meta/declaration/effective-from/)·[EFFECTIVE-UNTIL](/ko/grammar/meta/declaration/effective-until/): 버전 전체의 시행 기간
  - 조문 Edge의 QUALIFIER P580(시작)·P582(끝): 조문별로 시행일이 다를 때
- **시점 T에 시행 중인 판본은 시행일이 T 이하인 가장 높은 버전이다.** 조문별 P580·P582 QUALIFIER가 있으면 그것이 우선한다. 유효기간(`EFFECTIVE-UNTIL`)이 지난 판본은 시행 중이 아니다.
- 경과규정("종전의 규정에 따른다"), 행위시법과 피고인에게 유리한 신법의 선택처럼 어느 판본을 적용할지 정하는 규칙은 판정([TOULMIN](/ko/grammar/edge/toulmin/))이 맡는다. 시행 정보는 그 재료다.
- 해석례·판례가 용어의 해석을 좁히거나 넓히는 것은 문서 개정이 아니라 판정 규칙이다. 해석을 입법으로 정한 경우(예: 근로기준법 "1주" 정의 신설)는 개정이다.
- Codec과 형식 번호의 바이너리(wire) 레이아웃은 개정하지 않는다. 형식 번호로 인코딩된 레코드는 코덱북 버전을 고정하지 않고 읽히기 때문이다. 레이아웃을 바꾸려면 새 번호를 배정한다. 삭제한 형식 번호는 다른 형식에 다시 쓰지 않는다.

## diff 저장

버전은 언제나 문서 전체(스냅숏)로 정의한다. diff는 그 스냅숏을 적게 저장·전송하는 형식일 뿐이다.

- `DOC-ID`가 있고 BODY가 모두 Edge인 문서만 diff로 둘 수 있다. 버전 관리를 하지 않는 `versions.geul`·`documents.geul`·`issuers.geul`과 이름 없는 문서는 diff를 두지 않는다.
- diff 문서는 일반 GEUL 문서이고, HEAD에 [DELTA-BASE](/ko/grammar/meta/lineage/delta-base/)(기준 버전 ID)를 둔다.
- 삭제는 [DELTA-REMOVE](/ko/grammar/meta/lineage/delta-remove/)(빼는 LOCAL ID 목록)로, 추가와 개정은 BODY의 Edge로 적는다. 추가·개정 표지는 따로 없다. Edge Id가 기준에 있으면 개정, 없으면 추가다.
- 스냅숏 복원은 결정적이어야 한다(그래야 해시가 맞는다).
  1. 기준 버전의 스냅숏을 복원한다. 기준도 diff면 재귀로 복원한다.
  2. HEAD는 diff의 HEAD에서 `DELTA-BASE`·`DELTA-REMOVE`를 뺀 것으로 통째로 바꾼다. HEAD Edge도 함께 바뀐다(`DELTA-REMOVE`에 적지 않는다).
  3. BODY는 기준 순서를 유지한다. `DELTA-REMOVE`의 ID는 빼고, diff BODY의 Edge Id가 기준에 있으면 그 자리에서 바꾼다.
  4. 기준에 없는 Edge Id는 diff에 나온 순서대로 끝에 붙인다.
  5. 결과의 내용 해시가 버전 목록의 이 버전 해시와 같아야 한다. 다르면 invalid다.
- 삭제한 LOCAL ID를 diff에서 다시 쓰면 invalid다. 빠진 HEAD Edge의 Edge Id도 다시 쓰지 않는다.
- 내용 해시, 버전 목록, 서명은 모두 복원한 스냅숏 기준이다.
