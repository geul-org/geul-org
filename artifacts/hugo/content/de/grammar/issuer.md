---
title: "Issuer und Veröffentlichung"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "GEUL bündelt das Identifikationssystem nicht an einem Ort."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL bündelt das Identifikationssystem nicht an einem Ort. Jeder Issuer definiert seine Objekte und Formate, und andere Dokumente übernehmen die veröffentlichten Definitionen. Definitionen werden vertraulich gehalten oder bei geul.org (CC0) bzw. privat (Lizenz nach Festlegung des Issuers) veröffentlicht. Welcher Definition man vertraut, entscheidet der Nutzer.

Veröffentlichungsadresse, Formatangabe, Issuer-Liste, Versionsliste und Vertrauensschichten legt [Veröffentlichungsadresse und Versionsliste](publishing.md) fest.

## Was ein Issuer definiert {#issuer가-정의하는-것}

| Gegenstand | Methode |
|---|---|
| Objekte (Entitäten, Konzepte, Begriffe) | werden als LOCAL im eigenen Dokument deklariert |
| Reference-Formate | werden unter dem Issuer-Code mit einer 2-WORD-Codec-Nummer definiert |
| Value-Formate | werden unter dem Issuer-Code mit einer 2-WORD-Codec-Nummer definiert |
| Edge-Formate | werden unter dem Issuer-Code mit einer 2-WORD-Codec-Nummer definiert |

- Auch die Definitionen von Reference-, Value- und Edge-Formaten werden als Dokumente veröffentlicht.

## Grundsätze {#원칙}

- Ein von einem Issuer definiertes Objekt ist ein LOCAL in einem von diesem Issuer veröffentlichten Dokument. Andere Dokumente zitieren es direkt über eine verweisende Deklaration (`EXTERNAL-ISSUER-*`) oder importieren es mit `IMPORT-DOC` und verweisen mit `EXTERNAL-POINTER-*` darauf. Die Bedeutung eines [REFERENCE-ISSUER](reference/_index.md#reference-issuer)-Records legt das vom Issuer herausgegebene Codec-Dokument fest.
- Für Objekte, auf die von außerhalb des Dokuments verwiesen werden muss, wird ein LOCAL eines veröffentlichten Dokuments ausgegeben. Dieses Dokument muss eine [DOC-ID](meta/0x1C7L-doc-id.md) haben.

## Issuer-Klassen {#issuer-등급}

| Breite | Wertebereich | Vergabe |
|---|---|---|
| 2 WORD | `0x00000000`~`0xFFFFFFFF` | Registrierung bei geul.org. Mit Nachweis des Domainbesitzes. Auch die Nummern, die geul.org Normungsorganisationen und wichtigen Institutionen zugewiesen hat, haben diese Breite ([Zuweisungstabelle für 2 WORD](#2-word-배정표)) |
| 4 WORD | `2^32`~`2^64−1` | Registrierung bei geul.org. Ohne Besitznachweis |
| 16 WORD | `2^64` und mehr | Selbst ausgestellt. Aus dem öffentlichen Schlüssel berechnet |

- **Die Issuer ID ist ein ganzzahliger Wert.** Gleicher Wert bedeutet gleicher Issuer. Die Breite ist kein Teil des Bezeichners.
- **Eine längere Schreibweise einer kurzen Issuer ID mit vorangestellten Nullen bezeichnet denselben Issuer** (2 → 4, 2 → 16, 4 → 16 WORD). `0x00000001` und `0x0000000000000001` sind derselbe Issuer. Deshalb werden weder `0x00000000XXXXXXXX` als 4-WORD-Issuer noch Werte, deren obere 12 WORD 0 sind, als 16-WORD-Issuer zugewiesen.
- **Die kanonische Form ist die schmalste Breite.** In Records wird die schmalste Breite geschrieben, in die der Wert passt, und eine breitere Schreibweise wird abgelehnt. Daher beginnt die Zuweisung jeder Breite bei dem Wert nach dem Ende des Bereichs der nächstschmaleren Breite. 2 WORD ist die schmalste Breite. In Veröffentlichungsadressen wird die Stellenzahl der Vergabebreite (2 WORD 8 Stellen, 4 WORD 16 Stellen, 16 WORD 64 Stellen) in hexadezimalen Großbuchstaben geschrieben (auch eine klein geschriebene Adresse wird in Großbuchstaben umgesetzt und gesucht), und beim Lesen wird auch die erweiterte Schreibweise als derselbe Issuer angenommen ([Veröffentlichungsadresse und Versionsliste](publishing.md#id-표기)).

## Zuweisungstabelle für 2 WORD {#2-word-배정표}

geul.org weist Normungsorganisationen und wichtigen Institutionen der Reihe nach von vorn 2-WORD-Issuer-Nummern zu. De-facto-Standards oder Konventionsformate ohne Normungsorganisation stehen unter `ADHOC` (`adhoc.geul.org`). Die von GEUL entworfenen eigenen Formate sind direkte Codes. Der Issuer einer Normungsorganisation ist ein Subdomain-Issuer von geul.org. Der Subdomain-Name ist der kleingeschriebene Name der Organisation (`<Organisationsname>.geul.org`, z. B. `iso.geul.org`, `iec.geul.org`). Die Domains stehen in der Tabelle unten.

| Issuer | Name | Domain | Organisation | Repräsentative Formate |
|---|---|---|---|---|
| `0x00000000` | GEUL | `geul.org` | geul.org | Spezifikationsdokumente der direkten Codes (Codebook) |
| `0x00000001` | wikidata.geul.org | `wikidata.geul.org` | geul.org | Wikidata-Item- und -Property-Dokumente |
| `0x00000002` | ADHOC | `adhoc.geul.org` | geul.org | Konventionsformate ohne Normungsorganisation. BFLOAT16, BLAKE3, komplexe Zahlen, Brüche, Intervalle, Quaternionen, Vektoren, Tensoren |
| `0x00000003` | ISO | `iso.geul.org` | International Organization for Standardization | ISO 8601, ISO 4217 (Währungen), ISO 3166 (Länder) |
| `0x00000004` | IEC | `iec.geul.org` | International Electrotechnical Commission | IEC 80000 (Einheitenschreibweise) |
| `0x00000005` | ISO-IEC-JTC1 | `iso-iec-jtc1.geul.org` | ISO/IEC Joint Technical Committee 1 | ISO/IEC-Normen der Informationstechnik |
| `0x00000006` | ITU-T | `itu-t.geul.org` | ITU Telecommunication Standardization Sector | X.509, X.690 (ASN.1-Kodierung) |
| `0x00000007` | IETF | `ietf.geul.org` | Internet Engineering Task Force | URI (RFC 3986), UUID (RFC 9562), CRC32C, IPv4, IPv6 |
| `0x00000008` | IANA | `iana.geul.org` | Internet Assigned Numbers Authority | Medientypen, Registry der Sprach-Subtags |
| `0x00000009` | W3C | `w3c.geul.org` | World Wide Web Consortium | XML-Schema-Datentypen, RDF |
| `0x0000000A` | WHATWG | `whatwg.geul.org` | Web Hypertext Application Technology Working Group | URL, HTML |
| `0x0000000B` | UNICODE | `unicode.geul.org` | Unicode Consortium | Zeichenkodierung, Normalisierung, CLDR |
| `0x0000000C` | ECMA | `ecma.geul.org` | Ecma International | JSON (ECMA-404) |
| `0x0000000D` | IEEE | `ieee.geul.org` | Institute of Electrical and Electronics Engineers | IEEE 754 Gleitkomma und decimal, MAC-Adresse (802) |
| `0x0000000E` | KHRONOS | `khronos.geul.org` | Khronos Group | Pixelformate (RGBA8, BGRA8 UNORM), glTF |
| `0x0000000F` | OGC | `ogc.geul.org` | Open Geospatial Consortium | Koordinaten, Bounding Box, GeoJSON-Familie |
| `0x00000010` | ONNX | `onnx.geul.org` | ONNX (LF AI & Data Foundation) | FP8 E4M3FN, E4M3FNUZ, E5M2, E5M2FNUZ |
| `0x00000011` | OCP | `ocp.geul.org` | Open Compute Project | Microscaling-Formate (E8M0, FP4 E2M1) |
| `0x00000012` | OASIS | `oasis.geul.org` | OASIS Open | Dokument- und Sicherheitsstandards |
| `0x00000013` | BIPM | `bipm.geul.org` | Bureau International des Poids et Mesures | SI-Einheiten, TAI |
| `0x00000014` | IERS | `iers.geul.org` | International Earth Rotation and Reference Systems Service | Schaltsekunde, UTC−TAI |
| `0x00000015` | NIST | `nist.geul.org` | National Institute of Standards and Technology | SHA-2 (FIPS 180-4), SHA-3 (FIPS 202) |
| `0x00000016` | GPS | `gps.geul.org` | Betreiber des GPS (Regierung) | GPS-Zeit |
| `0x00000017` | KATS | `kats.geul.org` | Korean Agency for Technology and Standards | KS-Normen |

- Erweiterungsformate stehen unter dem Issuer der Organisation, die das Format normiert hat. Die Codec-Nummern unter einem Issuer definiert jeder Issuer selbst.
- Die Codec-Nummer legt der Issuer fest. GEUL bestimmt keine Bedeutung. Codec-Nummern überschneiden sich innerhalb des Issuers nicht, unabhängig vom Kind ([Veröffentlichungsadresse und Versionsliste](publishing.md#id-표기)).
- Verwaltet eine Normungsorganisation GEUL-Codec-Nummern nicht selbst, trägt geul.org deren Normen stellvertretend mit Nummern ein. Die Nummer wird zusammen mit dem Normdokument-Bezeichner aufgezeichnet.
- Eine neue Normungsorganisation erhält die nächste freie Nummer.
- **Domains können sich ändern.** Die Bindung von Issuer und Domain kann sich später ändern. Die Issuer ID ändert sich nicht. Verwaltet die Organisation sie selbst, wird sie durch die offizielle Domain der Organisation ersetzt.
- **Subdomains von geul.org sind keine offiziellen Herausgeber.** Eine Subdomain von geul.org mit dem Namen einer Normungsorganisation ist nicht der offizielle Herausgeber dieser Organisation. Zum Beispiel ist `iso.geul.org` nicht der offizielle Herausgeber von ISO.

## 16-WORD-Issuer {#16-word-issuer}

```
Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ Signaturalgorithmus-ID (2 Bytes) ‖ öffentlicher Schlüssel)
```

- Das 32-Byte-Ergebnis wird beginnend mit dem höchsten Byte in 16 WORD geschrieben.
- Jeder kann ihn ohne Registrierung erzeugen. Der Besitz wird durch die Signatur mit dem privaten Schlüssel nachgewiesen.
- Öffentlicher Schlüssel und Algorithmus werden im Dokument-HEAD mit [ISSUER-KEY](meta/0x1E5L-issuer-key.md) deklariert. Der Signaturalgorithmus `0x0001` ist Ed25519, alle anderen Werte sind Reserved.
- Das Präfix `GEUL-ISSUER-v1` verhindert, dass bei Verwendung desselben Schlüssels für einen anderen Zweck dieselbe ID entsteht (Zweckbindung).
- Auch wenn sich der Signaturalgorithmus ändert (z. B. Ed25519 → ML-DSA), bleibt die ID-Breite 16 WORD.
- Ist das Ergebnis kleiner als `2^64` (die Wahrscheinlichkeit ist praktisch 0), wird mit diesem Schlüssel kein Issuer erzeugt, weil es mit der Regel der schmalsten Breite kollidiert.

## Domainnachweis {#도메인-증명}

- Der Nachweis des Domainbesitzes eines 2-WORD-Issuers wird nur zum Zeitpunkt der Registrierung geprüft. Danach liegt die Domainverwaltung in der Verantwortung des Issuers.
- Eine Domain entspricht nur einem Issuer. Ein Issuer kann mehrere Domains haben. Die Zuordnung wird per BIND in der Issuer-Liste `issuers/` geschrieben ([Veröffentlichungsadresse und Versionsliste](publishing.md#issuer-목록)).
- Auch wenn die Domain abläuft oder übergeht, bleibt die Zuordnung beim zuerst nachgewiesenen Issuer. Der neue Inhaber darf diese Domain nicht als Issuer-Namen verwenden.
- Der Domainname dient der Eingabe und Anzeige in Interpretern und CLI. Er ist keine Veröffentlichungs-URL ([Veröffentlichungsadresse und Versionsliste](publishing.md#도메인-이름)). In GEUL-Dokumenten steht nur die Issuer ID.

## Begriffsdefinitionsdokumente {#용어-정의-문서}

- Vom Issuer definierte Begriffe (Werkzeuge, Programme, Rollen, Konzepte innerhalb einer Organisation) bekommen **je Begriff ein Dokument**. Der Begriff ist ein LOCAL dieses Dokuments, der Name wird mit [BIND](edge/0x0A3L-bind.md) und das bezeichnete externe Objekt (URI usw.) mit [REFERENCE-NODE](edge/0x0A0L-reference-node.md) verbunden.
- Andere Dokumente verweisen mit `EXTERNAL-ISSUER-*` (Issuer, Dokument-ID, LOCAL ID) auf den Begriff. Dieselbe Definition wird nicht in jedem Dokument wiederholt. Beispiel: das Werkzeug von [TRANSFORMED-BY](meta/0x1D4L-transformed-by.md).
- Den Dokument-ID-Bereich der Begriffsdefinitionsdokumente legt der Issuer fest. geul.org (`0x00000000`) verwendet `0x0001xxxx xxxxxxxx`.
- Jeder Issuer reserviert die Dokument-IDs `0x0000000000000000` und `0xFFFFFFFFFFFFFFFF`. Die derzeitige Verwendung sind die folgenden zwei Fälle.
- Die Dokument-ID `0x0000000000000000` ist der Platz des **Begriffsdefinitions-Indexdokuments** dieses Issuers: `<Issuer>/docs/0x0000000000000000/`. Dort werden die Begriffsdefinitionsdokumente aufgelistet.
- Die Dokument-ID `0xFFFFFFFFFFFFFFFF` wird für die Issuer-Liste `issuers/` des Issuers geul.org (`0x00000000`) verwendet. Andere Issuer verwenden diese ID nicht. Diese ID wird bei keinem Issuer über die Adresse `<Issuer>/docs/<Dokument-ID>/` ausgeliefert (404) ([Veröffentlichungsadresse und Versionsliste](publishing.md#목록-문서)).
- Indexdokumente werden allen Issuern **empfohlen**. Sie sind nicht verpflichtend.
- Reihenfolge beim Verweisen auf externe Objekte: (1) wenn es einen passenden Reference-Codec gibt, dieser (WIKIDATA-QID usw.), (2) wenn es ein GEUL-Dokument gibt, das das Objekt definiert, dieses (DOC-POINTER, EXTERNAL-ISSUER), (3) andernfalls als LOCAL im eigenen Begriffsdefinitionsdokument definieren und darauf verweisen.

## Arten der Dokumentveröffentlichung {#문서-공개-방식}

| Art | Gegenstand | Lizenz | Versionsverwaltung | Fortbestand |
|---|---|---|---|---|
| vertraulich | alle Issuer | intern beim Issuer | Issuer | hängt vom Issuer ab |
| Veröffentlichung bei geul.org | 2-WORD-Issuer | CC0 | geul.org | geul.org bewahrt |
| private Veröffentlichung | alle Issuer | vom Issuer festgelegt | Issuer | hängt vom Issuer ab |

### Veröffentlichung bei geul.org {#geulorg-공표}

- Ein 2-WORD-Issuer kann Dokumente bei geul.org registrieren und veröffentlichen. Registrierte Dokumente sind CC0. Mit der Registrierung ist das Dokument sofort veröffentlicht, Probleme werden nachträglich behandelt.
- Veröffentlicht werden können Konzepte und Codecs als Definitionen. **Eine Reference, die eine natürliche Person bezeichnet, kann nicht bei geul.org veröffentlicht werden.** Sie wird vertraulich oder privat veröffentlicht.
  - Ausnahme: Der Verweis auf eine natürliche Person per [WIKIDATA-QID](reference/0x014L-wikidata-qid.md) ist zulässig.
- Eine registrierte Version wird weder geändert noch gelöscht, und das Dokument bleibt auch bestehen, wenn der Issuer verschwindet (Bewahrung des alten Rechts). Ausnahmen sind die rechtliche und die von Amts wegen veranlasste Löschung ([TOMBSTONE](edge/0x0BAL-tombstone.md)).
- Ein Issuer kann an einer Definition nur eine Empfehlung zur Einstellung der Nutzung (deprecated) kennzeichnen. Auch eine so gekennzeichnete Definition wird weiter interpretiert.
- Eine neue Version desselben Dokuments kann Definitionen neu einführen, ändern und streichen ([Dokument](document.md#개정)). **Gestrichene Entitäts-IDs und Codec-Nummern werden nicht für andere Objekte wiederverwendet.** Das Wire-Layout einer Codec-Nummer wird nicht geändert.

### Private Veröffentlichung {#사설-공표}

- Ein Issuer, der unter einer anderen Lizenz als CC0 veröffentlichen will, stellt die Dokumente in einem privaten Netz (eigene Domain usw.) bereit. Die Lizenz wird im Dokument-HEAD mit [LICENSE](meta/0x1DEL-license.md) deklariert.
- Auch die private Veröffentlichung verwendet dieselben Pfade wie geul.org ([Veröffentlichungsadresse und Versionsliste](publishing.md)).
- Versionsverwaltung, Verfügbarkeit, Domainpflege und Lizenzbedingungen legt der Issuer fest. geul.org beteiligt sich nicht an privaten Veröffentlichungen und übernimmt keine Gewähr dafür.

### Vertraulich {#대외비}

- Vertrauliche Dokumente werden nicht veröffentlicht. Sie werden mit einer Zugriffskontrolle versehen und mit [ACCESS](meta/0x1DFL-access.md) gekennzeichnet.
- Wird ein Dokument mit vertraulichen Definitionen nach außen gesendet, kann der Empfänger diese Reference, Value und Edge nicht interpretieren und überspringt sie. Definitionen, die mit der Außenwelt ausgetauscht werden, werden veröffentlicht.

### Wahl des Nutzers {#사용자의-선택}

- Der Nutzer wählt die zu verwendenden Dokumente anhand der deklarierten Lizenz und der Fortbestandsaussichten des Issuers.
- Definitionen mit übermäßig restriktiver Lizenz oder von Issuern mit unsicherem Fortbestand werden nicht verwendet.
- Für Verweise, die lange erhalten bleiben müssen, werden bei geul.org veröffentlichte Dokumente verwendet.

## Signatur {#서명}

- Eine Signatur ist bei veröffentlichten Dokumenten Pflicht. Sie steht als [SIGNATURE](meta/0x1E6L-signature.md) im HEAD. Auch ein Dokument ohne Signatur ist ein gültiges GEUL-Dokument, und auch vertrauliche und interne Dokumente werden nach Möglichkeit signiert.
- Signiert wird der **Inhaltshash** des Dokuments ([Dokument](document.md#내용-해시)). Nicht nur der BODY wird signiert.
  - Im HEAD stehen Interpretationsregeln. Ändert man das Ziel von `IMPORT-DOC`, zeigt derselbe BODY auf ein anderes Ziel.
  - Werden `LICENSE` und `PARENT` nicht signiert, können Lizenz und Historie gefälscht werden.
- Ein Dokument kann mehrere Signaturen tragen. Alle signieren denselben Inhaltshash, sodass das Hinzufügen einer Signatur den Inhaltshash nicht ändert.
- Prüfung des Signaturschlüssels:
  - 2- und 4-WORD-Issuer: der bei geul.org registrierte Schlüssel (siehe Veröffentlichung der Prüfschlüssel unten).
  - 16-WORD-Issuer: `ISSUER-KEY` im selben Dokument. Die mit diesem öffentlichen Schlüssel berechnete Issuer ID muss mit dem Unterzeichner übereinstimmen.
- Fehlt die Signatur, senkt die lesende Seite die Vertrauenswürdigkeit. Schlägt eine vorhandene Signatur bei der Prüfung fehl, ist das ein Beleg für Manipulation oder Identitätsanmaßung, und sie senkt sie stärker.
- Die Dokumentsignatur leistet der Issuer des Dokuments, die Signatur der Versionsliste die Veröffentlichungsstelle, die die Versions-IDs vergeben hat ([Veröffentlichungsadresse und Versionsliste](publishing.md#서명-주체)).

## Veröffentlichung der Prüfschlüssel {#검증키-공개}

- geul.org veröffentlicht die Signaturprüfschlüssel der registrierten Issuer (2 und 4 WORD).
- Die Schlüsselliste erscheint als veröffentlichtes Dokument des GEUL-Issuers (`0x00000000`). Sie ist CC0 und von geul.org signiert.
  - Einträge: Issuer, Signaturalgorithmus-ID, öffentlicher Schlüssel, Gültigkeitsbeginn, Zeitpunkt und Grund des Widerrufs.
- Auch widerrufene Schlüssel werden nicht gelöscht. Frühere Signaturen werden mit dem Schlüssel geprüft, der zum Zeitpunkt der Signatur gültig war.
- Ein Schlüsselwechsel wird registriert, indem der neue Schlüssel mit dem alten signiert wird. Die prüfende Seite kann die Kontinuität des Schlüssels bestätigen, ohne geul.org zu vertrauen.
- Schlüsseländerungen werden in einem Append-only-Log aufgezeichnet (wie bei Certificate Transparency und Go sumdb). Eine Änderung der Historie fällt auf.
- Kann man bei Verlust des Schlüssels nicht mit dem alten Schlüssel signieren, prüft geul.org die Identität erneut und registriert einen neuen Schlüssel. Ein 2-WORD-Issuer durchläuft den Nachweis des Domainbesitzes erneut. In diesem Fall muss man geul.org vertrauen, und der Grund wird im Log festgehalten.
- Für 16-WORD-Issuer gilt das nicht. Da die Issuer ID aus dem öffentlichen Schlüssel berechnet wird, wird allein mit `ISSUER-KEY` im Dokument geprüft.

## Import {#가져오기}

IMPORT importiert nur Dokumente.

```
IMPORT-DOC                      DOC-POINTER (Issuer + Dokument-ID + Versions-ID) + IMPORT ID
                                Codec-Dokument: CODEC-POINTER (Issuer + Codec ID + Versions-ID) + IMPORT ID
EXTERNAL-POINTER-1/2/4WORD      IMPORT ID + LOCAL ID
EXTERNAL-ISSUER-2/4/16WORD      Issuer + Dokument-ID + LOCAL ID (ohne IMPORT)
ISSUER-POINTER                  Issuer (der Issuer selbst)
DOC-POINTER                     Issuer + Dokument-ID + Versions-ID (2 WORD, 0 = neueste)
CODEC-POINTER                   Issuer + Codec ID + Versions-ID (2 WORD, 0 = neueste)
```

- Ein Issuer beliebiger Breite und sein Dokument können ohne IMPORT mit einer verweisenden Deklaration angesprochen werden. Der Issuer selbst mit `ISSUER-POINTER`, das Dokument selbst mit `DOC-POINTER`, ein LOCAL eines Dokuments mit `EXTERNAL-ISSUER-*`. Verweisende Deklarationen folgen der neuesten Version. Um die Version festzulegen, verwendet man `IMPORT-DOC` (Versions-ID) und `EXTERNAL-POINTER-*`.
- Eine Reference im Hauptteil, die auf ein Objekt eines externen Dokuments zeigt, verwendet statt des vollständigen Pfads (Issuer + Dokument + Objekt-ID) nur IMPORT ID + Objekt-ID. [REFERENCE-ISSUER](reference/_index.md#reference-issuer) schreibt Issuer und Codec-Nummer.
- Die Breite der IMPORT ID wird bei `IMPORT-DOC` durch die Länge und bei `EXTERNAL-POINTER-*` durch den Codec bestimmt ([IMPORT-DOC](meta/0x1E4L-import-doc.md)).
- Ein Import ohne Versions-ID folgt der neuesten Version. Wird eine Versions-ID angegeben, ist man an diese Version gebunden. Veröffentlichte Dokumente geben eine Versions-ID an.

## Lizenz {#라이선스}

- Bei geul.org veröffentlichte Dokumente und Dokumente des GEUL-Issuers (`0x00000000`) sind CC0.
- Die Lizenz privat veröffentlichter Dokumente legt der Issuer fest. GEUL erzwingt sie nicht.
- **Lizenz von Issuer-Formaten.** Nur die direkten Codes und Veröffentlichungen, die geul.org bereitstellt, sind CC0. Die Lizenz eines Issuer-Formats legt dieser Issuer fest.
- **Issuer-Anzeige.** GEUL macht Resolve von der Issuer-Anzeige abhängig. In einem Dokument, das Codecs eines anderen Issuers verwendet, wird dieser Issuer stets angezeigt.
- Die Kernergebnisse von GEUL vervielfältigen keine Inhalte von Issuer-Dokumenten, die nicht CC0 sind.

## Offene Probleme {#열린-문제}

- Das Verfahren des Domainbesitznachweises (DNS TXT `_geul.<Domain>`, HTTP `.well-known`) und ob der Fingerabdruck des Signaturschlüssels an den Nachweiswert gebunden wird.
- Umgang mit Domainübernahme bei der Wiederherstellung nach Schlüsselverlust. Wird nur durch erneuten Domainnachweis ein neuer Schlüssel registriert, kann ein Domain-Entführer den Issuer an sich bringen. Geprüft werden die Bestätigung des Registrierungskontakts, eine Schonfrist mit Einspruch des alten Schlüssels und die entsprechende Anwendung von Domainstreit-Ergebnissen.
- Das Record-Format des Begriffsdefinitions-Indexdokuments (Dokument-ID `0`) (Edges, die Begriffsdefinitionsdokumente auflisten).
- Standardwert des Signaturalgorithmus (Ed25519 empfohlen).
