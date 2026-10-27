---
title: "CO-AUTHOR"
weight: 34
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "CO-AUTHOR é o Meta de proveniência que registra, como Reference, quem escreveu o documento em conjunto (git Co-authored-by)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Registra quem escreveu o documento em conjunto (git `Co-authored-by`).

## Layout

```
TAG WORD          0001 1LLL L010 0001      Codec 0x21
[TAG estendida de Length]
Payload           um registro Reference (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL etc.)
```

- Codec: Meta `0x21`, classe de proveniência (`010`)
- Payload: Reference embutida
- Quantidade: pode haver vários

## Interpretação e validade

- A Reference não é restrita a um Codec. Pode ser pessoa, organização, modelo ou motor de regras ([EXTERNAL-ISSUER](/pt/grammar/reference/external-issuer/), [GEUL](/pt/grammar/reference/geul/), [WIKIDATA-QID](/pt/grammar/reference/wikidata-qid/), [LOCAL](/pt/grammar/reference/local/) etc.).
- Nos documentos publicados no geul.org não se põe Reference que aponte para pessoa natural ([Issuer e publicação](/pt/grammar/issuer/#publicação-no-geulorg)). Aponta-se uma organização ou um Issuer. Como exceção, apontar uma pessoa natural por [WIKIDATA-QID](/pt/grammar/reference/wikidata-qid/) é permitido.
- Se for LOCAL, o alvo é descrito no BODY.
