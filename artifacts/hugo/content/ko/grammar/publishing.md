---
title: "공표 주소와 버전 목록"
weight: 85
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "공표한 GEUL 문서는 ID(Issuer, 문서 ID, 버전 ID)에서 정해지는 고정 주소로 서비스되고, 공표처가 서명한 버전 목록으로 검증된다. 이 페이지는 ID 표기, 주소, 형식 지정, Issuer 목록과 이름, 버전 목록, 신뢰 층을 정한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL은 문자열 URL이 아니라 ID(Issuer, 문서 ID, 버전 ID)로 문서를 가리킨다. 주소는 ID에서 정해진다. 이 페이지는 인코더·디코더·해석기가 서로 맞물려 동작하는 데 필요한 공표 규칙을 정한다. Issuer 등급과 공개 방식은 [Issuer와 공표](/ko/grammar/issuer/)가 정한다.

## ID 표기

주소에 쓰는 ID는 hex로 쓴다.

- 접두어는 소문자 `0x`, hex 숫자도 소문자다.
- 자릿수는 폭 × 4로 고정한다. 앞의 0을 생략하지 않으며, 자릿수가 곧 폭이다.
- 주소를 쓸 때 Issuer는 발급 폭의 자릿수로 쓴다: 2 WORD 8자리, 4 WORD 16자리, 16 WORD 64자리.
- 읽을 때 Issuer는 8자리, 16자리, 64자리 모두 받는다. 짧은 Issuer ID에 앞 0을 붙인 긴 표기는 같은 Issuer로 찾는다(`0x00000001`과 `0x0000000000000001`은 같은 Issuer다, [Issuer와 공표](/ko/grammar/issuer/#issuer-등급)).

| 대상 | 폭 | 자릿수 | 예 |
|---|---|---|---|
| Issuer | 2 WORD | 8 | `0x00000001` |
| Issuer | 4 WORD | 16 | `0x0000000100000000` |
| Issuer | 16 WORD | 64 | `0x` + 64자리 |
| 코덱 ID | 2 WORD | 8 | `0x00000aa0` |
| 문서 ID | 4 WORD | 16 | `0x0000000000000000` |
| 버전 ID | 2 WORD | 8 | `0x00000003` |
| 내용 해시 | 16 WORD | 64 | `0x` + 64자리 |

- GEUL 직접 코드의 코덱 ID는 그 TAG WORD(L=0)를 32비트로 쓴 값이다(TRIPLE `0x0AAL` → `0x00000aa0`). Kind가 TAG에 들어 있어 겹치지 않는다.
- 다른 Issuer의 ISSUER 형식 코덱은 그 Issuer의 `codecs/` 아래에 레코드의 코덱 번호로 둔다. 예: IETF CRC32C는 `0x00000007/codecs/0x0000c000/`.
- Issuer 코덱의 코덱 ID는 레코드의 코덱 번호(2 WORD)다. Issuer는 Kind(Reference, Value, Edge)와 상관없이 자기 `<Issuer>/codecs/` 안에서 코덱 번호가 겹치지 않게 배정한다. 주소는 Kind로 나누지 않는다(`references/`, `values/`, `edges/` 같은 폴더는 없다).
- 해석기는 레코드의 Kind와 그 코덱 문서 [DECLARE](/ko/grammar/edge/declare/) 대상의 Kind가 다르면 오류로 본다.
- 공표는 같은 코덱 ID에 다른 코덱을 올리는 것을 거부한다.
- 버전 ID의 규칙(1부터, `0`은 최신, 공표처 배정, 다 쓰면 새 문서 ID)은 [문서](/ko/grammar/document/#버전)가 정한다.

## 공표 주소

```
/.well-known/geul/issuers/latest.geul                              Issuer 목록 최신
/.well-known/geul/issuers/<버전 ID>.geul                           Issuer 목록 버전 지정
/.well-known/geul/issuers/versions.geul                            Issuer 목록 버전 목록
/.well-known/geul/<Issuer>/codecs/<코덱 ID>/latest.geul            코덱 최신
/.well-known/geul/<Issuer>/codecs/<코덱 ID>/<버전 ID>.geul         코덱 버전 지정
/.well-known/geul/<Issuer>/codecs/<코덱 ID>/versions.geul          코덱 버전 목록
/.well-known/geul/<Issuer>/docs/<문서 ID>/latest.geul              문서 최신
/.well-known/geul/<Issuer>/docs/<문서 ID>/<버전 ID>.geul           문서 버전 지정
/.well-known/geul/<Issuer>/docs/<문서 ID>/versions.geul            문서 버전 목록
/.well-known/geul/<Issuer>/hashes/<내용 해시>.geul                  내용 해시로 조회
```

예: `/.well-known/geul/0x00000002/docs/0x0000000000000000/latest.geul`

- 경로는 RFC 8615의 `.well-known`을 따른다. geul.org와 사설 공표가 같은 경로를 쓰고 도메인만 다르다. 등록할 접미사는 `geul` 하나다.
- Issuer 목록은 `issuers/`다. 코덱, 일반 문서, 해시는 Issuer 폴더 아래 `codecs/<코덱 ID>/`, `docs/<문서 ID>/`, `hashes/`로 갈린다. Issuer 목록도 버전 1부터이고 `versions.geul`을 둔다([목록 문서](#목록-문서)).
- `latest.geul`은 예약어이고 별칭이다. 저장하지 않는다. 같은 자리의 `versions.geul`에서 가장 최근 버전을 찾아 그 버전의 바이트를 그대로 낸다. 리다이렉트하지 않는다. Issuer 목록, 코덱, 문서의 모든 `latest.geul`이 같다.
- 한 버전의 정본 주소는 `/<Issuer>/docs/<문서 ID>/<버전 ID>.geul`이다. 코덱은 `/<Issuer>/codecs/<코덱 ID>/<버전 ID>.geul`이다. 같은 내용을 주는 다른 주소는 `Link: rel=canonical`로 정본 주소를 가리킨다.
- 버전 지정 주소와 내용 해시 주소는 불변이다. 불변 주소는 영구 캐시와 CDN에 둘 수 있다. 받은 쪽은 버전 목록(또는 잠금 기록)의 내용 해시로 검증한다.
- 내용 해시로 찾으려면 Issuer를 알아야 한다. 해시만으로 찾는 전역 조회는 없다.
- 코덱 문서는 문서 ID가 없다. [CODEC-POINTER](/ko/grammar/reference/codec-pointer/)(Issuer, 코덱 ID, 버전 ID)로 자기와 버전을 가리킨다.
- ID는 항상 `0x`로 시작한다. 그래서 예약 이름(`issuers`, `codecs`, `docs`, `hashes`, `latest.geul`, `versions.geul`)이나 사람이 붙인 이름은 `add`, `cafe`처럼 hex로만 된 단어여도 ID와 겹치지 않는다.
- 위치(어느 서버에서 받는지)는 문서 내용에 넣지 않는다. 넣으면 주소가 바뀔 때 내용 해시가 바뀐다. 위치는 문서를 받는 쪽의 설정이 정한다.

### 공표 형태와 조회

- 주소는 논리 주소다. 공표처는 개별 파일이나 pack으로 낼 수 있고, pack이면 주소 URL로 직접 받을 수 없으며 GEUL 해석기로 읽는다.
- 개별 파일, pack, zstd pack 어느 형태로 저장돼도 같은 주소로 찾는다. 위 10가지 형식 밖의 주소와 없는 주소는 404(없음)다.

명령줄 도구 `geul`([gogeul](https://github.com/geul-org/gogeul)):

```
geul get <주소>     순수 GEUL 문서 바이너리를 표준 출력으로 낸다
geul show <주소>    문서를 텍스트로 보여 준다
```

- `geul get`은 `file://`, `https://` 주소를 받는다. 10가지 형식 밖의 주소와 없는 주소는 404(없음)로 끝난다.

Go 라이브러리 gogeul의 `pkg/resolve`는 주소마다 조회 함수를 둔다. 모두 순수 GEUL 바이너리(`[]byte`)를 돌려준다. 버전 ID는 1부터이므로 `Latest`(0)가 최신이다. 없는 주소는 없음 오류(`ErrNotFound`)다.

```go
const Latest uint32 = 0

Issuers(ctx, v)               / IssuersVersions(ctx)
Codec(ctx, issuer, codec, v)  / CodecVersions(ctx, issuer, codec)
Doc(ctx, issuer, doc, v)      / DocVersions(ctx, issuer, doc)
Hash(ctx, issuer, hash)

ParseAddr(s string) (Addr, error)   // 10가지 외 형식은 404(없음)
Fetch(ctx, Addr) ([]byte, error)    // geul get = ParseAddr → Fetch → 표준 출력
```

### 형식 지정

- 확장자가 있으면 형식을 지정한 것이다. `.geul`은 바이너리(`application/vnd.geul`)다.
- 확장자가 없으면 `Accept` 헤더를 따른다. 브라우저에는 HTML 보기를, 도구에는 바이너리를 준다. 예: `/<Issuer>/docs/<문서 ID>/<버전 ID>`
- 문서는 바이너리가 정본이다. 내용 해시와 서명은 바이너리로만 계산한다.

### 목록 문서

목록 문서는 Issuer 목록 `issuers/` 하나다. Issuer와 도메인을 묶는다([Issuer 목록](#issuer-목록)). 버전 1부터이고 `versions.geul`을 둔다. 예약 문서 ID는 `0xFFFFFFFFFFFFFFFF`(Issuer geul.org `0x00000000`)다.

- `latest.geul`은 저장하지 않는 별칭이다. `versions.geul`에서 가장 최근 버전을 찾아 그 바이트를 낸다.
- `issuers/versions.geul`의 PUBLICATION·DEPRECATION·TOMBSTONE은 DOC-POINTER(`0x00000000`, `0xFFFFFFFFFFFFFFFF`, 버전 ID)로 목록 버전을 가리킨다. 그래서 `hashes/`로 받아도 무엇의 목록인지 안다([PUBLICATION](/ko/grammar/edge/publication/#목록-문서의-버전-목록)).
- 예약 문서 ID는 `0x00000000/docs/<문서 ID>/` 주소로 받지 않는다(404). 문서 ID `0x0000000000000000`(용어 정의 색인, [Issuer와 공표](/ko/grammar/issuer/#용어-정의-문서)) 예약과 같은 방식이다.
- 목록 문서에는 `DOC-ID`를 두지 않는다. 무엇의 목록인지는 레코드의 DOC-POINTER가 말한다([DOC-ID](/ko/grammar/meta/declaration/doc-id/)).
- 문서와 코덱은 목록 없이 레코드에서 계산한 ID로 바로 찾는다([문서 이름](#문서-이름)).

### 도메인 이름

도메인 이름은 공표 URL 주소가 아니다. `<Issuer>` 자리에 도메인을 쓰거나 ID 자리에 이름을 쓴 주소는 위 10가지 형식 밖이라 404(없음)다. 이름에서 ID 주소로 보내는 리다이렉트도 없다.

- 도메인 이름은 해석기와 CLI의 입력이다. 해석기는 Issuer 목록 `issuers/`의 BIND로 도메인을 Issuer ID로 바꾼다. 바꾼 ID는 잠금 기록에 남긴다. 문서 이름 주소는 없다([문서 이름](#문서-이름)).
- 정본 주소, 캐시 키, 서명 대상은 ID 주소다.
- 도메인은 소문자로 쓰고, 국제화 도메인은 IDNA(punycode) 형태로 쓴다. 끝의 `.`은 붙이지 않는다.
- 등록부가 없는 16 WORD Issuer와 geul.org에 닿지 못하는 망분리 환경은 도메인 이름을 쓰지 못한다. ID를 쓴다.

### Issuer 목록

Issuer 목록은 `/.well-known/geul/issuers/` 아래 문서다(최신은 `issuers/latest.geul`). Issuer와 그 이름(도메인)을 묶는다.

```
BODY
  BIND   Subject = ISSUER-POINTER(Issuer)   이름 = "geul.org"
  …
```

- Subject는 [ISSUER-POINTER](/ko/grammar/reference/issuer-pointer/)(Issuer 자신)이고 이름은 [BIND](/ko/grammar/edge/bind/)로 묶는다.
- 이름은 도메인 소유 증명을 거친 도메인이다. 소문자이며 국제화 도메인은 IDNA(punycode)로 쓴다. 이름 하나는 Issuer 하나에만 묶인다.
- 사람이 읽는 Issuer 표시 이름(언어별)은 같은 Subject에 서술 [LABEL](/ko/grammar/edge/label/)로 붙인다.
- geul.org(GEUL Issuer)가 서명하고, 바뀌면 덧붙이며 고치지 않는다(버전 목록과 같은 사슬 규칙).

### 문서 이름

**문서 이름 주소는 없다.** 문서와 코덱은 ID로 찾는다.

- 문서 이름·코덱 이름을 ID로 바꾸는 색인은 두지 않는다. 버전 목록에도 문서 이름 [BIND](/ko/grammar/edge/bind/)를 두지 않는다([PUBLICATION](/ko/grammar/edge/publication/#버전-목록-문서)).
- 사람이 둘러보는 색인은 도구(뷰어)가 pack 인벤토리로 만든다.
- 정본 주소, 캐시 키, 서명 대상은 ID 주소다. IMPORT와 문서 안의 인용은 ID로만 한다.
- 사람이 읽는 제목(언어별)은 서술 [LABEL](/ko/grammar/edge/label/)로 붙인다.

### 삭제된 문서

- 법적 삭제·직권 삭제된 버전의 주소는 `410 Gone`과 묘비(버전 ID, 내용 해시, 삭제 일자, 사유 범주)를 돌려준다.
- 버전 목록에는 [TOMBSTONE](/ko/grammar/edge/publication/) 레코드로 남는다.

## 층

GEUL은 출처·메타·목록까지 GEUL 문서로 표현한다. 그것을 읽는 데 필요한 최소한은 디코더에 내장해 순환을 끊는다. 각 층은 아래 층에만 기댄다.

| 층 | 내용 | 기대는 것 |
|---|---|---|
| 0층 | 디코더 내장 규칙: 프레이밍, 내용 해시, 서명 검증, 버전 목록 레코드 Codec(`PUBLICATION`·`DEPRECATION`·`TOMBSTONE`), Codec 규격 어휘(`DECLARE`·`FIELD`·`ENUM`·`CODEC`), [자리 표지](/ko/grammar/reference/slot-marker/)(`0x0000`, `0x0010`, `0x0020`), 문서 밖에서 받는 신뢰 키 | 없음. 조회하지 않는다 |
| 1층 | 버전 목록 문서 | 0층 |
| 2층 | 일반 문서, 코덱북, Codec 규격 문서, Issuer 검증키 문서 | 1층으로 찾고 0층으로 검증한다 |

- 어느 층도 자기 층이나 위 층에 기대지 않는다.
- GEUL로 표현하는 것과 GEUL로 해석해야만 읽히는 것을 구분한다. 0층은 GEUL로 표현할 수는 있어도 해석에 조회가 필요하지 않다.
- 판정의 의미처럼 TOULMIN 문서로 바꿀 수 없는 고정 핵심도 이 자리에 둔다([TOULMIN](/ko/grammar/edge/toulmin/#메타-인지와-자기-개정)).

## 버전 목록

공표처는 문서마다 버전 목록 문서 하나를 이어 쓴다(`/<Issuer>/docs/<문서 ID>/versions.geul`, 코덱은 `/<Issuer>/codecs/<코덱 ID>/versions.geul`, Issuer 목록은 `issuers/versions.geul`). 레코드 형식과 문서 구조는 [PUBLICATION](/ko/grammar/edge/publication/)이 정한다.

```
DOC-*
  SPEC-VERSION
  PARENT          직전 버전 목록의 내용 해시
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
- 버전 목록에는 `DOC-ID`를 두지 않는다. 레코드의 DOC-POINTER(문서 ID, Issuer 목록은 예약 문서 ID)가 무엇의 목록인지 말한다.
- 버전 목록은 IMPORT를 두지 않고, 0층 Codec만 쓴다. BODY에는 PUBLICATION·DEPRECATION·TOMBSTONE만 둔다.
- 지난 버전 목록은 내용 해시(`<Issuer>/hashes/<내용 해시>.geul`)로만 가리키고, 이력은 `PARENT` 사슬로 잇는다.
- 가변인 주소는 `latest.geul`과 `versions.geul`이다. 가변 포인터는 문서로 만들 수 없으므로, 받은 목록의 서명·`RECORDED-AT`·`PARENT`로 검증한다.

### 서명 주체

| 서명 | 주체 | 대상 |
|---|---|---|
| 문서 서명 | 그 문서의 Issuer | 문서의 내용 해시 ([Issuer와 공표](/ko/grammar/issuer/#서명)) |
| 목록 서명 | 버전 ID를 배정한 공표처 | 버전 목록의 내용 해시 |

- geul.org 공표는 geul.org(GEUL Issuer)가, 사설 공표는 그 Issuer가 버전 ID를 배정하고 목록에 서명한다.
- 저자는 내용을, 공표처는 번호와 순서를 책임진다.

### 검증

- 서명은 내용 해시에서 빠지므로 지워도 해시가 그대로다. 그래서 "서명이 있으면 확인한다"가 아니라 "정해진 키의 서명이 있어야 한다"로 검증한다. 요구할 키는 해석기의 신뢰 설정과 잠금 기록이 정한다.
- 해석기는 마지막으로 본 목록의 내용 해시를 잠금 기록에 남긴다. 새로 받은 목록의 `PARENT` 사슬에 그 해시가 없으면 거부한다(되감기·분기 방지).
- 미러와 망분리 환경은 버전 목록 사슬을 함께 복사한다. 공개키만 있으면 오프라인에서 검증된다.
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

- 2·4·16 WORD Issuer 문서 중 어디까지 geul.org가 직접 서비스하고 어디부터 등록부의 주소로 보낼지. 그때의 상태 코드(정본 308, 최신 302·307).
- 사설 공표·16 WORD Issuer·망분리 환경에서 버전 ID가 갈라질 때(같은 버전 ID, 다른 내용)의 처리.
- 텍스트 표현의 정의와 콘텐츠 협상(`Accept`에 따라 바이너리, 텍스트, HTML 보기).
- Issuer 목록 `issuers/`의 HEAD 구성과 서명·사슬 형식. 도메인이 없는 Issuer(4 WORD)의 이름 규칙, 이름 분쟁 처리와 길이 상한.
- 목록이 커질 때 전체 사슬 대신 Merkle 로그(포함·일관성 증명)로 옮기는 시점과 형식.
- 위치 제공 Issuer를 HEAD에 적는 Meta.
