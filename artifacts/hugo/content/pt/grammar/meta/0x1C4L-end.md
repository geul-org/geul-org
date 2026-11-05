---
title: "END (0x1C4L)"
weight: 452
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "Registro que fecha o documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `END` (BIND `END` do documento de especificação) |
| TAG ID | `0x1C4L` |
| Codec ID | `0x00001C40` |
| Documento de especificação | `0x00000000/codecs/0x00001C40/` (alvo do DECLARE `1C40`) |
| Seção | 14 `1110` (Meta), deslocamento C = 4 na seção |
| Kind | Meta · classe: estrutura |
| TAG WORD | `0001 1100 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | 1 WORD. Fecha o documento. |
| Lado Hugo | `meta/structure/end.md` |

## Campos (documento de especificação) {#필드-규격-문서}

O documento de especificação não tem FIELD. Nenhum campo de Payload é declarado.

Registro que fecha o documento.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0100 LLLL      Codec 0x1C4L
[TAG de extensão de Length]
```

- Codec: Meta `0x1C4L`, classe de estrutura
- Payload: nenhum (1 WORD)
- Quantidade: um por documento, no final

## Interpretação e validade {#해석과-유효성}

- É obrigatório. A posição é conferida pelo comprimento de [DOC](0x1C0L-doc-1word.md) (`DOC-*`).
- Se a entrada terminar sem END, o documento está truncado. Considerar ou não válido o conteúdo de um documento truncado é política do decodificador.
- Nada vem depois.

## Exemplo {#예시}

- `0x1C40`

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001C40/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C4000000000
BODY
#1 DECLARE 0x1C40
#2 BIND #1 "END"
```
