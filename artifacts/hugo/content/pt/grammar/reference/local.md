---
title: "LOCAL"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "LOCAL é a Reference de declaração que aponta para um alvo por um ID emitido por este documento. O Edge Id também é um LOCAL."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LOCAL é a Reference de declaração que aponta para um alvo por um ID emitido por este documento. Refere alvos dentro do documento sem Issuer externo e não tem sentido fora do documento. Para ser apontado de fora, o documento tem o Meta [DOC-ID](/pt/grammar/meta/declaration/doc-id/) e outros documentos o apontam por uma Reference de indicação.

## Layout

```
TAG WORD          0000 0LLL L000 1QQQ      CCCC = 0001
[TAG estendida de Length]
LOCAL ID          unsigned big-endian na menor largura
```

| LOCAL ID | Total | TAG WORD (Identified) |
|---|---|---|
| `0..65535` | 2 WORD | `0x0088` |
| `65536..2^32-1` | 3 WORD | `0x0108` |
| `2^32..2^48-1` | 4 WORD | `0x0188` |
| `2^48..2^64-1` | 5 WORD | `0x0208` |

- A TAG WORD é `0000 0 LLLL 0001 QQQ`. Em Identified (`000`), os 7 bits inferiores são `0x08`.
- Segue a regra comum das Reference de escrever o ID do alvo com o menor número de WORDs.

## Edge Id

- O LOCAL que é o primeiro elemento do Payload de um Edge é a declaração do Edge Id desse Edge ([Edge](/pt/grammar/edge/)). O LOCAL que declara um Edge Id usa apenas o Quantifier `000`.
- Os LOCAL nas outras posições do Payload de um Edge são menções. Os alvos deste documento escrevem-se como LOCAL a cada menção. Não há código de indicação separado para apontar alvos deste documento.

## Atribuição de identificadores

- O ID é um inteiro e é atribuído pelo codificador. O tamanho do número e a ordem de atribuição não têm outro significado além da identidade.
- **UNIQUE (obrigatório).** Em um documento, um LOCAL ID aponta para um único alvo. O Edge Id é declarado uma só vez por documento (HEAD Edge e BODY Edge usam um único espaço de números). Se mais de um Edge declarar o mesmo Edge Id, é invalid.
- **AUTO INCREMENT (recomendado).** Um novo ID é atribuído como o valor máximo dos IDs atribuídos até então nesse documento + 1, e cresce na ordem do documento. Também entre versões (cria-se com valor maior que o dos IDs excluídos). É só uma recomendação, não condição de validade, e um documento em que não cresça também é valid. O decodificador não depende do tamanho nem da continuidade do ID.
- O ID `0` não é atribuído. Não aponta para nenhum alvo e também não se usa como Edge Id. Os IDs de alvo são atribuídos a partir de `1`.
- O documento, dentro ou fora dele, é apontado apenas por um [DOC-POINTER](/pt/grammar/reference/doc-pointer/) (ele próprio é o DOC-POINTER do seu `DOC-ID`). Também se podem anexar ao documento `BIND`, `LABEL` e Edges de julgamento.
- O próprio Issuer é apontado por [ISSUER-POINTER](/pt/grammar/reference/issuer-pointer/). O ID de documento `0` é o documento de índice de definição de termos do Issuer.
- Nos Codecs que dão significado ao `0` na posição de um componente (REF e o "sem" dos Edges de execução de [TOULMIN](/pt/grammar/edge/toulmin/), o "documento inteiro" do Target do [SOURCE](/pt/grammar/edge/source/#origem-do-documento-inteiro) do HEAD), vale a regra desse Codec. É uma convenção interna desse Codec, diferente do [marcador de posição](/pt/grammar/reference/slot-marker/).
- Um ID atribuído uma vez não se reutiliza no mesmo documento.
- Usa-se sempre a menor largura que consegue expressar o valor.

## Identidade e âmbito

- No mesmo documento, LOCAL IDs com o mesmo valor inteiro são o mesmo alvo. A largura da codificação não faz parte da identidade.
- Um LOCAL Identified representa um alvo identificado. Não se usa como anônimo, não especificado, null ou sentinela. Dizer que há um valor mas não se sabe qual (UNKNOWN-VALUE) ou que não há valor (NO-VALUE) escreve-se, num campo que aceite o marcador, com o [marcador de posição](/pt/grammar/reference/slot-marker/).
- LOCAL IDs diferentes são apenas References diferentes, e não significam alvos diferentes no mundo real.
- A identidade de um LOCAL não se estende para fora do documento. O mesmo número em outro documento não tem relação.
- O LOCAL Variable (`100`) é uma variável de discurso com nome ([Reference](/pt/grammar/reference/) Variable).

## Fusão

Ao fundir vários documentos em um, cria-se para cada documento original uma tabela de correspondência `old ID → new ID`, reatribuem-se todos os LOCAL IDs com IDs do novo documento e trocam-se todas as referências.

- IDs que eram iguais no mesmo documento original devem continuar iguais depois da fusão.
- O mesmo número de documentos originais diferentes não tem relação e não se funde automaticamente na mesma Reference.
- Se houver um único LOCAL que não se conseguiu trocar, a fusão é rejeitada.

## Validade

As codificações e atribuições a seguir são invalid.

- Codificação não mínima com WORD `0x0000` à frente (a exceção é 1 WORD `0x0000` para o valor 0)
- Quantifier diferente de `000` na posição de declaração de Edge Id, ou ID igual a `0`
- Um mesmo ID atribuído, no mesmo documento, de forma sobreposta a alvos diferentes
- O mesmo Edge Id declarado duas ou mais vezes no mesmo documento

## Exemplo

| LOCAL ID | Sequência de WORDs |
|---:|---|
| 1 | `0088 0001` |
| 65535 | `0088 ffff` |
| 65536 | `0108 0001 0000` |
| 4294967295 | `0108 ffff ffff` |
| 1, Variable | `008C 0001` |

## Páginas relacionadas

- [Reference](/pt/grammar/reference/), [DOC-POINTER](/pt/grammar/reference/doc-pointer/), [ISSUER-POINTER](/pt/grammar/reference/issuer-pointer/), [EXTERNAL-POINTER](/pt/grammar/reference/external-pointer/)
- [Edge](/pt/grammar/edge/)
