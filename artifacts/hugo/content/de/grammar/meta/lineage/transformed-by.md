---
title: "TRANSFORMED-BY"
weight: 52
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "TRANSFORMED-BY ist ein Abstammungs-Meta, das das Werkzeug und dessen Quellversion (Commit-Digest) festhält, mit dem aus einer anderen Darstellung dieses Dokument erzeugt wurde."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Hält fest, wie dieses Dokument aus einer anderen Darstellung umgewandelt wurde (z. B. Wikidata-Konverter, Natursprach-Encoder). Tool nennt, womit umgewandelt wurde, Version, mit welchem Quellstand dieses Werkzeugs. Nur mit beiden lässt sich aus derselben Eingabe dasselbe Dokument erneut erzeugen.

## Layout

```
TAG WORD          0001 1LLL L011 0011      Codec 0x33
[Length-Erweiterungs-TAG]
Tool              1 Reference-Record (Konvertierungswerkzeug/-regel)
Version           1 Value-Record (SHA-256-DIGEST oder SHA1-DIGEST)
```

- Codec: Meta `0x33`, Abstammungsklasse (`011`)
- Payload: eingebettete Reference (Werkzeug) + eingebetteter Value (Digest der Quellversion)
- Anzahl: mehrere möglich (eines je Werkzeug)

## Interpretation und Gültigkeit

- Tool ist genau ein vollständiger Reference-Record. Jede Reference, die ein Werkzeug anspricht, ist zulässig.
  - Werkzeug aus einem geul.org-Werkzeugdokument: [EXTERNAL-ISSUER](/de/grammar/reference/external-issuer/) (`0x0000`, Dokument-ID `0x0001xxxx xxxxxxxx`, dessen LOCAL). Ein Dokument je Werkzeug ([Issuer](/de/grammar/issuer/), Begriffsdefinitionsdokument).
  - Ist der Codec ein GEUL-Dokument, spricht man dieses Dokument per [DOC-POINTER](/de/grammar/reference/doc-pointer/) an.
- Version ist genau ein vollständiger Value-Record und die Objekt-ID der Versionsverwaltung der Tool-Quelle. Bei git ist es die vollständige Commit-Objekt-ID.
  - Ist das Objektformat des git-Repositorys SHA-256, ist es [SHA-256-DIGEST](/de/grammar/value/binary/sha-256-digest/) (`0x61`, 16 WORD), bei SHA-1 [SHA1-DIGEST](/de/grammar/value/binary/sha1-digest/) (`0x62`, 10 WORD). Das Repository-Format prüft man mit `git rev-parse --show-object-format`.
  - Abgekürzte IDs (`2bd496f` usw.) werden nicht verwendet. Digest-Values erlauben keine gekürzten Werte.
  - Es wird kein Hex-Text (UTF8-TEXT) verwendet. Derselbe Wert wäre bei SHA-1 22 WORD (binär 11), bei SHA-256 34 WORD (binär 18).
- Version ist Pflicht. Ein Werkzeugeintrag ohne bekannte Quellversion ist keine Grundlage für Reproduzierbarkeit. Bei Werkzeugen außerhalb der Versionsverwaltung verwendet man das SHA-256 des Release-Artefakts (SHA-256-DIGEST).
- Version verweist auf den committeten Quellstand. Für Dokumente, die mit einem Arbeitsbaum mit nicht committeten Änderungen erzeugt wurden, verwendet man diese Commit-ID nicht (empfohlen: das Werkzeug verweigert die Ausführung).
- Stützt sich das Werkzeug auf Code außerhalb des Repositorys (z. B. eine lokale Bibliothek, auf die Go `replace` zeigt), gibt man auch diesen Code getrennt per TRANSFORMED-BY an. Die Commit-ID des Werkzeugs allein legt diesen Code nicht fest.
- Werkzeuge, die die Quelle nur verlustfrei umlagern (z. B. ein Werkzeug, das einen Dump unverändert in die DB lädt), bestimmen den Dokumentinhalt nicht und werden nicht angegeben. Ein nicht verlustfreies Laden verändert das Dokument und wird daher als Werkzeug angegeben.
- Das geul.org-Spezifikationsdokument (`0x1833`) schreibt es als Zwei-Record-Feld aus Tool (Breite 0, beliebige Reference, daher kein CODEC) und Version (Breite 0, [CODEC](/de/grammar/edge/codec/) `0861`, `0862`).

## Länge

```
gesamt = 1 + N_len + N_tool + N_version WORD
```

- Der Cursor nach dem Lesen des letzten Records muss genau mit dem Ende des Meta übereinstimmen.
- Ist Tool ein EXTERNAL-ISSUER-1WORD (7 WORD) und Version ein SHA1-DIGEST (11 WORD), beträgt die Gesamtlänge 1 + 1 + 7 + 11 = 20 WORD mit erweiterter Length. Bei SHA-256-DIGEST (18 WORD) sind es 27 WORD.

## Beispiel

Nicht normatives Beispiel. Das Werkzeug ist LOCAL 2 (`0360 0000 0001 0000 0000 0001 0002`) im geul.org-Werkzeugdokument `0x0001000000000001`, die Quelle der Commit `ddc0719974a32aaa7b422ee84221a9721085ce4c` (SHA-1).

```
1F33 0014
0360 0000 0001 0000 0000 0001 0002
0D62 ddc0 7199 74a3 2aaa 7b42 2ee8 4221 a972 1085 ce4c
```

## Offene Fragen

- Ob auch die Version von [GENERATED-BY](/de/grammar/meta/lineage/generated-by/) auf dieselbe Weise (Pflicht-Digest oder anderes Format) geändert werden soll. Eine Modellversion ist keine Commit-ID.

## Verwandte Seiten

- [Meta](/de/grammar/meta/), [GENERATED-BY](/de/grammar/meta/lineage/generated-by/), [DERIVED-FROM](/de/grammar/meta/lineage/derived-from/)
- [EXTERNAL-ISSUER](/de/grammar/reference/external-issuer/), [DOC-POINTER](/de/grammar/reference/doc-pointer/), [SHA-256-DIGEST](/de/grammar/value/binary/sha-256-digest/), [SHA1-DIGEST](/de/grammar/value/binary/sha1-digest/), [CODEC](/de/grammar/edge/codec/)
