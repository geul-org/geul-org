---
title: "DECLARE"
weight: 28
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DECLARE é o Edge descritivo que declara a composição do Payload de um Codec (Codec 0x1B). Junto com FIELD, ENUM e CODEC, é o vocabulário para escrever documentos de especificação de Codec."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DECLARE é o Edge descritivo que declara a composição do Payload de um Codec. Codec `0x1B`.

Junto com [FIELD](/pt/grammar/edge/field/) (`0x1C`), [ENUM](/pt/grammar/edge/enum/) (`0x1D`) e [CODEC](/pt/grammar/edge/codec/) (`0x1E`), é o vocabulário para escrever a especificação de Codec ([Documento de especificação de Codec](/pt/grammar/codec-spec/)). O layout dos quatro Edges é incorporado ao decodificador. Cada documento de especificação de Codec escrito com esse vocabulário é um documento comum. Uma só especificação serve para validar, decompor e exibir (visualizador). O visualizador não tem código por Codec: desenha conforme a especificação.

## Layout

```
TAG WORD          0001 0LLL L001 1011
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
Alvo              1 WORD. Da TAG WORD do Codec declarado, usa-se só a posição de Kind·Codec (LLLL = 0)
[Issuer·número de formato] quando o alvo é um formato Issuer. Mesmo layout da TAG estendida de Codec
```

- A lista de campos não fica no DECLARE. Cada [FIELD](/pt/grammar/edge/field/) aponta para o seu DECLARE, e a ordem desses FIELDs no documento é a ordem dos campos do Payload.

## Regras de interpretação

Regras para ler e escrever um registro conforme a especificação de Codec.

- Um campo de valor bruto é lido com o número fixo de WORDs declarado pelo FIELD. Um dos campos pode ser o valor bruto restante (largura `0xFFFF`), que lê as WORDs que sobram menos a largura dos campos fixos que vêm depois. Depois do campo restante só há valores brutos de largura fixa.
- Um campo de registro começa com uma TAG WORD e é lido pelo Length dessa TAG.
- Um campo de valor bruto é um inteiro sem sinal big-endian de n WORDs. Escreve-se `0x` + largura×4 dígitos hex e, se houver um ENUM de mesmo valor, escreve-se junto o nome BIND dele.
- O significado de um campo de registro é definido pela especificação de Codec desse registro. Valores que exigem interpretação, como sinal, parte decimal e data, vão em registros Value, não em valor bruto.

Não há outras regras de fronteira. Um Codec com dois ou mais valores brutos variáveis, ou com registro ou campo variável depois de um valor bruto variável, ou com valor bruto cuja largura mude conforme outro valor de campo ou o estado do documento, não pode ser declarado com este vocabulário. Esse layout deixa uma só parte variável, embrulhando-a num registro (por exemplo, o signatário de SIGNATURE é um registro Reference).

## Validade

- O Kind do alvo é um de Reference, Value, Edge e Meta. O Codec de Reference é a posição `CCCC`, e o Quantifier fica em 0.
- O [marcador de posição](/pt/grammar/reference/slot-marker/) (Codec `0000` de Reference) não pode ser alvo de DECLARE. É incorporado ao decodificador (camada 0).
- O Edge Id de um Edge não se declara com FIELD. Por ser o primeiro elemento de todo Edge, é implícito ([Edge](/pt/grammar/edge/)).
- Os campos de um DECLARE são os FIELDs que apontam para ele, e podem ser 0. Um FIELD pertence a um só DECLARE. Mesmo campos de forma idêntica têm FIELDs separados em cada DECLARE.
- O DECLARE não tem nada além do alvo (e, para alvos de formato Issuer, o Issuer e o número de formato).
- O cursor depois de ler os campos em sequência deve coincidir exatamente com o fim do registro. Se sobrar ou faltar, o registro viola a especificação.
- Num documento, o mesmo alvo não se declara duas vezes.
- Não se usam como ramificação variantes com campos finais diferentes. Para cada Codec há um DECLARE separado.

## Documento de especificação

- O documento de especificação de um código direto é um documento comum do Issuer GEUL `0x0000`. O ID do documento é a TAG WORD do alvo estendida para 4 WORDs (`0x1018` → `0x0000000000001018`), e é publicado do mesmo modo que os documentos de outros Issuers (ID de versão, `versions.geul`) ([Documento de especificação de Codec](/pt/grammar/codec-spec/)).
- Um documento de especificação tem um DECLARE, e o seu alvo deve ser igual à TAG WORD do ID do documento. O `DOC-ID` é um DOC-POINTER (`0x0000`, o ID desse documento, `0`).

## Nome

- O nome do Codec liga-se ao Edge Id do DECLARE por [BIND](/pt/grammar/edge/bind/) (por exemplo, `PUBLICATION`). Todos os UTF8-TEXT anexados a DECLARE, FIELD, ENUM e CODEC são feitos com BIND, e não se anexam com outros Edges como LABEL.
- O nome do campo e o nome do enum também se ligam a FIELD e ENUM do mesmo modo.

## Exemplo

Documento de especificação `geul.org/publication` de PUBLICATION (Edge `0x18`): depois do Edge Id, um registro DOC-POINTER e um hash de conteúdo de 16 WORDs.

```
119B 0088 0001 1018                 DECLARE #1  Edge 0x18                 (BIND "PUBLICATION")
129C 0088 0002 0088 0001 0000       FIELD #2    DECLARE #1, registro      (BIND "doc")
129E 0088 0009 0088 0002 0038       CODEC #9    FIELD #2, DOC-POINTER
129C 0088 0004 0088 0001 0010       FIELD #4    DECLARE #1, valor bruto 16 WORD   (BIND "hash")
```

- DECLARE: TAG 1 + Edge Id 2 + alvo 1 = 4 WORDs, `LLLL = 0011`.
- FIELD: TAG 1 + Edge Id 2 + DECLARE 2 + largura 1 = 6 WORDs (`LLLL = 0101`). O Kind·Codec aceito é posto à parte com [CODEC](/pt/grammar/edge/codec/) (`0038` = DOC-POINTER).
- Um campo opcional declara-se com o alvo de CODEC `0000`. Na posição omitida escreve-se ABSENT (`0x0000`) ([CODEC](/pt/grammar/edge/codec/) campo opcional).
- A ordem dos campos é a ordem em que FIELD #2 e #4 estão no documento. Os Edge Ids não precisam ser contíguos (LOCAL AUTO INCREMENT é uma recomendação).

## Questões em aberto

- Repetição. Composições em que um valor bruto anterior determina a quantidade, como os "argumentos × número de argumentos" de `CALL`. Por ora não se podem declarar.
- Como declarar Codecs que têm subformato (TAG por Codec), como WORLD.
- Como achar o documento de especificação de um formato Issuer (Issuer·número de formato → endereço do documento de especificação).
- A que conjunto de versões dos documentos de especificação de código direto corresponde `SPEC-VERSION`.

## Páginas relacionadas

- [FIELD](/pt/grammar/edge/field/), [ENUM](/pt/grammar/edge/enum/), [CODEC](/pt/grammar/edge/codec/), [BIND](/pt/grammar/edge/bind/)
- [Edge](/pt/grammar/edge/), [Documento de especificação de Codec](/pt/grammar/codec-spec/)
