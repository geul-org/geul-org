---
title: "NODE"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "NODE é o layout que escreve os nós do grafo TOULMIN (caso, regra, definição, ponto de entrada, gatilho, função, campo, alias, conjunto). Os flags do cabeçalho de 1 WORD determinam os campos condicionais que se seguem."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NODE é o layout que escreve os nós do grafo de julgamento e execução TOULMIN. O tipo de nó é determinado pelo Codec (ou pelo número de formato ISSUER do GEUL), e o cabeçalho de 1 WORD determina o papel, o Level, a forma do Claim e os campos condicionais.

## Codec

| Codec | Nome | TANGEUL | Nó |
|---|---|---|---|
| `0x60` | CASE-DECLARE | `in case of` | caso |
| `0x62` | SPEC-DECLARE | item de Definitions (`means`, `has`) | critério de julgamento (Backing). O role é o tipo de definição |
| `0x63` | RULE-DECLARE | general rule | afirmação (Warrant) |
| `0x64` | COUNTER-DECLARE | counter rule | contestação (Rebuttal) |
| `0x65` | EXCEPT-DECLARE | except rule | exceção (Defeater) |
| `0x75` | ENTRY | `provides x` | ponto de entrada externo |
| `0x76` | TRIGGER | `on`, `every`, `until` | ponto de entrada de evento ou periódico |
| ISSUER `0x0000`/`0xC010` | NAMESPACE | `this document is` | espaço de nomes do documento |
| ISSUER `0x0000`/`0xC011` | FUNC | referência de função | função externa (por exemplo, `bank.withdraw`) |
| ISSUER `0x0000`/`0xC012` | FIELD | `x is required [as Type]` | campo obrigatório |
| ISSUER `0x0000`/`0xC013` | ALIAS | `see a from path` | alias do pacote importado |
| ISSUER `0x0000`/`0xC014` | GROUP | lista ordenada `1.` | conjunto de execução ordenado |

Depois de `ISSUER-1WORD` (`0x7C`), o formato ISSUER coloca na TAG estendida de Codec o Issuer `0x0000` e o número de formato ([TOULMIN](/pt/grammar/edge/toulmin/)).

## Layout

```
ID               registro Reference LOCAL (Edge Id)
Cabeçalho 1 WORD role 2b | reservado 2b | F_GROUNDS 1b | level 2b | tipo de object 2b | flags 7b
[F_FUNC]         FuncRef: REF (ALIAS; 0 se não houver) + VerbCode de 1 WORD
[F_QUAL]         Value SIGNED-DECIMAL. Qualifier
[F_CHECK]        REF (caso)
[F_CLAIM]        Claim: REF (subject) + predicate de 1 WORD + object + mode de 1 WORD
[F_VERDICT]      Value SIGNED-DECIMAL. Valor inicial do julgamento
[F_WITH]         quantidade (Value UNSIGNED-INTEGER) + REF (TEXT) × quantidade
[F_GROUNDS]      quantidade (Value UNSIGNED-INTEGER) + REF (TEXT) × quantidade
SPAN             largura definida por SOURCE × 2 (byte inicial, número de bytes)
```

### WORD de cabeçalho

| Bit | Campo | Valor |
|---|---|---|
| 15–14 | role | 0 general, 1 counter, 2 except |
| 13–12 | reservado | 0 |
| 11 | F_GROUNDS | há uma lista de fundamentos |
| 10–9 | level | 0 Unset, 1 Fail, 2 Review (3 reservado) |
| 8–7 | tipo de object | Forma do object do Claim. 0 REF, 1 Value UNSIGNED-INTEGER, 2 SPAN |
| 6–0 | flags | tabela abaixo |

| Bit | flag | Significado |
|---|---|---|
| b0 | F_FUNC | há o campo FuncRef |
| b1 | F_QUAL | há o campo Qualifier |
| b2 | F_CHECK | há o campo do caso alvo de `checking` |
| b3 | F_CLAIM | há o campo Claim |
| b4 | F_VERDICT | há o campo do valor inicial do julgamento |
| b5 | F_STRIKE | declaração riscada (tachada). Não tem campo |
| b6 | F_WITH | há o campo da lista de critérios |

- Os campos condicionais são colocados na ordem dos flags (F_FUNC, F_QUAL, F_CHECK, F_CLAIM, F_VERDICT, F_WITH, F_GROUNDS). Um campo cujo flag está desligado não ocupa lugar.
- Se o flag estiver ligado e não houver o campo, rejeita-se. A posição depois de ler os campos em sequência, depois do SPAN, deve coincidir exatamente com o fim do registro.

## Campos

| Campo | Descrição |
|---|---|
| FuncRef | Posição da função. REF é o registro ALIAS que importou a função, e `0` se for função deste documento. VerbCode é um código de 1 WORD, ainda não atribuído (`0x0000` é permitido). A grafia original da função escreve-se à parte com TEXT + [LABEL](/pt/grammar/edge/toulmin/link/) |
| Qualifier | Grau de certeza do nó (0~1) |
| Caso | F_CHECK: o caso que este nó apenas julga (`checking c`) |
| Claim | A proposição que o nó contém. REF do subject, predicate de 1 WORD, object, mode de 1 WORD. A forma do object é determinada pelo tipo de object do cabeçalho |
| Valor do julgamento | Valor inicial do julgamento (−1~1) |
| F_WITH | Critérios de julgamento no momento da declaração (`기준으로 하는`, "tomando como critério"). Lista de REF de registros TEXT |
| F_GROUNDS | Nomes de fatos externos resolvidos no momento da avaliação (`근거로 하는`, "tomando como fundamento"). Lista de REF de registros TEXT |
| SPAN | Faixa do texto original de onde saiu esta declaração |

- A notação do valor do julgamento e do Qualifier segue as regras de [Números](/pt/grammar/edge/toulmin/#números) de TOULMIN.
- A quantidade das listas é um registro Value [UNSIGNED-INTEGER](/pt/grammar/value/numeric/unsigned-integer/) embutido.
- A forma padrão do Claim descritivo tem subject e predicate `0` e object SPAN (tipo de object 2). Fica fixado à grafia do texto original.

## Interpretação e validade

- O role deve ser igual ao Codec em RULE, COUNTER e EXCEPT-DECLARE (0 general, 1 counter, 2 except). Em SPEC-DECLARE é o tipo de definição. Nos outros Codecs é 0.
- Se o level for 0 (Unset), usa-se o padrão do motor: Fail em COUNTER-DECLARE e Review em EXCEPT-DECLARE.
- A regra de função do host de `tangl:규칙` ("regra") do TANGEUL (`쓰는 규칙이다`, "é uma regra que usa") escreve-se com um NODE RULE-DECLARE fora do caso. A função é F_FUNC, os critérios são F_WITH e os fundamentos são F_GROUNDS. Só a regra de expressão condicional leva antes um [PREDICATE-DECLARE](/pt/grammar/edge/toulmin/expr/).
- Os bits reservados (13–12) devem ser 0. Se um bit reservado estiver ligado ou o role não casar com o Codec, rejeita-se.

## Páginas relacionadas

- [TOULMIN](/pt/grammar/edge/toulmin/), [LINK](/pt/grammar/edge/toulmin/link/), [EXPR](/pt/grammar/edge/toulmin/expr/), [SOURCE e seções](/pt/grammar/edge/toulmin/source/)
- [LOCAL](/pt/grammar/reference/local/), [SIGNED-DECIMAL](/pt/grammar/value/decimal/signed-decimal/)
