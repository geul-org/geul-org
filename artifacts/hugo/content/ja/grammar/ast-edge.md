---
title: "AST エッジ"
weight: 80
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "AST", "programming", "PathGEUL"]
summary: "プログラミング言語のASTをGEULグラフで表現するEdgeタイプ。6ビットで64言語を分類し、8ビットで256種のASTノードタイプをエンコードする。PathGEULクエリ言語を含む。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

AST Edge は**プログラミング言語の AST（Abstract Syntax Tree）**を GEUL グラフで表現する Edge タイプである。

| 特性 | 説明 |
|------|------|
| **多言語対応** | 6ビットで64言語を表現 |
| **共通 AST ノード** | 言語間で同一概念は同一コード |
| **系統ベース分類** | 優雅な劣化（graceful degradation）をサポート |
| **PathGEUL 統合** | GEUL グラフ探索言語を含む |

## パケット構造

```
1st WORD (16ビット)
┌─────────────────────┬────────────────────┐
│       Prefix        │        言語        │
│       10bit         │        6bit        │
└─────────────────────┴────────────────────┘

2nd WORD (16ビット)
┌─────────────────────────┬───────────────────┐
│     AST ノードタイプ     │       予約        │
│         8bit            │       8bit        │
└─────────────────────────┴───────────────────┘

3rd WORD (16ビット)
┌─────────────────────────────────────────────┐
│                  Edge TID                   │
│                   16bit                     │
└─────────────────────────────────────────────┘

4th+ WORD: 子 TID（可変、終結マーカー 0x0000 で終了）
```

| フィールド | ビット | サイズ | 説明 |
|------|------|------|------|
| Prefix | 1-10 | 10 | `0001 000 001` (AST Edge) |
| 言語 | 11-16 | 6 | プログラミング言語コード |
| AST ノードタイプ | 17-24 | 8 | ノード種類（3+5 分割） |
| 予約 | 25-32 | 8 | 将来拡張用（現在 0x00） |
| Edge TID | 33-48 | 16 | この Edge の一意識別子 |
| 子 TID | 49+ | 16×N | 子ノード参照 |

ワード数：最小3ワード（リーフノード）~ 一般4-8ワード ~ 制限なし

## 言語コード（6ビット）

系統ベース分類。bit1-2が大分類（パラダイム）、bit3-6が詳細言語。

### システム/低レベル（00xxxx）

| コード | 言語 | 説明 |
|------|------|------|
| 000000 | **Abstract** | すべての言語の共通 AST |
| 000001 | C | システム言語の原型 |
| 000010 | C++ | C 拡張 |
| 000011 | Rust | モダンシステム |
| 000100 | Go | モダンシステム |
| 000101 | Zig | モダンシステム |
| 000110 | Assembly | 最低レベル |
| 000111 | D | システム |
| 001000 | Nim | システム |

### アプリケーション/VM（01xxxx）

| コード | 言語 | 説明 |
|------|------|------|
| 010000 | Java | VM 系の原型 |
| 010001 | C# | .NET |
| 010010 | Kotlin | JVM |
| 010011 | Scala | JVM+関数型 |
| 010100 | Swift | Apple |
| 010101 | Dart | Flutter |
| 010110 | Groovy | JVM |
| 010111 | Clojure | JVM+Lisp |

### スクリプト/動的（10xxxx）

| コード | 言語 | 説明 |
|------|------|------|
| 100000 | Python | 汎用スクリプトの原型 |
| 100001 | JavaScript | Web |
| 100010 | TypeScript | JS+型 |
| 100011 | Ruby | 汎用 |
| 100100 | PHP | Web サーバー |
| 100101 | Lua | 組み込み |
| 100110 | Perl | テキスト処理 |
| 100111 | R | 統計 |
| 101000 | Julia | 科学計算 |
| 101001 | MATLAB | 数値解析 |

### 宣言型/関数型/その他（11xxxx）

| コード | 言語 | 説明 |
|------|------|------|
| 110000 | SQL | クエリ |
| 110001 | Haskell | 純粋関数型 |
| 110010 | OCaml | ML 系 |
| 110011 | F# | .NET 関数型 |
| 110100 | Elixir | BEAM |
| 110101 | Erlang | BEAM |
| 110110 | Shell | Bash/Zsh |
| 110111 | PowerShell | Windows |
| 111000 | WASM | バイトコード |
| 111001 | LLVM IR | 中間表現 |
| 111010 | HTML | マークアップ |
| 111011 | CSS | スタイル |
| 111100 | JSON | データ |
| 111101 | YAML | データ |
| 111110 | **PathGEUL** | GEUL グラフ探索言語 |
| 111111 | **拡張ワード** | 追加言語（3rdワードで明示） |

**優雅な劣化：** ビット損失時に上位系統に収束 → 最終的に Abstract（000000）にフォールバック。

## AST ノードタイプ（8ビット）

3ビット大分類 + 5ビット詳細タイプに分割。

### 大分類

| コード | 大分類 | 説明 |
|------|--------|------|
| 000 | Declaration | 宣言（関数、変数、型） |
| 001 | Statement | 文（制御文、繰り返し文） |
| 010 | Expression | 式（演算、呼び出し） |
| 011 | Type | 型表現 |
| 100 | Pattern | パターンマッチング |
| 101 | Modifier | 修飾子（アクセス制御、async） |
| 110 | Structure | 構造（ブロック、モジュール） |
| 111 | Language-specific | 言語固有ノード |

### Declaration (000xxxxx)

| コード | ノード | Go | Python | C |
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

| コード | ノード | 意味 |
|------|------|------|
| 001 00000 | IfStmt | 条件文 |
| 001 00001 | ForStmt | for ループ |
| 001 00010 | RangeStmt | イテレータループ |
| 001 00011 | WhileStmt | while ループ |
| 001 00100 | SwitchStmt | switch/match |
| 001 00101 | CaseClause | case 節 |
| 001 00110 | ReturnStmt | 返却 |
| 001 00111 | BreakStmt | 脱出 |
| 001 01000 | ContinueStmt | 継続 |
| 001 01001 | GotoStmt | goto |
| 001 01010 | BlockStmt | ブロック { } |
| 001 01011 | ExprStmt | 式文 |
| 001 01100 | AssignStmt | 代入 |
| 001 01101 | DeclStmt | 宣言文 |
| 001 01110 | TryStmt | 例外処理 |
| 001 01111 | ThrowStmt | 例外発生 |
| 001 10000 | DeferStmt | defer |
| 001 10001 | GoStmt | go |
| 001 10010 | SelectStmt | select |
| 001 10011 | WithStmt | with |
| 001 10100 | AssertStmt | assert |
| 001 10101 | PassStmt | pass |

### Expression (010xxxxx)

| コード | ノード | 意味 |
|------|------|------|
| 010 00000 | BinaryExpr | 二項演算 |
| 010 00001 | UnaryExpr | 単項演算 |
| 010 00010 | CallExpr | 関数呼び出し |
| 010 00011 | IndexExpr | インデックスアクセス a[i] |
| 010 00100 | SliceExpr | スライス a[i:j] |
| 010 00101 | SelectorExpr | フィールドアクセス a.b |
| 010 00110 | Ident | 識別子 |
| 010 00111 | BasicLit | 基本リテラル |
| 010 01000 | CompositeLit | 複合リテラル |
| 010 01001 | FuncLit | ラムダ/匿名関数 |
| 010 01010 | ParenExpr | 括弧 (a) |
| 010 01011 | StarExpr | ポインタ *a |
| 010 01100 | UnaryAddr | アドレス &a |
| 010 01101 | TypeAssertExpr | 型アサーション |
| 010 01110 | KeyValueExpr | key: value |
| 010 01111 | TernaryExpr | 三項演算 |
| 010 10000 | ListComp | リスト内包表記 |
| 010 10001 | DictComp | 辞書内包表記 |
| 010 10010 | GeneratorExpr | ジェネレータ |
| 010 10011 | AwaitExpr | await |
| 010 10100 | YieldExpr | yield |
| 010 10101 | SendExpr | チャネル送信 <- |
| 010 10110 | RecvExpr | チャネル受信 <-ch |

### Type (011xxxxx)

| コード | ノード | 意味 |
|------|------|------|
| 011 00000 | IdentType | 名前型 |
| 011 00001 | PointerType | ポインタ *T |
| 011 00010 | ArrayType | 配列 [N]T |
| 011 00011 | SliceType | スライス []T |
| 011 00100 | MapType | マップ map[K]V |
| 011 00101 | ChanType | チャネル chan T |
| 011 00110 | FuncType | 関数型 |
| 011 00111 | StructType | 構造体型 |
| 011 01000 | InterfaceType | インターフェース型 |
| 011 01001 | UnionType | ユニオン A \| B |
| 011 01010 | OptionalType | オプショナル T? |
| 011 01011 | GenericType | ジェネリック T[U] |
| 011 01100 | TupleType | タプル (A, B) |

### Pattern (100xxxxx)

| コード | ノード | 意味 |
|------|------|------|
| 100 00000 | WildcardPattern | _ |
| 100 00001 | IdentPattern | 名前バインディング |
| 100 00010 | LiteralPattern | リテラルマッチング |
| 100 00011 | TuplePattern | タプル (a, b) |
| 100 00100 | ListPattern | リスト [a, b] |
| 100 00101 | StructPattern | 構造体 {a, b} |
| 100 00110 | OrPattern | a \| b |
| 100 00111 | GuardPattern | ガード条件 |

### Modifier (101xxxxx)

| コード | ノード | 意味 |
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

| コード | ノード | 意味 |
|------|------|------|
| 110 00000 | File | ファイル（最上位） |
| 110 00001 | Module | モジュール |
| 110 00010 | Package | パッケージ |
| 110 00011 | Namespace | ネームスペース |
| 110 00100 | Block | ブロック |
| 110 00101 | CommentGroup | コメントグループ |
| 110 00110 | Comment | コメント |
| 110 00111 | Directive | ディレクティブ (#pragma) |

### Language-specific (111xxxxx)

各言語固有のノード。32個の余裕。

## PathGEUL (111110)

PathGEUL は GEUL グラフを探索するクエリ言語である。XPath が XML を探索するように、PathGEUL は GEUL グラフを探索する。

言語コード `111110` の場合、8ビット AST ノードタイプは**クエリ演算子**として再解釈される。

| コード | 演算 | XPath 対応 | 説明 |
|------|------|------------|------|
| 00000000 | Root | / | ルートノード |
| 00000001 | Child | /child | 直接子 |
| 00000010 | Descendant | // | すべての子孫 |
| 00000011 | Parent | .. | 親 |
| 00000100 | Ancestor | ancestor:: | すべての祖先 |
| 00000101 | Sibling | sibling:: | 兄弟 |
| 00010000 | FilterType | [type=...] | タイプフィルタ |
| 00100000 | FilterProp | [@prop=...] | 属性フィルタ |
| 01000000 | Union | \| | 和集合 |
| 01000001 | Intersect | & | 積集合 |

## 例

### Go 関数宣言

```go
func Add(a, b int) int {
    return a + b
}
```

```
AST Edge (FuncDecl):
  1st: [Prefix 10bit] [000100]       - Prefix + Go
  2nd: [000 00000] [00000000]        - FuncDecl + 予約
  3rd: [TID: 0x0010]                 - この Edge TID
  4th: [TID: 0x0011]                 - Name "Add"
  5th: [TID: 0x0012]                 - Params
  6th: [TID: 0x0013]                 - Results
  7th: [TID: 0x0014]                 - Body
  8th: [0x0000]                      - 終結

合計: 8ワード
```

### Python 関数定義

```python
def greet(name: str) -> str:
    return f"Hello, {name}"
```

```
AST Edge (FuncDecl):
  1st: [Prefix 10bit] [100000]       - Prefix + Python
  2nd: [000 00000] [00000000]        - FuncDecl + 予約
  3rd: [TID: 0x0020]                 - この Edge TID
  4th: [TID: 0x0021]                 - Name "greet"
  5th: [TID: 0x0022]                 - Params
  6th: [TID: 0x0023]                 - Returns
  7th: [TID: 0x0024]                 - Body
  8th: [0x0000]                      - 終結

合計: 8ワード
```

### リーフノード（識別子）

```
AST Edge (Ident):
  1st: [Prefix 10bit] [000100]       - Prefix + Go
  2nd: [010 00110] [00000000]        - Ident + 予約
  3rd: [TID: 0x0030]                 - この Edge TID
  4th: [0x0000]                      - 終結（子なし）

合計: 4ワード
```
