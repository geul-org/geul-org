---
title: "Value — binario"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "Formatos de la familia BINARY (Codec `0x60`~`0x7B`, número de formato `0xC000`~`0xFFFF`): UUID, digests, CRC, direcciones de red, bytes desconocidos y vectores de bits."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
La familia BINARY son formatos de bytes. Se colocan en los códigos directos `0x60`~`0x7B` y en los números de formato Issuer `0xC000`~`0xFFFF`.

- UUID, SHA-256 y SHA-1 son códigos directos. Los demás digests, CRC32C, las direcciones IPv4·IPv6·MAC, los bytes desconocidos y los vectores de bits son formatos Issuer.
- Los valores de tamaño fijo (UUID, digests, direcciones) tienen el tamaño determinado, así que no tienen pares par/impar.
- Los medios públicos, como imágenes y vídeo, se colocan como formatos BINARY del Issuer IANA (`0x0021`). Los números de formato se asignan en pares par/impar y el Payload son bytes. El límite superior de Length es 2^32−1 WORD. Para valores grandes se recomienda referenciarlos con URI y SHA-256 en lugar de incluirlos directamente.
- Las obras contenidas en los bytes siguen su licencia original. La procedencia y la licencia se registran con Meta.
