---
title: "LABEL"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "LABEL é o Edge descritivo que liga um nome do alvo Subject em um idioma, por meio de um Object UTF8-LANGUAGE-TEXT (Codec 0x04)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LABEL é o Edge descritivo que liga, como Object, o nome (label) do alvo Subject em um idioma específico. Codec `0x04`. Não é um Edge que represente o lemma da lexicografia geral.

O nome e o seu idioma vão em um único Object, [UTF8-LANGUAGE-TEXT](/pt/grammar/value/text/utf8-language-text/). Não há campo bruto.

## Layout

```
TAG WORD          0001 0LLL L000 0100
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference
Object            Value UTF8-LANGUAGE-TEXT ou 1 registro Reference LOCAL
```

## Interpretação e validade

- O Subject é exatamente um registro Reference completo. A fronteira é achada pelo Length do próprio Subject; se não for Reference ou estiver incompleto, é invalid.
- O Object é exatamente um registro [UTF8-LANGUAGE-TEXT](/pt/grammar/value/text/utf8-language-text/) (`0x4A`, `0x4B`) completo. As regras de idioma e texto (aceitam-se os dois formatos de idioma, comparação do mesmo idioma) seguem esse formato.
- O Object também pode ser uma Reference LOCAL. Nesse caso, deve resolver-se para UTF8-LANGUAGE-TEXT por um vínculo [REFERENCE-NODE](/pt/grammar/edge/reference-node/) do mesmo documento. Se não se resolver, ou se resolver para outro tipo de alvo, é invalid.
- O documento de especificação do geul.org escreve essa restrição com [CODEC](/pt/grammar/edge/codec/) (Object = `084A`, `084B`, `0008`). O alvo de resolução do LOCAL não se expressa com CODEC.
- Se o Object não for um dos dois formatos acima ou o registro estiver incompleto, é invalid. Um texto sem idioma (UTF8-TEXT) não pode ser LABEL. Um nome para máquina, sem idioma, escreve-se com [BIND](/pt/grammar/edge/bind/). Um nome comum a vários idiomas escreve-se com o idioma `mul`.
- Para um mesmo Subject e idioma há no máximo um LABEL. Outros nomes escrevem-se com [ALIAS](/pt/grammar/edge/alias/).

## Comprimento

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

- O registro de idioma do Object e o número de bytes do texto ficam a cargo do registro Object, não do Edge. O cursor depois de ler o último registro deve coincidir exatamente com o fim do Edge.

## Exemplo (não normativo)

Como o registro do código de idioma de `en` ainda não está selado, `0783` é um valor não normativo, não um código definitivo.

### LANGUAGE-SHORT-CODE

Edge Id `0007`, Subject Q22686 (`00A0 589e`), Object `Donald Trump` (en).

- O Object é idioma `08C8 0783` (SHORT-CODE, 2 WORDs) + texto de 12 bytes (par, 6 WORDs), então `UTF8-LANGUAGE-TEXT-EVEN` (`0x4A`), 9 WORDs no total: `0C4A 08C8 0783 446f 6e61 6c64 2054 7275 6d70`.
- O Edge tem TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORDs, `LLLL=1101`. A TAG é `1684`.

```
1684 0088 0007 00A0 589e 0C4A 08C8 0783 446f 6e61 6c64 2054 7275 6d70
```

### LANGUAGE-BCP47-CODE

Edge Id `0008`, Subject Q155 (`00A0 009b`), Object `Brasil` (pt-BR).

- O Object é idioma `09C7 7074 2d42 5200` (BCP47 `pt-BR`, 4 WORDs) + texto de 6 bytes (par, 3 WORDs), então 8 WORDs no total: `0BCA 09C7 7074 2d42 5200 4272 6173 696c`.
- O Edge tem TAG 1 + Edge Id 2 + Subject 2 + Object 8 = 13 WORDs, `LLLL=1100`. A TAG é `1604`.

```
1604 0088 0008 00A0 009b 0BCA 09C7 7074 2d42 5200 4272 6173 696c
```

## Páginas relacionadas

- [Edge](/pt/grammar/edge/), [ALIAS](/pt/grammar/edge/alias/), [DESCRIPTION](/pt/grammar/edge/description/), [BIND](/pt/grammar/edge/bind/)
- [UTF8-LANGUAGE-TEXT](/pt/grammar/value/text/utf8-language-text/), [LANGUAGE-SHORT-CODE](/pt/grammar/value/text/language-short-code/), [LANGUAGE-BCP47-CODE](/pt/grammar/value/text/language-bcp47-code/)
- [LOCAL](/pt/grammar/reference/local/), [REFERENCE-NODE](/pt/grammar/edge/reference-node/)
