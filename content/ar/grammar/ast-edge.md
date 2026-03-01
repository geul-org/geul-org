---
title: "حافة AST"
weight: 80
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "AST", "programming", "PathGEUL"]
summary: "نوع Edge يمثل شجرة AST للغات البرمجة في رسم GEUL البياني. يصنّف 64 لغة بـ 6 بت ويشفّر 256 نوع عقدة AST بـ 8 بت. يتضمن لغة استعلام PathGEUL."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

AST Edge هو نوع Edge يمثل **شجرة AST (Abstract Syntax Tree)** للغات البرمجة في رسم GEUL البياني.

| الخاصية | الوصف |
|---------|-------|
| **دعم متعدد اللغات** | 64 لغة بـ 6 بت |
| **عقد AST مشتركة** | المفاهيم المشتركة بين اللغات تحمل نفس الرمز |
| **تصنيف بحسب السلالة** | دعم التدهور الأنيق (graceful degradation) |
| **تكامل PathGEUL** | تضمين لغة استعلام رسم GEUL |

## بنية الحزمة

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

| الحقل | البتات | الحجم | الوصف |
|-------|--------|-------|-------|
| Prefix | 1-10 | 10 | `0001 000 001` (AST Edge) |
| Language | 11-16 | 6 | رمز لغة البرمجة |
| AST Node Type | 17-24 | 8 | نوع العقدة (تقسيم 3+5) |
| Reserved | 25-32 | 8 | للتوسيع المستقبلي (حالياً 0x00) |
| Edge TID | 33-48 | 16 | معرّف فريد لهذا Edge |
| Child TIDs | 49+ | 16×N | مراجع العقد الفرعية |

عدد الكلمات: حد أدنى 3 كلمات (عقدة ورقة) ~ عادة 4-8 كلمات ~ بدون حد أقصى

## رموز اللغات (6 بت)

تصنيف بحسب السلالة. bit1-2 للتصنيف الكبير (النموذج)، bit3-6 للغة المحددة.

### نظام/منخفض المستوى (00xxxx)

| الرمز | اللغة | الوصف |
|-------|-------|-------|
| 000000 | **Abstract** | AST مشترك لجميع اللغات |
| 000001 | C | النموذج الأصلي للغة النظام |
| 000010 | C++ | امتداد C |
| 000011 | Rust | نظام حديث |
| 000100 | Go | نظام حديث |
| 000101 | Zig | نظام حديث |
| 000110 | Assembly | أدنى مستوى |
| 000111 | D | نظام |
| 001000 | Nim | نظام |

### تطبيقات/VM (01xxxx)

| الرمز | اللغة | الوصف |
|-------|-------|-------|
| 010000 | Java | النموذج الأصلي لعائلة VM |
| 010001 | C# | .NET |
| 010010 | Kotlin | JVM |
| 010011 | Scala | JVM+وظيفي |
| 010100 | Swift | Apple |
| 010101 | Dart | Flutter |
| 010110 | Groovy | JVM |
| 010111 | Clojure | JVM+Lisp |

### سكريبت/ديناميكي (10xxxx)

| الرمز | اللغة | الوصف |
|-------|-------|-------|
| 100000 | Python | النموذج الأصلي للسكريبت العام |
| 100001 | JavaScript | ويب |
| 100010 | TypeScript | JS+أنواع |
| 100011 | Ruby | عام |
| 100100 | PHP | خادم ويب |
| 100101 | Lua | مدمج |
| 100110 | Perl | معالجة نصوص |
| 100111 | R | إحصاء |
| 101000 | Julia | حوسبة علمية |
| 101001 | MATLAB | تحليل عددي |

### تصريحي/وظيفي/أخرى (11xxxx)

| الرمز | اللغة | الوصف |
|-------|-------|-------|
| 110000 | SQL | استعلامات |
| 110001 | Haskell | وظيفي خالص |
| 110010 | OCaml | عائلة ML |
| 110011 | F# | .NET وظيفي |
| 110100 | Elixir | BEAM |
| 110101 | Erlang | BEAM |
| 110110 | Shell | Bash/Zsh |
| 110111 | PowerShell | Windows |
| 111000 | WASM | بايت كود |
| 111001 | LLVM IR | تمثيل وسيط |
| 111010 | HTML | ترميز |
| 111011 | CSS | تنسيق |
| 111100 | JSON | بيانات |
| 111101 | YAML | بيانات |
| 111110 | **PathGEUL** | لغة استعلام رسم GEUL |
| 111111 | **Extended Word** | لغات إضافية (محددة في الكلمة الثالثة) |

**التدهور الأنيق:** عند فقدان بتات، يتقارب نحو السلالة العليا → في النهاية يرجع إلى Abstract(000000).

## أنواع عقد AST (8 بت)

تقسيم 3 بت تصنيف كبير + 5 بت نوع فرعي.

### التصنيف الكبير

| الرمز | التصنيف | الوصف |
|-------|---------|-------|
| 000 | Declaration | إعلان (دالة، متغير، نوع) |
| 001 | Statement | جملة (تحكم، تكرار) |
| 010 | Expression | تعبير (عملية، استدعاء) |
| 011 | Type | تعبير نوعي |
| 100 | Pattern | مطابقة أنماط |
| 101 | Modifier | معدّل (تحكم وصول، async) |
| 110 | Structure | بنية (كتلة، وحدة) |
| 111 | Language-specific | عقدة خاصة باللغة |

### Declaration (000xxxxx)

| الرمز | العقدة | Go | Python | C |
|-------|--------|-----|--------|---|
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

| الرمز | العقدة | المعنى |
|-------|--------|--------|
| 001 00000 | IfStmt | جملة شرطية |
| 001 00001 | ForStmt | حلقة for |
| 001 00010 | RangeStmt | حلقة مكرر |
| 001 00011 | WhileStmt | حلقة while |
| 001 00100 | SwitchStmt | switch/match |
| 001 00101 | CaseClause | عبارة case |
| 001 00110 | ReturnStmt | إرجاع |
| 001 00111 | BreakStmt | خروج |
| 001 01000 | ContinueStmt | متابعة |
| 001 01001 | GotoStmt | goto |
| 001 01010 | BlockStmt | كتلة { } |
| 001 01011 | ExprStmt | جملة تعبيرية |
| 001 01100 | AssignStmt | إسناد |
| 001 01101 | DeclStmt | جملة إعلان |
| 001 01110 | TryStmt | معالجة استثناء |
| 001 01111 | ThrowStmt | رمي استثناء |
| 001 10000 | DeferStmt | defer |
| 001 10001 | GoStmt | go |
| 001 10010 | SelectStmt | select |
| 001 10011 | WithStmt | with |
| 001 10100 | AssertStmt | assert |
| 001 10101 | PassStmt | pass |

### Expression (010xxxxx)

| الرمز | العقدة | المعنى |
|-------|--------|--------|
| 010 00000 | BinaryExpr | عملية ثنائية |
| 010 00001 | UnaryExpr | عملية أحادية |
| 010 00010 | CallExpr | استدعاء دالة |
| 010 00011 | IndexExpr | وصول فهرسي a[i] |
| 010 00100 | SliceExpr | شريحة a[i:j] |
| 010 00101 | SelectorExpr | وصول حقل a.b |
| 010 00110 | Ident | معرّف |
| 010 00111 | BasicLit | قيمة حرفية أساسية |
| 010 01000 | CompositeLit | قيمة حرفية مركبة |
| 010 01001 | FuncLit | لامبدا/دالة مجهولة |
| 010 01010 | ParenExpr | أقواس (a) |
| 010 01011 | StarExpr | مؤشر *a |
| 010 01100 | UnaryAddr | عنوان &a |
| 010 01101 | TypeAssertExpr | تأكيد نوع |
| 010 01110 | KeyValueExpr | key: value |
| 010 01111 | TernaryExpr | عملية ثلاثية |
| 010 10000 | ListComp | list comprehension |
| 010 10001 | DictComp | dict comprehension |
| 010 10010 | GeneratorExpr | مولّد |
| 010 10011 | AwaitExpr | await |
| 010 10100 | YieldExpr | yield |
| 010 10101 | SendExpr | إرسال قناة <- |
| 010 10110 | RecvExpr | استقبال قناة <-ch |

### Type (011xxxxx)

| الرمز | العقدة | المعنى |
|-------|--------|--------|
| 011 00000 | IdentType | نوع باسم |
| 011 00001 | PointerType | مؤشر *T |
| 011 00010 | ArrayType | مصفوفة [N]T |
| 011 00011 | SliceType | شريحة []T |
| 011 00100 | MapType | خريطة map[K]V |
| 011 00101 | ChanType | قناة chan T |
| 011 00110 | FuncType | نوع دالة |
| 011 00111 | StructType | نوع بنية |
| 011 01000 | InterfaceType | نوع واجهة |
| 011 01001 | UnionType | اتحاد A \| B |
| 011 01010 | OptionalType | اختياري T? |
| 011 01011 | GenericType | عام T[U] |
| 011 01100 | TupleType | صف (A, B) |

### Pattern (100xxxxx)

| الرمز | العقدة | المعنى |
|-------|--------|--------|
| 100 00000 | WildcardPattern | _ |
| 100 00001 | IdentPattern | ربط اسم |
| 100 00010 | LiteralPattern | مطابقة قيمة حرفية |
| 100 00011 | TuplePattern | صف (a, b) |
| 100 00100 | ListPattern | قائمة [a, b] |
| 100 00101 | StructPattern | بنية {a, b} |
| 100 00110 | OrPattern | a \| b |
| 100 00111 | GuardPattern | شرط حارس |

### Modifier (101xxxxx)

| الرمز | العقدة | المعنى |
|-------|--------|--------|
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

| الرمز | العقدة | المعنى |
|-------|--------|--------|
| 110 00000 | File | ملف (أعلى مستوى) |
| 110 00001 | Module | وحدة |
| 110 00010 | Package | حزمة |
| 110 00011 | Namespace | فضاء أسماء |
| 110 00100 | Block | كتلة |
| 110 00101 | CommentGroup | مجموعة تعليقات |
| 110 00110 | Comment | تعليق |
| 110 00111 | Directive | توجيه (#pragma) |

### Language-specific (111xxxxx)

عقد خاصة بكل لغة. 32 موقعاً متاحاً.

## PathGEUL (111110)

PathGEUL هي لغة استعلام لاستكشاف رسم GEUL البياني. كما يستكشف XPath ملفات XML، يستكشف PathGEUL رسم GEUL.

عندما يكون رمز اللغة `111110`، تُعاد تفسير 8 بت AST Node Type كـ **عوامل استعلام**.

| الرمز | العملية | مقابل XPath | الوصف |
|-------|---------|-------------|-------|
| 00000000 | Root | / | العقدة الجذرية |
| 00000001 | Child | /child | ابن مباشر |
| 00000010 | Descendant | // | جميع الأحفاد |
| 00000011 | Parent | .. | الأب |
| 00000100 | Ancestor | ancestor:: | جميع الأسلاف |
| 00000101 | Sibling | sibling:: | الإخوة |
| 00010000 | FilterType | [type=...] | ترشيح بالنوع |
| 00100000 | FilterProp | [@prop=...] | ترشيح بالخاصية |
| 01000000 | Union | \| | اتحاد |
| 01000001 | Intersect | & | تقاطع |

## أمثلة

### إعلان دالة Go

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

### تعريف دالة Python

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

### عقدة ورقة (معرّف)

```
AST Edge (Ident):
  1st: [Prefix 10bit] [000100]       - Prefix + Go
  2nd: [010 00110] [00000000]        - Ident + Reserved
  3rd: [TID: 0x0030]                 - Edge TID
  4th: [0x0000]                      - Terminator (no children)

Total: 4 words
```
