---
title: "DECLARE (0x0BBL)"
weight: 187
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DECLARE é o Edge de enunciado que declara a composição do Payload de um Codec."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `DECLARE` (BIND `DECLARE` do documento de especificação) |
| TAG ID | `0x0BBL` |
| Codec ID | `0x00000BB0` |
| Documento de especificação | `0x00000000/codecs/0x00000BB0/` (alvo do DECLARE `0BB0`) |
| Seção | 5 `0101` (Edge de enunciado), deslocamento C dentro da seção = 27 |
| Kind | Edge · família: enunciado, grupo: outros |
| TAG WORD | `0000 1011 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | Declaração da composição do Payload de um Codec. Kind e Codec alvo |
| Lado Hugo | `edge/declare.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELDs no documento é a ordem dos campos do Payload ([documento de especificação de Codec](../codec-spec.md)). O Edge Id do Edge não é declarado como FIELD.

| Ordem | Campo (BIND) | FIELD | Largura | Formato aceito (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `target` | #2 | valor bruto 1 WORD |  |  |
| 2 | `issuer` | #3 | valor bruto restante (`0xFFFF`) |  |  |

DECLARE é o Edge de enunciado que declara a composição do Payload de um Codec. Codec `0x0BBL`.

Junto com [FIELD](0x0BCL-field.md) (`0x0BCL`), [ENUM](0x0BDL-enum.md) (`0x0BDL`) e [CODEC](0x0BEL-codec.md) (`0x0BEL`), é o vocabulário para escrever especificações de Codec ([documento de especificação de Codec](../codec-spec.md)). O layout dos quatro Edges é embutido no decodificador. Cada documento de especificação de Codec escrito com esse vocabulário é um documento comum. Uma só especificação faz a validação, a decomposição e a exibição (visualizador). O visualizador não tem código por Codec e desenha segundo a especificação.

## Layout {#레이아웃}

```
TAG WORD          0000 1011 1011 LLLL
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
alvo              1 WORD. Da TAG WORD do Codec declarado usa-se só a posição do Codec (seção e C) (LLLL = 0)
[Issuer·nº do codec] Ao declarar um codec de Issuer. 2 WORDs de Issuer e número do codec. É o mesmo layout da TAG estendida de Codec e vale para os três Kinds
                  O documento de especificação do próprio código ISSUER (Issuer GEUL) tem apenas o alvo
```

- A lista de campos não fica no DECLARE. Cada [FIELD](0x0BCL-field.md) aponta para o seu DECLARE, e a ordem desses FIELDs no documento é a ordem dos campos do Payload.

## Regras de interpretação {#해석-규칙}

São as regras para ler e representar um registro segundo a especificação do Codec.

- Um campo de valor bruto lê tantos WORDs fixos quantos o FIELD declarou. Um dos campos pode ser de valor bruto restante (largura `0xFFFF`), e lê os WORDs que sobram menos as larguras dos campos fixos que o seguem. Depois do campo restante põem-se apenas valores brutos de largura fixa.
- Um campo de registro começa com uma TAG WORD e lê tantos WORDs quanto o Length dessa TAG.
- Um campo de valor bruto é um inteiro sem sinal big-endian de n WORDs. A notação é `0x` + hexadecimal de largura×4 dígitos, e se houver um ENUM do mesmo valor, escreve-se também o seu nome BIND.
- O significado de um campo de registro é definido pela especificação do Codec desse registro. Valores que exigem interpretação, como sinal, fração ou data, não são valores brutos, mas registros Value.

Não há outras regras de fronteira. Um Codec com dois ou mais valores brutos variáveis, com registro ou campo variável depois de um valor bruto variável, ou cuja largura do valor bruto varie conforme o valor de outro campo ou o estado do documento, não pode ser declarado com este vocabulário. Esse layout deixa só uma parte variável, envolvendo-a em um registro (por exemplo, o signatário de SIGNATURE é um registro Reference).

## Validade {#유효성}

- O Kind do alvo é um de Reference, Value, Edge e Meta. O documento de especificação de um código direto GEUL é um por código. O sistema 5Q de Reference também é declarado separadamente para cada código de quantificação (LOCAL Identified `0050`, Generic `0060`, …). Os ponteiros (`0x040L`, `0x041L`, `0x042L`), os marcadores de posição e o código ISSUER também são esse próprio código. O codec de Issuer determinado pelo Issuer e pelo número do codec que seguem o código ISSUER é definido pelo documento desse Issuer.
- Os [marcadores de posição](../slot-marker.md) (Reference `0x000L~0x002L`) também são alvo de DECLARE. Como não têm Payload, tem-se apenas o DECLARE, sem FIELD. O significado do marcador e as regras de aceitação são embutidos no decodificador (camada 0). Os Codecs cujo layout ainda não foi definido (SUPERSEDE-CHAIN, VERDICT, EVIDENCE etc.) também têm apenas o DECLARE.
- O Edge Id de um Edge não é declarado como FIELD. Como é o primeiro elemento de todo Edge, é implícito ([Edge](_index.md)). EDGE-ISSUER é o primeiro elemento depois do Issuer e do número do codec ([EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md)).
- Os campos de um DECLARE são os FIELDs que apontam para ele, e podem ser 0. Um FIELD pertence a um único DECLARE. Mesmo campos de mesma forma têm FIELDs separados em cada DECLARE.
- No DECLARE não há nada além do alvo (e, no caso de um alvo de formato Issuer, do Issuer e do número do codec).
- O cursor, depois de ler os campos em ordem, deve coincidir exatamente com o fim do registro. Se sobrar ou faltar, esse registro viola a especificação.
- O mesmo alvo não é declarado duas vezes em um documento.
- Variantes que diferem no campo final não se usam como ramificação. Cada Codec tem o seu DECLARE separado.

## Documento de especificação {#규격-문서}

- O documento de especificação de um código direto é um documento de codec do Issuer GEUL `0x00000000`. O ID do codec é a TAG WORD alvo (L=0) escrita em 32 bits (`0x0B80` → `0x00000B80`), publicada em `<Issuer>/codecs/<ID do codec>/` com ID de versão e `versions.geul` ([documento de especificação de Codec](../codec-spec.md)).
- O documento de codec de um codec de Issuer fica em `<Issuer>/codecs/<número do codec>/` desse Issuer. O número do codec não se repete dentro desse Issuer, independentemente do Kind. O interpretador trata como erro o caso em que o Kind do registro e o Kind do alvo do DECLARE sejam diferentes ([endereço de publicação e lista de versões](../publishing.md#id-표기)).
- Em um documento de especificação há um único DECLARE, e o seu alvo deve ser igual à TAG WORD do ID do codec. O `DOC-ID` é um [CODEC-POINTER](../reference/0x042L-codec-pointer.md) (`0x00000000`, o ID desse codec, `0`).

## Nomes {#이름}

- O nome do Codec liga-se ao Edge Id do DECLARE por [BIND](0x0A3L-bind.md) (por exemplo, `PUBLICATION`). Todo UTF8-TEXT anexado a DECLARE, FIELD, ENUM e CODEC é feito por BIND, e não se anexa por outros Edges como LABEL.
- Os nomes de campos e de enum também se ligam a FIELD e ENUM do mesmo modo.

## Exemplo {#예시}

O documento de especificação `0x00000000/codecs/0x00000B80/` de PUBLICATION (Edge `0x0B8L`): depois do Edge Id, um registro DOC-POINTER e o hash de conteúdo de 16 WORDs.

```
0BB3 0051 0001 0B80                 DECLARE #1  Edge 0x0B8L               (BIND "PUBLICATION")
0BC5 0051 0002 0051 0001 0000       FIELD #2    DECLARE #1, registro      (BIND "doc")
0BE5 0051 0009 0051 0002 0410       CODEC #9    FIELD #2, DOC-POINTER
0BE5 0051 000A 0051 0002 0420       CODEC #10   FIELD #2, CODEC-POINTER (lista de versões do codec)
0BC5 0051 0004 0051 0001 0010       FIELD #4    DECLARE #1, valor bruto 16 WORD   (BIND "hash")
```

- DECLARE: TAG 1 + Edge Id 2 + alvo 1 = 4 WORDs, `LLLL = 0011`.
- FIELD: TAG 1 + Edge Id 2 + DECLARE 2 + largura 1 = 6 WORDs (`LLLL = 0101`). O Kind e o Codec aceitos são postos à parte com [CODEC](0x0BEL-codec.md) (`0410` = DOC-POINTER, `0420` = CODEC-POINTER).
- Um campo opcional é declarado com o alvo de CODEC `0000`. Na posição omitida escreve-se ABSENT (`0x0000`) ([CODEC](0x0BEL-codec.md), campo opcional).
- A ordem dos campos é a ordem em que FIELD #2 e #4 estão no documento. Os Edge Ids não precisam ser contíguos (LOCAL AUTO INCREMENT é uma recomendação).

## Problemas em aberto {#열린-문제}

- Repetição. Composições em que um valor bruto anterior define a contagem, como "argumentos × número de argumentos" de `CALL`. Por ora não se pode declarar.
- Como declarar um Codec com subformato (TAG específica do Codec), como WORLD.
- A que conjunto de versões dos documentos de especificação de código direto se refere `SPEC-VERSION`.

## Páginas relacionadas {#관련-페이지}

- [FIELD](0x0BCL-field.md), [ENUM](0x0BDL-enum.md), [CODEC](0x0BEL-codec.md), [BIND](0x0A3L-bind.md)
- [Edge](_index.md), [documento de especificação de Codec](../codec-spec.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000BB0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BB000000000
BODY
#1 DECLARE 0x0BB0
#2 FIELD #1 0x0001
#3 FIELD #1 rest
#4 BIND #1 "DECLARE"
#5 BIND #2 "target"
#6 BIND #3 "issuer"
```
