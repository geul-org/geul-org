---
title: "Dokument"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "document", "version", "hash"]
summary: "Die Einheit der GEUL-Daten ist das Dokument. Ein Dokument wird mit Längenangabe geöffnet und mit END geschlossen und gliedert sich in HEAD (Meta und Quelle des gesamten Dokuments) und BODY (Reference, Value, Edge). Jede Version wird durch einen Inhaltshash festgelegt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Die Einheit der GEUL-Daten ist ein Dokument (DOC). Eine Datei (`.geul`, Medientyp `application/vnd.geul`) ist ein Dokument.

## Struktur

```
DOC-*            ← öffnet das Dokument (Gesamtlänge)
  Meta …         ← HEAD: Records über das Dokument
  SOURCE …       ←   (Quelle des gesamten Dokuments und deren QUALIFIER)
BODY             ← beendet den HEAD und öffnet den BODY
  Reference, Value, Edge …
END              ← schließt das Dokument
```

| Record | TAG | Bedeutung |
|---|---|---|
| DOC-1WORD | `1880` + 1 WORD | Öffnet das Dokument mit der Gesamtlänge in 1 WORD |
| DOC-2WORD | `1901` + 2 WORD | Gesamtlänge in 2 WORD |
| DOC-4WORD | `1A02` + 4 WORD | Gesamtlänge in 4 WORD |
| BODY | `180E` | 1 WORD. Beendet den HEAD und beginnt den BODY |
| END | `180F` | 1 WORD. Schließt das Dokument |

- Der Wert von DOC-* ist die Gesamtzahl der WORD vom Beginn des öffnenden Records bis zum Ende von END. Es wird die schmalste Breite verwendet, in die der Wert passt.
- END ist Pflicht. Passt die Position von END nicht zur Länge in DOC-*, wird das Dokument abgelehnt. Endet die Eingabe ohne END, ist das Dokument abgeschnitten.
- Ein Decoder kann mit der Länge in DOC-* das gesamte Dokument in einem Schritt überspringen.
- Es gibt keine Möglichkeit, ein Dokument ohne bekannte Länge zu öffnen. Echtzeitdaten, deren Ende nicht im Voraus bekannt ist, werden in Einheiten bekannter Länge zerlegt und als mehrere Dokumente gesendet.
- Ist der HEAD leer, entfällt BODY. Ein Dokument ohne BODY-Record besteht ganz aus BODY. BODY steht nur einmal. Enthält der HEAD mindestens einen Record (Meta oder HEAD-Edge), steht ein BODY.
- Dokumente werden nicht verschachtelt. Andere Dokumente werden über [IMPORT](/de/grammar/meta/) oder ein Zeiger-Reference angesprochen.

## HEAD und BODY

- Im HEAD stehen nur Meta und **HEAD-Edges**. Beide sind Aussagen über das **Dokument**, das sie enthält.
  - Meta: Struktur, Definition, Herkunft, Abstammung, Verifikation, Richtlinie und IMPORT des Dokuments.
  - HEAD-Edge: das Beleg-Edge [SOURCE](/de/grammar/edge/source/#quelle-des-gesamten-dokuments) (Target `0`), das die Quelle des gesamten Dokuments angibt, sowie die [QUALIFIER](/de/grammar/edge/qualifier/), die dieses SOURCE als Target haben (Hash des Originals, Empfangszeitpunkt, Bereich im Originaltext usw.). Die QUALIFIER stehen hinter diesem SOURCE.
- Im BODY stehen nur Reference, Value und Edge. Die Quelle einzelner Records schreibt man mit dem Beleg-Edge [SOURCE](/de/grammar/edge/source/) im BODY, andere Belege wie die Konfidenz als QUALIFIER, der an den Record angehängt wird. Ein SOURCE mit Target `0` und ein QUALIFIER, der das HEAD-SOURCE als Target hat, dürfen nicht im BODY stehen.
- Ein Decoder liest den HEAD von vorn und ordnet dabei zu. Meta gehört zum HEAD. Ein SOURCE mit Target `0` gehört zum HEAD, und seine Edge Id wird gemerkt. Ein QUALIFIER, der ein gemerktes SOURCE als Target hat, gehört zum HEAD. Kommt ein anderer Record: Ist der HEAD leer, wurde der BODY ausgelassen (ab diesem Record ist es BODY); andernfalls ist das Dokument invalid, weil der BODY fehlt.
- **HEAD und BODY teilen sich einen Nummernraum für Edge Ids.** Eine Edge Id ist im Dokument eindeutig und wird wie bei Edges im BODY von [NEXT-LOCAL-ID](/de/grammar/meta/lineage/next-local-id/) bezogen. Ist der Origin eines HEAD-Edge ein LOCAL, steht dessen Definition im BODY (LOCAL gilt im gesamten Dokument).
- Ein Meta kann in seinem Payload Value-Records enthalten. Ein enthaltener Value ist kein eigenständiger Record, sondern Teil dieses Meta.
- Der Geltungsbereich von Deklarationen (Meta-Klasse Definition) ist dieses Dokument.

## Grunddeklarationen

Beide Deklarationen stehen höchstens einmal. In welchen Dokumenten sie stehen müssen, regelt die folgende Bedingung.

| Meta | Bedeutung | Dokumente, in denen es stehen muss |
|---|---|---|
| [SPEC-VERSION](/de/grammar/meta/declaration/spec-version/) | Befolgte Spezifikationsausgabe. Legt fest, wie die übrigen Records zu lesen sind. Bei unbekannter Ausgabe wird abgelehnt oder gewarnt. Der Wert eines v1-Dokuments ist `0x0001` | Veröffentlichte Dokumente. Fehlt sie, liest der Decoder mit der ihm bekannten Ausgabe |
| [DOC-ID](/de/grammar/meta/declaration/doc-id/) | Kennung des Dokuments selbst. Sie muss vorhanden sein, damit man von außerhalb auf dieses Dokument und seine Objekte verweisen kann | Dokumente unter `.well-known/geul/`, deren Name mit `0x` beginnt (Versionsdokumente, Spezifikationsdokumente). Nicht in Versionsliste und Namensindex |

- `SPEC-VERSION` enthält nur eine Ganzzahl, damit Decoder jeder Ausgabe sie lesen können (bei v1 `1890 0001`). Sie stützt sich nicht auf einen Value-Code.
- `DOC-ID` ist ein DOC-POINTER auf das Dokument selbst (Issuer, Dokument-ID, Version `0`). Die Dokument-ID umfasst 4 WORD.
- Ein Dokument ohne `DOC-ID` ist ein namenloses Dokument. Man kann nur über den Inhaltshash darauf verweisen.

## Inhaltshash

Eine Fassung eines Dokuments wird über den **Inhaltshash** angesprochen (wie die Commit-ID in git).

- Es ist das SHA-256 vom öffnenden Record (DOC-*) bis unmittelbar vor END. 16 WORD.
- Meta der Verifikationsklasse (Signatur usw.) bleiben bei der Berechnung außen vor. Deshalb entsteht kein Zirkelbezug, wenn die Signatur im Dokument steht.
- Bei der Berechnung wird die Länge in DOC-* durch die Länge ohne Verifikations-Records ersetzt, und auch die Breite wird auf die schmalste Breite für diese Länge gesetzt. Deshalb ist der Inhaltshash vor und nach dem Anbringen der Signatur gleich.
- Der Inhaltshash wird nicht im Dokument gespeichert, sondern berechnet. Man schreibt ihn nur dann als Wert, wenn man auf eine andere Version verweist (`PARENT` usw.).
- Auch das `PARENT` im Dokument geht in die Berechnung ein, sodass der Inhaltshash zu einer Hashkette über die gesamte Historie wird.
- Meta, die später außerhalb des Dokuments angefügt werden (z. B. Anmerkungen in einem separaten Repository), ändern den Inhaltshash nicht (wie git notes).
- Die Binärform ist die maßgebliche Fassung eines Dokuments. Inhaltshash und Signatur werden nur über die Binärform berechnet.

## Version

Ein benanntes Dokument (ein Dokument mit `DOC-ID`) hat Versionen.

- Die **Versions-ID** ist eine 2-WORD-Ganzzahl, die innerhalb eines Dokuments in der Reihenfolge der Veröffentlichung ab 1 vergeben wird. `0` bedeutet „Version nicht angegeben“ und wird als die neueste Version behandelt.
- Die Versions-ID vergibt die veröffentlichende Stelle bei der Veröffentlichung. Die Zuordnung von Versions-ID und Inhaltshash steht in der von der veröffentlichenden Stelle signierten Versionsliste ([Veröffentlichungsadresse und Versionsliste](/de/grammar/publishing/#versionsliste)).
- Derselbe Inhalt wird nicht erneut veröffentlicht. Bei einem bereits vorhandenen Inhaltshash wird dessen Versions-ID zurückgegeben.
- Sind die 2 WORD aufgebraucht, erscheint das Dokument unter einer neuen Dokument-ID.
- Ab v2 steht im HEAD ein `PARENT` (Inhaltshash der unmittelbar vorherigen Version). Da es in den Inhaltshash eingeht, sind die Versionen zu einer Hashkette verbunden. In der ersten Version steht es nicht.

## Revision

GEUL-Dokumente werden wie Gesetze revidiert.

- **Versionen sind unveränderlich.** Eine veröffentlichte Version wird weder geändert noch gelöscht. Ausnahmen sind nur die rechtliche Löschung und die Löschung von Amts wegen ([TOMBSTONE](/de/grammar/edge/publication/)).
- Die Historie wird nicht gelöscht. Korrekturen erscheinen als neue Version, und die ursprüngliche Version wird nicht überschrieben (Bewahrung des alten Rechts). Eine überarbeitete Version verknüpft sich über [REPLACES](/de/grammar/meta/lineage/replaces/) mit der ursprünglichen.
- Veränderliche Zeiger wie branch, HEAD und reflog stehen nicht im Dokument. Sie werden außerhalb des Dokuments (Repository, Index) verwaltet.
- Eine neue Version kann Definitionen neu einführen, ändern oder streichen. Eine Kompatibilität mit der Vorversion wird nicht zugesichert. Auch die Änderung der Definition desselben Begriffs ist eine Revision (z. B. im koreanischen Zivilgesetz „Volljährigkeit“ 20 Jahre → 19 Jahre; im Strafgesetz das Opfer der Vergewaltigung „Frau“ → „Person“).
- **Die LOCAL ID ist eine Identität über Versionen hinweg** (wie eine Artikelnummer). Dieselbe LOCAL ID verweist auch in verschiedenen Versionen auf dasselbe Objekt.
  - Neueinführung: Es wird eine neue LOCAL ID bezogen. Da IDs keine Reihenfolge bedeuten, braucht es kein Einschieben wie „Artikel X-2“. Die neue Nummer kommt vom `NEXT-LOCAL-ID` der Versionsliste (auto increment).
  - Änderung: Der Inhalt derselben LOCAL ID wird geändert.
  - Streichung: Die LOCAL ID wird in der neuen Version weggelassen. **Eine gestrichene ID wird nicht wiederverwendet.**
  - Verschiebung, Teilung, Zusammenführung: Es wird eine neue LOCAL ID bezogen, und am neuen Record wird per QUALIFIER P1365 (replaces, Wert ist die alte LOCAL ID) die alte ID verknüpft. Da die alte ID nicht wiederverwendet wird, verweist sie auf den Record der früheren Version.
- Auch Werkzeuge, die ein Dokument aus Ausgangsmaterial neu erzeugen, halten diese Regel ein. Eine Aussage, die mit der Vorversion übereinstimmt, behält dieselbe LOCAL ID, und nur geänderte oder neue Aussagen erhalten neue Nummern. Die Nummern dürfen nicht jedes Mal neu ab 1 vergeben werden.
- Ein Zitat legt eine Fassung fest. Ein Zitat mit festgelegter Version bindet an diese Version, ein Zitat auf die neueste (Version `0`) an die zum Zeitpunkt der Interpretation geltende Version. Ein Dokument über vergangene Ereignisse zitiert die Version, die zu diesem Zeitpunkt in Kraft war, mit festgelegter Version.
- Veröffentlichung und Inkrafttreten sind verschieden. Der Veröffentlichungszeitpunkt steht in der Versionsliste, der Geltungszeitraum im Dokument.
  - [EFFECTIVE-FROM](/de/grammar/meta/declaration/effective-from/)/[EFFECTIVE-UNTIL](/de/grammar/meta/declaration/effective-until/): Geltungszeitraum der gesamten Version
  - QUALIFIER P580 (Beginn)/P582 (Ende) am Artikel-Edge: wenn das Inkrafttreten je Artikel abweicht
- **Die zum Zeitpunkt T geltende Fassung ist die höchste Version, deren Inkrafttreten T nicht übersteigt.** Gibt es QUALIFIER P580/P582 je Artikel, haben diese Vorrang. Eine Fassung, deren Gültigkeitsdauer (`EFFECTIVE-UNTIL`) abgelaufen ist, gilt nicht.
- Regeln, die festlegen, welche Fassung anzuwenden ist (Übergangsvorschriften wie „es gelten die bisherigen Vorschriften“, Wahl zwischen dem Recht zur Tatzeit und dem für den Angeklagten günstigeren neuen Recht), übernimmt das Urteil ([TOULMIN](/de/grammar/edge/toulmin/)). Die Inkrafttretensangaben sind dafür das Material.
- Wenn Auslegungsbeispiele oder Urteile die Auslegung eines Begriffs verengen oder erweitern, ist das keine Dokumentrevision, sondern eine Urteilsregel. Wird die Auslegung per Gesetzgebung festgelegt (z. B. Neufassung der Definition von „1 Woche“ im koreanischen Arbeitsstandardgesetz), ist es eine Revision.
- Das Binärlayout (wire) von Codecs und Formatnummern wird nicht revidiert, denn mit Formatnummern kodierte Records werden gelesen, ohne die Codebook-Version festzulegen. Um ein Layout zu ändern, vergibt man eine neue Nummer. Gestrichene Formatnummern werden nicht für andere Formate wiederverwendet.

## Diff-Speicherung

Eine Version wird stets als gesamtes Dokument (Snapshot) definiert. Ein Diff ist nur ein Format, um diesen Snapshot sparsamer zu speichern und zu übertragen.

- Nur Dokumente mit `DOC-ID`, deren BODY ausschließlich aus Edges besteht, können als Diff vorliegen. Für `versions.geul`, `documents.geul` und `issuers.geul`, die nicht versioniert werden, sowie für namenlose Dokumente gibt es keine Diffs.
- Ein Diff-Dokument ist ein gewöhnliches GEUL-Dokument und enthält im HEAD [DELTA-BASE](/de/grammar/meta/lineage/delta-base/) (Basis-Versions-ID).
- Streichungen schreibt man mit [DELTA-REMOVE](/de/grammar/meta/lineage/delta-remove/) (Liste der zu entfernenden LOCAL IDs), Ergänzungen und Revisionen als Edges im BODY. Eine Markierung für Ergänzung oder Revision gibt es nicht. Ist die Edge Id in der Basis vorhanden, ist es eine Revision, sonst eine Ergänzung.
- Die Wiederherstellung des Snapshots muss deterministisch sein (sonst stimmt der Hash nicht).
  1. Der Snapshot der Basisversion wird wiederhergestellt. Ist auch die Basis ein Diff, rekursiv.
  2. Der HEAD wird als Ganzes durch den HEAD des Diffs ohne `DELTA-BASE` und `DELTA-REMOVE` ersetzt. Auch die HEAD-Edges ändern sich damit (sie werden nicht in `DELTA-REMOVE` aufgeführt).
  3. Der BODY behält die Reihenfolge der Basis. Die IDs aus `DELTA-REMOVE` werden entfernt, und eine Edge Id aus dem Diff-BODY, die in der Basis vorhanden ist, ersetzt dort die Stelle.
  4. Edge Ids, die nicht in der Basis vorhanden sind, werden in der Reihenfolge des Diffs hinten angefügt.
  5. Der Inhaltshash des Ergebnisses muss dem Hash dieser Version in der Versionsliste entsprechen. Andernfalls ist es invalid.
- Eine gestrichene LOCAL ID im Diff erneut zu verwenden ist invalid. Auch die Edge Id eines weggefallenen HEAD-Edge wird nicht wiederverwendet.
- Inhaltshash, Versionsliste und Signatur beziehen sich stets auf den wiederhergestellten Snapshot.
