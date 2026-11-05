---
title: "PREDICATE-DECLARE (0x101L)"
weight: 257
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "PREDICATE-DECLARE é o Codec TOULMIN que declara um predicado (expressão de julgamento)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PREDICATE-DECLARE é o Codec TOULMIN que declara um predicado (expressão de julgamento). O layout é EXPR. EXPR é um layout que escreve a expressão condicional de TANGEUL Rules. Ele armazena a árvore da expressão achatada em pré-ordem, e as cadeias de caracteres dentro da expressão são referenciadas por uma tabela de rótulos dentro do próprio registro. Por isso é autossuficiente, sem registros TEXT.

| Item | Valor |
|---|---|
| Nome | `PREDICATE-DECLARE` (BIND do documento de especificação `PREDICATE-DECLARE`) |
| TAG ID | `0x101L` |
| Codec ID | `0x00001010` |
| Documento de especificação | `0x00000000/codecs/0x00001010/` (alvo do DECLARE `1010`) |
| Seção | 8 `1000` (Edge TOULMIN), deslocamento dentro da seção C = 1 |
| Kind | Edge · família: TOULMIN, grupo: declaração, layout: EXPR |
| TAG WORD | `0001 0000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | declaração de predicado. Função e expressão de julgamento, critério de julgamento (Spec), contrato de fatos (Ground) |
| Lado Hugo | `edge/toulmin/expr.md` |

## Layout {#레이아웃}

```
ID                     registro Reference LOCAL (Edge Id)
número de nós 1 WORD    número total de registros de expressão
número de rótulos 1 WORD
rótulo × número de rótulos   registro Value UTF8-TEXT
registro de expressão × número de nós   em pré-ordem
```

- Os rótulos são cadeias de caracteres como nomes de campo, valores de texto, etapas de caminho e nomes de função. Uma cadeia vazia também é um rótulo. Um registro de expressão aponta para um rótulo por um índice (1 WORD) numerado a partir de 0.
- Os registros de expressão colocam o pai seguido dos filhos em sequência (pré-ordem). A árvore fica determinada de forma única pelo número de filhos de cada registro e por essa ordem.

## Registro de expressão {#식-레코드}

Um registro de expressão começa com um cabeçalho de 1 WORD.

```
cabeçalho 1 WORD      2 bits inferiores do tipo (b15–14) | 1 bit superior do tipo (b13) | número de filhos, 13 bits (b12–0)
```

tipo = `(b13 << 2) | b15–14`.

| Tipo | Nome | Número de filhos | Após o cabeçalho |
|---|---|---|---|
| 0 | COMPARE | 0 | operador de comparação 1 WORD, rótulo do campo 1 WORD, posição do valor |
| 1 | LOGIC | n | operador lógico 1 WORD |
| 2 | NOT | 1 | nenhum |
| 3 | EITHER | n | nenhum |
| 4 | EXISTS | 1 | operador de quantificação 1 WORD, operando alvo, rótulo do nome de ligação 1 WORD |
| 5 | CALL | 0 | rótulo do alias 1 WORD, rótulo do nome da função 1 WORD |
| 6 | COMPARE-X | 0 | operador de comparação 1 WORD, rótulo do campo 1 WORD, marcador esquerdo 1 WORD [+ operando], posição do valor |
| 7 | Reserved | | |

- Os registros filhos vêm após os campos que seguem o cabeçalho. O filho de EXISTS é uma única condição.
- COMPARE é uma comparação `<campo> <operador> <valor>` sem operando em nenhum dos lados. Se houver operando em algum dos lados, usa-se COMPARE-X.
- Se o marcador esquerdo de COMPARE-X for `1`, um operando se segue; se for `0`, não há. Quando há operando à esquerda, o rótulo do campo é uma cadeia vazia.
- CALL é uma chamada de função do hospedeiro na posição de predicado. Se a função for deste documento, o rótulo do alias é uma cadeia vazia.

### Posição do valor {#값-자리}

```
tipo de valor 1 WORD    0 número, 1 cadeia, 2 operando
valor                   0: registro Value UNSIGNED-INTEGER
                        1: rótulo 1 WORD
                        2: operando (somente em COMPARE-X)
```

- Se a cadeia do valor for exatamente a notação decimal canônica de um inteiro não negativo, usa-se Value UNSIGNED-INTEGER. Qualquer outro valor é escrito como rótulo. Assim, a cadeia do valor é restaurada como estava.

### Operando {#피연산자}

```
tipo de operando 1 WORD   0 caminho, 1 referência de critério, 2 chamada de função
caminho, referência de critério   número de etapas 1 WORD + rótulo 1 WORD × número de etapas
chamada de função                 rótulo do alias 1 WORD + rótulo do nome da função 1 WORD
```

- Um caminho é um caminho nos dados de entrada; uma referência de critério é um caminho no critério de julgamento (SPEC) injetado com `with`.

### Códigos de operador {#연산자-코드}

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

### Avaliação com entrada desconhecida {#미상-입력의-평가}

Os operadores de comparação são avaliados com 3 valores (verdadeiro, falso, indeterminado U) quando a entrada é um marcador de posição. Para NO-VALUE, `is empty` é verdadeiro e as demais comparações são falsas. Para UNKNOWN-VALUE, `is not empty` é verdadeiro, e `equals`, `is in` e as comparações de tamanho são U. Para ABSENT e enunciado ausente, todos os operadores são U. Os operadores lógicos seguem a lógica forte de Kleene com 3 valores, e se o predicado for U, o julgamento do nó é Review. Essa avaliação é um núcleo fixo ([TOULMIN](_index.md#미상-위에서-판정하기)).

## Interpretação e validade {#해석과-유효성}

- O número de nós deve ser igual ao número de registros de expressão expandidos. A posição em que termina a leitura do último registro de expressão deve coincidir exatamente com o fim do registro.
- Se um índice de rótulo for maior ou igual ao número de rótulos, rejeita-se.
- O número de filhos de NOT e de EXISTS deve ser 1.
- Rejeita-se um tipo desconhecido (7) ou um tipo de valor ou tipo de operando desconhecido.
- O número de filhos tem 13 bits (máximo 8191).

## Documento do Codec {#코덱-문서}

O documento do Codec contém um DECLARE (alvo `1010`). No layout EXPR, os valores brutos iniciais (número de nós, número de rótulos) determinam o número de repetições e não podem ser declarados com FIELD; a declaração de campos é um problema em aberto (repetição em [DECLARE](../edge/0x0BBL-declare.md#열린-문제)).

## Páginas relacionadas {#관련-페이지}

- [TOULMIN](_index.md), [NODE](_index.md#node)
- [UTF8-TEXT](../value/0x072L-utf8-text.md), [UNSIGNED-INTEGER](../value/0x062L-unsigned-integer.md)

## Texto original do documento de especificação {#규격-문서-원문}

Documento de especificação `0x00000000/codecs/0x00001010/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000101000000000
BODY
#1 DECLARE 0x1010
#2 BIND #1 "PREDICATE-DECLARE"
```
