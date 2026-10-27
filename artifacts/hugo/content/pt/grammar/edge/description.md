---
title: "DESCRIPTION"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DESCRIPTION é o Edge descritivo que liga uma descrição curta do alvo Subject em um idioma (Codec 0x06). O layout é igual ao de LABEL."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIPTION é o Edge descritivo que liga, como Object, uma descrição do alvo Subject em um idioma específico. Codec `0x06`.

A descrição é uma frase curta que distingue o alvo (description do Wikidata, por exemplo: "capital e maior cidade da Alemanha"). Não é uma definição nem uma afirmação sobre o alvo. As proposições sobre o alvo escrevem-se com [TRIPLE](/pt/grammar/edge/triple/). O layout é igual ao de [LABEL](/pt/grammar/edge/label/). A descrição e o seu idioma vão em um único Object, [UTF8-LANGUAGE-TEXT](/pt/grammar/value/text/utf8-language-text/). Não há campo bruto.

## Layout

```
TAG WORD          0001 0LLL L000 0110
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference
Object            Value UTF8-LANGUAGE-TEXT ou 1 registro Reference LOCAL
```

## Interpretação e validade

- As regras de Subject e Object são as de [LABEL](/pt/grammar/edge/label/). O Subject é exatamente um registro Reference completo. O Object é exatamente um registro UTF8-LANGUAGE-TEXT (`0x4A`, `0x4B`) completo, ou uma Reference LOCAL que se resolve para UTF8-LANGUAGE-TEXT por um vínculo [REFERENCE-NODE](/pt/grammar/edge/reference-node/) do mesmo documento.
- Um texto sem idioma (UTF8-TEXT) não pode ser DESCRIPTION. Como a descrição é uma por idioma, a regra só se sustenta com idioma. Uma descrição comum a vários idiomas escreve-se com o idioma `mul`.
- Para um mesmo Subject e idioma há no máximo uma DESCRIPTION.
- A descrição serve para distinguir de outros alvos com o mesmo nome. No mesmo idioma, é desejável que o par LABEL e DESCRIPTION não se repita em dois alvos, mas a especificação não verifica isso (no Wikidata também é só uma recomendação, não imposta).
- O documento de especificação do geul.org restringe o Object com [CODEC](/pt/grammar/edge/codec/) (`084A`, `084B`, `0008`, igual a LABEL).

## Comprimento

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

- O registro de idioma do Object e o número de bytes do texto ficam a cargo do registro Object. O cursor depois de ler o último registro deve coincidir exatamente com o fim do Edge.
- A descrição é mais longa que o label, então o Object e o Edge passam facilmente de 15 WORDs. Nesse caso usa-se a extensão de Length ([Registro](/pt/grammar/record/)).

## Exemplo (não normativo)

Edge Id `0009`, Subject Q64 (`00A0 0040`), Object `capital and largest city of Germany` (en). O idioma é LANGUAGE-BCP47-CODE, pois o registro ainda não existe.

- O Object é idioma `08C6 656E` (BCP47 `en`, 2 WORDs) + texto de 35 bytes (ímpar, 18 WORDs), então `0x4B`, TAG 1 + TAG estendida 1 + 20 = 22 WORDs, `0F4B 0016 …`.
- O Edge tem TAG 1 + TAG estendida 1 + Edge Id 2 + Subject 2 + Object 22 = 28 WORDs, então `LLLL=1110`, TAG `1706`, TAG estendida `001C`.

```
1706 001C 0088 0009 00A0 0040
0F4B 0016 08C6 656E 6361 7069 7461 6C20 616E 6420 6C61 7267 6573 7420 6369 7479 206F 6620 4765 726D 616E 7900
```

## Correspondência com o Wikidata

- As `descriptions` do item (uma por idioma) → uma DESCRIPTION por idioma. O código de idioma é transcrito pela mesma tabela de correspondência de códigos de idioma de LABEL.

## Questões em aberto

- Se há casos que justifiquem permitir uma descrição UTF8-TEXT sem idioma (por ora não é permitido).

## Páginas relacionadas

- [Edge](/pt/grammar/edge/), [LABEL](/pt/grammar/edge/label/), [ALIAS](/pt/grammar/edge/alias/), [CODEC](/pt/grammar/edge/codec/)
- [UTF8-LANGUAGE-TEXT](/pt/grammar/value/text/utf8-language-text/), [LOCAL](/pt/grammar/reference/local/), [REFERENCE-NODE](/pt/grammar/edge/reference-node/)
