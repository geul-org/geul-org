---
title: "Warum WordNet?"
weight: 14
date: 2026-03-01T14:00:00+09:00
lastmod: 2026-03-01T14:00:00+09:00
tags: ["WordNet", "Verben", "semantische Primitive", "Synset"]
summary: "Ein Verbsystem von Grund auf zu erstellen bedeutet Lücken, willkürliche Entscheidungen und fehlende Begründung. WordNet ist eine 40 Jahre alte lexikalische Datenbank mit 13.767 Verb-Synsets, erstellt von Linguisten. Wir leihen das Wörterbuch und bauen die Grammatik darauf auf."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Wir brauchten Verben.

Damit eine KI die Welt beschreiben kann, braucht sie Verben. Im Satz „Yi Sun-sin baute das Schildkrötenschiff" — der koreanische Admiral des 16. Jahrhunderts und sein berühmtes gepanzertes Kriegsschiff — gibt es ohne „baute" keinen Satz.

Für die Identifikation von Entitäten gibt es Wikidata. Yi Sun-sin ist Q28090. Das Schildkrötenschiff ist Q249845. Die Identifikation ist abgeschlossen.

Für Verben gibt es nichts Vergleichbares. „bauen" hat keine ID. Ob „bauen", „herstellen" und „produzieren" dasselbe oder Verschiedenes bedeuten — dafür gibt es keinen anerkannten Maßstab.

Jedes Projekt, das sich mit Verben befasst — ob Wissensgraph, semantische Suche oder strukturierter Sprachentwurf — stößt unweigerlich auf diese Frage. Woher das Verbsystem nehmen.

---

## Selbst erstellen

Man kann eine Verbliste von Grund auf entwerfen.

move, give, think, feel, say. Etwa 50 Grundverben festlegen und dann untergeordnete Verben anhängen. Unter move: walk, run, crawl. Unter give: donate, bestow, grant.

Drei Probleme entstehen.

Erstens: Lücken. Wenn man Verben aus dem Kopf aufzählt, fehlt immer etwas. Man vergisst „adsorbieren", vergisst „grübeln", vergisst „resignieren". In dem Moment, in dem das fehlende Verb gebraucht wird, bricht das System.

Zweitens: kein Maßstab. Sind walk und stroll verschiedene Verben oder Varianten desselben Verbs? Beim Selbsterstellen hängt diese Entscheidung von der Intuition des Entwerfers ab. Intuition ist von Person zu Person verschieden.

Drittens: willkürliche Hierarchie. Man hat walk unter move eingeordnet, aber walk könnte auch ein Untertyp von travel sein. Der Entwerfer entscheidet. Für diese Entscheidung gibt es keine Begründung.

Ein selbst erstelltes Verbsystem ist im Kopf des Entwerfers perfekt. Jeder andere fragt: „Warum diese Klassifikation?"

---

## Das Erbe WordNet

Eine lexikalische Datenbank des Englischen, entwickelt an der Princeton University seit 1985.

40 Jahre lang haben Linguisten englische Wörter in Bedeutungseinheiten (synset) gruppiert und durch hierarchische Beziehungen verbunden. Allein für Verben gibt es 13.767 Synsets. Jedes Synset hat eine eindeutige ID, eine Definition und explizite Beziehungen zu anderen Synsets.

„donate" und „bestow" sind im selben Synset. Das bedeutet: gleiche Bedeutung.
„donate" ist ein troponym von „give". Das bedeutet: eine spezifische Form von give.
„give" ist ein troponym von „transfer". Das bedeutet: eine spezifische Form von transfer.

Diese Hierarchie ist für 13.767 Verben bereits aufgebaut.

Keine Lücken. Weil Linguisten sie 40 Jahre lang aufgefüllt haben.
Ein Maßstab existiert. Weil die Definitionen und Beziehungen der Synsets explizit sind.
Die Hierarchie ist begründet. Weil die Troponymie-Beziehungen auf linguistischer Analyse basieren.

---

## Wörterbuch und Grammatik sind verschieden

Wenn WordNet das Wörterbuch der Verben ist, dann ist die Frage, wie man diese Verben verwendet, ein eigenes Problem.

WordNet zeigt, welche Bedeutung „give" hat und wie es sich zu „donate" verhält. Aber wie „give" in einem Satz verwendet wird — wer gibt, was gegeben wird, wem gegeben wird — diese Struktur liefert WordNet nicht.

Das ist dieselbe Beziehung wie bei Wikidata. Wikidata zeigt, dass Yi Sun-sin Q28090 ist. Aber wie man einen Satz über Yi Sun-sin formuliert, ist nicht die Aufgabe von Wikidata.

Das Wörterbuch leihen, aber die Grammatik selbst bauen.

Was wir von WordNet übernehmen: Synset-IDs, semantische Definitionen, den hierarchischen Troponym-Baum. Die verb frames, Partizipantenstrukturen und syntaktischen Muster, die WordNet ebenfalls liefert, entwirft jedes Projekt besser selbst. Die syntaktischen Informationen von WordNet sind an das Englische gebunden, und das semantische System der Verben und ihre Verwendung sind verschiedene Probleme.

---

## Von 13.767 auf 10

Alle 13.767 Verben von WordNet aufzulisten, ist für sich genommen sinnlos. Struktur wird benötigt.

Wenn man den Troponym-Baum von WordNet nach oben verfolgt, erreicht man Knoten ohne Elternknoten. Wurzelverben. Davon gibt es 559.

Gruppiert man diese 559 semantisch, ergeben sich 68 Sub-Primitive (sub-primitive).
Gruppiert man diese 68 weiter, ergeben sich 10 Primitive (primitive).

```
13.767 Verben → 559 Wurzeln → 68 Sub-Primitive → 10 Primitive

BE          — Existenz, Besitz, Lokation
PERCEIVE    — Wahrnehmung, Erkennung, Entdeckung
FEEL        — Emotion, Präferenz, Verlangen
THINK       — Denken, Urteil, Erinnerung
CHANGE      — Veränderung, Beginn, Ende
CAUSE       — Handlung, Erzeugung, Zerstörung
MOVE        — Bewegung, Ankunft, Abgang
COMMUNICATE — Rede, Anzeige, Vereinbarung
TRANSFER    — Übertragung, Empfang, Austausch
SOCIAL      — Kooperation, Wettbewerb, Zugehörigkeit
```

Diese 10 sind die semantischen Primitive der menschlichen Verben. Sie stammen nicht aus der Intuition einer einzelnen Person, sondern aus der Struktur von 40 Jahren WordNet-Akkumulation, 13.767 Datenpunkten.

Diese 4-Ebenen-Hierarchie — Primitiv, Sub-Primitiv, Wurzel, einzelnes Verb — erlaubt die Auflösung zu steuern. Grob betrachtet: 10 Handlungstypen. Fein betrachtet: 13.767 Handlungstypen. Man liest bei der benötigten Auflösung ab.

---

## Erweiterung und Kompression

13.767 reichen nicht? Neue Verben können hinzugefügt werden. Mehrsprachige Verben, Neologismen, Fachbegriffe. Man ordnet sie dem passenden Sub-Primitiv zu. Das bestehende System bricht nicht.

13.767 sind zu viel? Synonyme Synsets können zusammengeführt werden. donate → give umleiten. Daten, die zuvor unter donate gespeichert waren, verweisen auf give. Dasselbe Prinzip wie HTTP 301.

Entscheidend ist die Reihenfolge. Zuerst alles aufnehmen, dann laufen lassen, die Nutzungsdaten betrachten und danach kürzen. Ohne Daten am Schreibtisch zu kürzen, bedeutet, notwendige Unterscheidungen zu verlieren.

---

## Darüber hinaus: semantische Atome

Die 13.767 Verben von WordNet sind die Liste der von Menschen benannten Verben. Umfassend, aber nicht vollständig.

„give" lässt sich weiter zerlegen. CAUSE + HAVE + MOVE. Eine Zerlegung in semantische Atome (semantic primitive). Ist diese Zerlegung abgeschlossen, lassen sich auch Verben, die nicht in der Liste stehen, als Kombination von Atomen ausdrücken.

Wenn WordNet die Standardbibliothek ist, dann ist das System der semantischen Atome der Compiler. So wie ein Compiler Funktionen erzeugen kann, die nicht in der Standardbibliothek enthalten sind.

Das ist ein großes Forschungsvorhaben, anzugehen, nachdem das WordNet-basierte System funktioniert. Vorerst genügt die Standardbibliothek.

---

## Zusammenfassung

Jedes Projekt, das ein Verbsystem aufbauen will, trifft auf dieselbe Frage. Woher es nehmen.

Selbst erstellen: Lücken, Willkür, keine Begründung.
Auf WordNet aufbauen: keine Lücken, Konsens, datenbasiert.

WordNet ist das Verb-Wörterbuch der Menschheit, 40 Jahre lang von Linguisten aufgebaut.
Die Wörter dieses Wörterbuchs leihen, aber die Grammatik selbst bauen.
Das ist der Grund, warum wir Wikidata für Entitäten verwenden und WordNet für Verben.
