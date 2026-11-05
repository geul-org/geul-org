---
title: "TAI-TIMESTAMP-NANOSECONDS"
weight: 1021
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "TAI-TIMESTAMP-NANOSECONDS est le nombre de nanosecondes signé depuis le même epoch TAI, `1970-01-01T00:00:00 TAI`. Cette représentation en count cumulatif n'est pas un wire format standard du BIPM : c'est un profil propre à GEUL qui fait correspondre l'échelle de temps TAI à un int64 signé de largeur fixe."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---


TAI-TIMESTAMP-NANOSECONDS est le nombre de nanosecondes signé depuis le même epoch TAI, `1970-01-01T00:00:00 TAI`. Cette représentation en count cumulatif n'est pas un wire format standard du BIPM : c'est un profil propre à GEUL qui fait correspondre l'échelle de temps TAI à un int64 signé de largeur fixe.

## Disposition {#레이아웃}

- Code : Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000013` BIPM, numéro de Codec `0x00004001`. Famille TIME.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  9 WORD au total
Issuer            2 WORD  0x00000013 (BIPM)
Numéro de Codec   2 WORD  0x00004001
Payload WORD 1er (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2ème (bits 47..32)    Signed Nanoseconds
Payload WORD 3ème (bits 31..16)    Signed Nanoseconds
Payload WORD 4ème (bits 15..0)     Signed Nanoseconds low 16bit
```

## Interprétation et validité {#해석과-유효성}

- Les 4 WORD du Payload sont lus ensemble comme un signed count en complément à deux de 64 bits, en ordre de WORD big-endian.
- La plage valide est de `-2^63` à `2^63-1` ns. Une valeur négative est un instant TAI antérieur à l'epoch fixé par GEUL.
- Même une petite valeur utilise toujours 4 WORD. Ni offset UTC ni table de leap seconds ne sont stockés.

## Length {#길이}

- Le total est de 9 WORD exactement : TAG 1 WORD, Issuer 2 WORD, numéro de Codec 2 WORD et Payload 4 WORD ; on utilise la longueur directe `LLLL=1000`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni padding.
- Si le Payload ne fait pas exactement 4 WORD, on rejette.

## Exemple {#예시}

- L'epoch TAI de GEUL est le Payload `0000 0000 0000 0000`, 9 WORD au total, `LLLL=1000`.
- 1 ns après l'epoch est le Payload `0000 0000 0000 0001`.
- 1 ns avant l'epoch est le Payload `FFFF FFFF FFFF FFFF`.

## Référence normative et statut du format {#표준-근거와-형식-지위}

- La [SI Brochure du BIPM, 9th edition](https://www.bipm.org/documents/20126/41483022/SI-Brochure-9-EN.pdf/2d2b50bf-f2b4-9661-f402-5f9d66e4b507?version=1.10) définit la seconde du SI et l'échelle de temps du Temps atomique international (TAI).
- Le BIPM ne définit ni un count cumulatif de nanosecondes en int64 signé depuis l'epoch `1970-01-01 TAI`, ni son wire encoding. L'epoch, le count par unité, l'int64 signé et la disposition en WORD big-endian de GEUL sont une correspondance propre à GEUL.
- L'int64 de largeur fixe a été choisi pour la cohérence d'échange avec les autres profils de count TIME ; cela ne signifie pas que le format du BIPM est reproduit tel quel.
