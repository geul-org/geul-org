---
title: "EXPR"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EXPR é o layout de expressão condicional usado por PREDICATE-DECLARE (Codec 0x61). Contém a árvore da expressão condicional com uma tabela de rótulos própria e registros de expressão desdobrados em pré-ordem."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXPR é o layout que escreve as expressões condicionais de Rules do TANGEUL. É usado por PREDICATE-DECLARE (declaração de predicado), Codec `0x61`. Contém a árvore da expressão condicional desdobrada em pré-ordem, e as cadeias de caracteres dentro da expressão são apontadas por uma tabela de rótulos dentro do registro. Por isso é autossuficiente, sem registros TEXT.

## Layout

```
ID                     registro Reference LOCAL (Edge Id)
Número de nós 1 WORD   número total de registros de expressão
Número de rótulos 1 WORD
Rótulos × número de rótulos   registros Value UTF8-TEXT
Registros de expressão × número de nós   em pré-ordem
```

- Os rótulos são cadeias como nomes de campos, valores de texto, passos de caminho e nomes de funções. Uma cadeia vazia também é um rótulo. Os registros de expressão apontam para os rótulos por um índice (1 WORD) numerado a partir de 0.
- Os registros de expressão colocam os filhos em seguida ao pai (pré-ordem). O número de filhos de cada registro e essa ordem determinam uma única árvore.

## Registro de expressão

O registro de expressão começa com um cabeçalho de 1 WORD.

```
Cabeçalho 1 WORD   2 bits inferiores do tipo (b15–14) | 1 bit superior do tipo (b13) | número de filhos, 13 bits (b12–0)
```

Tipo = `(b13 << 2) | b15–14`.

| Tipo | Nome | Filhos | Depois do cabeçalho |
|---|---|---|---|
| 0 | COMPARE | 0 | operador de comparação 1 WORD, rótulo do campo 1 WORD, posição do valor |
| 1 | LOGIC | n | operador lógico 1 WORD |
| 2 | NOT | 1 | nada |
| 3 | EITHER | n | nada |
| 4 | EXISTS | 1 | operador de quantificação 1 WORD, operando alvo, rótulo do nome ligado 1 WORD |
| 5 | CALL | 0 | rótulo do alias 1 WORD, rótulo do nome da função 1 WORD |
| 6 | COMPARE-X | 0 | operador de comparação 1 WORD, rótulo do campo 1 WORD, marcador esquerdo 1 WORD [+ operando], posição do valor |
| 7 | reservado | | |

- Os registros filhos vêm depois dos campos que seguem o cabeçalho. O filho de EXISTS é uma única condição.
- COMPARE é a comparação `<campo> <operador> <valor>` sem operandos em nenhum dos lados. Se houver operando em um dos lados, usa-se COMPARE-X.
- Se o marcador esquerdo de COMPARE-X for `1`, o operando se segue; se for `0`, não há. Se houver operando esquerdo, o rótulo do campo é uma cadeia vazia.
- CALL é a chamada de uma função do host na posição de predicado. Se for uma função deste documento, o rótulo do alias é uma cadeia vazia.

### Posição do valor

```
Tipo de valor 1 WORD   0 número, 1 cadeia, 2 operando
Valor                  0: registro Value UNSIGNED-INTEGER
                       1: rótulo de 1 WORD
                       2: operando (somente em COMPARE-X)
```

- Se a cadeia do valor for exatamente igual à notação decimal canônica de um inteiro não negativo, escreve-se como Value UNSIGNED-INTEGER. Os demais valores se escrevem como rótulo. Assim, a cadeia do valor é restaurada tal qual.

### Operando

```
Tipo de operando 1 WORD   0 caminho, 1 referência de critério, 2 chamada de função
Caminho, referência de critério   número de passos 1 WORD + rótulo de 1 WORD × número de passos
Chamada de função         rótulo do alias 1 WORD + rótulo do nome da função 1 WORD
```

- O caminho é o caminho dos dados de entrada, e a referência de critério é o caminho do critério de julgamento (SPEC) injetado com `with`.

### Códigos de operador

| Código | Operador de comparação |
|---|---|
| `0x0301` | is empty |
| `0x0302` | is not empty |
| `0x0303` | equals |
| `0x0304` | is in |
| `0x0305` | is greater than |
| `0x0306` | is less than |
| `0x0307` | is at most |
| `0x0308` | is at least |

| Código | Operador lógico |
|---|---|
| `0x0311` | and |
| `0x0312` | or |

| Código | Operador de quantificação |
|---|---|
| `0x0321` | any |

### Avaliação de entradas desconhecidas

Quando a entrada é um marcador de posição, os operadores de comparação são avaliados com 3 valores (verdadeiro, falso, indefinido U). Para NO-VALUE, `is empty` é verdadeiro e as demais comparações são falsas. Para UNKNOWN-VALUE, `is not empty` é verdadeiro e `equals`, `is in` e a comparação de tamanho são U. Para ABSENT e para a ausência de descrição, todos os operadores são U. Os operadores lógicos seguem a lógica forte de 3 valores de Kleene, e se o predicado for U, o julgamento do nó é Review. Essa avaliação é o núcleo fixo ([TOULMIN](/pt/grammar/edge/toulmin/#julgar-sobre-o-desconhecido)).

## Interpretação e validade

- O número de nós deve ser igual ao número de registros de expressão desdobrados. A posição depois de ler o último registro de expressão deve coincidir exatamente com o fim do registro.
- Se o índice de rótulo for maior ou igual ao número de rótulos, rejeita-se.
- O número de filhos de NOT e EXISTS deve ser 1.
- Rejeitam-se tipo desconhecido (7), tipo de valor desconhecido e tipo de operando desconhecido.
- O número de filhos tem 13 bits (no máximo 8191).

## Páginas relacionadas

- [TOULMIN](/pt/grammar/edge/toulmin/), [NODE](/pt/grammar/edge/toulmin/node/)
- [UTF8-TEXT](/pt/grammar/value/text/utf8-text/), [UNSIGNED-INTEGER](/pt/grammar/value/numeric/unsigned-integer/)
