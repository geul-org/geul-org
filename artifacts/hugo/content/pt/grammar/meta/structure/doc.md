---
title: "DOC"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "DOC-1WORD, DOC-2WORD e DOC-4WORD são Meta de estrutura que abrem o documento indicando o número total de WORDs do documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

É o registro que abre o documento. Indica no Payload o número total de WORDs do documento. `DOC-1WORD` (`0x00`), `DOC-2WORD` (`0x01`) e `DOC-4WORD` (`0x02`) são tratados juntos nesta página.

## Layout

```
TAG WORD          0001 1LLL L000 0000      Codec 0x00
[TAG estendida de Length]
Payload           número total de WORDs. O Codec determina a largura: DOC-1WORD 1, DOC-2WORD 2, DOC-4WORD 4
```

- Codec: Meta `0x00`~`0x02`, classe de estrutura (`000`)
- Payload: valor bruto (número total de WORDs do documento, sem sinal)
- Quantidade: um por documento, no início

## Interpretação e validade

- O comprimento vai do início do registro de abertura até o fim de [END](/pt/grammar/meta/structure/end/).
- Usa-se a menor largura em que o valor cabe. Codificar com uma largura maior é uma codificação não canônica e é rejeitada.
- O comprimento deve ser igual ao da entrada inteira. Um documento é uma entrada.
- O decodificador pode pular o documento inteiro por esse comprimento. Não há Codec que abra sem saber o comprimento.
- Ao calcular o hash de conteúdo, reescreve-se com o comprimento sem os Meta da classe de verificação e com a largura correspondente ([Hash de conteúdo](/pt/grammar/document/#hash-de-conteúdo)).

## Exemplo

- `0x1880 0x0017`: DOC-1WORD, 23 WORDs no total
