---
title: "AST Edge"
weight: 80
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "AST", "programming", "PathGEUL"]
summary: "Edge-Typ zur Darstellung von ASTs von Programmiersprachen als GEUL-Graphen. 6 Bit klassifizieren 64 Sprachen, 8 Bit kodieren 256 AST-Knotentypen. Enthaelt die Abfragesprache PathGEUL."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

AST Edge ist ein Edge-Typ, der den **AST (Abstract Syntax Tree) von Programmiersprachen** als GEUL-Graph darstellt.

| Eigenschaft | Beschreibung |
|-------------|--------------|
| **Mehrsprachige Unterstuetzung** | 64 Sprachen auf 6 Bit |
| **Gemeinsame AST-Knoten** | Gleicher Code fuer gleiche Konzepte zwischen Sprachen |
| **Familienbasierte Klassifikation** | Unterstuetzung eleganter Degradation (graceful degradation) |
| **PathGEUL-Integration** | GEUL-Graph-Traversierungssprache enthalten |

## Paketstruktur

```
1st WORD (16 Bit)
┌─────────────────────┬────────────────────┐
│       Prefix        │      Sprache       │
│       10bit         │        6bit        │
└─────────────────────┴────────────────────┘

2nd WORD (16 Bit)
┌─────────────────────────┬───────────────────┐
│     AST-Knotentyp       │     Reserviert    │
│         8bit            │       8bit        │
└─────────────────────────┴───────────────────┘

3rd WORD (16 Bit)
┌─────────────────────────────────────────────┐
│                  Edge TID                   │
│                   16bit                     │
└─────────────────────────────────────────────┘

4th+ WORD: Kind-TIDs (variabel, endet mit Terminierungsmarker 0x0000)
```

| Feld | Bits | Groesse | Beschreibung |
|------|------|---------|--------------|
| Prefix | 1-10 | 10 | `0001 000 001` (AST Edge) |
| Sprache | 11-16 | 6 | Programmiersprachencode |
| AST-Knotentyp | 17-24 | 8 | Knotenart (3+5-Aufteilung) |
| Reserviert | 25-32 | 8 | Fuer zukuenftige Erweiterung (aktuell 0x00) |
| Edge TID | 33-48 | 16 | Eindeutiger Identifikator dieses Edge |
| Kind-TID | 49+ | 16xN | Kindknoten-Referenzen |

Wortanzahl: mindestens 3 (Blattknoten) ~ ueblicherweise 4-8 ~ ohne Limit.

## Sprachcodes (6 Bit)

Familienbasierte Klassifikation. Bit1-2 = Hauptkategorie (Paradigma), Bit3-6 = spezifische Sprache.

### System/Low-Level (00xxxx)

| Code | Sprache | Beschreibung |
|------|---------|--------------|
| 000000 | **Abstract** | Gemeinsamer AST aller Sprachen |
| 000001 | C | Prototyp der Systemsprachen |
| 000010 | C++ | C-Erweiterung |
| 000011 | Rust | Modernes System |
| 000100 | Go | Modernes System |
| 000101 | Zig | Modernes System |
| 000110 | Assembly | Niedrigstes Niveau |
| 000111 | D | System |
| 001000 | Nim | System |

### Anwendung/VM (01xxxx)

| Code | Sprache | Beschreibung |
|------|---------|--------------|
| 010000 | Java | Prototyp der VM-Familie |
| 010001 | C# | .NET |
| 010010 | Kotlin | JVM |
| 010011 | Scala | JVM+funktional |
| 010100 | Swift | Apple |
| 010101 | Dart | Flutter |
| 010110 | Groovy | JVM |
| 010111 | Clojure | JVM+Lisp |

### Script/dynamisch (10xxxx)

| Code | Sprache | Beschreibung |
|------|---------|--------------|
| 100000 | Python | Prototyp universelle Skriptsprache |
| 100001 | JavaScript | Web |
| 100010 | TypeScript | JS+Typen |
| 100011 | Ruby | Universell |
| 100100 | PHP | Webserver |
| 100101 | Lua | Eingebettet |
| 100110 | Perl | Textverarbeitung |
| 100111 | R | Statistik |
| 101000 | Julia | Wissenschaftliches Rechnen |
| 101001 | MATLAB | Numerische Analyse |

### Deklarativ/funktional/sonstig (11xxxx)

| Code | Sprache | Beschreibung |
|------|---------|--------------|
| 110000 | SQL | Abfragen |
| 110001 | Haskell | Rein funktional |
| 110010 | OCaml | ML-Familie |
| 110011 | F# | .NET funktional |
| 110100 | Elixir | BEAM |
| 110101 | Erlang | BEAM |
| 110110 | Shell | Bash/Zsh |
| 110111 | PowerShell | Windows |
| 111000 | WASM | Bytecode |
| 111001 | LLVM IR | Zwischendarstellung |
| 111010 | HTML | Markup |
| 111011 | CSS | Stil |
| 111100 | JSON | Daten |
| 111101 | YAML | Daten |
| 111110 | **PathGEUL** | GEUL-Graph-Traversierungssprache |
| 111111 | **Erweiterungswort** | Zusaetzliche Sprachen (im 3. Wort angegeben) |

**Elegante Degradation:** Bei Bitverlust Konvergenz zur uebergeordneten Familie → endgueltiger Fallback auf Abstract (000000).

## AST-Knotentypen (8 Bit)

Aufteilung in 3-Bit-Hauptkategorie + 5-Bit-Untertyp.

### Hauptkategorien

| Code | Kategorie | Beschreibung |
|------|-----------|--------------|
| 000 | Declaration | Deklarationen (Funktion, Variable, Typ) |
| 001 | Statement | Anweisungen (Kontrollfluss, Schleifen) |
| 010 | Expression | Ausdruecke (Operationen, Aufrufe) |
| 011 | Type | Typausdruecke |
| 100 | Pattern | Mustererkennung |
| 101 | Modifier | Modifikatoren (Zugriff, async) |
| 110 | Structure | Strukturen (Block, Modul) |
| 111 | Language-specific | Sprachspezifische Knoten |

### Declaration (000xxxxx)

| Code | Knoten | Go | Python | C |
|------|--------|-----|--------|---|
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

| Code | Knoten | Bedeutung |
|------|--------|-----------|
| 001 00000 | IfStmt | Bedingung |
| 001 00001 | ForStmt | for-Schleife |
| 001 00010 | RangeStmt | Iterator-Schleife |
| 001 00011 | WhileStmt | while-Schleife |
| 001 00100 | SwitchStmt | switch/match |
| 001 00101 | CaseClause | case-Klausel |
| 001 00110 | ReturnStmt | Rueckgabe |
| 001 00111 | BreakStmt | Abbruch |
| 001 01000 | ContinueStmt | Fortsetzung |
| 001 01001 | GotoStmt | goto |
| 001 01010 | BlockStmt | Block { } |
| 001 01011 | ExprStmt | Ausdrucksanweisung |
| 001 01100 | AssignStmt | Zuweisung |
| 001 01101 | DeclStmt | Deklarationsanweisung |
| 001 01110 | TryStmt | Ausnahmebehandlung |
| 001 01111 | ThrowStmt | Ausnahmeausloesung |
| 001 10000 | DeferStmt | defer |
| 001 10001 | GoStmt | go |
| 001 10010 | SelectStmt | select |
| 001 10011 | WithStmt | with |
| 001 10100 | AssertStmt | assert |
| 001 10101 | PassStmt | pass |

### Expression (010xxxxx)

| Code | Knoten | Bedeutung |
|------|--------|-----------|
| 010 00000 | BinaryExpr | Binaere Operation |
| 010 00001 | UnaryExpr | Unaere Operation |
| 010 00010 | CallExpr | Funktionsaufruf |
| 010 00011 | IndexExpr | Indexzugriff a[i] |
| 010 00100 | SliceExpr | Slice a[i:j] |
| 010 00101 | SelectorExpr | Feldzugriff a.b |
| 010 00110 | Ident | Identifikator |
| 010 00111 | BasicLit | Basisliteral |
| 010 01000 | CompositeLit | Zusammengesetztes Literal |
| 010 01001 | FuncLit | Lambda/anonyme Funktion |
| 010 01010 | ParenExpr | Klammern (a) |
| 010 01011 | StarExpr | Zeiger *a |
| 010 01100 | UnaryAddr | Adresse &a |
| 010 01101 | TypeAssertExpr | Typ-Assertion |
| 010 01110 | KeyValueExpr | key: value |
| 010 01111 | TernaryExpr | Ternaere Operation |
| 010 10000 | ListComp | Listenkomprehension |
| 010 10001 | DictComp | Woerterbuchkomprehension |
| 010 10010 | GeneratorExpr | Generator |
| 010 10011 | AwaitExpr | await |
| 010 10100 | YieldExpr | yield |
| 010 10101 | SendExpr | Kanalsenden <- |
| 010 10110 | RecvExpr | Kanalempfangen <-ch |

### Type (011xxxxx)

| Code | Knoten | Bedeutung |
|------|--------|-----------|
| 011 00000 | IdentType | Benannter Typ |
| 011 00001 | PointerType | Zeiger *T |
| 011 00010 | ArrayType | Array [N]T |
| 011 00011 | SliceType | Slice []T |
| 011 00100 | MapType | Map map[K]V |
| 011 00101 | ChanType | Kanal chan T |
| 011 00110 | FuncType | Funktionstyp |
| 011 00111 | StructType | Strukturtyp |
| 011 01000 | InterfaceType | Schnittstellentyp |
| 011 01001 | UnionType | Union A \| B |
| 011 01010 | OptionalType | Optional T? |
| 011 01011 | GenericType | Generisch T[U] |
| 011 01100 | TupleType | Tupel (A, B) |

### Pattern (100xxxxx)

| Code | Knoten | Bedeutung |
|------|--------|-----------|
| 100 00000 | WildcardPattern | _ |
| 100 00001 | IdentPattern | Namensbindung |
| 100 00010 | LiteralPattern | Literal-Matching |
| 100 00011 | TuplePattern | Tupel (a, b) |
| 100 00100 | ListPattern | Liste [a, b] |
| 100 00101 | StructPattern | Struktur {a, b} |
| 100 00110 | OrPattern | a \| b |
| 100 00111 | GuardPattern | Waechterbedingung |

### Modifier (101xxxxx)

| Code | Knoten | Bedeutung |
|------|--------|-----------|
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

| Code | Knoten | Bedeutung |
|------|--------|-----------|
| 110 00000 | File | Datei (oberste Ebene) |
| 110 00001 | Module | Modul |
| 110 00010 | Package | Paket |
| 110 00011 | Namespace | Namensraum |
| 110 00100 | Block | Block |
| 110 00101 | CommentGroup | Kommentargruppe |
| 110 00110 | Comment | Kommentar |
| 110 00111 | Directive | Direktive (#pragma) |

### Language-specific (111xxxxx)

Sprachspezifische Knoten. 32 Plaetze verfuegbar.

## PathGEUL (111110)

PathGEUL ist eine Abfragesprache zur Traversierung von GEUL-Graphen. Wie XPath XML traversiert, traversiert PathGEUL GEUL-Graphen.

Wenn der Sprachcode `111110` ist, werden die 8-Bit-AST-Knotentypen als **Abfrageoperatoren** reinterpretiert.

| Code | Operation | XPath-Entsprechung | Beschreibung |
|------|-----------|---------------------|--------------|
| 00000000 | Root | / | Wurzelknoten |
| 00000001 | Child | /child | Direktes Kind |
| 00000010 | Descendant | // | Alle Nachfahren |
| 00000011 | Parent | .. | Elternknoten |
| 00000100 | Ancestor | ancestor:: | Alle Vorfahren |
| 00000101 | Sibling | sibling:: | Geschwister |
| 00010000 | FilterType | [type=...] | Typfilter |
| 00100000 | FilterProp | [@prop=...] | Eigenschaftsfilter |
| 01000000 | Union | \| | Vereinigung |
| 01000001 | Intersect | & | Schnittmenge |

## Beispiele

### Go-Funktionsdeklaration

```go
func Add(a, b int) int {
    return a + b
}
```

```
AST Edge (FuncDecl):
  1st: [Prefix 10bit] [000100]       - Prefix + Go
  2nd: [000 00000] [00000000]        - FuncDecl + Reserviert
  3rd: [TID: 0x0010]                 - TID dieses Edge
  4th: [TID: 0x0011]                 - Name "Add"
  5th: [TID: 0x0012]                 - Params
  6th: [TID: 0x0013]                 - Results
  7th: [TID: 0x0014]                 - Body
  8th: [0x0000]                      - Terminierung

Gesamt: 8 Woerter
```

### Python-Funktionsdefinition

```python
def greet(name: str) -> str:
    return f"Hello, {name}"
```

```
AST Edge (FuncDecl):
  1st: [Prefix 10bit] [100000]       - Prefix + Python
  2nd: [000 00000] [00000000]        - FuncDecl + Reserviert
  3rd: [TID: 0x0020]                 - TID dieses Edge
  4th: [TID: 0x0021]                 - Name "greet"
  5th: [TID: 0x0022]                 - Params
  6th: [TID: 0x0023]                 - Returns
  7th: [TID: 0x0024]                 - Body
  8th: [0x0000]                      - Terminierung

Gesamt: 8 Woerter
```

### Blattknoten (Identifikator)

```
AST Edge (Ident):
  1st: [Prefix 10bit] [000100]       - Prefix + Go
  2nd: [010 00110] [00000000]        - Ident + Reserviert
  3rd: [TID: 0x0030]                 - TID dieses Edge
  4th: [0x0000]                      - Terminierung (keine Kinder)

Gesamt: 4 Woerter
```
