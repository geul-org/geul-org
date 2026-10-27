---
title: "Value — Binaire"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "Formats de la famille BINARY (Codec `0x60`~`0x7B`, numéros de format `0xC000`~`0xFFFF`) : UUID, digests, CRC, adresses réseau, suites d'octets inconnues, vecteurs de bits."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

La famille BINARY regroupe les formats de suites d'octets. Elle se place dans les codes directs `0x60`~`0x7B` et les numéros de format d'Issuer `0xC000`~`0xFFFF`.

- UUID, SHA-256 et SHA-1 sont des codes directs. Les autres digests, CRC32C, les adresses IPv4, IPv6 et MAC, les suites d'octets inconnues et les vecteurs de bits sont des formats d'Issuer.
- La taille des valeurs de taille fixe (UUID, digests, adresses) étant déterminée, on ne leur donne pas de paire pair/impair.
- Les médias publics comme images et vidéos se placent en formats BINARY de l'Issuer IANA (`0x0021`). Les numéros de format sont attribués par paires pair/impair et le Payload est une suite d'octets. Le plafond de Length est de 2^32−1 WORD. Pour les grosses valeurs, on recommande de les référencer par URI et SHA-256 plutôt que de les mettre directement.
- Une œuvre contenue dans une suite d'octets suit sa licence d'origine. La provenance et la licence se consignent par Meta.
