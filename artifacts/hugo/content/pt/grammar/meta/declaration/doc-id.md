---
title: "DOC-ID"
weight: 19
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "DOC-ID é o Meta de definição que declara o identificador do documento por um DOC-POINTER (Issuer, ID do documento, versão 0) que aponta para o próprio documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Declara o identificador deste documento. É necessário para que outros documentos possam apontar para este documento e para os alvos dentro dele.

## Layout

```
TAG WORD          0001 1LLL L001 0010      Codec 0x12
[TAG estendida de Length]
Documento         registro Reference DOC-POINTER. (Issuer, ID do documento, versão 0)
```

- Codec: Meta `0x12`, classe de definição (`001`)
- Payload: uma Reference embutida [DOC-POINTER](/pt/grammar/reference/doc-pointer/) (Issuer, ID do documento, versão 0)
- Quantidade: no máximo um. Obrigatório nos documentos cujo nome começa com `0x`

## Interpretação e validade

- O Payload é exatamente um registro Reference `DOC-POINTER` (Issuer, ID do documento, versão `0`). Do ID da versão só se usa `0`. A versão não é atribuída pelo documento, e sim pela lista de versões. O Quantifier é `000`.
- Assim, a notação que aponta para "este documento" é igual no DOC-ID, no Subject de [BIND](/pt/grammar/edge/bind/) de `documents.geul` e nas citações de outros documentos.
- Independentemente da versão, o mesmo documento tem o mesmo `DOC-ID`. O ID da versão e o hash de conteúdo não se escrevem no documento ([Versão](/pt/grammar/document/#versão)).
- O nome para endereço fica a cargo do `BIND` descritivo do índice de nomes `documents.geul` ([Endereço de publicação e lista de versões](/pt/grammar/publishing/#nome-do-documento)), e o título legível por pessoas fica a cargo do [LABEL](/pt/grammar/edge/label/) descritivo.
- Sem ele, é um documento sem nome, que só pode ser apontado pelo hash de conteúdo. É necessário para que outro documento aponte o LOCAL deste documento por uma Reference de indicação.
- Quem busca um documento verifica se o `DOC-ID` do documento recebido é igual ao Issuer e ao ID do documento solicitados.
- O ID de documento `0x0000000000000000` é o documento de índice de definição de termos do Issuer ([Issuer](/pt/grammar/issuer/)). Como o nome desse documento também começa com `0x`, ele também tem DOC-ID (`DOC-POINTER` (Issuer, `0`, `0`)). O próprio Issuer é representado por [ISSUER-POINTER](/pt/grammar/reference/issuer-pointer/).
- Os documentos em `.well-known/geul/` cujo nome começa com `0x` (documento de versão `<ID da versão>.geul`, documentos de especificação) devem ter `DOC-ID`.
- Os documentos cujo nome não começa com `0x` não têm `DOC-ID`, como exceção: a lista de versões `versions.geul` ([PUBLICATION](/pt/grammar/edge/publication/)), o índice de nomes de documentos `documents.geul` e o índice de nomes de Issuer `issuers.geul` ([Endereço de publicação e lista de versões](/pt/grammar/publishing/)). O repositório de hashes de conteúdo `h/` contém cópias dos documentos acima e segue o original.
- O documento de especificação de Codec é um documento do Issuer GEUL `0x0000`. O ID do documento é a TAG WORD de Kind·Codec estendida para 4 WORD (`0x1018` → `0x0000000000001018`). Como a Reference `0000` é reservada, nunca resulta em ID de documento `0` ([especificação](/pt/grammar/codec-spec/)).

## Exemplo

- Issuer `0x0001`, documento `0x…0005`: `1C12 03B8 0001 0000 0000 0000 0005 0000 0000` (TAG do Meta 1 + TAG da Reference 1 + Issuer 1 + ID do documento 4 + versão 2 = 9 WORD)
