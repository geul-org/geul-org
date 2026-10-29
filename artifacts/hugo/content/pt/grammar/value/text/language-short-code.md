---
title: "LANGUAGE-SHORT-CODE"
weight: 73
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE é o Value de código de idioma do GEUL que comprime em 1 WORD apenas o primary language subtag (Codec 0x48)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-SHORT-CODE é o código de idioma comprimido do GEUL que contém apenas o primary language subtag, e não a tag BCP 47 inteira. O Payload é exatamente 1 WORD.

## Layout

- Código: código direto de Value `0x48`. Família TEXT.
- O Payload é exatamente 1 WORD, um código sem sinal de 16 bits.

```
TAG WORD          0x08C8 (0000 1000 1100 1000)  total de 2 WORD
Payload WORD 1st (16 bits)           GEUL language code (uint16)
```

## Interpretação e validade

- A 1 WORD do Payload é lida como inteiro sem sinal de 16 bits.
- Esse valor é o código comprimido do primary language subtag. Não contém script, region, variant, extension nem private-use. Quando essa informação é necessária, usa-se [LANGUAGE-BCP47-CODE](/pt/grammar/value/text/language-bcp47-code/) (`0x46`, `0x47`).
- `0x0000..0xfffe` é a faixa de atribuição do GEUL Language Registry. Mesmo dentro dessa faixa, um valor que não foi realmente atribuído na versão do registry correspondente é invalid.
- Os alvos da atribuição inicial são os registros públicos de `Type: language` de um snapshot determinado do IANA Language Subtag Registry, menos os de `Scope: private-use`. Não se excluem collections, macrolanguage nem special.
- A atribuição inicial ordena esses registros públicos pela ordem ASCII do subtag e lhes dá os IDs. A ordem física do arquivo da IANA não é regra de ID.
- Os novos subtags `Type: language` posteriores são acrescentados ao final, sem mudar os números existentes (append-only).
- O ID de um language subtag deprecated não se apaga nem se reutiliza. A relação de Preferred-Value e o estado de deprecated preservam-se nos metadados do registry.
- `0xffff` é reservado como escape de extensão. Até que se defina um formato de extensão à parte, é invalid em um Value LANGUAGE-SHORT-CODE independente. Não se usa com significados como `null`, `unknown` ou `und`.
- Outra especificação de Codec pode definir no futuro a regra de interpretação depois de `0xffff`. Mas isso não quer dizer que essa regra aumente o comprimento do Payload deste formato nem que admita um Payload que se segue.
- Uma especificação de Codec pode guardar o mesmo código de 1 WORD num campo de valor bruto, sem TAG (um [CODEC](/pt/grammar/codec-spec/#codec) no campo de valor bruto). Isso é uma regra dessa especificação de Codec, e a wire form de um Value independente é sempre 1 WORD de TAG + 1 WORD de Payload.
- Para julgar o significado do valor, deve-se preservar junto a versão do GEUL Language Registry usada e a data do snapshot do registry da IANA que essa versão fixou.

## Base normativa

- O registry de origem do primary language subtag e os metadados de deprecated/Preferred-Value seguem o [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- O significado básico do sistema de language subtags BCP 47 segue a [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- A atribuição de IDs append-only em ordem ASCII, a reserva de `0xffff` e a distinção do embutimento sem TAG num campo de valor bruto são regras do GEUL.

## Comprimento

- O total é exatamente 2 WORD, a soma de 1 WORD de TAG e 1 WORD de Payload, e usa o comprimento direto `LLLL=0001`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não for exatamente 1 WORD, rejeita-se.

## Exemplo

- Como o snapshot do registry e a tabela de códigos real ainda não foram definidos, não se apresenta um exemplo de ID numérico de nenhum idioma específico.

## Questões em aberto

- A data do snapshot inicial da IANA, o nome da versão do GEUL Language Registry e a tabela de mapeamento completa. Até serem definidos, não se confirmam exemplos numéricos concretos nem a tabela de códigos.
