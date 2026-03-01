---
title: "AST Edge"
weight: 80
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "AST", "programming", "PathGEUL"]
summary: "Tipe Edge untuk merepresentasikan AST bahasa pemrograman dalam graf GEUL. 6 bit meng-encode 64 bahasa, 8 bit meng-encode 256 tipe node AST. Termasuk bahasa kueri PathGEUL."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

AST Edge adalah tipe Edge untuk merepresentasikan **AST (Abstract Syntax Tree) bahasa pemrograman** dalam graf GEUL.

| Karakteristik | Deskripsi |
|---------------|-----------|
| **Dukungan multi-bahasa** | 6 bit untuk 64 bahasa |
| **Node AST umum** | Konsep yang sama = kode yang sama |
| **Klasifikasi berbasis rumpun** | Mendukung graceful degradation |
| **Integrasi PathGEUL** | Bahasa navigasi graf GEUL bawaan |

## Struktur Paket

```
1st WORD (16 bit)
┌─────────────────────┬────────────────────┐
│       Prefix        │       Bahasa       │
│       10bit         │        6bit        │
└─────────────────────┴────────────────────┘

2nd WORD (16 bit)
┌─────────────────────────┬───────────────────┐
│     Tipe node AST       │     Cadangan      │
│         8bit            │       8bit        │
└─────────────────────────┴───────────────────┘

3rd WORD (16 bit)
┌─────────────────────────────────────────────┐
│                  Edge TID                   │
│                   16bit                     │
└─────────────────────────────────────────────┘

4th+ WORD: TID anak (variabel, diakhiri marker 0x0000)
```

| Field | Bit | Ukuran | Deskripsi |
|-------|-----|--------|-----------|
| Prefix | 1-10 | 10 | `0001 000 001` (AST Edge) |
| Bahasa | 11-16 | 6 | Kode bahasa pemrograman |
| Tipe node AST | 17-24 | 8 | Jenis node (pembagian 3+5) |
| Cadangan | 25-32 | 8 | Ekstensi masa depan (saat ini 0x00) |
| Edge TID | 33-48 | 16 | ID unik Edge ini |
| TID anak | 49+ | 16×N | Referensi ke node anak |

Jumlah word: minimal 3 (leaf) ~ umumnya 4-8 ~ tanpa batas

## Kode Bahasa (6 bit)

Klasifikasi berbasis rumpun. bit1-2 kategori besar (paradigma), bit3-6 bahasa spesifik.

### Sistem/level rendah (00xxxx)

| Kode | Bahasa | Deskripsi |
|------|--------|-----------|
| 000000 | **Abstract** | AST umum semua bahasa |
| 000001 | C | Prototipe bahasa sistem |
| 000010 | C++ | Ekstensi C |
| 000011 | Rust | Sistem modern |
| 000100 | Go | Sistem modern |
| 000101 | Zig | Sistem modern |
| 000110 | Assembly | Level terendah |
| 000111 | D | Sistem |
| 001000 | Nim | Sistem |

### Aplikasi/VM (01xxxx)

| Kode | Bahasa | Deskripsi |
|------|--------|-----------|
| 010000 | Java | Prototipe VM |
| 010001 | C# | .NET |
| 010010 | Kotlin | JVM |
| 010011 | Scala | JVM+fungsional |
| 010100 | Swift | Apple |
| 010101 | Dart | Flutter |
| 010110 | Groovy | JVM |
| 010111 | Clojure | JVM+Lisp |

### Skrip/dinamis (10xxxx)

| Kode | Bahasa | Deskripsi |
|------|--------|-----------|
| 100000 | Python | Prototipe skrip |
| 100001 | JavaScript | Web |
| 100010 | TypeScript | JS+tipe |
| 100011 | Ruby | Umum |
| 100100 | PHP | Server web |
| 100101 | Lua | Embedded |
| 100110 | Perl | Pemrosesan teks |
| 100111 | R | Statistik |
| 101000 | Julia | Komputasi ilmiah |
| 101001 | MATLAB | Analisis numerik |

### Deklaratif/fungsional/lainnya (11xxxx)

| Kode | Bahasa | Deskripsi |
|------|--------|-----------|
| 110000 | SQL | Kueri |
| 110001 | Haskell | Fungsional murni |
| 110010 | OCaml | Keluarga ML |
| 110011 | F# | .NET fungsional |
| 110100 | Elixir | BEAM |
| 110101 | Erlang | BEAM |
| 110110 | Shell | Bash/Zsh |
| 110111 | PowerShell | Windows |
| 111000 | WASM | Bytecode |
| 111001 | LLVM IR | Representasi intermediate |
| 111010 | HTML | Markup |
| 111011 | CSS | Style |
| 111100 | JSON | Data |
| 111101 | YAML | Data |
| 111110 | **PathGEUL** | Bahasa navigasi graf GEUL |
| 111111 | **Ekstensi** | Bahasa tambahan (ditentukan di word ke-3) |

**Graceful degradation:** Jika bit hilang, konvergensi ke cabang atas → akhirnya fallback ke Abstract(000000).

## Tipe Node AST (8 bit)

Pembagian 3-bit kategori besar + 5-bit subtipe.

### Kategori Besar

| Kode | Kategori | Deskripsi |
|------|----------|-----------|
| 000 | Declaration | Deklarasi (fungsi, variabel, tipe) |
| 001 | Statement | Pernyataan (kondisi, loop) |
| 010 | Expression | Ekspresi (operasi, panggilan) |
| 011 | Type | Ekspresi tipe |
| 100 | Pattern | Pattern matching |
| 101 | Modifier | Pengubah (akses, async) |
| 110 | Structure | Struktur (blok, modul) |
| 111 | Language-specific | Node spesifik bahasa |

### Declaration (000xxxxx)

| Kode | Node | Go | Python | C |
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

| Kode | Node | Makna |
|------|------|-------|
| 001 00000 | IfStmt | Pernyataan kondisi |
| 001 00001 | ForStmt | Loop for |
| 001 00010 | RangeStmt | Loop iterator |
| 001 00011 | WhileStmt | Loop while |
| 001 00100 | SwitchStmt | switch/match |
| 001 00101 | CaseClause | Klausa case |
| 001 00110 | ReturnStmt | Return |
| 001 00111 | BreakStmt | Break |
| 001 01000 | ContinueStmt | Continue |
| 001 01001 | GotoStmt | goto |
| 001 01010 | BlockStmt | Blok { } |
| 001 01011 | ExprStmt | Pernyataan ekspresi |
| 001 01100 | AssignStmt | Penugasan |
| 001 01101 | DeclStmt | Pernyataan deklarasi |
| 001 01110 | TryStmt | Penanganan eksepsi |
| 001 01111 | ThrowStmt | Pelemparan eksepsi |
| 001 10000 | DeferStmt | defer |
| 001 10001 | GoStmt | go |
| 001 10010 | SelectStmt | select |
| 001 10011 | WithStmt | with |
| 001 10100 | AssertStmt | assert |
| 001 10101 | PassStmt | pass |

### Expression (010xxxxx)

| Kode | Node | Makna |
|------|------|-------|
| 010 00000 | BinaryExpr | Operasi biner |
| 010 00001 | UnaryExpr | Operasi uner |
| 010 00010 | CallExpr | Pemanggilan fungsi |
| 010 00011 | IndexExpr | Akses indeks a[i] |
| 010 00100 | SliceExpr | Slice a[i:j] |
| 010 00101 | SelectorExpr | Akses field a.b |
| 010 00110 | Ident | Identifier |
| 010 00111 | BasicLit | Literal dasar |
| 010 01000 | CompositeLit | Literal komposit |
| 010 01001 | FuncLit | Lambda/fungsi anonim |
| 010 01010 | ParenExpr | Tanda kurung (a) |
| 010 01011 | StarExpr | Pointer *a |
| 010 01100 | UnaryAddr | Alamat &a |
| 010 01101 | TypeAssertExpr | Type assertion |
| 010 01110 | KeyValueExpr | key: value |
| 010 01111 | TernaryExpr | Operasi terner |
| 010 10000 | ListComp | List comprehension |
| 010 10001 | DictComp | Dict comprehension |
| 010 10010 | GeneratorExpr | Generator |
| 010 10011 | AwaitExpr | await |
| 010 10100 | YieldExpr | yield |
| 010 10101 | SendExpr | Kirim ke channel <- |
| 010 10110 | RecvExpr | Terima dari channel <-ch |

### Type (011xxxxx)

| Kode | Node | Makna |
|------|------|-------|
| 011 00000 | IdentType | Tipe bernama |
| 011 00001 | PointerType | Pointer *T |
| 011 00010 | ArrayType | Array [N]T |
| 011 00011 | SliceType | Slice []T |
| 011 00100 | MapType | Map map[K]V |
| 011 00101 | ChanType | Channel chan T |
| 011 00110 | FuncType | Tipe fungsi |
| 011 00111 | StructType | Tipe struct |
| 011 01000 | InterfaceType | Tipe interface |
| 011 01001 | UnionType | Union A \| B |
| 011 01010 | OptionalType | Optional T? |
| 011 01011 | GenericType | Generic T[U] |
| 011 01100 | TupleType | Tuple (A, B) |

### Pattern (100xxxxx)

| Kode | Node | Makna |
|------|------|-------|
| 100 00000 | WildcardPattern | _ |
| 100 00001 | IdentPattern | Binding nama |
| 100 00010 | LiteralPattern | Pencocokan literal |
| 100 00011 | TuplePattern | Tuple (a, b) |
| 100 00100 | ListPattern | List [a, b] |
| 100 00101 | StructPattern | Struct {a, b} |
| 100 00110 | OrPattern | a \| b |
| 100 00111 | GuardPattern | Kondisi guard |

### Modifier (101xxxxx)

| Kode | Node | Makna |
|------|------|-------|
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

| Kode | Node | Makna |
|------|------|-------|
| 110 00000 | File | File (level atas) |
| 110 00001 | Module | Modul |
| 110 00010 | Package | Paket |
| 110 00011 | Namespace | Namespace |
| 110 00100 | Block | Blok |
| 110 00101 | CommentGroup | Grup komentar |
| 110 00110 | Comment | Komentar |
| 110 00111 | Directive | Direktif (#pragma) |

### Language-specific (111xxxxx)

Node spesifik tiap bahasa. 32 slot tersedia.

## PathGEUL (111110)

PathGEUL adalah bahasa kueri untuk menavigasi graf GEUL. Seperti XPath menavigasi XML, PathGEUL menavigasi graf GEUL.

Saat kode bahasa `111110`, 8-bit tipe node AST diinterpretasikan ulang sebagai **operator kueri**.

| Kode | Operasi | Padanan XPath | Deskripsi |
|------|---------|---------------|-----------|
| 00000000 | Root | / | Node akar |
| 00000001 | Child | /child | Anak langsung |
| 00000010 | Descendant | // | Semua keturunan |
| 00000011 | Parent | .. | Induk |
| 00000100 | Ancestor | ancestor:: | Semua leluhur |
| 00000101 | Sibling | sibling:: | Saudara |
| 00010000 | FilterType | [type=...] | Filter tipe |
| 00100000 | FilterProp | [@prop=...] | Filter properti |
| 01000000 | Union | \| | Gabungan |
| 01000001 | Intersect | & | Irisan |

## Contoh

### Deklarasi Fungsi Go

```go
func Add(a, b int) int {
    return a + b
}
```

```
AST Edge (FuncDecl):
  1st: [Prefix 10bit] [000100]       - Prefix + Go
  2nd: [000 00000] [00000000]        - FuncDecl + cadangan
  3rd: [TID: 0x0010]                 - TID Edge ini
  4th: [TID: 0x0011]                 - Name "Add"
  5th: [TID: 0x0012]                 - Params
  6th: [TID: 0x0013]                 - Results
  7th: [TID: 0x0014]                 - Body
  8th: [0x0000]                      - terminasi

Total: 8 word
```

### Definisi Fungsi Python

```python
def greet(name: str) -> str:
    return f"Hello, {name}"
```

```
AST Edge (FuncDecl):
  1st: [Prefix 10bit] [100000]       - Prefix + Python
  2nd: [000 00000] [00000000]        - FuncDecl + cadangan
  3rd: [TID: 0x0020]                 - TID Edge ini
  4th: [TID: 0x0021]                 - Name "greet"
  5th: [TID: 0x0022]                 - Params
  6th: [TID: 0x0023]                 - Returns
  7th: [TID: 0x0024]                 - Body
  8th: [0x0000]                      - terminasi

Total: 8 word
```

### Node Leaf (identifier)

```
AST Edge (Ident):
  1st: [Prefix 10bit] [000100]       - Prefix + Go
  2nd: [010 00110] [00000000]        - Ident + cadangan
  3rd: [TID: 0x0030]                 - TID Edge ini
  4th: [0x0000]                      - terminasi (tanpa anak)

Total: 4 word
```
