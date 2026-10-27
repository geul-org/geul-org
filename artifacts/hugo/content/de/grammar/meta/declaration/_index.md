---
title: "Meta — Definition"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Die Meta-Definitionsklasse (obere 3 Bit `001`, `0x10`~`0x1F`) enthält Interpretationsdeklarationen. Sie legt Spezifikationsausgabe, Profil, Dokument-ID, Geltungszeitraum und Standardsprache fest."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Die Meta-Definitionsklasse (obere 3 Bit `001`, Codec `0x10`~`0x1F`) enthält Interpretationsdeklarationen. Deklarationen ändern die Interpretationsregeln, daher muss jeder Decoder sie verarbeiten. Der Geltungsbereich einer Deklaration ist ihr Dokument.

- `SPEC-VERSION` bestimmt, wie die übrigen Records zu lesen sind, und enthält deshalb nur eine Ganzzahl, keinen eingebetteten Value. GEUL v1 ist `0x0001` (Record `1890 0001`).
- `DOC-ID` ist ein `DOC-POINTER` (Issuer, Dokument-ID, Version `0`), der auf das Dokument selbst zeigt. Fehlt er, ist das Dokument namenlos und nur über seinen Inhaltshash ansprechbar.
- Der Adressname eines Dokuments wird nicht als Meta gesetzt. Der Namensindex `documents.geul` des Issuers hängt ihn als beschreibendes `BIND` an, den für Menschen lesbaren Titel als `LABEL` ([Veröffentlichungsadresse und Versionsliste](/de/grammar/publishing/#dokumentname)).
