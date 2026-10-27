---
title: "DOC"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "DOC-1WORD, DOC-2WORD und DOC-4WORD sind Struktur-Meta, die ein Dokument unter Angabe der Gesamtzahl der WORD öffnen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Der Record, der ein Dokument öffnet. Im Payload steht die Gesamtzahl der WORD des Dokuments. Diese Seite behandelt `DOC-1WORD` (`0x00`), `DOC-2WORD` (`0x01`) und `DOC-4WORD` (`0x02`) gemeinsam.

## Layout

```
TAG WORD          0001 1LLL L000 0000      Codec 0x00
[Length-Erweiterungs-TAG]
Payload           Gesamtzahl der WORD. Der Codec legt die Breite fest: DOC-1WORD 1, DOC-2WORD 2, DOC-4WORD 4
```

- Codec: Meta `0x00`~`0x02`, Strukturklasse (`000`)
- Payload: Rohwert (Gesamtzahl der WORD des Dokuments, vorzeichenlos)
- Anzahl: eines je Dokument, ganz am Anfang

## Interpretation und Gültigkeit

- Die Länge reicht vom Beginn des öffnenden Records bis zum Ende von [END](/de/grammar/meta/structure/end/).
- Es wird die schmalste Breite verwendet, in die der Wert passt. Eine Kodierung mit größerer Breite wird als nicht kanonisch abgelehnt.
- Die Länge muss der gesamten Eingabe entsprechen. Ein Dokument ist eine Eingabe.
- Ein Decoder kann mit dieser Länge das gesamte Dokument überspringen. Einen Codec, der ein Dokument mit unbekannter Länge öffnet, gibt es nicht.
- Bei der Berechnung des Inhaltshashs wird mit der Länge ohne die Meta der Verifikationsklasse und der dazu passenden Breite neu geschrieben ([Inhaltshash](/de/grammar/document/#inhaltshash)).

## Beispiel

- `0x1880 0x0017`: DOC-1WORD, insgesamt 23 WORD
