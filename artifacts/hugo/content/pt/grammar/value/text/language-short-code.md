---
title: "LANGUAGE-SHORT-CODE"
weight: 73
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE é um Value de código de idioma do GEUL que contém em 1 WORD uma tag BCP 47 numerada pelo GEUL Language Registry (Codec 0x48). O registry são os ENUM do documento de especificação deste Codec."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-SHORT-CODE é um código de idioma comprimido do GEUL que contém em 1 WORD uma tag BCP 47 que tem número no GEUL Language Registry. O Payload é exatamente 1 WORD.

## Layout

- Código: código direto de Value `0x48`. Família TEXT.
- O Payload é exatamente 1 WORD, um código unsigned de 16 bits.

```
TAG WORD          0x08C8 (0000 1000 1100 1000)  2 WORD no total
Payload WORD 1st (16 bits)           número do GEUL Language Registry (uint16)
```

## Interpretação e validade

- O WORD do Payload é lido como inteiro unsigned de 16 bits.
- Este valor é uma tag atribuída pelo GEUL Language Registry. A forma normativa do registry é o documento de especificação deste Codec, `0x0000/0x0000000000000848`. Cada valor de código tem um [ENUM](/pt/grammar/edge/enum/) no FIELD `code`, e o nome ligado por [BIND](/pt/grammar/edge/bind/) ao Edge Id desse ENUM é a tag BCP 47 em caixa canônica.
- O registry é uma lista fechada. Um valor sem ENUM no documento de especificação é invalid. Esta regra do Codec prevalece sobre a regra geral de ENUM ("um valor de código não declarado não é erro").
- São atribuídos três tipos de tag.
  - Os registros `Type: language` do IANA Language Subtag Registry, exceto `Scope: private-use` (`qaa..qtz`). Não se excluem collection, macrolanguage nem special (`mul`, `und`, `zxx`, `mis`).
  - As tags que a IANA registra inteiras: grandfathered e redundant (`zh-Hans`, `sr-Latn`, `zh-min-nan` etc.).
  - As tags combinadas válidas observadas em fontes públicas CC0 (`pt-BR`, `en-GB`, `be-tarask` etc.). Consistem apenas de subtags language, extlang, script, region e variant. Tags com extension (`-u-`, `-t-`) ou private-use (`-x-`) não são aceitas.
- Uma tag sem número não pode ser escrita neste formato. Escreve-se como [LANGUAGE-BCP47-CODE](/pt/grammar/value/text/language-bcp47-code/) (`0x46`, `0x47`). O SHORT-CODE não tem caminho de escape.
- `0x0000` e `0xffff` nunca são atribuídos. Ambos são invalid neste Value. Nenhum é usado com o sentido de `null`, `unknown` ou `und`.
- As faixas de valores são uma convenção de atribuição. O decodificador não deduz o tipo de tag pela faixa do valor. O significado de um valor vem apenas do documento de especificação.

| Faixa | Uso |
|---|---|
| `0x0000` | Nunca atribuído (invalid) |
| `0x0001`–`0x3fff` | Tags de um único language subtag |
| `0x4000`–`0x7fff` | Tags de dois ou mais subtags (tags inteiras da IANA, tags combinadas observadas) |
| `0x8000`–`0xfffe` | Transbordo. Quando um bloco acima enche, a atribuição continua aqui |
| `0xffff` | Nunca atribuído (invalid) |

- A edição inicial numera as tags dentro de cada bloco em ordem ASCII minúscula. No bloco `0x4000` vêm primeiro as tags inteiras da IANA (grandfathered e redundant misturadas, em ordem ASCII) e depois as tags combinadas observadas (em ordem ASCII). Nem a ordem física do arquivo da IANA nem a frequência de uso são regras de numeração.
- A atribuição só acrescenta (append-only). Uma tag nova é acrescentada ao fim do seu bloco e, se o bloco estiver cheio, na faixa de transbordo. A tag (sem distinguir maiúsculas) de um número já dado não é alterada, apagada nem reutilizada.
- Uma tag nova entra acrescentando um ENUM e um BIND numa nova versão do documento de especificação. ENUM e BIND existentes não são modificados. Por isso toda versão é um superconjunto da anterior.
- Quando os 65.534 números se esgotam, não se atribuem mais. Tags novas posteriores são escritas como LANGUAGE-BCP47-CODE. A expressividade não diminui; só se perde o ganho de compressão.
- Mesmo idioma: o SHORT-CODE `n` e o LANGUAGE-BCP47-CODE da tag que o registry liga a `n` (sem distinguir maiúsculas) são o mesmo idioma.
- Uma edição do registry é uma versão do documento de especificação. Cada edição registra o arquivo do registry da IANA em que se baseia (File-Date, SHA-256) como [SOURCE](/pt/grammar/edge/source/) no HEAD do documento de especificação. Quando for preciso indicar a edição usada para interpretar um valor, guarda-se essa versão (`0x0000/0x0000000000000848@n`) junto.
- Uma especificação de Codec pode conter o mesmo código de 1 WORD num campo de valor bruto sem TAG ([CODEC](/pt/grammar/codec-spec/#codec) de campo de valor bruto). Isso é regra dessa especificação de Codec; a wire form de um Value independente é sempre TAG 1 WORD + Payload 1 WORD.

## Base normativa

- O significado das tags e a validade dos subtags seguem o [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry) e a [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646). A IANA e o IETF colocam seus direitos sobre os registries de protocolo sob CC0 1.0 ([IANA Licensing Terms](https://www.iana.org/help/licensing-terms)).
- Os números do registry (atribuição append-only em ordem ASCII, composição dos blocos, `0x0000` e `0xffff` não atribuídos, lista fechada), o fato de os ENUM do documento de especificação serem a forma normativa e a distinção em relação ao embedding sem TAG num campo de valor bruto são regras do GEUL.

## Comprimento

- O total é exatamente 2 WORD, TAG 1 WORD mais Payload 1 WORD, com comprimento direto `LLLL=0001`. Não há TAG de extensão de Length, descriptor nem padding.
- Se o Payload não tiver exatamente 1 WORD, rejeita-se.

## Exemplo

Números do registry v2 (documento de especificação `0x0000/0x0000000000000848` versão 2, IANA File-Date 2026-09-17). Atribui 8.678 tags (language 8.275, grandfathered 26, redundant 67, combinadas observadas 310).

| tag | Código | WORD completos |
|---|---|---|
| `en` | `0x0784` | `08C8 0784` |
| `ko` | `0x0d06` | `08C8 0D06` |
| `zh-Hans` | `0x404c` | `08C8 404C` |
| `pt-BR` | `0x4130` | `08C8 4130` |

- No documento de especificação, `en` é `ENUM #2 0x0784` e o `BIND "en"` no seu Edge Id.
- `de-x-formal` (private-use) e `nl-u-sd-bebru` (extension) não têm número, por isso são escritos como LANGUAGE-BCP47-CODE.

## Questões em aberto

- Leitura entre edições: se um número mais novo que a edição do leitor é descartado como invalid ou guardado com o valor bruto como "código desconhecido". Por ser append-only, a última edição sempre basta, mas decodificadores offline precisam de uma regra.
- Forma canônica: se uma tag com número deve (SHOULD/MUST) ser escrita como SHORT-CODE. Com MUST a grafia fica única, mas uma nova edição tornaria não canônicos os documentos escritos antes.
- Como exprimir tags deprecated e Preferred-Value no documento de especificação (a edição atual não as tem).
- O procedimento para acrescentar tags combinadas observadas (fontes, limiar de observação).

## Páginas relacionadas

- [LANGUAGE-BCP47-CODE](/pt/grammar/value/text/language-bcp47-code/), [UTF8-LANGUAGE-TEXT](/pt/grammar/value/text/utf8-language-text/), [LABEL](/pt/grammar/edge/label/)
- [Documento de especificação de Codec](/pt/grammar/codec-spec/), [ENUM](/pt/grammar/edge/enum/), [BIND](/pt/grammar/edge/bind/), [SOURCE](/pt/grammar/edge/source/)
