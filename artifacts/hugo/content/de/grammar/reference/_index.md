---
title: "Reference"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference", "LOCAL", "quantifier"]
summary: "Reference ist ein Record, der auf ein Objekt verweist. Die 4 Bit des Codec legen das Identifikationssystem fest (LOCAL, Wikidata, externe Dokumente usw.), die 3 Bit des Quantifier die Quantifizierung (identifiziert, generisch, universal, Variable usw.). Der reservierte Codec 0000 ist die Gruppe der Slot-Marker."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Ein Reference ist ein Record, der auf ein Objekt verweist. Das Objekt kann eine Entität, ein Konzept, ein Dokument oder ein anderes Edge sein. Man verweist nicht über Namen, sondern über IDs.

## Layout

```
TAG WORD          0000 0LLL LCCC CQQQ
[Length-Erweiterungs-TAG]
[IMPORT ID]       bei EXTERNAL-POINTER (1/2/4/8 WORD)
[Issuer]          bei EXTERNAL-ISSUER (1/2/4/16 WORD)
[Dokument-ID]     bei EXTERNAL-ISSUER (4 WORD)
Ziel-ID           der gesamte Rest
```

- `LLLL` ist die Gesamtzahl der WORD einschließlich TAG WORD minus 1 ([Record und TAG WORD](/de/grammar/record/)).
- Der Codec umfasst die 4 Bit `CCCC`, der Quantifier die 3 Bit `QQQ`. Die unteren 7 Bit des TAG WORD sind `CCCC << 3 | QQQ`.
- Die Ziel-ID ist eine vorzeichenlose Big-Endian-Ganzzahl und wird in der **kürzesten Breite** geschrieben. Die Breite ist der Rest der Length nach Abzug der vorangehenden Felder.
- Die Ziel-ID `0` wird als 1 WORD `0x0000` geschrieben. Sonst wird kein WORD `0x0000` vorangestellt.
- Gleicher ganzzahliger Wert bedeutet gleiche ID. Die Breite ist nicht Teil der ID.
- Alle Codecs verwenden die kürzeste Breite. Kein Codec legt die Breite der Ziel-ID fest.
- [ISSUER-POINTER](/de/grammar/reference/issuer-pointer/) und [DOC-POINTER](/de/grammar/reference/doc-pointer/) folgen diesem Layout nicht. Sie haben keine Ziel-ID, sondern nur den Issuer (und Dokument-ID und Versions-ID).

## Codec (`CCCC`)

| CCCC | Name | Kategorie | Ziel |
|---|---|---|---|
| `0000` | [Slot-Marker](/de/grammar/reference/slot-marker/) | Reserviert | Verweist auf kein Objekt. Verwendet werden nur 1-WORD-Marker, deren untere 3 Bit die Markernummer sind: `0x0000` ABSENT (nicht angegeben), `0x0001` UNKNOWN-VALUE (unbekannt), `0x0002` NO-VALUE (kein Wert) |
| `0001` | [LOCAL](/de/grammar/reference/local/) | Deklaration | Von diesem Dokument vergebene ID |
| `0010` | [GEUL](/de/grammar/reference/geul/) | Deklaration | Von geul.org vergebene Entität |
| `0011` | [GEUL-SIDX](/de/grammar/reference/geul-sidx/) | Deklaration | Semantisch ausgerichtete Kennung, deren Bits Bedeutung tragen |
| `0100` | [WIKIDATA-QID](/de/grammar/reference/wikidata-qid/) | Deklaration | Wikidata-Eintrag. Die ganze Zahl nach `Q` |
| `0101` | [WIKIDATA-PID](/de/grammar/reference/wikidata-pid/) | Deklaration | Wikidata-Eigenschaft. Die ganze Zahl nach `P` |
| `0110` | [ISSUER-POINTER](/de/grammar/reference/issuer-pointer/) | Zeiger-Deklaration | Der Issuer selbst |
| `0111` | [DOC-POINTER](/de/grammar/reference/doc-pointer/) | Zeiger-Deklaration | Eine Version eines vom Issuer veröffentlichten Dokuments |
| `1000`~`1011` | [EXTERNAL-POINTER-1/2/4/8WORD](/de/grammar/reference/external-pointer/) | Zeiger | LOCAL ID eines per IMPORT importierten Dokuments |
| `1100`~`1111` | [EXTERNAL-ISSUER-1/2/4/16WORD](/de/grammar/reference/external-issuer/) | Zeiger-Deklaration | LOCAL ID eines vom Issuer veröffentlichten Dokuments |

- Eine **Deklaration** identifiziert das Objekt direkt über die von der vergebenden Stelle festgelegte ID.
- Ein **Zeiger** verweist auf ein LOCAL in einem per IMPORT-ID importierten Dokument. Die unteren 2 Bit sind die Breite der IMPORT ID (`00`=1, `01`=2, `10`=4, `11`=8 WORD).
- Eine **Zeiger-Deklaration** verweist ohne IMPORT mit einem einzigen Record auf ein anderes Dokument und dessen Objekte.
- Ist das höchste Bit `0`, wird das Objekt direkt identifiziert (LOCAL dieses Dokuments, vergebene ID, Issuer/Dokument selbst), bei `1` wird auf ein LOCAL eines anderen Dokuments verwiesen.
- Der Codec `0000` ist reserviert und wird nicht als Reference verwendet, der auf ein Objekt verweist. Es gibt eine einzige Ausnahme, eine Gruppe: Die WORDs `0x0000`~`0x0007` (Codec `0000`, 1 WORD) sind [Slot-Marker](/de/grammar/reference/slot-marker/). Derzeit werden drei verwendet (`0x0000` ABSENT, `0x0001` UNKNOWN-VALUE, `0x0002` NO-VALUE). Ein Marker ist nur an einer Stelle eines Record-Feldes gültig, dessen CODEC-Ziel genau dieses WORD ist. Wildcards und Felder ohne CODEC akzeptieren ihn nicht, an Stellen für HEAD-/BODY-Records und für Edge Ids ist er invalid. `0x0003`~`0x0007` und Codec `0000` mit Payload sind reserviert.
- Identifikationssysteme, die nicht unter CC0 stehen (WordNet usw.), werden nicht als Reference-Codec geführt. Reference hat auch keinen ISSUER-Code, in den man sie als Issuer-Format verlagern könnte.

### Häufig verwendete TAGs

| Record | WORD |
|---|---|
| LOCAL 1 | `0088 0001` |
| LOCAL 65536 | `0108 0001 0000` |
| Wikidata Q5 (Mensch) | `00A0 0005` |
| Wikidata Q691283 | `0120 000a 8c53` |
| Wikidata P31 (instance of) | `00A8 001f` |
| Slot-Marker ABSENT / UNKNOWN-VALUE / NO-VALUE | `0000` / `0001` / `0002` |

## LOCAL

LOCAL ist eine von diesem Dokument vergebene ID. Sie hat nur innerhalb des Dokuments Bedeutung.

- **Sie ist eindeutig.** In einem Dokument verweist eine LOCAL ID auf genau ein Objekt.
- **0 wird nicht vergeben.** Ziel-IDs werden ab 1 vergeben.
- **Es wird empfohlen, aufsteigend zu vergeben** (auto increment). Die Größe der ID hat keine Bedeutung.
- Sie verweist über Versionen hinweg auf dasselbe Objekt. Eine gestrichene ID wird nicht wiederverwendet ([Dokument](/de/grammar/document/), Revision).
- Damit man von außerhalb des Dokuments darauf verweisen kann, muss das Dokument eine `DOC-ID` haben.
- Dass LOCAL IDs verschieden sind, heißt nicht, dass es in der Wirklichkeit verschiedene Objekte sind. Gleiche verbindet man mit einem `SAME-NODE`-Edge, verschiedene mit einem `DIFFERENT-NODE`-Edge.

### Edge Id

Jedes Edge hat als erstes Element seines Payloads ein LOCAL Reference. Diese LOCAL ID ist die **Edge Id**.

- Die Edge Id lässt sich auch ohne Kenntnis des Codebooks lesen.
- Das LOCAL an der Stelle der Edge Id ist eine Deklaration, das LOCAL an anderen Stellen eines Edge eine Erwähnung.
- Das LOCAL, das eine Edge Id deklariert, verwendet nur den Quantifier `000`.
- Auf andere Edges verweist man über die Edge Id. Auf Edges dieses Dokuments mit LOCAL, auf Edges anderer Dokumente mit einem Zeiger-Reference.

## Auf andere Dokumente verweisen

| Was | Wie |
|---|---|
| Der Issuer selbst | `ISSUER-POINTER` (Issuer) |
| Eine Dokumentversion | `DOC-POINTER` (Issuer, Dokument-ID 4 WORD, Versions-ID 2 WORD). Version `0` ist die neueste |
| Objekt in einem veröffentlichten Dokument (neueste Fassung) | `EXTERNAL-ISSUER-*` (Issuer, Dokument-ID, LOCAL ID) |
| Objekt in einem importierten Dokument (Fassung festgelegt) | Mit Meta `IMPORT-DOC` eine IMPORT ID vergeben und `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) verwenden |

- Ein Dokument selbst wird, innerhalb wie außerhalb des Dokuments, nur mit einem einzigen DOC-POINTER angesprochen. Es selbst ist der DOC-POINTER seiner eigenen `DOC-ID`.
- EXTERNAL-ISSUER folgt der neuesten Version. Um eine Fassung festzulegen, verwendet man IMPORT.
- Der Issuer wird in der kürzesten Breite (1/2/4/16 WORD) geschrieben, und der zu dieser Breite passende Codec wird gewählt.
- Die Dokument-ID `0` jedes Issuers ist für das Indexdokument der von diesem Issuer definierten Begriffe (Werkzeuge, Rollen usw.) reserviert. Das Indexdokument wird allen Issuern empfohlen und ist nicht verpflichtend ([Issuer und Veröffentlichung](/de/grammar/issuer/#begriffsdefinitionsdokumente)).

Beispiel: LOCAL 7 im Dokument von Issuer `0x0001` mit der Dokument-ID `0x0000000000000002`

```
0360 0001 0000 0000 0000 0002 0007
```

## Quantifier (`QQQ`)

| QQQ | Name | Bedeutung | Beispiel |
|---|---|---|---|
| `000` | Identified | Identifizierte Entität | Elon Musk, Deutschland |
| `001` | Generic | Allgemeine Aussage über eine ganze Art. Ausnahmen sind zulässig | Soldaten gehorchen Befehlen |
| `010` | Free-choice | Ein beliebiges Objekt, das die Bedingung erfüllt | irgendein Soldat |
| `011` | Universal | Alle Objekte im Bereich | alle Soldaten |
| `100` | Variable | Diskursvariable | dieser Mann, diese Frau |
| `101`~`111` | Reserviert | | |

- **Ausnahme: Beim Codec `0000` (Slot-Marker) sind die unteren 3 Bit nicht der Quantifier, sondern die Markernummer.** Markernummer und Bedeutung des Quantifiers hängen nicht zusammen (`0x0001` UNKNOWN-VALUE ist nicht Generic). Die Quantifier dieser Tabelle gelten nur für die Codecs `0001`~`1111`.
- Generic bedeutet anders als Universal nicht, dass es ausnahmslos auf jedes einzelne Objekt zutrifft. Definitorische Ausdrücke wie „Was ist ein Soldat“ lassen sich mit Generic schreiben. Braucht man eine strenge Begriffs- oder Klassifikationsdefinition, konkretisiert man sie durch eine eigene Beziehung.
- Reichweite und Negation einer Quantifizierung bestimmt nicht das Reference, sondern das Edge, das es verwendet.
- Eine **Variable** ist ein Objekt im Diskurs, dessen Art man kennt, das aber noch nicht identifiziert ist.
  - Benannte Variablen entstehen, indem man LOCAL mit Variable versieht. Dieselbe LOCAL ID ist dieselbe Variable. Die Art verbindet man per Edge.
  - Anonyme Variablen entstehen, indem man den Deklarations-Codec, der auf die Art verweist (GEUL, WIKIDATA-*), mit Variable versieht (z. B. Wikidata „Präsident“ + Variable). Koreferenz wird nicht verfolgt, und man kann sie nicht erneut ansprechen. Anonyme Variablen gelten untereinander nicht als dieselbe Variable.
  - Wird das Objekt später bekannt, verbindet man die Variable per `SAME-NODE` mit diesem Objekt. Alle Ausdrücke, die auf dieselbe Variable verweisen, werden gemeinsam auf dieses Objekt aufgelöst.
  - Auch verschiedene Variablen bedeuten nicht, dass die tatsächlichen Objekte verschieden sind. Gleiche verbindet man per `SAME-NODE`, verschiedene per `DIFFERENT-NODE`.
  - Variablen gelten nur innerhalb des Dokuments und werden nicht als dauerhafte Kennung verwendet.
  - Die Variable der externen Zeiger-Codecs (EXTERNAL-POINTER-*, EXTERNAL-ISSUER-*) ist eine LOCAL-Variable des Dokuments, auf das verwiesen wird.
  - Beispiel: Ist in „Der Präsident hielt eine Rede“ die Person nicht feststehend, verwendet man die Variable „Präsident“. Um sie erneut zu erwähnen, legt man eine LOCAL-Variable an und verbindet die Art „Präsident“ per Edge. Stellt sich später heraus, dass es Obama war, verbindet man diese Variable per `SAME-NODE` mit Obama (Identified). Alle Ausdrücke, die auf dieselbe Variable verweisen, werden gemeinsam als Obama aufgelöst.
- Beispiel: Verwendet man Wikidata Q5 (Mensch) als Generic, ergibt das `00A1 0005` („Der Mensch ist …“).
