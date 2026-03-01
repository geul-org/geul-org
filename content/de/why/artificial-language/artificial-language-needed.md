---
title: "Warum wird eine künstliche Sprache benötigt?"
weight: 7
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["künstliche Sprache", "natürliche Sprache", "Halluzination", "LLVM IR"]
summary: "Die natürliche Sprache hat sich für die menschliche Kommunikation entwickelt. Mehrdeutigkeit, Redundanz und Implikation sind Stärken für Menschen, aber Ursachen von Halluzinationen für KI. Weder Programmiersprachen noch bestehende semantische Frameworks sind die Antwort. Eine neue künstliche Sprache, die sechs Bedingungen gleichzeitig erfüllt, wird benötigt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

## Natuerliche Sprache hat uns hierher gebracht. Aber weiter geht es nicht.

---

## Die grosse Erfindung der natuerlichen Sprache

Die groesste Technologie, die die Menschheit je geschaffen hat, ist die natuerliche Sprache.

Nicht die Entdeckung des Feuers, nicht die Erfindung des Rads, nicht die Erfindung des Halbleiters.
Was all das ermoeglicht hat, war die natuerliche Sprache.

Weil natuerliche Sprache existierte, konnte Wissen uebertragen werden.
Weil natuerliche Sprache existierte, war Kooperation moeglich.
Weil natuerliche Sprache existierte, konnten die Gedanken der Toten von den Lebenden geerbt werden.

Der Grund, warum Homo sapiens die Erde beherrscht, sind nicht die Muskeln --- es ist die Sprache.
Zehntausende Jahre lang war natuerliche Sprache das Medium aller intellektuellen Aktivitaet der Menschheit.

Und jetzt ist natuerliche Sprache zum Flaschenhals des KI-Zeitalters geworden.

---

## Warum ist natuerliche Sprache entstanden?

Um dieses Problem zu verstehen, muessen wir zum urspruenglichen Zweck der natuerlichen Sprache zurueckkehren.

Natuerliche Sprache hat sich fuer die **Echtzeit-Kommunikation zwischen Menschen** entwickelt.

Als unsere fruehen Vorfahren in der Savanne jagten,
brauchte man fuer die Botschaft "Da drueben ist ein Loewe!"
keine praezise logische Struktur, sondern schnelle Uebermittlung.

Dieser evolutionaere Druck bestimmte alle Eigenschaften der natuerlichen Sprache.

**Mehrdeutigkeit ist ein Feature.**
Es spielt keine Rolle, ob "da drueben" genau wie viele Meter bedeutet.
Der Zuhoerer dreht den Kopf und sieht den Loewen.
Kontext gleicht die Mehrdeutigkeit aus.

**Redundanz ist ein Feature.**
Selbst wenn die Haelfte der Nachricht vom Wind verschluckt wird, muss der Sinn ankommen.
Deshalb drueckt natuerliche Sprache denselben Gedanken auf verschiedene Weisen aus.

**Implikation ist ein Feature.**
Dass "Haben Sie schon gegessen?" in vielen Kulturen als Grussformel dienen kann,
liegt daran, dass der geteilte kulturelle Kontext die Implikation entschluesselt.

Alle diese Eigenschaften sind Vorteile in der Mensch-zu-Mensch-Kommunikation.
Schnell, flexibel, kontextanpassend.

Das Problem entsteht, wenn man das auf KI anwenden will.

---

## Was ist natuerliche Sprache fuer KI?

Aktuelle LLMs empfangen natuerliche Sprache als Eingabe, denken in natuerlicher Sprache und geben natuerliche Sprache aus.

Das ist, als wuerde man ein Chemie-Experiment durchfuehren
und alle Messungen mit "ziemlich viel", "ein bisschen", "ungefaehr so viel" notieren.

"Friedrich der Grosse war bedeutend."

Was passiert, wenn KI diesen Satz verarbeitet?

Wer sagt, dass er bedeutend war? Der Sprecher? Die Geschichtswissenschaft? Die deutsche Gesellschaft?
Nach welchen Kriterien bedeutend? Militaerisch? Moralisch? Historischer Einfluss?
Zu welchem Zeitpunkt? Zu seiner Zeit? Heute?
Wie sicher? Tatsache? Meinung? Spekulation?

Nichts davon ist in der natuerlichen Sprache angegeben.
Alles ist nur impliziert: "Erschliessen Sie es aus dem Kontext."

Menschen verfuegen ueber Zehntausende Jahre evolutionaerer Hardware, um solche Implikationen zu entschluesseln.
Gesichtsausdruecke, Tonfall, geteilte Erfahrungen, kultureller Hintergrund.
KI hat nichts davon. Sie hat nur Text.

Deshalb raet KI. Und sie praesentiert ihre Vermutungen als Gewissheiten.
Wir nennen das "Halluzination".

Halluzination ist kein Bug. Solange natuerliche Sprache als Denksprache der KI verwendet wird,
ist es ein strukturell unvermeidliches Ergebnis.

---

## Halluzination entsteht aus der Mehrdeutigkeit natuerlicher Sprache

Praezisieren wir diesen Punkt weiter.

Wenn ein LLM antwortet "Friedrich der Grosse starb am 17. August 1786 in Potsdam",
was ist die Grundlage dieser Aussage?

Weil aehnliche Muster zu diesem Satz mit hoher Wahrscheinlichkeit in den Trainingsdaten auftraten.

Aber aus welcher Quelle dieses Muster stammt,
wie zuverlaessig diese Quelle ist,
auf welchen Zeitpunkt sich diese Information bezieht,
ob es widerspruechliche andere Darstellungen gibt ---
all das kann strukturell nicht in natuerlichsprachlicher Ausgabe enthalten sein.

Natuerliche Sprache hat keinen Platz fuer Metadaten.

"Friedrich der Grosse starb in Potsdam" und
"Laut den preussischen Staatsarchiven starb Friedrich der Grosse in Potsdam"
sind in natuerlicher Sprache nur zwei Saetze unterschiedlicher Laenge.

Epistemologisch sind es jedoch voellig verschiedene Arten von Aussagen.
Eine ist eine Tatsachenbehauptung, die andere ist eine Darstellung mit expliziter Quelle.

Natuerliche Sprache kann diesen Unterschied nicht strukturell unterscheiden.
Deshalb kann KI ihn auch nicht unterscheiden.
Deshalb entsteht Halluzination.

---

## Programmiersprachen sind nicht die Antwort

"Warum dann nicht eine Programmiersprache verwenden?"

Programmiersprachen sind nicht mehrdeutig. Sie sind strukturell. Sie sind praezise.
Aber Programmiersprachen sind **Sprachen zur Beschreibung von Ablaeufen**,
nicht **Sprachen zur Beschreibung der Welt**.

Versuchen Sie "Friedrich der Grosse war bedeutend" in Python auszudruecken.

```python
is_great("Friedrich der Grosse") == True
```

Das ist keine Beschreibung --- das ist ein boolesches Urteil.
Wer hat geurteilt? Auf welcher Grundlage? In welchem Kontext? Mit welcher Sicherheit?
Programmiersprachen haben keine Struktur, um das zu enthalten.

Datenformate wie JSON, XML, RDF sind genauso.
Sie haben Struktur, aber es gibt kein einheitliches System, das die Semantik dieser Struktur definiert.
Jedes Projekt erstellt sein eigenes Schema,
und diese Schemas sind untereinander nicht kompatibel.

Natuerliche Sprache ist reich an Bedeutung, aber es fehlt an Struktur.
Programmiersprachen haben Struktur, aber es fehlt an Bedeutung.
Datenformate haben Struktur und Bedeutung, aber sie sind nicht vereinheitlicht.

Was benoetigt wird, ist eine andere Art von Sprache.

---

## Der Weg, den LLVM gezeigt hat

In der Informatik gibt es ein exaktes Vorbild.

In den 1990er Jahren gab es Dutzende von Programmiersprachen
und Dutzende von Prozessorarchitekturen.
Damit jede Sprache jede Architektur unterstuetzen konnte,
brauchte man N x M Compiler.

LLVMs Loesung war eine Zwischendarstellung (IR, Intermediate Representation).

Alle Sprachen werden in LLVM IR uebersetzt.
LLVM IR wird in alle Architekturen uebersetzt.
Es genuegen N + M Konverter.

Benutzer sehen LLVM IR nicht.
Sie schreiben C++ und erhalten eine ausfuehrbare Datei.
LLVM IR arbeitet im Verborgenen.

GEUL ist das LLVM IR fuer KI.

Alle natuerlichen Sprachen werden in GEUL uebersetzt.
GEUL wird im WMS gespeichert, zum Denken verwendet und zurueck in natuerliche Sprache uebersetzt.
Benutzer sehen GEUL nicht.
Sie stellen Fragen in natuerlicher Sprache und erhalten Antworten in natuerlicher Sprache.
GEUL arbeitet im Verborgenen.

---

## Bedingungen, die eine kuenstliche Sprache erfuellen muss

Um die Grenzen der natuerlichen Sprache zu ueberschreiten, ohne ihre Ausdruckskraft zu verlieren,
muss eine kuenstliche Sprache gleichzeitig folgende Bedingungen erfuellen.

**1. Beseitigung von Mehrdeutigkeit**

Wenn "Friedrich der Grosse war bedeutend" eingegeben wird,
muss "wer, in welchem Kontext, auf welcher Grundlage, mit welchem Sicherheitsgrad so beschrieben hat"
strukturell angegeben sein.
Wenn ein Feld leer ist, muss es als leer markiert werden.
Keine Abhaengigkeit von Implikation.

**2. Eingebettete Metadaten**

Fuer jede Beschreibung muessen Quelle, Zeitpunkt, Vertrauensgrad und Perspektive (POV)
nicht als separate Annotationen, sondern als Teil der Beschreibungsstruktur selbst enthalten sein.
Ohne das ist Whitebox-KI unmoeglich.

**3. LLM-Kompatibilitaet**

Das LLM muss diese Sprache "lernen" koennen.
Sie muss nicht fuer Menschen leicht verstaendlich sein.
Wichtig ist, dass sie tokenisierbar ist, dass Muster regelmaessig sind
und dass sie einer festen Struktur folgt.

**4. Graph-Ausdruckskraft**

Die Welt ist ein Graph, keine Tabelle.
Entitaeten sind Knoten, und Beziehungen sind Kanten.
Die kuenstliche Sprache muss Graphen natuerlich serialisieren koennen.

**5. Trennung von Fakten und Beschreibungen**

"Friedrich der Grosse starb 1786" ist kein Fakt.
"Die preussischen Staatsarchive verzeichnen, dass Friedrich der Grosse 1786 starb" sind die Primaerdaten.
Die kuenstliche Sprache muss diese Unterscheidung strukturell erzwingen.

**6. Zukunfts-Erweiterbarkeit**

Das heute definierte System muss in 10 Jahren, in 100 Jahren
und in einer unvorstellbaren Zukunft mit Abwaertskompatibilitaet erweiterbar bleiben.

---

## Warum bestehende Ansaetze unzureichend sind

Dies ist nicht der erste Versuch dieser Art.

**Esperanto** war eine kuenstliche Sprache fuer Menschen.
Strukturell, aber nicht fuer das Denken von KI entworfen.
Lernleichtigkeit wurde gegenueber semantischer Praezision bevorzugt.

**OWL/RDF** war ein semantisches Repraesentationssystem fuer Maschinen.
Logisch streng, aber aus der Zeit vor LLMs.
Die Umwandlung von und zu natuerlicher Sprache ist schwierig, und der Ausdruck ist weitschweifig.
Und fataler Weise langsam. Grossangelegtes Denken ist nicht realistisch.

**Wissensgraphen (Wikidata, Freebase)** stellten die Welt als Graph dar.
Aber sie speichern "Fakten", nicht "Beschreibungen".
Sie speichern "Friedrich der Grosse war Koenig" als Tripel,
aber nicht, wer das behauptet hat oder mit welchem Sicherheitsgrad.

**Chain-of-Thought** zeichnet den Denkprozess des LLM in natuerlicher Sprache auf.
Eine gute Richtung, aber da das Aufzeichnungsmedium natuerliche Sprache ist,
loest es das Mehrdeutigkeitsproblem nicht grundlegend.

Alle diese Versuche erfuellen jeweils ein oder zwei Bedingungen,
aber keiner erfuellt alle sechs gleichzeitig.

---

## GEUL: Der Schnittpunkt der sechs Bedingungen

GEUL steht am Schnittpunkt dieser sechs Bedingungen.

Ein Stromformat auf Basis von 16-Bit-Woertern.
In jeder Beschreibung sind Kontext, Quelle und Sicherheitsgrad strukturell eingebettet.
Graphen werden als Knoten- und Kantenpakete serialisiert.
Es folgt einem festen Muster, das 1:1 auf LLM-Tokens abbildbar ist.
Es behandelt Beschreibungen (Claims) als Primaerdaten, nicht Fakten.
50% des gesamten Adressraums sind fuer die Zukunft reserviert.

GEUL ist fuer den Benutzer nicht sichtbar.
Der Benutzer spricht in natuerlicher Sprache und erhaelt Antworten in natuerlicher Sprache.
Dazwischen strukturiert GEUL das Denken,
zeichnet es auf, akkumuliert es und macht es wiederverwendbar.

---

## Das Zeitalter der natuerlichen Sprache endet nicht

Es gibt ein Missverstaendnis zu vermeiden.

GEUL ersetzt nicht die natuerliche Sprache.
Menschen werden weiterhin in natuerlicher Sprache sprechen, schreiben und denken.
Natuerliche Sprache wird als Sprache der Menschen ewig fortbestehen.

Was GEUL ersetzt,
ist die Rolle, die natuerliche Sprache im Inneren der KI einnahm.

Das Medium des Denkens.
Das Format der Wissensspeicherung.
Das Protokoll der Kommunikation zwischen Systemen.

In dieser Rolle hat natuerliche Sprache bereits ihre Grenzen erreicht.
Diese Grenzen zeigen sich als Halluzination, als Blackbox, als Ineffizienz.

Natuerliche Sprache hat die Menschheit hierher gebracht.
Dieses Verdienst ist ewig.
Aber um den naechsten Schritt zu gehen, braucht man eine neue Sprache.

Das ist der Grund, warum eine kuenstliche Sprache benoetigt wird.

---

## Zusammenfassung

Die Mehrdeutigkeit der natuerlichen Sprache ist in der menschlichen Kommunikation ein Feature, aber im KI-Denken ein Defekt.

1. Natuerliche Sprache hat keinen strukturellen Platz fuer Metadaten.
2. Deshalb denkt KI ohne Quelle, ohne Sicherheitsgrad, ohne Kontext.
3. Deshalb entsteht Halluzination. Das ist kein Bug, sondern eine strukturelle Unvermeidlichkeit.
4. Programmiersprachen beschreiben Ablaeufe, nicht die Welt.
5. Bestehende semantische Repraesentationssysteme erfuellen jeweils nur ein oder zwei Bedingungen.
6. Eine neue kuenstliche Sprache, die alle sechs Bedingungen gleichzeitig erfuellt, wird benoetigt.

So wie LLVM IR die unsichtbare Bruecke zwischen Programmiersprachen und Hardware ist,
ist GEUL die unsichtbare Bruecke zwischen natuerlicher Sprache und KI-Denken.
