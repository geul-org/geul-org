---
title: "AST Edge"
weight: 80
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "AST", "programming", "PathGEUL"]
summary: "An Edge type that represents programming language ASTs as GEUL graphs. Classifies 64 languages with 6 bits and encodes 256 AST node types with 8 bits. Includes the PathGEUL query language."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

AST Edge is an Edge type that represents **programming language ASTs (Abstract Syntax Trees)** as GEUL graphs.

| Property | Description |
|----------|-------------|
| **Multi-language support** | 64 languages in 6 bits |
| **Common AST nodes** | Same concept across languages uses the same code |
| **Lineage-based classification** | Supports graceful degradation |
| **PathGEUL integration** | Includes GEUL graph traversal language |

## Packet Structure

```
1st WORD (16 bits)
┌─────────────────────┬────────────────────┐
│       Prefix        │     Language       │
│       10bit         │        6bit        │
└─────────────────────┴────────────────────┘

2nd WORD (16 bits)
┌─────────────────────────┬───────────────────┐
│     AST Node Type       │     Reserved      │
│         8bit            │       8bit        │
└─────────────────────────┴───────────────────┘

3rd WORD (16 bits)
┌─────────────────────────────────────────────┐
│                  Edge TID                   │
│                   16bit                     │
└─────────────────────────────────────────────┘

4th+ WORD: Child TIDs (variable, terminated by 0x0000)
```

| Field | Bits | Size | Description |
|-------|------|------|-------------|
| Prefix | 1-10 | 10 | `0001 000 001` (AST Edge) |
| Language | 11-16 | 6 | Programming language code |
| AST Node Type | 17-24 | 8 | Node kind (3+5 split) |
| Reserved | 25-32 | 8 | For future extension (currently 0x00) |
| Edge TID | 33-48 | 16 | Unique identifier for this Edge |
| Child TIDs | 49+ | 16xN | Child node references |

Word count: minimum 3 words (leaf node) ~ typical 4-8 words ~ unlimited

## Language Codes (6 bits)

Lineage-based classification. Bits 1-2 are the major category (paradigm), bits 3-6 are the specific language.

### System/Low-level (00xxxx)

| Code | Language | Description |
|------|----------|-------------|
| 000000 | **Abstract** | Common AST for all languages |
| 000001 | C | System language archetype |
| 000010 | C++ | C extension |
| 000011 | Rust | Modern systems |
| 000100 | Go | Modern systems |
| 000101 | Zig | Modern systems |
| 000110 | Assembly | Lowest level |
| 000111 | D | Systems |
| 001000 | Nim | Systems |

### Application/VM (01xxxx)

| Code | Language | Description |
|------|----------|-------------|
| 010000 | Java | VM family archetype |
| 010001 | C# | .NET |
| 010010 | Kotlin | JVM |
| 010011 | Scala | JVM+functional |
| 010100 | Swift | Apple |
| 010101 | Dart | Flutter |
| 010110 | Groovy | JVM |
| 010111 | Clojure | JVM+Lisp |

### Scripting/Dynamic (10xxxx)

| Code | Language | Description |
|------|----------|-------------|
| 100000 | Python | General-purpose script archetype |
| 100001 | JavaScript | Web |
| 100010 | TypeScript | JS+types |
| 100011 | Ruby | General-purpose |
| 100100 | PHP | Web server |
| 100101 | Lua | Embedded |
| 100110 | Perl | Text processing |
| 100111 | R | Statistics |
| 101000 | Julia | Scientific computing |
| 101001 | MATLAB | Numerical analysis |

### Declarative/Functional/Other (11xxxx)

| Code | Language | Description |
|------|----------|-------------|
| 110000 | SQL | Query |
| 110001 | Haskell | Pure functional |
| 110010 | OCaml | ML family |
| 110011 | F# | .NET functional |
| 110100 | Elixir | BEAM |
| 110101 | Erlang | BEAM |
| 110110 | Shell | Bash/Zsh |
| 110111 | PowerShell | Windows |
| 111000 | WASM | Bytecode |
| 111001 | LLVM IR | Intermediate representation |
| 111010 | HTML | Markup |
| 111011 | CSS | Styling |
| 111100 | JSON | Data |
| 111101 | YAML | Data |
| 111110 | **PathGEUL** | GEUL graph traversal language |
| 111111 | **Extension word** | Additional languages (specified in 3rd word) |

**Graceful degradation:** On bit loss, converges to a parent lineage → ultimately falls back to Abstract (000000).

## AST Node Types (8 bits)

Split into 3-bit major category + 5-bit subtype.

### Major Categories

| Code | Category | Description |
|------|----------|-------------|
| 000 | Declaration | Declarations (function, variable, type) |
| 001 | Statement | Statements (control flow, loops) |
| 010 | Expression | Expressions (operations, calls) |
| 011 | Type | Type expressions |
| 100 | Pattern | Pattern matching |
| 101 | Modifier | Modifiers (access control, async) |
| 110 | Structure | Structure (block, module) |
| 111 | Language-specific | Language-specific nodes |

### Declaration (000xxxxx)

| Code | Node | Go | Python | C |
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

| Code | Node | Meaning |
|------|------|---------|
| 001 00000 | IfStmt | Conditional |
| 001 00001 | ForStmt | For loop |
| 001 00010 | RangeStmt | Iterator loop |
| 001 00011 | WhileStmt | While loop |
| 001 00100 | SwitchStmt | Switch/match |
| 001 00101 | CaseClause | Case clause |
| 001 00110 | ReturnStmt | Return |
| 001 00111 | BreakStmt | Break |
| 001 01000 | ContinueStmt | Continue |
| 001 01001 | GotoStmt | Goto |
| 001 01010 | BlockStmt | Block { } |
| 001 01011 | ExprStmt | Expression statement |
| 001 01100 | AssignStmt | Assignment |
| 001 01101 | DeclStmt | Declaration statement |
| 001 01110 | TryStmt | Exception handling |
| 001 01111 | ThrowStmt | Throw exception |
| 001 10000 | DeferStmt | Defer |
| 001 10001 | GoStmt | Go |
| 001 10010 | SelectStmt | Select |
| 001 10011 | WithStmt | With |
| 001 10100 | AssertStmt | Assert |
| 001 10101 | PassStmt | Pass |

### Expression (010xxxxx)

| Code | Node | Meaning |
|------|------|---------|
| 010 00000 | BinaryExpr | Binary operation |
| 010 00001 | UnaryExpr | Unary operation |
| 010 00010 | CallExpr | Function call |
| 010 00011 | IndexExpr | Index access a[i] |
| 010 00100 | SliceExpr | Slice a[i:j] |
| 010 00101 | SelectorExpr | Field access a.b |
| 010 00110 | Ident | Identifier |
| 010 00111 | BasicLit | Basic literal |
| 010 01000 | CompositeLit | Composite literal |
| 010 01001 | FuncLit | Lambda/anonymous function |
| 010 01010 | ParenExpr | Parentheses (a) |
| 010 01011 | StarExpr | Pointer *a |
| 010 01100 | UnaryAddr | Address &a |
| 010 01101 | TypeAssertExpr | Type assertion |
| 010 01110 | KeyValueExpr | key: value |
| 010 01111 | TernaryExpr | Ternary operation |
| 010 10000 | ListComp | List comprehension |
| 010 10001 | DictComp | Dict comprehension |
| 010 10010 | GeneratorExpr | Generator |
| 010 10011 | AwaitExpr | Await |
| 010 10100 | YieldExpr | Yield |
| 010 10101 | SendExpr | Channel send <- |
| 010 10110 | RecvExpr | Channel receive <-ch |

### Type (011xxxxx)

| Code | Node | Meaning |
|------|------|---------|
| 011 00000 | IdentType | Named type |
| 011 00001 | PointerType | Pointer *T |
| 011 00010 | ArrayType | Array [N]T |
| 011 00011 | SliceType | Slice []T |
| 011 00100 | MapType | Map map[K]V |
| 011 00101 | ChanType | Channel chan T |
| 011 00110 | FuncType | Function type |
| 011 00111 | StructType | Struct type |
| 011 01000 | InterfaceType | Interface type |
| 011 01001 | UnionType | Union A \| B |
| 011 01010 | OptionalType | Optional T? |
| 011 01011 | GenericType | Generic T[U] |
| 011 01100 | TupleType | Tuple (A, B) |

### Pattern (100xxxxx)

| Code | Node | Meaning |
|------|------|---------|
| 100 00000 | WildcardPattern | _ |
| 100 00001 | IdentPattern | Name binding |
| 100 00010 | LiteralPattern | Literal matching |
| 100 00011 | TuplePattern | Tuple (a, b) |
| 100 00100 | ListPattern | List [a, b] |
| 100 00101 | StructPattern | Struct {a, b} |
| 100 00110 | OrPattern | a \| b |
| 100 00111 | GuardPattern | Guard condition |

### Modifier (101xxxxx)

| Code | Node | Meaning |
|------|------|---------|
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

| Code | Node | Meaning |
|------|------|---------|
| 110 00000 | File | File (top-level) |
| 110 00001 | Module | Module |
| 110 00010 | Package | Package |
| 110 00011 | Namespace | Namespace |
| 110 00100 | Block | Block |
| 110 00101 | CommentGroup | Comment group |
| 110 00110 | Comment | Comment |
| 110 00111 | Directive | Directive (#pragma) |

### Language-specific (111xxxxx)

Language-specific nodes. 32 slots available.

## PathGEUL (111110)

PathGEUL is a query language for traversing GEUL graphs. Just as XPath traverses XML, PathGEUL traverses GEUL graphs.

When the language code is `111110`, the 8-bit AST node type is **reinterpreted as query operators**.

| Code | Operation | XPath equivalent | Description |
|------|-----------|------------------|-------------|
| 00000000 | Root | / | Root node |
| 00000001 | Child | /child | Direct child |
| 00000010 | Descendant | // | All descendants |
| 00000011 | Parent | .. | Parent |
| 00000100 | Ancestor | ancestor:: | All ancestors |
| 00000101 | Sibling | sibling:: | Siblings |
| 00010000 | FilterType | [type=...] | Type filter |
| 00100000 | FilterProp | [@prop=...] | Property filter |
| 01000000 | Union | \| | Union |
| 01000001 | Intersect | & | Intersection |

## Examples

### Go Function Declaration

```go
func Add(a, b int) int {
    return a + b
}
```

```
AST Edge (FuncDecl):
  1st: [Prefix 10bit] [000100]       - Prefix + Go
  2nd: [000 00000] [00000000]        - FuncDecl + Reserved
  3rd: [TID: 0x0010]                 - This Edge TID
  4th: [TID: 0x0011]                 - Name "Add"
  5th: [TID: 0x0012]                 - Params
  6th: [TID: 0x0013]                 - Results
  7th: [TID: 0x0014]                 - Body
  8th: [0x0000]                      - Terminator

Total: 8 words
```

### Python Function Definition

```python
def greet(name: str) -> str:
    return f"Hello, {name}"
```

```
AST Edge (FuncDecl):
  1st: [Prefix 10bit] [100000]       - Prefix + Python
  2nd: [000 00000] [00000000]        - FuncDecl + Reserved
  3rd: [TID: 0x0020]                 - This Edge TID
  4th: [TID: 0x0021]                 - Name "greet"
  5th: [TID: 0x0022]                 - Params
  6th: [TID: 0x0023]                 - Returns
  7th: [TID: 0x0024]                 - Body
  8th: [0x0000]                      - Terminator

Total: 8 words
```

### Leaf Node (Identifier)

```
AST Edge (Ident):
  1st: [Prefix 10bit] [000100]       - Prefix + Go
  2nd: [010 00110] [00000000]        - Ident + Reserved
  3rd: [TID: 0x0030]                 - This Edge TID
  4th: [0x0000]                      - Terminator (no children)

Total: 4 words
```
