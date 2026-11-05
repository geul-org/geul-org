---
title: "Veröffentlichungsadresse und Versionsliste"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "GEUL verweist auf Dokumente nicht über eine URL-Zeichenkette, sondern über IDs (Issuer, Dokument-ID, Versions-ID)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL verweist auf Dokumente nicht über eine URL-Zeichenkette, sondern über IDs (Issuer, Dokument-ID, Versions-ID). Die Adresse ergibt sich aus den IDs. Diese Seite legt die Veröffentlichungsregeln fest, die nötig sind, damit Encoder, Decoder und Interpreter ineinandergreifen. Die Issuer-Klassen und die Veröffentlichungsarten legt [Issuer und Veröffentlichung](issuer.md) fest.

## ID-Schreibweise {#id-표기}

IDs in Adressen werden hexadezimal geschrieben.

- Das Präfix ist kleines `0x`. Hexadezimalziffern werden mit den Großbuchstaben A-F geschrieben. Der Interpreter setzt auch klein geschriebene Adressen in Großbuchstaben um und sucht damit.
- Die Stellenzahl ist auf Breite × 4 festgelegt. Führende Nullen werden nicht weggelassen, die Stellenzahl ist zugleich die Breite.
- Beim Schreiben einer Adresse wird der Issuer mit der Stellenzahl seiner Vergabebreite geschrieben: 2 WORD 8 Stellen, 4 WORD 16 Stellen, 16 WORD 64 Stellen.
- Beim Lesen werden für den Issuer 8, 16 und 64 Stellen akzeptiert. Eine längere Schreibweise einer kurzen Issuer ID mit vorangestellten Nullen wird als derselbe Issuer gesucht (`0x00000001` und `0x0000000000000001` sind derselbe Issuer, [Issuer und Veröffentlichung](issuer.md#issuer-등급)).

| Gegenstand | Breite | Stellen | Beispiel |
|---|---|---|---|
| Issuer | 2 WORD | 8 | `0x00000001` |
| Issuer | 4 WORD | 16 | `0x0000000100000000` |
| Issuer | 16 WORD | 64 | `0x` + 64 Stellen |
| Codec ID | 2 WORD | 8 | `0x00000AA0` |
| Dokument-ID | 4 WORD | 16 | `0x0000000000000000` |
| Versions-ID | 2 WORD | 8 | `0x00000003` |
| Inhaltshash | 16 WORD | 64 | `0x` + 64 Stellen |

- Die Codec ID eines direkten Codes von GEUL ist sein TAG WORD (L=0) als 32-Bit-Wert (TRIPLE `0x0AAL` → `0x00000AA0`). Das Kind steckt im TAG, daher gibt es keine Überschneidung.
- Codecs im ISSUER-Format eines anderen Issuers liegen unter `codecs/` dieses Issuers mit der Codec-Nummer des Records. Beispiel: IETF CRC32C liegt unter `0x00000007/codecs/0x0000C000/`.
- Die Codec ID eines Issuer-Codecs ist die Codec-Nummer des Records (2 WORD). Ein Issuer vergibt Codec-Nummern innerhalb seines `<Issuer>/codecs/` so, dass sie sich nicht überschneiden, unabhängig vom Kind (Reference, Value, Edge). Die Adresse wird nicht nach Kind aufgeteilt (es gibt keine Ordner wie `references/`, `values/`, `edges/`).
- Weicht das Kind eines Records vom Kind des Ziels von [DECLARE](edge/0x0BBL-declare.md) in seinem Codec-Dokument ab, behandelt der Interpreter das als Fehler.
- Die Veröffentlichung lehnt es ab, unter derselben Codec ID einen anderen Codec abzulegen.
- Die Regeln der Versions-ID (ab 1, `0` ist die neueste, von der Veröffentlichungsstelle vergeben, bei Erschöpfung neue Dokument-ID) legt [Dokument](document.md#버전) fest.

## Veröffentlichungsadresse {#공표-주소}

```
/.well-known/geul/issuers/latest.geul                              Issuer-Liste, neueste
/.well-known/geul/issuers/<Versions-ID>.geul                       Issuer-Liste, bestimmte Version
/.well-known/geul/issuers/versions.geul                            Versionsliste der Issuer-Liste
/.well-known/geul/<Issuer>/codecs/<Codec ID>/latest.geul           Codec, neueste
/.well-known/geul/<Issuer>/codecs/<Codec ID>/<Versions-ID>.geul    Codec, bestimmte Version
/.well-known/geul/<Issuer>/codecs/<Codec ID>/versions.geul         Versionsliste des Codecs
/.well-known/geul/<Issuer>/docs/<Dokument-ID>/latest.geul          Dokument, neueste
/.well-known/geul/<Issuer>/docs/<Dokument-ID>/<Versions-ID>.geul   Dokument, bestimmte Version
/.well-known/geul/<Issuer>/docs/<Dokument-ID>/versions.geul        Versionsliste des Dokuments
/.well-known/geul/<Issuer>/hashes/<Inhaltshash>.geul                Abruf über Inhaltshash
```

Beispiel: `/.well-known/geul/0x00000002/docs/0x0000000000000000/latest.geul`

- Der Pfad folgt `.well-known` aus RFC 8615. geul.org und private Veröffentlichungen verwenden denselben Pfad, nur die Domain ist verschieden. Das zu registrierende Suffix ist nur `geul`.
- Die Issuer-Liste ist `issuers/`. Codecs, allgemeine Dokumente und Hashes liegen unter dem Issuer-Ordner getrennt in `codecs/<Codec ID>/`, `docs/<Dokument-ID>/` und `hashes/`. Auch die Issuer-Liste beginnt bei Version 1 und hat `versions.geul` ([Listendokument](#목록-문서)).
- `latest.geul` ist ein reserviertes Wort und ein Alias. Es wird nicht gespeichert. Es sucht in `versions.geul` an derselben Stelle die jüngste Version und liefert deren Bytes unverändert aus. Es wird nicht umgeleitet. Alle `latest.geul` von Issuer-Liste, Codecs und Dokumenten sind gleich.
- Die kanonische Adresse einer Version ist `/<Issuer>/docs/<Dokument-ID>/<Versions-ID>.geul`. Bei Codecs ist es `/<Issuer>/codecs/<Codec ID>/<Versions-ID>.geul`. Andere Adressen, die denselben Inhalt liefern, verweisen mit `Link: rel=canonical` auf die kanonische Adresse.
- Die Adresse einer bestimmten Version und die Inhaltshash-Adresse sind unveränderlich. Unveränderliche Adressen können dauerhaft in Caches und CDNs liegen. Die empfangende Seite prüft mit dem Inhaltshash der Versionsliste (oder der Sperrdatei).
- Um über den Inhaltshash zu suchen, muss man den Issuer kennen. Eine globale Suche allein über den Hash gibt es nicht.
- Codec-Dokumente haben keine Dokument-ID. Sie verweisen mit einem [CODEC-POINTER](reference/0x042L-codec-pointer.md) (Issuer, Codec ID, Versions-ID) auf sich selbst und ihre Version.
- IDs beginnen immer mit `0x`. Daher überschneiden sich die reservierten Namen (`issuers`, `codecs`, `docs`, `hashes`, `latest.geul`, `versions.geul`) oder von Menschen vergebene Namen nicht mit IDs, auch wenn sie wie `add` oder `cafe` nur aus Hex-Zeichen bestehen.
- Der Ort (von welchem Server man empfängt) gehört nicht in den Dokumentinhalt. Würde man ihn aufnehmen, änderte sich der Inhaltshash, wenn sich die Adresse ändert. Der Ort wird durch die Einstellung der empfangenden Seite bestimmt.

### Veröffentlichungsform und Abruf {#공표-형태와-조회}

- Die Adresse ist eine logische Adresse. Die Veröffentlichungsstelle kann einzelne Dateien oder Packs ausliefern; bei einem Pack kann man nicht direkt über die Adress-URL laden, sondern liest mit einem GEUL-Interpreter.
- Ob als einzelne Datei, Pack oder zstd-Pack gespeichert, es wird über dieselbe Adresse gefunden. Adressen außerhalb der obigen 10 Formen und nicht vorhandene Adressen sind 404 (nicht vorhanden).

Kommandozeilenwerkzeug `geul` ([gogeul](https://github.com/geul-org/gogeul)):

```
geul get <Adresse>     gibt die reine GEUL-Dokument-Binärdatei auf der Standardausgabe aus
geul show <Adresse>    zeigt das Dokument als Text an
```

- `geul get` nimmt `file://`- und `https://`-Adressen an. Adressen außerhalb der 10 Formen und nicht vorhandene Adressen enden mit 404 (nicht vorhanden).

`pkg/resolve` der Go-Bibliothek gogeul hat je Adresse eine Abruffunktion. Alle liefern reine GEUL-Binärdaten (`[]byte`). Da Versions-IDs bei 1 beginnen, ist `Latest` (0) die neueste. Eine nicht vorhandene Adresse ist der Fehler „nicht vorhanden“ (`ErrNotFound`).

```go
const Latest uint32 = 0

Issuers(ctx, v)               / IssuersVersions(ctx)
Codec(ctx, issuer, codec, v)  / CodecVersions(ctx, issuer, codec)
Doc(ctx, issuer, doc, v)      / DocVersions(ctx, issuer, doc)
Hash(ctx, issuer, hash)

ParseAddr(s string) (Addr, error)   // andere Formen als die 10 sind 404 (nicht vorhanden)
Fetch(ctx, Addr) ([]byte, error)    // geul get = ParseAddr → Fetch → Standardausgabe
```

### Formatangabe {#형식-지정}

- Veröffentlichungsadressen enden auf `.geul` und sind binär (`application/vnd.geul`).
- Maßgeblich ist die Binärfassung des Dokuments. Inhaltshash und Signatur werden nur über die Binärfassung berechnet.

### Listendokument {#목록-문서}

Das Listendokument ist die eine Issuer-Liste `issuers/`. Sie verbindet Issuer und Domains ([Issuer-Liste](#issuer-목록)). Sie beginnt bei Version 1 und hat `versions.geul`. Die Dokument-ID der Liste ist die reservierte Dokument-ID `0xFFFFFFFFFFFFFFFF` (Issuer geul.org `0x00000000`). Jeder Issuer reserviert die Dokument-IDs `0x0000000000000000` und `0xFFFFFFFFFFFFFFFF` ([Issuer und Veröffentlichung](issuer.md#용어-정의-문서)).

- `latest.geul` ist ein Alias, der nicht gespeichert wird. Es sucht in `versions.geul` die jüngste Version und liefert deren Bytes.
- PUBLICATION, DEPRECATION und TOMBSTONE in `issuers/versions.geul` verweisen mit einem DOC-POINTER (`0x00000000`, `0xFFFFFFFFFFFFFFFF`, Versions-ID) auf die Listenversion. So weiß man auch bei einem Abruf über `hashes/`, wessen Liste es ist ([PUBLICATION](edge/0x0B8L-publication.md#목록-문서의-버전-목록)).
- Die Dokument-ID `0xFFFFFFFFFFFFFFFF` wird bei keinem Issuer über die Adresse `<Issuer>/docs/<Dokument-ID>/` ausgeliefert (404). Die andere reservierte Dokument-ID `0x0000000000000000` ist das Begriffsdefinitions-Indexdokument dieses Issuers und liegt unter `docs/` ([Issuer und Veröffentlichung](issuer.md#용어-정의-문서)).
- Ein Listendokument hat keine `DOC-ID`. Wessen Liste es ist, sagt der DOC-POINTER in den Records ([DOC-ID](meta/0x1C7L-doc-id.md)).
- Dokumente und Codecs werden ohne Liste direkt über die aus den Records berechnete ID gefunden ([Dokumentname](#문서-이름)).

### Domainname {#도메인-이름}

Ein Domainname ist keine Veröffentlichungs-URL. Eine Adresse, die an der Stelle `<Issuer>` eine Domain oder an der Stelle einer ID einen Namen verwendet, liegt außerhalb der obigen 10 Formen und ist 404 (nicht vorhanden). Auch eine Umleitung von einem Namen auf eine ID-Adresse gibt es nicht.

- Der Domainname ist eine Eingabe von Interpreter und CLI. Der Interpreter wandelt die Domain über BIND in der Issuer-Liste `issuers/` in eine Issuer ID um. Die umgewandelte ID wird in der Sperrdatei festgehalten. Eine Adresse nach Dokumentname gibt es nicht ([Dokumentname](#문서-이름)).
- Kanonische Adresse, Cache-Schlüssel und Signaturgegenstand sind die ID-Adresse.
- Domains werden klein geschrieben, internationalisierte Domains in IDNA-Form (punycode). Ein abschließender `.` wird nicht angehängt.
- 16-WORD-Issuer ohne Registrierung und luftgetrennte Umgebungen, die geul.org nicht erreichen, können Domainnamen nicht verwenden. Sie verwenden die ID.

### Issuer-Liste {#issuer-목록}

Die Issuer-Liste ist ein Dokument unter `/.well-known/geul/issuers/` (die neueste ist `issuers/latest.geul`). Sie verbindet Issuer und ihre Namen (Domains).

```
BODY
  BIND   Subject = ISSUER-POINTER(Issuer)   Name = "geul.org"
  …
```

- Das Subject ist ein [ISSUER-POINTER](reference/0x040L-issuer-pointer.md) (der Issuer selbst), und der Name wird per [BIND](edge/0x0A3L-bind.md) gebunden.
- Der Name ist eine Domain, die den Nachweis des Domainbesitzes durchlaufen hat. Er ist klein geschrieben, internationalisierte Domains werden in IDNA (punycode) geschrieben. Ein Name ist an nur einen Issuer gebunden.
- Der für Menschen lesbare Anzeigename des Issuers (je Sprache) wird am selben Subject als beschreibendes [LABEL](edge/0x0A4L-label.md) angefügt.
- Sie wird von geul.org (GEUL-Issuer) signiert, bei Änderungen wird angehängt und nicht korrigiert (dieselbe Kettenregel wie bei Versionslisten).

### Dokumentname {#문서-이름}

**Eine Adresse nach Dokumentname gibt es nicht.** Dokumente und Codecs werden über IDs gefunden.

- Es gibt keinen Index, der Dokumentnamen oder Codec-Namen in IDs umwandelt. Auch in der Versionsliste steht kein [BIND](edge/0x0A3L-bind.md) für den Dokumentnamen ([PUBLICATION](edge/0x0B8L-publication.md#버전-목록-문서)).
- Einen Index zum Durchstöbern durch Menschen erstellt ein Werkzeug (Viewer) aus dem Pack-Inventar.
- Kanonische Adresse, Cache-Schlüssel und Signaturgegenstand sind die ID-Adresse. IMPORT und Zitate in Dokumenten erfolgen nur über IDs.
- Der für Menschen lesbare Titel (je Sprache) wird als beschreibendes [LABEL](edge/0x0A4L-label.md) angefügt.

### Gelöschte Dokumente {#삭제된-문서}

- Auch die Adresse einer durch eine rechtliche oder eine von Amts wegen veranlasste Löschung verworfenen Version (TOMBSTONE) ist wie andere nicht vorhandene Adressen 404 (nicht vorhanden).
- Eine Version, für die eine Empfehlung zur Einstellung der Nutzung ausgesprochen wurde (DEPRECATION), ist nicht 404. Sie wird über diese Versionsadresse weiter ausgeliefert.
- Die Löschung bleibt in der Versionsliste als [TOMBSTONE](edge/0x0BAL-tombstone.md)-Record (DOC-POINTER dieser Version, Begründungskategorie).

## Schicht {#층}

GEUL stellt auch Herkunft, Meta und Listen als GEUL-Dokumente dar. Das zum Lesen nötige Minimum ist im Decoder eingebaut, um den Zirkelbezug zu durchbrechen. Jede Schicht stützt sich nur auf die darunterliegenden Schichten.

| Schicht | Inhalt | Stützt sich auf |
|---|---|---|
| Schicht 0 | im Decoder eingebaute Regeln: Framing, Inhaltshash, Signaturprüfung, Record-Codecs der Versionsliste (`PUBLICATION`, `DEPRECATION`, `TOMBSTONE`), Vokabular der Codec-Spezifikation (`DECLARE`, `FIELD`, `ENUM`, `CODEC`), [Slot-Marker](slot-marker.md) (`0x0000`, `0x0010`, `0x0020`), von außerhalb des Dokuments empfangene Vertrauensschlüssel | nichts. Wird nicht abgerufen |
| Schicht 1 | Versionslisten-Dokumente | Schicht 0 |
| Schicht 2 | allgemeine Dokumente, Codebooks, Codec-Spezifikationsdokumente, Prüfschlüssel-Dokumente der Issuer | wird über Schicht 1 gefunden und mit Schicht 0 geprüft |

- Keine Schicht stützt sich auf sich selbst oder auf eine höhere Schicht.
- Zu unterscheiden ist, was in GEUL dargestellt wird, und was nur durch Interpretation mit GEUL lesbar ist. Schicht 0 lässt sich in GEUL darstellen, braucht für die Interpretation aber keinen Abruf.
- Auch der feste Kern, der sich nicht in TOULMIN-Dokumente umwandeln lässt, etwa die Bedeutung einer Beurteilung, liegt an dieser Stelle ([TOULMIN](toulmin/_index.md#메타-인지와-자기-개정)).

## Versionsliste {#버전-목록}

Die Veröffentlichungsstelle führt für jedes Dokument ein Versionslisten-Dokument fort (`/<Issuer>/docs/<Dokument-ID>/versions.geul`, bei Codecs `/<Issuer>/codecs/<Codec ID>/versions.geul`, bei der Issuer-Liste `issuers/versions.geul`). Record-Format und Dokumentstruktur legt [PUBLICATION](edge/0x0B8L-publication.md) fest.

```
DOC-*
  SPEC-VERSION
  PARENT          Inhaltshash der unmittelbar vorangehenden Versionsliste
  RECORDED-AT     Zeitpunkt, zu dem diese Liste herausgegeben wurde
  NEXT-LOCAL-ID   nächste zu vergebende LOCAL ID
  SIGNATURE       Signatur der Veröffentlichungsstelle
BODY
  PUBLICATION     #1  Dokument@1  Inhaltshash
  PUBLICATION     #2  Dokument@2  Inhaltshash
  DEPRECATION     #3  Dokument@1
  …
END
```

| Edge | Bedeutung |
|---|---|
| PUBLICATION | veröffentlicht eine Version des Dokuments mit ihrem Inhaltshash |
| DEPRECATION | kennzeichnet an einer veröffentlichten Version eine Empfehlung zur Einstellung der Nutzung. Wird weiter interpretiert |
| TOMBSTONE | löscht eine veröffentlichte Version (rechtliche und von Amts wegen veranlasste Löschung). Die Begründungskategorie wird angegeben |

- Records werden nur angehängt. Es wird nichts geändert, gelöscht oder umsortiert. Auch Deprecate und Löschen hängen Records an. Eine neue Liste stellt den BODY der vorherigen Liste unverändert voran und hängt Records an, und die Listen sind über die `PARENT`-Hashkette verbunden.
- Gemeint ist, dass Veröffentlichungsaufzeichnungen nicht korrigiert werden; das ist etwas anderes als die Änderung des Dokumentinhalts ([Dokument](document.md#개정)). Der aktuelle Zustand einer Version wird berechnet, indem die Records der Reihe nach angewendet werden.
- Versions-IDs sind lückenlos aufsteigend ab 1. Derselbe Inhalt wird nicht erneut veröffentlicht.
- Die neueste Version ist die höchste Version, die weder zur Einstellung empfohlen noch gelöscht ist.
- In Records steht keine Zeitangabe. Der Veröffentlichungszeitpunkt ist `RECORDED-AT` der Liste, in der der Record erstmals erschien.
- Eine Versionsliste hat keine `DOC-ID`. Wessen Liste es ist, sagt der DOC-POINTER in den Records (Dokument-ID, bei der Issuer-Liste die reservierte Dokument-ID).
- Eine Versionsliste enthält kein IMPORT und verwendet nur Codecs der Schicht 0. Im BODY stehen nur PUBLICATION, DEPRECATION und TOMBSTONE.
- Vergangene Versionslisten werden nur über den Inhaltshash (`<Issuer>/hashes/<Inhaltshash>.geul`) angesprochen, und die Historie wird über die `PARENT`-Kette verbunden.
- Veränderliche Adressen sind `latest.geul` und `versions.geul`. Da veränderliche Zeiger nicht als Dokumente erzeugt werden können, werden sie mit Signatur, `RECORDED-AT` und `PARENT` der empfangenen Liste geprüft.

### Signierende Stelle {#서명-주체}

| Signatur | Signierende Stelle | Gegenstand |
|---|---|---|
| Dokumentsignatur | der Issuer des Dokuments | Inhaltshash des Dokuments ([Issuer und Veröffentlichung](issuer.md#서명)) |
| Listensignatur | die Veröffentlichungsstelle, die die Versions-IDs vergeben hat | Inhaltshash der Versionsliste |

- Bei einer Veröffentlichung bei geul.org vergibt geul.org (GEUL-Issuer) die Versions-IDs und signiert die Liste, bei einer privaten Veröffentlichung der jeweilige Issuer.
- Der Autor verantwortet den Inhalt, die Veröffentlichungsstelle Nummer und Reihenfolge.

### Verifikation {#검증}

- Da Signaturen aus dem Inhaltshash herausfallen, bleibt der Hash auch beim Löschen unverändert. Daher wird nicht mit „wenn eine Signatur da ist, wird sie geprüft“ verifiziert, sondern mit „es muss eine Signatur des festgelegten Schlüssels vorhanden sein“. Welche Schlüssel verlangt werden, bestimmen die Vertrauenseinstellung des Interpreters und die Sperrdatei.
- Der Interpreter hält den Inhaltshash der zuletzt gesehenen Liste in der Sperrdatei fest. Steht dieser Hash nicht in der `PARENT`-Kette einer neu empfangenen Liste, wird sie abgelehnt (Schutz vor Zurückspulen und Verzweigung).
- Spiegel und luftgetrennte Umgebungen kopieren die Versionslisten-Kette mit. Mit nur dem öffentlichen Schlüssel wird offline verifiziert.
- Ein empfangenes Dokument wird, gleich aus welcher Quelle, über den Inhaltshash verifiziert. Der Quelle muss man nicht vertrauen.

## Auflösung von Abhängigkeiten {#의존성-해석}

- Ein Dokument gibt abhängige Dokumente im HEAD mit [IMPORT-DOC](meta/0x1E4L-import-doc.md) an.
- Eine neue Version sichert keine Kompatibilität mit der Vorversion zu. Daher wird die Version eines Dokuments im gesamten Graphen nicht auf eine vereinheitlicht (Minimal Version Selection wird nicht verwendet).
- Jedes `IMPORT-DOC` ist an die von ihm festgelegte Ausgabe gebunden. Mehrere Ausgaben desselben Dokuments können gemeinsam in einem Graphen stehen (ein Urteil, das altes Recht zitiert, und ein Urteil, das geltendes Recht zitiert). Verweise werden über (Dokument, Version, LOCAL ID) aufgelöst.
- Ein Import der neuesten (Version `0`) ist an die zum Zeitpunkt der Auslegung neueste Ausgabe gebunden. Wird zu einem bestimmten Zeitpunkt ausgelegt, ist er an die zu diesem Zeitpunkt geltende Ausgabe gebunden ([Dokument](document.md#개정)).
- Ein per Versions-ID festgelegter Import ist reproduzierbar (der Inhalt einer Versions-ID ist unveränderlich und wird über die Sperrdatei verifiziert).

## Medientyp {#미디어-타입}

- Der Medientyp von GEUL-Dokumenten ist `application/vnd.geul`. Die Dateierweiterung ist `.geul`.
- Auch bei einem Umzug in den Standardbaum `application/geul` wird `application/vnd.geul` weiter akzeptiert.

## Offene Probleme {#열린-문제}

- Umgang damit, wenn sich Versions-IDs bei privater Veröffentlichung, 16-WORD-Issuern und luftgetrennten Umgebungen aufspalten (gleiche Versions-ID, anderer Inhalt).
- HEAD-Aufbau sowie Signatur- und Kettenformat der Issuer-Liste `issuers/`. Namensregeln für Issuer ohne Domain (4 WORD), Behandlung von Namensstreitigkeiten und Längenobergrenze.
- Zeitpunkt und Format des Wechsels von der gesamten Kette zu einem Merkle-Log (Inklusions- und Konsistenzbeweis), wenn die Liste wächst.
- Ein Meta, das im HEAD den Issuer angibt, der den Ort bereitstellt.
