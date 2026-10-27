---
title: "PUBLICATION"
weight: 25
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "PUBLICATION, DEPRECATION und TOMBSTONE sind Beschreibungs-Edges, die Veröffentlichung, Einstellungsempfehlung und Löschung von Dokumentversionen festhalten. Diese Seite legt auch die Spezifikation des mit diesen Edges geschriebenen Versionslisten-Dokuments fest (Codec 0x18~0x1A)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Beschreibungs-Edges, die Veröffentlichung, Deprecation und Löschung eines Dokuments festhalten, und die Spezifikation des mit diesen Edges geschriebenen Versionslisten-Dokuments. Sie legt das Format der Versionsliste aus [Veröffentlichungsadresse und Versionsliste](/de/grammar/publishing/#versionsliste) fest.

## Codes

| Codec | Name | Payload |
|---|---|---|
| `0x18` | PUBLICATION | Edge Id, DOC-POINTER, Inhaltshash |
| `0x19` | DEPRECATION | Edge Id, DOC-POINTER |
| `0x1A` | TOMBSTONE | Edge Id, DOC-POINTER, Begründungskategorie |

- Die drei Codes sind im Decoder eingebaut ([Ebene 0](/de/grammar/publishing/#ebenen)). Die Versionsliste wird interpretiert, ohne das Codebook nachzuschlagen.
- Es gibt keine Unterformate (Codec-spezifischer TAG). Die [Edge](/de/grammar/edge/)-Regel, dass das erste Element des Payloads die Edge Id ist, bleibt unverändert.

## Layout

```
TAG WORD          Edge, Codec 0x18 / 0x19 / 0x1A
[Length-Erweiterungs-TAG]
Edge Id           LOCAL-Reference-Record
Dokument          DOC-POINTER-Reference-Record (Issuer, Dokument-ID, Versions-ID)
Inhaltshash       16 WORD   (PUBLICATION)
Begründungskategorie  1 WORD    (TOMBSTONE)
```

| Feld | Breite | Beschreibung |
|---|---|---|
| Edge Id | LOCAL-Reference-Record | Laufnummer in der Liste. Wird ab 1 vergeben und fortlaufend angehängt |
| Dokument | DOC-POINTER-Record | Eine Version des veröffentlichten Dokuments ([DOC-POINTER](/de/grammar/reference/doc-pointer/)). Issuer und Dokument-ID sind dieselben wie bei dem Dokument, das diese Liste behandelt. So sagt das Listendokument auch ohne Pfad, wessen Liste es ist. Die Versions-ID ist die Laufnummer in diesem Dokument ([Dokument](/de/grammar/document/), Version); `0` (neueste) wird nicht verwendet |
| Inhaltshash | 16 WORD | Inhaltshash dieser Version (SHA-256, [Dokument](/de/grammar/document/), Inhaltshash) |
| Begründungskategorie | 1 WORD | Kategoriecode für den Löschgrund. Die Codetabelle ist eine offene Frage |

- Die Länge nach dem DOC-POINTER ist je Code fest (16, 0, 1 WORD). Weicht sie ab, wird abgelehnt.
- In den Record kommt kein Zeitpunkt. Das `RECORDED-AT` des Listendokuments, in dem der Record zum ersten Mal steht, ist der Zeitpunkt von Veröffentlichung, Deprecation und Löschung.

## Versionslisten-Dokument

Die veröffentlichende Stelle führt je Dokument ein Versionslisten-Dokument fort: `/<Issuer>/<Dokument-ID>/versions.geul`. In diese eine Liste kommen alle Versionen, die dieses Dokument bei dieser veröffentlichenden Stelle veröffentlicht hat.

```
DOC-1WORD/2WORD/4WORD     Gesamtlänge
  SPEC-VERSION            0x0001 (v1)
  PARENT                  SHA-256-DIGEST-Value. Inhaltshash des vorherigen Listendokuments (entfällt bei der ersten Liste)
  RECORDED-AT             POSIX-TIMESTAMP-SECONDS-Value. Zeitpunkt, zu dem diese Liste herausgegeben wurde
  NEXT-LOCAL-ID           Nächste zu vergebende LOCAL ID (wenn es Versionen gibt)
  SIGNATURE               Signatur der veröffentlichenden Stelle. Gegenstand ist der Inhaltshash dieses Listendokuments
BODY
  PUBLICATION · DEPRECATION · TOMBSTONE · BIND …
END
```

- HEAD-Meta: [SPEC-VERSION](/de/grammar/meta/declaration/spec-version/), [PARENT](/de/grammar/meta/lineage/parent/), [RECORDED-AT](/de/grammar/meta/provenance/recorded-at/), [NEXT-LOCAL-ID](/de/grammar/meta/lineage/next-local-id/), [SIGNATURE](/de/grammar/meta/verification/signature/).
- Ein Listendokument enthält keine `DOC-ID` (Ausnahme für Dokumente, deren Name nicht mit `0x` beginnt, [DOC-ID](/de/grammar/meta/declaration/doc-id/)). Eine Liste ist kein veröffentlichtes Dokument, sondern eine Aufzeichnung, die zu diesem Dokument gehört. Wessen Liste es ist, sagt die Dokument-ID der Records. Deshalb weiß man auch bei Empfang ohne Pfad (`h/`, Dump), wessen Liste es ist.
- Die Dokument-IDs der Records müssen alle dem Dokument entsprechen, das diese Liste behandelt. Records anderer Dokumente werden abgelehnt.
- Ein Listendokument enthält kein IMPORT und verwendet nur Codecs der Ebene 0. Es wird nicht in eine andere Liste aufgenommen (keine Liste von Listen).
- Ein neues Listendokument behält den BODY des vorherigen Listendokuments unverändert am Anfang und fügt Records an. Es wird nichts geändert, gelöscht oder umgeordnet.
- Die veröffentlichende Stelle signiert die Liste. Bei Veröffentlichungen bei geul.org signiert geul.org (GEUL-Issuer), bei privaten Veröffentlichungen der jeweilige Issuer.
- Die Dokument-ID `0x0000000000000000` ist das Begriffsdefinitions-Indexdokument des Issuers ([Issuer und Veröffentlichung](/de/grammar/issuer/)). Den Issuer selbst spricht man mit [ISSUER-POINTER](/de/grammar/reference/issuer-pointer/) an.

## Regeln

- Die Versions-IDs von PUBLICATION laufen lückenlos aufsteigend ab 1. Die Versions-IDs vergibt die veröffentlichende Stelle.
- Derselbe Inhaltshash wird nicht erneut veröffentlicht. Ist er bereits vorhanden, wird dessen Versions-ID zurückgegeben.
- DEPRECATION und TOMBSTONE verweisen nur auf Versions-IDs eines zuvor stehenden PUBLICATION. Verweist eines auf eine nicht vorhandene Version, wird abgelehnt.
- Den Zustand einer Version berechnet man, indem man die Records der Reihe nach anwendet. Veröffentlicht → deprecated → gelöscht. Eine gelöschte Version wird nicht erneut veröffentlicht und nicht ausgeliefert.
- Die neueste Version ist die höchste Versions-ID, die weder deprecated noch gelöscht ist.
- Erreicht die Versions-ID das Ende ihrer 2 WORD, wird dieses Dokument nicht weiter veröffentlicht, sondern erscheint unter einer neuen Dokument-ID.

## Dokumentname

Den Adressnamen eines Dokuments bindet der Namensindex des Issuers `/<Issuer>/documents.geul` per [BIND](/de/grammar/edge/bind/) ([Veröffentlichungsadresse und Versionsliste](/de/grammar/publishing/#dokumentname)). Der Interpreter liest nur diesen Index.

Auch im Listendokument kann dasselbe BIND stehen (optional). Steht es dort, gilt Folgendes.

- Das Subject ist `DOC-POINTER` (Issuer, Dokument-ID dieser Liste, Version `0`). Der Name ist nicht an eine Version, sondern an das Dokument gebunden, daher ist die Version `0`.
- Es wird nur an Dokumente gebunden, zu denen zuvor ein PUBLICATION steht. An ein nie veröffentlichtes Dokument wird kein Name gebunden.
- Der Name folgt der Regel für Dokumentnamen (ASCII-Slug in Kleinbuchstaben) und muss mit dem BIND im Namensindex übereinstimmen.
- Bei einer Umbenennung wird ein neues BIND angefügt. Der alte Name bleibt erhalten und verweist auf dasselbe Dokument. Der maßgebliche Name ist das letzte BIND.
- Im Dokument steht der eigene Name nicht.

## Adressen

```
/.well-known/geul/<Issuer>/<Dokument-ID>/versions.geul             Neuestes Listendokument (veränderlich)
/.well-known/geul/h/<Inhaltshash>.geul                           Frühere Listendokumente (unveränderlich)
```

- Veränderlich ist nur die Adresse der neuesten Liste. Eine empfangene Liste wird über Signatur, `RECORDED-AT` und die `PARENT`-Kette geprüft.
- Alle früheren Listendokumente bleiben unter `h/` erhalten. Entlang der `PARENT`-Kette lässt sich die Liste jedes Zeitpunkts zurückverfolgen.

## Prüfung

- Das Listendokument muss eine `SIGNATURE` mit dem festgelegten Schlüssel der veröffentlichenden Stelle haben.
- Die Dokument-ID der Records muss der angefragten Dokument-ID entsprechen.
- Der im Sperrprotokoll festgehaltene Inhaltshash der vorherigen Liste muss in der `PARENT`-Kette der neuen Liste stehen. Der BODY dieser Liste muss dem Anfang des BODY der neuen Liste entsprechen.
- Der Inhaltshash eines empfangenen Dokuments muss dem Wert entsprechen, den das PUBLICATION dieser Versions-ID angibt, und die `DOC-ID` des Dokuments muss dem angefragten Issuer und der angefragten Dokument-ID entsprechen.

## Offene Fragen

- Codetabelle der Begründungskategorie.
- Standardwert des Signaturalgorithmus und Payload-Layout von `SIGNATURE`.
- Zeitpunkt und Format des Wechsels zu einem Merkle-Log (Inklusions- und Konsistenzbeweise), wenn die Liste wächst.
- Ob das BIND der Liste und der Namensindex `documents.geul` zusammengelegt werden, Signatur des Index.
- Schutz vor Zurückspulen auf Issuer-Ebene. Da die Listen je Dokument eine eigene Kette bilden, wird ein Angriff, der nur die Liste eines Dokuments in veralteter Fassung vorlegt, nur durch die Kette dieses Dokuments abgewehrt.

## Verwandte Seiten

- [Edge](/de/grammar/edge/), [BIND](/de/grammar/edge/bind/), [DOC-POINTER](/de/grammar/reference/doc-pointer/)
- [Issuer und Veröffentlichung](/de/grammar/issuer/), [Veröffentlichungsadresse und Versionsliste](/de/grammar/publishing/), [Dokument](/de/grammar/document/)
