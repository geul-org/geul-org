---
title: "Reference"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference", "LOCAL", "quantifier"]
summary: "Reference는 대상을 가리키는 레코드다. Codec 4비트로 식별 체계(LOCAL, 위키데이터, 외부 문서 등)를, Quantifier 3비트로 양화(식별됨, 총칭, 전칭, 변수 등)를 정한다. 예약 Codec 0000은 자리 표지 묶음이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Reference는 대상을 가리키는 레코드다. 대상은 엔티티, 개념, 문서, 다른 Edge일 수 있다. 이름이 아니라 ID로 가리킨다.

## 레이아웃

```
TAG WORD          0000 0LLL LCCC CQQQ
[Length 확장 TAG]
[IMPORT ID]       EXTERNAL-POINTER일 때 (1/2/4/8 WORD)
[Issuer]          EXTERNAL-ISSUER일 때 (1/2/4/16 WORD)
[문서 ID]         EXTERNAL-ISSUER일 때 (4 WORD)
대상 ID           나머지 전부
```

- `LLLL`은 TAG WORD를 포함한 전체 WORD 수 − 1이다([레코드와 TAG WORD](/ko/grammar/record/)).
- Codec은 `CCCC` 4비트, Quantifier는 `QQQ` 3비트다. TAG WORD의 하위 7비트는 `CCCC << 3 | QQQ`다.
- 대상 ID는 부호 없는 빅 엔디언 정수이고 **가장 짧은 폭**으로 쓴다. 폭은 Length에서 앞 필드를 뺀 나머지다.
- 대상 ID `0`은 `0x0000` 1 WORD로 쓴다. 그 밖에는 앞에 `0x0000` WORD를 붙이지 않는다.
- 정수값이 같으면 같은 ID다. 폭은 ID의 일부가 아니다.
- 모든 Codec이 가장 짧은 폭을 쓴다. Codec이 대상 ID 폭을 고정하지 않는다.
- [ISSUER-POINTER](/ko/grammar/reference/issuer-pointer/)와 [DOC-POINTER](/ko/grammar/reference/doc-pointer/)는 이 레이아웃을 따르지 않는다. 대상 ID가 없고 Issuer(와 문서 ID·버전 ID)만 둔다.

## Codec (`CCCC`)

| CCCC | 이름 | 분류 | 대상 |
|---|---|---|---|
| `0000` | [자리 표지](/ko/grammar/reference/slot-marker/) | 예약 | 대상을 가리키지 않는다. 하위 3비트가 표지 번호인 1 WORD 표지만 쓴다: `0x0000` ABSENT(적지 않음), `0x0001` UNKNOWN-VALUE(알 수 없음), `0x0002` NO-VALUE(없음) |
| `0001` | [LOCAL](/ko/grammar/reference/local/) | 선언 | 이 문서가 발급한 ID |
| `0010` | [GEUL](/ko/grammar/reference/geul/) | 선언 | geul.org가 발급하는 엔티티 |
| `0011` | [GEUL-SIDX](/ko/grammar/reference/geul-sidx/) | 선언 | 비트에 의미를 담은 의미정렬 식별자 |
| `0100` | [WIKIDATA-QID](/ko/grammar/reference/wikidata-qid/) | 선언 | 위키데이터 항목. `Q` 뒤의 정수 |
| `0101` | [WIKIDATA-PID](/ko/grammar/reference/wikidata-pid/) | 선언 | 위키데이터 속성. `P` 뒤의 정수 |
| `0110` | [ISSUER-POINTER](/ko/grammar/reference/issuer-pointer/) | 지시선언 | Issuer 자신 |
| `0111` | [DOC-POINTER](/ko/grammar/reference/doc-pointer/) | 지시선언 | Issuer가 공표한 문서의 한 버전 |
| `1000`~`1011` | [EXTERNAL-POINTER-1/2/4/8WORD](/ko/grammar/reference/external-pointer/) | 지시 | IMPORT로 가져온 문서의 LOCAL ID |
| `1100`~`1111` | [EXTERNAL-ISSUER-1/2/4/16WORD](/ko/grammar/reference/external-issuer/) | 지시선언 | Issuer가 공표한 문서의 LOCAL ID |

- **선언**은 발급 주체가 정한 ID로 대상을 직접 식별한다.
- **지시**는 IMPORT ID로 가져온 문서 안의 LOCAL을 가리킨다. 하위 2비트가 IMPORT ID 폭이다(`00`=1, `01`=2, `10`=4, `11`=8 WORD).
- **지시선언**은 IMPORT 없이 레코드 하나로 다른 문서와 그 안의 대상을 가리킨다.
- 최상위 비트가 `0`이면 대상을 직접 식별하고(이 문서의 LOCAL, 발급 ID, Issuer·문서 자체), `1`이면 다른 문서의 LOCAL을 가리킨다.
- Codec `0000`은 예약이고, 대상을 가리키는 Reference로는 쓰지 않는다. 예외는 하나의 묶음이다: WORD `0x0000`~`0x0007`(Codec `0000`, 1 WORD)은 [자리 표지](/ko/grammar/reference/slot-marker/)다. 지금 셋을 쓴다(`0x0000` ABSENT, `0x0001` UNKNOWN-VALUE, `0x0002` NO-VALUE). 표지는 그 WORD를 CODEC 대상으로 정확히 둔 레코드 필드 자리에서만 유효하다. 와일드카드와 CODEC 없는 필드는 받지 않고, HEAD·BODY 레코드 자리와 Edge Id 자리에서는 invalid다. `0x0003`~`0x0007`과 Payload가 있는 Codec `0000`은 예약이다.
- CC0가 아닌 식별 체계(WordNet 등)는 Reference Codec으로 두지 않는다. Reference에는 ISSUER 코드도 없어 Issuer 형식으로 옮길 자리도 없다.

### 자주 쓰는 TAG

| 레코드 | WORD |
|---|---|
| LOCAL 1 | `0088 0001` |
| LOCAL 65536 | `0108 0001 0000` |
| 위키데이터 Q5 (사람) | `00A0 0005` |
| 위키데이터 Q691283 | `0120 000a 8c53` |
| 위키데이터 P31 (instance of) | `00A8 001f` |
| 자리 표지 ABSENT / UNKNOWN-VALUE / NO-VALUE | `0000` / `0001` / `0002` |

## LOCAL

LOCAL은 이 문서가 발급한 ID다. 문서 안에서만 뜻이 있다.

- **유일하다.** 한 문서에서 LOCAL ID 하나는 대상 하나만 가리킨다.
- **0은 배정하지 않는다.** 대상 ID는 1부터 배정한다.
- **늘려 가며 배정하기를 권고한다**(auto increment). ID의 대소에는 의미가 없다.
- 버전을 넘어 같은 대상을 가리킨다. 삭제한 ID는 다시 쓰지 않는다([문서](/ko/grammar/document/) 개정).
- 문서 밖에서 가리키게 하려면 문서에 `DOC-ID`가 있어야 한다.
- 서로 다른 LOCAL ID가 현실에서 다른 대상이라는 뜻은 아니다. 같으면 `SAME-NODE`, 다르면 `DIFFERENT-NODE` Edge로 잇는다.

### Edge Id

모든 Edge는 Payload의 첫 요소로 LOCAL Reference를 둔다. 그 LOCAL ID가 **Edge Id**다.

- 코덱북을 몰라도 Edge Id를 읽을 수 있다.
- Edge Id 자리의 LOCAL은 선언이고, Edge의 다른 자리의 LOCAL은 언급이다.
- Edge Id를 선언하는 LOCAL의 Quantifier는 `000`만 쓴다.
- 다른 Edge는 Edge Id로 가리킨다. 이 문서의 Edge는 LOCAL로, 다른 문서의 Edge는 지시 Reference로 가리킨다.

## 다른 문서 가리키기

| 무엇을 | 어떻게 |
|---|---|
| Issuer 자신 | `ISSUER-POINTER`(Issuer) |
| 문서 한 버전 | `DOC-POINTER`(Issuer, 문서 ID 4 WORD, 버전 ID 2 WORD). 버전 `0`은 최신 |
| 공표 문서 안의 대상 (최신) | `EXTERNAL-ISSUER-*`(Issuer, 문서 ID, LOCAL ID) |
| 가져온 문서 안의 대상 (판본 고정) | Meta `IMPORT-DOC`으로 IMPORT ID를 배정하고 `EXTERNAL-POINTER-*`(IMPORT ID, LOCAL ID) |

- 문서 자체는 그 문서 안에서든 밖에서든 DOC-POINTER 하나로만 가리킨다. 자기 자신은 자기 `DOC-ID`의 DOC-POINTER다.
- EXTERNAL-ISSUER는 최신 버전을 따른다. 판본을 고정하려면 IMPORT를 쓴다.
- Issuer는 값이 들어가는 가장 짧은 폭(1/2/4/16 WORD)으로 쓰고, 그 폭에 맞는 Codec을 고른다.
- 각 Issuer의 문서 ID `0`은 그 Issuer가 정의한 용어(도구, 역할 등)의 색인 문서로 예약한다. 색인 문서는 모든 Issuer에 권고하며 필수가 아니다([Issuer와 공표](/ko/grammar/issuer/#용어-정의-문서)).

예: Issuer `0x0001`의 문서 `0x0000000000000002` 안의 LOCAL 7

```
0360 0001 0000 0000 0000 0002 0007
```

## Quantifier (`QQQ`)

| QQQ | 이름 | 뜻 | 예 |
|---|---|---|---|
| `000` | Identified | 식별된 개체 | 일론 머스크, 대한민국 |
| `001` | Generic | 종류 전체에 관한 일반적 진술. 예외를 허용한다 | 병사는 명령에 복종한다 |
| `010` | Free-choice | 조건을 만족하는 임의의 대상 | 아무 병사나 |
| `011` | Universal | 범위 안의 모든 대상 | 모든 병사 |
| `100` | Variable | 담화 변수 | 그 사람, 이 여자 |
| `101`~`111` | 예약 | | |

- **예외: Codec `0000`(자리 표지)에서는 하위 3비트가 Quantifier가 아니라 표지 번호다.** 표지 번호와 Quantifier의 뜻은 이어지지 않는다(`0x0001` UNKNOWN-VALUE는 Generic이 아니다). 이 표의 Quantifier는 Codec `0001`~`1111`에만 적용된다.
- Generic은 Universal과 달리 모든 개별 대상에 예외 없이 적용된다는 뜻이 아니다. `병사란 무엇인가` 같은 정의적 표현은 Generic으로 쓸 수 있다. 엄밀한 개념·분류 정의가 필요하면 별도의 관계로 구체화한다.
- 양화의 적용 범위와 부정은 Reference가 아니라 그것을 쓰는 Edge가 정한다.
- **Variable**은 종류는 알지만 아직 식별되지 않은 담화 속 대상이다.
  - 이름 있는 변수는 LOCAL에 Variable을 붙인다. 같은 LOCAL ID면 같은 변수다. 종류는 Edge로 잇는다.
  - 익명 변수는 종류를 가리키는 선언 Codec(GEUL, WIKIDATA-*)에 Variable을 붙인다(예: 위키데이터 "대통령" + Variable). 공참조를 추적하지 않으며 다시 가리킬 수 없다. 익명 변수끼리는 같은 변수로 보지 않는다.
  - 나중에 대상이 확인되면 변수를 그 대상과 `SAME-NODE`로 잇는다. 같은 변수를 가리키는 모든 표현이 함께 그 대상으로 해석된다.
  - 서로 다른 변수라도 실제 대상이 다르다는 뜻은 아니다. 같으면 `SAME-NODE`, 다르면 `DIFFERENT-NODE`로 잇는다.
  - 변수는 그 문서 안에서만 유효하며 영구 식별자로 쓰지 않는다.
  - 외부 지시 Codec(EXTERNAL-POINTER-*, EXTERNAL-ISSUER-*)의 Variable은 가리키는 문서의 LOCAL 변수다.
  - 예: `대통령이 연설했다`에서 인물이 확정되지 않았으면 '대통령' Variable을 쓴다. 다시 언급하려면 LOCAL Variable을 두고 종류 '대통령'을 Edge로 잇는다. 나중에 오바마로 확인되면 그 변수를 오바마 Identified와 `SAME-NODE`로 잇는다. 같은 변수를 가리키는 모든 표현이 함께 오바마로 해석된다.
- 예: 위키데이터 Q5(사람)를 Generic으로 쓰면 `00A1 0005`("사람은 …")다.
