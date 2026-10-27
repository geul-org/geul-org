---
title: "GEUL-SIDX"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL-SIDX é a Reference de declaração que aponta para um alvo pelo GEUL SIDX (Semantic-aligned Index), que leva o significado nos próprios bits."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL-SIDX é a Reference de declaração que aponta para um alvo pelo GEUL SIDX (Semantic-aligned Index). O SIDX é um identificador que leva o significado (tipo, atributos) nos próprios bits.

## Layout

```
TAG WORD          0000 0LLL L001 1QQQ      CCCC = 0011
[TAG estendida de Length]
SIDX              todo o restante
```

- O Quantifier é igual ao dos outros Codecs de declaração. Se for Variable, é uma variável anônima dessa espécie ([Reference](/pt/grammar/reference/) Variable). A quantificação se faz apenas pelo `QQQ`. Não se põe quantificação dentro do valor do SIDX.
- O documento de especificação declara o SIDX como um único campo de valor bruto de largura restante. Será alterado quando as regras de largura forem definidas.

## Exemplo

| SIDX | Sequência de WORDs |
|---|---|
| (não normativo) 64 bits `0x1234 5678 9abc def0`, Identified | `0218 1234 5678 9abc def0` |

## Política de atribuição

- O papel é diferente do de [GEUL](/pt/grammar/reference/geul/). O GEUL é um ID de identidade, atribuído em geral em ordem (auto increment), e o GEUL-SIDX é um endereço semântico que dá valores próximos a alvos de significado próximo.
- O grau de proximidade é definido por estatísticas, acumulando dados de uso. Antes de haver estatísticas usa-se o ID GEUL e, depois de atribuir o SIDX, liga-se o GEUL e o GEUL-SIDX do mesmo alvo por [SAME-NODE](/pt/grammar/edge/same-node/).

## Questões em aberto

- **Largura.** Decide-se vendo as estatísticas. Examinam-se 4 WORD (64 bits) e 16 WORD, entre outros. No SIDX os bits superiores têm significado, então a regra da "menor largura" dos outros Codecs de declaração (proibição de `0x0000` à frente) não pode ser usada tal como está. Por isso será uma largura fixa (ou fixa por subformato). Até ser decidido, o documento de especificação declara o SIDX como valor bruto de largura restante.
- **Estabilidade da atribuição.** Em Reference, valores inteiros iguais são o mesmo alvo e um ID atribuído não se reutiliza. Para não mover SIDX já atribuídos mesmo que as estatísticas mudem, é preciso uma atribuição append-only (atribuição esparsa, deixando lugares para os de significado próximo). Se as mudanças forem frequentes, decide-se se o SIDX se define não como identificador permanente, mas como um índice vinculado a uma edição do registro.
- **Unicidade.** Se o SIDX é gerado a partir do significado dos bits e pode colidir, isso não casa com a premissa de que "valores inteiros iguais são o mesmo alvo". Ao atribuir, resolvem-se as colisões para garantir a unicidade.
- Codebook e formato de divulgação do registro.

## Páginas relacionadas

- [Reference](/pt/grammar/reference/), [GEUL](/pt/grammar/reference/geul/)
