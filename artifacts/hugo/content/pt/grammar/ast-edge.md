---
title: "AST Edge"
weight: 80
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "AST", "programming", "PathGEUL"]
summary: "Tipo de Edge que representa o AST de linguagens de programação como um grafo GEUL. Classifica 64 linguagens com 6 bits e codifica 256 tipos de nós AST com 8 bits. Inclui a linguagem de consulta PathGEUL."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

AST Edge é um tipo de Edge que representa o **AST (Abstract Syntax Tree) de linguagens de programação** como um grafo GEUL.

| Característica | Descrição |
|----------------|-----------|
| **Suporte multilinguagem** | 64 linguagens com 6 bits |
| **Nós AST comuns** | Conceitos idênticos entre linguagens partilham o mesmo código |
| **Classificação por linhagem** | Suporte de degradação elegante (graceful degradation) |
| **Integração PathGEUL** | Inclui linguagem de exploração de grafos GEUL |

## Estrutura do pacote

```
1st WORD (16 bits)
┌─────────────────────┬────────────────────┐
│       Prefix        │     Linguagem      │
│       10bit         │        6bit        │
└─────────────────────┴────────────────────┘

2nd WORD (16 bits)
┌─────────────────────────┬───────────────────┐
│    Tipo de nó AST       │     Reservado     │
│         8bit            │       8bit        │
└─────────────────────────┴───────────────────┘

3rd WORD (16 bits)
┌─────────────────────────────────────────────┐
│                  Edge TID                   │
│                   16bit                     │
└─────────────────────────────────────────────┘

4th+ WORD: TIDs filhos (variável, termina com marcador 0x0000)
```

| Campo | Bits | Tamanho | Descrição |
|-------|------|---------|-----------|
| Prefix | 1-10 | 10 | `0001 000 001` (AST Edge) |
| Linguagem | 11-16 | 6 | Código da linguagem de programação |
| Tipo de nó AST | 17-24 | 8 | Tipo de nó (divisão 3+5) |
| Reservado | 25-32 | 8 | Para extensão futura (atualmente 0x00) |
| Edge TID | 33-48 | 16 | Identificador único deste Edge |
| TIDs filhos | 49+ | 16×N | Referências a nós filhos |

Palavras: mínimo 3 (nó folha) ~ geral 4-8 ~ sem limite

## Código de linguagem (6 bits)

Classificação baseada em linhagem. Bits 1-2 são a categoria principal (paradigma), bits 3-6 são a linguagem específica.

### Sistema/baixo nível (00xxxx)

| Código | Linguagem | Descrição |
|--------|-----------|-----------|
| 000000 | **Abstract** | AST comum a todas as linguagens |
| 000001 | C | Arquétipo de linguagem de sistema |
| 000010 | C++ | Extensão de C |
| 000011 | Rust | Sistema moderno |
| 000100 | Go | Sistema moderno |
| 000101 | Zig | Sistema moderno |
| 000110 | Assembly | Nível mais baixo |
| 000111 | D | Sistema |
| 001000 | Nim | Sistema |

### Aplicação/VM (01xxxx)

| Código | Linguagem | Descrição |
|--------|-----------|-----------|
| 010000 | Java | Arquétipo de família VM |
| 010001 | C# | .NET |
| 010010 | Kotlin | JVM |
| 010011 | Scala | JVM+funcional |
| 010100 | Swift | Apple |
| 010101 | Dart | Flutter |
| 010110 | Groovy | JVM |
| 010111 | Clojure | JVM+Lisp |

### Script/dinâmico (10xxxx)

| Código | Linguagem | Descrição |
|--------|-----------|-----------|
| 100000 | Python | Arquétipo de script de propósito geral |
| 100001 | JavaScript | Web |
| 100010 | TypeScript | JS+tipos |
| 100011 | Ruby | Propósito geral |
| 100100 | PHP | Servidor web |
| 100101 | Lua | Embutido |
| 100110 | Perl | Processamento de texto |
| 100111 | R | Estatística |
| 101000 | Julia | Computação científica |
| 101001 | MATLAB | Análise numérica |

### Declarativo/funcional/outros (11xxxx)

| Código | Linguagem | Descrição |
|--------|-----------|-----------|
| 110000 | SQL | Consultas |
| 110001 | Haskell | Funcional puro |
| 110010 | OCaml | Família ML |
| 110011 | F# | .NET funcional |
| 110100 | Elixir | BEAM |
| 110101 | Erlang | BEAM |
| 110110 | Shell | Bash/Zsh |
| 110111 | PowerShell | Windows |
| 111000 | WASM | Bytecode |
| 111001 | LLVM IR | Representação intermediária |
| 111010 | HTML | Marcação |
| 111011 | CSS | Estilos |
| 111100 | JSON | Dados |
| 111101 | YAML | Dados |
| 111110 | **PathGEUL** | Linguagem de exploração de grafos GEUL |
| 111111 | **Palavra de extensão** | Linguagens adicionais (especificado na 3.ª palavra) |

**Degradação elegante:** Em caso de perda de bits, converge para a linhagem superior → finalmente faz fallback para Abstract(000000).

## Tipo de nó AST (8 bits)

Divisão em 3 bits de categoria principal + 5 bits de subtipo.

### Categoria principal

| Código | Categoria | Descrição |
|--------|-----------|-----------|
| 000 | Declaration | Declarações (função, variável, tipo) |
| 001 | Statement | Instruções (controle, loops) |
| 010 | Expression | Expressões (operações, chamadas) |
| 011 | Type | Expressões de tipo |
| 100 | Pattern | Correspondência de padrões |
| 101 | Modifier | Modificadores (acesso, async) |
| 110 | Structure | Estrutura (bloco, módulo) |
| 111 | Language-specific | Nós específicos da linguagem |

### Declaration (000xxxxx)

| Código | Nó | Go | Python | C |
|--------|-----|-----|--------|---|
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

| Código | Nó | Significado |
|--------|-----|-------------|
| 001 00000 | IfStmt | Condicional |
| 001 00001 | ForStmt | Loop for |
| 001 00010 | RangeStmt | Loop iterador |
| 001 00011 | WhileStmt | Loop while |
| 001 00100 | SwitchStmt | switch/match |
| 001 00101 | CaseClause | Cláusula case |
| 001 00110 | ReturnStmt | Retorno |
| 001 00111 | BreakStmt | Saída |
| 001 01000 | ContinueStmt | Continuação |
| 001 01001 | GotoStmt | goto |
| 001 01010 | BlockStmt | Bloco { } |
| 001 01011 | ExprStmt | Instrução de expressão |
| 001 01100 | AssignStmt | Atribuição |
| 001 01101 | DeclStmt | Instrução de declaração |
| 001 01110 | TryStmt | Tratamento de exceções |
| 001 01111 | ThrowStmt | Lançamento de exceção |
| 001 10000 | DeferStmt | defer |
| 001 10001 | GoStmt | go |
| 001 10010 | SelectStmt | select |
| 001 10011 | WithStmt | with |
| 001 10100 | AssertStmt | assert |
| 001 10101 | PassStmt | pass |

### Expression (010xxxxx)

| Código | Nó | Significado |
|--------|-----|-------------|
| 010 00000 | BinaryExpr | Operação binária |
| 010 00001 | UnaryExpr | Operação unária |
| 010 00010 | CallExpr | Chamada de função |
| 010 00011 | IndexExpr | Acesso por índice a[i] |
| 010 00100 | SliceExpr | Slice a[i:j] |
| 010 00101 | SelectorExpr | Acesso a campo a.b |
| 010 00110 | Ident | Identificador |
| 010 00111 | BasicLit | Literal básico |
| 010 01000 | CompositeLit | Literal composto |
| 010 01001 | FuncLit | Lambda/função anónima |
| 010 01010 | ParenExpr | Parênteses (a) |
| 010 01011 | StarExpr | Ponteiro *a |
| 010 01100 | UnaryAddr | Endereço &a |
| 010 01101 | TypeAssertExpr | Asserção de tipo |
| 010 01110 | KeyValueExpr | key: value |
| 010 01111 | TernaryExpr | Operação ternária |
| 010 10000 | ListComp | List comprehension |
| 010 10001 | DictComp | Dict comprehension |
| 010 10010 | GeneratorExpr | Gerador |
| 010 10011 | AwaitExpr | await |
| 010 10100 | YieldExpr | yield |
| 010 10101 | SendExpr | Envio por canal <- |
| 010 10110 | RecvExpr | Recepção por canal <-ch |

### Type (011xxxxx)

| Código | Nó | Significado |
|--------|-----|-------------|
| 011 00000 | IdentType | Tipo por nome |
| 011 00001 | PointerType | Ponteiro *T |
| 011 00010 | ArrayType | Array [N]T |
| 011 00011 | SliceType | Slice []T |
| 011 00100 | MapType | Map map[K]V |
| 011 00101 | ChanType | Canal chan T |
| 011 00110 | FuncType | Tipo função |
| 011 00111 | StructType | Tipo estrutura |
| 011 01000 | InterfaceType | Tipo interface |
| 011 01001 | UnionType | União A \| B |
| 011 01010 | OptionalType | Opcional T? |
| 011 01011 | GenericType | Genérico T[U] |
| 011 01100 | TupleType | Tupla (A, B) |

### Pattern (100xxxxx)

| Código | Nó | Significado |
|--------|-----|-------------|
| 100 00000 | WildcardPattern | _ |
| 100 00001 | IdentPattern | Vinculação por nome |
| 100 00010 | LiteralPattern | Correspondência de literal |
| 100 00011 | TuplePattern | Tupla (a, b) |
| 100 00100 | ListPattern | Lista [a, b] |
| 100 00101 | StructPattern | Estrutura {a, b} |
| 100 00110 | OrPattern | a \| b |
| 100 00111 | GuardPattern | Condição de guarda |

### Modifier (101xxxxx)

| Código | Nó | Significado |
|--------|-----|-------------|
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

| Código | Nó | Significado |
|--------|-----|-------------|
| 110 00000 | File | Arquivo (nível superior) |
| 110 00001 | Module | Módulo |
| 110 00010 | Package | Pacote |
| 110 00011 | Namespace | Namespace |
| 110 00100 | Block | Bloco |
| 110 00101 | CommentGroup | Grupo de comentários |
| 110 00110 | Comment | Comentário |
| 110 00111 | Directive | Diretiva (#pragma) |

### Language-specific (111xxxxx)

Nós específicos de cada linguagem. 32 espaços disponíveis.

## PathGEUL (111110)

PathGEUL é uma linguagem de consulta para explorar grafos GEUL. Assim como XPath explora XML, PathGEUL explora grafos GEUL.

Quando o código de linguagem é `111110`, o tipo de nó AST de 8 bits é reinterpretado como **operador de consulta**.

| Código | Operação | Correspondência XPath | Descrição |
|--------|----------|----------------------|-----------|
| 00000000 | Root | / | Nó raiz |
| 00000001 | Child | /child | Filho direto |
| 00000010 | Descendant | // | Todos os descendentes |
| 00000011 | Parent | .. | Pai |
| 00000100 | Ancestor | ancestor:: | Todos os ancestrais |
| 00000101 | Sibling | sibling:: | Irmãos |
| 00010000 | FilterType | [type=...] | Filtro de tipo |
| 00100000 | FilterProp | [@prop=...] | Filtro de propriedade |
| 01000000 | Union | \| | União |
| 01000001 | Intersect | & | Interseção |

## Exemplos

### Declaração de função Go

```go
func Add(a, b int) int {
    return a + b
}
```

```
AST Edge (FuncDecl):
  1st: [Prefix 10bit] [000100]       - Prefix + Go
  2nd: [000 00000] [00000000]        - FuncDecl + Reservado
  3rd: [TID: 0x0010]                 - TID deste Edge
  4th: [TID: 0x0011]                 - Nome "Add"
  5th: [TID: 0x0012]                 - Parâmetros
  6th: [TID: 0x0013]                 - Resultados
  7th: [TID: 0x0014]                 - Corpo
  8th: [0x0000]                      - Terminação

Total: 8 palavras
```

### Definição de função Python

```python
def greet(name: str) -> str:
    return f"Hello, {name}"
```

```
AST Edge (FuncDecl):
  1st: [Prefix 10bit] [100000]       - Prefix + Python
  2nd: [000 00000] [00000000]        - FuncDecl + Reservado
  3rd: [TID: 0x0020]                 - TID deste Edge
  4th: [TID: 0x0021]                 - Nome "greet"
  5th: [TID: 0x0022]                 - Parâmetros
  6th: [TID: 0x0023]                 - Resultados
  7th: [TID: 0x0024]                 - Corpo
  8th: [0x0000]                      - Terminação

Total: 8 palavras
```

### Nó folha (identificador)

```
AST Edge (Ident):
  1st: [Prefix 10bit] [000100]       - Prefix + Go
  2nd: [010 00110] [00000000]        - Ident + Reservado
  3rd: [TID: 0x0030]                 - TID deste Edge
  4th: [0x0000]                      - Terminação (sem filhos)

Total: 4 palavras
```
