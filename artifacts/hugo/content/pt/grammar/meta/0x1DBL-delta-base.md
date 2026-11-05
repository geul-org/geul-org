---
title: "DELTA-BASE (0x1DBL)"
weight: 475
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Marca de que este arquivo de versão não é um snapshot, e sim um diff em relação a uma versão-base do mesmo documento (delta do git packfile)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `DELTA-BASE` (BIND `DELTA-BASE` do documento de especificação) |
| TAG ID | `0x1DBL` |
| Codec ID | `0x00001DB0` |
| Documento de especificação | `0x00000000/codecs/0x00001DB0/` (alvo do DECLARE `1DB0`) |
| Seção | 14 `1110` (Meta), deslocamento C = 27 na seção |
| Kind | Meta · classe: linhagem |
| TAG WORD | `0001 1101 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Este arquivo de versão é um diff em relação a uma versão-base do mesmo documento (ID de versão de 2 WORDs) (git packfile delta) |
| Lado Hugo | `meta/lineage/delta-base.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `version` | #2 | valor bruto 2 WORD | `0620` UNSIGNED-INTEGER |  |

Marca de que este arquivo de versão não é um snapshot, e sim um **diff** em relação a uma versão-base do mesmo documento (delta do git packfile). A versão em si continua a ser definida como snapshot. O hash de conteúdo, a lista de versões e as assinaturas referem-se todos ao snapshot restaurado pela aplicação do diff ([armazenamento por diff](../document.md#diff-저장)).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1011 LLLL      Codec 0x1DBL
ID de versão      2 WORDs sem sinal (versão-base do mesmo documento)
```

- Codec: Meta `0x1DBL`, classe de linhagem
- Payload: ID de versão de 2 WORDs (valor bruto)
- Quantidade: no máximo um

## Interpretação e validade {#해석과-유효성}

- Só se usa em documentos que têm [DOC-ID](0x1C7L-doc-id.md). A lista de versões `versions.geul`, os documentos de lista (versões de `issuers/`) e os documentos sem nome, que não têm `DOC-ID`, não usam diff.
- A versão-base é uma versão publicada do mesmo `DOC-ID` e é anterior a esta versão. `0` (sem versão) é inválido.
- O hash de conteúdo do snapshot restaurado deve ser igual ao hash desta versão na lista de versões ([PUBLICATION](../edge/0x0B8L-publication.md)). Se diferir, este diff é inválido. Por isso não se escreve à parte, dentro do diff, o hash do resultado.
- Só pode ser mantido como diff um documento em que todos os registros do BODY sejam Edge (registros com Edge Id), pois a unidade do diff é o LOCAL ID (Edge Id).
- As regras de restauração do snapshot seguem o [armazenamento por diff](../document.md#diff-저장). A exclusão cabe a [DELTA-REMOVE](0x1DCL-delta-remove.md).
- Não há marca separada de adição ou revisão. Se o Edge Id do BODY do diff existe na base, é revisão; se não, é adição. As adições recebem numeração a partir de [NEXT-LOCAL-ID](0x1DDL-next-local-id.md) da lista de versões. Reutilizar um LOCAL ID excluído é inválido ([revisão](../document.md#개정)).

## Exemplo {#예시}

Diff em relação à versão-base 3:

```
1DB2 0000 0003
```

- TAG `1DB2` (Meta `0x1DBL`, `LLLL=0010`, 3 WORDs), ID de versão `0000 0003`.

## Problemas em aberto {#열린-문제}

1. Intervalo de snapshots: a cada quantas versões se mantém um snapshot completo (comprimento da cadeia de diffs e custo de restauração).
2. Se a versão-base deve ser limitada à versão imediatamente anterior.
3. Local de armazenamento do arquivo de diff: se no lugar do arquivo de versão (`<ID de versão>.geul`), e a relação com o endereço por hash de conteúdo `<Issuer>/hashes/` (`hashes/` é localizado pelo hash de conteúdo do snapshot).

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001DB0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DB000000000
BODY
#1 DECLARE 0x1DB0
#2 FIELD #1 0x0002
#3 BIND #1 "DELTA-BASE"
#4 BIND #2 "version"
#5 CODEC #2 0x0620
```
