---
title: "SIGNATURE (0x1E6L)"
weight: 486
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Assinatura sobre o hash de conteúdo do documento (commit e tag assinados do git)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `SIGNATURE` (BIND `SIGNATURE` do documento de especificação) |
| TAG ID | `0x1E6L` |
| Codec ID | `0x00001E60` |
| Documento de especificação | `0x00000000/codecs/0x00001E60/` (alvo do DECLARE `1E60`) |
| Seção | 15 `1111` (Meta), deslocamento C = 6 na seção |
| Kind | Meta · classe: verificação |
| TAG WORD | `0001 1110 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição do índice | Assinatura sobre um alvo. A assinatura do documento assina o hash de conteúdo (commit e tag assinados do git) |
| Lado Hugo | `meta/verification/signature.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([documento de especificação do Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato de entrada (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `algorithm` | #2 | valor bruto 1 WORD |  | `0x0001` ed25519 |
| 2 | `signer` | #3 | registro | `0400` ISSUER-POINTER |  |
| 3 | `signature` | #4 | valor bruto restante(`0xFFFF`) |  |  |

Assinatura sobre o hash de conteúdo do documento (commit e tag assinados do git).

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0110 LLLL      Codec 0x1E6L
[TAG de extensão de Length]
ID do algoritmo   1 WORD (0x0001 = Ed25519)
Signatário        Registro Reference ISSUER-POINTER (Issuer)
Assinatura        Todo o restante. A largura é definida pelo algoritmo (Ed25519 32 WORDs)
```

- Codec: Meta `0x1E6L`, classe de verificação
- Payload: ID do algoritmo (valor bruto, 1 WORD) + signatário (Reference embutida) + assinatura (valor bruto, restante)
- Quantidade: vários possíveis

## Interpretação e validade {#해석과-유효성}

- O alvo da assinatura é o hash de conteúdo. Não se assina apenas o BODY ([assinatura](../issuer.md#서명)).
- Por ser da classe de verificação, fica de fora do hash de conteúdo. Acrescentar uma assinatura não altera o hash.
- A verificação não é «se houver assinatura, conferir», e sim «deve haver assinatura da chave determinada».
- O documento de lista de versões é assinado por quem publica.
- O signatário é um [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md) (Issuer) que aponta para o próprio Issuer. Como é um registro Reference e termina no seu próprio Length, o layout fica único mesmo que a largura da assinatura varie conforme o algoritmo (campo restante de [DECLARE](../edge/0x0BBL-declare.md)).
- Se o número de WORDs da assinatura diferir da largura definida pelo algoritmo, é inválido.

## Problemas em aberto {#열린-문제}

- Resta decidir se o instante da assinatura também será assinado.

## Texto do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00001E60/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E6000000000
BODY
#1 DECLARE 0x1E60
#2 FIELD #1 0x0001
#3 FIELD #1 record
#11 CODEC #3 0x0400
#4 FIELD #1 rest
#5 ENUM #2 0x0001
#6 BIND #1 "SIGNATURE"
#7 BIND #2 "algorithm"
#8 BIND #3 "signer"
#9 BIND #4 "signature"
#10 BIND #5 "ed25519"
```
