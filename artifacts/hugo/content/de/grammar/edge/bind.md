---
title: "BIND"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "BIND ist ein Beschreibungs-Edge (Codec 0x03), das an ein Subject einen Namen bindet, auf den Maschinen abgestimmt werden (UTF8-TEXT ohne Sprache)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIND ist ein Beschreibungs-Edge, das an ein Subject einen Namen bindet, auf den Maschinen abgestimmt werden. Codec `0x03`.

Es ist eine Benennung. Für Namen, die Menschen lesen (Titel je Sprache), ist [LABEL](/de/grammar/edge/label/) zuständig. Der Name eines Programmsymbols und der Adressname eines Dokuments werden mit demselben Record geschrieben.

## Layout

```
TAG WORD          0001 0LLL L000 0011
[Length-Erweiterungs-TAG]
Edge Id           LOCAL-Reference-Record
Subject           1 Reference-Record oder 1 WORD Codec-TAG-WORD
Name              1 UTF8-TEXT-*-Value
```

## Interpretation und Gültigkeit

- Das Subject ist genau ein vollständiger [Reference](/de/grammar/reference/)-Record. Ein LOCAL ist ein Objekt dieses Dokuments (Symbol usw.), ein Zeiger-Reference ein Objekt eines anderen Dokuments. Das Dokument selbst ist ein [DOC-POINTER](/de/grammar/reference/doc-pointer/), der Issuer selbst ein [ISSUER-POINTER](/de/grammar/reference/issuer-pointer/).
- Oder das Subject ist ein einzelnes Codec-TAG-WORD (nur Kind und Codec, `LLLL = 0`, kein Payload). Das ist kein Record mit leerem Payload, sondern verweist auf den direkten Code selbst, also auf sein Spezifikationsdokument (GEUL-Issuer-Dokument `0x000000000000<TAG>`) ([Codec-Spezifikationsdokument](/de/grammar/codec-spec/), [DECLARE](/de/grammar/edge/declare/)). Beispiel: `1018` ist PUBLICATION. Im Namensindex verwendet man ein DOC-POINTER-Subject. Issuer-Format-Codecs werden nicht verwendet.
- Andere Records (Value usw.) können kein Subject sein. Da das FIELD im Spezifikationsdokument von BIND das Subject nur mit Breite `0` (Record) deklariert, ist diese Beschränkung eine Regel im Text von BIND.
- Der Name ist genau ein [UTF8-TEXT](/de/grammar/value/text/utf8-text/)-Value. Er hat keine Sprache und wird nicht normalisiert. Nur bytegleiche Namen sind derselbe Name.
- Der Geltungsbereich des Namens ist das Dokument, das das BIND enthält. In einem Dokument wird derselbe Name nicht an verschiedene Subjects gebunden.
- An ein Subject können mehrere Namen gebunden werden (Aliase, frühere Namen). Legt das Dokument nichts anderes fest, ist das letzte BIND der maßgebliche Name.
- Auf andere Records verweist man nicht über Namen, sondern über LOCAL IDs. Namen dienen dem Abgleich mit der Außenwelt (Host-Funktionen, Adresseingabe, Menschen).
- Welche Zeichen in einem Namen zulässig sind, bestimmt der Verwendungszweck. Namen für Dokumentadressen folgen der Regel für Dokumentnamen (ASCII-Slug in Kleinbuchstaben) ([Veröffentlichungsadresse und Versionsliste](/de/grammar/publishing/#dokumentname)).

## Länge

```
Gesamt = 1 + N_len + N_id + N_subject + N_name WORD
```

## Beispiel (nicht normativ)

Programmsymbol: Edge Id `0003`, Subject LOCAL 7, Name `main`.

- Der Name `main` hat 4 Byte (gerade), also `0940 6d61 696e` mit 3 WORD.
- Das Edge hat TAG 1 + Edge Id 2 + Subject 2 + Name 3 = 8 WORD, TAG `1383`.

```
1383 0088 0003 0088 0007 0940 6d61 696e
```

Dokumentname (im Versionslisten-Dokument `0x0000/0xffff000000000002/versions.geul` dieses Dokuments): Edge Id `0005`, Subject `DOC-POINTER` (Issuer `0x0000`, Dokument `0xffff000000000002`, Version `0` = das Dokument selbst), Name `this-is-sample-doc`.

- Das Subject ist TAG `03B8` + Issuer 1 + Dokument-ID 4 + Versions-ID 2 = 8 WORD.
- Der Name hat 18 Byte (gerade), also TAG `0CC0` + 9 WORD = 10 WORD.
- Das Edge hat TAG 1 + Length-Erweiterung 1 + Edge Id 2 + Subject 8 + Name 10 = 22 WORD, also `LLLL=1110`, TAG `1703`, Erweiterung `0016`.

```
1703 0016 0088 0005 03B8 0000 ffff 0000 0000 0002 0000 0000 0CC0 7468 6973 2d69 732d 7361 6d70 6c65 2d64 6f63
```

## Verwandte Seiten

- [Edge](/de/grammar/edge/), [LABEL](/de/grammar/edge/label/), [PUBLICATION](/de/grammar/edge/publication/) (Dokumentname des Versionslisten-Dokuments)
- [LOCAL](/de/grammar/reference/local/), [DOC-POINTER](/de/grammar/reference/doc-pointer/), [ISSUER-POINTER](/de/grammar/reference/issuer-pointer/)
