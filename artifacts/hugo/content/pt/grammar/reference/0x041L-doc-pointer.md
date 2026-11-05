---
title: "DOC-POINTER (0x041L)"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "DOC-POINTER é a Reference de indicação e declaração que aponta uma versão de um documento publicado por um Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `DOC-POINTER` (BIND `DOC-POINTER` do documento de especificação) |
| TAG ID | `0x041L` |
| Codec ID | `0x00000410` |
| Documento de especificação | `0x00000000/codecs/0x00000410/` (alvo do DECLARE `0410`) |
| Seção | 2 `0010` (Reference diversas), deslocamento C na seção = 1 |
| Kind | Reference · classificação: indicação e declaração |
| TAG WORD | `0000 0100 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Lado Hugo | `reference/doc-pointer.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([Documento de especificação de Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato aceito (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | valor bruto restante (`0xFFFF`) |  |  |
| 2 | `doc` | #3 | valor bruto de 4 WORD |  |  |
| 3 | `version` | #4 | valor bruto de 2 WORD |  |  |

DOC-POINTER é a Reference de indicação e declaração que aponta uma versão de um documento publicado por um Issuer. Torna-se alvo da publicação, da depreciação (deprecate) e da exclusão de documentos, da edição citada e de enunciados sobre o documento.

## Layout {#레이아웃}

```
TAG WORD          0000 0100 0001 LLLL      Codec 0x041L
[TAG estendida de Length]
Issuer            2/4/16 WORD
ID do documento   4 WORD
ID da versão      2 WORD
```

## Interpretação e validade {#해석과-유효성}

- A largura do Issuer é o que resta do Payload depois de subtrair 6 WORD do ID do documento e do ID da versão. O Codec não divide a largura. É invalid se a largura não for 2, 4 ou 16 WORD, ou se o valor do Issuer couber numa largura mais estreita (forma canônica do Issuer).
- O ID da versão não se omite. Se a omissão fosse permitida, o comprimento do Payload sozinho não bastaria para definir a largura do Issuer (Issuer de 4 WORD sem versão e Issuer de 2 WORD com versão dariam os mesmos 8 WORD).
- O ID de versão `0` é a versão mais recente. Fica atrelado à versão vigente no momento da interpretação. Os demais valores ficam fixados nessa versão ([PUBLICATION](../edge/0x0B8L-publication.md)).
- O ID de documento `0` é o documento de índice das definições de termos do Issuer. O próprio Issuer é apontado por [ISSUER-POINTER](0x040L-issuer-pointer.md).
- Todo Issuer reserva os IDs de documento `0x0000000000000000` e `0xFFFFFFFFFFFFFFFF` ([Issuer e publicação](../issuer.md#용어-정의-문서)). `0xFFFFFFFFFFFFFFFF` é usado na lista de Issuer `issuers/` do Issuer `0x00000000` e os outros Issuer não o usam. PUBLICATION, DEPRECATION e TOMBSTONE de `issuers/versions.geul` apontam as versões da lista com esse valor ([endereço de publicação e lista de versões](../publishing.md#목록-문서)).
- É uma única posição do Codec `0x041L`. Não há quantificação (Identified).
- A forma de apontar um documento de um Issuer é apenas DOC-POINTER. É invalid apontar um documento com `EXTERNAL-ISSUER-*` (Issuer, ID de documento, ID de alvo `0`) ou `EXTERNAL-POINTER-*` (IMPORT ID, ID de alvo `0`).
- Onde se usa: Meta [DOC-ID](../meta/0x1C7L-doc-id.md) e [IMPORT-DOC](../meta/0x1E4L-import-doc.md); PUBLICATION, DEPRECATION e TOMBSTONE da lista de versões.
- O documento de codec não tem ID de documento. O documento de codec e sua versão são apontados por [CODEC-POINTER](0x042L-codec-pointer.md).

## Exemplo {#예시}

Documento `0xFFFF000000000001` do Issuer GEUL `0x00000000`.

| Versão | WORD sequence |
|---|---|
| 1 | `0418 0000 0000 FFFF 0000 0000 0001 0000 0001` |
| mais recente (`0`) | `0418 0000 0000 FFFF 0000 0000 0001 0000 0000` |

- TAG 1 + Issuer 2 + ID do documento 4 + ID da versão 2 = 9 WORD, `LLLL=1000`. O TAG é `0000 0100 0001 1000` = `0418`.

## Páginas relacionadas {#관련-페이지}

- [Reference](_index.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [PUBLICATION](../edge/0x0B8L-publication.md)
- [Issuer e publicação](../issuer.md)

## Texto original do documento de especificação {#규격-문서-원문}

Como o documento de especificação `0x00000000/codecs/0x00000410/latest.geul` aparece ao ser lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000041000000000
BODY
#1 DECLARE 0x0410
#2 FIELD #1 rest
#3 FIELD #1 0x0004
#4 FIELD #1 0x0002
#5 BIND #1 "DOC-POINTER"
#6 BIND #2 "issuer"
#7 BIND #3 "doc"
#8 BIND #4 "version"
```
