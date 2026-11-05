---
title: "TRANSFORMED-BY (0x1D4L)"
weight: 468
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Hält fest, wie aus einer anderen Darstellung dieses Dokument erzeugt wurde (z. B. Wikidata-Konverter, Encoder für natürliche Sprache)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `TRANSFORMED-BY` (Spezifikationsdokument BIND `TRANSFORMED-BY`) |
| TAG ID | `0x1D4L` |
| Codec ID | `0x00001D40` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001D40/` (DECLARE-Ziel `1D40`) |
| Abschnitt | 14 `1110` (Meta), Offset im Abschnitt C = 20 |
| Kind | Meta · Klasse: Abstammung |
| TAG WORD | `0001 1101 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Transformationsmethode. Werkzeug, Regeln, Version |
| Hugo-Seite | `meta/lineage/transformed-by.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `tool` | #2 | Record | beliebiger Record (außer Slot-Marker) |  |
| 2 | `version` | #3 | Record | `07C0` SHA-256-DIGEST, `07D0` SHA1-DIGEST |  |

Hält fest, wie aus einer anderen Darstellung dieses Dokument erzeugt wurde (z. B. Wikidata-Konverter, Encoder für natürliche Sprache). Tool ist, womit transformiert wurde; Version ist, mit welcher Quelle des Werkzeugs transformiert wurde. Nur mit beiden lässt sich aus derselben Eingabe dasselbe Dokument erneut erzeugen.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0100 LLLL      Codec 0x1D4L
[Length-Erweiterungs-TAG]
Tool              1 Reference-Record (Transformationswerkzeug, Regeln)
Version           1 Value-Record (SHA-256-DIGEST oder SHA1-DIGEST)
```

- Codec: Meta `0x1D4L`, Abstammungsklasse
- Payload: eingebettete Reference (Werkzeug) + eingebetteter Value (Digest der Quellversion)
- Anzahl: mehrere möglich (eines pro Werkzeug)

## Interpretation und Gültigkeit {#해석과-유효성}

- Tool ist genau ein vollständiger Reference-Record. Jede Reference, die auf ein Werkzeug verweist, kann verwendet werden.
  - Werkzeug eines Werkzeugdokuments von geul.org: [EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md)(`0x00000000`, Dokument-ID `0x0001xxxx xxxxxxxx`, dessen LOCAL). Ein Werkzeug hat ein Dokument ([Issuer](../issuer.md) Begriffsdefinitions-Dokument).
  - Ist der Codec ein GEUL-Dokument, verweist man mit [CODEC-POINTER](../reference/0x042L-codec-pointer.md) auf dieses Codec-Dokument.
- Version ist genau ein vollständiger Value-Record und die Objekt-ID der Versionsverwaltung der Tool-Quelle. Bei git ist es die vollständige Commit-Objekt-ID.
  - Ist das Objektformat des git-Repositorys SHA-256, ist es [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md)(`0x07CL`, 16 WORD), bei SHA-1 [SHA1-DIGEST](../value/0x07DL-sha1-digest.md)(`0x07DL`, 10 WORD). Das Repository-Format prüft man mit `git rev-parse --show-object-format`.
  - Abgekürzte IDs (`2bd496f` usw.) werden nicht verwendet. Der Digest-Value erlaubt keine gekürzten Werte.
  - Man schreibt sie nicht als Hex-Text (UTF8-TEXT). Derselbe Wert umfasst bei SHA-1 22 WORD (binär 11), bei SHA-256 34 WORD (binär 18).
- Version ist Pflicht. Ein Werkzeugeintrag ohne bekannte Quellversion taugt nicht als Grundlage der Reproduktion. Liegt das Werkzeug außerhalb der Versionsverwaltung, verwendet man das SHA-256 des Release-Artefakts (SHA-256-DIGEST).
- Version verweist auf die committete Quelle. Für ein Dokument, das mit einem Arbeitsbaum mit nicht committeten Änderungen erzeugt wurde, verwendet man diese Commit-ID nicht (empfohlen ist, dass das Werkzeug die Ausführung verweigert).
- Stützt sich das Werkzeug auf Code außerhalb des Repositorys (z. B. eine lokale Bibliothek, auf die Go `replace` zeigt), vermerkt man auch diesen Code gesondert mit TRANSFORMED-BY. Die Commit-ID des Werkzeugs allein bestimmt diesen Code nicht.
- Ein Werkzeug, das die Quelle nur verlustfrei überträgt (z. B. eines, das einen Dump unverändert in eine DB lädt), bestimmt den Dokumentinhalt nicht und wird daher nicht vermerkt. Ein nicht verlustfreies Laden verändert das Dokument und wird daher als Werkzeug vermerkt.
- Das Spezifikationsdokument von geul.org (`0x1D40`) wird mit zwei Record-Feldern geschrieben: Tool (Breite 0, beliebige Reference, daher kein CODEC) und Version (Breite 0, [CODEC](../edge/0x0BEL-codec.md) `07C0`·`07D0`).

## Länge {#길이}

```
gesamt = 1 + N_len + N_tool + N_version WORD
```

- Der Cursor nach dem Lesen des letzten Records muss exakt mit dem Ende des Meta übereinstimmen.
- Ist Tool ein EXTERNAL-ISSUER-2WORD (8 WORD) und Version ein SHA1-DIGEST (11 WORD), beträgt die Gesamtlänge 1 + 1 + 8 + 11 = 21 WORD, und die Erweiterungslänge wird verwendet. Bei SHA-256-DIGEST (18 WORD) sind es 28 WORD.

## Beispiel {#예시}

Nicht normatives Beispiel. Das Werkzeug ist LOCAL 2 (`02F7 0000 0000 0001 0000 0000 0001 0002`) des Werkzeugdokuments `0x0001000000000001` von geul.org, die Quelle der Commit `ddc0719974a32aaa7b422ee84221a9721085ce4c` (SHA-1).

```
1D4E 0015
02F7 0000 0000 0001 0000 0000 0001 0002
07DA DDC0 7199 74A3 2AAA 7B42 2EE8 4221 A972 1085 CE4C
```

## Offene Probleme {#열린-문제}

- Ob auch die Version von [GENERATED-BY](0x1D3L-generated-by.md) auf dieselbe Weise geändert werden soll (Pflicht-Digest oder anderes Format). Die Modellversion ist keine Commit-ID.

## Verwandte Seiten {#관련-페이지}

- [Meta](_index.md), [GENERATED-BY](0x1D3L-generated-by.md), [DERIVED-FROM](0x1D2L-derived-from.md)
- [EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md), [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md), [SHA1-DIGEST](../value/0x07DL-sha1-digest.md), [CODEC](../edge/0x0BEL-codec.md)

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001D40/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D4000000000
BODY
#1 DECLARE 0x1D40
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "TRANSFORMED-BY"
#5 BIND #2 "tool"
#6 BIND #3 "version"
#7 CODEC #3 0x07C0
#8 CODEC #3 0x07D0
```
