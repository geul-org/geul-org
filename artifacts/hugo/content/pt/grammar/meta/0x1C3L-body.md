---
title: "BODY (0x1C3L)"
weight: 451
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "Registro que encerra o HEAD e inicia o BODY."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `BODY` (BIND `BODY` do documento de especificação) |
| TAG ID | `0x1C3L` |
| Codec ID | `0x00001C30` |
| Documento de especificação | `0x00000000/codecs/0x00001C30/` (alvo do DECLARE `1C30`) |
| Seção | 14 `1110` (Meta), deslocamento C = 3 na seção |
| Kind | Meta · classe: estrutura |
| TAG WORD | `0001 1100 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | 1 WORD. Encerra o HEAD do documento e inicia o BODY. |
| Lado Hugo | `meta/structure/body.md` |

## Campos (documento de especificação) {#필드-규격-문서}

O documento de especificação não tem FIELD. Nenhum campo de Payload é declarado.

Registro que encerra o HEAD e inicia o BODY.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0011 LLLL      Codec 0x1C3L
[TAG de extensão de Length]
```

- Codec: Meta `0x1C3L`, classe de estrutura
- Payload: nenhum (1 WORD)
- Quantidade: no máximo um por documento

## Interpretação e validade {#해석과-유효성}

- Se o HEAD estiver vazio, omite-se. Um documento sem `BODY` é todo BODY. Se o HEAD contiver Meta ou Edge de HEAD ([SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) do documento inteiro e seu QUALIFIER), o `BODY` é colocado.
- Não há Payload. O total é 1 WORD.

## Exemplo {#예시}

- `0x1C30`

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001C30/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C3000000000
BODY
#1 DECLARE 0x1C30
#2 BIND #1 "BODY"
```
