---
title: "OPAQUE-BYTES (0x07EL·0x07FL)"
weight: 126
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "OPAQUE-BYTES é uma sequência arbitrária de bytes cujo significado e formato não são definidos por este próprio formato."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

OPAQUE-BYTES é uma sequência arbitrária de bytes cujo significado e formato não são definidos por este próprio formato. Códigos diretos de Value `0x07EL` (número par de bytes) e `0x07FL` (número ímpar de bytes), família BINARY. O número de bytes é determinado pelo bit menos significativo do Codec e pelo número de WORDs do Payload. É `2 × número de WORD do Payload − bit menos significativo`, e não há Byte Count ([Value](_index.md)).

| Item | Valor |
|---|---|
| Nome | `OPAQUE-BYTES` (grupo par/ímpar; os nomes por código estão na tabela de membros abaixo) |
| TAG ID | `0x07EL`·`0x07FL` |
| Seção | 3 `0011` (Value), deslocamento C dentro da seção = 30~31 |
| Kind | Value · família: BINARY |
| Descrição do índice | Sequência de bytes de significado e formato desconhecidos. Bytes pares·ímpares |
| Lado Hugo | `value/binary/opaque-bytes.md` |

## Membros {#구성원}

Esta página trata em conjunto os dois códigos de um par par/ímpar. O código par é o de valores com número par de bytes, e o ímpar, o de valores com número ímpar ([Registro e TAG WORD](../record.md#가변-길이-바이트열)). Há um documento de Codec por código. Os campos dos dois documentos de Codec são iguais; só diferem o alvo de DECLARE e o nome (BIND).

| TAG ID | Nome | Número de bytes | Codec ID | Documento de especificação | TAG WORD |
|---|---|---|---|---|---|
| `0x07EL` | `OPAQUE-BYTES-EVEN` | par | `0x000007E0` | `0x00000000/codecs/0x000007E0/` | `0000 0111 1110 LLLL` |
| `0x07FL` | `OPAQUE-BYTES-ODD` | ímpar | `0x000007F0` | `0x00000000/codecs/0x000007F0/` | `0000 0111 1111 LLLL` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([Documento de especificação de Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | restante, valor bruto (`0xFFFF`) |  |  |

## Layout {#레이아웃}

```
TAG WORD          0000 0111 111P LLLL      Codec 0x07EL/0x07FL
[TAG de extensão de Length] quando o total é de 15 WORD ou mais
Payload WORD 1st ... Nth   bytes / zero padding final
```

## Interpretação e validade {#해석과-유효성}

- Do Payload, leem-se em ordem tantos bytes quantos indica o número de bytes. Dentro de um WORD, o byte alto vem primeiro.
- O número de WORDs do Payload é `ceil(número de bytes/2)`. Se o código é ímpar e o byte baixo do último WORD não é `00`, rejeita-se.
- Se o código par/ímpar, o número de WORDs do Payload e o zero padding não forem coerentes entre si, rejeita-se.

## Situação do formato {#형식-지위}

- O par de códigos par/ímpar (`0x07EL` par, `0x07FL` ímpar), a disposição do payload e o zero padding do último WORD não citam um padrão industrial externo, mas são framing próprio de GEUL.

## Comprimento {#길이}

- O total é 1 WORD de TAG mais o número de WORDs da TAG de extensão de Length (se houver) e do Payload. Até 14 WORD usa-se o comprimento direto; com 15 WORD ou mais, o comprimento estendido `1110`·`1111`, e a TAG de extensão também entra no total ([Registro e TAG WORD](../record.md)).
- 0 byte escreve-se como registro de 1 WORD do código par (`0x07EL`) (apenas o TAG WORD) ([Value](_index.md)).

## Exemplo {#예시}

Os bytes `AB CD EF` são 3 bytes (ímpar), logo é `OPAQUE-BYTES-ODD` (`0x07FL`), Payload `ABCD EF00`. O total é 3 WORDs, portanto `LLLL=0010`.

```
07F2 ABCD EF00
```

A sequência vazia de bytes é `07E0` (`OPAQUE-BYTES-EVEN`, apenas o TAG WORD), 1 WORD.

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x000007E0/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007E000000000
BODY
#1 DECLARE 0x07E0
#2 FIELD #1 rest
#3 BIND #1 "OPAQUE-BYTES-EVEN"
#4 BIND #2 "bytes"
```

Acima está o documento de Codec de `OPAQUE-BYTES-EVEN` (`0x07EL`). O documento de Codec do outro membro (`OPAQUE-BYTES-ODD`) difere apenas no Codec ID do DOC-ID, no alvo de DECLARE e no nome ligado a `#1` (BIND).
