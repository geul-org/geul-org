---
title: "DOC-ID (0x1C7L)"
weight: 455
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Deklariert die Kennung dieses Dokuments."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `DOC-ID` (Spezifikationsdokument BIND `DOC-ID`) |
| TAG ID | `0x1C7L` |
| Codec ID | `0x00001C70` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001C70/` (DECLARE-Ziel `1C70`) |
| Abschnitt | 14 `1110` (Meta), Offset im Abschnitt C = 7 |
| Kind | Meta · Klasse: Definition |
| TAG WORD | `0001 1100 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Kennung dieses Dokuments. Eingebettete Reference `DOC-POINTER` (Issuer, Dokument-ID, Version 0). Bei einem Codec-Dokument `CODEC-POINTER` (Issuer, Codec-ID, Version 0) |
| Hugo-Seite | `meta/declaration/doc-id.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #2 | Record | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |

Deklariert die Kennung dieses Dokuments. Sie ist nötig, damit andere Dokumente dieses Dokument und die Objekte darin referenzieren können.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0111 LLLL      Codec 0x1C7L
[Length-Erweiterungs-TAG]
Dokument          DOC-POINTER-Reference-Record. (Issuer, Dokument-ID, Version 0). Bei einem Codec-Dokument CODEC-POINTER
```

- Codec: Meta `0x1C7L`, Definitionsklasse
- Payload: genau eine eingebettete Reference [DOC-POINTER](../reference/0x041L-doc-pointer.md) (Issuer, Dokument-ID, Version 0)
- Anzahl: höchstens eines. Für Versionsdokumente unter `docs/<Dokument-ID>/`·`codecs/<Codec-ID>/` ist er Pflicht

## Interpretation und Gültigkeit {#해석과-유효성}

- Der Payload ist genau ein Reference-Record `DOC-POINTER` (Issuer, Dokument-ID, Version `0`). Als Versions-ID wird nur `0` verwendet. Die Version vergibt nicht das Dokument, sondern die Versionsliste. Ein Codec-Dokument verwendet `CODEC-POINTER` (Issuer, Codec-ID, Version `0`) ([CODEC-POINTER](../reference/0x042L-codec-pointer.md)).
- Deshalb ist die Schreibweise, die „dieses Dokument“ bezeichnet, in DOC-ID, im PUBLICATION-Record der Versionsliste und in Zitaten anderer Dokumente dieselbe.
- Dasselbe Dokument hat unabhängig von der Version dieselbe `DOC-ID`. Versions-ID und Inhaltshash werden nicht im Dokument vermerkt ([Version](../document.md#버전)).
- Es gibt keine Dokumentnamen-Adresse ([Veröffentlichungsadressen und Versionsliste](../publishing.md#문서-이름)). Den für Menschen lesbaren Titel übernimmt die Aussage [LABEL](../edge/0x0A4L-label.md).
- Fehlt er, ist das Dokument namenlos und nur über den Inhaltshash adressierbar. Er ist nötig, damit andere Dokumente ein LOCAL dieses Dokuments über eine zeigende Reference referenzieren können.
- Wer ein Dokument holt, prüft, ob die `DOC-ID` des erhaltenen Dokuments mit dem angeforderten Issuer und der Dokument-ID übereinstimmt.
- Die Dokument-ID `0x0000000000000000` ist das Index-Dokument der Begriffsdefinitionen eines Issuers ([Issuer](../issuer.md)). Auch dieses Dokument ist ein Versionsdokument unter `docs/<Dokument-ID>/` und erhält daher eine DOC-ID (`DOC-POINTER` (Issuer, `0`, `0`)). Der Issuer selbst wird durch [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md) vertreten.
- Für die Versionsdokumente `<Versions-ID>.geul` (einschließlich Spezifikationsdokumenten) unter `<Issuer>/docs/<Dokument-ID>/` und `<Issuer>/codecs/<Codec-ID>/` in `.well-known/geul/` ist `DOC-ID` Pflicht.
- Listendokumente sind die Ausnahme und haben keine `DOC-ID`: die Versionsliste `versions.geul` ([PUBLICATION](../edge/0x0B8L-publication.md)) und die Version `<Versions-ID>.geul` der Issuer-Liste `issuers/` ([Veröffentlichungsadressen und Versionsliste](../publishing.md#목록-문서)). Wessen Liste es ist, sagt der DOC-POINTER im Record. Die Version eines Listendokuments referenziert die PUBLICATION in dessen `versions.geul` mit einem DOC-POINTER (`0x00000000`, reservierte Dokument-ID, Versions-ID). Die Inhaltshash-Adresse `<Issuer>/hashes/` ist eine Kopie der obigen Dokumente und folgt dem Original.
- Die Dokument-ID `0xFFFFFFFFFFFFFFFF` ist bei allen Issuern reserviert (ebenso `0x0000000000000000`) und wird für die Issuer-Liste des Issuers `0x00000000` verwendet. Andere Issuer verwenden sie nicht. Da Listendokumente keine `DOC-ID` haben, erscheint dieser Wert nur im DOC-POINTER der Records von `issuers/versions.geul`.
- Das Codec-Spezifikationsdokument ist ein Codec-Dokument des GEUL-Issuers `0x00000000`. Es hat keine Dokument-ID und legt als `DOC-ID` einen CODEC-POINTER (`0x00000000`, Codec-ID, `0`) ab. Die Codec-ID ist das TAG WORD aus Kind und Codec in 32 Bit geschrieben (`0x0B80` → `0x00000B80`) ([Spezifikationsdokument](../codec-spec.md)).

## Beispiel {#예시}

- Issuer `0x00000002`, Dokument `0x…0005`: `1C79 0418 0000 0002 0000 0000 0000 0005 0000 0000` (Meta-TAG 1 + Reference-TAG 1 + Issuer 2 + Dokument-ID 4 + Version 2 = 10 WORD)

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001C70/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C7000000000
BODY
#1 DECLARE 0x1C70
#2 FIELD #1 record
#5 CODEC #2 0x0410
#3 BIND #1 "DOC-ID"
#4 BIND #2 "doc"
#6 CODEC #2 0x0420
```
