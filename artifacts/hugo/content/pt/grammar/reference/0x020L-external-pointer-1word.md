---
title: "EXTERNAL-POINTER-1WORD (0x020L~0x024L)"
weight: 32
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-POINTER é a Reference de indicação que aponta o LOCAL ID de um documento importado por IMPORT-DOC no HEAD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-POINTER é a Reference de indicação que aponta o LOCAL ID de um documento importado por IMPORT-DOC no HEAD.

| Item | Valor |
|---|---|
| Nome | `EXTERNAL-POINTER-1WORD` (grupo 5Q. Os nomes por código estão na tabela de membros abaixo) |
| TAG ID | `0x020L~0x024L` |
| Seção | 1 `0001` (Reference EXTERNAL), deslocamento C na seção = 0~4 |
| Kind | Reference · classificação: indicação |
| Lado Hugo | `reference/external-pointer.md` (essa página trata também de [EXTERNAL-POINTER-2WORD](0x025L-external-pointer-2word.md) e [EXTERNAL-POINTER-4WORD](0x02AL-external-pointer-4word.md)) |

## Membros {#구성원}

Esta página trata de um conjunto do sistema 5Q, cinco códigos. A quantificação é o deslocamento na seção `C % 5` ([Reference](_index.md#quantifier)). Há um documento de codec por código. Os campos dos cinco documentos de codec são iguais; só diferem o alvo do DECLARE e o nome (BIND).

| TAG ID | Nome | Quantificação | Codec ID | Documento de especificação | TAG WORD |
|---|---|---|---|---|---|
| `0x020L` | `EXTERNAL-POINTER-1WORD-IDENTIFIED` | Identified | `0x00000200` | `0x00000000/codecs/0x00000200/` | `0000 0010 0000 LLLL` |
| `0x021L` | `EXTERNAL-POINTER-1WORD-GENERIC` | Generic | `0x00000210` | `0x00000000/codecs/0x00000210/` | `0000 0010 0001 LLLL` |
| `0x022L` | `EXTERNAL-POINTER-1WORD-FREE-CHOICE` | Free-choice | `0x00000220` | `0x00000000/codecs/0x00000220/` | `0000 0010 0010 LLLL` |
| `0x023L` | `EXTERNAL-POINTER-1WORD-UNIVERSAL` | Universal | `0x00000230` | `0x00000000/codecs/0x00000230/` | `0000 0010 0011 LLLL` |
| `0x024L` | `EXTERNAL-POINTER-1WORD-VARIABLE` | Variable | `0x00000240` | `0x00000000/codecs/0x00000240/` | `0000 0010 0100 LLLL` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([Documento de especificação de Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato aceito (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `import-id` | #2 | valor bruto de 1 WORD |  |  |
| 2 | `target-id` | #3 | valor bruto restante (`0xFFFF`) |  |  |

EXTERNAL-POINTER é a Reference de indicação que aponta o LOCAL ID de um documento importado por [IMPORT-DOC](../meta/0x1E4L-import-doc.md) no HEAD.

## Layout {#레이아웃}

```
TAG WORD          0000 001C CCCC LLLL      Codec 0x020L~0x02EL (seção 1)
[TAG estendida de Length]
IMPORT ID         largura definida pelo Codec (1/2/4 WORD)
ID do alvo        todo o restante. LOCAL ID do documento importado, na menor largura
```

| Codec (Identified, Generic, Free-choice, Universal, Variable) | Nome | Largura do IMPORT ID |
|---|---|---|
| `0x020L~0x024L` | EXTERNAL-POINTER-1WORD | 1 WORD |
| `0x025L~0x029L` | EXTERNAL-POINTER-2WORD | 2 WORD |
| `0x02AL~0x02EL` | EXTERNAL-POINTER-4WORD | 4 WORD |

- A largura é determinada pelo número do sistema: se sistema − 6 (`C / 5` do deslocamento `C` na seção) for 0, 1, 2, a largura é 1, 2, 4 WORD. A quantificação é `C % 5`.

- Usa-se o Codec mais estreito em que cabe o valor do IMPORT ID.
- O IMPORT ID é o valor atribuído pelo `IMPORT-DOC` deste documento. O EXTERNAL-POINTER não registra o Issuer. O Issuer e o ID do documento obtêm-se desse `IMPORT-DOC`. A versão também é definida por esse `IMPORT-DOC` (fixa ou mais recente).
- Se o LOCAL ID do documento importado é o mesmo, é o mesmo alvo, tanto se usado como LOCAL dentro desse documento quanto como EXTERNAL-POINTER aqui.
- Se for Variable, é uma variável LOCAL do documento importado.

## Validade {#유효성}

- É invalid se este documento não tiver um `IMPORT-DOC` que atribua esse IMPORT ID.
- Se o IMPORT ID cabe num Codec mais estreito e se usa um mais largo, é rejeitado como non-minimal.
- É invalid se o ID do alvo for `0`. O próprio documento importado é apontado por [DOC-POINTER](0x041L-doc-pointer.md).
- WORD `0x0000` à frente no ID do alvo é proibido.

## Exemplo {#예시}

| Alvo | WORD sequence |
|---|---|
| LOCAL 5 do IMPORT ID 1 | `0202 0001 0005` |
| LOCAL 65536 do IMPORT ID 1 | `0203 0001 0001 0000` |
| LOCAL 5 do IMPORT ID 70000 | `0253 0001 1170 0005` |

## Páginas relacionadas {#관련-페이지}

- [Reference](_index.md), [LOCAL](0x005L-local.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [DOC-POINTER](0x041L-doc-pointer.md)
- [IMPORT-DOC](../meta/0x1E4L-import-doc.md)

## Texto original do documento de especificação {#규격-문서-원문}

Como o documento de especificação `0x00000000/codecs/0x00000200/latest.geul` aparece ao ser lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000020000000000
BODY
#1 DECLARE 0x0200
#2 FIELD #1 0x0001
#3 FIELD #1 rest
#4 BIND #1 "EXTERNAL-POINTER-1WORD-IDENTIFIED"
#5 BIND #2 "import-id"
#6 BIND #3 "target-id"
```

Acima está o documento de codec de `EXTERNAL-POINTER-1WORD-IDENTIFIED` (`0x020L`). Os documentos de codec dos outros membros (`EXTERNAL-POINTER-1WORD-GENERIC`, `EXTERNAL-POINTER-1WORD-FREE-CHOICE`, `EXTERNAL-POINTER-1WORD-UNIVERSAL`, `EXTERNAL-POINTER-1WORD-VARIABLE`) diferem apenas no Codec ID do DOC-ID, no alvo do DECLARE e no nome ligado em `#1` (BIND).
