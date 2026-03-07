---
title: "AST 엣지"
weight: 80
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "AST", "programming", "PathGEUL"]
summary: "프로그래밍 언어의 AST를 GEUL 그래프로 표현하는 Edge 타입. 6비트로 64개 언어를 분류하고, 8비트로 256개 AST 노드 타입을 인코딩한다. PathGEUL 쿼리 언어를 포함한다."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

AST Edge는 **프로그래밍 언어의 AST(Abstract Syntax Tree)**를 GEUL 그래프로 표현하는 Edge 타입이다.

| 특성 | 설명 |
|------|------|
| **다중 언어 지원** | 6비트로 64개 언어 표현 |
| **공통 AST 노드** | 언어 간 동일 개념은 동일 코드 |
| **계통 기반 분류** | 우아한 열화(graceful degradation) 지원 |
| **PathGEUL 통합** | GEUL 그래프 탐색 언어 포함 |

## 패킷 구조

```
1st WORD (16비트)
┌─────────────────────┬────────────────────┐
│       Prefix        │        언어        │
│       10bit         │        6bit        │
└─────────────────────┴────────────────────┘

2nd WORD (16비트)
┌─────────────────────────┬───────────────────┐
│     AST 노드 타입        │       예약        │
│         8bit            │       8bit        │
└─────────────────────────┴───────────────────┘

3rd WORD (16비트)
┌─────────────────────────────────────────────┐
│                  Edge TID                   │
│                   16bit                     │
└─────────────────────────────────────────────┘

4th+ WORD: 자식 TID들 (가변, 종결 마커 0x0000으로 끝)
```

| 필드 | 비트 | 크기 | 설명 |
|------|------|------|------|
| Prefix | 1-10 | 10 | `0001 000 001` (AST Edge) |
| 언어 | 11-16 | 6 | 프로그래밍 언어 코드 |
| AST 노드 타입 | 17-24 | 8 | 노드 종류 (3+5 분할) |
| 예약 | 25-32 | 8 | 미래 확장용 (현재 0x00) |
| Edge TID | 33-48 | 16 | 이 Edge의 고유 식별자 |
| 자식 TID | 49+ | 16×N | 자식 노드 참조 |

워드 수: 최소 3워드(리프 노드) ~ 일반 4-8워드 ~ 제한 없음

## 언어 코드 (6비트)

계통 기반 분류. bit1-2가 대분류(패러다임), bit3-6이 세부 언어.

### 시스템/저수준 (00xxxx)

| 코드 | 언어 | 설명 |
|------|------|------|
| 000000 | **Abstract** | 모든 언어의 공통 AST |
| 000001 | C | 시스템 언어 원형 |
| 000010 | C++ | C 확장 |
| 000011 | Rust | 현대 시스템 |
| 000100 | Go | 현대 시스템 |
| 000101 | Zig | 현대 시스템 |
| 000110 | Assembly | 최저수준 |
| 000111 | D | 시스템 |
| 001000 | Nim | 시스템 |

### 응용/VM (01xxxx)

| 코드 | 언어 | 설명 |
|------|------|------|
| 010000 | Java | VM 계열 원형 |
| 010001 | C# | .NET |
| 010010 | Kotlin | JVM |
| 010011 | Scala | JVM+함수형 |
| 010100 | Swift | Apple |
| 010101 | Dart | Flutter |
| 010110 | Groovy | JVM |
| 010111 | Clojure | JVM+Lisp |

### 스크립트/동적 (10xxxx)

| 코드 | 언어 | 설명 |
|------|------|------|
| 100000 | Python | 범용 스크립트 원형 |
| 100001 | JavaScript | 웹 |
| 100010 | TypeScript | JS+타입 |
| 100011 | Ruby | 범용 |
| 100100 | PHP | 웹 서버 |
| 100101 | Lua | 임베디드 |
| 100110 | Perl | 텍스트 처리 |
| 100111 | R | 통계 |
| 101000 | Julia | 과학 계산 |
| 101001 | MATLAB | 수치 해석 |

### 선언적/함수형/기타 (11xxxx)

| 코드 | 언어 | 설명 |
|------|------|------|
| 110000 | SQL | 쿼리 |
| 110001 | Haskell | 순수 함수형 |
| 110010 | OCaml | ML 계열 |
| 110011 | F# | .NET 함수형 |
| 110100 | Elixir | BEAM |
| 110101 | Erlang | BEAM |
| 110110 | Shell | Bash/Zsh |
| 110111 | PowerShell | Windows |
| 111000 | WASM | 바이트코드 |
| 111001 | LLVM IR | 중간 표현 |
| 111010 | HTML | 마크업 |
| 111011 | CSS | 스타일 |
| 111100 | JSON | 데이터 |
| 111101 | YAML | 데이터 |
| 111110 | **PathGEUL** | GEUL 그래프 탐색 언어 |
| 111111 | **확장 워드** | 추가 언어 (3rd 워드에 명시) |

**우아한 열화:** 비트 손실 시 상위 계통으로 수렴 → 최종적으로 Abstract(000000)로 폴백.

## AST 노드 타입 (8비트)

3비트 대분류 + 5비트 세부타입으로 분할.

### 대분류

| 코드 | 대분류 | 설명 |
|------|--------|------|
| 000 | Declaration | 선언 (함수, 변수, 타입) |
| 001 | Statement | 문장 (제어문, 반복문) |
| 010 | Expression | 표현식 (연산, 호출) |
| 011 | Type | 타입 표현 |
| 100 | Pattern | 패턴 매칭 |
| 101 | Modifier | 수식어 (접근제어, async) |
| 110 | Structure | 구조 (블록, 모듈) |
| 111 | Language-specific | 언어 고유 노드 |

### Declaration (000xxxxx)

| 코드 | 노드 | Go | Python | C |
|------|------|-----|--------|---|
| 000 00000 | FuncDecl | FuncDecl | FunctionDef | FunctionDecl |
| 000 00001 | VarDecl | GenDecl(var) | Assign | VarDecl |
| 000 00010 | ConstDecl | GenDecl(const) | - | VarDecl(const) |
| 000 00011 | TypeDecl | TypeSpec | - | TypedefDecl |
| 000 00100 | StructDecl | StructType | ClassDef | RecordDecl |
| 000 00101 | InterfaceDecl | InterfaceType | ClassDef(ABC) | - |
| 000 00110 | EnumDecl | - | Enum | EnumDecl |
| 000 00111 | ParamDecl | Field | arg | ParmVarDecl |
| 000 01000 | MethodDecl | FuncDecl(recv) | FunctionDef | CXXMethodDecl |
| 000 01001 | ImportDecl | ImportSpec | Import | #include |
| 000 01010 | PackageDecl | package | - | - |
| 000 01011 | FieldDecl | Field | - | FieldDecl |
| 000 01100 | LabelDecl | LabeledStmt | - | LabelDecl |

### Statement (001xxxxx)

| 코드 | 노드 | 의미 |
|------|------|------|
| 001 00000 | IfStmt | 조건문 |
| 001 00001 | ForStmt | for 루프 |
| 001 00010 | RangeStmt | 이터레이터 루프 |
| 001 00011 | WhileStmt | while 루프 |
| 001 00100 | SwitchStmt | switch/match |
| 001 00101 | CaseClause | case 절 |
| 001 00110 | ReturnStmt | 반환 |
| 001 00111 | BreakStmt | 탈출 |
| 001 01000 | ContinueStmt | 계속 |
| 001 01001 | GotoStmt | goto |
| 001 01010 | BlockStmt | 블록 { } |
| 001 01011 | ExprStmt | 표현식 문장 |
| 001 01100 | AssignStmt | 대입 |
| 001 01101 | DeclStmt | 선언 문장 |
| 001 01110 | TryStmt | 예외 처리 |
| 001 01111 | ThrowStmt | 예외 발생 |
| 001 10000 | DeferStmt | defer |
| 001 10001 | GoStmt | go |
| 001 10010 | SelectStmt | select |
| 001 10011 | WithStmt | with |
| 001 10100 | AssertStmt | assert |
| 001 10101 | PassStmt | pass |

### Expression (010xxxxx)

| 코드 | 노드 | 의미 |
|------|------|------|
| 010 00000 | BinaryExpr | 이항 연산 |
| 010 00001 | UnaryExpr | 단항 연산 |
| 010 00010 | CallExpr | 함수 호출 |
| 010 00011 | IndexExpr | 인덱스 접근 a[i] |
| 010 00100 | SliceExpr | 슬라이스 a[i:j] |
| 010 00101 | SelectorExpr | 필드 접근 a.b |
| 010 00110 | Ident | 식별자 |
| 010 00111 | BasicLit | 기본 리터럴 |
| 010 01000 | CompositeLit | 복합 리터럴 |
| 010 01001 | FuncLit | 람다/익명함수 |
| 010 01010 | ParenExpr | 괄호 (a) |
| 010 01011 | StarExpr | 포인터 *a |
| 010 01100 | UnaryAddr | 주소 &a |
| 010 01101 | TypeAssertExpr | 타입 단언 |
| 010 01110 | KeyValueExpr | key: value |
| 010 01111 | TernaryExpr | 삼항 연산 |
| 010 10000 | ListComp | 리스트 컴프리헨션 |
| 010 10001 | DictComp | 딕트 컴프리헨션 |
| 010 10010 | GeneratorExpr | 제너레이터 |
| 010 10011 | AwaitExpr | await |
| 010 10100 | YieldExpr | yield |
| 010 10101 | SendExpr | 채널 송신 <- |
| 010 10110 | RecvExpr | 채널 수신 <-ch |

### Type (011xxxxx)

| 코드 | 노드 | 의미 |
|------|------|------|
| 011 00000 | IdentType | 이름 타입 |
| 011 00001 | PointerType | 포인터 *T |
| 011 00010 | ArrayType | 배열 [N]T |
| 011 00011 | SliceType | 슬라이스 []T |
| 011 00100 | MapType | 맵 map[K]V |
| 011 00101 | ChanType | 채널 chan T |
| 011 00110 | FuncType | 함수 타입 |
| 011 00111 | StructType | 구조체 타입 |
| 011 01000 | InterfaceType | 인터페이스 타입 |
| 011 01001 | UnionType | 유니온 A \| B |
| 011 01010 | OptionalType | 옵셔널 T? |
| 011 01011 | GenericType | 제네릭 T[U] |
| 011 01100 | TupleType | 튜플 (A, B) |

### Pattern (100xxxxx)

| 코드 | 노드 | 의미 |
|------|------|------|
| 100 00000 | WildcardPattern | _ |
| 100 00001 | IdentPattern | 이름 바인딩 |
| 100 00010 | LiteralPattern | 리터럴 매칭 |
| 100 00011 | TuplePattern | 튜플 (a, b) |
| 100 00100 | ListPattern | 리스트 [a, b] |
| 100 00101 | StructPattern | 구조체 {a, b} |
| 100 00110 | OrPattern | a \| b |
| 100 00111 | GuardPattern | 가드 조건 |

### Modifier (101xxxxx)

| 코드 | 노드 | 의미 |
|------|------|------|
| 101 00000 | Public | public/exported |
| 101 00001 | Private | private |
| 101 00010 | Protected | protected |
| 101 00011 | Static | static |
| 101 00100 | Const | const |
| 101 00101 | Async | async |
| 101 00110 | Volatile | volatile |
| 101 00111 | Inline | inline |
| 101 01000 | Virtual | virtual |
| 101 01001 | Abstract | abstract |
| 101 01010 | Final | final |

### Structure (110xxxxx)

| 코드 | 노드 | 의미 |
|------|------|------|
| 110 00000 | File | 파일 (최상위) |
| 110 00001 | Module | 모듈 |
| 110 00010 | Package | 패키지 |
| 110 00011 | Namespace | 네임스페이스 |
| 110 00100 | Block | 블록 |
| 110 00101 | CommentGroup | 주석 그룹 |
| 110 00110 | Comment | 주석 |
| 110 00111 | Directive | 지시어 (#pragma) |

### Language-specific (111xxxxx)

각 언어 고유 노드. 32개 여유.

## PathGEUL (111110)

PathGEUL은 GEUL 그래프를 탐색하는 쿼리 언어다. XPath가 XML을 탐색하듯, PathGEUL은 GEUL 그래프를 탐색한다.

언어 코드 `111110`일 때, 8비트 AST 노드 타입은 **쿼리 연산자**로 재해석된다.

| 코드 | 연산 | XPath 대응 | 설명 |
|------|------|------------|------|
| 00000000 | Root | / | 루트 노드 |
| 00000001 | Child | /child | 직접 자식 |
| 00000010 | Descendant | // | 모든 후손 |
| 00000011 | Parent | .. | 부모 |
| 00000100 | Ancestor | ancestor:: | 모든 조상 |
| 00000101 | Sibling | sibling:: | 형제 |
| 00010000 | FilterType | [type=...] | 타입 필터 |
| 00100000 | FilterProp | [@prop=...] | 속성 필터 |
| 01000000 | Union | \| | 합집합 |
| 01000001 | Intersect | & | 교집합 |

## 예시

### Go 함수 선언

```go
func Add(a, b int) int {
    return a + b
}
```

```
AST Edge (FuncDecl):
  1st: [Prefix 10bit] [000100]       - Prefix + Go
  2nd: [000 00000] [00000000]        - FuncDecl + 예약
  3rd: [TID: 0x0010]                 - 이 Edge TID
  4th: [TID: 0x0011]                 - Name "Add"
  5th: [TID: 0x0012]                 - Params
  6th: [TID: 0x0013]                 - Results
  7th: [TID: 0x0014]                 - Body
  8th: [0x0000]                      - 종결

총: 8워드
```

### Python 함수 정의

```python
def greet(name: str) -> str:
    return f"Hello, {name}"
```

```
AST Edge (FuncDecl):
  1st: [Prefix 10bit] [100000]       - Prefix + Python
  2nd: [000 00000] [00000000]        - FuncDecl + 예약
  3rd: [TID: 0x0020]                 - 이 Edge TID
  4th: [TID: 0x0021]                 - Name "greet"
  5th: [TID: 0x0022]                 - Params
  6th: [TID: 0x0023]                 - Returns
  7th: [TID: 0x0024]                 - Body
  8th: [0x0000]                      - 종결

총: 8워드
```

### 리프 노드 (식별자)

```
AST Edge (Ident):
  1st: [Prefix 10bit] [000100]       - Prefix + Go
  2nd: [010 00110] [00000000]        - Ident + 예약
  3rd: [TID: 0x0030]                 - 이 Edge TID
  4th: [0x0000]                      - 종결 (자식 없음)

총: 4워드
```
