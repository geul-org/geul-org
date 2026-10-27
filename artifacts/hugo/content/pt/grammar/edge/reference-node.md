---
title: "REFERENCE-NODE"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "REFERENCE-NODE é o Edge descritivo direcional que liga uma Reference a um registro Object para definir o que essa Reference é (Codec 0x00)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REFERENCE-NODE é o Edge descritivo direcional que liga uma Reference a um registro Object para definir ou vincular o que essa Reference é. Codec `0x00`.

O Subject indica o Object. Esse vínculo não é um [SAME-NODE](/pt/grammar/edge/same-node/), que afirma identidade de significado, nem quer dizer que os bytes dos dois registros sejam iguais.

## Layout

```
TAG WORD          0001 0LLL L000 0000
[TAG estendida de Length]
Edge Id           registro Reference LOCAL
Subject           1 registro Reference
Object            1 registro Reference ou Value
```

## Interpretação e validade

- O Subject deve ser exatamente um registro [Reference](/pt/grammar/reference/) completo. A fronteira é achada pelo Length do próprio Subject; se não for Reference ou estiver incompleto, é invalid.
- O Object deve ser exatamente um registro Reference ou Value completo. A fronteira é achada pelo Length do próprio Object; se for Edge ou Meta, ou estiver incompleto, é invalid.
- Se o Object for uma Reference, a cadeia de Reference seguida pelos vínculos REFERENCE-NODE não pode ser circular, e o LOCAL deve ser resolvido até o fim. Resolução circular e LOCAL pendente (dangling) são invalid.
- Se, no mesmo documento, um LOCAL ID for vinculado a Objects conflitantes, é invalid. O âmbito, o ID, a largura mínima e as regras de fusão do LOCAL seguem [LOCAL](/pt/grammar/reference/local/).
- Nem toda Reference precisa ser vinculada por REFERENCE-NODE.
- O uso representativo é `LOCAL → UTF8-LANGUAGE-TEXT`. Quando se coloca um LOCAL no Object de [LABEL](/pt/grammar/edge/label/), o texto é resolvido por este vínculo do mesmo documento.

Não se deve interpretar ao contrário a direção em que o Subject indica o Object. O significado e as regras de detalhe de SAME e DIFFERENT são definidos por cada formato.

## Comprimento

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

`N_len` é o número de WORDs da TAG estendida de Length, `N_id` o número de WORDs do registro LOCAL do Edge Id, e `N_subject` e `N_object` o número total de WORDs de cada registro. O cursor depois de ler Subject e Object deve coincidir exatamente com o fim do Edge.

## Exemplo (não normativo)

Edge Id `0008`, o Subject é LOCAL 1 e o Object é um [UTF8-LANGUAGE-TEXT](/pt/grammar/value/text/utf8-language-text/) de `Donald Trump` (en).

- O Edge Id é `0088 0008`, 2 WORDs.
- O Subject é `0088 0001`, 2 WORDs.
- O Object é idioma `08C6 656e` (BCP47 `en`) + texto de 12 bytes (par), então `UTF8-LANGUAGE-TEXT-EVEN` (`0x4A`), 9 WORDs no total. A TAG é `0C4A`.
- O Edge tem TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORDs, `LLLL=1101`. A TAG é `1680`.

```
1680 0088 0008 0088 0001 0C4A 08C6 656e 446f 6e61 6c64 2054 7275 6d70
```

## Páginas relacionadas

- [Edge](/pt/grammar/edge/), [SAME-NODE](/pt/grammar/edge/same-node/), [DIFFERENT-NODE](/pt/grammar/edge/different-node/), [LABEL](/pt/grammar/edge/label/)
- [Reference](/pt/grammar/reference/), [LOCAL](/pt/grammar/reference/local/), [UTF8-LANGUAGE-TEXT](/pt/grammar/value/text/utf8-language-text/)
