---
title: "Value — Binär"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "Die Formate der BINARY-Familie (Codec `0x60`~`0x7B`, Formatnummern `0xC000`~`0xFFFF`): UUID, Digests, CRC, Netzwerkadressen, Bytefolge unbekannter Art, Bitvektor."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Die BINARY-Familie umfasst Bytefolgen-Formate. Sie liegen bei den direkten Codes `0x60`~`0x7B` und den Issuer-Formatnummern `0xC000`~`0xFFFF`.

- UUID, SHA-256 und SHA-1 sind direkte Codes. Die übrigen Digests, CRC32C, IPv4-, IPv6- und MAC-Adressen, Bytefolge unbekannter Art und Bitvektor sind Issuer-Formate.
- Werte fester Größe (UUID, Digests, Adressen) haben eine festgelegte Größe und erhalten daher kein Paar aus gerade/ungerade.
- Öffentliche Medien wie Bilder und Videos liegen als BINARY-Formate des IANA-Issuers (`0x0021`) vor. Die Formatnummern werden als Paare aus gerade/ungerade vergeben, und der Payload ist eine Bytefolge. Die Obergrenze der Length beträgt 2^32−1 WORD. Große Werte referenziert man besser über URI und SHA-256, statt sie direkt einzufügen.
- Werke in einer Bytefolge folgen ihrer ursprünglichen Lizenz. Quelle und Lizenz werden als Meta festgehalten.
