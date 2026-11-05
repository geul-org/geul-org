---
title: "DELTA-BASE (0x1DBL)"
weight: 475
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Marker dafür, dass diese Versionsdatei kein Snapshot, sondern ein Diff gegen eine Basisversion desselben Dokuments ist (Delta eines git packfile)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `DELTA-BASE` (Spezifikationsdokument BIND `DELTA-BASE`) |
| TAG ID | `0x1DBL` |
| Codec ID | `0x00001DB0` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001DB0/` (DECLARE-Ziel `1DB0`) |
| Abschnitt | 14 `1110` (Meta), Offset im Abschnitt C = 27 |
| Kind | Meta · Klasse: Abstammung |
| TAG WORD | `0001 1101 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Diese Versionsdatei ist ein Diff gegen eine Basisversion (2-WORD-Versions-ID) desselben Dokuments (git packfile delta) |
| Hugo-Seite | `meta/lineage/delta-base.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `version` | #2 | Rohwert 2 WORD | `0620` UNSIGNED-INTEGER |  |

Marker dafür, dass diese Versionsdatei kein Snapshot, sondern ein **Diff** gegen eine Basisversion desselben Dokuments ist (Delta eines git packfile). Die Version selbst wird weiterhin als Snapshot definiert. Inhaltshash, Versionsliste und Signatur beziehen sich alle auf den Snapshot, der durch Anwenden des Diffs wiederhergestellt wird ([Diff-Speicherung](../document.md#diff-저장)).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1011 LLLL      Codec 0x1DBL
Versions-ID       2 WORD unsigned (Basisversion desselben Dokuments)
```

- Codec: Meta `0x1DBL`, Abstammungsklasse
- Payload: 2-WORD-Versions-ID (Rohwert)
- Anzahl: höchstens eines

## Interpretation und Gültigkeit {#해석과-유효성}

- Wird nur bei Dokumenten mit [DOC-ID](0x1C7L-doc-id.md) verwendet. Die Versionsliste `versions.geul`, Listendokumente (Versionen von `issuers/`) und namenlose Dokumente, die keine `DOC-ID` haben, bekommen keinen Diff.
- Die Basisversion ist eine veröffentlichte Version derselben `DOC-ID` und liegt vor dieser Version. `0` (keine Version) ist invalid.
- Der Inhaltshash des wiederhergestellten Snapshots muss mit dem Hash dieser Version in der Versionsliste ([PUBLICATION](../edge/0x0B8L-publication.md)) übereinstimmen. Andernfalls ist dieser Diff invalid. Deshalb wird der Ergebnishash nicht gesondert im Diff vermerkt.
- Nur Dokumente, in denen alle Records des BODY Edges sind (Records mit Edge Id), können als Diff abgelegt werden. Denn die Diff-Einheit ist die LOCAL ID (Edge Id).
- Die Regeln zur Wiederherstellung des Snapshots folgen [Diff-Speicherung](../document.md#diff-저장). Das Löschen übernimmt [DELTA-REMOVE](0x1DCL-delta-remove.md).
- Marker für Hinzufügung oder Revision gibt es nicht. Ist die Edge Id im Diff-BODY in der Basis vorhanden, ist es eine Revision, andernfalls eine Hinzufügung. Hinzufügungen erhalten ihre Nummer ab [NEXT-LOCAL-ID](0x1DDL-next-local-id.md) der Versionsliste. Die Wiederverwendung einer gelöschten LOCAL ID ist invalid ([Revision](../document.md#개정)).

## Beispiel {#예시}

Diff gegen Basisversion 3:

```
1DB2 0000 0003
```

- TAG `1DB2` (Meta `0x1DBL`, `LLLL=0010`, 3 WORD), Versions-ID `0000 0003`.

## Offene Probleme {#열린-문제}

1. Snapshot-Abstand: nach wie vielen Versionen ein vollständiger Snapshot angelegt wird (Länge der Diff-Kette und Wiederherstellungskosten).
2. Ob die Basisversion auf die unmittelbar vorangehende Version beschränkt wird.
3. Speicherort der Diff-Datei: ob am Platz der Versionsdatei (`<Versions-ID>.geul`), und das Verhältnis zur Inhaltshash-Adresse `<Issuer>/hashes/` (`hashes/` wird über den Inhaltshash des Snapshots gefunden).

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001DB0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DB000000000
BODY
#1 DECLARE 0x1DB0
#2 FIELD #1 0x0002
#3 BIND #1 "DELTA-BASE"
#4 BIND #2 "version"
#5 CODEC #2 0x0620
```
