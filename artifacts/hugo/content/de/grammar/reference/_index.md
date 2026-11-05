---
title: "Reference"
weight: 90
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "LOCAL", "quantifier"]
summary: "Reference ist ein Record, der ein Objekt bezeichnet."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Reference ist ein Record, der ein Objekt bezeichnet. Das Objekt kann eine Entität, ein Konzept, ein Dokument oder ein anderer Edge sein. Es wird nicht über den Namen, sondern über die ID bezeichnet.

## Layout {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      Abschnitt 0~2 (0x000L~0x05FL)
[Length-Erweiterungs-TAG]
[IMPORT ID]       bei EXTERNAL-POINTER (1/2/4 WORD)
[Issuer]          bei EXTERNAL-ISSUER (2/4/16 WORD)
[Dokument-ID]     bei EXTERNAL-ISSUER (4 WORD)
Ziel-ID           der gesamte Rest
```

- `LLLL` ist die Gesamtzahl der WORD einschließlich des TAG WORD − 1 ([Record und TAG WORD](../record.md)).
- Reference umfasst die 96 Plätze der Abschnitte 0~2 (`w < 0x0600`). Abschnitt 0 Entität `0x000L~0x01FL`, Abschnitt 1 EXTERNAL `0x020L~0x03FL`, Abschnitt 2 Sonstige `0x040L~0x05FL`.
- Der Codec wird als Codetabelle geschrieben (Tabelle unten). Beim 5Q-System stecken in einem Code zugleich Identifikationssystem und Quantifizierung. Die Quantifizierung von REFERENCE-ISSUER bestimmt das Issuer-Dokument.
- Die Ziel-ID ist eine vorzeichenlose Big-Endian-Ganzzahl und wird in der **kürzesten Breite** geschrieben. Die Breite ist der Rest der Length nach Abzug der vorangehenden Felder.
- Die Ziel-ID `0` wird als `0x0000`, 1 WORD, geschrieben. Sonst wird kein WORD `0x0000` vorangestellt.
- Gleicher ganzzahliger Wert heißt gleiche ID. Die Breite ist kein Teil der ID.
- Alle Codecs verwenden die kürzeste Breite. Kein Codec legt die Breite der Ziel-ID fest.
- [ISSUER-POINTER](0x040L-issuer-pointer.md), [DOC-POINTER](0x041L-doc-pointer.md) und [CODEC-POINTER](0x042L-codec-pointer.md) folgen diesem Layout nicht. Sie haben keine Ziel-ID und führen nur den Issuer (und Dokument-ID, Codec ID, Versions-ID).
- Auch [REFERENCE-ISSUER](#reference-issuer) folgt diesem Layout nicht. Es sind TAG, Issuer, Codec-Nummer 2 WORD und Payload. Den Payload bestimmt das vom Issuer herausgegebene Codec-Dokument.

## Codec {#codec}

| TAG ID | Name | Klasse | Ziel |
|---|---|---|---|
| `0x000L~0x002L` | [Slot-Marker](../slot-marker.md) | Slot-Marker | Bezeichnet kein Objekt. Es wird nur ein Marker mit 1 WORD geschrieben: `0x0000` ABSENT (nicht angegeben), `0x0010` UNKNOWN-VALUE (unbekannt), `0x0020` NO-VALUE (keiner) |
| `0x005L~0x009L` | [LOCAL](0x005L-local.md) | Deklaration | Vom Dokument vergebene ID |
| `0x00AL~0x00EL` | [GEUL](0x00AL-geul.md) | Deklaration | Von geul.org vergebene Entität |
| `0x00FL~0x013L` | [GEUL-SIDX](0x00FL-geul-sidx.md) | Deklaration | Semantisch ausgerichtete Kennung, deren Bits Bedeutung tragen |
| `0x014L~0x018L` | [WIKIDATA-QID](0x014L-wikidata-qid.md) | Deklaration | Wikidata-Item. Ganzzahl nach dem `Q` |
| `0x019L~0x01DL` | [WIKIDATA-PID](0x019L-wikidata-pid.md) | Deklaration | Wikidata-Eigenschaft. Ganzzahl nach dem `P` |
| `0x020L~0x02EL` | [EXTERNAL-POINTER-1/2/4WORD](0x020L-external-pointer-1word.md) | Zeigen | LOCAL ID eines per IMPORT importierten Dokuments |
| `0x02FL~0x03DL` | [EXTERNAL-ISSUER-2/4/16WORD](0x02FL-external-issuer-2word.md) | Zeigen-und-Deklarieren | LOCAL ID eines vom Issuer veröffentlichten Dokuments |
| `0x040L` | [ISSUER-POINTER](0x040L-issuer-pointer.md) | Zeigen-und-Deklarieren | Der Issuer selbst |
| `0x041L` | [DOC-POINTER](0x041L-doc-pointer.md) | Zeigen-und-Deklarieren | Eine Version eines vom Issuer veröffentlichten Dokuments |
| `0x042L` | [CODEC-POINTER](0x042L-codec-pointer.md) | Zeigen-und-Deklarieren | Eine Version eines vom Issuer veröffentlichten Codecs |
| `0x05DL~0x05FL` | [REFERENCE-ISSUER-2/4/16WORD](#reference-issuer) | Issuer-Format | Vom Issuer definiert. Klasse und Ziel-ID-Platz bestimmt das Issuer-Dokument |

- Reserved sind `0x003L~0x004L`, `0x01EL~0x01FL` (Abschnitt 0), `0x03EL~0x03FL` (Abschnitt 1) und `0x043L~0x05CL` (Abschnitt 2, Platz für neue Identifikationssysteme).
- Die Systemnummer liest man aus dem Offset im Abschnitt `C`. In Abschnitt 0 ist bei `5 <= C < 30` das System `C / 5` (1~5), in Abschnitt 1 bei `C < 30` das System `6 + C / 5` (6~11).

| System | Name | Identified | Generic | Free-choice | Universal | Variable |
|---:|---|---|---|---|---|---|
| 1 | LOCAL | `0x005L` | `0x006L` | `0x007L` | `0x008L` | `0x009L` |
| 2 | GEUL | `0x00AL` | `0x00BL` | `0x00CL` | `0x00DL` | `0x00EL` |
| 3 | GEUL-SIDX | `0x00FL` | `0x010L` | `0x011L` | `0x012L` | `0x013L` |
| 4 | WIKIDATA-QID | `0x014L` | `0x015L` | `0x016L` | `0x017L` | `0x018L` |
| 5 | WIKIDATA-PID | `0x019L` | `0x01AL` | `0x01BL` | `0x01CL` | `0x01DL` |
| 6 | EXTERNAL-POINTER-1WORD | `0x020L` | `0x021L` | `0x022L` | `0x023L` | `0x024L` |
| 7 | EXTERNAL-POINTER-2WORD | `0x025L` | `0x026L` | `0x027L` | `0x028L` | `0x029L` |
| 8 | EXTERNAL-POINTER-4WORD | `0x02AL` | `0x02BL` | `0x02CL` | `0x02DL` | `0x02EL` |
| 9 | EXTERNAL-ISSUER-2WORD | `0x02FL` | `0x030L` | `0x031L` | `0x032L` | `0x033L` |
| 10 | EXTERNAL-ISSUER-4WORD | `0x034L` | `0x035L` | `0x036L` | `0x037L` | `0x038L` |
| 11 | EXTERNAL-ISSUER-16WORD | `0x039L` | `0x03AL` | `0x03BL` | `0x03CL` | `0x03DL` |

- **Deklaration** identifiziert das Objekt direkt über eine vom Aussteller bestimmte ID.
- **Zeigen** bezeichnet ein LOCAL in einem Dokument, das über eine IMPORT ID importiert wurde. Die Breite der IMPORT ID wird durch das System bestimmt: Ist System − 6 gleich 0, 1 oder 2, beträgt sie 1, 2 bzw. 4 WORD.
- **Zeigen-und-Deklarieren** bezeichnet mit einem einzigen Record ohne IMPORT ein anderes Dokument und ein Objekt darin. Die Breite des Issuer bei EXTERNAL-ISSUER ist 2, 4 bzw. 16 WORD, wenn System − 9 gleich 0, 1 oder 2 ist.
- `0x020L~0x03DL` (Abschnitt 1, Systeme 6~11) bezeichnen das LOCAL eines anderen Dokuments. Die übrigen Deklarationssysteme identifizieren das Objekt direkt (LOCAL dieses Dokuments, vergebene ID). Die Pointer (Abschnitt 2, `0x040L~0x042L`) bezeichnen Issuer, Dokument und Codec selbst. REFERENCE-ISSUER liegt außerhalb dieser Unterscheidung.
- `0x000L~0x002L` sind den Slot-Markern zugewiesene Codes und werden nicht als Reference verwendet, der ein Objekt bezeichnet. Die WORD `0x0000`, `0x0010` und `0x0020` (L 0, 1 WORD) sind [Slot-Marker](../slot-marker.md) (`0x0000` ABSENT, `0x0010` UNKNOWN-VALUE, `0x0020` NO-VALUE). Ein Marker ist nur an einem Record-Feld-Slot gültig, das genau dieses WORD als CODEC-Ziel führt. Wildcards und Felder ohne CODEC nehmen ihn nicht an, und an Record-Slots von HEAD und BODY sowie an Edge-Id-Slots ist er invalid. Eine TAG-Form mit Payload (L ≥ 1) bei C 0~2 ist Reserved.
- Nur die von geul.org bereitgestellten Direktcodes und Veröffentlichungen stehen unter CC0. Nicht-CC0-Identifikationssysteme (WordNet usw.) werden nicht als Direktcode aufgenommen. Die Lizenz eines Issuer-Formats bestimmt dieser Issuer.

### Häufig verwendete TAG {#자주-쓰는-tag}

| Record | WORD |
|---|---|
| LOCAL 1 | `0051 0001` |
| LOCAL 65536 | `0052 0001 0000` |
| Wikidata Q5 (Mensch) | `0141 0005` |
| Wikidata Q691283 | `0142 000A 8C53` |
| Wikidata P31 (ist ein(e)) | `0191 001F` |
| Slot-Marker ABSENT / UNKNOWN-VALUE / NO-VALUE | `0000` / `0010` / `0020` |

## LOCAL {#local}

LOCAL ist eine vom Dokument vergebene ID.

- **Sie ist eindeutig.** In einem Dokument bezeichnet eine LOCAL ID genau ein Objekt.
- **0 wird nicht vergeben.** Ziel-IDs werden ab 1 vergeben.
- **Es wird empfohlen, aufsteigend zu vergeben** (auto increment). Die Größe der ID hat keine Bedeutung.
- Über Versionen hinweg bezeichnet sie dasselbe Objekt. Gelöschte ID werden nicht wiederverwendet (Revision des [Dokuments](../document.md)).
- Damit man von außerhalb des Dokuments darauf verweisen kann, muss das Dokument eine `DOC-ID` haben.
- Verschiedene LOCAL ID bedeuten nicht, dass es in der Wirklichkeit verschiedene Objekte sind. Gleich verbindet man mit einem `SAME-NODE`-, verschieden mit einem `DIFFERENT-NODE`-Edge.

### Edge Id {#edge-id}

Jeder Edge hat als erstes Element des Payloads ein LOCAL-Reference. Diese LOCAL ID ist die **Edge Id**.

- Die Edge Id lässt sich auch ohne Kenntnis des Codebuchs lesen.
- Das LOCAL am Edge-Id-Slot ist eine Deklaration, ein LOCAL an anderer Stelle des Edge ist eine Erwähnung.
- Für die Deklaration einer Edge Id wird nur Identified (`0x005L`) verwendet.
- Auf einen anderen Edge verweist man über die Edge Id: auf einen Edge dieses Dokuments mit LOCAL, auf einen Edge eines anderen Dokuments mit einem zeigenden Reference.

## Auf andere Dokumente verweisen {#다른-문서-가리키기}

| Was | Wie |
|---|---|
| Der Issuer selbst | `ISSUER-POINTER` (Issuer) |
| Eine Dokumentversion | `DOC-POINTER` (Issuer, Dokument-ID 4 WORD, Versions-ID 2 WORD). Version `0` ist die neueste |
| Eine Codec-Version | `CODEC-POINTER` (Issuer, Codec ID 2 WORD, Versions-ID 2 WORD). Version `0` ist die neueste |
| Ein Objekt in einem veröffentlichten Dokument (neueste) | `EXTERNAL-ISSUER-*` (Issuer, Dokument-ID, LOCAL ID) |
| Ein Objekt in einem importierten Dokument (Ausgabe fest) | Mit dem Meta `IMPORT-DOC` eine IMPORT ID vergeben und `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) |

- Auf ein Dokument selbst verweist man, innerhalb wie außerhalb dieses Dokuments, nur mit einem einzigen DOC-POINTER. Auf sich selbst verweist man mit dem DOC-POINTER auf die eigene `DOC-ID`. Codec-Dokumente sind eine Ausnahme und werden mit CODEC-POINTER bezeichnet (auch `DOC-ID` ist CODEC-POINTER).
- EXTERNAL-ISSUER folgt der neuesten Version. Um die Ausgabe festzulegen, verwendet man IMPORT.
- Der Issuer wird in der kürzesten Breite geschrieben, in die der Wert passt (2/4/16 WORD), und der zu dieser Breite passende Codec gewählt. Bei EXTERNAL-ISSUER und REFERENCE-ISSUER ist das gleich.
- Die Dokument-ID `0` jedes Issuer ist als Indexdokument der von diesem Issuer definierten Begriffe (Werkzeuge, Rollen usw.) reserviert. Das Indexdokument wird für alle Issuer empfohlen und ist nicht verpflichtend ([Issuer und Veröffentlichung](../issuer.md#용어-정의-문서)).

Beispiel: LOCAL 7 im Dokument `0x0000000000000002` des Issuer `0x00000002`

```
02F7 0000 0002 0000 0000 0000 0002 0007
```

## Quantifier {#quantifier}

| `C % 5` | Name | Bedeutung | Beispiel |
|---|---|---|---|
| `0` | Identified | Identifiziertes Individuum | Elon Musk, Südkorea |
| `1` | Generic | Allgemeine Aussage über eine ganze Art. Ausnahmen sind zulässig | Soldaten gehorchen Befehlen |
| `2` | Free-choice | Ein beliebiges Objekt, das die Bedingung erfüllt | irgendein Soldat |
| `3` | Universal | Alle Objekte im Bereich | alle Soldaten |
| `4` | Variable | Diskursvariable | diese Person, diese Frau |

- **Die Quantifizierung wird nur im 5Q-System gelesen (Systeme 1~11).** Sie ergibt sich aus dem Offset im Abschnitt `C`: In Abschnitt 0 ist es bei `5 <= C < 30`, in Abschnitt 1 bei `C < 30` die Quantifizierung `C % 5`. Da ein Abschnitt 32 Plätze hat, würde ein Teilen des 9-Bit-Codec-Platzes (`w >> 4`) durch 5 in Abschnitt 1 verrutschen. Marker (Abschnitt 0, `C < 3`) und Abschnitt 2 (Pointer, REFERENCE-ISSUER) haben keine Quantifizierung. Der Marker `0x0010` UNKNOWN-VALUE ist nicht Generic. Die Quantifizierung von REFERENCE-ISSUER bestimmt das vom Issuer herausgegebene Codec-Dokument.
- Generic bedeutet anders als Universal nicht, dass es ausnahmslos für alle einzelnen Objekte gilt. Definitorische Ausdrücke wie „Was ist ein Soldat“ lassen sich als Generic schreiben. Wird eine strenge Definition von Begriff oder Klassifikation gebraucht, konkretisiert man sie durch eine eigene Relation.
- Den Geltungsbereich und die Negation einer Quantifizierung bestimmt nicht das Reference, sondern der Edge, der es verwendet.
- **Variable** ist ein Objekt im Diskurs, dessen Art bekannt, das aber noch nicht identifiziert ist.
  - Eine benannte Variable bildet man, indem man an LOCAL Variable hängt. Gleiche LOCAL ID heißt gleiche Variable. Die Art verbindet man über einen Edge.
  - Eine anonyme Variable bildet man, indem man an einen deklarierenden Codec, der die Art bezeichnet (GEUL, WIKIDATA-*), Variable hängt (Beispiel: Wikidata „Präsident“ + Variable). Koreferenz wird nicht verfolgt, und man kann nicht erneut darauf verweisen. Anonyme Variablen gelten untereinander nicht als dieselbe Variable.
  - Wird das Objekt später bestätigt, verbindet man die Variable mit `SAME-NODE` mit diesem Objekt. Alle Ausdrücke, die auf dieselbe Variable verweisen, werden gemeinsam zu diesem Objekt aufgelöst.
  - Auch verschiedene Variablen heißen nicht, dass die tatsächlichen Objekte verschieden sind. Gleich verbindet man mit `SAME-NODE`, verschieden mit `DIFFERENT-NODE`.
  - Die Variable der externen zeigenden Codecs (EXTERNAL-POINTER-*, EXTERNAL-ISSUER-*) ist eine LOCAL-Variable des bezeichneten Dokuments.
  - Beispiel: Ist im Satz „Der Präsident hielt eine Rede“ die Person nicht feststehend, verwendet man die Variable ‚Präsident‘. Um erneut darauf zu verweisen, legt man eine LOCAL Variable an und verbindet die Art ‚Präsident‘ über einen Edge. Wird später Obama bestätigt, verbindet man diese Variable mit dem Identified Obama über `SAME-NODE`. Alle Ausdrücke, die auf dieselbe Variable verweisen, werden gemeinsam zu Obama aufgelöst.
- Beispiel: Wikidata Q5 (Mensch) als Generic geschrieben ist `0151 0005` („Menschen sind …“).

## REFERENCE-ISSUER {#reference-issuer}

REFERENCE-ISSUER ist ein vom Issuer definiertes Reference-Format. Es sind die letzten drei Plätze des Reference-Bereichs. Das Layout ist dasselbe wie beim ISSUER von Value und Edge ([Record und TAG WORD](../record.md#issuer-형식-레코드)).

### Layout {#레이아웃-1}

```
TAG WORD          0000 0101 11WW LLLL      Codec 0x05DL / 0x05EL / 0x05FL (WW = Breite des Issuer: 01 2, 10 4, 11 16 WORD)
[Length-Erweiterungs-TAG]
Issuer            2/4/16 WORD (der Codec bestimmt die Breite)
Codec-Nummer      2 WORD. Wird vom Issuer definiert
Payload           Bestimmt das vom Issuer herausgegebene Codec-Dokument
```

| Codec | Name | Breite des Issuer |
|---|---|---|
| `0x05DL` | [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md) | 2 WORD |
| `0x05EL` | [REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md) | 4 WORD |
| `0x05FL` | [REFERENCE-ISSUER-16WORD](0x05FL-reference-issuer-16word.md) | 16 WORD |

- Jeder Code hat eine Seite: [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md), [REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md), [REFERENCE-ISSUER-16WORD](0x05FL-reference-issuer-16word.md).
- Das Codec-Dokument des GEUL-Issuer ist pro Code eines und enthält drei FIELD: Issuer (2·4·16 WORD), Codec-Nummer (2 WORD), Payload (bestimmt der Issuer-Codec).

### Interpretation und Gültigkeit {#해석과-유효성}

- GEUL kennt über Length nur die Grenze des Payloads. Der Payload wird nicht ohne Codebuch interpretiert.
- Bedeutung und Quantifizierung der Codec-Nummer bestimmt der Issuer. Auch was bezeichnet wird, bestimmt das vom Issuer herausgegebene Codec-Dokument.
- Die gemeinsamen Reference-Regeln gelten nicht: kürzeste Breite der Ziel-ID, Schreibweise der Ziel-ID `0` mit 1 WORD, Quantifier, Lesen von Quantifizierung und System aus dem Offset im Abschnitt, Einteilung in Deklaration und Zeigen, bezeichnetes Objekt.
- Die Codec-Nummer mit 2 WORD ist dieselbe wie beim ISSUER von Value und Edge. Reichen die Nummern nicht aus, lässt man sich einen weiteren Issuer ausstellen.
- Ein Decoder, der das Format nicht kennt, kennt Kind, Length, Issuer und Codec-Nummer und überspringt den Rest mittels Length.
- Die Lizenz eines Issuer-Formats bestimmt dieser Issuer ([Issuer und Veröffentlichung](../issuer.md#라이선스)).

### Verwandte Seiten {#관련-페이지}

- [Record und TAG WORD](../record.md), [Issuer und Veröffentlichung](../issuer.md)
