---
title: "MAC-48-ADDRESS"
weight: 1031
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "MAC-48-ADDRESS é um Value de largura fixa que guarda um valor de endereço MAC IEEE 802 de 48 bits."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

MAC-48-ADDRESS é um Value de largura fixa que guarda um valor de endereço MAC IEEE 802 de 48 bits. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000D` IEEE, número do Codec `0x0000C000`, família BINARY. O Payload tem exatamente 3 WORD (6 octetos, 48 bits).

## Layout {#레이아웃}

```
TAG WORD          0x09D7 (0000 1001 1101 0111)  total de 8 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Número do Codec   2 WORD  0x0000C000
Payload           3 WORD  octet 0 → 1 │ octet 2 → 3 │ octet 4 → 5
```

## Interpretação e validade {#해석과-유효성}

- Os seis octetos do endereço MAC de 48 bits mantêm a ordem de octetos da notação em cadeia de caracteres e da transmissão na LAN. Os octetos 0–1, 2–3 e 4–5 são agrupados, cada par num WORD, do octeto superior para o inferior.
- Nos meios IEEE 802, o least-significant bit de cada octeto é transmitido primeiro, mas, por isso, não se invertem os bits dentro do octeto. I/G e U/L permanecem no least-significant bit do octeto 0 e no bit seguinte.
- I/G=0 é um endereço individual, usado como unicast no destino; I/G=1 é um endereço de grupo, usado como multicast ou broadcast. U/L=0 é um endereço universally administered; U/L=1 é um endereço locally administered.
- Nenhum pattern é excluído estruturalmente por causa dos valores de I/G ou U/L. Representam-se tanto endereços universally/locally administered como individuais/de grupo, e também endereços MAC locally administered, randomized, spoofed ou virtuais podem ser expressos como um valor de 48 bits.
- Este valor preserva apenas os 48 bits do endereço observado ou apresentado. Não garante o endereço permanente de um dispositivo específico, a unicidade global, a autenticação de dispositivo ou de usuário, a propriedade, nem a vinculação contínua ao mesmo dispositivo.
- Este formato trata apenas de endereços MAC IEEE 802 de exatamente 48 bits. Não guarda EUI-64 nem outros endereços MAC de 64 bits. A IEEE RA descreve o termo histórico `MAC-48` como obsolete, mas nem todo endereço MAC de 48 bits pode ser chamado de EUI-48; portanto, este formato não é identificado automaticamente com o EUI-48.
- Se o Payload não tiver exatamente 3 WORD, rejeita-se.

## Base normativa {#표준-근거}

- O [Standard Group MAC Addresses](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/macgrp.pdf) da IEEE Registration Authority notaciona o endereço MAC de LAN de 48 bits como seis octetos em ordem de transmissão e explica que cada octeto é transmitido a partir do least-significant bit e que I/G e U/L são os dois least-significant bits do primeiro octeto. Este formato preserva as posições de octeto e de bit tal qual.
- O [Guidelines for Use of EUI, OUI, and CID](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/eui.pdf) da IEEE Registration Authority define I/G=0/1 como individual/group e U/L=0/1 como universal/local administration, e explica que um endereço local não é globalmente único. Explica também a relação e a diferença terminológica histórica entre `MAC-48` e EUI-48.
- O [IEEE SA — MAC Addresses](https://standards.ieee.org/products-programs/regauth/mac/) explica que EUI-48 e EUI-64 podem ser usados como endereços MAC, entre outros usos. Isso não significa que um EUI-64 seja colocado neste registro de 48 bits.
- O [RFC 9724 — State of Affairs for Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9724.html) e o [RFC 9797 — Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9797.html) registram que dispositivos reais podem gerar e trocar aleatoriamente endereços MAC locally administered. Por isso, não se infere uma identity permanente de dispositivo apenas pelo valor MAC.
- A TAG do GEUL, a atribuição de Issuer, o Length direto e o enquadramento em WORD de 16 bits não fazem parte do IEEE 802 nem das fontes acima, mas são regras que este formato acrescenta.

## Comprimento {#길이}

- O total é exatamente 8 WORD, somando TAG 1 WORD, Issuer 2 WORD, número do Codec 2 WORD e Payload 3 WORD, e usa-se o comprimento direto `LLLL=0111`. Não há TAG estendida de Length, descriptor nem padding.
- Se o Payload não tiver exatamente 3 WORD, rejeita-se.

## Exemplo {#예시}

Endereço individual (unicast) locally administered `02:00:5e:10:00:00` (I/G=0 e U/L=1 do primeiro octeto `0x02`):

```
09D7 0000 000D 0000 C000 0200 5E10 0000
```
