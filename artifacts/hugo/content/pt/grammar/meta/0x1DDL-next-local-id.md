---
title: "NEXT-LOCAL-ID (0x1DDL)"
weight: 477
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Registra o LOCAL ID que a próxima versão do documento atribuirá a um novo enunciado (auto increment de SGBD, AUTO_INCREMENT do MySQL)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `NEXT-LOCAL-ID` (BIND `NEXT-LOCAL-ID` do documento de especificação) |
| TAG ID | `0x1DDL` |
| Codec ID | `0x00001DD0` |
| Documento de especificação | `0x00000000/codecs/0x00001DD0/` (alvo do DECLARE `1DD0`) |
| Seção | 14 `1110` (Meta), deslocamento C = 29 na seção |
| Kind | Meta · classe: linhagem |
| TAG WORD | `0001 1101 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Próximo LOCAL ID a atribuir (auto increment). Fica no HEAD da lista de versões `versions.geul` |
| Lado Hugo | `meta/lineage/next-local-id.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `next` | #2 | valor bruto restante(`0xFFFF`) |  |  |

Registra o LOCAL ID que a próxima versão do documento atribuirá a um novo enunciado (auto increment de SGBD, `AUTO_INCREMENT` do MySQL). Todos os LOCAL ID atribuídos em qualquer versão do documento são menores que este valor.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1101 LLLL      Codec 0x1DDL
Payload           Próximo LOCAL ID a atribuir, inteiro sem sinal na menor largura
```

- Codec: Meta `0x1DDL`, classe de linhagem
- Payload: valor bruto (inteiro sem sinal na menor largura)
- Quantidade: no máximo um
- Onde se coloca: no HEAD do documento de lista de versões `versions.geul` ([PUBLICATION](../edge/0x0B8L-publication.md))

## Interpretação e validade {#해석과-유효성}

- O LOCAL ID (incluindo o Edge Id) é uma identidade que atravessa as versões ([revisão](../document.md#개정)). Um novo enunciado recebe este valor e o valor aumenta em 1. Um LOCAL ID excluído não é reutilizado. Por isso, mesmo que o enunciado de valor máximo seja excluído, este valor não diminui.
- O LOCAL ID `0` não é atribuído, portanto o valor inicial é `1`. Se ainda não há versão, este Meta não é colocado e o próximo número é `1`.
- Quem publica atualiza e escreve o valor no novo documento de lista ao publicar uma versão. Deve ser maior que qualquer LOCAL ID usado na versão publicada. Se for menor ou igual, é inválido.
- O valor só aumenta. Se for menor que o do documento de lista anterior ([PARENT](0x1D1L-parent.md)), é inválido.
- Não existe em documentos sem controle de versão (documentos sem `versions.geul`, documentos sem nome). Tais documentos também não usam diff ([DELTA-BASE](0x1DBL-delta-base.md)).
- Não se coloca no corpo do documento (documento de versão). A memória do número não é conteúdo do documento, e sim estado de quem continua a publicar o documento (do lado das refs do git, não dos commits).

## Exemplo {#예시}

Próximo número a atribuir 524:

```
1DD1 020C
```

- TAG `1DD1`(Meta `0x1DDL`, `LLLL=0001`, 2 WORD), Payload `020C`.

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001DD0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DD000000000
BODY
#1 DECLARE 0x1DD0
#2 FIELD #1 rest
#3 BIND #1 "NEXT-LOCAL-ID"
#4 BIND #2 "next"
```
