---
title: "Issuer und Veröffentlichung"
weight: 80
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "Ein Issuer ist die Instanz, die Dokumente und Formate definiert. Je nach Breite (1, 2, 4, 16 WORD) unterscheidet sich die Vergabe. Diese Seite regelt die Issuer-Stufen, die 1-WORD-Zuweisungstabelle, die Offenlegung von Dokumenten sowie Signatur und Prüfschlüssel."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL bündelt das Identifikationssystem nicht an einer Stelle. Jeder Issuer definiert Objekte und Formate, und andere Dokumente verwenden die veröffentlichten Definitionen. Definitionen können vertraulich bleiben, bei geul.org (CC0) oder privat veröffentlicht werden (unter der vom Issuer festgelegten Lizenz). Welchen Definitionen man vertraut, entscheiden die Nutzer.

Veröffentlichungsadresse, Formatangabe, Namensindex, Versionsliste und Vertrauensebenen regelt [Veröffentlichungsadresse und Versionsliste](/de/grammar/publishing/).

## Was ein Issuer definiert

| Gegenstand | Methode |
|---|---|
| Objekte (Entitäten, Konzepte, Begriffe) | Werden als LOCAL im eigenen Dokument deklariert |
| Value-Formate | Werden unter dem Issuer-Code per Formatnummer definiert |
| Edge-Formate | Werden unter dem Issuer-Code per Formatnummer definiert |

- Auch die Definition von Value- und Edge-Formaten wird als Dokument veröffentlicht.

## Grundsätze

- Alle IDs gelten im Dokument. LOCAL IDs (einschließlich Edge Ids und Variablen) und IMPORT IDs sind nur innerhalb dieses Dokuments gültig.
- Ein vom Issuer definiertes Objekt ist ein LOCAL im vom Issuer veröffentlichten Dokument. Andere Dokumente zitieren es direkt über die Zeiger-Deklaration (`EXTERNAL-ISSUER-*`) oder importieren es mit `IMPORT-DOC` und verweisen mit `EXTERNAL-POINTER-*` darauf.
- Für Objekte, auf die von außerhalb eines Dokuments verwiesen werden muss, wird ein LOCAL eines veröffentlichten Dokuments vergeben. Dieses Dokument muss eine [DOC-ID](/de/grammar/meta/declaration/doc-id/) haben.

## Issuer-Stufen

| Breite | Wertebereich | Vergabe |
|---|---|---|
| 1 WORD | `0x0000`~`0xFFFF` | geul.org weist sie Normungsorganisationen und wichtigen Institutionen zu ([1-WORD-Zuweisungstabelle](#1-word-zuweisungstabelle)) |
| 2 WORD | `0x00010000`~`0xFFFFFFFF` | Registrierung bei geul.org. Mit Nachweis des Domainbesitzes |
| 4 WORD | `2^32`~`2^64−1` | Registrierung bei geul.org. Ohne Besitznachweis |
| 16 WORD | ab `2^64` | Selbst ausgestellt. Aus dem öffentlichen Schlüssel berechnet |

- **Die Issuer-ID ist ein ganzzahliger Wert.** Gleicher Wert bedeutet gleicher Issuer (`0x0001` und `0x00000001` sind derselbe Wert). Die Breite ist nicht Teil der Kennung.
- **Die kanonische Form ist die kürzeste Breite.** Man schreibt die kürzeste Breite, in die der Wert passt, und lehnt breitere Schreibweisen ab. Deshalb beginnt die Vergabe jeder Breite mit dem Wert nach dem Ende des Bereichs der nächstschmaleren Breite (2 WORD ab `0x00010000`).

## 1-WORD-Zuweisungstabelle

1-WORD-Issuer weist geul.org Normungsorganisationen und wichtigen Institutionen zu. Von GEUL entworfene eigene Formate stehen unter `GEUL`, De-facto-Standards oder Konventionsformate ohne normsetzende Organisation unter `ADHOC`.

| Issuer | Name | Organisation | Typische Formate |
|---|---|---|---|
| `0x0000` | GEUL | geul.org | GEUL-eigene Formate, Codebook |
| `0x0001` | ADHOC | geul.org | Konventionsformate ohne normsetzende Organisation. BFLOAT16, BLAKE3, komplexe Zahlen, Brüche, Intervalle, Quaternionen, Vektoren, Tensoren |
| `0x0002`~`0x000F` | reserviert | | |
| `0x0010` | ISO | International Organization for Standardization | ISO 8601, ISO 4217 (Währungen), ISO 3166 (Länder) |
| `0x0011` | IEC | International Electrotechnical Commission | IEC 80000 (Einheitennotation) |
| `0x0012` | ISO-IEC-JTC1 | ISO/IEC Joint Technical Committee 1 | ISO/IEC-Normen der Informationstechnik |
| `0x0013` | ITU-T | ITU Telecommunication Standardization Sector | X.509, X.690 (ASN.1-Kodierung) |
| `0x0014`~`0x001F` | reserviert | Internationale Normungsorganisationen | |
| `0x0020` | IETF | Internet Engineering Task Force | URI (RFC 3986), UUID (RFC 9562), CRC32C, IPv4/IPv6 |
| `0x0021` | IANA | Internet Assigned Numbers Authority | Medientypen, Register der Sprach-Subtags |
| `0x0022` | W3C | World Wide Web Consortium | XML-Schema-Datentypen, RDF |
| `0x0023` | WHATWG | Web Hypertext Application Technology Working Group | URL, HTML |
| `0x0024` | UNICODE | Unicode Consortium | Zeichenkodierung, Normalisierung, CLDR |
| `0x0025` | ECMA | Ecma International | JSON (ECMA-404) |
| `0x0026`~`0x003F` | reserviert | Internet- und Web-Normungsorganisationen | |
| `0x0040` | IEEE | Institute of Electrical and Electronics Engineers | IEEE-754-Gleitkomma/-decimal, MAC-Adresse (802) |
| `0x0041` | KHRONOS | Khronos Group | Pixelformate (RGBA8/BGRA8 UNORM), glTF |
| `0x0042` | OGC | Open Geospatial Consortium | Koordinaten, Bounding Box, GeoJSON-Familie |
| `0x0043` | ONNX | ONNX (LF AI & Data Foundation) | FP8 E4M3FN/E4M3FNUZ/E5M2/E5M2FNUZ |
| `0x0044` | OCP | Open Compute Project | Microscaling-Formate (E8M0, FP4 E2M1) |
| `0x0045` | OASIS | OASIS Open | Dokument- und Sicherheitsstandards |
| `0x0046`~`0x005F` | reserviert | Industrielle Normungsorganisationen | |
| `0x0060` | BIPM | Bureau International des Poids et Mesures | SI-Einheiten, TAI |
| `0x0061` | IERS | International Earth Rotation and Reference Systems Service | Schaltsekunden, UTC−TAI |
| `0x0062` | NIST | National Institute of Standards and Technology | SHA-2 (FIPS 180-4), SHA-3 (FIPS 202) |
| `0x0063` | GPS | Betreiber des GPS auf staatlicher Seite | GPS-Zeit |
| `0x0064`~`0x00FF` | reserviert | Mess- und Regierungsbehörden | |
| `0x0100` | KATS | Korean Agency for Technology and Standards | KS-Normen |
| `0x0101`~`0x01FF` | reserviert | Nationale Normungsbehörden | |
| `0x0200`~`0xFFFF` | reserviert | Spätere Vergabe | |

- Erweiterte Formate stehen unter dem Issuer der Organisation, die das Format festgelegt hat. Die Formatnummern unter einem Issuer definiert der jeweilige Issuer.
- Die oberen Bits der Formatnummer müssen den Familienregeln des jeweiligen Kind folgen. Nur so kennt man die Familie ohne Codebook.
- Verwaltet eine Normungsorganisation GEUL-Formatnummern nicht selbst, trägt geul.org deren Normen stellvertretend mit Nummern ein. Die Nummer wird zusammen mit der Kennung des Normdokuments festgehalten.
- Die Vergabe erfolgt innerhalb des Bereichs einer Organisationsgruppe mit den niedrigsten Nummern zuerst. Die Bereiche dienen der Einteilung; ein Decoder muss sie nicht interpretieren.

## 16-WORD-Issuer

```
Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ Signaturalgorithmus-ID (2 Bytes) ‖ öffentlicher Schlüssel)
```

- Das Ergebnis von 32 Bytes wird ab dem oberen Byte in 16 WORD geschrieben.
- Jeder kann ihn ohne Registrierung erzeugen. Der Besitz wird durch die Signatur mit dem zugehörigen privaten Schlüssel nachgewiesen.
- Öffentlicher Schlüssel und Algorithmus werden im HEAD des Dokuments mit [ISSUER-KEY](/de/grammar/meta/verification/issuer-key/) deklariert. Der Signaturalgorithmus `0x0001` ist Ed25519, andere Werte sind reserviert.
- Das Präfix `GEUL-ISSUER-v1` sorgt dafür, dass bei Verwendung desselben Schlüssels für einen anderen Zweck nicht dieselbe ID entsteht (Zweckbindung).
- Auch wenn sich der Signaturalgorithmus ändert (z. B. Ed25519 → ML-DSA), bleibt die ID-Breite bei 16 WORD.
- Liegt das Ergebnis unter `2^64` (die Wahrscheinlichkeit ist praktisch null), wird mit diesem Schlüssel kein Issuer erzeugt, weil es sich mit der Regel der kürzesten Breite überschneidet.

## Domainnachweis

- Der Nachweis des Domainbesitzes eines 2-WORD-Issuers wird nur zum Zeitpunkt der Registrierung geprüft. Die spätere Domainverwaltung liegt in der Verantwortung des Issuers.
- Eine Domain entspricht nur einem Issuer. Ein Issuer kann mehrere Domains haben. Die Zuordnung steht per BIND im Issuer-Namensindex `issuers.geul` ([Veröffentlichungsadresse und Versionsliste](/de/grammar/publishing/#issuer-name)).
- Läuft die Domain ab oder wechselt sie den Inhaber, bleibt die Zuordnung beim zuerst nachgewiesenen Issuer. Der neue Inhaber kann diese Domain nicht als Issuer-Namen verwenden.
- Der Domainname dient der Adresseingabe und Anzeige. In GEUL-Dokumenten steht nur die Issuer-ID.

## Begriffsdefinitionsdokumente

- Vom Issuer definierte Begriffe (Werkzeuge, Programme, Rollen, Konzepte innerhalb einer Organisation) liegen **als ein Dokument je Begriff** vor. Der Begriff ist das LOCAL dieses Dokuments, der Name wird per [BIND](/de/grammar/edge/bind/) und das verwiesene externe Objekt (URI usw.) per [REFERENCE-NODE](/de/grammar/edge/reference-node/) verbunden.
- Andere Dokumente verweisen mit `EXTERNAL-ISSUER-*` (Issuer, Dokument-ID, LOCAL ID) auf den Begriff. Dieselbe Definition wird nicht in jedem Dokument wiederholt. Beispiel: Das Werkzeug in [TRANSFORMED-BY](/de/grammar/meta/lineage/transformed-by/).
- Den Bereich der Dokument-IDs für Begriffsdefinitionsdokumente legt der Issuer fest. geul.org (`0x0000`) verwendet `0x0001xxxx xxxxxxxx` ([Codec-Spezifikationsdokument](/de/grammar/codec-spec/#dokument-id-des-geul-issuers)).
- Die Dokument-ID `0x0000000000000000` jedes Issuers ist für dessen **Begriffsdefinitions-Indexdokument** reserviert: `<Issuer>/0x0000000000000000/`. Hier werden die Begriffsdefinitionsdokumente aufgelistet.
- Das Indexdokument wird allen Issuern **empfohlen**. Es ist nicht verpflichtend. Gibt es keinen Index, findet man Begriffsdefinitionsdokumente über den Namensindex `documents.geul`.
- Reihenfolge beim Verweis auf externe Objekte: (1) Gibt es einen passenden Reference-Codec, nimmt man ihn (WIKIDATA-QID usw.); (2) gibt es ein GEUL-Dokument, das das Objekt definiert, nimmt man dieses (DOC-POINTER, EXTERNAL-ISSUER); (3) andernfalls definiert man es als LOCAL im eigenen Begriffsdefinitionsdokument und verweist darauf.

## Offenlegung von Dokumenten

| Weise | Gilt für | Lizenz | Versionsverwaltung | Bestand |
|---|---|---|---|---|
| Vertraulich | Alle Issuer | Intern beim Issuer | Issuer | Hängt vom Issuer ab |
| Veröffentlichung bei geul.org | 1- und 2-WORD-Issuer | CC0 | geul.org | geul.org bewahrt sie auf |
| Private Veröffentlichung | Alle Issuer | Vom Issuer festgelegt | Issuer | Hängt vom Issuer ab |

### Veröffentlichung bei geul.org

- 1- und 2-WORD-Issuer können Dokumente bei geul.org registrieren und veröffentlichen. Registrierte Dokumente stehen unter CC0.
  - 1-WORD-Issuer veröffentlichen nach vorheriger Prüfung durch geul.org.
  - 2-WORD-Issuer werden mit der Registrierung sofort veröffentlicht, Probleme werden nachträglich behandelt.
- Veröffentlicht werden können Konzepte und Codecs. **Ein Reference, das auf eine natürliche Person verweist, darf nicht bei geul.org veröffentlicht werden.** Dafür gilt vertraulich oder private Veröffentlichung.
  - Ausnahme: Der Verweis auf natürliche Personen über [WIKIDATA-QID](/de/grammar/reference/wikidata-qid/) ist zulässig.
- Registrierte Versionen werden weder geändert noch gelöscht, und das Dokument bleibt auch bestehen, wenn der Issuer verschwindet (Bewahrung des alten Rechts). Ausnahmen sind die rechtliche Löschung und die Löschung von Amts wegen ([TOMBSTONE](/de/grammar/edge/publication/)).
- Ein Issuer kann in einer Definition nur eine Empfehlung zur Einstellung (deprecated) markieren. Auch empfohlen eingestellte Definitionen werden weiter interpretiert.
- Eine neue Version desselben Dokuments kann Definitionen neu einführen, ändern oder streichen ([Dokument](/de/grammar/document/#revision)). **Gestrichene Entitäts-IDs und Formatnummern werden für andere Objekte nicht wiederverwendet.** Das wire-Layout einer Formatnummer wird nicht revidiert.

### Private Veröffentlichung

- Ein Issuer, der unter einer anderen Lizenz als CC0 veröffentlichen will, stellt seine Dokumente in einem privaten Netz (eigene Domain usw.) bereit. Die Lizenz wird im HEAD des Dokuments mit [LICENSE](/de/grammar/meta/policy/license/) deklariert.
- Auch die private Veröffentlichung verwendet dieselben Pfade wie geul.org ([Veröffentlichungsadresse und Versionsliste](/de/grammar/publishing/)).
- Versionsverwaltung, Verfügbarkeit, Domainpflege und Lizenzbedingungen legt der Issuer fest. geul.org wirkt bei privaten Veröffentlichungen nicht mit und übernimmt keine Gewähr.

### Vertraulich

- Vertrauliche Dokumente werden nicht veröffentlicht. Sie werden mit Zugriffskontrolle versehen und mit [ACCESS](/de/grammar/meta/policy/access/) gekennzeichnet.
- Wird ein Dokument, das vertrauliche Definitionen verwendet, nach außen gesendet, kann der Empfänger dessen Reference, Value und Edge nicht interpretieren und überspringt sie. Definitionen, die mit Externen ausgetauscht werden sollen, werden veröffentlicht.

### Wahl der Nutzer

- Nutzer wählen die Dokumente, die sie verwenden, anhand der deklarierten Lizenz und der Bestandsaussichten des Issuers.
- Definitionen mit übermäßig restriktiven Lizenzen oder von Issuern mit unsicherem Fortbestand werden nicht verwendet.
- Für Verweise, die lange erhalten bleiben müssen, nutzt man bei geul.org veröffentlichte Dokumente.

## Signatur

- Die Signatur ist bei veröffentlichten Dokumenten Pflicht. Sie steht als [SIGNATURE](/de/grammar/meta/verification/signature/) im HEAD. Auch ein Dokument ohne Signatur ist ein gültiges GEUL-Dokument, und auch vertrauliche und interne Dokumente werden möglichst signiert.
- Gegenstand der Signatur ist der **Inhaltshash** des Dokuments ([Dokument](/de/grammar/document/#inhaltshash)). Es wird nicht nur der BODY signiert.
  - Der HEAD enthält Interpretationsregeln. Ändert man das Ziel von `IMPORT-DOC`, verweist derselbe BODY auf ein anderes Ziel.
  - Signiert man `LICENSE` und `PARENT` nicht, lassen sich Lizenz und Historie fälschen.
- In einem Dokument können mehrere Signaturen stehen. Da alle denselben Inhaltshash signieren, ändert sich der Inhaltshash durch weitere Signaturen nicht.
- Prüfung des Signaturschlüssels:
  - 1-, 2- und 4-WORD-Issuer: bei geul.org registrierter Schlüssel (siehe Veröffentlichung der Prüfschlüssel unten).
  - 16-WORD-Issuer: `ISSUER-KEY` im selben Dokument. Die aus diesem öffentlichen Schlüssel berechnete Issuer-ID muss mit dem Signierenden übereinstimmen.
- Der Leser senkt das Vertrauen, wenn die Signatur fehlt, und senkt es stärker, wenn eine Signatur vorhanden ist, aber die Prüfung fehlschlägt, denn das ist ein Beleg für Manipulation oder Identitätsmissbrauch.
- Die Dokumentsignatur leistet der Issuer des Dokuments, die Signatur der Versionsliste die veröffentlichende Stelle, die die Versions-IDs vergibt ([Veröffentlichungsadresse und Versionsliste](/de/grammar/publishing/#signierende-stelle)).

## Veröffentlichung der Prüfschlüssel

- geul.org veröffentlicht die Signaturprüfschlüssel der registrierten Issuer (1, 2, 4 WORD).
- Die Schlüsselliste erscheint als veröffentlichtes Dokument des GEUL-Issuers (`0x0000`). Sie steht unter CC0 und wird von geul.org signiert.
  - Einträge: Issuer, Signaturalgorithmus-ID, öffentlicher Schlüssel, Beginn der Gültigkeit, Zeitpunkt und Grund des Widerrufs.
- Auch widerrufene Schlüssel werden nicht gelöscht. Frühere Signaturen werden mit dem Schlüssel geprüft, der zum Zeitpunkt der Signatur gültig war.
- Beim Schlüsselwechsel wird der neue Schlüssel mit dem alten signiert und registriert. Wer prüft, kann die Kontinuität der Schlüssel auch ohne Vertrauen in geul.org feststellen.
- Schlüsseländerungen werden in einem Append-only-Log festgehalten (wie Certificate Transparency und Go sumdb). Eine Änderung der Historie würde auffallen.
- Hat man den Schlüssel verloren und kann nicht mit dem alten Schlüssel signieren, prüft geul.org die Identität erneut und registriert einen neuen Schlüssel. Ein 2-WORD-Issuer durchläuft den Nachweis des Domainbesitzes erneut. In diesem Fall muss man geul.org vertrauen, und der Grund wird im Log festgehalten.
- Für 16-WORD-Issuer gilt das nicht. Da die Issuer-ID aus dem öffentlichen Schlüssel berechnet wird, prüft man allein mit dem `ISSUER-KEY` im Dokument.

## Import

IMPORT importiert nur Dokumente.

```
IMPORT-DOC                      DOC-POINTER (Issuer + Dokument-ID + Versions-ID) + IMPORT ID
EXTERNAL-POINTER-1/2/4/8WORD    IMPORT ID + LOCAL ID
EXTERNAL-ISSUER-1/2/4/16WORD    Issuer + Dokument-ID + LOCAL ID (ohne IMPORT)
ISSUER-POINTER                  Issuer (der Issuer selbst)
DOC-POINTER                     Issuer + Dokument-ID + Versions-ID (2 WORD, bei 0 die neueste)
```

- Auf Issuer jeder Breite und deren Dokumente kann man ohne IMPORT per Zeiger-Deklaration verweisen. Der Issuer selbst: `ISSUER-POINTER`, das Dokument selbst: `DOC-POINTER`, das LOCAL eines Dokuments: `EXTERNAL-ISSUER-*`. Die Zeiger-Deklaration folgt der neuesten Version; um die Version festzulegen, verwendet man `IMPORT-DOC` (Versions-ID) und `EXTERNAL-POINTER-*`.
- Reference im BODY verwenden statt des vollständigen Pfades (Issuer + Dokument + Ziel-ID) nur IMPORT ID + Ziel-ID.
- Die Breite der IMPORT ID wird bei `IMPORT-DOC` durch die Länge, bei `EXTERNAL-POINTER-*` durch den Codec bestimmt. Sie gilt nur innerhalb dieses Dokuments ([IMPORT-DOC](/de/grammar/meta/import/import-doc/)).
- Ein Import ohne Versions-ID folgt der neuesten Version. Wird eine Versions-ID angegeben, ist man an diese Version gebunden. Veröffentlichte Dokumente geben die Versions-ID an.

## Lizenz

- Bei geul.org veröffentlichte Dokumente und Dokumente des GEUL-Issuers (`0x0000`) stehen unter CC0.
- Die Lizenz privat veröffentlichter Dokumente legt der Issuer fest. GEUL erzwingt sie nicht.
- Die zentralen Ergebnisse von GEUL vervielfältigen keine Inhalte von Issuer-Dokumenten, die nicht unter CC0 stehen.

## Offene Fragen

- Ob 4-WORD- und 16-WORD-Issuer bei geul.org veröffentlichen dürfen.
- Das Verfahren des Domainbesitznachweises (DNS TXT `_geul.<Domain>`, HTTP `.well-known`) und ob der Fingerabdruck des Signaturschlüssels an den Nachweiswert gebunden wird.
- Umgang mit Domainübernahme bei der Wiederherstellung verlorener Schlüssel. Registriert man allein durch erneuten Domainnachweis einen neuen Schlüssel, könnte ein Domain-Entführer den Issuer übernehmen. Geprüft werden: Bestätigung der Registrierungskontakte, Karenzzeit mit Einspruch des alten Schlüssels, entsprechende Anwendung von Domainstreit-Ergebnissen.
- Das Record-Format des Begriffsdefinitions-Indexdokuments (Dokument-ID `0`) (Edge, der die Begriffsdefinitionsdokumente auflistet).
- Standardwert des Signaturalgorithmus (Ed25519 empfohlen).
