---
title: "DELTA-BASE"
weight: 59
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DELTA-BASE é o Meta de linhagem que indica que este arquivo de versão é um diff em relação à versão base do mesmo documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

É a marca de que este arquivo de versão não é um snapshot, e sim um **diff** em relação à versão base do mesmo documento (delta do git packfile). A versão em si continua sendo definida como snapshot. O hash de conteúdo, a lista de versões e a assinatura são todos calculados sobre o snapshot restaurado ao aplicar o diff ([Armazenamento de diff](/pt/grammar/document/#armazenamento-de-diff)).

## Layout

```
TAG WORD          0001 1LLL L011 1010      Codec 0x3A
ID da versão      2 WORD sem sinal (versão base do mesmo documento)
```

- Codec: Meta `0x3A`, classe de linhagem (`011`)
- Payload: ID de versão de 2 WORD (valor bruto)
- Quantidade: no máximo um

## Interpretação e validade

- Só se usa em documentos com [DOC-ID](/pt/grammar/meta/declaration/doc-id/) (documentos cujas versões são geridas pela lista de versões). `versions.geul`, `documents.geul` e `issuers.geul`, que não têm gestão de versões, e documentos sem nome não têm diff.
- A versão base é uma versão publicada do mesmo `DOC-ID` e é anterior a esta versão. `0` (sem versão) é invalid.
- O hash de conteúdo do snapshot restaurado deve ser igual ao hash desta versão na lista de versões ([PUBLICATION](/pt/grammar/edge/publication/)). Se for diferente, este diff é invalid. Por isso o hash do resultado não se escreve no diff.
- Só um documento cujos registros do BODY são todos Edge (registros com Edge Id) pode ficar como diff, porque a unidade do diff é o LOCAL ID (Edge Id).
- As regras de restauração do snapshot seguem [Armazenamento de diff](/pt/grammar/document/#armazenamento-de-diff). A exclusão fica a cargo de [DELTA-REMOVE](/pt/grammar/meta/lineage/delta-remove/).
- Não há marca de adição ou revisão. Se o Edge Id do BODY do diff existir na base, é revisão; se não existir, é adição. A adição recebe os números a partir do [NEXT-LOCAL-ID](/pt/grammar/meta/lineage/next-local-id/) da lista de versões. Reutilizar um LOCAL ID excluído é invalid ([Revisão](/pt/grammar/document/#revisão)).

## Exemplo

Diff em relação à versão base 3:

```
193A 0000 0003
```

- TAG `193A` (Meta `0x3A`, `LLLL=0010`, 3 WORD), ID da versão `0000 0003`.

## Questões em aberto

1. Intervalo de snapshots: a cada quantas versões pôr um snapshot completo (comprimento da cadeia de diffs e custo de restauração).
2. Se a versão base deve se limitar à versão imediatamente anterior.
3. Onde guardar o arquivo de diff: no lugar do arquivo de versão (`<ID da versão>.geul`), e a relação com o repositório endereçado por conteúdo `h/` (`h/` é achado pelo hash de conteúdo do snapshot).
