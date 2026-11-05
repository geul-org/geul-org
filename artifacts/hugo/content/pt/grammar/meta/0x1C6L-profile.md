---
title: "PROFILE (0x1C6L)"
weight: 454
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Declara o perfil aplicado ao documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `PROFILE` (BIND `PROFILE` do documento de especificação) |
| TAG ID | `0x1C6L` |
| Codec ID | `0x00001C60` |
| Documento de especificação | `0x00000000/codecs/0x00001C60/` (alvo do DECLARE `1C60`) |
| Seção | 14 `1110` (Meta), deslocamento C = 6 na seção |
| Kind | Meta · classe: definição |
| TAG WORD | `0001 1100 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Perfil aplicado |
| Lado Hugo | `meta/declaration/profile.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `profile` | #2 | registro | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD | |

Declara o perfil aplicado ao documento. Os mesmos registros são interpretados segundo o documento de Codec definido pelo perfil (por exemplo, `tangeul-1.0` remete a [TOULMIN](../toulmin/_index.md)).

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0110 LLLL      Codec 0x1C6L
[TAG de extensão de Length]
Payload           Value UTF8-TEXT "<nome>-<major>.<minor>"
```

- Codec: Meta `0x1C6L`, classe de definição
- Payload: Value embutido ([UTF8-TEXT](../value/0x072L-utf8-text.md))
- Quantidade: no máximo um

## Interpretação e validade {#해석과-유효성}

- Perfis com major diferente são rejeitados. Diferenças de minor são permitidas (apenas acréscimos).
- Sem perfil, lê-se apenas com a gramática básica do GEUL e as especificações de código direto.

## Exemplo {#예시}

- `tangeul-1.0`: `0x1C67 0x0736 7461 6E67 6575 6C2D 312E 3000`

## Problemas em aberto {#열린-문제}

- Registro de nomes de perfil (geul.org) e regras de nomenclatura.
- Se o perfil é referenciado por ID de documento (IMPORT) ou posto como texto.

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001C60/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C6000000000
BODY
#1 DECLARE 0x1C60
#2 FIELD #1 record
#3 BIND #1 "PROFILE"
#4 BIND #2 "profile"
#5 CODEC #2 0x0720
#6 CODEC #2 0x0730
```
