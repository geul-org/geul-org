---
title: "DOC-POINTER"
weight: 8
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "DOC-POINTER é a Reference de indicação-declaração que aponta para uma versão de um documento publicado por um Issuer. O ID de versão 0 é a versão mais recente."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DOC-POINTER é a Reference de indicação-declaração que aponta para uma versão de um documento publicado por um Issuer. É o alvo da publicação, da deprecação e da exclusão de documentos, da edição citada e das descrições sobre o documento.

## Layout

```
TAG WORD          0000 0LLL L011 1QQQ      CCCC = 0111
[TAG estendida de Length]
Issuer            1/2/4/16 WORD
ID do documento   4 WORD
ID da versão      2 WORD
```

## Interpretação e validade

- A largura do Issuer é o que sobra do Payload depois de tirar as 6 WORDs do ID do documento e do ID da versão. O Codec não divide a largura. Se a largura não for 1, 2, 4 ou 16 WORD, ou se o valor do Issuer couber numa largura menor, é invalid (forma canônica do Issuer).
- O ID da versão não se omite. Se se permitisse omiti-lo, o comprimento do Payload não bastaria para decidir a largura do Issuer (Issuer de 4 WORD sem versão e Issuer de 2 WORD com versão dariam as mesmas 8 WORD).
- O ID de versão `0` é a versão mais recente. Fica vinculado à versão vigente no momento da interpretação. Os demais valores fixam nessa versão ([PUBLICATION](/pt/grammar/edge/publication/)).
- O ID de documento `0` é o documento de índice de definição de termos do Issuer. O próprio Issuer é apontado por [ISSUER-POINTER](/pt/grammar/reference/issuer-pointer/).
- Usa-se apenas o Quantifier `000` (Identified). Qualquer outro valor é invalid.
- O formato que aponta para o documento de um Issuer é só o DOC-POINTER. Apontar para um documento com `EXTERNAL-ISSUER-*` (Issuer, ID do documento, ID de alvo `0`) ou `EXTERNAL-POINTER-*` (IMPORT ID, ID de alvo `0`) é invalid.
- Onde se usa: Meta [DOC-ID](/pt/grammar/meta/declaration/doc-id/) e [IMPORT-DOC](/pt/grammar/meta/import/import-doc/), PUBLICATION, DEPRECATION, TOMBSTONE e o Subject de BIND da lista de versões, e o Subject de BIND do índice de nomes `documents.geul`.

## Exemplo

No Issuer GEUL `0x0000`, o documento `0xffff000000000001`.

| Versão | Sequência de WORDs |
|---|---|
| 1 | `03B8 0000 ffff 0000 0000 0001 0000 0001` |
| mais recente (`0`) | `03B8 0000 ffff 0000 0000 0001 0000 0000` |

- TAG 1 + Issuer 1 + ID do documento 4 + ID da versão 2 = 8 WORDs, `LLLL=0111`. A TAG é `0000 0 0111 0111 000` = `03B8`.

## Páginas relacionadas

- [Reference](/pt/grammar/reference/), [ISSUER-POINTER](/pt/grammar/reference/issuer-pointer/), [EXTERNAL-ISSUER](/pt/grammar/reference/external-issuer/), [PUBLICATION](/pt/grammar/edge/publication/)
- [Issuer e publicação](/pt/grammar/issuer/)
