---
title: "공표 주소와 버전 목록"
weight: 85
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "공표한 GEUL 문서는 ID(Issuer, 문서 ID, 버전 ID)에서 정해지는 고정 주소로 서비스되고, 공표처가 서명한 버전 목록으로 검증된다. 이 페이지는 ID 표기, 주소, 형식 지정, 이름 색인, 버전 목록, 신뢰 층을 정한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL은 문자열 URL이 아니라 ID(Issuer, 문서 ID, 버전 ID)로 문서를 가리킨다. 주소는 ID에서 정해진다. 이 페이지는 인코더·디코더·해석기가 서로 맞물려 동작하는 데 필요한 공표 규칙을 정한다. Issuer 등급과 공개 방식은 [Issuer와 공표](/ko/grammar/issuer/)가 정한다.

## ID 표기

주소에 쓰는 ID는 hex로 쓴다.

- 접두어는 소문자 `0x`, hex 숫자도 소문자다.
- 자릿수는 폭 × 4로 고정한다. 앞의 0을 생략하지 않으며, 자릿수가 곧 폭이다.
- Issuer ID는 값이 들어가는 가장 짧은 폭으로 쓴다. `0x00000005` 같은 넓힌 표기는 없다(`0x0005`).

| 대상 | 폭 | 자릿수 | 예 |
|---|---|---|---|
| Issuer | 1 WORD | 4 | `0x0001` |
| Issuer | 2 WORD | 8 | `0x00010000` |
| Issuer | 4 WORD | 16 | `0x0000000100000000` |
| Issuer | 16 WORD | 64 | `0x` + 64자리 |
| 문서 ID | 4 WORD | 16 | `0x0000000000000000` |
| 버전 ID | 2 WORD | 8 | `0x00000003` |
| 내용 해시 | 16 WORD | 64 | `0x` + 64자리 |

- 정규형이 아닌 요청(`0X`, 대문자, 0 생략)은 정규형 주소로 `301` 리다이렉트한다. 캐시 키와 서명 대상이 하나로 정해진다.
- 버전 ID의 규칙(1부터, `0`은 최신, 공표처 배정, 다 쓰면 새 문서 ID)은 [문서](/ko/grammar/document/#버전)가 정한다.

## 공표 주소

```
/.well-known/geul/<Issuer>/<문서 ID>.geul              최신 버전. 302로 정본 주소에 보낸다 (가변)
/.well-known/geul/<Issuer>/<문서 ID>/<버전 ID>.geul    문서 한 벌 (불변, 정본 주소)
/.well-known/geul/<Issuer>/<문서 ID>/versions.geul     버전 목록 문서 (가변, 서명)
/.well-known/geul/h/<내용 해시>.geul                   내용 해시로 조회 (불변)
```

예: `/.well-known/geul/0x0001/0x0000000000000000.geul`

- 경로는 RFC 8615의 `.well-known`을 따른다. geul.org와 사설 공표가 같은 경로를 쓰고 도메인만 다르다. 등록할 접미사는 `geul` 하나다.
- 문서 내용은 불변 주소에서만 나간다. 최신 버전 주소는 내용을 주지 않고 `302`로 그 버전의 정본 주소에 보낸다.
- 한 버전의 정본 주소는 `/<Issuer>/<문서 ID>/<버전 ID>.geul`이다. 같은 내용을 주는 다른 주소는 `Link: rel=canonical`로 정본 주소를 가리킨다.
- 불변 주소는 영구 캐시와 CDN에 둘 수 있다. 받은 쪽은 버전 목록(또는 잠금 기록)의 내용 해시로 검증한다.
- ID는 항상 `0x`로 시작한다. 그래서 예약 이름(`h`, `keys`, `issuers.geul`, `documents.geul`, `versions.geul`)이나 사람이 붙인 이름은 `add`, `cafe`처럼 hex로만 된 단어여도 ID와 겹치지 않는다.
- 위치(어느 서버에서 받는지)는 문서 내용에 넣지 않는다. 넣으면 주소가 바뀔 때 내용 해시가 바뀐다. 위치는 문서를 받는 쪽의 설정이 정한다.

### 형식 지정

- 확장자가 있으면 형식을 지정한 것이다. `.geul`은 바이너리(`application/vnd.geul`)다.
- 확장자가 없으면 `Accept` 헤더를 따른다. 브라우저에는 HTML 보기를, 도구에는 바이너리를 준다. 예: `/<Issuer>/<문서 ID>/<버전 ID>`
- 문서는 바이너리가 정본이다. 내용 해시와 서명은 바이너리로만 계산한다.

### 도메인 이름

도메인 소유 증명을 거친 Issuer는 주소의 `<Issuer>` 자리에 ID 대신 그 도메인을 쓸 수 있다.

```
/.well-known/geul/<도메인>/<문서 ID>.geul              → 302 → /<Issuer>/<문서 ID>.geul
/.well-known/geul/<도메인>/<문서 ID>/<버전 ID>.geul    → 302 → /<Issuer>/<문서 ID>/<버전 ID>.geul
/.well-known/geul/<도메인>/<문서 ID>/                  → 302 → /<Issuer>/<문서 ID>/
```

예: `/.well-known/geul/geul.org/0x0000000000001018/0x00000001.geul`

- 도메인 주소는 내용을 주지 않고 `302`로 ID 주소에 보낸다. 정본 주소, 캐시 키, 서명 대상은 ID 주소다. 대응이 바뀔 수 있으므로 영구 리다이렉트를 쓰지 않는다.
- 도메인은 소문자로 쓰고, 국제화 도메인은 IDNA(punycode) 형태로 쓴다. 끝의 `.`은 붙이지 않는다. 정규형이 아니면 정규형으로 `301` 리다이렉트한다.
- 도메인에는 `.`이 있으므로 `0x`로 시작하는 ID나 예약 이름과 겹치지 않는다.
- 해석기는 도메인 주소를 받으면 Issuer 이름 색인으로 대응을 확인하고 ID로 바꿔 잠금 기록에 남긴다.
- 등록부가 없는 16 WORD Issuer와 geul.org에 닿지 못하는 망분리 환경은 도메인 이름을 쓰지 못한다. ID 주소를 쓴다.

### Issuer 이름

Issuer 이름 색인은 `/.well-known/geul/issuers.geul` 한 문서다.

```
BODY
  BIND   Subject = ISSUER-POINTER(Issuer)   이름 = "geul.org"
  …
```

- Subject는 [ISSUER-POINTER](/ko/grammar/reference/issuer-pointer/)(Issuer 자신)이고 이름은 [BIND](/ko/grammar/edge/bind/)로 묶는다.
- 이름은 도메인 소유 증명을 거친 도메인이다. 소문자이며 국제화 도메인은 IDNA(punycode)로 쓴다. 이름 하나는 Issuer 하나에만 묶인다.
- 사람이 읽는 Issuer 표시 이름(언어별)은 같은 Subject에 서술 [LABEL](/ko/grammar/edge/label/)로 붙인다.
- geul.org(GEUL Issuer)가 서명하고, 바뀌면 덧붙이며 고치지 않는다(버전 목록과 같은 사슬 규칙).
- 예약 이름 `issuers.geul`은 `.`이 있어 도메인 모양이다. 같은 이름의 도메인이 생겨도 이 경로는 Issuer 이름 색인으로 남는다.

### 문서 이름

문서 ID 대신 문서 이름으로도 주소를 쓸 수 있다. `<Issuer>` 자리에는 ID나 도메인 이름을 쓴다.

```
/.well-known/geul/<Issuer|도메인>/<문서 이름>.geul              → 302 → /<Issuer>/<문서 ID>.geul
/.well-known/geul/<Issuer|도메인>/<문서 이름>/<버전 ID>.geul    → 302 → /<Issuer>/<문서 ID>/<버전 ID>.geul
/.well-known/geul/<Issuer|도메인>/<문서 이름>/                  → 302 → /<Issuer>/<문서 ID>/
```

예: `/.well-known/geul/geul.org/publication/0x00000001.geul` → `/0x0000/0x0000000000001018/0x00000001.geul`

**문서 이름은 Issuer의 이름 색인 `/<Issuer>/documents.geul`이 BIND로 묶는다.** 해석기는 이름을 이 색인으로 문서 ID에 대응시킨다.

```
BODY
  BIND   Subject = DOC-POINTER(Issuer, 문서 ID, 버전 0)   이름 = "publication"
  …
```

- Subject는 [DOC-POINTER](/ko/grammar/reference/doc-pointer/)(Issuer, 문서 ID, 버전 `0`)다. 이름은 버전이 아니라 문서에 묶인다.
- Subject의 Issuer는 색인을 둔 Issuer와 같아야 한다. 다른 Issuer의 문서는 무시한다.
- 이름은 공표된 문서에만 묶는다.
- 문서 이름은 소문자 ASCII 슬러그다: `a-z`, `0-9`, `-`. 처음과 끝은 `-`가 아니고 `0x`로 시작하지 않는다. 그래서 문서 ID(`0x…`)나 예약 이름(`h`, `versions.geul` 등)과 겹치지 않는다([BIND](/ko/grammar/edge/bind/)).
- 한 Issuer 안에서 이름 하나는 문서 하나에만 묶이고, 한 번 묶은 이름은 다른 문서에 다시 쓰지 않는다. 이름을 바꾸면 새 BIND를 덧붙인다. 옛 이름은 같은 문서로 계속 보낸다. 같은 이름이 여러 번 나오면 마지막 BIND가 대표다.
- 문서 안에는 자기 이름을 적지 않는다. 정본 주소, 캐시 키, 서명 대상은 ID 주소다. IMPORT와 문서 안의 인용은 ID로만 한다.
- 사람이 읽는 제목(언어별)은 이름이 아니다. 서술 `LABEL`로 붙인다.
- 버전 목록 문서에도 같은 문서 이름 BIND를 둘 수 있다([PUBLICATION](/ko/grammar/edge/publication/#문서-이름)). 두면 이름 색인과 같아야 한다. 해석기는 이름 색인만 읽는다.

### 삭제된 문서

- 법적 삭제·직권 삭제된 버전의 주소는 `410 Gone`과 묘비(버전 ID, 내용 해시, 삭제 일자, 사유 범주)를 돌려준다.
- 버전 목록에는 [TOMBSTONE](/ko/grammar/edge/publication/) 레코드로 남는다.

## 층

GEUL은 출처·메타·목록까지 GEUL 문서로 표현한다. 그것을 읽는 데 필요한 최소한은 디코더에 내장해 순환을 끊는다. 각 층은 아래 층에만 기댄다.

| 층 | 내용 | 기대는 것 |
|---|---|---|
| 0층 | 디코더 내장 규칙: 프레이밍, 내용 해시, 서명 검증, 버전 목록 레코드 Codec(`PUBLICATION`·`DEPRECATION`·`TOMBSTONE`), Codec 규격 어휘(`DECLARE`·`FIELD`·`ENUM`·`CODEC`), [자리 표지](/ko/grammar/reference/slot-marker/)(`0x0000`~`0x0002`), 문서 밖에서 받는 신뢰 키 | 없음. 조회하지 않는다 |
| 1층 | 버전 목록 문서 | 0층 |
| 2층 | 일반 문서, 코덱북, Codec 규격 문서, Issuer 검증키 문서 | 1층으로 찾고 0층으로 검증한다 |

- 어느 층도 자기 층이나 위 층에 기대지 않는다.
- GEUL로 표현하는 것과 GEUL로 해석해야만 읽히는 것을 구분한다. 0층은 GEUL로 표현할 수는 있어도 해석에 조회가 필요하지 않다.
- 판정의 의미처럼 TOULMIN 문서로 바꿀 수 없는 고정 핵심도 이 자리에 둔다([TOULMIN](/ko/grammar/edge/toulmin/#메타-인지와-자기-개정)).

## 버전 목록

공표처는 문서마다 버전 목록 문서 하나를 이어 쓴다(`/<Issuer>/<문서 ID>/versions.geul`). 레코드 형식과 문서 구조는 [PUBLICATION](/ko/grammar/edge/publication/)이 정한다.

```
DOC-*
  SPEC-VERSION
  PARENT          직전 목록 문서의 내용 해시
  RECORDED-AT     이 목록을 낸 시각
  NEXT-LOCAL-ID   다음에 배정할 LOCAL ID
  SIGNATURE       공표처의 서명
BODY
  PUBLICATION     #1  문서@1  내용 해시
  PUBLICATION     #2  문서@2  내용 해시
  DEPRECATION     #3  문서@1
  …
END
```

| Edge | 뜻 |
|---|---|
| PUBLICATION | 문서의 한 버전과 그 내용 해시를 공표한다 |
| DEPRECATION | 공표한 버전에 사용 중단 권고를 표시한다. 계속 해석된다 |
| TOMBSTONE | 공표한 버전을 삭제한다(법적·직권 삭제). 사유 범주를 적는다 |

- 레코드는 추가만 한다. 고치거나 지우거나 순서를 바꾸지 않는다. deprecate·삭제도 레코드를 덧붙인다. 새 목록은 직전 목록의 BODY를 그대로 앞에 두고 레코드를 덧붙이며, 목록끼리 `PARENT` 해시 사슬로 이어진다.
- 공표 기록을 고치지 않는다는 뜻이며, 문서 내용의 개정([문서](/ko/grammar/document/#개정))과는 다르다. 버전의 현재 상태는 레코드를 차례로 적용해 계산한다.
- 버전 ID는 1부터 빠짐없이 오름차순이다. 같은 내용을 다시 공표하지 않는다.
- 최신 버전은 폐기 권고도 삭제도 아닌 가장 높은 버전이다.
- 레코드에는 시각을 넣지 않는다. 그 레코드가 처음 실린 목록의 `RECORDED-AT`이 공표 시각이다.
- 목록 문서에는 `DOC-ID`를 두지 않는다. 레코드의 문서 ID가 무엇의 목록인지 말한다.
- 목록 문서는 IMPORT를 두지 않고, 0층 Codec만 쓴다.
- 목록 문서는 다른 목록에 올리지 않는다(목록의 목록 없음). 지난 목록은 내용 해시(`h/<내용 해시>.geul`)로만 가리키고, 이력은 `PARENT` 사슬로 잇는다.
- 가변인 주소는 최신 목록 주소(`/<Issuer>/<문서 ID>/versions.geul`) 하나다. 가변 포인터는 문서로 만들 수 없으므로, 받은 목록의 서명·`RECORDED-AT`·`PARENT`로 검증한다.

### 서명 주체

| 서명 | 주체 | 대상 |
|---|---|---|
| 문서 서명 | 그 문서의 Issuer | 문서의 내용 해시 ([Issuer와 공표](/ko/grammar/issuer/#서명)) |
| 목록 서명 | 버전 ID를 배정한 공표처 | 목록 문서의 내용 해시 |

- geul.org 공표는 geul.org(GEUL Issuer)가, 사설 공표는 그 Issuer가 버전 ID를 배정하고 목록에 서명한다.
- 저자는 내용을, 공표처는 번호와 순서를 책임진다.

### 검증

- 서명은 내용 해시에서 빠지므로 지워도 해시가 그대로다. 그래서 "서명이 있으면 확인한다"가 아니라 "정해진 키의 서명이 있어야 한다"로 검증한다. 요구할 키는 해석기의 신뢰 설정과 잠금 기록이 정한다.
- 해석기는 마지막으로 본 목록의 내용 해시를 잠금 기록에 남긴다. 새로 받은 목록의 `PARENT` 사슬에 그 해시가 없으면 거부한다(되감기·분기 방지).
- 미러와 망분리 환경은 목록 문서 사슬을 함께 복사한다. 공개키만 있으면 오프라인에서 검증된다.
- 받은 문서는 어느 출처에서 왔든 내용 해시로 검증한다. 출처를 신뢰할 필요가 없다.

## 의존성 해석

- 문서는 HEAD의 [IMPORT-DOC](/ko/grammar/meta/import/import-doc/)으로 의존 문서를 적는다.
- 새 버전은 이전 버전과의 호환을 약속하지 않는다. 그래서 그래프 전체에서 한 문서의 버전을 하나로 합치지 않는다(최소 버전 선택을 쓰지 않는다).
- 각 `IMPORT-DOC`은 자기가 고정한 판본에 바인딩된다. 같은 문서의 여러 판본이 한 그래프에 함께 있을 수 있다(구법을 인용한 판결과 현행법을 인용한 판결). 참조는 (문서, 버전, LOCAL ID)로 푼다.
- 최신(버전 `0`) 가져오기는 해석 시점의 최신 판본에 바인딩된다. 시점을 정해 해석하면 그 시점에 시행 중인 판본에 바인딩된다([문서](/ko/grammar/document/#개정)).
- 버전 ID로 고정한 가져오기는 재현된다(버전 ID의 내용은 불변이고 잠금 기록으로 검증한다).

## 미디어 타입

- GEUL 문서의 미디어 타입은 `application/vnd.geul`이다. 확장자는 `.geul`이다.
- 표준 트리 `application/geul`로 옮기더라도 `application/vnd.geul`을 계속 받는다.

## 열린 문제

- 1·2·4·16 WORD Issuer 문서 중 어디까지 geul.org가 직접 서비스하고 어디부터 등록부의 주소로 보낼지. 그때의 상태 코드(정본 308, 최신 302·307).
- 사설 공표·16 WORD Issuer·망분리 환경에서 버전 ID가 갈라질 때(같은 버전 ID, 다른 내용)의 처리.
- 텍스트 표현의 정의와 콘텐츠 협상(`Accept`에 따라 바이너리, 텍스트, HTML 보기).
- 문서 이름 색인 `documents.geul`과 버전 목록 BIND의 관계(하나로 합칠지), 색인의 서명.
- `issuers.geul`의 HEAD 구성과 서명·사슬 형식. 도메인이 없는 Issuer(1·4 WORD)의 이름 규칙, 이름 분쟁 처리와 길이 상한.
- 1 WORD Issuer도 도메인 증명을 선택적으로 거쳐 도메인 이름을 쓸 수 있게 할지.
- 목록이 커질 때 전체 사슬 대신 Merkle 로그(포함·일관성 증명)로 옮기는 시점과 형식.
- 위치 제공 Issuer를 HEAD에 적는 Meta.
