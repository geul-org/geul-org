---
title: "קשת AST"
weight: 80
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "AST", "programming", "PathGEUL"]
summary: "סוג Edge המייצג עץ AST של שפות תכנות בגרף GEUL. מסווג 64 שפות ב-6 סיביות ומקודד 256 סוגי צמתי AST ב-8 סיביות. כולל שפת שאילתא PathGEUL."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

AST Edge הוא סוג Edge המייצג **עץ AST (Abstract Syntax Tree)** של שפות תכנות בגרף GEUL.

| מאפיין | תיאור |
|--------|-------|
| **תמיכה רב-שפתית** | 64 שפות ב-6 סיביות |
| **צמתי AST משותפים** | מושגים משותפים בין שפות נושאים אותו קוד |
| **סיווג לפי שושלת** | תמיכה בהידרדרות חיננית (graceful degradation) |
| **שילוב PathGEUL** | כולל שפת שאילתא לגרף GEUL |

## מבנה המנה

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

4th+ WORD: Child TIDs (variable, ends with 0x0000)
```

| שדה | סיביות | גודל | תיאור |
|-----|--------|------|-------|
| Prefix | 1-10 | 10 | `0001 000 001` (AST Edge) |
| Language | 11-16 | 6 | קוד שפת תכנות |
| AST Node Type | 17-24 | 8 | סוג צומת (חלוקה 3+5) |
| Reserved | 25-32 | 8 | להרחבה עתידית (כרגע 0x00) |
| Edge TID | 33-48 | 16 | מזהה ייחודי של Edge זה |
| Child TIDs | 49+ | 16×N | הפניות לצמתים בנים |

מספר מילים: מינימום 3 (צומת עלה) ~ בדרך כלל 4-8 ~ ללא הגבלה

## קודי שפה (6 סיביות)

סיווג לפי שושלת. bit1-2 לסיווג גדול (פרדיגמה), bit3-6 לשפה ספציפית.

### מערכת/רמה נמוכה (00xxxx)

| קוד | שפה | תיאור |
|-----|-----|-------|
| 000000 | **Abstract** | AST משותף לכל השפות |
| 000001 | C | אב טיפוס שפת מערכת |
| 000010 | C++ | הרחבת C |
| 000011 | Rust | מערכת מודרנית |
| 000100 | Go | מערכת מודרנית |
| 000101 | Zig | מערכת מודרנית |
| 000110 | Assembly | הרמה הנמוכה ביותר |
| 000111 | D | מערכת |
| 001000 | Nim | מערכת |

### יישומים/VM (01xxxx)

| קוד | שפה | תיאור |
|-----|-----|-------|
| 010000 | Java | אב טיפוס למשפחת VM |
| 010001 | C# | .NET |
| 010010 | Kotlin | JVM |
| 010011 | Scala | JVM+פונקציונלי |
| 010100 | Swift | Apple |
| 010101 | Dart | Flutter |
| 010110 | Groovy | JVM |
| 010111 | Clojure | JVM+Lisp |

### סקריפט/דינמי (10xxxx)

| קוד | שפה | תיאור |
|-----|-----|-------|
| 100000 | Python | אב טיפוס סקריפט כללי |
| 100001 | JavaScript | ווב |
| 100010 | TypeScript | JS+טיפוסים |
| 100011 | Ruby | כללי |
| 100100 | PHP | שרת ווב |
| 100101 | Lua | מוטמע |
| 100110 | Perl | עיבוד טקסט |
| 100111 | R | סטטיסטיקה |
| 101000 | Julia | חישוב מדעי |
| 101001 | MATLAB | ניתוח מספרי |

### הצהרתי/פונקציונלי/אחר (11xxxx)

| קוד | שפה | תיאור |
|-----|-----|-------|
| 110000 | SQL | שאילתות |
| 110001 | Haskell | פונקציונלי טהור |
| 110010 | OCaml | משפחת ML |
| 110011 | F# | .NET פונקציונלי |
| 110100 | Elixir | BEAM |
| 110101 | Erlang | BEAM |
| 110110 | Shell | Bash/Zsh |
| 110111 | PowerShell | Windows |
| 111000 | WASM | בייטקוד |
| 111001 | LLVM IR | ייצוג ביניים |
| 111010 | HTML | סימון |
| 111011 | CSS | עיצוב |
| 111100 | JSON | נתונים |
| 111101 | YAML | נתונים |
| 111110 | **PathGEUL** | שפת שאילתא לגרף GEUL |
| 111111 | **Extended Word** | שפות נוספות (מצוינות במילה ה-3) |

**הידרדרות חיננית:** בעת אובדן סיביות, מתכנס לשושלת העליונה → בסופו של דבר נופל ל-Abstract(000000).

## סוגי צמתי AST (8 סיביות)

חלוקה של 3 סיביות סיווג גדול + 5 סיביות תת-סוג.

### סיווג גדול

| קוד | סיווג | תיאור |
|-----|-------|-------|
| 000 | Declaration | הצהרה (פונקציה, משתנה, טיפוס) |
| 001 | Statement | משפט (בקרה, לולאה) |
| 010 | Expression | ביטוי (פעולה, קריאה) |
| 011 | Type | ביטוי טיפוס |
| 100 | Pattern | התאמת דפוסים |
| 101 | Modifier | משנה (בקרת גישה, async) |
| 110 | Structure | מבנה (בלוק, מודול) |
| 111 | Language-specific | צומת ייחודי לשפה |

### Declaration (000xxxxx)

| קוד | צומת | Go | Python | C |
|-----|------|-----|--------|---|
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

| קוד | צומת | משמעות |
|-----|------|--------|
| 001 00000 | IfStmt | משפט תנאי |
| 001 00001 | ForStmt | לולאת for |
| 001 00010 | RangeStmt | לולאת איטרטור |
| 001 00011 | WhileStmt | לולאת while |
| 001 00100 | SwitchStmt | switch/match |
| 001 00101 | CaseClause | סעיף case |
| 001 00110 | ReturnStmt | החזרה |
| 001 00111 | BreakStmt | יציאה |
| 001 01000 | ContinueStmt | המשך |
| 001 01001 | GotoStmt | goto |
| 001 01010 | BlockStmt | בלוק { } |
| 001 01011 | ExprStmt | משפט ביטוי |
| 001 01100 | AssignStmt | השמה |
| 001 01101 | DeclStmt | משפט הצהרה |
| 001 01110 | TryStmt | טיפול בחריגה |
| 001 01111 | ThrowStmt | זריקת חריגה |
| 001 10000 | DeferStmt | defer |
| 001 10001 | GoStmt | go |
| 001 10010 | SelectStmt | select |
| 001 10011 | WithStmt | with |
| 001 10100 | AssertStmt | assert |
| 001 10101 | PassStmt | pass |

### Expression (010xxxxx)

| קוד | צומת | משמעות |
|-----|------|--------|
| 010 00000 | BinaryExpr | פעולה בינארית |
| 010 00001 | UnaryExpr | פעולה אונרית |
| 010 00010 | CallExpr | קריאת פונקציה |
| 010 00011 | IndexExpr | גישת אינדקס a[i] |
| 010 00100 | SliceExpr | חיתוך a[i:j] |
| 010 00101 | SelectorExpr | גישת שדה a.b |
| 010 00110 | Ident | מזהה |
| 010 00111 | BasicLit | ליטרל בסיסי |
| 010 01000 | CompositeLit | ליטרל מורכב |
| 010 01001 | FuncLit | למבדה/פונקציה אנונימית |
| 010 01010 | ParenExpr | סוגריים (a) |
| 010 01011 | StarExpr | מצביע *a |
| 010 01100 | UnaryAddr | כתובת &a |
| 010 01101 | TypeAssertExpr | אישור טיפוס |
| 010 01110 | KeyValueExpr | key: value |
| 010 01111 | TernaryExpr | פעולה משולשת |
| 010 10000 | ListComp | list comprehension |
| 010 10001 | DictComp | dict comprehension |
| 010 10010 | GeneratorExpr | מחולל |
| 010 10011 | AwaitExpr | await |
| 010 10100 | YieldExpr | yield |
| 010 10101 | SendExpr | שליחת ערוץ <- |
| 010 10110 | RecvExpr | קבלת ערוץ <-ch |

### Type (011xxxxx)

| קוד | צומת | משמעות |
|-----|------|--------|
| 011 00000 | IdentType | טיפוס שם |
| 011 00001 | PointerType | מצביע *T |
| 011 00010 | ArrayType | מערך [N]T |
| 011 00011 | SliceType | חיתוך []T |
| 011 00100 | MapType | מפה map[K]V |
| 011 00101 | ChanType | ערוץ chan T |
| 011 00110 | FuncType | טיפוס פונקציה |
| 011 00111 | StructType | טיפוס מבנה |
| 011 01000 | InterfaceType | טיפוס ממשק |
| 011 01001 | UnionType | איחוד A \| B |
| 011 01010 | OptionalType | אופציונלי T? |
| 011 01011 | GenericType | גנרי T[U] |
| 011 01100 | TupleType | טאפל (A, B) |

### Pattern (100xxxxx)

| קוד | צומת | משמעות |
|-----|------|--------|
| 100 00000 | WildcardPattern | _ |
| 100 00001 | IdentPattern | קישור שם |
| 100 00010 | LiteralPattern | התאמת ליטרל |
| 100 00011 | TuplePattern | טאפל (a, b) |
| 100 00100 | ListPattern | רשימה [a, b] |
| 100 00101 | StructPattern | מבנה {a, b} |
| 100 00110 | OrPattern | a \| b |
| 100 00111 | GuardPattern | תנאי שומר |

### Modifier (101xxxxx)

| קוד | צומת | משמעות |
|-----|------|--------|
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

| קוד | צומת | משמעות |
|-----|------|--------|
| 110 00000 | File | קובץ (רמה עליונה) |
| 110 00001 | Module | מודול |
| 110 00010 | Package | חבילה |
| 110 00011 | Namespace | מרחב שמות |
| 110 00100 | Block | בלוק |
| 110 00101 | CommentGroup | קבוצת הערות |
| 110 00110 | Comment | הערה |
| 110 00111 | Directive | הנחיה (#pragma) |

### Language-specific (111xxxxx)

צמתים ייחודיים לכל שפה. 32 מקומות פנויים.

## PathGEUL (111110)

PathGEUL היא שפת שאילתא לסריקת גרף GEUL. כשם ש-XPath סורק קבצי XML, PathGEUL סורק גרף GEUL.

כאשר קוד השפה הוא `111110`, 8 סיביות AST Node Type מפורשות מחדש כ**אופרטורי שאילתא**.

| קוד | פעולה | מקבילה ב-XPath | תיאור |
|-----|-------|----------------|-------|
| 00000000 | Root | / | צומת שורש |
| 00000001 | Child | /child | בן ישיר |
| 00000010 | Descendant | // | כל הצאצאים |
| 00000011 | Parent | .. | הורה |
| 00000100 | Ancestor | ancestor:: | כל האבות |
| 00000101 | Sibling | sibling:: | אחים |
| 00010000 | FilterType | [type=...] | סינון לפי סוג |
| 00100000 | FilterProp | [@prop=...] | סינון לפי מאפיין |
| 01000000 | Union | \| | איחוד |
| 01000001 | Intersect | & | חיתוך |

## דוגמאות

### הצהרת פונקציה ב-Go

```go
func Add(a, b int) int {
    return a + b
}
```

```
AST Edge (FuncDecl):
  1st: [Prefix 10bit] [000100]       - Prefix + Go
  2nd: [000 00000] [00000000]        - FuncDecl + Reserved
  3rd: [TID: 0x0010]                 - Edge TID
  4th: [TID: 0x0011]                 - Name "Add"
  5th: [TID: 0x0012]                 - Params
  6th: [TID: 0x0013]                 - Results
  7th: [TID: 0x0014]                 - Body
  8th: [0x0000]                      - Terminator

Total: 8 words
```

### הגדרת פונקציה ב-Python

```python
def greet(name: str) -> str:
    return f"Hello, {name}"
```

```
AST Edge (FuncDecl):
  1st: [Prefix 10bit] [100000]       - Prefix + Python
  2nd: [000 00000] [00000000]        - FuncDecl + Reserved
  3rd: [TID: 0x0020]                 - Edge TID
  4th: [TID: 0x0021]                 - Name "greet"
  5th: [TID: 0x0022]                 - Params
  6th: [TID: 0x0023]                 - Returns
  7th: [TID: 0x0024]                 - Body
  8th: [0x0000]                      - Terminator

Total: 8 words
```

### צומת עלה (מזהה)

```
AST Edge (Ident):
  1st: [Prefix 10bit] [000100]       - Prefix + Go
  2nd: [010 00110] [00000000]        - Ident + Reserved
  3rd: [TID: 0x0030]                 - Edge TID
  4th: [0x0000]                      - Terminator (no children)

Total: 4 words
```
