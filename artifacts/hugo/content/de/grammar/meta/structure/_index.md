---
title: "Meta — Struktur"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "Die Meta-Strukturklasse (obere 3 Bit `000`, `0x00`~`0x0F`) legt Grenzen und Länge eines Dokuments fest. Es wird mit DOC-1WORD/2WORD/4WORD geöffnet, der HEAD mit BODY beendet und das Dokument mit END geschlossen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Die Meta-Strukturklasse (obere 3 Bit `000`, Codec `0x00`~`0x0F`) legt Grenzen und Länge eines Dokuments fest. Die Einheit der GEUL-Daten ist ein Dokument.

```
DOC-*                  ← HEAD beginnt
  Meta für Definition, Herkunft, Abstammung, Verifikation, Richtlinie, IMPORT
  SOURCE für das gesamte Dokument und dessen QUALIFIER
BODY                   ← BODY beginnt
  Reference, Value, Edge
END                    ← schließt das Dokument
```

- Jedes Dokument wird mit `DOC-1WORD/2WORD/4WORD` unter Angabe der Gesamtlänge geöffnet. Mit dieser Länge kann ein Decoder das gesamte Dokument in einem Schritt überspringen.
- `BODY` und `END` sind 1-WORD-Records ohne Payload. `END` ist Pflicht.
- Dokumente werden nicht verschachtelt. Andere Dokumente werden per IMPORT angesprochen.
- Ist der HEAD (Meta, SOURCE für das gesamte Dokument und dessen QUALIFIER) leer, entfällt `BODY`. `BODY` darf je Dokument nur einmal stehen.

Die vollständige Dokumentstruktur steht unter [Dokument](/de/grammar/document/).
