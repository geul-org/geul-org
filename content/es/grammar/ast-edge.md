---
title: "AST Edge"
weight: 80
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "AST", "programming", "PathGEUL"]
summary: "Tipo de Edge que representa el AST de lenguajes de programación como un grafo GEUL. Clasifica 64 lenguajes con 6 bits y codifica 256 tipos de nodos AST con 8 bits. Incluye el lenguaje de consulta PathGEUL."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

AST Edge es un tipo de Edge que representa el **AST (Abstract Syntax Tree) de lenguajes de programación** como un grafo GEUL.

| Característica | Descripción |
|----------------|-------------|
| **Soporte multilenguaje** | 64 lenguajes con 6 bits |
| **Nodos AST comunes** | Los conceptos idénticos entre lenguajes comparten el mismo código |
| **Clasificación por linaje** | Soporte de degradación elegante (graceful degradation) |
| **Integración PathGEUL** | Incluye lenguaje de exploración de grafos GEUL |

## Estructura de paquete

```
1st WORD (16 bits)
┌─────────────────────┬────────────────────┐
│       Prefix        │      Lenguaje      │
│       10bit         │        6bit        │
└─────────────────────┴────────────────────┘

2nd WORD (16 bits)
┌─────────────────────────┬───────────────────┐
│    Tipo de nodo AST     │     Reservado     │
│         8bit            │       8bit        │
└─────────────────────────┴───────────────────┘

3rd WORD (16 bits)
┌─────────────────────────────────────────────┐
│                  Edge TID                   │
│                   16bit                     │
└─────────────────────────────────────────────┘

4th+ WORD: TIDs hijos (variable, termina con marcador 0x0000)
```

| Campo | Bits | Tamaño | Descripción |
|-------|------|--------|-------------|
| Prefix | 1-10 | 10 | `0001 000 001` (AST Edge) |
| Lenguaje | 11-16 | 6 | Código de lenguaje de programación |
| Tipo de nodo AST | 17-24 | 8 | Tipo de nodo (división 3+5) |
| Reservado | 25-32 | 8 | Para extensión futura (actualmente 0x00) |
| Edge TID | 33-48 | 16 | Identificador único de este Edge |
| TIDs hijos | 49+ | 16×N | Referencias a nodos hijos |

Palabras: mínimo 3 (nodo hoja) ~ general 4-8 ~ sin límite

## Código de lenguaje (6 bits)

Clasificación basada en linaje. Los bits 1-2 son la categoría principal (paradigma), los bits 3-6 son el lenguaje específico.

### Sistema/bajo nivel (00xxxx)

| Código | Lenguaje | Descripción |
|--------|----------|-------------|
| 000000 | **Abstract** | AST común a todos los lenguajes |
| 000001 | C | Arquetipo de lenguaje de sistema |
| 000010 | C++ | Extensión de C |
| 000011 | Rust | Sistema moderno |
| 000100 | Go | Sistema moderno |
| 000101 | Zig | Sistema moderno |
| 000110 | Assembly | Nivel más bajo |
| 000111 | D | Sistema |
| 001000 | Nim | Sistema |

### Aplicación/VM (01xxxx)

| Código | Lenguaje | Descripción |
|--------|----------|-------------|
| 010000 | Java | Arquetipo de familia VM |
| 010001 | C# | .NET |
| 010010 | Kotlin | JVM |
| 010011 | Scala | JVM+funcional |
| 010100 | Swift | Apple |
| 010101 | Dart | Flutter |
| 010110 | Groovy | JVM |
| 010111 | Clojure | JVM+Lisp |

### Script/dinámico (10xxxx)

| Código | Lenguaje | Descripción |
|--------|----------|-------------|
| 100000 | Python | Arquetipo de script de propósito general |
| 100001 | JavaScript | Web |
| 100010 | TypeScript | JS+tipos |
| 100011 | Ruby | Propósito general |
| 100100 | PHP | Servidor web |
| 100101 | Lua | Embebido |
| 100110 | Perl | Procesamiento de texto |
| 100111 | R | Estadística |
| 101000 | Julia | Computación científica |
| 101001 | MATLAB | Análisis numérico |

### Declarativo/funcional/otros (11xxxx)

| Código | Lenguaje | Descripción |
|--------|----------|-------------|
| 110000 | SQL | Consultas |
| 110001 | Haskell | Funcional puro |
| 110010 | OCaml | Familia ML |
| 110011 | F# | .NET funcional |
| 110100 | Elixir | BEAM |
| 110101 | Erlang | BEAM |
| 110110 | Shell | Bash/Zsh |
| 110111 | PowerShell | Windows |
| 111000 | WASM | Bytecode |
| 111001 | LLVM IR | Representación intermedia |
| 111010 | HTML | Marcado |
| 111011 | CSS | Estilos |
| 111100 | JSON | Datos |
| 111101 | YAML | Datos |
| 111110 | **PathGEUL** | Lenguaje de exploración de grafos GEUL |
| 111111 | **Palabra de extensión** | Lenguajes adicionales (especificado en 3rd word) |

**Degradación elegante:** En caso de pérdida de bits, converge al linaje superior → finalmente hace fallback a Abstract(000000).

## Tipo de nodo AST (8 bits)

División en 3 bits de categoría principal + 5 bits de subtipo.

### Categoría principal

| Código | Categoría | Descripción |
|--------|-----------|-------------|
| 000 | Declaration | Declaraciones (función, variable, tipo) |
| 001 | Statement | Sentencias (control, bucles) |
| 010 | Expression | Expresiones (operaciones, llamadas) |
| 011 | Type | Expresiones de tipo |
| 100 | Pattern | Coincidencia de patrones |
| 101 | Modifier | Modificadores (acceso, async) |
| 110 | Structure | Estructura (bloque, módulo) |
| 111 | Language-specific | Nodos específicos del lenguaje |

### Declaration (000xxxxx)

| Código | Nodo | Go | Python | C |
|--------|------|-----|--------|---|
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

| Código | Nodo | Significado |
|--------|------|-------------|
| 001 00000 | IfStmt | Condicional |
| 001 00001 | ForStmt | Bucle for |
| 001 00010 | RangeStmt | Bucle iterador |
| 001 00011 | WhileStmt | Bucle while |
| 001 00100 | SwitchStmt | switch/match |
| 001 00101 | CaseClause | Cláusula case |
| 001 00110 | ReturnStmt | Retorno |
| 001 00111 | BreakStmt | Salida |
| 001 01000 | ContinueStmt | Continuación |
| 001 01001 | GotoStmt | goto |
| 001 01010 | BlockStmt | Bloque { } |
| 001 01011 | ExprStmt | Sentencia de expresión |
| 001 01100 | AssignStmt | Asignación |
| 001 01101 | DeclStmt | Sentencia de declaración |
| 001 01110 | TryStmt | Manejo de excepciones |
| 001 01111 | ThrowStmt | Lanzamiento de excepción |
| 001 10000 | DeferStmt | defer |
| 001 10001 | GoStmt | go |
| 001 10010 | SelectStmt | select |
| 001 10011 | WithStmt | with |
| 001 10100 | AssertStmt | assert |
| 001 10101 | PassStmt | pass |

### Expression (010xxxxx)

| Código | Nodo | Significado |
|--------|------|-------------|
| 010 00000 | BinaryExpr | Operación binaria |
| 010 00001 | UnaryExpr | Operación unaria |
| 010 00010 | CallExpr | Llamada a función |
| 010 00011 | IndexExpr | Acceso por índice a[i] |
| 010 00100 | SliceExpr | Slice a[i:j] |
| 010 00101 | SelectorExpr | Acceso a campo a.b |
| 010 00110 | Ident | Identificador |
| 010 00111 | BasicLit | Literal básico |
| 010 01000 | CompositeLit | Literal compuesto |
| 010 01001 | FuncLit | Lambda/función anónima |
| 010 01010 | ParenExpr | Paréntesis (a) |
| 010 01011 | StarExpr | Puntero *a |
| 010 01100 | UnaryAddr | Dirección &a |
| 010 01101 | TypeAssertExpr | Aserción de tipo |
| 010 01110 | KeyValueExpr | key: value |
| 010 01111 | TernaryExpr | Operación ternaria |
| 010 10000 | ListComp | List comprehension |
| 010 10001 | DictComp | Dict comprehension |
| 010 10010 | GeneratorExpr | Generador |
| 010 10011 | AwaitExpr | await |
| 010 10100 | YieldExpr | yield |
| 010 10101 | SendExpr | Envío por canal <- |
| 010 10110 | RecvExpr | Recepción por canal <-ch |

### Type (011xxxxx)

| Código | Nodo | Significado |
|--------|------|-------------|
| 011 00000 | IdentType | Tipo por nombre |
| 011 00001 | PointerType | Puntero *T |
| 011 00010 | ArrayType | Array [N]T |
| 011 00011 | SliceType | Slice []T |
| 011 00100 | MapType | Map map[K]V |
| 011 00101 | ChanType | Canal chan T |
| 011 00110 | FuncType | Tipo función |
| 011 00111 | StructType | Tipo estructura |
| 011 01000 | InterfaceType | Tipo interfaz |
| 011 01001 | UnionType | Unión A \| B |
| 011 01010 | OptionalType | Opcional T? |
| 011 01011 | GenericType | Genérico T[U] |
| 011 01100 | TupleType | Tupla (A, B) |

### Pattern (100xxxxx)

| Código | Nodo | Significado |
|--------|------|-------------|
| 100 00000 | WildcardPattern | _ |
| 100 00001 | IdentPattern | Vinculación por nombre |
| 100 00010 | LiteralPattern | Coincidencia de literal |
| 100 00011 | TuplePattern | Tupla (a, b) |
| 100 00100 | ListPattern | Lista [a, b] |
| 100 00101 | StructPattern | Estructura {a, b} |
| 100 00110 | OrPattern | a \| b |
| 100 00111 | GuardPattern | Condición de guarda |

### Modifier (101xxxxx)

| Código | Nodo | Significado |
|--------|------|-------------|
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

| Código | Nodo | Significado |
|--------|------|-------------|
| 110 00000 | File | Archivo (nivel superior) |
| 110 00001 | Module | Módulo |
| 110 00010 | Package | Paquete |
| 110 00011 | Namespace | Espacio de nombres |
| 110 00100 | Block | Bloque |
| 110 00101 | CommentGroup | Grupo de comentarios |
| 110 00110 | Comment | Comentario |
| 110 00111 | Directive | Directiva (#pragma) |

### Language-specific (111xxxxx)

Nodos específicos de cada lenguaje. 32 espacios disponibles.

## PathGEUL (111110)

PathGEUL es un lenguaje de consulta para explorar grafos GEUL. Así como XPath explora XML, PathGEUL explora grafos GEUL.

Cuando el código de lenguaje es `111110`, el tipo de nodo AST de 8 bits se reinterpreta como **operador de consulta**.

| Código | Operación | Correspondencia XPath | Descripción |
|--------|-----------|----------------------|-------------|
| 00000000 | Root | / | Nodo raíz |
| 00000001 | Child | /child | Hijo directo |
| 00000010 | Descendant | // | Todos los descendientes |
| 00000011 | Parent | .. | Padre |
| 00000100 | Ancestor | ancestor:: | Todos los ancestros |
| 00000101 | Sibling | sibling:: | Hermanos |
| 00010000 | FilterType | [type=...] | Filtro de tipo |
| 00100000 | FilterProp | [@prop=...] | Filtro de propiedad |
| 01000000 | Union | \| | Unión |
| 01000001 | Intersect | & | Intersección |

## Ejemplos

### Declaración de función Go

```go
func Add(a, b int) int {
    return a + b
}
```

```
AST Edge (FuncDecl):
  1st: [Prefix 10bit] [000100]       - Prefix + Go
  2nd: [000 00000] [00000000]        - FuncDecl + Reservado
  3rd: [TID: 0x0010]                 - TID de este Edge
  4th: [TID: 0x0011]                 - Nombre "Add"
  5th: [TID: 0x0012]                 - Parámetros
  6th: [TID: 0x0013]                 - Resultados
  7th: [TID: 0x0014]                 - Cuerpo
  8th: [0x0000]                      - Terminación

Total: 8 palabras
```

### Definición de función Python

```python
def greet(name: str) -> str:
    return f"Hello, {name}"
```

```
AST Edge (FuncDecl):
  1st: [Prefix 10bit] [100000]       - Prefix + Python
  2nd: [000 00000] [00000000]        - FuncDecl + Reservado
  3rd: [TID: 0x0020]                 - TID de este Edge
  4th: [TID: 0x0021]                 - Nombre "greet"
  5th: [TID: 0x0022]                 - Parámetros
  6th: [TID: 0x0023]                 - Resultados
  7th: [TID: 0x0024]                 - Cuerpo
  8th: [0x0000]                      - Terminación

Total: 8 palabras
```

### Nodo hoja (identificador)

```
AST Edge (Ident):
  1st: [Prefix 10bit] [000100]       - Prefix + Go
  2nd: [010 00110] [00000000]        - Ident + Reservado
  3rd: [TID: 0x0030]                 - TID de este Edge
  4th: [0x0000]                      - Terminación (sin hijos)

Total: 4 palabras
```
