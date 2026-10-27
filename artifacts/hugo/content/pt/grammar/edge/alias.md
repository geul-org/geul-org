---
title: "ALIAS"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ALIAS é o Edge descritivo que liga um outro nome (alias) do alvo Subject (Codec 0x05). O layout é igual ao de LABEL."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ALIAS é o Edge descritivo que liga, como Object, um outro nome (alias) do alvo Subject. Codec `0x05`.

[LABEL](/pt/grammar/edge/label/) é o nome representativo naquele idioma (no máximo um por idioma), e ALIAS é outro nome do mesmo alvo (vários por idioma; "also known as" do Wikidata). Serve sobretudo para busca. O layout e a validade são os mesmos de LABEL.

## Layout

```
TAG WORD          0001 0LLL L000 0101
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference
Object            Value UTF8-LANGUAGE-TEXT ou 1 registro Reference LOCAL
```

## Interpretação e validade

- As regras de Subject e Object são as de [LABEL](/pt/grammar/edge/label/) (o Object é [UTF8-LANGUAGE-TEXT](/pt/grammar/value/text/utf8-language-text/) ou um LOCAL que se resolve para ele).
- Pode haver vários ALIAS para o mesmo Subject e idioma. A ordem é a do documento.
- Não se coloca como ALIAS o mesmo texto do LABEL do mesmo Subject e idioma (para o nome representativo basta um LABEL). Esta regra é uma recomendação.
- O documento de especificação do geul.org restringe o Object com [CODEC](/pt/grammar/edge/codec/) (`084A`, `084B`, `0008`, igual a LABEL).

## Exemplo (não normativo)

Edge Id `0003`, Subject Q42 (`00A0 002a`), Object `DNA` (en): idioma `08C6 656e` (BCP47 `en`) + texto de 3 bytes (ímpar) → `UTF8-LANGUAGE-TEXT-ODD` (`0x4B`), `0A4B 08C6 656e 444e 4100`.

- TAG 1 + Edge Id 2 + Subject 2 + Object 5 = 10 WORDs, `LLLL=1001`. A TAG é `1485`.

```
1485 0088 0003 00A0 002a 0A4B 08C6 656e 444e 4100
```

## Páginas relacionadas

- [Edge](/pt/grammar/edge/), [LABEL](/pt/grammar/edge/label/), [DESCRIPTION](/pt/grammar/edge/description/), [UTF8-LANGUAGE-TEXT](/pt/grammar/value/text/utf8-language-text/)
