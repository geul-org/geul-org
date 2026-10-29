---
title: "Warum MD/JSON/XML nicht funktionieren"
weight: 9
date: 2026-02-26T12:00:15+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["Format", "JSON", "XML"]
summary: "Markdown, JSON und XML wurden jeweils für eine andere Zeit und einen anderen Zweck geschaffen. Sie haben Struktur, aber keine einheitliche Bedeutung und keinen Platz für Quellen. Warum es ein eigenes Format braucht, um KI-Schlussfolgerungen festzuhalten und anzusammeln."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

## Strukturierte Formate gibt es bereits. Warum wird also eine neue Sprache benoetigt?

---

## Der haeufigste Einwand

Wenn jemand zum ersten Mal die Idee einer KI-Denksprache hoert, sagt er zuerst:

"Strukturierte Formate gibt es doch schon?"

Das stimmt. Sie existieren. Viele davon.

Es gibt Markdown.
Es gibt JSON.
Es gibt XML.
YAML, TOML, Protocol Buffers, MessagePack, CSV...

Die Welt quillt ueber vor Datenformaten.
Warum denkt KI also immer noch in natuerlicher Sprache?

Um diese Frage zu beantworten, muessen wir genau bestimmen, was jedes Format gut kann
und was es nicht kann.

---

## Markdown: Das aktuelle Gedaechtnis von KI-Agenten

Im Jahr 2026 ist Markdown das am weitesten verbreitete Format bei KI-Agenten.

Claude Code erinnert sich in `.md`-Dateien.
GPT-basierte Agenten hinterlassen ebenfalls Notizen in Markdown.
CLAUDE.md, memory.md, notes.md.
Das Langzeitgedaechtnis der KI steht in diesem Moment auf Markdown.

Warum Markdown? Der Grund ist einfach.
LLMs lesen und schreiben Markdown gut.
Markdown ist reichlich in den Trainingsdaten vorhanden,
und seine Struktur ist einfach genug fuer leichte Generierung und Analyse.

Aber Markdown ist **ein Dokumentformat, das fuer Menschen zum Lesen gedacht ist.**

```markdown
# Projektstatus
## Cache-Strategie
- SIMD-Bitmaske uebernommen (entschieden am 28.01.)
- GPU-Beschleunigung wird geprueft
## Ungeloest
- Methode zur Abfragegenerierung offen
```

Wie interpretiert eine Maschine das?

Es gibt eine Abschnittsueberschrift namens "Cache-Strategie".
Darunter gibt es einen Eintrag "SIMD-Bitmaske uebernommen".
Es gibt ein Datum "(28.01.)" in Klammern.

Eine Maschine kann das nicht strukturell verstehen.
Sie kann aus `##` ableiten, dass "Cache-Strategie" eine Abschnittsueberschrift ist,
aber die semantische Beziehung, dass es sich um "ein Unterthema der Architektur" handelt, existiert in Markdown nicht.
Ein Mensch weiss, dass "28.01." ein Datum ist, aber eine Maschine muss raten.
Der 28. Januar, oder ein Achtundzwanzigstel?

Letztlich muss ein LLM, um Markdown zu "verstehen", natuerlichsprachliche Interpretation durchfuehren.
Markdown ist natuerliche Sprache mit Einrueckung darueber ---
es sind keine strukturierten Daten.

---

## JSON: Struktur ohne Bedeutung

JSON geht einen Schritt weiter als Markdown.

```json
{
  "entity": "Yi Sun-sin",
  "birth": "1545",
  "death": "1598",
  "occupation": "naval_commander"
}
```

Es gibt Struktur. Schluessel-Wert-Paare sind explizit.
Eine Maschine kann es parsen. Felder sind zugaenglich.

Aber es gibt ein Problem.

**JSON weiss nicht, was der Schluessel "entity" bedeutet.**

Die Person, die dieses JSON erstellt hat, weiss, dass "entity" "ein Objekt" bedeutet.
Im JSON einer anderen Person koennte dasselbe Konzept "name", "subject" oder "item" sein.

```json
{"name": "Yi Sun-sin"}
{"subject": "Yi Sun-sin"}
{"item": "Yi Sun-sin"}
{"entity": "Yi Sun-sin"}
```

Vier JSONs druecken dasselbe aus,
aber eine Maschine kann nicht wissen, dass sie identisch sind.

JSON fehlt **geteilte Semantik.**
Es gibt Struktur, aber es gibt keine Uebereinkunft darueber, was diese Struktur bedeutet.

Jedes Projekt erstellt sein eigenes Schema.
Jede API verwendet ihre eigenen Feldnamen.
Schema A mit Schema B zu verbinden erfordert eine weitere Transformationsschicht.

Das ist der Turm von Babel.
Struktur existiert, aber niemand versteht die Struktur der anderen.

---

## XML: Die Steuer der Weitschweifigkeit

XML versuchte, JSONs Problem zu loesen.

Namensraeume, Schemadefinitionen (XSD), Dokumenttypdefinitionen (DTD).
Es bietet Metastrukturen, die die Bedeutung von Strukturen definieren.

```xml
<entity xmlns="http://example.org/schema">
  <name>Yi Sun-sin</name>
  <birth>
    <year>1545</year>
    <calendar>lunar</calendar>
  </birth>
  <death>
    <year>1598</year>
    <cause>killed_in_action</cause>
  </death>
</entity>
```

Bedeutung kann definiert werden. Struktur kann mit Schemas erzwungen werden.
Es ist strenger als JSON.

Aber XML hat ein fatales Problem.

**Es ist weitschweifig.**

Im obigen XML ist die tatsaechliche Information "Yi Sun-sin, 1545, 1598, killed_in_action".
Alles andere sind Tags. Oeffnende und schliessende Tags ueberwiegen die Information zahlemaessig.

Warum ist das ein Problem fuer KI?

Das Kontextfenster eines LLM ist endlich.
Wenn die Uebermittlung derselben Information 3-mal so viele Tokens erfordert,
schrumpft die Informationsmenge, die in den Kontext passt, auf ein Drittel.

XML ist weitschweifig, damit Menschen es leicht lesen koennen.
Eine KI-Denksprache darf diese Verschwendung nicht haben.
Fuer ein LLM ist das `<name>`-Tag Verschwendung.

Und XML ist ein Entwurf aus den späten 1990er-Jahren.
Es entstand in einer Zeit, als es keine LLMs gab, für Menschen und herkömmliche Software.
Es wurde nie als Sprache für KI-Schlussfolgerungen entworfen.

---

## Die gemeinsame Grenze

Markdown, JSON, XML.
Jedes der drei Formate hat seine Stärken, doch sie teilen gemeinsame Grenzen.

**Sie sind textbasiert.**
Alle werden zu Zeichenketten serialisiert.
Eine Maschine muss sie parsen, um sie zu verarbeiten.
Parsen kostet.

GEUL ist eine Folge von 16-Bit-Wörtern.
Das erste Wort jedes Datensatzes nennt Art und Länge,
sodass die Grenzen der Datensätze sofort bekannt sind, ohne Zeichenketten zu interpretieren.

**Sie wurden vor der LLM-Ära entworfen.**
Markdown stammt von 2004, JSON von 2001, XML von 1998.
Sie wurden in einer Zeit entworfen, als es das Konzept LLM nicht gab,
für Menschen oder herkömmliche Software.

Eine Sprache für KI-Schlussfolgerungen muss in der LLM-Ära und für LLMs entworfen werden.
Das 16-Bit-Wort auf LLM-Vokabulare zuzuschneiden,
setzt die Existenz von LLMs voraus.

**Ein einheitliches Bedeutungssystem fehlt oder ist unvollständig.**
Markdown hat überhaupt kein Bedeutungssystem.
JSON hat Struktur, aber keine Bedeutung.
XML kann Schemata definieren, doch sie sind nicht vereinheitlicht.

GEUL bezeichnet Ziele per ID, nicht per Name:
References wie eine Wikidata-QID oder eine von einem Issuer vergebene Dokument-ID.
Wo immer sie verwendet wird, ist dieselbe ID dasselbe Ziel. Keine Umwandlung nötig.

---

## Zusammenfassung

| Format | Struktur | Bedeutung | LLM-freundlich | Binär | Platz für Quellen | Qualifikatoren |
|--------|-----------|---------|---------------|--------|---------------|----------------|
| Markdown | Schwach | Keine | Hoch | Nein | Keiner | Keine |
| JSON | Ja | Keine | Mittel | Nein | Keiner | Keine |
| XML | Ja | Teilweise | Niedrig | Nein | Keiner | Keine |
| **Ideale Sprache für Schlussfolgerungen** | **Ja** | **Ja** | **Hoch** | **Ja** | **Ja** | **Ja** |

Ein neues Format wird nicht gebraucht, weil bestehende Formate schlecht sind.
Sondern weil bestehende Formate in einer anderen Aera, fuer einen anderen Zweck gemacht wurden.

Markdown wurde fuer Dokumente gemacht, die Menschen lesen.
JSON wurde fuer den Datenaustausch in Web-APIs gemacht.
XML wurde fuer allgemeine Serialisierung von Dokumenten und Daten gemacht.

Ein Format zum Aufzeichnen und Akkumulieren von KI-Denken. Das existiert noch nicht.

Wenn der Zweck anders ist, muss das Werkzeug anders sein.
