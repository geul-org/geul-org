---
title: "Meta"
weight: 110
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance", "lineage", "import"]
summary: "Meta sind Records über das Dokument, nicht über Inhalte der Welt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta sind Records über das Dokument, nicht über Inhalte der Welt. Mit Ausnahme der Dokumentstruktur-Records (DOC, BODY, END) stehen alle im HEAD des Dokuments. Im HEAD steht außer Meta auch der Beleg-Edge [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) für das gesamte Dokument samt seinem QUALIFIER.

## Layout {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      Abschnitt 14·15 (0x1C0L~0x1FFL)
[Length-Erweiterungs-TAG]
Payload           Rohwert oder eingebettete Value-/Reference-Records
```

- Meta haben kein Issuer-Format. Meta sind eine gemeinsame Spezifikation, der alle Issuer folgen, und werden allein von GEUL definiert.
- `LLLL` ist die Gesamtzahl der WORDs einschließlich des TAG WORD minus 1. Ein Codec, der nicht in der Tabelle steht, ist Reserved.

## Payload-Formate {#payload-형식}

| Format | Wann | Beispiel |
|---|---|---|
| Rohwert | Wenn das Format feststeht. Stützt sich nicht auf andere Record-Codecs | `DOC-*`-Länge, `SPEC-VERSION`, `ISSUER-KEY` |
| eingebetteter Value | Wenn aus mehreren Formaten gewählt wird. Der Value-TAG nennt das Format | `PROFILE`, `EFFECTIVE-*`, Zeitpunkt, Inhaltshash |
| eingebettete Reference | Wenn auf ein Objekt wie Person, Organisation, Werkzeug oder Dokument verwiesen wird | `DOC-ID`, `AUTHOR`, `CO-AUTHOR`, `RECORDED-BY`, `SIGNED-OFF`, Unterzeichner von `SIGNATURE` |
| keiner | 1-WORD-Marker | `BODY`, `END` |

- Eingebettete Records sind keine eigenständigen Records, sondern gehören zu ihrem Meta. Jeder findet seine Grenze über seine Length, und die Position nach dem Lesen des letzten Records muss exakt mit dem Ende des Meta übereinstimmen.
- Ob ein Meta pro Dokument nur einmal oder mehrfach vorkommen darf, bestimmt die „Anzahl“ im jeweiligen Codec-Dokument.

## Klasse {#클래스}

Die Meta-Nummern setzen sich ab `0x1C0L` ohne Reserved fort. Die Bits der Nummer geben die Klasse nicht an. Die Klasse ergibt sich aus der Bereichstabelle unten.

| Klasse | direkter Code | Behandelt |
|---|---|---|
| Struktur | `0x1C0L~0x1C4L` | Grenzen und Länge des Dokuments |
| Definition | `0x1C5L~0x1CAL` | Interpretationsdeklarationen |
| Herkunft | `0x1CBL~0x1D0L` | Wer, wann, wo |
| Abstammung | `0x1D1L~0x1DDL` | Woraus und wie es entstanden ist |
| Richtlinie | `0x1DEL~0x1E3L` | Wie es behandelt wird |
| IMPORT | `0x1E4L` | Holt ein externes Dokument herein |
| Verifikation | `0x1E5L~0x1E9L` | Ob es vertrauenswürdig ist |
| Reserved (nur Verifikation) | `0x1EAL~0x1FFL` | |

- Verifikationsklasse sind in Abschnitt 15 die Records mit `C >= 5`, also `w >= 0x1E50`. Daran erkennt man die Verifikationsklasse ohne Codebook und lässt sie beim Inhaltshash weg.
- Das hintere Reserved `0x1EAL~0x1FFL` ist der Verifikation vorbehalten. Ein neues Meta außerhalb der Verifikation kann nicht vor der Verifikation eingefügt werden; liegt es im hinteren Reserved, fällt es aus dem Inhaltshash heraus.
- Struktur-, Definitions- und IMPORT-Klasse werden nicht an den Bits gelesen. Der Decoder kennt sie aus der eingebauten Nummerntabelle.
- **Für die Interpretation notwendige Meta**: Struktur, Definition, IMPORT. Fehlen sie, lassen sich Records nicht lesen oder die Interpretation ändert sich. Jeder Decoder muss sie verarbeiten. Diese Codecs gehören zum **GEUL-Kern-Codebook**.
- **Meta, die die Interpretation nicht ändern**: Herkunft, Abstammung, Verifikation, Richtlinie. Auch wenn man sie löscht, bleibt der Aussageinhalt unverändert. Nur das Material für Vertrauensurteile und Behandlung geht verloren.
- Belege schreibt man nicht als Meta, sondern mit dem Beleg-Edge [SOURCE](../edge/0x0C0L-source.md) und QUALIFIER. Der Beleg eines einzelnen Records steht im BODY, die Quelle des gesamten Dokuments als SOURCE mit Target `0` im HEAD ([Dokument](../document.md#head와-body)).

## Struktur {#구조}

Die Meta der Strukturklasse (Codec `0x1C0L~0x1C4L`) bestimmen Grenzen und Länge des Dokuments. Die Einheit von GEUL-Daten ist ein einzelnes Dokument.

```
DOC-*                  ← Beginn des HEAD
  Definitions-, Herkunfts-, Abstammungs-, Verifikations-, Richtlinien-, IMPORT-Meta
  SOURCE für das gesamte Dokument und sein QUALIFIER
BODY                   ← Beginn des BODY
  Reference, Value, Edge
END                    ← schließt das Dokument
```

- Jedes Dokument wird mit `DOC-1WORD/2WORD/4WORD` unter Angabe der Gesamtlänge geöffnet. Mit dieser Länge kann der Decoder das gesamte Dokument in einem Zug überspringen.
- `BODY` und `END` sind 1-WORD-Records ohne Payload. `END` ist Pflicht.
- Dokumente werden nicht verschachtelt. Andere Dokumente werden per IMPORT referenziert.
- Ist der HEAD (Meta, SOURCE für das gesamte Dokument und sein QUALIFIER) leer, entfällt `BODY`. `BODY` darf pro Dokument nur einmal vorkommen.

Die gesamte Dokumentstruktur steht unter [Dokument](../document.md).

| Codec | Name | Bedeutung |
|---|---|---|
| `0x1C0L~0x1C2L` | [DOC-1WORD / 2WORD / 4WORD](0x1C0L-doc-1word.md) | Öffnet das Dokument unter Angabe der Gesamtlänge |
| `0x1C3L` | [BODY](0x1C3L-body.md) | Beendet den HEAD und öffnet den BODY |
| `0x1C4L` | [END](0x1C4L-end.md) | Schließt das Dokument |

Die genauen Regeln stehen unter [Dokument](../document.md).

## Definition {#정의}

Die Meta der Definitionsklasse (Codec `0x1C5L~0x1CAL`) sind Interpretationsdeklarationen. Da Deklarationen die Interpretationsregeln ändern, muss jeder Decoder sie verarbeiten. Der Geltungsbereich einer Deklaration ist ihr Dokument.

- `SPEC-VERSION` bestimmt, wie die übrigen Records gelesen werden, und enthält daher ohne eingebetteten Value nur eine Ganzzahl. GEUL v1 ist `0x0001` (Record `1C51 0001`).
- `DOC-ID` ist ein `DOC-POINTER` (Issuer, Dokument-ID, Version `0`), der auf das Dokument selbst zeigt. Bei einem Codec-Dokument ist es ein `CODEC-POINTER` (Issuer, Codec-ID, Version `0`). Fehlt er, ist das Dokument namenlos und nur über den Inhaltshash adressierbar.
- Es gibt keine Dokumentnamen-Adresse. Einen für Menschen lesbaren Titel hängt man als Aussage-`LABEL` an ([Veröffentlichungsadressen und Versionsliste](../publishing.md#문서-이름)).

| Codec | Name | Bedeutung |
|---|---|---|
| `0x1C5L` | [SPEC-VERSION](0x1C5L-spec-version.md) | Die befolgte Spezifikationsfassung. Eine Ganzzahl |
| `0x1C6L` | [PROFILE](0x1C6L-profile.md) | Angewandtes Profil |
| `0x1C7L` | [DOC-ID](0x1C7L-doc-id.md) | Kennung dieses Dokuments. DOC-POINTER (Version 0), der auf sich selbst zeigt. Bei einem Codec-Dokument CODEC-POINTER (Version 0) |
| `0x1C8L` | [EFFECTIVE-FROM](0x1C8L-effective-from.md) | Inkrafttreten dieser Version. Fehlt es, gilt der Veröffentlichungszeitpunkt |
| `0x1C9L` | [EFFECTIVE-UNTIL](0x1C9L-effective-until.md) | Ende der Gültigkeit dieser Version (befristetes Gesetz). Fehlt es, bis zum Inkrafttreten der nächsten Version |
| `0x1CAL` | [DEFAULT-LANGUAGE](0x1CAL-default-language.md) | Standardsprache |

- Es gibt keine Dokumentnamen-Adresse ([Veröffentlichungsadressen und Versionsliste](../publishing.md#문서-이름)). Einen für Menschen lesbaren Titel hängt man als LABEL im BODY an.

## Herkunft {#출처}

Die Meta der Herkunftsklasse (Codec `0x1CBL~0x1D0L`) halten fest, wer das Dokument wann erstellt und aufgezeichnet hat.

- Autor, Aufzeichner und ihre Zeitpunkte folgen dem author-/committer-Modell von git (`AUTHOR`·`CREATED-AT`, `RECORDED-BY`·`RECORDED-AT`).
- Auch wenn man die Herkunft löscht, ändert sich der Aussageinhalt nicht. Nur das Material für Vertrauensurteile geht verloren.
- Quellmaterial gehört nicht zu dieser Klasse. Die Quelle des gesamten Dokuments schreibt man im HEAD, die Quelle einzelner Records im BODY als Beleg-Edge [SOURCE](../edge/0x0C0L-source.md). Der entsprechende Bereich im Originaltext, der Erfassungszeitpunkt und der Hash des Originaltexts sind QUALIFIER, die an dieses SOURCE angehängt werden (Seite P304·Abschnitt P958, Abrufdatum P813, Prüfsumme P4092).
- Legte man Eigenschaften der Quelle (Bereich im Originaltext, Erfassungszeitpunkt) als Meta ab, ließe sich bei mehreren Quellen nicht bestimmen, zu welcher Quelle sie gehören. Deshalb schreibt man sie als QUALIFIER mit SOURCE als Target.

| Codec | Name | Bedeutung |
|---|---|---|
| `0x1CBL` | [AUTHOR](0x1CBL-author.md) | Autor (Reference) |
| `0x1CCL` | [CO-AUTHOR](0x1CCL-co-author.md) | Mitautor |
| `0x1CDL` | [CREATED-AT](0x1CDL-created-at.md) | Erstellungszeitpunkt |
| `0x1CEL` | [MODIFIED-AT](0x1CEL-modified-at.md) | Änderungszeitpunkt |
| `0x1CFL` | [RECORDED-BY](0x1CFL-recorded-by.md) | Aufzeichnendes Subjekt |
| `0x1D0L` | [RECORDED-AT](0x1D0L-recorded-at.md) | Aufzeichnungszeitpunkt |

- Quellmaterial schreibt man nicht als Meta, sondern als Beleg-Edge [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) (Target `0`) im HEAD; den Bereich im Originaltext, den Erfassungszeitpunkt und den Hash des Originaltexts schreibt man als QUALIFIER, die an dieses SOURCE angehängt werden.

## Abstammung {#계보}

Die Meta der Abstammungsklasse (Codec `0x1D1L~0x1DDL`) halten fest, woraus und wie das Dokument entstanden ist. Die Abstammung folgt dem Commit-Modell von git; die Einheit, die dem Commit entspricht, ist das Dokument.

- Der **Inhaltshash** bezeichnet den Inhalt eines Dokumentstands (git commit id). Er ist das SHA-256 vom öffnenden Record (`DOC-*`) bis unmittelbar vor `END`, wobei Records der Verifikationsklasse (`C >= 5` in Abschnitt 15, `w >= 0x1E50`) von der Berechnung ausgenommen sind.
- Die **Versions-ID** ist eine 2-WORD-Ganzzahl, die innerhalb eines benannten Dokuments in Veröffentlichungsreihenfolge ab 1 vergeben wird. `0` bedeutet, dass keine Version angegeben wurde.
- Abstammungs-Meta bezeichnen Versionen über den Inhaltshash. Auch das `PARENT` im Dokument geht in den Hash ein, sodass der Inhaltshash zu einer Hashkette über die gesamte Historie wird.
- Die Historie wird nicht gelöscht. Korrekturen erscheinen als neue Version. Zeiger, die sich wie ein branch ändern, legt man nicht im Dokument ab.
- `DELTA-BASE`·`DELTA-REMOVE` sind ein Format, das eine Version als Diff gegen eine Basisversion speichert. Eine Version ist stets als Snapshot definiert.

Die Revisionsregeln stehen unter [Dokument](../document.md).

Die Abstammung folgt dem Commit-Modell von git. Die Einheit, die dem Commit entspricht, ist das Dokument.

| Codec | Name | Bedeutung |
|---|---|---|
| `0x1D1L` | [PARENT](0x1D1L-parent.md) | Inhaltshash der unmittelbar vorangehenden Version. Bei mehreren ein Merge |
| `0x1D2L` | [DERIVED-FROM](0x1D2L-derived-from.md) | Abgeleitet von Material einer anderen Abstammung |
| `0x1D3L` | [GENERATED-BY](0x1D3L-generated-by.md) | Erzeugendes Subjekt (Mensch, Modell, Regel-Engine) |
| `0x1D4L` | [TRANSFORMED-BY](0x1D4L-transformed-by.md) | Transformationswerkzeug und seine Quellversion (Commit-Digest) |
| `0x1D5L` | [CHERRY-PICKED-FROM](0x1D5L-cherry-picked-from.md) | Ursprungsversion einer übernommenen Änderung |
| `0x1D6L` | [REVERTS](0x1D6L-reverts.md) | Zurückgenommene Zielversion |
| `0x1D7L` | [REPLACES](0x1D7L-replaces.md) | Neu geschriebene Zielversion. Die ursprüngliche Version wird nicht gelöscht |
| `0x1D8L` | [SQUASHED-FROM](0x1D8L-squashed-from.md) | Zu einer Version zusammengeführte Ursprungsversionen |
| `0x1D9L` | [MESSAGE](0x1D9L-message.md) | Grund der Änderung. Einer pro Sprache |
| `0x1DAL` | [TAG](0x1DAL-tag.md) | Unveränderlicher Name, der an eine Version gehängt wird |
| `0x1DBL` | [DELTA-BASE](0x1DBL-delta-base.md) | Diese Datei ist ein Diff gegen eine Basisversion |
| `0x1DCL` | [DELTA-REMOVE](0x1DCL-delta-remove.md) | Liste der LOCAL IDs, die aus dem Diff zu entfernen sind |
| `0x1DDL` | [NEXT-LOCAL-ID](0x1DDL-next-local-id.md) | Als Nächstes zu vergebende LOCAL ID. Steht im Versionslisten-Dokument |

- Die Historie wird nicht gelöscht. Korrekturen erscheinen als neue Version.
- Zeiger, die sich wie ein branch ändern, legt man nicht im Dokument ab. Repository und Index verwalten sie.

## Verifikation {#검증}

Die Meta der Verifikationsklasse (Codec `0x1E5L~0x1E9L`) halten Material fest, anhand dessen sich beurteilen lässt, ob das Dokument vertrauenswürdig ist: den öffentlichen Schlüssel eines selbst ausgestellten Issuers, Signatur, Bestätigung des Beitragsrechts, Konfidenz und das Beurteilungsergebnis für das gesamte Dokument.

- Die Verifikationsklasse fällt aus der Inhaltshash-Berechnung heraus. Deshalb ändert sich der Inhaltshash nicht, wenn man eine Signatur ins Dokument legt oder mehrere Signaturen hinzufügt (wie bei git `gpgsig`).
- Die Verifikationsklasse sind in Abschnitt 15 die Records mit `C >= 5`, also `w >= 0x1E50`, sodass sich der Hash ohne Codebook berechnen lässt. Auch das hintere Reserved `0x1EAL~0x1FFL` ist der Verifikation vorbehalten und fällt aus dem Hash heraus.
- Die Beurteilung auf Knoten- und Record-Ebene übernimmt der [TOULMIN](../toulmin/_index.md)-Edge `VERDICT` (`0x118L`).

| Codec | Name | Bedeutung |
|---|---|---|
| `0x1E5L` | [ISSUER-KEY](0x1E5L-issuer-key.md) | Signaturalgorithmus und öffentlicher Schlüssel eines selbst ausgestellten Issuers |
| `0x1E6L` | [SIGNATURE](0x1E6L-signature.md) | Signatur über den Inhaltshash. Algorithmus, Unterzeichner, Signatur |
| `0x1E7L` | [SIGNED-OFF](0x1E7L-signed-off.md) | Bestätigung des Beitragsrechts |
| `0x1E8L` | [CONFIDENCE](0x1E8L-confidence.md) | Konfidenz |
| `0x1E9L` | [VERDICT](0x1E9L-verdict.md) | Beurteilungsergebnis für das gesamte Dokument (Pass, Review, Fail) |

- Die Verifikationsklasse fällt aus der Inhaltshash-Berechnung heraus. Deshalb ändert sich der Inhaltshash nicht, wenn man eine Signatur ins Dokument legt oder mehrere Signaturen hinzufügt.

## Richtlinie {#정책}

Die Meta der Richtlinienklasse (Codec `0x1DEL~0x1E3L`) bestimmen, wie das Dokument behandelt wird: Lizenz, Zugriffsbereich, Datenschutzstufe, Aufbewahrungsfrist, Einwilligung und Nutzungsbeschränkung.

- Richtlinien ändern die Interpretation nicht, sondern bestimmen die Behandlung.
- Die ursprüngliche Lizenz eines Werks innerhalb einer Bytefolge wird mit `LICENSE` festgehalten.

| Codec | Name | Bedeutung |
|---|---|---|
| `0x1DEL` | [LICENSE](0x1DEL-license.md) | Lizenz |
| `0x1DFL` | [ACCESS](0x1DFL-access.md) | Zugriffsbereich |
| `0x1E0L` | [PRIVACY](0x1E0L-privacy.md) | Datenschutzstufe |
| `0x1E1L` | [RETENTION](0x1E1L-retention.md) | Aufbewahrungsfrist |
| `0x1E2L` | [CONSENT](0x1E2L-consent.md) | Einwilligungsumfang und -grundlage |
| `0x1E3L` | [USAGE](0x1E3L-usage.md) | Nutzungsbeschränkung |

- Richtlinien ändern die Interpretation nicht, sondern bestimmen die Behandlung.

## IMPORT {#import}

Das Meta der IMPORT-Klasse (Codec `0x1E4L`) holt ein externes Dokument über eine IMPORT ID herein. Der Codec ist allein `IMPORT-DOC` (`0x1E4L`).

- IMPORT holt nur Dokumente herein. Objekte im hereingeholten Dokument werden im BODY über die Reference `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) referenziert ([Reference](../reference/_index.md)).
- Wird eine Versions-ID angegeben, ist es an diese Fassung gebunden, bei `0` an die zum Zeitpunkt der Interpretation neueste Fassung. Veröffentlichte Dokumente geben eine Version an.
- Der HEAD des hereingeholten Dokuments wird nicht hereingeholt. Reference- und Value-Records werden nicht hereingeholt, sondern kopiert.

```
TAG WORD          0001 1110 0100 LLLL      IMPORT-DOC (0x1E4L)
[Length-Erweiterungs-TAG]
Dokument          DOC-POINTER-Record (Issuer, Dokument-ID, Versions-ID). Bei einem Codec-Dokument CODEC-POINTER
IMPORT ID         Rest. Ganzzahl in der kürzesten Breite
```

- Es wird allein [IMPORT-DOC](0x1E4L-import-doc.md) (`0x1E4L`) verwendet. IMPORT holt nur Dokumente herein. Objekte im hereingeholten Dokument werden im BODY über `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) referenziert.
- Wird eine Versions-ID angegeben, ist es an diese Fassung gebunden, bei `0` an die zum Zeitpunkt der Interpretation neueste Fassung. Veröffentlichte Dokumente geben eine Version an.
- Dieselbe IMPORT ID wird in einem Dokument nicht zweimal vergeben.
- Der HEAD des hereingeholten Dokuments wird nicht hereingeholt. Dessen Objekte werden gemäß den eigenen Deklarationen jenes Dokuments interpretiert.

Beispiel: Die neueste Version des Dokuments `0x0000000000000002` von Issuer `0x00000002` wird mit IMPORT ID 1 hereingeholt.

```
1E4A 0418 0000 0002 0000 0000 0000 0002 0000 0000 0001
```
