---
title: "Issuer와 공표"
weight: 80
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "Issuer는 문서와 형식을 정의하는 주체다. 폭(1·2·4·16 WORD)에 따라 발급 방식이 다르다. 이 페이지는 Issuer 등급과 1 WORD 배정표, 문서 공개 방식, 서명과 검증키 공개를 정한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL은 식별 체계를 한곳에 모으지 않는다. 각 Issuer가 대상과 형식을 정의하고, 다른 문서는 공표된 정의를 가져다 쓴다. 정의는 대외비로 쓰거나, geul.org(CC0) 또는 사설 공표(Issuer가 정한 라이선스)로 공표한다. 어느 정의를 믿고 쓸지는 사용자가 정한다.

공표 주소, 형식 지정, 이름 색인, 버전 목록, 신뢰 층은 [공표 주소와 버전 목록](/ko/grammar/publishing/)이 정한다.

## Issuer가 정의하는 것

| 대상 | 방법 |
|---|---|
| 대상(엔티티, 개념, 용어) | 자기 문서의 LOCAL로 선언한다 |
| Value 형식 | Issuer 코드 아래 형식 번호로 정의한다 |
| Edge 형식 | Issuer 코드 아래 형식 번호로 정의한다 |

- Value·Edge 형식의 정의도 문서로 공표한다.

## 원칙

- 모든 ID는 문서 범위다. LOCAL ID(Edge Id, 변수 포함)와 IMPORT ID는 그 문서 안에서만 유효하다.
- Issuer가 정의한 대상은 그 Issuer가 공표한 문서의 LOCAL이다. 다른 문서는 지시선언(`EXTERNAL-ISSUER-*`)으로 바로 인용하거나, `IMPORT-DOC`으로 가져와 `EXTERNAL-POINTER-*`로 가리킨다.
- 문서 밖에서 가리켜야 하는 대상에는 공표 문서의 LOCAL을 발급한다. 그 문서에는 [DOC-ID](/ko/grammar/meta/declaration/doc-id/)가 있어야 한다.

## Issuer 등급

| 폭 | 값 범위 | 발급 |
|---|---|---|
| 1 WORD | `0x0000`~`0xFFFF` | geul.org가 표준 제정 단체와 주요 기관에 배정([1 WORD 배정표](#1-word-배정표)) |
| 2 WORD | `0x00010000`~`0xFFFFFFFF` | geul.org 등록. 도메인 소유 증명을 거친다 |
| 4 WORD | `2^32`~`2^64−1` | geul.org 등록. 소유 증명이 없다 |
| 16 WORD | `2^64` 이상 | 자체 발급. 공개키에서 계산한다 |

- **Issuer ID는 정수값이다.** 값이 같으면 같은 Issuer다(`0x0001`과 `0x00000001`은 같은 값이다). 폭은 식별자의 일부가 아니다.
- **정규형은 가장 짧은 폭이다.** 값이 들어가는 가장 짧은 폭으로 쓰고, 더 넓은 폭의 표기는 거부한다. 그래서 각 폭의 배정은 바로 아래 폭의 범위가 끝난 다음 값부터 시작한다(2 WORD는 `0x00010000`부터).

## 1 WORD 배정표

1 WORD Issuer는 geul.org가 표준 제정 단체와 주요 기관에 배정한다. GEUL이 설계한 고유 형식은 `GEUL`, 제정 단체가 없는 사실상 표준이나 관례 형식은 `ADHOC` 아래에 둔다.

| Issuer | 이름 | 단체 | 대표 형식 |
|---|---|---|---|
| `0x0000` | GEUL | geul.org | GEUL 고유 형식, 코덱북 |
| `0x0001` | ADHOC | geul.org | 제정 단체가 없는 관례 형식. BFLOAT16, BLAKE3, 복소수·분수·구간·사원수, 벡터·텐서 |
| `0x0002`~`0x000F` | 예약 | | |
| `0x0010` | ISO | International Organization for Standardization | ISO 8601, ISO 4217(통화), ISO 3166(국가) |
| `0x0011` | IEC | International Electrotechnical Commission | IEC 80000(단위 표기) |
| `0x0012` | ISO-IEC-JTC1 | ISO/IEC Joint Technical Committee 1 | ISO/IEC 정보기술 표준 |
| `0x0013` | ITU-T | ITU Telecommunication Standardization Sector | X.509, X.690(ASN.1 인코딩) |
| `0x0014`~`0x001F` | 예약 | 국제 표준 단체 | |
| `0x0020` | IETF | Internet Engineering Task Force | URI(RFC 3986), UUID(RFC 9562), CRC32C, IPv4·IPv6 |
| `0x0021` | IANA | Internet Assigned Numbers Authority | 미디어 타입, 언어 부태그 레지스트리 |
| `0x0022` | W3C | World Wide Web Consortium | XML Schema 데이터 타입, RDF |
| `0x0023` | WHATWG | Web Hypertext Application Technology Working Group | URL, HTML |
| `0x0024` | UNICODE | Unicode Consortium | 문자 인코딩, 정규화, CLDR |
| `0x0025` | ECMA | Ecma International | JSON(ECMA-404) |
| `0x0026`~`0x003F` | 예약 | 인터넷·웹 표준 단체 | |
| `0x0040` | IEEE | Institute of Electrical and Electronics Engineers | IEEE 754 부동소수점·decimal, MAC 주소(802) |
| `0x0041` | KHRONOS | Khronos Group | 픽셀 형식(RGBA8·BGRA8 UNORM), glTF |
| `0x0042` | OGC | Open Geospatial Consortium | 좌표·경계 상자, GeoJSON 계열 |
| `0x0043` | ONNX | ONNX (LF AI & Data Foundation) | FP8 E4M3FN·E4M3FNUZ·E5M2·E5M2FNUZ |
| `0x0044` | OCP | Open Compute Project | Microscaling 형식(E8M0, FP4 E2M1) |
| `0x0045` | OASIS | OASIS Open | 문서·보안 표준 |
| `0x0046`~`0x005F` | 예약 | 산업 표준 단체 | |
| `0x0060` | BIPM | Bureau International des Poids et Mesures | SI 단위, TAI |
| `0x0061` | IERS | International Earth Rotation and Reference Systems Service | 윤초, UTC−TAI |
| `0x0062` | NIST | National Institute of Standards and Technology | SHA-2(FIPS 180-4), SHA-3(FIPS 202) |
| `0x0063` | GPS | GPS 정부 운영 주체 | GPS 시각 |
| `0x0064`~`0x00FF` | 예약 | 계량·정부 기관 | |
| `0x0100` | KATS | 국가기술표준원 | KS 표준 |
| `0x0101`~`0x01FF` | 예약 | 국가 표준 기관 | |
| `0x0200`~`0xFFFF` | 예약 | 이후 배정 | |

- 확장 형식은 그 형식을 제정한 단체의 Issuer 아래에 둔다. Issuer 아래의 형식 번호는 각 Issuer가 정의한다.
- 형식 번호의 상위 비트는 해당 Kind의 계열 규칙을 따라야 한다. 그래야 코덱북 없이 계열을 안다.
- 표준 단체가 GEUL 형식 번호를 직접 관리하지 않으면 geul.org가 그 단체의 표준을 대신 번호로 등재한다. 번호는 표준 문서 식별자와 함께 기록한다.
- 배정은 단체 구분 범위 안에서 낮은 번호부터 한다. 범위는 분류 편의이며 디코더가 해석할 의무는 없다.

## 16 WORD Issuer

```
Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ 서명 알고리즘 ID(2바이트) ‖ 공개키)
```

- 결과 32바이트를 16 WORD에 상위 바이트부터 쓴다.
- 등록 없이 누구나 만들 수 있다. 소유는 그 개인키의 서명으로 증명한다.
- 공개키와 알고리즘은 문서 HEAD의 [ISSUER-KEY](/ko/grammar/meta/verification/issuer-key/)로 선언한다. 서명 알고리즘 `0x0001`은 Ed25519이고, 그 밖의 값은 예약이다.
- 접두사 `GEUL-ISSUER-v1`은 같은 키를 다른 용도에 쓸 때 같은 ID가 나오지 않게 한다(용도 분리).
- 서명 알고리즘이 바뀌어도(예: Ed25519 → ML-DSA) ID 폭은 16 WORD로 같다.
- 결과가 `2^64` 미만이면(확률은 사실상 0) 그 키로는 Issuer를 만들지 않는다. 가장 짧은 폭 규칙과 겹치기 때문이다.

## 도메인 증명

- 2 WORD Issuer의 도메인 소유 증명은 등록 시점에만 확인한다. 이후 도메인 관리는 Issuer의 책임이다.
- 도메인 하나는 Issuer 하나에만 대응한다. Issuer 하나는 도메인을 여럿 가질 수 있다. 대응은 Issuer 이름 색인 `issuers.geul`의 BIND로 적는다([공표 주소와 버전 목록](/ko/grammar/publishing/#issuer-이름)).
- 도메인이 만료되거나 넘어가도 대응은 처음 증명한 Issuer에 남는다. 새 소유자는 그 도메인을 Issuer 이름으로 쓰지 못한다.
- 도메인 이름은 주소 입력과 표시용이다. GEUL 문서 안에는 Issuer ID만 적는다.

## 용어 정의 문서

- Issuer가 정의한 용어(도구, 프로그램, 역할, 조직 안의 개념)는 **용어 하나에 문서 하나**로 둔다. 용어는 그 문서의 LOCAL이고, 이름은 [BIND](/ko/grammar/edge/bind/)로, 가리키는 외부 대상(URI 등)은 [REFERENCE-NODE](/ko/grammar/edge/reference-node/)로 잇는다.
- 다른 문서는 `EXTERNAL-ISSUER-*`(Issuer, 문서 ID, LOCAL ID)로 용어를 가리킨다. 같은 정의를 문서마다 반복하지 않는다. 예: [TRANSFORMED-BY](/ko/grammar/meta/lineage/transformed-by/)의 도구.
- 용어 정의 문서의 문서 ID 구간은 Issuer가 정한다. geul.org(`0x0000`)는 `0x0001xxxx xxxxxxxx`를 쓴다([Codec 규격 문서](/ko/grammar/codec-spec/#geul-issuer의-문서-id)).
- 각 Issuer의 문서 ID `0x0000000000000000`은 그 Issuer의 **용어 정의 색인 문서**로 예약한다: `<Issuer>/0x0000000000000000/`. 용어 정의 문서들을 나열하는 자리다.
- 색인 문서는 모든 Issuer에 **권고**한다. 필수는 아니다. 색인이 없으면 용어 정의 문서는 이름 색인 `documents.geul`로 찾는다.
- 외부 대상을 가리키는 순서: (1) 맞는 Reference Codec이 있으면 그것(WIKIDATA-QID 등), (2) 그 대상을 정의한 GEUL 문서가 있으면 그것(DOC-POINTER·EXTERNAL-ISSUER), (3) 없으면 자기 용어 정의 문서에 LOCAL로 정의하고 가리킨다.

## 문서 공개 방식

| 방식 | 대상 | 라이선스 | 버전 관리 | 존속 |
|---|---|---|---|---|
| 대외비 | 모든 Issuer | Issuer 내부 | Issuer | Issuer에 달림 |
| geul.org 공표 | 1·2 WORD Issuer | CC0 | geul.org | geul.org가 보존 |
| 사설 공표 | 모든 Issuer | Issuer가 정한다 | Issuer | Issuer에 달림 |

### geul.org 공표

- 1·2 WORD Issuer는 문서를 geul.org에 등록해 공표할 수 있다. 등록 문서는 CC0다.
  - 1 WORD Issuer는 geul.org의 사전 심사를 거쳐 공표한다.
  - 2 WORD Issuer는 등록하면 바로 공표되고, 문제는 사후에 조치한다.
- 공표할 수 있는 정의는 개념과 코덱이다. **자연인을 가리키는 Reference는 geul.org에 공표할 수 없다.** 대외비나 사설 공표로 한다.
  - 예외: [WIKIDATA-QID](/ko/grammar/reference/wikidata-qid/)로 자연인을 가리키는 것은 허용한다.
- 등록한 버전은 바꾸거나 지우지 않으며, Issuer가 사라져도 문서는 남는다(구법 보존). 예외는 법적 삭제와 직권 삭제다([TOMBSTONE](/ko/grammar/edge/publication/)).
- Issuer는 정의에 사용 중단 권고(deprecated)만 표시할 수 있다. 권고된 정의도 계속 해석된다.
- 같은 문서의 새 버전은 정의를 신설·개정·삭제할 수 있다([문서](/ko/grammar/document/#개정)). **삭제한 엔티티 ID와 형식 번호는 다른 대상에 재사용하지 않는다.** 형식 번호의 wire 레이아웃은 개정하지 않는다.

### 사설 공표

- CC0가 아닌 라이선스로 공표하려는 Issuer는 사설망(자체 도메인 등)에서 문서를 서비스한다. 라이선스는 문서 HEAD의 [LICENSE](/ko/grammar/meta/policy/license/)로 선언한다.
- 사설 공표도 geul.org와 같은 경로를 쓴다([공표 주소와 버전 목록](/ko/grammar/publishing/)).
- 버전 관리, 가용성, 도메인 유지, 라이선스 조건은 Issuer가 정한다. geul.org는 사설 공표에 관여하거나 보증하지 않는다.

### 대외비

- 대외비 문서는 공표하지 않는다. 접근 제어를 걸고 [ACCESS](/ko/grammar/meta/policy/access/)로 표시한다.
- 대외비 정의를 쓴 문서를 외부에 보내면 받는 쪽은 그 Reference·Value·Edge를 해석하지 못하고 건너뛴다. 외부와 주고받을 정의는 공표한다.

### 사용자의 선택

- 사용자는 선언된 라이선스와 Issuer의 존속 가능성을 보고 쓸 문서를 고른다.
- 지나치게 제한적인 라이선스나 존속이 불안한 Issuer의 정의는 쓰이지 않는다.
- 오래 보존되어야 하는 참조는 geul.org 공표 문서를 쓴다.

## 서명

- 서명은 공표 문서에 필수다. HEAD에 [SIGNATURE](/ko/grammar/meta/verification/signature/)로 둔다. 서명이 없는 문서도 유효한 GEUL 문서이며, 대외비·내부 문서도 가능하면 서명한다.
- 서명 대상은 문서의 **내용 해시**다([문서](/ko/grammar/document/#내용-해시)). BODY만 서명하지 않는다.
  - HEAD에는 해석 규칙이 있다. `IMPORT-DOC`의 대상을 바꾸면 같은 BODY가 다른 대상을 가리킨다.
  - `LICENSE`·`PARENT`를 서명하지 않으면 라이선스와 이력을 위조할 수 있다.
- 한 문서에 서명을 여럿 둘 수 있다. 모두 같은 내용 해시에 서명하므로 서명을 더해도 내용 해시는 바뀌지 않는다.
- 서명 키 확인:
  - 1·2·4 WORD Issuer: geul.org에 등록한 키(아래 검증키 공개).
  - 16 WORD Issuer: 같은 문서의 `ISSUER-KEY`. 그 공개키로 계산한 Issuer ID가 서명자와 같아야 한다.
- 읽는 쪽은 서명이 없으면 신뢰도를 낮추고, 서명이 있는데 검증에 실패하면 변조·사칭의 증거이므로 더 크게 낮춘다.
- 문서 서명은 그 문서의 Issuer가, 버전 목록 서명은 버전 ID를 배정한 공표처가 한다([공표 주소와 버전 목록](/ko/grammar/publishing/#서명-주체)).

## 검증키 공개

- geul.org는 등록 Issuer(1·2·4 WORD)의 서명 검증키를 공개한다.
- 키 목록은 GEUL Issuer(`0x0000`)의 공표 문서로 낸다. CC0이며 geul.org가 서명한다.
  - 항목: Issuer, 서명 알고리즘 ID, 공개키, 유효 시작 시점, 폐기 시점과 사유.
- 폐기된 키도 지우지 않는다. 과거 서명은 서명 시점에 유효했던 키로 검증한다.
- 키 교체는 새 키를 옛 키로 서명해 등록한다. 검증하는 쪽은 geul.org를 믿지 않아도 키의 연속성을 확인할 수 있다.
- 키 변경 기록은 추가만 가능한 로그로 남긴다(Certificate Transparency, Go sumdb와 같은 방식). 이력을 고치면 드러난다.
- 키를 잃어버려 옛 키로 서명할 수 없으면 geul.org가 신원을 다시 확인해 새 키를 등록한다. 2 WORD Issuer는 도메인 소유 증명을 다시 거친다. 이 경우는 geul.org를 신뢰해야 하며, 사유를 로그에 남긴다.
- 16 WORD Issuer는 해당하지 않는다. Issuer ID가 공개키에서 계산되므로 문서 안의 `ISSUER-KEY`만으로 검증한다.

## 가져오기

IMPORT는 문서만 가져온다.

```
IMPORT-DOC                      DOC-POINTER(Issuer + 문서 ID + 버전 ID) + IMPORT ID
EXTERNAL-POINTER-1/2/4/8WORD    IMPORT ID + LOCAL ID
EXTERNAL-ISSUER-1/2/4/16WORD    Issuer + 문서 ID + LOCAL ID (IMPORT 없이)
ISSUER-POINTER                  Issuer (Issuer 자신)
DOC-POINTER                     Issuer + 문서 ID + 버전 ID (2 WORD, 0이면 최신)
```

- 어느 폭의 Issuer와 그 문서든 IMPORT 없이 지시선언으로 가리킬 수 있다. Issuer 자신은 `ISSUER-POINTER`, 문서 자신은 `DOC-POINTER`, 문서의 LOCAL은 `EXTERNAL-ISSUER-*`다. 지시선언은 최신 버전을 따르고, 버전을 고정하려면 `IMPORT-DOC`(버전 ID)과 `EXTERNAL-POINTER-*`를 쓴다.
- 본문 Reference는 전체 경로(Issuer + 문서 + 대상 ID) 대신 IMPORT ID + 대상 ID만 쓴다.
- IMPORT ID의 폭은 `IMPORT-DOC`에서는 길이로, `EXTERNAL-POINTER-*`에서는 Codec으로 정해진다. 그 문서 안에서만 유효하다([IMPORT-DOC](/ko/grammar/meta/import/import-doc/)).
- 버전 ID 없이 가져오면 최신 버전을 따른다. 버전 ID를 적으면 그 버전에 고정된다. 공표 문서는 버전 ID를 적는다.

## 라이선스

- geul.org 공표 문서와 GEUL Issuer(`0x0000`) 문서는 CC0다.
- 사설 공표 문서의 라이선스는 Issuer가 정한다. GEUL은 강제하지 않는다.
- GEUL 핵심 산출물은 CC0가 아닌 Issuer 문서의 내용을 복제하지 않는다.

## 열린 문제

- 4 WORD·16 WORD Issuer의 geul.org 공표 허용 여부.
- 도메인 소유 증명 방식(DNS TXT `_geul.<도메인>`, HTTP `.well-known`)과 증명 값에 서명 키 지문을 묶을지.
- 키 분실 복구 때 도메인 탈취 대응. 도메인 재증명만으로 새 키를 등록하면 탈취자가 Issuer를 가져갈 수 있다. 등록 연락처 확인, 유예 기간과 옛 키 이의, 도메인 분쟁 결과 준용을 검토한다.
- 용어 정의 색인 문서(문서 ID `0`)의 레코드 형식(용어 정의 문서를 나열하는 Edge).
- 서명 알고리즘 기본값(Ed25519 권장).
