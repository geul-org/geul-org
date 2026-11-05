---
title: "DOC-ID (0x1C7L)"
weight: 455
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Declara o identificador deste documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `DOC-ID` (BIND `DOC-ID` do documento de especificação) |
| TAG ID | `0x1C7L` |
| Codec ID | `0x00001C70` |
| Documento de especificação | `0x00000000/codecs/0x00001C70/` (alvo do DECLARE `1C70`) |
| Seção | 14 `1110` (Meta), deslocamento C = 7 na seção |
| Kind | Meta · classe: definição |
| TAG WORD | `0001 1100 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Identificador deste documento. Reference embutida `DOC-POINTER` (Issuer, ID do documento, versão 0). Documentos de Codec usam `CODEC-POINTER` (Issuer, Codec ID, versão 0) |
| Lado Hugo | `meta/declaration/doc-id.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #2 | registro | `0410` DOC-POINTER, `0420` CODEC-POINTER | |

Declara o identificador deste documento. É necessário para que outros documentos possam apontar para este documento e para os alvos dentro dele.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0111 LLLL      Codec 0x1C7L
[TAG de extensão de Length]
Documento         Registro Reference DOC-POINTER. (Issuer, ID do documento, versão 0). Documentos de Codec usam CODEC-POINTER
```

- Codec: Meta `0x1C7L`, classe de definição
- Payload: uma Reference embutida [DOC-POINTER](../reference/0x041L-doc-pointer.md) (Issuer, ID do documento, versão 0)
- Quantidade: no máximo um. É obrigatório nos documentos de versão sob `docs/<ID do documento>/` e `codecs/<Codec ID>/`

## Interpretação e validade {#해석과-유효성}

- O Payload é exatamente um registro Reference `DOC-POINTER` (Issuer, ID do documento, versão `0`). O ID de versão é sempre `0`. A versão é atribuída pela lista de versões, não pelo documento. Documentos de Codec usam `CODEC-POINTER` (Issuer, Codec ID, versão `0`) ([CODEC-POINTER](../reference/0x042L-codec-pointer.md)).
- Assim, a notação que aponta para "este documento" é a mesma no DOC-ID, no registro PUBLICATION da lista de versões e nas citações de outros documentos.
- Independentemente da versão, o mesmo documento tem o mesmo `DOC-ID`. O ID de versão e o hash de conteúdo não são escritos no documento ([versão](../document.md#버전)).
- Não existe endereço por nome de documento ([endereço de publicação e lista de versões](../publishing.md#문서-이름)). O título legível por pessoas fica a cargo do [LABEL](../edge/0x0A4L-label.md) de enunciado.
- Se ausente, é um documento sem nome, só apontável pelo hash de conteúdo. É necessário para que outro documento aponte por Reference dêitica para um LOCAL deste documento.
- Quem obtém o documento verifica se o `DOC-ID` do documento recebido é igual ao Issuer e ao ID de documento solicitados.
- O ID de documento `0x0000000000000000` é o documento de índice de definições de termos do Issuer ([Issuer](../issuer.md)). Esse documento também é um documento de versão sob `docs/<ID do documento>/`, portanto leva DOC-ID (`DOC-POINTER` (Issuer, `0`, `0`)). O próprio Issuer é representado por [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md).
- Os documentos de versão `<ID de versão>.geul` (incluindo documentos de especificação) em `<Issuer>/docs/<ID do documento>/` e `<Issuer>/codecs/<Codec ID>/` sob `.well-known/geul/` exigem `DOC-ID`.
- Documentos de lista são exceção e não levam `DOC-ID`: a lista de versões `versions.geul` ([PUBLICATION](../edge/0x0B8L-publication.md)) e as versões `<ID de versão>.geul` da lista de Issuers `issuers/` ([endereço de publicação e lista de versões](../publishing.md#목록-문서)). De que é a lista, quem diz é o DOC-POINTER do registro. A versão de um documento de lista é apontada pelo PUBLICATION do respectivo `versions.geul` com DOC-POINTER (`0x00000000`, ID de documento reservado, ID de versão). O endereço por hash de conteúdo `<Issuer>/hashes/` é cópia dos documentos acima e segue o original.
- O ID de documento `0xFFFFFFFFFFFFFFFF` é reservado em todos os Issuers (`0x0000000000000000` também) e é usado na lista de Issuers do Issuer `0x00000000`. Outros Issuers não o usam. Como documentos de lista não têm `DOC-ID`, esse valor aparece apenas no DOC-POINTER do registro de `issuers/versions.geul`.
- O documento de especificação de Codec é um documento de Codec do Issuer GEUL `0x00000000`. Não tem ID de documento e leva, como `DOC-ID`, CODEC-POINTER (`0x00000000`, Codec ID, `0`). O Codec ID é o valor do TAG WORD de Kind·Codec escrito em 32 bits (`0x0B80` → `0x00000B80`) ([documento de especificação](../codec-spec.md)).

## Exemplo {#예시}

- Issuer `0x00000002`, documento `0x…0005`: `1C79 0418 0000 0002 0000 0000 0000 0005 0000 0000` (TAG Meta 1 + TAG Reference 1 + Issuer 2 + ID de documento 4 + versão 2 = 10 WORDs)

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001C70/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C7000000000
BODY
#1 DECLARE 0x1C70
#2 FIELD #1 record
#5 CODEC #2 0x0410
#3 BIND #1 "DOC-ID"
#4 BIND #2 "doc"
#6 CODEC #2 0x0420
```
