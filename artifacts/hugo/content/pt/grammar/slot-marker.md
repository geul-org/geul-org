---
title: "Marcador de posição"
weight: 80
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "O marcador de posição (slot marker) é um registro de 1 WORD que preenche a posição de um campo do registro."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

O marcador de posição (slot marker) é um registro de 1 WORD que preenche a posição de um campo do registro. Não aponta para nada. São os códigos atribuídos às três primeiras posições `0x000L~0x002L` da seção 0 de Reference. Cada marcador tem sua página: [ABSENT](reference/0x000L-absent.md), [UNKNOWN-VALUE](reference/0x001L-unknown-value.md), [NO-VALUE](reference/0x002L-no-value.md).

Na posição de um valor, há três coisas que podem ser ditas: o valor não foi escrito, o valor existe mas não se sabe qual é, ou o valor não existe. As três são diferentes. O marcador de posição escreve as três em três WORDs vizinhos.

## Layout {#레이아웃}

```
TAG WORD          0000 0000 00CC 0000
                  Prefix 000, seção 0(Reference), Codec 0~2, LLLL 0000(1 WORD)
```

| WORD | Nome | Significado | Notação |
|---|---|---|---|
| `0x0000` | [ABSENT](reference/0x000L-absent.md) | Não escrito | `ABSENT` |
| `0x0010` | [UNKNOWN-VALUE](reference/0x001L-unknown-value.md) | Desconhecido: há um valor. Não se sabe qual | `UNKNOWN` |
| `0x0020` | [NO-VALUE](reference/0x002L-no-value.md) | Inexistente: não há valor | `NONE` |
| Codec 0~2, LLLL ≥ `0001` | Reserved | Esta forma de TAG (marcador com Payload) não foi atribuída | |

- O marcador **não tem Quantifier.** A quantificação só é lida nos sistemas 5Q (`5 <= C < 30` na seção 0 e `C < 30` na seção 1). Não se lê `0x0010` UNKNOWN-VALUE como `C % 5` para interpretá-lo como Generic ([Reference](reference/_index.md) Quantifier).
- Não tem Payload. Também não tem ID de objeto.
- Mesmo um decodificador sem codebook sabe, só pelo TAG WORD, que é Kind Reference e 1 WORD, e o salta. «Se o valor do WORD é `0x0000`, `0x0010` ou `0x0020`, é um marcador de posição» se reconhece por `w & 0xF == 0 && w <= 0x0020`.
- As notações `ABSENT`, `UNKNOWN` e `NONE` são as notações em texto de `geul show` e `geul add`.

## Três distinções {#세-가지-구분}

| | Não escrito (ABSENT) | Desconhecido (UNKNOWN-VALUE) | Inexistente (NO-VALUE) |
|---|---|---|---|
| Sobre o que fala | **O documento**: esta posição não foi preenchida | **O mundo**: há um valor. Não se sabe qual | **O mundo**: não há valor |
| Lógica | Não assere nada | `∃x. P(s, x)`, x não identificado | `¬∃x. P(s, x)` |
| Pressuposto de mundo | Mundo aberto (sem informação) | Existência fechada, identidade aberta | Mundo fechado para (s, P, condição de qualificação) |
| Wikidata | Não há o snak correspondente | `somevalue` | `novalue` |
| Onde se usa | Campo opcional com destino de CODEC `0000` (SOURCE Origin etc.) | Campo com destino de CODEC `0010` (TRIPLE Object, QUALIFIER Value, SOURCE Origin) | Campo com destino de CODEC `0020` (TRIPLE Object, QUALIFIER Value) |
| «Quantos filhos (P40)» | Não se sabe | Um ou mais | 0 |
| «Há instante de término (P582)» | Não se sabe → não se sabe se ainda é válido | Terminou. Não se sabe quando | Não terminou (asserção) |

A mesma distinção vale no nível da proposição. **Um TRIPLE ausente do documento** é «não escrito». Como o documento GEUL é de mundo aberto, a ausência de um enunciado não significa que o fato não exista. «Não há» só pode ser dito **escrevendo** NO-VALUE.

## Regras de aceitação {#수용-규칙}

- O marcador de posição só é válido **se o mesmo WORD constar como destino exato** na lista de [CODEC](edge/0x0BEL-codec.md) do campo. O destino `0000` significa «campo opcional», `0010` «aceita desconhecido» e `0020` «aceita inexistente».
- Curingas (`000F`, `060F` etc., `L=1111`) não aceitam marcadores. Qualquer Reference (`000F`·`020F`·`040F`) também não se sobrepõe aos marcadores.
- Campos de registro sem CODEC («qualquer registro») também não aceitam marcadores.
- Um marcador nas posições de registro de HEAD e BODY ou na posição do Edge Id é invalid.
- Campos de valor bruto não podem usar marcadores. Como o valor bruto não tem TAG, não há lugar para um marcador de 1 WORD.
- Uma lista de CODEC que tenha só destinos de marcador (sempre marcador) é invalid.
- O significado do marcador (o que existe e o que não existe) é definido pela especificação do Edge que o aceita. É o mesmo princípio de que quantificação e negação são definidas pelo Edge, e não pela Reference.
- O significado e as regras de aceitação do marcador pertencem à [camada 0](publishing.md#층) (embutida no decodificador). Os três não têm Payload, portanto também não há custo de embuti-los. Ainda assim, há um documento de Codec por código. O documento de Codec contém apenas DECLARE e não tem FIELD.

## Obrigações de quem lê {#읽는-쪽의-의무}

Cada marcador as descreve em sua página. Em resumo:

- [UNKNOWN-VALUE](reference/0x001L-unknown-value.md#읽는-쪽의-의무) não é um valor, mas uma asserção de existência. Não é igual nem diferente de nenhum valor, e seu TRIPLE não é mesclado como duplicado.
- [NO-VALUE](reference/0x002L-no-value.md#읽는-쪽의-의무) fecha-se dentro da condição de qualificação dessa proposição.
- Em ambos os marcadores, o rank se aplica igualmente e, quando usados como valor de QUALIFIER, mudam o sentido dessa qualificação.
- [ABSENT](reference/0x000L-absent.md#읽는-쪽의-의무) não diz nada sobre o mundo. Um valor que não foi possível transferir não é escrito como UNKNOWN-VALUE.

## Diferença em relação a outros «inexistentes» {#다른-없음과의-차이}

- A regra de Codec que usa [LOCAL](reference/0x005L-local.md) `0` como «inexistente» ([TOULMIN](toulmin/_index.md) REF etc.) é uma convenção interna desse Codec. É diferente do marcador de posição.
- Não se usa LOCAL Identified como null ou sentinela. Para escrever desconhecido ou ausente, usa-se um marcador num campo que aceite marcadores.

## Exemplo {#예시}

Fronteira entre Q30 (Estados Unidos) e Q34266 (Império Russo), com o instante de término desconhecido. Os Edge Ids são ilustrativos.

```
0AA9 0051 080C 0191 002F 0141 001E 0141 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
0AB7 0051 0C58 0191 0246 0051 080C 0010                #3160 QUALIFIER P582 #2060 UNKNOWN
```

O banco central de Q30, que não existiu entre 1811 e 1816.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000           #3161 TRIPLE P1304 Q30 NONE normal
0AB9 0051 0C5A 0191 0244 0051 0C59 06E2 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
0AB9 0051 0C5B 0191 0246 0051 0C59 06E2 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

- A posição do marcador é de 1 WORD. O TRIPLE passa a ter 9 WORD (`0AA8`) e o QUALIFIER 8 WORD (`0AB7`).
- Na forma simples, «sem filhos (P40)» é `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000`.

## Páginas relacionadas {#관련-페이지}

- [ABSENT](reference/0x000L-absent.md), [UNKNOWN-VALUE](reference/0x001L-unknown-value.md), [NO-VALUE](reference/0x002L-no-value.md)
- [Reference](reference/_index.md), [CODEC](edge/0x0BEL-codec.md), [documento de especificação de Codec](codec-spec.md)
- [TRIPLE](edge/0x0AAL-triple.md), [QUALIFIER](edge/0x0ABL-qualifier.md), [TOULMIN](toulmin/_index.md)
