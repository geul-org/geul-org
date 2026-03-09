---
title: "AST 边"
weight: 80
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "AST", "programming", "PathGEUL"]
summary: "将编程语言的AST表示为GEUL图的Edge类型。6位编码64种语言，8位编码256种AST节点类型。包含PathGEUL查询语言。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

AST Edge 是将**编程语言的 AST（Abstract Syntax Tree）**表示为 GEUL 图的 Edge 类型。

| 特性 | 说明 |
|------|------|
| **多语言支持** | 6位表达64种语言 |
| **通用 AST 节点** | 跨语言相同概念使用相同代码 |
| **谱系分类** | 支持优雅退化（graceful degradation） |
| **PathGEUL 集成** | 包含 GEUL 图遍历语言 |

## 数据包结构

```
1st WORD (16位)
┌─────────────────────┬────────────────────┐
│       Prefix        │       语言         │
│       10bit         │        6bit        │
└─────────────────────┴────────────────────┘

2nd WORD (16位)
┌─────────────────────────┬───────────────────┐
│     AST 节点类型         │       保留        │
│         8bit            │       8bit        │
└─────────────────────────┴───────────────────┘

3rd WORD (16位)
┌─────────────────────────────────────────────┐
│                  Edge TID                   │
│                   16bit                     │
└─────────────────────────────────────────────┘

4th+ WORD: 子节点 TID（可变，以终止标记 0x0000 结束）
```

| 字段 | 位 | 大小 | 说明 |
|------|------|------|------|
| Prefix | 1-10 | 10 | `0001 000 001` (AST Edge) |
| 语言 | 11-16 | 6 | 编程语言代码 |
| AST 节点类型 | 17-24 | 8 | 节点种类（3+5 分割） |
| 保留 | 25-32 | 8 | 未来扩展用（当前 0x00） |
| Edge TID | 33-48 | 16 | 此 Edge 的唯一标识符 |
| 子节点 TID | 49+ | 16×N | 子节点引用 |

字数：最少3字（叶节点）~ 一般4-8字 ~ 无限制

## 语言代码（6位）

基于谱系分类。bit1-2为大分类（范式），bit3-6为具体语言。

### 系统/底层（00xxxx）

| 代码 | 语言 | 说明 |
|------|------|------|
| 000000 | **Abstract** | 所有语言的通用 AST |
| 000001 | C | 系统语言原型 |
| 000010 | C++ | C 扩展 |
| 000011 | Rust | 现代系统 |
| 000100 | Go | 现代系统 |
| 000101 | Zig | 现代系统 |
| 000110 | Assembly | 最底层 |
| 000111 | D | 系统 |
| 001000 | Nim | 系统 |

### 应用/VM（01xxxx）

| 代码 | 语言 | 说明 |
|------|------|------|
| 010000 | Java | VM 系原型 |
| 010001 | C# | .NET |
| 010010 | Kotlin | JVM |
| 010011 | Scala | JVM+函数式 |
| 010100 | Swift | Apple |
| 010101 | Dart | Flutter |
| 010110 | Groovy | JVM |
| 010111 | Clojure | JVM+Lisp |

### 脚本/动态（10xxxx）

| 代码 | 语言 | 说明 |
|------|------|------|
| 100000 | Python | 通用脚本原型 |
| 100001 | JavaScript | Web |
| 100010 | TypeScript | JS+类型 |
| 100011 | Ruby | 通用 |
| 100100 | PHP | Web 服务器 |
| 100101 | Lua | 嵌入式 |
| 100110 | Perl | 文本处理 |
| 100111 | R | 统计 |
| 101000 | Julia | 科学计算 |
| 101001 | MATLAB | 数值分析 |

### 声明式/函数式/其他（11xxxx）

| 代码 | 语言 | 说明 |
|------|------|------|
| 110000 | SQL | 查询 |
| 110001 | Haskell | 纯函数式 |
| 110010 | OCaml | ML 系 |
| 110011 | F# | .NET 函数式 |
| 110100 | Elixir | BEAM |
| 110101 | Erlang | BEAM |
| 110110 | Shell | Bash/Zsh |
| 110111 | PowerShell | Windows |
| 111000 | WASM | 字节码 |
| 111001 | LLVM IR | 中间表示 |
| 111010 | HTML | 标记 |
| 111011 | CSS | 样式 |
| 111100 | JSON | 数据 |
| 111101 | YAML | 数据 |
| 111110 | **PathGEUL** | GEUL 图遍历语言 |
| 111111 | **扩展字** | 额外语言（第3字中指定） |

**优雅退化：** 位丢失时向上级谱系收敛 → 最终回退到 Abstract（000000）。

## AST 节点类型（8位）

3位大分类 + 5位细分类型。

### 大分类

| 代码 | 大分类 | 说明 |
|------|--------|------|
| 000 | Declaration | 声明（函数、变量、类型） |
| 001 | Statement | 语句（控制语句、循环语句） |
| 010 | Expression | 表达式（运算、调用） |
| 011 | Type | 类型表达 |
| 100 | Pattern | 模式匹配 |
| 101 | Modifier | 修饰符（访问控制、async） |
| 110 | Structure | 结构（块、模块） |
| 111 | Language-specific | 语言特有节点 |

### Declaration (000xxxxx)

| 代码 | 节点 | Go | Python | C |
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

| 代码 | 节点 | 含义 |
|------|------|------|
| 001 00000 | IfStmt | 条件语句 |
| 001 00001 | ForStmt | for 循环 |
| 001 00010 | RangeStmt | 迭代器循环 |
| 001 00011 | WhileStmt | while 循环 |
| 001 00100 | SwitchStmt | switch/match |
| 001 00101 | CaseClause | case 子句 |
| 001 00110 | ReturnStmt | 返回 |
| 001 00111 | BreakStmt | 跳出 |
| 001 01000 | ContinueStmt | 继续 |
| 001 01001 | GotoStmt | goto |
| 001 01010 | BlockStmt | 块 { } |
| 001 01011 | ExprStmt | 表达式语句 |
| 001 01100 | AssignStmt | 赋值 |
| 001 01101 | DeclStmt | 声明语句 |
| 001 01110 | TryStmt | 异常处理 |
| 001 01111 | ThrowStmt | 抛出异常 |
| 001 10000 | DeferStmt | defer |
| 001 10001 | GoStmt | go |
| 001 10010 | SelectStmt | select |
| 001 10011 | WithStmt | with |
| 001 10100 | AssertStmt | assert |
| 001 10101 | PassStmt | pass |

### Expression (010xxxxx)

| 代码 | 节点 | 含义 |
|------|------|------|
| 010 00000 | BinaryExpr | 二元运算 |
| 010 00001 | UnaryExpr | 一元运算 |
| 010 00010 | CallExpr | 函数调用 |
| 010 00011 | IndexExpr | 索引访问 a[i] |
| 010 00100 | SliceExpr | 切片 a[i:j] |
| 010 00101 | SelectorExpr | 字段访问 a.b |
| 010 00110 | Ident | 标识符 |
| 010 00111 | BasicLit | 基本字面量 |
| 010 01000 | CompositeLit | 复合字面量 |
| 010 01001 | FuncLit | Lambda/匿名函数 |
| 010 01010 | ParenExpr | 括号 (a) |
| 010 01011 | StarExpr | 指针 *a |
| 010 01100 | UnaryAddr | 取地址 &a |
| 010 01101 | TypeAssertExpr | 类型断言 |
| 010 01110 | KeyValueExpr | key: value |
| 010 01111 | TernaryExpr | 三元运算 |
| 010 10000 | ListComp | 列表推导 |
| 010 10001 | DictComp | 字典推导 |
| 010 10010 | GeneratorExpr | 生成器 |
| 010 10011 | AwaitExpr | await |
| 010 10100 | YieldExpr | yield |
| 010 10101 | SendExpr | 通道发送 <- |
| 010 10110 | RecvExpr | 通道接收 <-ch |

### Type (011xxxxx)

| 代码 | 节点 | 含义 |
|------|------|------|
| 011 00000 | IdentType | 名称类型 |
| 011 00001 | PointerType | 指针 *T |
| 011 00010 | ArrayType | 数组 [N]T |
| 011 00011 | SliceType | 切片 []T |
| 011 00100 | MapType | 映射 map[K]V |
| 011 00101 | ChanType | 通道 chan T |
| 011 00110 | FuncType | 函数类型 |
| 011 00111 | StructType | 结构体类型 |
| 011 01000 | InterfaceType | 接口类型 |
| 011 01001 | UnionType | 联合 A \| B |
| 011 01010 | OptionalType | 可选 T? |
| 011 01011 | GenericType | 泛型 T[U] |
| 011 01100 | TupleType | 元组 (A, B) |

### Pattern (100xxxxx)

| 代码 | 节点 | 含义 |
|------|------|------|
| 100 00000 | WildcardPattern | _ |
| 100 00001 | IdentPattern | 名称绑定 |
| 100 00010 | LiteralPattern | 字面量匹配 |
| 100 00011 | TuplePattern | 元组 (a, b) |
| 100 00100 | ListPattern | 列表 [a, b] |
| 100 00101 | StructPattern | 结构体 {a, b} |
| 100 00110 | OrPattern | a \| b |
| 100 00111 | GuardPattern | 守卫条件 |

### Modifier (101xxxxx)

| 代码 | 节点 | 含义 |
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

| 代码 | 节点 | 含义 |
|------|------|------|
| 110 00000 | File | 文件（顶层） |
| 110 00001 | Module | 模块 |
| 110 00010 | Package | 包 |
| 110 00011 | Namespace | 命名空间 |
| 110 00100 | Block | 块 |
| 110 00101 | CommentGroup | 注释组 |
| 110 00110 | Comment | 注释 |
| 110 00111 | Directive | 指令 (#pragma) |

### Language-specific (111xxxxx)

各语言特有节点。32个余量。

## PathGEUL (111110)

PathGEUL 是遍历 GEUL 图的查询语言。如同 XPath 遍历 XML，PathGEUL 遍历 GEUL 图。

当语言代码为 `111110` 时，8位 AST 节点类型被重新解释为**查询运算符**。

| 代码 | 运算 | XPath 对应 | 说明 |
|------|------|------------|------|
| 00000000 | Root | / | 根节点 |
| 00000001 | Child | /child | 直接子节点 |
| 00000010 | Descendant | // | 所有后代 |
| 00000011 | Parent | .. | 父节点 |
| 00000100 | Ancestor | ancestor:: | 所有祖先 |
| 00000101 | Sibling | sibling:: | 兄弟 |
| 00010000 | FilterType | [type=...] | 类型过滤 |
| 00100000 | FilterProp | [@prop=...] | 属性过滤 |
| 01000000 | Union | \| | 并集 |
| 01000001 | Intersect | & | 交集 |

## 示例

### Go 函数声明

```go
func Add(a, b int) int {
    return a + b
}
```

```
AST Edge (FuncDecl):
  1st: [Prefix 10bit] [000100]       - Prefix + Go
  2nd: [000 00000] [00000000]        - FuncDecl + 保留
  3rd: [TID: 0x0010]                 - 此 Edge TID
  4th: [TID: 0x0011]                 - Name "Add"
  5th: [TID: 0x0012]                 - Params
  6th: [TID: 0x0013]                 - Results
  7th: [TID: 0x0014]                 - Body
  8th: [0x0000]                      - 终止

总计: 8字
```

### Python 函数定义

```python
def greet(name: str) -> str:
    return f"Hello, {name}"
```

```
AST Edge (FuncDecl):
  1st: [Prefix 10bit] [100000]       - Prefix + Python
  2nd: [000 00000] [00000000]        - FuncDecl + 保留
  3rd: [TID: 0x0020]                 - 此 Edge TID
  4th: [TID: 0x0021]                 - Name "greet"
  5th: [TID: 0x0022]                 - Params
  6th: [TID: 0x0023]                 - Returns
  7th: [TID: 0x0024]                 - Body
  8th: [0x0000]                      - 终止

总计: 8字
```

### 叶节点（标识符）

```
AST Edge (Ident):
  1st: [Prefix 10bit] [000100]       - Prefix + Go
  2nd: [010 00110] [00000000]        - Ident + 保留
  3rd: [TID: 0x0030]                 - 此 Edge TID
  4th: [0x0000]                      - 终止（无子节点）

总计: 4字
```
