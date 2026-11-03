---
title: "Reference"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference", "LOCAL", "quantifier"]
summary: "Reference는 대상을 가리키는 레코드다. 코드 하나로 식별 체계(LOCAL, 위키데이터, 외부 문서 등)와 양화(식별됨, 총칭, 전칭, 변수 등)를 정하고, Issuer 형식은 REFERENCE-ISSUER로 나타낸다. 코드 0x000L~0x002L은 자리 표지 묶음이다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Reference는 대상을 가리키는 레코드다. 대상은 엔티티, 개념, 문서, 다른 Edge일 수 있다. 이름이 아니라 ID로 가리킨다.

## 레이아웃

```
TAG WORD          000K KKKC CCCC LLLL      섹션 0~2 (0x000L~0x05FL)
[Length 확장 TAG]
[IMPORT ID]       EXTERNAL-POINTER일 때 (1/2/4 WORD)
[Issuer]          EXTERNAL-ISSUER일 때 (2/4/16 WORD)
[문서 ID]         EXTERNAL-ISSUER일 때 (4 WORD)
대상 ID           나머지 전부
```

- `LLLL`은 TAG WORD를 포함한 전체 WORD 수 − 1이다([레코드와 TAG WORD](/ko/grammar/record/)).
- Reference는 섹션 0~2(`w < 0x0600`) 96칸이다. 섹션 0 엔티티 `0x000L~0x01FL`, 섹션 1 EXTERNAL `0x020L~0x03FL`, 섹션 2 기타 `0x040L~0x05FL`이다.
- Codec은 코드 표로 쓴다(아래 표). 5Q 체계는 코드 하나에 식별 체계와 양화가 함께 있다. REFERENCE-ISSUER의 양화는 Issuer 문서가 정한다.
- 대상 ID는 부호 없는 빅 엔디언 정수이고 **가장 짧은 폭**으로 쓴다. 폭은 Length에서 앞 필드를 뺀 나머지다.
- 대상 ID `0`은 `0x0000` 1 WORD로 쓴다. 그 밖에는 앞에 `0x0000` WORD를 붙이지 않는다.
- 정수값이 같으면 같은 ID다. 폭은 ID의 일부가 아니다.
- 모든 Codec이 가장 짧은 폭을 쓴다. Codec이 대상 ID 폭을 고정하지 않는다.
- [ISSUER-POINTER](/ko/grammar/reference/issuer-pointer/), [DOC-POINTER](/ko/grammar/reference/doc-pointer/), [CODEC-POINTER](/ko/grammar/reference/codec-pointer/)는 이 레이아웃을 따르지 않는다. 대상 ID가 없고 Issuer(와 문서 ID·코덱 ID·버전 ID)만 둔다.
- [REFERENCE-ISSUER](/ko/grammar/reference/reference-issuer/)도 이 레이아웃을 따르지 않는다. TAG, Issuer, 코덱 번호 2 WORD, Payload다. Payload는 Issuer가 발행한 Codec 문서가 정한다.

## Codec

| TAG ID | 이름 | 분류 | 대상 |
|---|---|---|---|
| `0x000L~0x002L` | [자리 표지](/ko/grammar/reference/slot-marker/) | 자리 표지 | 대상을 가리키지 않는다. 1 WORD 표지만 쓴다: `0x0000` ABSENT(적지 않음), `0x0010` UNKNOWN-VALUE(알 수 없음), `0x0020` NO-VALUE(없음) |
| `0x005L~0x009L` | [LOCAL](/ko/grammar/reference/local/) | 선언 | 이 문서가 발급한 ID |
| `0x00AL~0x00EL` | [GEUL](/ko/grammar/reference/geul/) | 선언 | geul.org가 발급하는 엔티티 |
| `0x00FL~0x013L` | [GEUL-SIDX](/ko/grammar/reference/geul-sidx/) | 선언 | 비트에 의미를 담은 의미정렬 식별자 |
| `0x014L~0x018L` | [WIKIDATA-QID](/ko/grammar/reference/wikidata-qid/) | 선언 | 위키데이터 항목. `Q` 뒤의 정수 |
| `0x019L~0x01DL` | [WIKIDATA-PID](/ko/grammar/reference/wikidata-pid/) | 선언 | 위키데이터 속성. `P` 뒤의 정수 |
| `0x020L~0x02EL` | [EXTERNAL-POINTER-1/2/4WORD](/ko/grammar/reference/external-pointer/) | 지시 | IMPORT로 가져온 문서의 LOCAL ID |
| `0x02FL~0x03DL` | [EXTERNAL-ISSUER-2/4/16WORD](/ko/grammar/reference/external-issuer/) | 지시선언 | Issuer가 공표한 문서의 LOCAL ID |
| `0x040L` | [ISSUER-POINTER](/ko/grammar/reference/issuer-pointer/) | 지시선언 | Issuer 자신 |
| `0x041L` | [DOC-POINTER](/ko/grammar/reference/doc-pointer/) | 지시선언 | Issuer가 공표한 문서의 한 버전 |
| `0x042L` | [CODEC-POINTER](/ko/grammar/reference/codec-pointer/) | 지시선언 | Issuer가 공표한 코덱의 한 버전 |
| `0x05DL~0x05FL` | [REFERENCE-ISSUER-2/4/16WORD](/ko/grammar/reference/reference-issuer/) | Issuer 형식 | Issuer가 정의한다. 분류와 대상 ID 칸은 Issuer 문서가 정한다 |

- Reserved는 `0x003L~0x004L`, `0x01EL~0x01FL`(섹션 0), `0x03EL~0x03FL`(섹션 1), `0x043L~0x05CL`(섹션 2, 새 식별 체계 자리)이다.
- 체계 번호는 섹션 안 오프셋 `C`로 읽는다. 섹션 0에서 `5 <= C < 30`이면 체계 `C / 5`(1~5), 섹션 1에서 `C < 30`이면 체계 `6 + C / 5`(6~11)다.

| 체계 | 이름 | Identified | Generic | Free-choice | Universal | Variable |
|---:|---|---|---|---|---|---|
| 1 | LOCAL | `0x005L` | `0x006L` | `0x007L` | `0x008L` | `0x009L` |
| 2 | GEUL | `0x00AL` | `0x00BL` | `0x00CL` | `0x00DL` | `0x00EL` |
| 3 | GEUL-SIDX | `0x00FL` | `0x010L` | `0x011L` | `0x012L` | `0x013L` |
| 4 | WIKIDATA-QID | `0x014L` | `0x015L` | `0x016L` | `0x017L` | `0x018L` |
| 5 | WIKIDATA-PID | `0x019L` | `0x01AL` | `0x01BL` | `0x01CL` | `0x01DL` |
| 6 | EXTERNAL-POINTER-1WORD | `0x020L` | `0x021L` | `0x022L` | `0x023L` | `0x024L` |
| 7 | EXTERNAL-POINTER-2WORD | `0x025L` | `0x026L` | `0x027L` | `0x028L` | `0x029L` |
| 8 | EXTERNAL-POINTER-4WORD | `0x02AL` | `0x02BL` | `0x02CL` | `0x02DL` | `0x02EL` |
| 9 | EXTERNAL-ISSUER-2WORD | `0x02FL` | `0x030L` | `0x031L` | `0x032L` | `0x033L` |
| 10 | EXTERNAL-ISSUER-4WORD | `0x034L` | `0x035L` | `0x036L` | `0x037L` | `0x038L` |
| 11 | EXTERNAL-ISSUER-16WORD | `0x039L` | `0x03AL` | `0x03BL` | `0x03CL` | `0x03DL` |

- **선언**은 발급 주체가 정한 ID로 대상을 직접 식별한다.
- **지시**는 IMPORT ID로 가져온 문서 안의 LOCAL을 가리킨다. IMPORT ID 폭은 체계로 정해진다: 체계 − 6이 0, 1, 2이면 1, 2, 4 WORD다.
- **지시선언**은 IMPORT 없이 레코드 하나로 다른 문서와 그 안의 대상을 가리킨다. EXTERNAL-ISSUER의 Issuer 폭은 체계 − 9가 0, 1, 2이면 2, 4, 16 WORD다.
- `0x020L~0x03DL`(섹션 1, 체계 6~11)은 다른 문서의 LOCAL을 가리킨다. 그 밖의 선언 체계는 대상을 직접 식별한다(이 문서의 LOCAL, 발급 ID). 포인터(섹션 2, `0x040L~0x042L`)는 Issuer·문서·코덱 자체를 가리킨다. REFERENCE-ISSUER는 이 구분 밖이다.
- `0x000L~0x002L`은 자리 표지에 배정한 코드이고, 대상을 가리키는 Reference로는 쓰지 않는다. WORD `0x0000`, `0x0010`, `0x0020`(L 0, 1 WORD)은 [자리 표지](/ko/grammar/reference/slot-marker/)다(`0x0000` ABSENT, `0x0010` UNKNOWN-VALUE, `0x0020` NO-VALUE). 표지는 그 WORD를 CODEC 대상으로 정확히 둔 레코드 필드 자리에서만 유효하다. 와일드카드와 CODEC 없는 필드는 받지 않고, HEAD·BODY 레코드 자리와 Edge Id 자리에서는 invalid다. C 0~2에 Payload가 있는 TAG 형태(L ≥ 1)는 Reserved다.
- geul.org가 제공하는 직접 코드와 공표물만 CC0다. CC0가 아닌 식별 체계(WordNet 등)를 직접 코드로 두지 않는다. Issuer 형식의 라이선스는 그 Issuer가 정한다.

### 자주 쓰는 TAG

| 레코드 | WORD |
|---|---|
| LOCAL 1 | `0051 0001` |
| LOCAL 65536 | `0052 0001 0000` |
| 위키데이터 Q5 (사람) | `0141 0005` |
| 위키데이터 Q691283 | `0142 000A 8C53` |
| 위키데이터 P31 (instance of) | `0191 001F` |
| 자리 표지 ABSENT / UNKNOWN-VALUE / NO-VALUE | `0000` / `0010` / `0020` |

## LOCAL

LOCAL은 이 문서가 발급한 ID다.

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
- Edge Id를 선언하는 LOCAL은 Identified(`0x005L`)만 쓴다.
- 다른 Edge는 Edge Id로 가리킨다. 이 문서의 Edge는 LOCAL로, 다른 문서의 Edge는 지시 Reference로 가리킨다.

## 다른 문서 가리키기

| 무엇을 | 어떻게 |
|---|---|
| Issuer 자신 | `ISSUER-POINTER`(Issuer) |
| 문서 한 버전 | `DOC-POINTER`(Issuer, 문서 ID 4 WORD, 버전 ID 2 WORD). 버전 `0`은 최신 |
| 코덱 한 버전 | `CODEC-POINTER`(Issuer, 코덱 ID 2 WORD, 버전 ID 2 WORD). 버전 `0`은 최신 |
| 공표 문서 안의 대상 (최신) | `EXTERNAL-ISSUER-*`(Issuer, 문서 ID, LOCAL ID) |
| 가져온 문서 안의 대상 (판본 고정) | Meta `IMPORT-DOC`으로 IMPORT ID를 배정하고 `EXTERNAL-POINTER-*`(IMPORT ID, LOCAL ID) |

- 문서 자체는 그 문서 안에서든 밖에서든 DOC-POINTER 하나로만 가리킨다. 자기 자신은 자기 `DOC-ID`의 DOC-POINTER다. 코덱 문서는 예외로 CODEC-POINTER로 가리킨다(`DOC-ID`도 CODEC-POINTER).
- EXTERNAL-ISSUER는 최신 버전을 따른다. 판본을 고정하려면 IMPORT를 쓴다.
- Issuer는 값이 들어가는 가장 짧은 폭(2/4/16 WORD)으로 쓰고, 그 폭에 맞는 Codec을 고른다. EXTERNAL-ISSUER와 REFERENCE-ISSUER가 같다.
- 각 Issuer의 문서 ID `0`은 그 Issuer가 정의한 용어(도구, 역할 등)의 색인 문서로 예약한다. 색인 문서는 모든 Issuer에 권고하며 필수가 아니다([Issuer와 공표](/ko/grammar/issuer/#용어-정의-문서)).

예: Issuer `0x00000002`의 문서 `0x0000000000000002` 안의 LOCAL 7

```
02F7 0000 0002 0000 0000 0000 0002 0007
```

## Quantifier

| `C % 5` | 이름 | 뜻 | 예 |
|---|---|---|---|
| `0` | Identified | 식별된 개체 | 일론 머스크, 대한민국 |
| `1` | Generic | 종류 전체에 관한 일반적 진술. 예외를 허용한다 | 병사는 명령에 복종한다 |
| `2` | Free-choice | 조건을 만족하는 임의의 대상 | 아무 병사나 |
| `3` | Universal | 범위 안의 모든 대상 | 모든 병사 |
| `4` | Variable | 담화 변수 | 그 사람, 이 여자 |

- **양화는 5Q 체계(체계 1~11)에서만 읽는다.** 섹션 안 오프셋 `C`로, 섹션 0은 `5 <= C < 30`, 섹션 1은 `C < 30`일 때 양화 `C % 5`다. 한 섹션이 32칸이라 9비트 Codec 자리(`w >> 4`)를 5로 나누면 섹션 1이 어긋난다. 표지(섹션 0, `C < 3`)와 섹션 2(포인터, REFERENCE-ISSUER)는 양화가 없다. 표지 `0x0010` UNKNOWN-VALUE는 Generic이 아니다. REFERENCE-ISSUER의 양화는 Issuer가 발행한 Codec 문서가 정한다.
- Generic은 Universal과 달리 모든 개별 대상에 예외 없이 적용된다는 뜻이 아니다. `병사란 무엇인가` 같은 정의적 표현은 Generic으로 쓸 수 있다. 엄밀한 개념·분류 정의가 필요하면 별도의 관계로 구체화한다.
- 양화의 적용 범위와 부정은 Reference가 아니라 그것을 쓰는 Edge가 정한다.
- **Variable**은 종류는 알지만 아직 식별되지 않은 담화 속 대상이다.
  - 이름 있는 변수는 LOCAL에 Variable을 붙인다. 같은 LOCAL ID면 같은 변수다. 종류는 Edge로 잇는다.
  - 익명 변수는 종류를 가리키는 선언 Codec(GEUL, WIKIDATA-*)에 Variable을 붙인다(예: 위키데이터 "대통령" + Variable). 공참조를 추적하지 않으며 다시 가리킬 수 없다. 익명 변수끼리는 같은 변수로 보지 않는다.
  - 나중에 대상이 확인되면 변수를 그 대상과 `SAME-NODE`로 잇는다. 같은 변수를 가리키는 모든 표현이 함께 그 대상으로 해석된다.
  - 서로 다른 변수라도 실제 대상이 다르다는 뜻은 아니다. 같으면 `SAME-NODE`, 다르면 `DIFFERENT-NODE`로 잇는다.
  - 외부 지시 Codec(EXTERNAL-POINTER-*, EXTERNAL-ISSUER-*)의 Variable은 가리키는 문서의 LOCAL 변수다.
  - 예: `대통령이 연설했다`에서 인물이 확정되지 않았으면 '대통령' Variable을 쓴다. 다시 언급하려면 LOCAL Variable을 두고 종류 '대통령'을 Edge로 잇는다. 나중에 오바마로 확인되면 그 변수를 오바마 Identified와 `SAME-NODE`로 잇는다. 같은 변수를 가리키는 모든 표현이 함께 오바마로 해석된다.
- 예: 위키데이터 Q5(사람)를 Generic으로 쓰면 `0151 0005`("사람은 …")다.
