---
title: "Dokument"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "document", "version", "hash"]
summary: "Die Einheit der GEUL-Daten ist ein einzelnes Dokument (DOC)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Die Einheit der GEUL-Daten ist ein einzelnes Dokument (DOC). Eine Datei (`.geul`, Medientyp `application/vnd.geul`) ist ein Dokument.

## Struktur {#구조}

```
DOC-*            ← öffnet das Dokument (Gesamtlänge)
  Meta …         ← HEAD: Records über das Dokument
  SOURCE …       ←   (Herkunft des gesamten Dokuments und ihre QUALIFIER)
BODY             ← beendet den HEAD und öffnet den BODY
  Reference, Value, Edge …
END              ← schließt das Dokument
```

| Record | TAG | Bedeutung |
|---|---|---|
| DOC-1WORD | `1C01` + 1 WORD | öffnet das Dokument mit einer Gesamtlänge von 1 WORD |
| DOC-2WORD | `1C12` + 2 WORD | Gesamtlänge in 2 WORD |
| DOC-4WORD | `1C24` + 4 WORD | Gesamtlänge in 4 WORD |
| BODY | `1C30` | 1 WORD. Beendet den HEAD und beginnt den BODY |
| END | `1C40` | 1 WORD. Schließt das Dokument |

- Der Wert von DOC-* ist die Gesamtzahl der WORD vom Anfang des öffnenden Records bis zum Ende von END. Es wird die schmalste Breite verwendet, in die der Wert passt.
- END ist Pflicht. Stimmt die Position von END nicht mit der Länge von DOC-* überein, wird das Dokument abgelehnt. Endet die Eingabe ohne END, ist das Dokument abgeschnitten.
- Ein Decoder kann anhand der Länge von DOC-* das gesamte Dokument in einem Schritt überspringen.
- Es gibt keine Möglichkeit, ein Dokument mit unbekannter Länge zu öffnen. Echtzeitdaten, deren Ende nicht im Voraus bekannt ist, werden in Einheiten bekannter Länge geteilt und als mehrere Dokumente gesendet.
- Ist der HEAD leer, entfällt der BODY. Ein Dokument ohne BODY-Record besteht ganz aus BODY. Der BODY steht nur einmal. Enthält der HEAD mindestens einen Record (Meta oder HEAD Edge), steht ein BODY.
- Dokumente werden nicht verschachtelt. Andere Dokumente werden über [IMPORT](meta/_index.md) oder eine verweisende Reference angesprochen.

## HEAD und BODY {#head와-body}

- Der HEAD enthält nur Meta und **HEAD Edge**. Beide sind Aussagen über das **Dokument**, das sie enthält.
  - Meta: Struktur, Definition, Herkunft, Abstammung, Verifikation, Richtlinie und IMPORT des Dokuments.
  - HEAD Edge: das Beleg-Edge [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처) (Target `0`), das den Ursprung des gesamten Dokuments angibt, sowie das [QUALIFIER](edge/0x0ABL-qualifier.md), das dieses SOURCE als Target hat (Hash des Originaltexts, Empfangszeit, Bereich im Originaltext usw.). Das QUALIFIER steht hinter diesem SOURCE.
- Der BODY enthält nur Reference, Value und Edge. Die Herkunft einzelner Records wird mit dem Beleg-Edge [SOURCE](edge/0x0C0L-source.md) im BODY geschrieben, andere Belege wie Zuverlässigkeit mit einem QUALIFIER, das an den Record gehängt wird. Ein SOURCE mit Target `0` und ein QUALIFIER, das das HEAD-SOURCE als Target hat, dürfen nicht im BODY stehen.
- Der Decoder liest den HEAD von vorn und trennt dabei. Meta gehört zum HEAD. Ein SOURCE mit Target `0` gehört zum HEAD, und seine Edge Id wird gemerkt. Ein QUALIFIER, das ein gemerktes SOURCE als Target hat, gehört zum HEAD. Kommt ein anderer Record, gilt: Ist der HEAD leer, wurde der BODY ausgelassen (ab diesem Record beginnt der BODY), andernfalls ist es invalid, weil der BODY fehlt.
- **Edge Ids teilen sich in HEAD und BODY einen Nummernraum.** Sie sind im Dokument eindeutig und werden wie die Edges im BODY von [NEXT-LOCAL-ID](meta/0x1DDL-next-local-id.md) bezogen. Ist der Origin eines HEAD Edge LOCAL, steht dessen Definition im BODY (LOCAL gilt im gesamten Dokument).
- Ein Meta kann einen Value-Record in seinem Payload tragen. Der enthaltene Value ist kein eigenständiger Record, sondern Teil dieses Meta.
- Der Geltungsbereich einer Deklaration (Meta-Klasse Definition) ist dieses Dokument.

## Grunddeklarationen {#기본-선언}

Beide Deklarationen kommen höchstens einmal vor. In welchem Dokument sie vorhanden sein müssen, bestimmen die Bedingungen unten.

| Meta | Bedeutung | Dokument, in dem es vorhanden sein muss |
|---|---|---|
| [SPEC-VERSION](meta/0x1C5L-spec-version.md) | Die befolgte Spezifikationsausgabe. Legt fest, wie die übrigen Records gelesen werden. Bei einer unbekannten Ausgabe wird abgelehnt oder gewarnt. Der Wert für v1-Dokumente ist `0x0001` | veröffentlichte Dokumente. Fehlt es, wird mit der dem Decoder bekannten Ausgabe gelesen |
| [DOC-ID](meta/0x1C7L-doc-id.md) | Der Bezeichner des Dokuments selbst. Er muss vorhanden sein, um dieses Dokument und seine Objekte von außerhalb anzusprechen | die versionierten Dokumente (einschließlich Spezifikationsdokumente) unter `docs/<Dokument-ID>/` und `codecs/<Codec ID>/` in `.well-known/geul/`. Nicht in der Versionsliste `versions.geul` und nicht in Listendokumenten (`issuers/`) |

- `SPEC-VERSION` enthält nur eine einzelne ganze Zahl, damit Decoder jeder Ausgabe es lesen können (bei v1 `1C51 0001`). Es stützt sich nicht auf Value-Codes.
- `DOC-ID` ist ein DOC-POINTER (Issuer, Dokument-ID, Version `0`), der auf das Dokument selbst zeigt. Die Dokument-ID umfasst 4 WORD. Codec-Dokumente haben keine Dokument-ID und verwenden einen [CODEC-POINTER](reference/0x042L-codec-pointer.md) (Issuer, Codec ID, Version `0`). Jeder Issuer reserviert die Dokument-IDs `0x0000000000000000` und `0xFFFFFFFFFFFFFFFF` ([Issuer und Veröffentlichung](issuer.md#용어-정의-문서)).
- Ein Dokument ohne `DOC-ID` ist ein namenloses Dokument. Es kann nur über den Inhaltshash angesprochen werden.

## Inhaltshash {#내용-해시}

Eine Ausgabe eines Dokuments wird durch den **Inhaltshash** angesprochen (gleiche Rolle wie die Commit-ID in git).

- Es ist das SHA-256 vom öffnenden Record (DOC-*) bis unmittelbar vor END. 16 WORD.
- Meta der Verifikationsklasse (Signaturen usw., Records mit `C >= 5` in Abschnitt 15, also `w >= 0x1E50`) werden aus der Berechnung ausgenommen. Daher entsteht kein Zirkelbezug, wenn die Signatur im Dokument steht.
- Bei der Berechnung wird die Länge von DOC-* auf die Länge ohne Verifikations-Records gesetzt, und auch die Breite wird auf die schmalste zu dieser Länge passende Breite gesetzt. Deshalb ist der Inhaltshash vor und nach dem Anbringen der Signatur gleich.
- Der Inhaltshash wird nicht im Dokument aufgezeichnet, sondern berechnet. Nur beim Ansprechen einer anderen Version wird er als Wert angegeben (`PARENT` usw.).
- Auch `PARENT` im Dokument geht in die Berechnung ein, sodass der Inhaltshash zu einer Hashkette über die gesamte Historie wird.
- Meta, das außerhalb des Dokuments nachträglich angebracht wird (Anmerkungen in einem getrennten Speicher usw.), ändert den Inhaltshash nicht (wie bei git notes).
- Maßgeblich ist die Binärfassung des Dokuments. Inhaltshash und Signatur werden nur über die Binärfassung berechnet.

## Version {#버전}

Ein benanntes Dokument (ein Dokument mit `DOC-ID`) hat Versionen.

- Die **Versions-ID** ist eine 2-WORD-Ganzzahl, die innerhalb eines Dokuments in der Reihenfolge der Veröffentlichung ab 1 vergeben wird. `0` bedeutet „Version nicht angegeben“ und wird als neueste Version behandelt.
- Die Versions-ID vergibt die Veröffentlichungsstelle bei der Veröffentlichung. Die Zuordnung von Versions-ID zu Inhaltshash steht in der von der Veröffentlichungsstelle signierten Versionsliste ([Veröffentlichungsadresse und Versionsliste](publishing.md#버전-목록)).
- Derselbe Inhalt wird nicht erneut veröffentlicht. Bei einem bereits vorhandenen Inhaltshash wird dessen Versions-ID zurückgegeben.
- Sind die 2 WORD aufgebraucht, wird mit einer neuen Dokument-ID veröffentlicht.
- Ab v2 steht im HEAD `PARENT` (Inhaltshash der unmittelbar vorangehenden Version). Da er in den Inhaltshash eingeht, sind die Versionen zu einer Hashkette verbunden. Die erste Version hat keines.

## Änderung {#개정}

GEUL-Dokumente werden wie Gesetze geändert.

- **Versionen sind unveränderlich.** Eine veröffentlichte Version wird weder geändert noch gelöscht. Ausnahmen sind nur die rechtliche und die von Amts wegen veranlasste Löschung ([TOMBSTONE](edge/0x0BAL-tombstone.md)).
- Die Historie wird nicht gelöscht. Korrekturen erscheinen als neue Version, und die ursprüngliche Version wird nicht überschrieben (Bewahrung des alten Rechts). Eine umgeschriebene Version knüpft mit [REPLACES](meta/0x1D7L-replaces.md) an die ursprüngliche Version an.
- Veränderliche Zeiger wie branch, HEAD oder reflog stehen nicht im Dokument. Sie werden außerhalb des Dokuments (Repository, Index) verwaltet.
- Eine neue Version kann Definitionen neu einführen, ändern und streichen. Kompatibilität mit der Vorversion wird nicht zugesichert. Auch die Änderung der Definition desselben Begriffs ist eine Änderung (Beispiel: im koreanischen Zivilgesetz „Volljährigkeit“ von 20 auf 19 Jahre, im Strafgesetz das Objekt der Vergewaltigung von „Frau“ zu „Person“).
- **Die LOCAL ID ist eine Identität über Versionen hinweg** (wie eine Artikelnummer). Dieselbe LOCAL ID bezeichnet auch in verschiedenen Versionen dasselbe Objekt.
  - Neueinführung: Es wird eine neue LOCAL ID bezogen. Da IDs keine Ordnungsbedeutung haben, sind Einschübe wie „Artikel X-2“ nicht nötig. Neue Nummern werden von `NEXT-LOCAL-ID` der Versionsliste bezogen (auto increment).
  - Änderung: Der Inhalt derselben LOCAL ID wird geändert.
  - Streichung: Die LOCAL ID entfällt in der neuen Version. **Eine gestrichene ID wird nicht wiederverwendet.**
  - Verschiebung, Teilung, Zusammenlegung: Es wird eine neue LOCAL ID bezogen, und am neuen Record wird ein QUALIFIER P1365 (replaces, Wert ist die alte LOCAL ID) angebracht, das an die alte ID anknüpft. Da die alte ID nicht wiederverwendet wird, zeigt sie auf diesen Record der früheren Version.
- Auch Werkzeuge, die ein Dokument aus Quelldaten neu erzeugen, halten diese Regel ein. Gleiche Aussagen wie in der Vorversion erhalten dieselbe LOCAL ID, und nur geänderte oder neue Aussagen erhalten neue Nummern. Die Nummern dürfen nicht jedes Mal von 1 neu vergeben werden.
- Zitate legen eine Ausgabe fest. Ein Zitat mit festgelegter Version ist an diese Version gebunden, ein Zitat der neuesten Version (Version `0`) an die zum Zeitpunkt der Auslegung geltende Version. Ein Dokument über vergangene Ereignisse zitiert mit festgelegter Version die damals geltende Fassung.
- Veröffentlichung und Inkrafttreten sind verschieden. Der Veröffentlichungszeitpunkt steht in der Versionsliste, der Geltungszeitraum im Dokument.
  - [EFFECTIVE-FROM](meta/0x1C8L-effective-from.md) und [EFFECTIVE-UNTIL](meta/0x1C9L-effective-until.md): Geltungszeitraum der gesamten Version
  - QUALIFIER P580 (Beginn) und P582 (Ende) am Artikel-Edge: wenn das Inkrafttreten je Artikel verschieden ist
- **Die zum Zeitpunkt T geltende Ausgabe ist die höchste Version, deren Inkrafttretensdatum T oder früher ist.** Gibt es QUALIFIER P580 und P582 je Artikel, haben diese Vorrang. Eine Ausgabe, deren Geltungsdauer (`EFFECTIVE-UNTIL`) abgelaufen ist, gilt nicht.
- Regeln, die bestimmen, welche Ausgabe anzuwenden ist, etwa Übergangsvorschriften („es gilt das bisherige Recht“) oder die Wahl zwischen dem Recht zur Tatzeit und einem für den Angeklagten günstigeren neuen Recht, überlässt man der Beurteilung ([TOULMIN](toulmin/_index.md)). Die Angaben zum Inkrafttreten sind deren Material.
- Wenn Auslegungsbescheide oder Urteile die Auslegung eines Begriffs verengen oder erweitern, ist das keine Dokumentänderung, sondern eine Beurteilungsregel. Wird die Auslegung durch Gesetzgebung festgelegt (Beispiel: Neueinführung der Definition von „1 Woche“ im Arbeitsstandardgesetz), ist es eine Änderung.
- Das binäre (Wire-)Layout von Codecs und Codec-Nummern wird nicht geändert, denn mit Codec-Nummern kodierte Records werden gelesen, ohne die Codebook-Version festzulegen. Um das Layout zu ändern, wird eine neue Nummer zugewiesen. Eine gestrichene Codec-Nummer wird nicht für ein anderes Format wiederverwendet.

## diff-Speicherung {#diff-저장}

Eine Version wird immer als gesamtes Dokument (Snapshot) definiert. Ein diff ist nur ein Format, um diesen Snapshot platzsparend zu speichern und zu übertragen.

- Nur Dokumente mit `DOC-ID`, deren BODY ausschließlich aus Edges besteht, können als diff vorliegen. Die Versionsliste `versions.geul` ohne `DOC-ID`, Listendokumente (Versionen unter `issuers/`) und namenlose Dokumente haben keinen diff.
- Ein diff-Dokument ist ein gewöhnliches GEUL-Dokument und trägt im HEAD [DELTA-BASE](meta/0x1DBL-delta-base.md) (Basisversions-ID).
- Streichungen werden mit [DELTA-REMOVE](meta/0x1DCL-delta-remove.md) (Liste der zu entfernenden LOCAL IDs) geschrieben, Ergänzungen und Änderungen als Edges im BODY. Eine eigene Markierung für Ergänzung oder Änderung gibt es nicht. Ist die Edge Id in der Basis vorhanden, ist es eine Änderung, sonst eine Ergänzung.
- Die Wiederherstellung des Snapshots muss deterministisch sein (damit der Hash stimmt).
  1. Der Snapshot der Basisversion wird wiederhergestellt. Ist die Basis selbst ein diff, rekursiv.
  2. Der HEAD wird vollständig durch den HEAD des diff ersetzt, abzüglich `DELTA-BASE` und `DELTA-REMOVE`. Auch HEAD Edges werden mit ersetzt (sie werden nicht in `DELTA-REMOVE` geschrieben).
  3. Der BODY behält die Reihenfolge der Basis. Die IDs aus `DELTA-REMOVE` werden entfernt, und ist die Edge Id eines Edge im diff-BODY in der Basis vorhanden, wird sie an dieser Stelle ersetzt.
  4. Edge Ids, die in der Basis nicht vorkommen, werden in der Reihenfolge ihres Auftretens im diff am Ende angefügt.
  5. Der Inhaltshash des Ergebnisses muss dem Hash dieser Version in der Versionsliste entsprechen. Andernfalls ist es invalid.
- Wird eine gestrichene LOCAL ID im diff erneut verwendet, ist es invalid. Auch die Edge Id eines entfallenen HEAD Edge wird nicht wiederverwendet.
- Inhaltshash, Versionsliste und Signatur beziehen sich alle auf den wiederhergestellten Snapshot.
