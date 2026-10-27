---
title: "CODEC"
weight: 31
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "CODEC é o Edge descritivo que especifica um Kind·Codec aceito por um FIELD (Codec 0x1E). Os curingas e os marcadores de posição (0x0000 não informado, 0x0001 desconhecido, 0x0002 sem valor) também são declarados por ele."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CODEC é o Edge descritivo que especifica um Kind·Codec aceito por um [FIELD](/pt/grammar/edge/field/). Codec `0x1E`.

Assim como o [ENUM](/pt/grammar/edge/enum/) dá significado a um valor de código de um campo de valor bruto, o CODEC atribui a um campo um formato. Como é um por Edge, podem-se especificar vários. O layout é incorporado ao decodificador ([Documento de especificação de Codec](/pt/grammar/codec-spec/)).

## Layout

```
TAG WORD          0001 0LLL L001 1110
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
Campo             registro Reference LOCAL que aponta para o Edge FIELD
Alvo              1 WORD. 000K KLLL LCCC CCCC (LLLL = 0000 exato, 1111 curinga)
```

## WORD alvo

- Mantêm-se as posições de Kind (`KK`) e Codec (`CCCCCCC`) da TAG WORD. Os 3 bits superiores são 0. `LLLL` é `0000` (exato) ou `1111` (curinga); qualquer outro valor é invalid.
- O alvo exato (`LLLL = 0000`) é o mesmo valor que o ID do documento de especificação do Codec (por exemplo, LOCAL `0x0008`, COORDINATE-EARTH `0x0804`, UTF8-LANGUAGE-TEXT `0x084A`). Assim o alvo aponta diretamente para o documento de especificação desse Codec.
- Os pares de códigos par/ímpar (texto, sequências de bytes) também se especificam com códigos exatos. Para aceitar par e ímpar, põem-se os dois. Não há regra de interpretar o par em conjunto (há códigos adjacentes que não são pares, como NUMERIC `0x04`/`0x05`).

### Curinga (`LLLL = 1111`)

- O Kind deve ser igual, e **qualquer grupo de bits de Codec que seja 0 casa com qualquer valor**. Em Reference, `CCCC` (Codec) e `QQQ` (Quantifier) são grupos separados; nos outros Kinds, os 7 bits inteiros são um só grupo.

| Alvo | Significado |
|---|---|
| `0780` | qualquer Reference |
| `07A0` | WIKIDATA-QID, qualquer Quantifier |
| `0781` | qualquer Codec de Reference, Quantifier Generic (`001`) |
| `0F80` | qualquer Value |
| `1780`, `1F80` | qualquer Edge, qualquer Meta |

- Um curinga que não tem nada a casar é invalid. Em Value, Edge e Meta o Codec deve ser 0, e em Reference um entre `CCCC` e `QQQ` deve ser 0. O Codec `CCCC = 0000` de Reference (marcador de posição) é um Codec reservado e **não casa com nenhum curinga** (`0780` não aceita ABSENT, UNKNOWN-VALUE nem NO-VALUE). Por outro lado, nos Kinds em que o Codec 0 está atribuído, como Value `0x00` (BOOL) e Edge `0x00` (REFERENCE-NODE), o curinga também os inclui (para aceitar só BOOL, usa-se `LLLL = 0000`).
- O curinga não aponta para um documento de especificação.
- Não existe expressão que fixe apenas um grupo diferente de 0 e deixe livre o grupo 0, como "qualquer Reference, só Identified". Essas listas enumeram os alvos exatos.
- Os 7 bits de Codec de Reference contêm o Quantifier (`QQQ`). O alvo especifica exatamente até o Quantifier. Para aceitar vários Quantifiers, põem-se vários CODEC.

### Marcador de posição (alvos `0000`~`0002`)

[Marcador de posição](/pt/grammar/reference/slot-marker/) é um conjunto de registros de 1 WORD do Codec reservado `0000` de Reference. Os 3 bits inferiores são o número do marcador (não é Quantifier).

| Alvo | Marcador | Significado |
|---|---|---|
| `0000` | ABSENT | Não informado. O campo é opcional |
| `0001` | UNKNOWN-VALUE | Desconhecido. Aceita a afirmação de que há um valor |
| `0002` | NO-VALUE | Sem valor. Aceita a afirmação de que não há valor |
| `0003`~`0007` | reservado | |

- **Regra de aceitação:** o marcador só é válido se a lista de CODEC do campo contiver a mesma WORD como alvo exato. Curingas e campos de registro sem CODEC ("qualquer registro") não aceitam marcadores. Um marcador na posição de registro de HEAD ou BODY, ou na posição de Edge Id, é invalid.
- Uma lista só com alvos de marcador (sempre marcador) é invalid (generalização da regra da lista só com `0000`). Usa-se junto com um curinga ou um alvo exato (`0780` + `0000` = qualquer Reference ou omitido).
- Um campo de valor bruto não pode ter alvo de marcador. O valor bruto não tem TAG e tem largura definida, então não há lugar para um marcador de 1 WORD.
- O significado do marcador é definido pela especificação do Codec que o recebe.

### Campo opcional (alvo `0000`)

- Se a lista de CODEC de um campo de registro tiver o alvo `0000`, esse campo é um **campo opcional**. Ao omiti-lo, escreve-se naquela posição 1 WORD `0x0000`. Esse registro de 1 WORD é o marcador de posição ABSENT (não informado).
- `0x0000` é o Codec `0000` de Reference (reservado), número de marcador `000`, `LLLL = 0000` (1 WORD no total). Não se confunde com outros registros, e mesmo um decodificador que não conhece a especificação o pula como registro de 1 WORD.
- O campo opcional também ocupa sempre o seu lugar. Ao omitir, escreve-se obrigatoriamente `0x0000` e não se deixa a posição vazia (mesmo que seja um campo final). Assim a notação de um registro é uma só, e a decomposição é determinada só pela posição. Não há restrição quanto à posição e ao número de campos opcionais, nem quanto a listas que se sobreponham a outros campos.
- ABSENT só é válido na posição de um campo opcional. `0x0000` na posição de registro de HEAD ou BODY, na posição de campo obrigatório ou na posição de Edge Id é invalid.
- Omitir não é "sem valor", e sim "não informado". Nada se afirma sobre o mundo. "Não há valor" escreve-se com NO-VALUE (`0002`). O que a omissão significa (por exemplo, sem alvo na TAG, vale esta versão) é definido pela especificação de cada formato.

## Interpretação e validade

- O campo é um Edge FIELD do mesmo documento. Não se põe o mesmo alvo duas vezes num campo.
- **Campo de registro (largura 0)**: sem CODEC, aceita qualquer registro exceto marcadores de posição. Com um ou mais, é uma lista fechada. O registro desse campo deve ter Kind·Codec (em Reference, com Quantifier) igual a um da lista; senão, esse registro não segue a especificação. É diferente do ENUM, que é uma lista aberta.
- **Campo de valor bruto (largura n ≥ 1, ou resto `0xFFFF`)**: o CODEC leva apenas um alvo exato (curinga não é permitido). Esse valor bruto é o Payload desse Value, sem a TAG. O Kind·Codec vêm do CODEC e o Length vem da largura do FIELD. Nos códigos par/ímpar, o código indicado determina a paridade do número de bytes. Se o valor bruto não seguir as regras desse Value (inclusive o comprimento), esse registro não segue a especificação.
- Os marcadores de posição só são conferidos como alvos exatos da lista. Quando `0x0000` aparece na posição de um campo opcional (alvo `0000`), é omissão. Os demais registros são conferidos com a lista sem os alvos de marcador.
- Um campo de valor bruto pode ter CODEC e ENUM juntos. O CODEC é o formato e o ENUM é o nome do valor de código (por exemplo, rank como UNSIGNED-INTEGER, com 0, 1 e 2 como ENUM).
- Pode-se dar nome ao Edge Id do CODEC com BIND, mas não é obrigatório.
- Um campo "Reference ou Value" escreve-se com 2 CODEC (`0780`, `0F80`).

## Comprimento

```
total = 1 + N_len + N_id + N_field + 1 WORD   (6 WORDs se Edge Id e campo forem IDs LOCAL de 1 WORD)
```

## Exemplo

No documento de especificação de LABEL `geul.org/label`, o campo Object (FIELD #3) aceita UTF8-LANGUAGE-TEXT (par e ímpar) e LOCAL. Edge Ids 7 a 9.

```
129E 0088 0007 0088 0003 084A
129E 0088 0008 0088 0003 084B
129E 0088 0009 0088 0003 0008
```

- TAG `129E` (Edge, Codec `0x1E`, `LLLL = 0101`, 6 WORDs), Edge Id `0088 0007`, campo `0088 0003`, alvo `084A`.

## Páginas relacionadas

- [FIELD](/pt/grammar/edge/field/), [ENUM](/pt/grammar/edge/enum/), [DECLARE](/pt/grammar/edge/declare/), [BIND](/pt/grammar/edge/bind/)
- [Documento de especificação de Codec](/pt/grammar/codec-spec/), [LABEL](/pt/grammar/edge/label/)
