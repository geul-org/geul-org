---
title: "BIND (0x0A3L)"
weight: 163
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "BIND é um Edge de enunciado que liga a Subject um nome com o qual a máquina faz correspondência."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `BIND` (BIND `BIND` do documento de especificação) |
| TAG ID | `0x0A3L` |
| Codec ID | `0x00000A30` |
| Documento de especificação | `0x00000000/codecs/0x00000A30/` (alvo do DECLARE `0A30`) |
| Seção | 5 `0101` (Edge de enunciado), deslocamento C dentro da seção = 3 |
| Kind | Edge · família: enunciado, grupo: apontamento e nome |
| TAG WORD | `0000 1010 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Descrição no índice | Liga a Subject um nome (`UTF8-TEXT-*`) com o qual a máquina faz correspondência. Deve ser único no âmbito e coincidir exatamente, e não tem idioma |
| Lado Hugo | `edge/bind.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELDs no documento é a ordem dos campos do Payload ([documento de especificação de Codec](../codec-spec.md)). O Edge Id do Edge não é declarado como FIELD.

| Ordem | Campo (BIND) | FIELD | Largura | Formato aceito (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | registro | qualquer registro (exceto marcador de posição) |  |
| 2 | `name` | #3 | registro | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD |  |

BIND é um Edge de enunciado que liga a Subject um nome com o qual a máquina faz correspondência. Codec `0x0A3L`.

É nomeação. O nome legível por pessoas (título por idioma) fica a cargo de [LABEL](0x0A4L-label.md). Usa-se o mesmo registro para o nome de um símbolo de programa e para o nome de domínio da lista de Issuers.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0011 LLLL
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference, ou 1 WORD de TAG WORD de codec
nome              1 Value UTF8-TEXT-*
```

## Interpretação e validade {#해석과-유효성}

- Subject é exatamente um registro [Reference](../reference/_index.md) completo. Se for LOCAL, é um alvo deste documento (símbolo etc.); se for uma Reference de apontamento, é um alvo de outro documento. O próprio documento é [DOC-POINTER](../reference/0x041L-doc-pointer.md), e o próprio Issuer é [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md).
- Ou então Subject é uma única TAG WORD de codec (apenas Kind e Codec, `LLLL = 0`, sem Payload). Isto não é um registro com Payload vazio, mas aponta para o próprio código direto, isto é, para o seu documento de especificação (codec de Issuer GEUL `0x0000<TAG>`) ([documento de especificação de Codec](../codec-spec.md), [DECLARE](0x0BBL-declare.md)). Exemplo: `0B80` é PUBLICATION. Codecs de formato Issuer não são apontados nesta forma.
- Outros registros (Value etc.) não podem ser Subject. Como o FIELD do documento de especificação de BIND declara Subject apenas com largura `0` (registro), esta restrição é uma regra do corpo de BIND.
- O nome é exatamente um Value [UTF8-TEXT](../value/0x072L-utf8-text.md). Não tem idioma e não é normalizado. Só é o mesmo nome se os bytes forem iguais.
- O âmbito do nome é o documento que contém o BIND. Em um documento, o mesmo nome não é ligado a Subjects diferentes.
- Vários nomes podem ser ligados a um Subject (alias, nome antigo). Se o documento não dispuser de outro modo, o último BIND é o nome representativo.
- Outros registros apontam para o alvo por LOCAL ID, não pelo nome. O nome serve para fazer a correspondência com o exterior (funções do host, entrada de endereços, pessoas).
- Os caracteres que um nome pode usar são determinados pelo uso. O nome de domínio da lista de Issuers segue as regras de domínio (minúsculas, IDNA) ([endereço de publicação e lista de versões](../publishing.md#issuer-목록)).
- Na lista de versões não se põe BIND. Não existe endereço por nome de documento ([endereço de publicação e lista de versões](../publishing.md#문서-이름)).

## Comprimento {#길이}

```
total = 1 + N_len + N_id + N_subject + N_name WORDs
```

## Exemplo (não normativo) {#예시-비규범}

Símbolo de programa: Edge Id `0003`, Subject LOCAL 7, nome `main`.

- O nome `main` tem 4 bytes (par), portanto `0722 6D61 696E`, 3 WORDs.
- O Edge tem TAG 1 + Edge Id 2 + Subject 2 + nome 3 = 8 WORDs, TAG `0A37`.

```
0A37 0051 0003 0051 0007 0722 6D61 696E
```

## Páginas relacionadas {#관련-페이지}

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [endereço de publicação e lista de versões](../publishing.md#issuer-목록) (nome de domínio da lista de Issuers)
- [LOCAL](../reference/0x005L-local.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md), [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md)

## Texto original do documento de especificação {#규격-문서-원문}

É o documento de especificação `0x00000000/codecs/0x00000A30/latest.geul` lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A3000000000
BODY
#1 DECLARE 0x0A30
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "BIND"
#5 BIND #2 "subject"
#6 BIND #3 "name"
#7 CODEC #3 0x0720
#8 CODEC #3 0x0730
```
