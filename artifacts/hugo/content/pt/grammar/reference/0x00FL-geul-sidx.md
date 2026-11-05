---
title: "GEUL-SIDX (0x00FL~0x013L)"
weight: 15
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL-SIDX é a Reference de declaração que aponta um alvo pelo GEUL SIDX (Semantic-aligned Index)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `GEUL-SIDX` (grupo 5Q. Os nomes por código estão na tabela de membros abaixo) |
| TAG ID | `0x00FL~0x013L` |
| Seção | 0 `0000` (entidade Reference), deslocamento C na seção = 15~19 |
| Kind | Reference · classificação: declaração |
| Lado Hugo | `reference/geul-sidx.md` |

## Membros {#구성원}

Esta página trata de um conjunto do sistema 5Q, cinco códigos. A quantificação é o deslocamento na seção `C % 5` ([Reference](_index.md#quantifier)). Há um documento de codec por código. Os campos dos cinco documentos de codec são iguais; só diferem o alvo do DECLARE e o nome (BIND).

| TAG ID | Nome | Quantificação | Codec ID | Documento de especificação | TAG WORD |
|---|---|---|---|---|---|
| `0x00FL` | `GEUL-SIDX-IDENTIFIED` | Identified | `0x000000F0` | `0x00000000/codecs/0x000000F0/` | `0000 0000 1111 LLLL` |
| `0x010L` | `GEUL-SIDX-GENERIC` | Generic | `0x00000100` | `0x00000000/codecs/0x00000100/` | `0000 0001 0000 LLLL` |
| `0x011L` | `GEUL-SIDX-FREE-CHOICE` | Free-choice | `0x00000110` | `0x00000000/codecs/0x00000110/` | `0000 0001 0001 LLLL` |
| `0x012L` | `GEUL-SIDX-UNIVERSAL` | Universal | `0x00000120` | `0x00000000/codecs/0x00000120/` | `0000 0001 0010 LLLL` |
| `0x013L` | `GEUL-SIDX-VARIABLE` | Variable | `0x00000130` | `0x00000000/codecs/0x00000130/` | `0000 0001 0011 LLLL` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([Documento de especificação de Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato aceito (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `sidx` | #2 | valor bruto restante (`0xFFFF`) |  |  |

GEUL-SIDX é a Reference de declaração que aponta um alvo pelo GEUL SIDX (Semantic-aligned Index). O SIDX é um identificador que carrega significado (tipo, atributos) nos próprios bits.

## Layout {#레이아웃}

```
TAG WORD          0000 0000 1111 LLLL      Codec 0x00FL~0x013L (Identified 0x00FL)
[TAG estendida de Length]
SIDX              todo o restante
```

- O Quantifier é igual ao dos outros Codec de declaração. Se for Variable, é uma variável anônima desse tipo ([Reference](_index.md) Variable). A quantificação é feita apenas pelo código 5Q (`0x00FL~0x013L`, `C % 5`). Não se coloca quantificação no valor do SIDX.
- O documento de especificação declara o SIDX como um único campo de valor bruto de largura restante. Será alterado quando a regra de largura for definida.

## Exemplo {#예시}

| SIDX | WORD sequence |
|---|---|
| (não normativo) 64 bits `0x1234 5678 9ABC DEF0`, Identified | `00F4 1234 5678 9ABC DEF0` |

## Política de atribuição {#배정-방침}

- O papel é diferente do de [GEUL](0x00AL-geul.md). GEUL é um ID de identidade atribuído em geral em ordem (auto increment); GEUL-SIDX é um endereço semântico que dá valores próximos a alvos de significado próximo.
- O grau de proximidade é definido por estatística, acumulando dados de uso. Antes de a estatística se acumular, usa-se o GEUL ID; depois de atribuir o SIDX, ligam-se o GEUL e o GEUL-SIDX do mesmo alvo com [SAME-NODE](../edge/0x0A1L-same-node.md).

## Problemas em aberto {#열린-문제}

- **Largura.** Será definida a partir da estatística. Estão em análise 4 WORD (64 bits), 16 WORD e outras. O SIDX tem significado nos bits mais altos, por isso a regra de "menor largura" dos outros Codec de declaração (proibição de `0x0000` à frente) não se aplica tal qual. Assim, será uma largura fixa (ou fixa por subformato). Até ser definida, o documento de especificação declara o SIDX como valor bruto de largura restante.
- **Estabilidade da atribuição.** Em uma Reference, valor inteiro igual é o mesmo alvo, e um ID atribuído não é reutilizado. Para não mover SIDX já atribuídos mesmo que a estatística mude, é preciso atribuição append-only (atribuição esparsa que deixa lugares livres próximos em significado). Se for necessário mover com frequência, decide-se se o SIDX será definido não como identificador permanente, mas como índice atrelado à edição do registro.
- **Unicidade.** Se o SIDX for gerado a partir do significado dos bits e puder colidir, não combina com a premissa de que "valor inteiro igual é o mesmo alvo". Ao atribuir, resolvem-se as colisões para garantir a unicidade.
- Formato de publicação do codebook e do registro.

## Páginas relacionadas {#관련-페이지}

- [Reference](_index.md), [GEUL](0x00AL-geul.md)

## Texto original do documento de especificação {#규격-문서-원문}

Como o documento de especificação `0x00000000/codecs/0x000000F0/latest.geul` aparece ao ser lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000000F000000000
BODY
#1 DECLARE 0x00F0
#2 FIELD #1 rest
#3 BIND #1 "GEUL-SIDX-IDENTIFIED"
#4 BIND #2 "sidx"
```

Acima está o documento de codec de `GEUL-SIDX-IDENTIFIED` (`0x00FL`). Os documentos de codec dos outros membros (`GEUL-SIDX-GENERIC`, `GEUL-SIDX-FREE-CHOICE`, `GEUL-SIDX-UNIVERSAL`, `GEUL-SIDX-VARIABLE`) diferem apenas no Codec ID do DOC-ID, no alvo do DECLARE e no nome ligado em `#1` (BIND).
