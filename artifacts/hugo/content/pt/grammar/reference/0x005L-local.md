---
title: "LOCAL (0x005L~0x009L)"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "LOCAL é a Reference de declaração que aponta um alvo por um ID emitido por este documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Valor |
|---|---|
| Nome | `LOCAL` (grupo 5Q. Os nomes por código estão na tabela de membros abaixo) |
| TAG ID | `0x005L~0x009L` |
| Seção | 0 `0000` (entidade Reference), deslocamento C na seção = 5~9 |
| Kind | Reference · classificação: declaração |
| Lado Hugo | `reference/local.md` |

## Membros {#구성원}

Esta página trata de um conjunto do sistema 5Q, cinco códigos. A quantificação é o deslocamento na seção `C % 5` ([Reference](_index.md#quantifier)). Há um documento de codec por código. Os campos dos cinco documentos de codec são iguais; só diferem o alvo do DECLARE e o nome (BIND).

| TAG ID | Nome | Quantificação | Codec ID | Documento de especificação | TAG WORD |
|---|---|---|---|---|---|
| `0x005L` | `LOCAL-IDENTIFIED` | Identified | `0x00000050` | `0x00000000/codecs/0x00000050/` | `0000 0000 0101 LLLL` |
| `0x006L` | `LOCAL-GENERIC` | Generic | `0x00000060` | `0x00000000/codecs/0x00000060/` | `0000 0000 0110 LLLL` |
| `0x007L` | `LOCAL-FREE-CHOICE` | Free-choice | `0x00000070` | `0x00000000/codecs/0x00000070/` | `0000 0000 0111 LLLL` |
| `0x008L` | `LOCAL-UNIVERSAL` | Universal | `0x00000080` | `0x00000000/codecs/0x00000080/` | `0000 0000 1000 LLLL` |
| `0x009L` | `LOCAL-VARIABLE` | Variable | `0x00000090` | `0x00000000/codecs/0x00000090/` | `0000 0000 1001 LLLL` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([Documento de especificação de Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato aceito (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `local-id` | #2 | valor bruto restante (`0xFFFF`) |  |  |

LOCAL é a Reference de declaração que aponta um alvo por um ID emitido por este documento. Refere-se a alvos dentro do documento sem Issuer externo. Para apontar de fora do documento, coloca-se no documento o Meta [DOC-ID](../meta/0x1C7L-doc-id.md), e outro documento o aponta com uma Reference de indicação.

## Layout {#레이아웃}

```
TAG WORD          0000 0000 0101 LLLL      Codec 0x005L~0x009L (Identified 0x005L)
[TAG estendida de Length]
LOCAL ID          unsigned big-endian na menor largura
```

| LOCAL ID | Total | TAG WORD (Identified) |
|---|---|---|
| `0..65535` | 2 WORD | `0x0051` |
| `65536..2^32-1` | 3 WORD | `0x0052` |
| `2^32..2^48-1` | 4 WORD | `0x0053` |
| `2^48..2^64-1` | 5 WORD | `0x0054` |

- Os Codec são `0x005L` (Identified), `0x006L` (Generic), `0x007L` (Free-choice), `0x008L` (Universal) e `0x009L` (Variable). O TAG WORD de Identified é `0000 0000 0101 LLLL`.
- Segue a regra comum das Reference de escrever o ID do alvo com o menor número de WORD.

## Edge Id {#edge-id}

- O LOCAL que é o primeiro elemento do Payload de um Edge é a declaração do Edge Id desse Edge ([Edge](../edge/_index.md)). Para declarar um Edge Id usa-se apenas Identified (`0x005L`).
- Um LOCAL em qualquer outra posição do Payload de um Edge é uma menção. Os alvos deste documento são escritos como LOCAL a cada menção. Não há código de indicação separado para apontar os alvos deste documento.

## Atribuição de identificadores {#식별자-할당}

- O ID é um inteiro atribuído pelo codificador. A magnitude do número e a ordem de atribuição não têm significado além da identidade.
- **UNIQUE (obrigatório).** Num documento, um LOCAL ID aponta apenas um alvo. Cada Edge Id é declarado uma única vez por documento (Edge HEAD e Edge BODY compartilham um único espaço de numeração). Se mais de um Edge declara o mesmo Edge Id, é invalid.
- **AUTO INCREMENT (recomendado).** Um novo ID recebe o máximo dos IDs atribuídos até então no documento + 1, e cresce na ordem do documento. Vale também entre versões (cria-se com valor maior que o de um ID excluído). É apenas recomendação, não condição de validade; um documento que não incrementa também é valid. O decodificador não depende da magnitude nem da continuidade dos IDs.
- O ID `0` não é atribuído. Não aponta nenhum alvo e também não é usado como Edge Id. Os IDs de alvo são atribuídos a partir de `1`.
- Um documento é apontado, dentro ou fora dele, apenas por um [DOC-POINTER](0x041L-doc-pointer.md) (o próprio documento, pelo DOC-POINTER do seu `DOC-ID`). Também se podem associar ao documento `BIND`, `LABEL` e Edge de julgamento.
- O próprio Issuer é apontado por [ISSUER-POINTER](0x040L-issuer-pointer.md). O ID de documento `0` é o documento de índice das definições de termos do Issuer.
- Os Codec que dão significado ao `0` na posição de um componente (o "nenhum" das REF e dos Edge de execução de [TOULMIN](../toulmin/_index.md); o "documento inteiro" do Target de [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) do HEAD) seguem a regra desse Codec. Isso é um acordo interno desse Codec, distinto do [marcador de posição](../slot-marker.md).
- Um ID, uma vez atribuído, não é reutilizado no mesmo documento.
- Usa-se sempre a menor largura capaz de representar o valor.

## Identidade e escopo {#동일성과-범위}

- No mesmo documento, LOCAL ID com o mesmo valor inteiro é o mesmo alvo. A largura da codificação não faz parte da identidade.
- Um LOCAL Identified representa um alvo identificado. Não se usa para anônimo, não especificado, null nem sentinel. Dizer que existe valor mas não se sabe qual (UNKNOWN-VALUE), ou que não há valor (NO-VALUE), escreve-se como [marcador de posição](../slot-marker.md) no campo que aceita esse marcador.
- LOCAL ID diferentes são apenas Reference diferentes; não significam que os alvos na realidade sejam diferentes.
- A identidade de LOCAL não se estende para fora do documento. O mesmo número em outro documento não tem relação.
- O LOCAL Variable (`0x009L`) é uma variável de discurso nomeada ([Reference](_index.md) Variable).

## Mesclagem {#병합}

Ao mesclar vários documentos em um, cria-se para cada documento de origem uma tabela de correspondência `old ID → new ID`, reatribuem-se todos os LOCAL ID com IDs do novo documento e substituem-se todas as referências.

- IDs que eram iguais no mesmo documento de origem devem continuar iguais após a mesclagem.
- O mesmo número em documentos de origem diferentes não tem relação e não se unifica automaticamente na mesma Reference.
- Se restar um único LOCAL que não pôde ser substituído, a mesclagem é recusada.

## Validade {#유효성}

As seguintes codificações ou atribuições são invalid.

- Codificação não minimal com WORD `0x0000` à frente (exceção: `0x0000` de 1 WORD para o valor 0)
- O Codec na posição de declaração de Edge Id não é Identified (`0x005L`) ou o ID é `0`
- Um ID atribuído de forma sobreposta a alvos diferentes no mesmo documento
- O mesmo Edge Id declarado duas ou mais vezes no mesmo documento

## Exemplo {#예시}

| LOCAL ID | WORD sequence |
|---:|---|
| 1 | `0051 0001` |
| 65535 | `0051 FFFF` |
| 65536 | `0052 0001 0000` |
| 4294967295 | `0052 FFFF FFFF` |
| 1, Variable | `0091 0001` |

## Páginas relacionadas {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [EXTERNAL-POINTER](0x020L-external-pointer-1word.md)
- [Edge](../edge/_index.md)

## Texto original do documento de especificação {#규격-문서-원문}

Como o documento de especificação `0x00000000/codecs/0x00000050/latest.geul` aparece ao ser lido com `geul show` (hexadecimal em maiúsculas).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000005000000000
BODY
#1 DECLARE 0x0050
#2 FIELD #1 rest
#3 BIND #1 "LOCAL-IDENTIFIED"
#4 BIND #2 "local-id"
```

Acima está o documento de codec de `LOCAL-IDENTIFIED` (`0x005L`). Os documentos de codec dos outros membros (`LOCAL-GENERIC`, `LOCAL-FREE-CHOICE`, `LOCAL-UNIVERSAL`, `LOCAL-VARIABLE`) diferem apenas no Codec ID do DOC-ID, no alvo do DECLARE e no nome ligado em `#1` (BIND).
