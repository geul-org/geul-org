---
title: "EXPR"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EXPR는 PREDICATE-DECLARE(Codec 0x61)가 쓰는 조건식 레이아웃이다. 자체 라벨 표와 전위 순서로 펼친 식 레코드로 조건식 트리를 담는다."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXPR는 TANGEUL Rules의 조건식을 쓰는 레이아웃이다. Codec `0x61` PREDICATE-DECLARE(술어 선언)가 쓴다. 조건식 트리를 전위 순서로 펼쳐 담고, 식 안의 문자열은 레코드 안의 라벨 표로 가리킨다. 그래서 TEXT 레코드 없이 혼자 완결된다.

## 레이아웃

```
ID                     LOCAL Reference 레코드 (Edge Id)
노드 수 1 WORD          식 레코드의 전체 개수
라벨 수 1 WORD
라벨 × 라벨 수          UTF8-TEXT Value 레코드
식 레코드 × 노드 수      전위 순서
```

- 라벨은 필드 이름, 문자열 값, 경로 단계, 함수 이름 같은 문자열이다. 빈 문자열도 라벨이 된다. 식 레코드는 라벨을 0부터 매긴 인덱스(1 WORD)로 가리킨다.
- 식 레코드는 부모 다음에 자식을 차례로 둔다(전위 순서). 각 레코드의 자식 수와 이 순서로 트리가 하나로 정해진다.

## 식 레코드

식 레코드는 헤더 1 WORD로 시작한다.

```
헤더 1 WORD      종류 하위 2비트 (b15–14) | 종류 상위 1비트 (b13) | 자식 수 13비트 (b12–0)
```

종류 = `(b13 << 2) | b15–14`이다.

| 종류 | 이름 | 자식 수 | 헤더 뒤 |
|---|---|---|---|
| 0 | COMPARE | 0 | 비교 연산자 1 WORD, 필드 라벨 1 WORD, 값 자리 |
| 1 | LOGIC | n | 논리 연산자 1 WORD |
| 2 | NOT | 1 | 없음 |
| 3 | EITHER | n | 없음 |
| 4 | EXISTS | 1 | 양화 연산자 1 WORD, 대상 피연산자, 묶는 이름 라벨 1 WORD |
| 5 | CALL | 0 | 별칭 라벨 1 WORD, 함수 이름 라벨 1 WORD |
| 6 | COMPARE-X | 0 | 비교 연산자 1 WORD, 필드 라벨 1 WORD, 왼쪽 표지 1 WORD [+ 피연산자], 값 자리 |
| 7 | 예약 | | |

- 자식 레코드는 헤더 뒤 필드 다음에 이어진다. EXISTS의 자식은 조건 하나다.
- COMPARE는 양쪽에 피연산자가 없는 비교 `<필드> <연산자> <값>`이다. 피연산자가 한쪽이라도 있으면 COMPARE-X를 쓴다.
- COMPARE-X의 왼쪽 표지가 `1`이면 피연산자가 뒤따르고, `0`이면 없다. 왼쪽 피연산자가 있으면 필드 라벨은 빈 문자열이다.
- CALL은 술어 자리의 호스트 함수 호출이다. 이 문서의 함수면 별칭 라벨이 빈 문자열이다.

### 값 자리

```
값 종류 1 WORD    0 수, 1 문자열, 2 피연산자
값                0: UNSIGNED-INTEGER Value 레코드
                  1: 라벨 1 WORD
                  2: 피연산자 (COMPARE-X에서만)
```

- 값 문자열이 음이 아닌 정수의 정규 10진 표기와 정확히 같으면 UNSIGNED-INTEGER Value로 쓴다. 그 밖의 값은 라벨로 쓴다. 그래서 값 문자열이 그대로 되살아난다.

### 피연산자

```
피연산자 종류 1 WORD   0 경로, 1 기준 참조, 2 함수 호출
경로·기준 참조         단계 수 1 WORD + 라벨 1 WORD × 단계 수
함수 호출              별칭 라벨 1 WORD + 함수 이름 라벨 1 WORD
```

- 경로는 입력 데이터의 경로, 기준 참조는 `with`로 주입한 판단 기준(SPEC)의 경로다.

### 연산자 코드

| 코드 | 비교 연산자 |
|---|---|
| `0x0301` | is empty |
| `0x0302` | is not empty |
| `0x0303` | equals |
| `0x0304` | is in |
| `0x0305` | is greater than |
| `0x0306` | is less than |
| `0x0307` | is at most |
| `0x0308` | is at least |

| 코드 | 논리 연산자 |
|---|---|
| `0x0311` | and |
| `0x0312` | or |

| 코드 | 양화 연산자 |
|---|---|
| `0x0321` | any |

### 미상 입력의 평가

비교 연산자는 입력이 자리 표지일 때 3값(참, 거짓, 미정 U)으로 평가한다. NO-VALUE는 `is empty`가 참이고 다른 비교는 거짓이다. UNKNOWN-VALUE는 `is not empty`가 참이고 `equals`·`is in`·크기 비교는 U다. ABSENT와 서술 없음은 모든 연산자가 U다. 논리 연산자는 Kleene 강 3값을 따르고, 술어가 U이면 노드 판정은 Review다. 이 평가는 고정 핵심이다([TOULMIN](/ko/grammar/edge/toulmin/#미상-위에서-판정하기)).

## 해석과 유효성

- 노드 수는 펼친 식 레코드 수와 같아야 한다. 마지막 식 레코드를 읽은 위치가 레코드 끝과 정확히 맞아야 한다.
- 라벨 인덱스가 라벨 수 이상이면 거부한다.
- NOT와 EXISTS의 자식 수는 1이어야 한다.
- 모르는 종류(7)나 모르는 값 종류·피연산자 종류는 거부한다.
- 자식 수는 13비트(최대 8191)다.

## 관련 페이지

- [TOULMIN](/ko/grammar/edge/toulmin/), [NODE](/ko/grammar/edge/toulmin/node/)
- [UTF8-TEXT](/ko/grammar/value/text/utf8-text/), [UNSIGNED-INTEGER](/ko/grammar/value/numeric/unsigned-integer/)
