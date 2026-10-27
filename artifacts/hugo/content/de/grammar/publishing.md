---
title: "Veröffentlichungsadresse und Versionsliste"
weight: 85
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "Ein veröffentlichtes GEUL-Dokument wird unter einer festen Adresse bereitgestellt, die sich aus der ID (Issuer, Dokument-ID, Versions-ID) ergibt, und über eine von der veröffentlichenden Stelle signierte Versionsliste geprüft. Diese Seite regelt ID-Notation, Adresse, Formatangabe, Namensindex, Versionsliste und Vertrauensebenen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL verweist auf Dokumente nicht über String-URLs, sondern über die ID (Issuer, Dokument-ID, Versions-ID). Die Adresse ergibt sich aus der ID. Diese Seite legt die Veröffentlichungsregeln fest, die Encoder, Decoder und Interpreter brauchen, um ineinanderzugreifen. Issuer-Stufen und Offenlegungsweisen regelt [Issuer und Veröffentlichung](/de/grammar/issuer/).

## ID-Notation

IDs in Adressen werden hexadezimal geschrieben.

- Das Präfix ist kleingeschriebenes `0x`, auch die Hex-Ziffern sind klein.
- Die Stellenzahl ist fest: Breite × 4. Führende Nullen werden nicht weggelassen, und die Stellenzahl ist zugleich die Breite.
- Die Issuer-ID wird in der kürzesten Breite geschrieben, in die der Wert passt. Verbreiterte Schreibweisen wie `0x00000005` gibt es nicht (`0x0005`).

| Gegenstand | Breite | Stellen | Beispiel |
|---|---|---|---|
| Issuer | 1 WORD | 4 | `0x0001` |
| Issuer | 2 WORD | 8 | `0x00010000` |
| Issuer | 4 WORD | 16 | `0x0000000100000000` |
| Issuer | 16 WORD | 64 | `0x` + 64 Stellen |
| Dokument-ID | 4 WORD | 16 | `0x0000000000000000` |
| Versions-ID | 2 WORD | 8 | `0x00000003` |
| Inhaltshash | 16 WORD | 64 | `0x` + 64 Stellen |

- Anfragen, die nicht kanonisch sind (`0X`, Großbuchstaben, ausgelassene Nullen), werden mit `301` auf die kanonische Adresse umgeleitet. So sind Cache-Schlüssel und Signaturgegenstand eindeutig.
- Die Regeln der Versions-ID (ab 1, `0` ist die neueste, von der veröffentlichenden Stelle vergeben, bei Erschöpfung neue Dokument-ID) legt [Dokument](/de/grammar/document/#version) fest.

## Veröffentlichungsadresse

```
/.well-known/geul/<Issuer>/<Dokument-ID>.geul              Neueste Version. Per 302 zur kanonischen Adresse (veränderlich)
/.well-known/geul/<Issuer>/<Dokument-ID>/<Versions-ID>.geul    Eine Dokumentfassung (unveränderlich, kanonische Adresse)
/.well-known/geul/<Issuer>/<Dokument-ID>/versions.geul     Versionslisten-Dokument (veränderlich, signiert)
/.well-known/geul/h/<Inhaltshash>.geul                     Abruf über den Inhaltshash (unveränderlich)
```

Beispiel: `/.well-known/geul/0x0001/0x0000000000000000.geul`

- Der Pfad folgt dem `.well-known` von RFC 8615. geul.org und private Veröffentlichungen verwenden denselben Pfad und unterscheiden sich nur in der Domain. Als Suffix wird nur `geul` registriert.
- Dokumentinhalt wird nur von unveränderlichen Adressen ausgeliefert. Die Adresse der neuesten Version liefert keinen Inhalt, sondern leitet per `302` auf die kanonische Adresse dieser Version um.
- Die kanonische Adresse einer Version ist `/<Issuer>/<Dokument-ID>/<Versions-ID>.geul`. Andere Adressen, die denselben Inhalt liefern, verweisen mit `Link: rel=canonical` auf die kanonische Adresse.
- Unveränderliche Adressen dürfen dauerhaft in Cache und CDN liegen. Der Empfänger prüft mit dem Inhaltshash aus der Versionsliste (oder dem Sperrprotokoll).
- IDs beginnen stets mit `0x`. Deshalb überschneiden sich reservierte Namen (`h`, `keys`, `issuers.geul`, `documents.geul`, `versions.geul`) und von Menschen vergebene Namen nicht mit IDs, selbst wenn Letztere wie `add` oder `cafe` nur aus Hex-Zeichen bestehen.
- Der Ort (von welchem Server man abruft) steht nicht im Dokumentinhalt. Stünde er darin, änderte sich der Inhaltshash bei einem Adresswechsel. Den Ort bestimmt die Konfiguration des Empfängers.

### Formatangabe

- Eine Dateiendung legt das Format fest. `.geul` ist binär (`application/vnd.geul`).
- Ohne Dateiendung richtet man sich nach dem `Accept`-Header. Browser erhalten eine HTML-Ansicht, Werkzeuge die Binärform. Beispiel: `/<Issuer>/<Dokument-ID>/<Versions-ID>`
- Die Binärform ist die maßgebliche Fassung eines Dokuments. Inhaltshash und Signatur werden nur über die Binärform berechnet.

### Domainname

Ein Issuer mit Nachweis des Domainbesitzes kann in der Adresse an der Stelle `<Issuer>` statt der ID seine Domain verwenden.

```
/.well-known/geul/<Domain>/<Dokument-ID>.geul              → 302 → /<Issuer>/<Dokument-ID>.geul
/.well-known/geul/<Domain>/<Dokument-ID>/<Versions-ID>.geul    → 302 → /<Issuer>/<Dokument-ID>/<Versions-ID>.geul
/.well-known/geul/<Domain>/<Dokument-ID>/                  → 302 → /<Issuer>/<Dokument-ID>/
```

Beispiel: `/.well-known/geul/geul.org/0x0000000000001018/0x00000001.geul`

- Eine Domainadresse liefert keinen Inhalt, sondern leitet per `302` auf die ID-Adresse um. Kanonische Adresse, Cache-Schlüssel und Signaturgegenstand sind die ID-Adresse. Da sich die Zuordnung ändern kann, verwendet man keine permanente Umleitung.
- Die Domain wird kleingeschrieben, internationalisierte Domains in IDNA-Form (Punycode). Ein abschließender `.` wird nicht angefügt. Ist die Form nicht kanonisch, wird per `301` auf die kanonische Form umgeleitet.
- Eine Domain enthält `.`, deshalb überschneidet sie sich nicht mit IDs, die mit `0x` beginnen, oder mit reservierten Namen.
- Erhält ein Interpreter eine Domainadresse, prüft er die Zuordnung im Issuer-Namensindex, wandelt sie in die ID um und hält diese im Sperrprotokoll fest.
- 16-WORD-Issuer, für die es kein Register gibt, und abgeschottete Netze, die geul.org nicht erreichen, können keine Domainnamen verwenden. Sie nutzen die ID-Adresse.

### Issuer-Name

Der Issuer-Namensindex ist ein einziges Dokument: `/.well-known/geul/issuers.geul`.

```
BODY
  BIND   Subject = ISSUER-POINTER(Issuer)   Name = "geul.org"
  …
```

- Das Subject ist [ISSUER-POINTER](/de/grammar/reference/issuer-pointer/) (der Issuer selbst), und der Name wird per [BIND](/de/grammar/edge/bind/) gebunden.
- Der Name ist eine Domain, für die der Besitz nachgewiesen wurde. Er ist kleingeschrieben, internationalisierte Domains in IDNA (Punycode). Ein Name ist nur an einen Issuer gebunden.
- Den für Menschen lesbaren Anzeigenamen des Issuers (je Sprache) hängt man als beschreibendes [LABEL](/de/grammar/edge/label/) an dasselbe Subject.
- geul.org (GEUL-Issuer) signiert ihn, und Änderungen werden angefügt und nicht korrigiert (dieselbe Kettenregel wie bei der Versionsliste).
- Der reservierte Name `issuers.geul` hat wegen des `.` die Form einer Domain. Auch wenn eine Domain mit diesem Namen entsteht, bleibt dieser Pfad der Issuer-Namensindex.

### Dokumentname

Statt der Dokument-ID kann man auch den Dokumentnamen in der Adresse verwenden. An der Stelle `<Issuer>` steht die ID oder der Domainname.

```
/.well-known/geul/<Issuer|Domain>/<Dokumentname>.geul              → 302 → /<Issuer>/<Dokument-ID>.geul
/.well-known/geul/<Issuer|Domain>/<Dokumentname>/<Versions-ID>.geul    → 302 → /<Issuer>/<Dokument-ID>/<Versions-ID>.geul
/.well-known/geul/<Issuer|Domain>/<Dokumentname>/                  → 302 → /<Issuer>/<Dokument-ID>/
```

Beispiel: `/.well-known/geul/geul.org/publication/0x00000001.geul` → `/0x0000/0x0000000000001018/0x00000001.geul`

**Dokumentnamen bindet der Namensindex des Issuers `/<Issuer>/documents.geul` per BIND.** Der Interpreter ordnet den Namen über diesen Index einer Dokument-ID zu.

```
BODY
  BIND   Subject = DOC-POINTER(Issuer, Dokument-ID, Version 0)   Name = "publication"
  …
```

- Das Subject ist [DOC-POINTER](/de/grammar/reference/doc-pointer/) (Issuer, Dokument-ID, Version `0`). Der Name ist nicht an eine Version, sondern an das Dokument gebunden.
- Der Issuer des Subject muss mit dem Issuer übereinstimmen, der den Index führt. Dokumente anderer Issuer werden ignoriert.
- Namen werden nur an veröffentlichte Dokumente gebunden.
- Ein Dokumentname ist ein ASCII-Slug in Kleinbuchstaben: `a-z`, `0-9`, `-`. Er beginnt und endet nicht mit `-` und beginnt nicht mit `0x`. Deshalb überschneidet er sich nicht mit Dokument-IDs (`0x…`) oder reservierten Namen (`h`, `versions.geul` usw.) ([BIND](/de/grammar/edge/bind/)).
- Innerhalb eines Issuers ist ein Name nur an ein Dokument gebunden, und ein einmal gebundener Name wird nicht für ein anderes Dokument wiederverwendet. Bei einer Umbenennung wird ein neues BIND angefügt. Der alte Name führt weiterhin zum selben Dokument. Kommt derselbe Name mehrfach vor, gilt das letzte BIND.
- Im Dokument steht der eigene Name nicht. Kanonische Adresse, Cache-Schlüssel und Signaturgegenstand sind die ID-Adresse. IMPORT und Zitate im Dokument verwenden nur IDs.
- Ein für Menschen lesbarer Titel (je Sprache) ist kein Name. Man hängt ihn als beschreibendes `LABEL` an.
- Auch im Versionslisten-Dokument kann dasselbe Dokumentnamen-BIND stehen ([PUBLICATION](/de/grammar/edge/publication/#dokumentname)). Steht es dort, muss es mit dem Namensindex übereinstimmen. Der Interpreter liest nur den Namensindex.

### Gelöschte Dokumente

- Die Adresse einer rechtlich oder von Amts wegen gelöschten Version liefert `410 Gone` und einen Grabstein (Versions-ID, Inhaltshash, Löschdatum, Begründungskategorie).
- In der Versionsliste bleibt sie als [TOMBSTONE](/de/grammar/edge/publication/)-Record erhalten.

## Ebenen

GEUL stellt Herkunft, Meta und Listen bis hin zu GEUL-Dokumenten dar. Das Minimum, das zum Lesen nötig ist, ist im Decoder eingebaut und durchbricht den Zirkelbezug. Jede Ebene stützt sich nur auf die darunterliegenden.

| Ebene | Inhalt | Stützt sich auf |
|---|---|---|
| Ebene 0 | Im Decoder eingebaute Regeln: Framing, Inhaltshash, Signaturprüfung, Codecs der Versionslisten-Records (`PUBLICATION`, `DEPRECATION`, `TOMBSTONE`), Vokabular der Codec-Spezifikation (`DECLARE`, `FIELD`, `ENUM`, `CODEC`), [Slot-Marker](/de/grammar/reference/slot-marker/) (`0x0000`~`0x0002`), außerhalb des Dokuments bezogene Vertrauensschlüssel | Nichts. Es wird nichts nachgeschlagen |
| Ebene 1 | Versionslisten-Dokument | Ebene 0 |
| Ebene 2 | Gewöhnliche Dokumente, Codebooks, Codec-Spezifikationsdokumente, Prüfschlüssel-Dokumente der Issuer | Wird über Ebene 1 gefunden und mit Ebene 0 geprüft |

- Keine Ebene stützt sich auf sich selbst oder eine höhere Ebene.
- Man unterscheidet, was sich in GEUL ausdrücken lässt, von dem, was sich nur durch GEUL-Interpretation lesen lässt. Ebene 0 lässt sich zwar in GEUL ausdrücken, braucht zur Interpretation aber keine Nachschlagevorgänge.
- Auch der feste Kern, der sich nicht in TOULMIN-Dokumente umwandeln lässt, wie die Bedeutung des Urteils, hat hier seinen Platz ([TOULMIN](/de/grammar/edge/toulmin/#metakognition-und-selbstrevision)).

## Versionsliste

Die veröffentlichende Stelle führt je Dokument ein Versionslisten-Dokument fort (`/<Issuer>/<Dokument-ID>/versions.geul`). Record-Format und Dokumentstruktur regelt [PUBLICATION](/de/grammar/edge/publication/).

```
DOC-*
  SPEC-VERSION
  PARENT          Inhaltshash des vorherigen Listendokuments
  RECORDED-AT     Zeitpunkt, zu dem diese Liste herausgegeben wurde
  NEXT-LOCAL-ID   Nächste zu vergebende LOCAL ID
  SIGNATURE       Signatur der veröffentlichenden Stelle
BODY
  PUBLICATION     #1  Dokument@1  Inhaltshash
  PUBLICATION     #2  Dokument@2  Inhaltshash
  DEPRECATION     #3  Dokument@1
  …
END
```

| Edge | Bedeutung |
|---|---|
| PUBLICATION | Veröffentlicht eine Version eines Dokuments mit ihrem Inhaltshash |
| DEPRECATION | Markiert eine veröffentlichte Version mit einer Empfehlung zur Einstellung. Sie wird weiter interpretiert |
| TOMBSTONE | Löscht eine veröffentlichte Version (rechtliche Löschung oder Löschung von Amts wegen). Die Begründungskategorie wird angegeben |

- Records werden nur angefügt. Sie werden weder geändert noch gelöscht noch umgeordnet. Auch Deprecation und Löschung werden als angehängte Records festgehalten. Eine neue Liste behält den BODY der vorherigen Liste unverändert am Anfang und fügt Records an; die Listen sind über die `PARENT`-Hashkette verbunden.
- Das bedeutet, dass Veröffentlichungsprotokolle nicht korrigiert werden; es ist etwas anderes als die Revision des Dokumentinhalts ([Dokument](/de/grammar/document/#revision)). Den aktuellen Zustand einer Version berechnet man, indem man die Records der Reihe nach anwendet.
- Versions-IDs laufen lückenlos aufsteigend ab 1. Derselbe Inhalt wird nicht erneut veröffentlicht.
- Die neueste Version ist die höchste Version, die weder zur Einstellung empfohlen noch gelöscht ist.
- In die Records kommt kein Zeitpunkt. Das `RECORDED-AT` der Liste, in der der Record zum ersten Mal steht, ist der Veröffentlichungszeitpunkt.
- Ein Listendokument enthält keine `DOC-ID`. Die Dokument-ID in den Records sagt, wessen Liste es ist.
- Ein Listendokument enthält kein IMPORT und verwendet nur Codecs der Ebene 0.
- Ein Listendokument wird nicht in eine andere Liste aufgenommen (keine Liste von Listen). Frühere Listen werden nur über den Inhaltshash (`h/<Inhaltshash>.geul`) angesprochen, und die Historie wird über die `PARENT`-Kette verbunden.
- Die einzige veränderliche Adresse ist die Adresse der neuesten Liste (`/<Issuer>/<Dokument-ID>/versions.geul`). Ein veränderlicher Zeiger lässt sich nicht als Dokument ausdrücken, daher prüft man mit Signatur, `RECORDED-AT` und `PARENT` der empfangenen Liste.

### Signierende Stelle

| Signatur | Signierende Stelle | Gegenstand |
|---|---|---|
| Dokumentsignatur | Der Issuer des Dokuments | Inhaltshash des Dokuments ([Issuer und Veröffentlichung](/de/grammar/issuer/#signatur)) |
| Listensignatur | Die veröffentlichende Stelle, die die Versions-IDs vergibt | Inhaltshash des Listendokuments |

- Bei Veröffentlichungen bei geul.org vergibt geul.org (GEUL-Issuer) die Versions-IDs und signiert die Liste, bei privaten Veröffentlichungen der jeweilige Issuer.
- Der Autor verantwortet den Inhalt, die veröffentlichende Stelle Nummer und Reihenfolge.

### Prüfung

- Da die Signatur im Inhaltshash nicht enthalten ist, bleibt der Hash auch bei ihrer Entfernung gleich. Deshalb prüft man nicht „wenn eine Signatur vorhanden ist, wird sie geprüft“, sondern „es muss eine Signatur des festgelegten Schlüssels vorhanden sein“. Welche Schlüssel verlangt werden, bestimmen die Vertrauenseinstellungen des Interpreters und das Sperrprotokoll.
- Der Interpreter hält den Inhaltshash der zuletzt gesehenen Liste im Sperrprotokoll fest. Fehlt dieser Hash in der `PARENT`-Kette einer neu empfangenen Liste, wird sie abgelehnt (Schutz vor Zurückspulen und Verzweigung).
- Spiegel und abgeschottete Netze kopieren die Kette der Listendokumente mit. Mit dem öffentlichen Schlüssel lässt sich offline prüfen.
- Ein empfangenes Dokument wird, gleich aus welcher Quelle, über den Inhaltshash geprüft. Der Quelle muss man nicht vertrauen.

## Auflösung von Abhängigkeiten

- Ein Dokument führt abhängige Dokumente im HEAD mit [IMPORT-DOC](/de/grammar/meta/import/import-doc/) auf.
- Eine neue Version sichert keine Kompatibilität mit der Vorversion zu. Deshalb wird die Version eines Dokuments nicht im gesamten Graphen auf eine vereinheitlicht (keine Minimal-Version-Selection).
- Jedes `IMPORT-DOC` ist an die von ihm festgelegte Fassung gebunden. Mehrere Fassungen desselben Dokuments können gemeinsam in einem Graphen vorkommen (ein Urteil, das altes Recht zitiert, und eines, das geltendes Recht zitiert). Verweise werden als (Dokument, Version, LOCAL ID) aufgelöst.
- Ein Import der neuesten Fassung (Version `0`) ist an die zum Zeitpunkt der Interpretation neueste Fassung gebunden. Interpretiert man zu einem festgelegten Zeitpunkt, ist er an die zu diesem Zeitpunkt geltende Fassung gebunden ([Dokument](/de/grammar/document/#revision)).
- Ein per Versions-ID festgelegter Import ist reproduzierbar (der Inhalt einer Versions-ID ist unveränderlich und wird mit dem Sperrprotokoll geprüft).

## Medientyp

- Der Medientyp von GEUL-Dokumenten ist `application/vnd.geul`. Die Dateiendung ist `.geul`.
- Auch bei einem Wechsel in den Standardbaum `application/geul` wird `application/vnd.geul` weiter akzeptiert.

## Offene Fragen

- Bis wohin geul.org Dokumente von 1-, 2-, 4- und 16-WORD-Issuern selbst ausliefert und ab wo es auf die Adresse des Registers verweist. Die Statuscodes dafür (kanonisch 308, neueste 302/307).
- Behandlung auseinanderlaufender Versions-IDs (dieselbe Versions-ID, anderer Inhalt) bei privaten Veröffentlichungen, 16-WORD-Issuern und abgeschotteten Netzen.
- Definition der Textdarstellung und Content Negotiation (je nach `Accept` Binärform, Text oder HTML-Ansicht).
- Das Verhältnis von Dokumentnamen-Index `documents.geul` und Versionslisten-BIND (ob zusammenzulegen), Signatur des Index.
- Aufbau des HEAD sowie Signatur- und Kettenformat von `issuers.geul`. Namensregeln für Issuer ohne Domain (1 und 4 WORD), Behandlung von Namensstreitigkeiten und Längenobergrenze.
- Ob auch 1-WORD-Issuer optional einen Domainnachweis erbringen und Domainnamen verwenden dürfen.
- Zeitpunkt und Format des Wechsels zu einem Merkle-Log (Inklusions- und Konsistenzbeweise) statt der gesamten Kette, wenn die Liste wächst.
- Ein Meta, das im HEAD den Issuer angibt, der den Ort bereitstellt.
