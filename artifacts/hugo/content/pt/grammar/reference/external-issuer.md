---
title: "EXTERNAL-ISSUER"
weight: 13
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-ISSUER é a Reference de indicação-declaração que cita, com um só registro e sem IMPORT, o LOCAL ID de um documento publicado por um Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-ISSUER é a Reference de indicação-declaração que cita, sem IMPORT, o LOCAL ID de um documento publicado por um Issuer. O significado se completa com um só registro e segue a versão mais recente.

## Layout

```
TAG WORD          0000 0LLL L11W WQQQ      CCCC = 11WW
[TAG estendida de Length]
Issuer            largura determinada por WW (00=1, 01=2, 10=4, 11=16 WORD)
ID do documento   4 WORD
ID do alvo        todo o restante. LOCAL ID desse documento, na menor largura
```

| CCCC | Nome | Largura do Issuer |
|---|---|---|
| `1100` | EXTERNAL-ISSUER-1WORD | 1 WORD (atribuído pelo geul.org) |
| `1101` | EXTERNAL-ISSUER-2WORD | 2 WORD (registro no geul.org, prova de domínio) |
| `1110` | EXTERNAL-ISSUER-4WORD | 4 WORD (registro no geul.org, sem prova) |
| `1111` | EXTERNAL-ISSUER-16WORD | 16 WORD (calculado a partir da chave pública) |

- O Issuer ID é um valor inteiro. Valores iguais são o mesmo Issuer. O Issuer é escrito na menor largura em que o valor cabe e escolhe-se o Codec dessa largura (2 WORD só se o valor passar de `0xFFFF`, 4 WORD só se for `2^32` ou mais, 16 WORD só se for `2^64` ou mais). A notação em largura maior é invalid ([Issuer](/pt/grammar/issuer/)).
- O registro e a gestão dos Issuers ficam a cargo do geul.org.
- A versão não é escrita e segue a mais recente. Para fixar a versão, usam-se [IMPORT-DOC](/pt/grammar/meta/import/import-doc/) e [EXTERNAL-POINTER](/pt/grammar/reference/external-pointer/).
- A localização é achada pelas regras do endereço de publicação ([Endereço de publicação e lista de versões](/pt/grammar/publishing/)).
- Com o mesmo LOCAL ID desse documento, é o mesmo alvo, quer seja usado como LOCAL dentro desse documento, quer como EXTERNAL-ISSUER em outro documento (ou como EXTERNAL-POINTER depois de um IMPORT).
- Aponta apenas para o LOCAL de um documento. O próprio documento é apontado por [DOC-POINTER](/pt/grammar/reference/doc-pointer/) e o próprio Issuer por [ISSUER-POINTER](/pt/grammar/reference/issuer-pointer/). Por isso o ID de alvo não é `0`. O ID de documento `0` é o documento de índice de definição de termos do Issuer.

## Validade

- Se a largura do Issuer não casar com o Codec, ou se o valor couber numa largura menor, é invalid.
- Se o ID de alvo for `0`, é invalid. O ID de alvo `0` (o próprio documento) fica a cargo do DOC-POINTER.
- Proíbe-se WORD `0x0000` à frente no ID do alvo.

## Exemplo

| Alvo | Sequência de WORDs |
|---|---|
| Issuer `0x0001`, documento `0x…0002`, LOCAL 7 | `0360 0001 0000 0000 0000 0002 0007` |
| Issuer `0x00012345`, documento `0x…0002`, LOCAL 7 | `03E8 0001 2345 0000 0000 0000 0002 0007` |

## Páginas relacionadas

- [Reference](/pt/grammar/reference/), [DOC-POINTER](/pt/grammar/reference/doc-pointer/), [ISSUER-POINTER](/pt/grammar/reference/issuer-pointer/), [EXTERNAL-POINTER](/pt/grammar/reference/external-pointer/)
- [Issuer e publicação](/pt/grammar/issuer/)
