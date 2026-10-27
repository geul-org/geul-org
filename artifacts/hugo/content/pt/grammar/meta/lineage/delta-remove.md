---
title: "DELTA-REMOVE"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DELTA-REMOVE é o Meta de linhagem que registra, num diff, a lista de LOCAL IDs (Edge Id) a retirar do BODY do snapshot base."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Registra, num diff ([DELTA-BASE](/pt/grammar/meta/lineage/delta-base/)), os LOCAL IDs (Edge Id) dos registros a retirar do BODY do snapshot base ("artigo X revogado").

## Layout

```
TAG WORD          0001 1LLL L011 1011      Codec 0x3B
[TAG estendida de Length]
LOCAL IDs a excluir    registro Reference LOCAL × 1 ou mais
```

- Codec: Meta `0x3B`, classe de linhagem (`011`)
- Payload: um ou mais registros Reference [LOCAL](/pt/grammar/reference/local/)
- Quantidade: no máximo um

## Interpretação e validade

- Só se coloca em documentos com `DELTA-BASE`.
- Cada LOCAL ID deve ser um Edge Id presente no BODY do snapshot base. Se não existir, é invalid. Repetir o mesmo ID é invalid.
- Pôr de novo o mesmo Edge Id no BODY do mesmo diff é invalid (não se pode excluir e revisar ao mesmo tempo).
- Um LOCAL ID excluído não se atribui de novo a outro alvo em versões posteriores ([Revisão](/pt/grammar/document/#revisão)).
- Não haver registro no BODY do diff significa "não mudou". Por isso a exclusão só se expressa com este Meta.
- Os HEAD Edges (o [SOURCE](/pt/grammar/edge/source/#origem-do-documento-inteiro) do documento inteiro e seus QUALIFIERs) não se escrevem aqui. O HEAD é trocado por inteiro pelo HEAD do diff ([Armazenamento de diff](/pt/grammar/document/#armazenamento-de-diff)).

## Exemplo

Exclui os LOCAL `#7` e `#12`:

```
1A3B 0088 0007 0088 000C
```

- TAG `1A3B` (Meta `0x3B`, `LLLL=0100`, 5 WORD), Reference LOCAL `0088 0007`, `0088 000C`.
