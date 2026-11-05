---
title: "PUBLICATION (0x0B8L)"
weight: 184
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "PUBLICATION, DEPRECATION und TOMBSTONE sind Aussage-Edges, die Veröffentlichung, Abkehr-Empfehlung und Löschung einer Dokumentversion aufzeichnen; diese Seite legt auch die Spezifikation des mit diesen Edges geschriebenen Versionslisten-Dokuments fest (Codec 0x0B8L~0x0BAL)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PUBLICATION, DEPRECATION und TOMBSTONE sind Aussage-Edges, die Veröffentlichung, Abkehr-Empfehlung und Löschung einer Dokumentversion aufzeichnen; diese Seite legt auch die Spezifikation des mit diesen Edges geschriebenen Versionslisten-Dokuments fest (Codec 0x0B8L~0x0BAL).

| Eintrag | Wert |
|---|---|
| Name | `PUBLICATION` (BIND des Spezifikationsdokuments `PUBLICATION`) |
| TAG ID | `0x0B8L` |
| Codec ID | `0x00000B80` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000B80/` (DECLARE-Ziel `0B80`) |
| Abschnitt | 5 `0101` (Edge-Aussage), Offset im Abschnitt C = 24 |
| Kind | Edge · Familie: Aussage, Gruppe: Sonstiges |
| TAG WORD | `0000 1011 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Dokumentveröffentlichung. DOC-POINTER, Inhaltshash |
| Hugo-Seite | `edge/publication.md` (diese Seite behandelt auch [DEPRECATION](0x0B9L-deprecation.md) und [TOMBSTONE](0x0BAL-tombstone.md)) |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)). Die Edge Id eines Edge wird nicht als FIELD deklariert.

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #2 | Record | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |
| 2 | `hash` | #4 | Rohwert 16 WORD |  |  |

Dies ist die Spezifikation der Aussage-Edges, die Veröffentlichung, Deprecation und Löschung eines Dokuments aufzeichnen, und des mit ihnen geschriebenen Versionslisten-Dokuments. Sie legt das Versionslistenformat aus [Veröffentlichungsadresse und Versionsliste](../publishing.md#버전-목록) fest.

## Codes {#코드}

| Codec | Name | Payload |
|---|---|---|
| `0x0B8L` | PUBLICATION | Edge Id, DOC-POINTER, Inhaltshash |
| `0x0B9L` | DEPRECATION | Edge Id, DOC-POINTER |
| `0x0BAL` | TOMBSTONE | Edge Id, DOC-POINTER, Begründungskategorie |

- Die drei Codes sind im Decoder eingebaut ([Schicht 0](../publishing.md#층)). Versionslisten werden interpretiert, ohne das Codebook abzufragen.
- Es gibt keine Unterformate (Codec-spezifischer TAG). Die [Edge](_index.md)-Regel, dass das erste Element des Payload die Edge Id ist, gilt unverändert.

## Layout {#레이아웃}

```
TAG WORD          Edge, Codec 0x0B8L / 0x0B9L / 0x0BAL
[Length-Erweiterungs-TAG]
Edge Id           LOCAL Reference-Record
Dokument          DOC-POINTER Reference-Record (Issuer, Dokument-ID, Versions-ID). Bei der Versionsliste eines Codec CODEC-POINTER
Inhaltshash       16 WORD   (PUBLICATION)
Begründungskat.   1 WORD    (TOMBSTONE)
```

| Feld | Breite | Beschreibung |
|---|---|---|
| Edge Id | LOCAL Reference-Record | Laufende Nummer in der Liste. Beginnt bei 1 und wird fortlaufend angehängt |
| Dokument | DOC-POINTER-Record | Eine Version des veröffentlichten Dokuments ([DOC-POINTER](../reference/0x041L-doc-pointer.md)). Issuer und Dokument-ID sind dieselben wie bei dem Dokument, das die Liste behandelt. So sagt das Listendokument auch ohne Pfad, wessen Liste es ist. Die Versions-ID ist die laufende Nummer innerhalb des Dokuments ([Dokument](../document.md) Version); `0` (neueste) wird nicht verwendet. Für die Versionsliste eines Codec wird [CODEC-POINTER](../reference/0x042L-codec-pointer.md) (Issuer, Codec ID, Versions-ID) verwendet |
| Inhaltshash | 16 WORD | Inhaltshash dieser Version (SHA-256, [Dokument](../document.md) Inhaltshash) |
| Begründungskategorie | 1 WORD | Kategoriecode des Löschgrundes. Die Codetabelle ist ein offenes Problem |

- Die Länge nach dem DOC-POINTER ist je Code fest (16, 0, 1 WORD). Weicht sie ab, wird abgelehnt.
- Ein Zeitpunkt steht nicht im Record. Das `RECORDED-AT` des Listendokuments, in dem der Record zuerst erschien, ist der Zeitpunkt von Veröffentlichung, Deprecation oder Löschung.

## Versionslisten-Dokument {#버전-목록-문서}

Die Veröffentlichungsstelle führt für jedes Dokument ein Versionslisten-Dokument fort: `/<Issuer>/docs/<Dokument-ID>/versions.geul` (bei Codecs `/<Issuer>/codecs/<Codec ID>/versions.geul`, zur Issuer-Liste siehe [unten](#목록-문서의-버전-목록)). Alle von dieser Veröffentlichungsstelle veröffentlichten Versionen dieses Dokuments stehen in einer Liste.

```
DOC-1WORD/2WORD/4WORD     Gesamtlänge
  SPEC-VERSION            0x0001 (v1)
  PARENT                  SHA-256-DIGEST Value. Inhaltshash des vorherigen Listendokuments (bei der ersten Liste nicht vorhanden)
  RECORDED-AT             POSIX-TIMESTAMP-SECONDS Value. Zeitpunkt, zu dem diese Liste erstellt wurde
  NEXT-LOCAL-ID           Als Nächstes zu vergebende LOCAL ID (falls Versionen vorhanden)
  SIGNATURE               Signatur der Veröffentlichungsstelle. Ziel ist der Inhaltshash dieses Listendokuments
BODY
  PUBLICATION · DEPRECATION · TOMBSTONE …
END
```

- HEAD Meta: [SPEC-VERSION](../meta/0x1C5L-spec-version.md), [PARENT](../meta/0x1D1L-parent.md), [RECORDED-AT](../meta/0x1D0L-recorded-at.md), [NEXT-LOCAL-ID](../meta/0x1DDL-next-local-id.md), [SIGNATURE](../meta/0x1E6L-signature.md).
- Im Versionslisten-Dokument steht kein `DOC-ID` (Ausnahme für Listendokumente, [DOC-ID](../meta/0x1C7L-doc-id.md)). Eine Liste ist kein veröffentlichtes Dokument, sondern eine zu diesem Dokument gehörende Aufzeichnung. Wessen Liste es ist, sagt der DOC-POINTER (Dokument-ID) im Record. Daher weiß man auch ohne Pfad (`hashes/`, Dump), wessen Liste es ist.
- Die Dokument-ID aller Records muss das Dokument sein, das die Liste behandelt. Records eines anderen Dokuments werden abgelehnt.
- Das Versionslisten-Dokument hat kein IMPORT und verwendet nur Codecs der Schicht 0. Im BODY stehen nur PUBLICATION, DEPRECATION und TOMBSTONE. Ein BIND mit Dokumentnamen steht nicht darin ([Veröffentlichungsadresse und Versionsliste](../publishing.md#문서-이름)).
- Das neue Listendokument stellt den BODY des vorherigen Listendokuments unverändert voran und hängt Records an. Es ändert, löscht oder vertauscht nichts.
- Die Veröffentlichungsstelle signiert die Liste. Bei einer Veröffentlichung von geul.org signiert geul.org (GEUL Issuer), bei einer privaten Veröffentlichung der jeweilige Issuer.
- Die Dokument-ID `0x0000000000000000` ist das Indexdokument der Begriffsdefinitionen des Issuer ([Issuer und Veröffentlichung](../issuer.md)). Der Issuer selbst wird per [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md) angesprochen.

## Versionsliste des Listendokuments {#목록-문서의-버전-목록}

Das Listendokument ist die eine Issuer-Liste `issuers/` ([Veröffentlichungsadresse und Versionsliste](../publishing.md#목록-문서)). Auch die Issuer-Liste beginnt bei Version 1 und hat die Versionsliste `issuers/versions.geul`. Die Records verweisen mit einem DOC-POINTER der reservierten Dokument-ID (`0x00000000`, `0xFFFFFFFFFFFFFFFF`, Versions-ID) auf die Listenversion.

- Das Record-Format ist wie oben. Daher weiß man auch bei Empfang über `hashes/`, wessen Liste es ist.
- Auch das Listendokument selbst (`<Versions-ID>.geul`) hat kein `DOC-ID`.
- Die Dokument-ID `0xFFFFFFFFFFFFFFFF` wird bei keinem Issuer über die Adresse `<Issuer>/docs/<Dokument-ID>/` bezogen (404).
- `latest.geul` der Liste ist ein nicht gespeicherter Alias. Er sucht in dieser Versionsliste die jüngste Version und liefert deren Bytes aus.

## Regeln {#규칙}

- Die Versions-ID von PUBLICATION ist lückenlos aufsteigend ab 1. Die Versions-ID vergibt die Veröffentlichungsstelle.
- Derselbe Inhaltshash wird nicht erneut veröffentlicht. Ist er schon vorhanden, wird dessen Versions-ID zurückgegeben.
- DEPRECATION und TOMBSTONE verweisen nur auf die Versions-ID eines vorher erschienenen PUBLICATION. Verweist ein Record auf eine nicht vorhandene Version, wird abgelehnt.
- Der Zustand einer Version wird berechnet, indem die Records der Reihe nach angewendet werden. Veröffentlicht → deprecated → gelöscht. Eine gelöschte Version wird weder erneut veröffentlicht noch ausgeliefert.
- Die neueste Version ist die höchste Versions-ID, die weder deprecated noch gelöscht ist.
- Erreicht die Versions-ID das Ende von 2 WORD, wird das Dokument nicht weiter veröffentlicht, sondern unter einer neuen Dokument-ID herausgegeben.

## Adressen {#주소}

```
/.well-known/geul/<Issuer>/docs/<Dokument-ID>/versions.geul    Neuestes Listendokument (veränderlich)
/.well-known/geul/<Issuer>/codecs/<Codec ID>/versions.geul     Neuestes Listendokument des Codec (veränderlich)
/.well-known/geul/issuers/versions.geul                        Neueste Versionsliste der Issuer-Liste (veränderlich)
/.well-known/geul/<Issuer>/hashes/<Inhaltshash>.geul           Frühere Listendokumente (unveränderlich)
```

- Veränderlich ist die Adresse der neuesten Liste. Eine empfangene Liste wird über Signatur, `RECORDED-AT` und die `PARENT`-Kette verifiziert.
- Alle früheren Listendokumente bleiben unter `<Issuer>/hashes/` erhalten. Über die `PARENT`-Kette lässt sich die Liste zu jedem Zeitpunkt zurückverfolgen.

## Verifikation {#검증}

- Das Listendokument muss die `SIGNATURE` des für die Veröffentlichungsstelle bestimmten Schlüssels haben.
- Die Dokument-ID der Records muss mit der angeforderten Dokument-ID übereinstimmen.
- Der in der Lock-Aufzeichnung verbliebene Inhaltshash der vorherigen Liste muss in der `PARENT`-Kette der neuen Liste stehen. Der BODY dieser Liste muss dem Anfangsteil des neuen Listen-BODY entsprechen.
- Der Inhaltshash des empfangenen Dokuments muss dem Wert entsprechen, den das PUBLICATION dieser Versions-ID angibt, und das `DOC-ID` des Dokuments muss dem angeforderten Issuer und der Dokument-ID entsprechen. Ein Listendokument hat kein `DOC-ID`.

## Offene Probleme {#열린-문제}

- Codetabelle der Begründungskategorie.
- Standardwert des Signaturalgorithmus und Payload-Layout von `SIGNATURE`.
- Zeitpunkt und Format des Wechsels zu einem Merkle-Log (Inklusions- und Konsistenznachweise), wenn die Liste wächst.
- Rollback-Schutz auf Issuer-Ebene. Da die Listen je Dokument eine eigene Kette bilden, wird ein Angriff, der nur die Liste eines Dokuments in veralteter Fassung vorlegt, allein durch die Kette dieses Dokuments abgewehrt.

## Verwandte Seiten {#관련-페이지}

- [Edge](_index.md), [BIND](0x0A3L-bind.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md)
- [Issuer und Veröffentlichung](../issuer.md), [Veröffentlichungsadresse und Versionsliste](../publishing.md), [Dokument](../document.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000B80/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000B8000000000
BODY
#1 DECLARE 0x0B80
#2 FIELD #1 record
#9 CODEC #2 0x0410
#4 FIELD #1 0x0010
#5 BIND #1 "PUBLICATION"
#6 BIND #2 "doc"
#8 BIND #4 "hash"
#10 CODEC #2 0x0420
```
