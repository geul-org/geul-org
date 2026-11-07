---
title: "TOKEN-0·TOKEN-1 (0x043L·0x044L)"
weight: 67
date: 2026-11-07T12:00:00+09:00
lastmod: 2026-11-07T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "TOKEN é uma Reference de 2 WORD que aponta uma entrada do vocabulário de tokens do GEUL. Juntando os bytes dos registros TOKEN consecutivos, obtém-se o texto original."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | TOKEN-0 | TOKEN-1 |
|---|---|---|
| Nome | `TOKEN-0` (BIND `TOKEN-0` do documento de especificação) | `TOKEN-1` (BIND `TOKEN-1` do documento de especificação) |
| TAG ID | `0x043L` | `0x044L` |
| Codec ID | `0x00000430` | `0x00000440` |
| Documento de especificação | `0x00000000/codecs/0x00000430/` (alvo do DECLARE `0430`) | `0x00000000/codecs/0x00000440/` (alvo do DECLARE `0440`) |
| Seção | 2 `0010` (Reference diversas), deslocamento C na seção = 3 | 2 `0010`, C = 4 |
| Kind | Reference · classificação: declaração | Reference · classificação: declaração |
| TAG WORD | `0000 0100 0011 LLLL` | `0000 0100 0100 LLLL` |
| ID do token | `0`~`65.535` | `65.536`~`131.071` |
| Lado Hugo | `reference/token.md` | `reference/token.md` |

## Campos (documento de especificação) {#필드-규격-문서}

A ordem dos FIELD no documento é a ordem dos campos do Payload ([Documento de especificação de Codec](../codec-spec.md)).

| Ordem | Campo (BIND) | FIELD | Largura | Formato recebido (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | valor bruto de 1 WORD |  | Um por token. Preenchido ao publicar a edição 1 do vocabulário |

TOKEN é uma Reference que aponta uma entrada do vocabulário de tokens do GEUL. O vocabulário é um vocabulário BPE (Byte Pair Encoding) treinado em coreano e inglês, e uma entrada é uma sequência de bytes. Juntando em ordem as sequências de bytes dos registros TOKEN consecutivos, obtêm-se os bytes do texto original.

- Se o vocabulário couber em 65.536 entradas, usa-se apenas TOKEN-0. Se crescer além disso, as entradas excedentes ficam em TOKEN-1. Mesmo sem usar TOKEN-1, o nome do primeiro Codec é TOKEN-0.
- Cada token é escrito como um registro. Como o tamanho é fixo em 2 WORD, o k-ésimo registro de uma sequência de tokens está a 4k bytes do início.

## Layout {#레이아웃}

```
TAG WORD          0x0431 (0000 0100 0011 0001)  TOKEN-0, 2 WORDs no total
Payload WORD 1st (16 bits)           ID do token (uint16)

TAG WORD          0x0441 (0000 0100 0100 0001)  TOKEN-1, 2 WORDs no total
Payload WORD 1st (16 bits)           ID do token − 65.536 (uint16)
```

- Código: códigos diretos de Reference `0x043L`·`0x044L` (seção 2).
- O Payload é o ID do alvo. Conforme o [layout comum de Reference](_index.md), é um inteiro sem sinal big-endian escrito na menor largura, e, como o ID do alvo é sempre `0`~`65.535`, o Payload é sempre 1 WORD (`0` é `0x0000`).
- Não há quantificação (a quantificação só é lida no sistema 5Q).

## Interpretação e validade {#해석과-유효성}

- O ID do alvo de cada Codec é o valor do Payload. O ID do token em todo o vocabulário é o ID do alvo em TOKEN-0, e 65.536 + o ID do alvo em TOKEN-1.
- A representação oficial de um token é o documento de especificação do seu Codec. Para cada ID de token há um [ENUM](../edge/0x0BDL-enum.md) no FIELD `code`, e o nome ligado por [BIND](../edge/0x0A3L-bind.md) a esse Edge Id do ENUM é a sequência de bytes do token. O valor de código ENUM de TOKEN-1 é o valor do Payload (ID do token − 65.536).
- O vocabulário é uma lista fechada. Um ID de token sem ENUM no documento de especificação é invalid. Esta regra do Codec prevalece sobre a regra geral de ENUM (“um valor de código não declarado não é erro”).
- **Tokens de byte:** Os IDs de token `0`~`255` são um único byte. O ID do token é o próprio valor do byte. Um caractere que não está no vocabulário, como os que não são coreanos nem ingleses, tem seus bytes UTF-8 escritos como tokens de byte. O nome BIND de um token de byte é o nome de máquina `<0x00>`~`<0xFF>`, e o significado é definido por esta regra.
- **Demais tokens:** A sequência de bytes é UTF-8 válido, e o nome BIND é essa sequência de bytes tal como está.
- **Decodificação:** Lê-se a sequência de registros TOKEN desde o início e juntam-se as sequências de bytes de cada token. Os caracteres UTF-8 formados por tokens de byte consecutivos também são restaurados por essa junção. O resultado é idêntico, byte a byte, ao texto antes da codificação.
- **Codificação:** O modo de dividir o texto em uma sequência de tokens (a regra de divisão e a ordem de fusão) depende da edição do vocabulário. O mesmo texto pode dar uma sequência de tokens diferente em outra edição do vocabulário. O resultado da decodificação é o mesmo, independentemente da edição.
- **Edição:** A edição do vocabulário é a versão do documento de especificação. Cada edição registra os hashes do arquivo de vocabulário e do registro de treinamento como [SOURCE](../edge/0x0C0L-source.md) no HEAD do documento de especificação. Quando for preciso indicar a edição que gerou uma sequência de tokens, deixa-se junto essa versão ([CODEC-POINTER](0x042L-codec-pointer.md) (`0x00000000`, `0x00000430`, ID de versão `n`)).
- **Somente acréscimo:** Uma nova edição apenas acrescenta ENUM e BIND no fim. A sequência de bytes de um ID de token já atribuído não é alterada, apagada nem reescrita. Assim, toda edição é um superconjunto da anterior, e uma sequência de tokens feita com uma edição anterior é decodificada da mesma forma por uma posterior. Se o vocabulário for treinado de novo desde o início e os significados mudarem, não se usa este Codec; recebe-se um novo número de Codec.
- Como um token é uma Reference, ele pode ser sujeito de [BIND](../edge/0x0A3L-bind.md), [LABEL](../edge/0x0A4L-label.md) e [TRIPLE](../edge/0x0AAL-triple.md) (por exemplo, a frequência de ocorrência de um token, o idioma).

## Comprimento {#길이}

- O total é exatamente 2 WORDs, 1 WORD de TAG mais 1 WORD de Payload, e usa o comprimento direto `LLLL=0001`. Não há TAG de extensão de Length, TAG de extensão de Codec nem TAG específica do Codec.
- Se o Payload não for exatamente 1 WORD, o registro é rejeitado.

## Exemplo {#예시}

Antes de a edição 1 do vocabulário ser publicada, os tokens comuns ainda não têm número. Os tokens de byte têm número definido pela regra.

| Token | ID do token | WORDs completos |
|---|---|---|
| byte `0xE3` | `227` | `0431 00E3` |
| byte `0x80` | `128` | `0431 0080` |

## Problemas em aberto {#열린-문제}

- Publicação da edição 1 do vocabulário. Concluídos o treinamento e a verificação, preenchem-se ENUM e BIND no documento de especificação.
- Formato para pôr uma sequência de tokens no documento. Não se decidiu qual campo de Edge ou de Value recebe uma sequência de registros TOKEN.
- Forma canônica da codificação. Como escrever no documento de especificação a regra de divisão e a ordem de fusão, e se se fixa uma única sequência de tokens para o mesmo texto.
- Interpretação entre edições. Quando o leitor encontra um ID de token mais novo que a edição que possui, se o descarta como invalid ou preserva o valor original e o trata como “token desconhecido”.

## Páginas relacionadas {#관련-페이지}

- [Reference](_index.md), [CODEC-POINTER](0x042L-codec-pointer.md)
- [Documento de especificação de Codec](../codec-spec.md), [ENUM](../edge/0x0BDL-enum.md), [BIND](../edge/0x0A3L-bind.md), [SOURCE](../edge/0x0C0L-source.md)
- Registro da mesma forma: [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md)

## Texto original do documento de especificação {#규격-문서-원문}

O documento de especificação `0x00000000/codecs/0x00000430/` será publicado junto com a edição 1 do vocabulário. Ainda não foi publicado. A forma é a seguinte (para explicação).

```
BODY
#1 DECLARE 0x0430
#2 FIELD #1 0x0001
#3 BIND #1 "TOKEN-0"
#4 BIND #2 "code"
#5 ENUM #2 0x0000
#6 BIND #5 "<0x00>"
…
```
