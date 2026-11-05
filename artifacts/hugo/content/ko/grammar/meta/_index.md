---
title: "Meta"
weight: 110
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance", "lineage", "import"]
summary: "Meta는 세계에 관한 내용이 아니라 문서에 관한 레코드다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta는 세계에 관한 내용이 아니라 문서에 관한 레코드다. 문서 구조 레코드(DOC·BODY·END)를 빼면 모두 문서의 HEAD에 둔다. HEAD에는 Meta 말고 문서 전체의 근거 Edge [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처)와 그 QUALIFIER도 온다.

## 레이아웃

```
TAG WORD          000K KKKC CCCC LLLL      섹션 14·15 (0x1C0L~0x1FFL)
[Length 확장 TAG]
Payload           날값 또는 내장 Value·Reference 레코드
```

- Meta에는 Issuer 형식이 없다. Meta는 모든 Issuer가 따르는 공통 규격이며 GEUL만 정의한다.
- `LLLL`은 TAG WORD를 포함한 전체 WORD 수 − 1이다. 표에 없는 Codec은 Reserved다.

## Payload 형식

| 형식 | 언제 | 예 |
|---|---|---|
| 날값 | 형식이 하나로 정해질 때. 다른 레코드 Codec에 기대지 않는다 | `DOC-*` 길이, `SPEC-VERSION`, `ISSUER-KEY` |
| 내장 Value | 여러 형식 중 고를 때. Value TAG가 형식을 알려 준다 | `PROFILE`, `EFFECTIVE-*`, 시각, 내용 해시 |
| 내장 Reference | 사람·조직·도구·문서 같은 대상을 가리킬 때 | `DOC-ID`, `AUTHOR`, `CO-AUTHOR`, `RECORDED-BY`, `SIGNED-OFF`, `SIGNATURE`의 서명자 |
| 없음 | 1 WORD 표지 | `BODY`, `END` |

- 내장 레코드는 독립 레코드가 아니며 그 Meta에 속한다. 각자 Length로 경계를 찾고, 마지막 레코드를 읽은 위치가 Meta의 끝과 정확히 맞아야 한다.
- 한 문서에 하나만 둘 수 있는 Meta와 여럿 둘 수 있는 Meta는 각 Codec 문서의 "개수"가 정한다.

## 클래스

Meta 번호는 `0x1C0L`부터 Reserved 없이 이어진다. 번호의 비트는 클래스를 나타내지 않는다. 클래스는 아래 구간 표로 안다.

| 클래스 | 직접 코드 | 다루는 것 |
|---|---|---|
| 구조 | `0x1C0L~0x1C4L` | 문서의 경계와 길이 |
| 정의 | `0x1C5L~0x1CAL` | 해석 선언 |
| 출처 | `0x1CBL~0x1D0L` | 누가, 언제, 어디서 |
| 계보 | `0x1D1L~0x1DDL` | 무엇에서 어떻게 나왔는가 |
| 정책 | `0x1DEL~0x1E3L` | 어떻게 취급하는가 |
| IMPORT | `0x1E4L` | 외부 문서를 가져온다 |
| 검증 | `0x1E5L~0x1E9L` | 믿을 수 있는가 |
| Reserved(검증 전용) | `0x1EAL~0x1FFL` | |

- 검증 클래스는 섹션 15에서 `C >= 5`, 곧 `w >= 0x1E50`인 레코드다. 코덱북 없이 이것으로 검증 클래스를 알고 내용 해시에서 뺀다.
- 뒤 Reserved `0x1EAL~0x1FFL`은 검증 전용이다. 검증 밖의 새 Meta는 검증 앞에 넣을 수 없고, 뒤 Reserved에 두면 내용 해시에서 빠진다.
- 구조·정의·IMPORT 클래스는 비트로 읽지 않는다. 디코더는 내장 번호 표로 안다.
- **해석에 필요한 Meta**: 구조, 정의, IMPORT. 지우면 레코드를 읽을 수 없거나 해석이 바뀐다. 모든 디코더가 처리해야 한다. 이 Codec들은 **GEUL 핵심 코덱북**에 속한다.
- **해석을 바꾸지 않는 Meta**: 출처, 계보, 검증, 정책. 지워도 서술 내용은 그대로다. 신뢰 판단과 취급의 재료만 사라진다.
- 근거는 Meta가 아니라 근거 Edge [SOURCE](../edge/0x0C0L-source.md)와 QUALIFIER로 쓴다. 개별 레코드의 근거는 BODY에, 문서 전체의 원천은 HEAD에 Target `0`인 SOURCE로 둔다([문서](../document.md#head와-body)).

## 구조

Meta 구조 클래스(Codec `0x1C0L~0x1C4L`)는 문서의 경계와 길이를 정한다. GEUL 데이터의 단위는 문서 하나다.

```
DOC-*                  ← HEAD 시작
  정의·출처·계보·검증·정책·IMPORT Meta
  문서 전체의 SOURCE와 그 QUALIFIER
BODY                   ← BODY 시작
  Reference, Value, Edge
END                    ← 문서를 닫음
```

- 모든 문서는 `DOC-1WORD/2WORD/4WORD`로 전체 길이를 지정해 연다. 디코더는 이 길이로 문서 전체를 한 번에 건너뛸 수 있다.
- `BODY`와 `END`는 Payload가 없는 1 WORD 레코드다. `END`는 필수다.
- 문서는 중첩하지 않는다. 다른 문서는 IMPORT로 가리킨다.
- HEAD(Meta, 문서 전체의 SOURCE와 그 QUALIFIER)가 비어 있으면 `BODY`를 생략한다. `BODY`는 문서마다 한 번만 둘 수 있다.

문서 구조 전체는 [문서](../document.md)에 있다.

| Codec | 이름 | 뜻 |
|---|---|---|
| `0x1C0L~0x1C2L` | [DOC-1WORD / 2WORD / 4WORD](0x1C0L-doc-1word.md) | 전체 길이를 지정해 문서를 연다 |
| `0x1C3L` | [BODY](0x1C3L-body.md) | HEAD를 끝내고 BODY를 연다 |
| `0x1C4L` | [END](0x1C4L-end.md) | 문서를 닫는다 |

자세한 규칙은 [문서](../document.md)에 있다.

## 정의

Meta 정의 클래스(Codec `0x1C5L~0x1CAL`)는 해석 선언이다. 선언은 해석 규칙을 바꾸므로 모든 디코더가 처리해야 한다. 선언의 범위는 그 문서다.

- `SPEC-VERSION`은 나머지 레코드를 어떻게 읽을지 정하므로 내장 Value 없이 정수만 둔다. GEUL v1은 `0x0001`(레코드 `1C51 0001`)이다.
- `DOC-ID`는 그 문서 자신을 가리키는 `DOC-POINTER`(Issuer, 문서 ID, 버전 `0`)다. 코덱 문서는 `CODEC-POINTER`(Issuer, 코덱 ID, 버전 `0`)다. 없으면 이름 없는 문서이며 내용 해시로만 가리킬 수 있다.
- 문서 이름 주소는 없다. 사람이 읽는 제목은 서술 `LABEL`로 붙인다([공표 주소와 버전 목록](../publishing.md#문서-이름)).

| Codec | 이름 | 뜻 |
|---|---|---|
| `0x1C5L` | [SPEC-VERSION](0x1C5L-spec-version.md) | 따르는 명세 판. 정수 하나 |
| `0x1C6L` | [PROFILE](0x1C6L-profile.md) | 적용 프로파일 |
| `0x1C7L` | [DOC-ID](0x1C7L-doc-id.md) | 이 문서의 식별자. 자기 자신을 가리키는 DOC-POINTER(버전 0). 코덱 문서는 CODEC-POINTER(버전 0) |
| `0x1C8L` | [EFFECTIVE-FROM](0x1C8L-effective-from.md) | 이 버전의 시행일. 없으면 공표 시각 |
| `0x1C9L` | [EFFECTIVE-UNTIL](0x1C9L-effective-until.md) | 이 버전의 유효기간 끝(한시법). 없으면 다음 버전이 시행될 때까지 |
| `0x1CAL` | [DEFAULT-LANGUAGE](0x1CAL-default-language.md) | 기본 언어 |

- 문서 이름 주소는 없다([공표 주소와 버전 목록](../publishing.md#문서-이름)). 사람이 읽는 제목은 BODY의 LABEL로 붙인다.

## 출처

Meta 출처 클래스(Codec `0x1CBL~0x1D0L`)는 문서를 누가, 언제 만들고 기록했는지 적는다.

- 작성자·기록자와 그 시각은 git의 author·committer 모델을 따른다(`AUTHOR`·`CREATED-AT`, `RECORDED-BY`·`RECORDED-AT`).
- 출처는 지워도 서술 내용이 바뀌지 않는다. 신뢰 판단의 재료만 사라진다.
- 원천 자료는 이 클래스에 없다. 문서 전체의 원천은 HEAD에, 개별 레코드의 원천은 BODY에 근거 Edge [SOURCE](../edge/0x0C0L-source.md)로 쓴다. 원문 안의 대응 범위, 확보 시각, 원문 해시는 그 SOURCE에 붙는 QUALIFIER다(쪽 P304·절 P958, 조회일 P813, 체크섬 P4092).
- 원천에 딸린 성질(원문 범위, 확보 시각)을 Meta로 두면 원천이 여럿일 때 어느 원천의 것인지 정할 수 없다. 그래서 SOURCE를 Target으로 하는 QUALIFIER로 쓴다.

| Codec | 이름 | 뜻 |
|---|---|---|
| `0x1CBL` | [AUTHOR](0x1CBL-author.md) | 작성자 (Reference) |
| `0x1CCL` | [CO-AUTHOR](0x1CCL-co-author.md) | 공동 작성자 |
| `0x1CDL` | [CREATED-AT](0x1CDL-created-at.md) | 작성 시각 |
| `0x1CEL` | [MODIFIED-AT](0x1CEL-modified-at.md) | 수정 시각 |
| `0x1CFL` | [RECORDED-BY](0x1CFL-recorded-by.md) | 기록한 주체 |
| `0x1D0L` | [RECORDED-AT](0x1D0L-recorded-at.md) | 기록한 시각 |

- 원천 자료는 Meta가 아니라 HEAD의 근거 Edge [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처)(Target `0`)로 쓰고, 원문 범위·확보 시각·원문 해시는 그 SOURCE에 붙는 QUALIFIER로 쓴다.

## 계보

Meta 계보 클래스(Codec `0x1D1L~0x1DDL`)는 문서가 무엇에서 어떻게 나왔는지 적는다. 계보는 git의 커밋 모델을 따르며, 커밋에 해당하는 단위가 문서다.

- **내용 해시**는 문서 한 벌의 내용을 가리킨다(git commit id). 여는 레코드(`DOC-*`)부터 `END` 직전까지의 SHA-256이며 검증 클래스(섹션 15의 `C >= 5`, `w >= 0x1E50`) 레코드는 계산에서 뺀다.
- **버전 ID**는 이름 있는 문서 안에서 공표 순서대로 1부터 매기는 2 WORD 정수다. `0`은 버전을 적지 않았다는 뜻이다.
- 계보 Meta는 내용 해시로 버전을 가리킨다. 문서 안의 `PARENT`도 해시에 들어가므로 내용 해시는 이력 전체를 잇는 해시 사슬이 된다.
- 이력은 지우지 않는다. 고친 내용은 새 버전으로 낸다. branch처럼 바뀌는 포인터는 문서에 두지 않는다.
- `DELTA-BASE`·`DELTA-REMOVE`는 버전을 기준 버전에 대한 diff로 저장하는 형식이다. 버전은 언제나 스냅숏으로 정의한다.

개정 규칙은 [문서](../document.md)에 있다.

계보는 git의 커밋 모델을 따른다. 커밋에 해당하는 단위가 문서다.

| Codec | 이름 | 뜻 |
|---|---|---|
| `0x1D1L` | [PARENT](0x1D1L-parent.md) | 직전 버전의 내용 해시. 여럿이면 병합 |
| `0x1D2L` | [DERIVED-FROM](0x1D2L-derived-from.md) | 다른 계보의 자료에서 파생 |
| `0x1D3L` | [GENERATED-BY](0x1D3L-generated-by.md) | 생성 주체(사람, 모델, 규칙 엔진) |
| `0x1D4L` | [TRANSFORMED-BY](0x1D4L-transformed-by.md) | 변환 도구와 그 소스 버전(커밋 다이제스트) |
| `0x1D5L` | [CHERRY-PICKED-FROM](0x1D5L-cherry-picked-from.md) | 가져온 변경의 원 버전 |
| `0x1D6L` | [REVERTS](0x1D6L-reverts.md) | 되돌린 대상 버전 |
| `0x1D7L` | [REPLACES](0x1D7L-replaces.md) | 고쳐 쓴 대상 버전. 원 버전은 지우지 않는다 |
| `0x1D8L` | [SQUASHED-FROM](0x1D8L-squashed-from.md) | 하나로 합친 원 버전들 |
| `0x1D9L` | [MESSAGE](0x1D9L-message.md) | 변경 이유. 언어마다 하나 |
| `0x1DAL` | [TAG](0x1DAL-tag.md) | 버전에 붙인 불변 이름 |
| `0x1DBL` | [DELTA-BASE](0x1DBL-delta-base.md) | 이 파일은 기준 버전에 대한 diff다 |
| `0x1DCL` | [DELTA-REMOVE](0x1DCL-delta-remove.md) | diff에서 뺄 LOCAL ID 목록 |
| `0x1DDL` | [NEXT-LOCAL-ID](0x1DDL-next-local-id.md) | 다음에 배정할 LOCAL ID. 버전 목록 문서에 둔다 |

- 이력은 지우지 않는다. 고친 내용은 새 버전으로 낸다.
- branch처럼 바뀌는 포인터는 문서에 두지 않는다. 저장소와 색인이 관리한다.

## 검증

Meta 검증 클래스(Codec `0x1E5L~0x1E9L`)는 문서를 믿을 수 있는지 판단할 재료를 적는다. 자체 발급 Issuer의 공개키, 서명, 기여 권리 확인, 신뢰도, 문서 전체의 판정 결과다.

- 검증 클래스는 내용 해시 계산에서 빠진다. 그래서 서명을 문서 안에 둬도, 서명을 여럿 더해도 내용 해시가 바뀌지 않는다(git `gpgsig`와 같은 방식).
- 검증 클래스는 섹션 15에서 `C >= 5`, 곧 `w >= 0x1E50`인 레코드라 코덱북 없이 해시를 계산할 수 있다. 뒤 Reserved `0x1EAL~0x1FFL`도 검증 전용이라 해시에서 빠진다.
- 노드·레코드 단위의 판정은 [TOULMIN](../toulmin/_index.md) Edge `VERDICT`(`0x118L`)가 맡는다.

| Codec | 이름 | 뜻 |
|---|---|---|
| `0x1E5L` | [ISSUER-KEY](0x1E5L-issuer-key.md) | 자체 발급 Issuer의 서명 알고리즘과 공개키 |
| `0x1E6L` | [SIGNATURE](0x1E6L-signature.md) | 내용 해시에 대한 서명. 알고리즘, 서명자, 서명 |
| `0x1E7L` | [SIGNED-OFF](0x1E7L-signed-off.md) | 기여 권리 확인 |
| `0x1E8L` | [CONFIDENCE](0x1E8L-confidence.md) | 신뢰도 |
| `0x1E9L` | [VERDICT](0x1E9L-verdict.md) | 문서 전체의 판정 결과(Pass, Review, Fail) |

- 검증 클래스는 내용 해시 계산에서 빠진다. 그래서 서명을 문서 안에 둬도, 서명을 여럿 더해도 내용 해시가 바뀌지 않는다.

## 정책

Meta 정책 클래스(Codec `0x1DEL~0x1E3L`)는 문서를 어떻게 취급하는지 정한다. 라이선스, 공개 범위, 개인정보 등급, 보존 기한, 동의, 사용 제한이다.

- 정책은 해석을 바꾸지 않고 취급 방법을 정한다.
- 바이트열 안 저작물의 원래 라이선스는 `LICENSE`로 기록한다.

| Codec | 이름 | 뜻 |
|---|---|---|
| `0x1DEL` | [LICENSE](0x1DEL-license.md) | 라이선스 |
| `0x1DFL` | [ACCESS](0x1DFL-access.md) | 공개 범위 |
| `0x1E0L` | [PRIVACY](0x1E0L-privacy.md) | 개인정보 등급 |
| `0x1E1L` | [RETENTION](0x1E1L-retention.md) | 보존 기한 |
| `0x1E2L` | [CONSENT](0x1E2L-consent.md) | 동의 범위와 근거 |
| `0x1E3L` | [USAGE](0x1E3L-usage.md) | 사용 제한 |

- 정책은 해석을 바꾸지 않고 취급 방법을 정한다.

## IMPORT

Meta IMPORT 클래스(Codec `0x1E4L`)는 외부 문서를 IMPORT ID로 가져온다. Codec은 `IMPORT-DOC`(`0x1E4L`) 하나다.

- IMPORT는 문서만 가져온다. 가져온 문서 안의 대상은 BODY의 Reference `EXTERNAL-POINTER-*`(IMPORT ID, LOCAL ID)로 가리킨다([Reference](../reference/_index.md)).
- 버전 ID를 적으면 그 판본에, `0`이면 해석 시점의 최신 판본에 묶인다. 공표 문서는 버전을 적는다.
- 가져온 문서의 HEAD는 가져오지 않는다. Reference·Value 레코드는 가져오지 않고 복사한다.

```
TAG WORD          0001 1110 0100 LLLL      IMPORT-DOC (0x1E4L)
[Length 확장 TAG]
문서              DOC-POINTER 레코드 (Issuer, 문서 ID, 버전 ID). 코덱 문서는 CODEC-POINTER
IMPORT ID         나머지. 가장 짧은 폭의 정수
```

- [IMPORT-DOC](0x1E4L-import-doc.md)(`0x1E4L`) 하나만 쓴다. IMPORT는 문서만 가져온다. 가져온 문서 안의 대상은 BODY의 `EXTERNAL-POINTER-*`(IMPORT ID, LOCAL ID)로 가리킨다.
- 버전 ID를 적으면 그 판본에, `0`이면 해석 시점의 최신 판본에 묶인다. 공표 문서는 버전을 적는다.
- 한 문서에서 같은 IMPORT ID를 두 번 배정하지 않는다.
- 가져온 문서의 HEAD는 가져오지 않는다. 그 문서의 대상은 그 문서의 선언대로 해석한다.

예: Issuer `0x00000002`의 문서 `0x0000000000000002` 최신 버전을 IMPORT ID 1로 가져온다.

```
1E4A 0418 0000 0002 0000 0000 0000 0002 0000 0000 0001
```
