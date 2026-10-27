---
title: "MAC-48-ADDRESS"
weight: 1007
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "MAC-48-ADDRESS é um formato fixo de 6 WORD do Issuer IEEE que contém um endereço MAC IEEE 802 de 48 bits na ordem dos octetos."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

MAC-48-ADDRESS é o Value de largura fixa que contém o valor de um endereço MAC IEEE 802 de 48 bits. É `ISSUER-1WORD` (`0x7C`) de Value, Issuer `0x0040` IEEE, número de formato `0xC000`, família BINARY. O Payload tem exatamente 3 WORD (6 octetos, 48 bits).

## Layout

```
TAG WORD          0x0AFC (0000 1010 1111 1100)  total de 6 WORD
Issuer            1 WORD  0x0040 (IEEE)
Número de formato 1 WORD  0xC000
Payload           3 WORD  octet 0 → 1 │ octet 2 → 3 │ octet 4 → 5
```

## Interpretação e validade

- Os seis octetos do endereço MAC de 48 bits ficam na mesma ordem de octetos da notação em cadeia e da transmissão na LAN. Os octetos 0–1, 2–3 e 4–5 agrupam-se, cada par, em uma WORD, do octeto superior ao inferior.
- Nos meios IEEE 802, o bit menos significativo de cada octeto é transmitido primeiro, mas, por isso, não se invertem os bits dentro do octeto. O I/G e o U/L permanecem no bit menos significativo do octeto 0 e no bit seguinte.
- I/G=0 é um endereço individual, usado como unicast no destino, e I/G=1 é um endereço de grupo, usado como multicast ou broadcast. U/L=0 é um endereço universally administered e U/L=1 é um endereço locally administered.
- Nenhum padrão é excluído estruturalmente por causa do valor de I/G ou U/L. Representa tanto endereços universally/locally administered como individual/group, e também endereços MAC locally administered, randomized, spoofed e virtuais podem ser representados como valor de 48 bits.
- Este valor só preserva os 48 bits do endereço observado ou apresentado. Não garante o endereço permanente de um dispositivo específico, a unicidade mundial, a autenticação de dispositivo ou usuário, a propriedade nem a ligação contínua com o mesmo dispositivo.
- Este formato só trata endereços MAC IEEE 802 de exatamente 48 bits. Não contém EUI-64 nem outros endereços MAC de 64 bits. A IEEE RA descreve o termo histórico `MAC-48` como obsoleto, mas nem todo endereço MAC de 48 bits pode ser chamado EUI-48, por isso este formato não se equipara automaticamente a EUI-48.
- Se o Payload não for exatamente 3 WORD, rejeita-se.

## Base normativa

- O [Standard Group MAC Addresses](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/macgrp.pdf) da IEEE Registration Authority escreve o endereço MAC de LAN de 48 bits como seis octetos na ordem de transmissão e explica que cada octeto é transmitido a partir do bit menos significativo e que I/G e U/L são os dois bits menos significativos do primeiro octeto. Este formato preserva tal como estão os octetos e as posições dos bits.
- O [Guidelines for Use of EUI, OUI, and CID](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/eui.pdf) da IEEE Registration Authority define I/G=0/1 como individual/group e U/L=0/1 como universal/local administration, e explica que os endereços locais não são globalmente únicos. Explica também a relação e a diferença histórica entre os termos `MAC-48` e EUI-48.
- O [IEEE SA — MAC Addresses](https://standards.ieee.org/products-programs/regauth/mac/) explica que EUI-48 e EUI-64 podem ser usados como endereços MAC e similares. Isso não quer dizer que se ponha EUI-64 neste registro de 48 bits.
- A [RFC 9724 — State of Affairs for Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9724.html) e a [RFC 9797 — Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9797.html) registram que dispositivos reais podem gerar e trocar aleatoriamente endereços MAC locally administered. Por isso não se infere uma identity permanente de dispositivo só pelo valor do MAC.
- A TAG do GEUL, a atribuição do Issuer, o Length direto e o framing de WORD de 16 bits não fazem parte do IEEE 802 nem dos materiais acima, e sim regras que este formato acrescenta.

## Comprimento

- O total é exatamente 6 WORD, a soma de 1 WORD de TAG, 1 WORD de Issuer, 1 WORD de número de formato e 3 WORD de Payload, e usa o comprimento direto `LLLL=0101`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não for exatamente 3 WORD, rejeita-se.

## Exemplo

Endereço locally administered individual (unicast) `02:00:5e:10:00:00` (I/G=0, U/L=1 do primeiro octeto `0x02`):

```
0afc 0040 c000 0200 5e10 0000
```
