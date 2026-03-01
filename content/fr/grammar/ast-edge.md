---
title: "AST Edge"
weight: 80
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "AST", "programming", "PathGEUL"]
summary: "Type d'Edge representant l'AST de langages de programmation sous forme de graphe GEUL. 6 bits classifient 64 langages, 8 bits encodent 256 types de noeuds AST. Inclut le langage de requete PathGEUL."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

AST Edge est un type d'Edge qui represente l'**AST (Abstract Syntax Tree) des langages de programmation** sous forme de graphe GEUL.

| Caracteristique | Description |
|-----------------|-------------|
| **Support multilingue** | 64 langages sur 6 bits |
| **Noeuds AST communs** | Meme code pour les memes concepts entre langages |
| **Classification par famille** | Support de la degradation elegante (graceful degradation) |
| **Integration PathGEUL** | Langage de parcours de graphe GEUL inclus |

## Structure du paquet

```
1st WORD (16 bits)
┌─────────────────────┬────────────────────┐
│       Prefix        │      Langage       │
│       10bit         │        6bit        │
└─────────────────────┴────────────────────┘

2nd WORD (16 bits)
┌─────────────────────────┬───────────────────┐
│    Type de noeud AST    │      Reserve      │
│         8bit            │       8bit        │
└─────────────────────────┴───────────────────┘

3rd WORD (16 bits)
┌─────────────────────────────────────────────┐
│                  Edge TID                   │
│                   16bit                     │
└─────────────────────────────────────────────┘

4th+ WORD: TID enfants (variable, termine par le marqueur 0x0000)
```

| Champ | Bits | Taille | Description |
|-------|------|--------|-------------|
| Prefix | 1-10 | 10 | `0001 000 001` (AST Edge) |
| Langage | 11-16 | 6 | Code du langage de programmation |
| Type de noeud AST | 17-24 | 8 | Type de noeud (division 3+5) |
| Reserve | 25-32 | 8 | Pour extension future (actuellement 0x00) |
| Edge TID | 33-48 | 16 | Identifiant unique de cet Edge |
| TID enfants | 49+ | 16xN | References aux noeuds enfants |

Nombre de mots : minimum 3 (noeud feuille) ~ generalement 4-8 ~ sans limite.

## Codes de langages (6 bits)

Classification par famille. bit1-2 = categorie principale (paradigme), bit3-6 = langage specifique.

### Systeme/bas niveau (00xxxx)

| Code | Langage | Description |
|------|---------|-------------|
| 000000 | **Abstract** | AST commun a tous les langages |
| 000001 | C | Prototype des langages systeme |
| 000010 | C++ | Extension du C |
| 000011 | Rust | Systeme moderne |
| 000100 | Go | Systeme moderne |
| 000101 | Zig | Systeme moderne |
| 000110 | Assembly | Plus bas niveau |
| 000111 | D | Systeme |
| 001000 | Nim | Systeme |

### Application/VM (01xxxx)

| Code | Langage | Description |
|------|---------|-------------|
| 010000 | Java | Prototype de la famille VM |
| 010001 | C# | .NET |
| 010010 | Kotlin | JVM |
| 010011 | Scala | JVM+fonctionnel |
| 010100 | Swift | Apple |
| 010101 | Dart | Flutter |
| 010110 | Groovy | JVM |
| 010111 | Clojure | JVM+Lisp |

### Script/dynamique (10xxxx)

| Code | Langage | Description |
|------|---------|-------------|
| 100000 | Python | Prototype script polyvalent |
| 100001 | JavaScript | Web |
| 100010 | TypeScript | JS+types |
| 100011 | Ruby | Polyvalent |
| 100100 | PHP | Serveur web |
| 100101 | Lua | Embarque |
| 100110 | Perl | Traitement de texte |
| 100111 | R | Statistiques |
| 101000 | Julia | Calcul scientifique |
| 101001 | MATLAB | Calcul numerique |

### Declaratif/fonctionnel/autre (11xxxx)

| Code | Langage | Description |
|------|---------|-------------|
| 110000 | SQL | Requetes |
| 110001 | Haskell | Fonctionnel pur |
| 110010 | OCaml | Famille ML |
| 110011 | F# | .NET fonctionnel |
| 110100 | Elixir | BEAM |
| 110101 | Erlang | BEAM |
| 110110 | Shell | Bash/Zsh |
| 110111 | PowerShell | Windows |
| 111000 | WASM | Bytecode |
| 111001 | LLVM IR | Representation intermediaire |
| 111010 | HTML | Balisage |
| 111011 | CSS | Style |
| 111100 | JSON | Donnees |
| 111101 | YAML | Donnees |
| 111110 | **PathGEUL** | Langage de parcours de graphe GEUL |
| 111111 | **Mot d'extension** | Langages supplementaires (specifie dans le 3e mot) |

**Degradation elegante :** en cas de perte de bits, convergence vers la famille superieure → repli final vers Abstract (000000).

## Types de noeuds AST (8 bits)

Division en 3 bits de categorie principale + 5 bits de sous-type.

### Categories principales

| Code | Categorie | Description |
|------|-----------|-------------|
| 000 | Declaration | Declarations (fonction, variable, type) |
| 001 | Statement | Instructions (controle, boucles) |
| 010 | Expression | Expressions (operations, appels) |
| 011 | Type | Expressions de type |
| 100 | Pattern | Filtrage par motif |
| 101 | Modifier | Modificateurs (acces, async) |
| 110 | Structure | Structures (bloc, module) |
| 111 | Language-specific | Noeuds specifiques au langage |

### Declaration (000xxxxx)

| Code | Noeud | Go | Python | C |
|------|-------|-----|--------|---|
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

| Code | Noeud | Signification |
|------|-------|---------------|
| 001 00000 | IfStmt | Condition |
| 001 00001 | ForStmt | Boucle for |
| 001 00010 | RangeStmt | Boucle iterateur |
| 001 00011 | WhileStmt | Boucle while |
| 001 00100 | SwitchStmt | switch/match |
| 001 00101 | CaseClause | Clause case |
| 001 00110 | ReturnStmt | Retour |
| 001 00111 | BreakStmt | Sortie |
| 001 01000 | ContinueStmt | Continuation |
| 001 01001 | GotoStmt | goto |
| 001 01010 | BlockStmt | Bloc { } |
| 001 01011 | ExprStmt | Expression en instruction |
| 001 01100 | AssignStmt | Assignation |
| 001 01101 | DeclStmt | Instruction de declaration |
| 001 01110 | TryStmt | Gestion d'exception |
| 001 01111 | ThrowStmt | Declenchement d'exception |
| 001 10000 | DeferStmt | defer |
| 001 10001 | GoStmt | go |
| 001 10010 | SelectStmt | select |
| 001 10011 | WithStmt | with |
| 001 10100 | AssertStmt | assert |
| 001 10101 | PassStmt | pass |

### Expression (010xxxxx)

| Code | Noeud | Signification |
|------|-------|---------------|
| 010 00000 | BinaryExpr | Operation binaire |
| 010 00001 | UnaryExpr | Operation unaire |
| 010 00010 | CallExpr | Appel de fonction |
| 010 00011 | IndexExpr | Acces par index a[i] |
| 010 00100 | SliceExpr | Tranche a[i:j] |
| 010 00101 | SelectorExpr | Acces champ a.b |
| 010 00110 | Ident | Identifiant |
| 010 00111 | BasicLit | Litteral de base |
| 010 01000 | CompositeLit | Litteral compose |
| 010 01001 | FuncLit | Lambda/fonction anonyme |
| 010 01010 | ParenExpr | Parentheses (a) |
| 010 01011 | StarExpr | Pointeur *a |
| 010 01100 | UnaryAddr | Adresse &a |
| 010 01101 | TypeAssertExpr | Assertion de type |
| 010 01110 | KeyValueExpr | key: value |
| 010 01111 | TernaryExpr | Operation ternaire |
| 010 10000 | ListComp | Liste en comprehension |
| 010 10001 | DictComp | Dictionnaire en comprehension |
| 010 10010 | GeneratorExpr | Generateur |
| 010 10011 | AwaitExpr | await |
| 010 10100 | YieldExpr | yield |
| 010 10101 | SendExpr | Envoi canal <- |
| 010 10110 | RecvExpr | Reception canal <-ch |

### Type (011xxxxx)

| Code | Noeud | Signification |
|------|-------|---------------|
| 011 00000 | IdentType | Type nomme |
| 011 00001 | PointerType | Pointeur *T |
| 011 00010 | ArrayType | Tableau [N]T |
| 011 00011 | SliceType | Tranche []T |
| 011 00100 | MapType | Map map[K]V |
| 011 00101 | ChanType | Canal chan T |
| 011 00110 | FuncType | Type de fonction |
| 011 00111 | StructType | Type de structure |
| 011 01000 | InterfaceType | Type d'interface |
| 011 01001 | UnionType | Union A \| B |
| 011 01010 | OptionalType | Optionnel T? |
| 011 01011 | GenericType | Generique T[U] |
| 011 01100 | TupleType | Tuple (A, B) |

### Pattern (100xxxxx)

| Code | Noeud | Signification |
|------|-------|---------------|
| 100 00000 | WildcardPattern | _ |
| 100 00001 | IdentPattern | Liaison par nom |
| 100 00010 | LiteralPattern | Correspondance de litteral |
| 100 00011 | TuplePattern | Tuple (a, b) |
| 100 00100 | ListPattern | Liste [a, b] |
| 100 00101 | StructPattern | Structure {a, b} |
| 100 00110 | OrPattern | a \| b |
| 100 00111 | GuardPattern | Condition de garde |

### Modifier (101xxxxx)

| Code | Noeud | Signification |
|------|-------|---------------|
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

| Code | Noeud | Signification |
|------|-------|---------------|
| 110 00000 | File | Fichier (niveau superieur) |
| 110 00001 | Module | Module |
| 110 00010 | Package | Package |
| 110 00011 | Namespace | Espace de noms |
| 110 00100 | Block | Bloc |
| 110 00101 | CommentGroup | Groupe de commentaires |
| 110 00110 | Comment | Commentaire |
| 110 00111 | Directive | Directive (#pragma) |

### Language-specific (111xxxxx)

Noeuds propres a chaque langage. 32 emplacements disponibles.

## PathGEUL (111110)

PathGEUL est un langage de requete pour parcourir les graphes GEUL. Comme XPath parcourt le XML, PathGEUL parcourt les graphes GEUL.

Lorsque le code de langage est `111110`, les 8 bits du type de noeud AST sont reinterpretes comme des **operateurs de requete**.

| Code | Operation | Correspondance XPath | Description |
|------|-----------|---------------------|-------------|
| 00000000 | Root | / | Noeud racine |
| 00000001 | Child | /child | Enfant direct |
| 00000010 | Descendant | // | Tous les descendants |
| 00000011 | Parent | .. | Parent |
| 00000100 | Ancestor | ancestor:: | Tous les ancetres |
| 00000101 | Sibling | sibling:: | Freres et soeurs |
| 00010000 | FilterType | [type=...] | Filtre par type |
| 00100000 | FilterProp | [@prop=...] | Filtre par propriete |
| 01000000 | Union | \| | Union |
| 01000001 | Intersect | & | Intersection |

## Exemples

### Declaration de fonction Go

```go
func Add(a, b int) int {
    return a + b
}
```

```
AST Edge (FuncDecl):
  1st: [Prefix 10bit] [000100]       - Prefix + Go
  2nd: [000 00000] [00000000]        - FuncDecl + Reserve
  3rd: [TID: 0x0010]                 - TID de cet Edge
  4th: [TID: 0x0011]                 - Name "Add"
  5th: [TID: 0x0012]                 - Params
  6th: [TID: 0x0013]                 - Results
  7th: [TID: 0x0014]                 - Body
  8th: [0x0000]                      - Terminaison

Total: 8 mots
```

### Definition de fonction Python

```python
def greet(name: str) -> str:
    return f"Hello, {name}"
```

```
AST Edge (FuncDecl):
  1st: [Prefix 10bit] [100000]       - Prefix + Python
  2nd: [000 00000] [00000000]        - FuncDecl + Reserve
  3rd: [TID: 0x0020]                 - TID de cet Edge
  4th: [TID: 0x0021]                 - Name "greet"
  5th: [TID: 0x0022]                 - Params
  6th: [TID: 0x0023]                 - Returns
  7th: [TID: 0x0024]                 - Body
  8th: [0x0000]                      - Terminaison

Total: 8 mots
```

### Noeud feuille (identifiant)

```
AST Edge (Ident):
  1st: [Prefix 10bit] [000100]       - Prefix + Go
  2nd: [010 00110] [00000000]        - Ident + Reserve
  3rd: [TID: 0x0030]                 - TID de cet Edge
  4th: [0x0000]                      - Terminaison (pas d'enfant)

Total: 4 mots
```
