---
title: "CODEC (0x0BEL)"
weight: 190
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "CODEC é o Edge de enunciado que indica um Kind e um Codec que um FIELD aceita."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `CODEC` (BIND `CODEC` do documento de especificação) |
| TAG ID | `0x0BEL` |
| Codec ID | `0x00000BE0` |
| Documento de especificação | `0x00000000/codecs/0x00000BE0/` (alvo do DECLARE `0BE0`) |
| Seção | 5 `0101` (Edge de enunciado), deslocamento C dentro da seção = 30 |
| Kind | Edge · família: enunciado, grupo: outros |
| TAG WORD | `0000 1011 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | Um Kind e Codec que o campo aceita. Campo, WORD alvo (`000K KKKC CCCC LLLL`, LLLL 0000 exato · 1111 curinga (todas as 32 posições da seção), os marcadores de posição só como alvos exatos `0000`·`0010`·`0020`). Um campo de registro tem vários (lista fechada), um campo de valor bruto tem um (esse Value sem TAG) |
| Lado Hugo | `edge/codec.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELDs no documento é a ordem dos campos do Payload ([documento de especificação de Codec](../codec-spec.md)). O Edge Id do Edge não é declarado como FIELD.

| Ordem | Campo (BIND) | FIELD | Largura | Formato aceito (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `field` | #2 | registro | `0050` LOCAL |  |
| 2 | `target` | #4 | valor bruto 1 WORD |  |  |

CODEC é o Edge de enunciado que indica um Kind e um Codec que um [FIELD](0x0BCL-field.md) aceita. Codec `0x0BEL`.

Assim como [ENUM](0x0BDL-enum.md) atribui um significado a um valor de código de um campo de valor bruto, CODEC atribui um formato a um campo. Como é um por Edge, pode-se indicar vários. O layout é embutido no decodificador ([documento de especificação de Codec](../codec-spec.md)).

## Layout {#레이아웃}

```
TAG WORD          0000 1011 1110 LLLL
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
campo             registro Reference LOCAL que aponta para o Edge FIELD
alvo              1 WORD. 000K KKKC CCCC LLLL (LLLL = 0000 exato, 1111 curinga)
```

## WORD alvo {#대상-word}

- Mantêm-se tal como estão a posição do Codec da TAG WORD (seção `KKKK` e `CCCCC`). Os 3 bits superiores são 0. `LLLL` é `0000` (exato) ou `1111` (curinga), e outros valores são invalid.
- O valor do alvo exato (`LLLL = 0000`) escrito em 32 bits é o ID do codec desse Codec (por exemplo, LOCAL `0x0050` → `0x00000050`, COORDINATE-EARTH `0x0640`, UTF8-LANGUAGE-TEXT `0x0780`). Por isso o alvo aponta diretamente para o documento de especificação desse Codec ([documento de especificação de Codec](../codec-spec.md)).
- Os pares de códigos par/ímpar (texto e sequência de bytes) também são indicados por código exato. Para aceitar tanto o par como o ímpar, põem-se ambos. Não há regra que interprete o par em conjunto (há códigos adjacentes que não são pares, como NUMERIC `0x064L`/`0x065L`).

### Curinga (`LLLL = 1111`) {#와일드카드-llll--1111}

- Com `LLLL = 1111`, aceita-se toda a seção `KKKK` (32 posições) do WORD alvo, qualquer que seja o valor de `C`. Dentro da mesma seção, o significado é o mesmo para qualquer `C`. Verifica-se apenas se a seção do alvo e a seção do registro são a mesma. Não aceita além da seção.
- Com `LLLL = 1111`, recomenda-se a primeira posição da seção (`C = 0`). É uma recomendação, não uma imposição. Outro `C` da mesma seção também é válido.
- Se o Kind abrange várias seções, listam-se CODECs por seção.

| Alvo | Significado |
|---|---|
| `000F`·`020F`·`040F` | qualquer Reference (seções 0~2, incluindo REFERENCE-ISSUER) |
| `060F`·`080F` | qualquer Value (seções 3 e 4, incluindo VALUE-ISSUER) |
| `0A0F`·`0C0F`·`0E0F`·`100F`·`120F`·`140F`·`160F`·`180F`·`1A0F` | qualquer Edge (seções 5~13, incluindo EDGE-ISSUER) |
| `1C0F`·`1E0F` | qualquer Meta (seções 14 e 15) |

- Os marcadores de posição de Reference (`0x000L~0x002L`) não se ajustam a `LLLL = 1111` (`000F` não aceita ABSENT, UNKNOWN-VALUE nem NO-VALUE). Por outro lado, mesmo uma seção cuja primeira posição está atribuída, como Value `0x060L` (BOOL) e Edge `0x0A0L` (REFERENCE-NODE), é incluída por `LLLL = 1111` (para aceitar só BOOL, usa-se `0600`, com `LLLL = 0000`).
- Um alvo com `LLLL = 1111` não aponta para um documento de especificação.
- Uma quantificação indiferente ou um grupo escreve-se apenas listando CODECs (`LLLL = 0000`). Por exemplo, WIKIDATA-QID com quantificação indiferente são cinco: `0140`, `0150`, `0160`, `0170`, `0180`.
- Os códigos do sistema 5Q de Reference contêm a quantificação. O alvo indica exatamente até a quantificação. Para aceitar vários Quantifiers, põem-se vários CODECs. A quantificação de REFERENCE-ISSUER é definida pelo documento do Issuer.

### Marcador de posição (alvo `0000`, `0010`, `0020`) {#자리-표지-대상-0000-0010-0020}

Os [marcadores de posição](../slot-marker.md) são um grupo de registros de 1 WORD atribuído às três primeiras posições `0x000L~0x002L` da seção 0 de Reference. Não têm quantificação.

| Alvo | Marcador | Significado |
|---|---|---|
| `0000` | ABSENT | não escrito. Esse campo é opcional |
| `0010` | UNKNOWN-VALUE | desconhecido. Aceita a asserção de que há um valor |
| `0020` | NO-VALUE | inexistente. Aceita a asserção de que não há valor |

- **Regra de aceitação:** o marcador só é válido se o mesmo WORD estiver, como alvo exato, na lista de CODECs desse campo. Um curinga e um campo de registro sem CODEC ("qualquer registro") não aceitam marcadores. Um marcador na posição de registro do HEAD ou do BODY, ou na posição de Edge Id, é invalid.
- Uma lista com apenas alvos de marcador (sempre marcador) é invalid (generalização da regra da lista só com `0000`). Usa-se junto com um alvo `LLLL = 1111` ou com um alvo exato (`000F`·`020F`·`040F` + `0000` = qualquer Reference ou omitido).
- Num campo de valor bruto não se pode pôr alvo de marcador. O valor bruto não tem TAG e tem largura fixa, de modo que não há lugar para um marcador de 1 WORD.
- O significado do marcador é definido pela especificação do Codec que o recebe.

### Campo opcional (alvo `0000`) {#선택-필드-대상-0000}

- Se o alvo `0000` for posto na lista de CODECs de um campo de registro, esse campo é um **campo opcional**. Ao omiti-lo, escreve-se nessa posição 1 WORD `0x0000`. Esse registro de 1 WORD é o marcador de posição ABSENT (não escrito).
- `0x0000` é Reference, Codec `0x000L` (Reserved), `LLLL = 0000` (1 WORD no total). Não se sobrepõe a outros registros, e um decodificador que não conhece a especificação também o salta como registro de 1 WORD.
- Um campo opcional também ocupa sempre a sua posição. Ao omiti-lo, escreve-se sempre `0x0000` e não se deixa a posição vazia (mesmo para campos finais). Por isso a notação de um registro é uma só, e a decomposição é determinada apenas pela posição. Não há restrições à posição e ao número de campos opcionais, nem a que a lista se sobreponha à de outros campos.
- ABSENT só é válido na posição de um campo opcional. `0x0000` na posição de registro do HEAD ou do BODY, na posição de um campo obrigatório ou na posição de Edge Id é invalid.
- A omissão não é "sem valor", mas "não escrito". Não afirma nada sobre o mundo. "Não há valor" escreve-se com NO-VALUE (`0020`). O que significa a omissão (por exemplo, sem alvo na TAG, esta versão) é definido pela especificação de cada formato.

## Interpretação e validade {#해석과-유효성}

- O campo é um Edge FIELD do mesmo documento. Não se põe o mesmo alvo duas vezes em um campo.
- **Campo de registro (largura 0)**: sem CODEC, aceita qualquer registro exceto marcadores de posição. Havendo um ou mais, é uma lista fechada. O Kind e o Codec do registro desse campo (para Reference, incluindo o Quantifier) devem ser um dos da lista; caso contrário, esse registro não segue a especificação. É diferente de ENUM, que é uma lista aberta.
- **Campo de valor bruto (largura n ≥ 1, ou restante `0xFFFF`)**: o CODEC é um único alvo exato (curinga não é permitido). Esse valor bruto é o Payload desse Value sem a TAG. O Kind e o Codec vêm do CODEC, e o Length vem da largura do FIELD. Nos códigos par/ímpar, o código indicado determina a paridade do número de bytes. Se o valor bruto não seguir as regras desse Value (incluindo o comprimento), esse registro não segue a especificação.
- Os marcadores de posição só se confrontam com os alvos exatos da lista. Se `0x0000` aparece na posição de um campo opcional (alvo `0000`), é omissão. Os demais registros são confrontados com a lista sem os alvos de marcador.
- Num campo de valor bruto podem coexistir CODEC e ENUM. O CODEC é o formato, e o ENUM é o nome do valor de código (por exemplo, pôr rank como UNSIGNED-INTEGER e 0·1·2 como ENUM).
- Pode-se dar um nome ao Edge Id do CODEC por BIND, mas não é obrigatório.
- Um campo "Reference ou Value" escreve-se com 5 CODECs (`000F`, `020F`, `040F`, `060F`, `080F`).

## Comprimento {#길이}

```
total = 1 + N_len + N_id + N_field + 1 WORDs   (6 WORDs se Edge Id e campo forem IDs LOCAL de 1 WORD)
```

## Exemplo {#예시}

Na especificação de LABEL, `0x00000000/codecs/0x00000A40/`, o campo Object (FIELD #3) aceita UTF8-LANGUAGE-TEXT (par e ímpar) e LOCAL. Edge Id 7~9.

```
0BE5 0051 0007 0051 0003 0780
0BE5 0051 0008 0051 0003 0790
0BE5 0051 0009 0051 0003 0050
```

- TAG `0BE5` (Edge, Codec `0x0BEL`, `LLLL = 0101`, 6 WORDs), Edge Id `0051 0007`, campo `0051 0003`, alvo `0780`.

## Páginas relacionadas {#관련-페이지}

- [FIELD](0x0BCL-field.md), [ENUM](0x0BDL-enum.md), [DECLARE](0x0BBL-declare.md), [BIND](0x0A3L-bind.md)
- [documento de especificação de Codec](../codec-spec.md), [LABEL](0x0A4L-label.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000BE0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BE000000000
BODY
#1 DECLARE 0x0BE0
#2 FIELD #1 record
#3 CODEC #2 0x0050
#4 FIELD #1 0x0001
#5 BIND #1 "CODEC"
#6 BIND #2 "field"
#7 BIND #4 "target"
```
