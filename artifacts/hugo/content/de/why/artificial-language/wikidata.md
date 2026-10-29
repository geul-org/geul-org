---
title: "Warum Wikidata"
weight: 13
date: 2026-02-26T12:00:17+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["Wikidata", "Ontologie", "wikigeul", "SIDX"]
summary: "GEUL lehnt Wikidata nicht ab. Es lädt den Dump verlustfrei und macht aus jeder der rund 120 Millionen Entitäten ein GEUL-Dokument mit allen Sprachen. Einen semantisch ausgerichteten Identifikator (SIDX) aus Klassifikation und Häufigkeitsstatistik zu entwerfen, ist laufende Forschung."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

## GEUL lehnt Wikidata nicht ab. Es steht darauf.

---

## Ohne Wörterbuch lässt sich keine Sprache erschaffen

Jede Sprache braucht einen Wortschatz.

Koreanisch hat das koreanische Wörterbuch.
Englisch hat das englische Wörterbuch.
Programmiersprachen haben Standardbibliotheken.

Dasselbe gilt für eine künstliche Sprache.
Eine Liste von Entitäten, eine Liste von Relationen, eine Liste von Eigenschaften.
Welcher Code steht für „Samsung Electronics" in dieser Sprache?
Welcher Code steht für die Relation „Hauptstadt"?
Man braucht einen Wortschatz, bevor man einen Satz schreiben kann.

Wie baut man diesen Wortschatz auf?
Es gibt zwei Wege.

Ihn von Grund auf neu erstellen.
Oder das verwenden, was bereits existiert.

---

## Von Grund auf neu: die Lehre aus CYC

Das CYC-Projekt begann 1984.

Sein Ziel war es, allgemeines Alltagswissen zu formalisieren und zu speichern.
Die Ontologie wurde von Grund auf entworfen.
Konzepte wurden definiert, Relationen wurden definiert, Regeln wurden definiert.
Experten gaben sie händisch ein.

Dreißig Jahre vergingen.
Millionen von Regeln wurden eingegeben.

Doch es reichte bei Weitem nicht aus, um das Wissen der Welt abzudecken.
Für jede Domäne musste eine eigene Ontologie entworfen werden.
Die Konsistenz zwischen den Domänen aufrechtzuerhalten erwies sich als schwierig.
Bei jedem neuen Konzept musste die Ontologie überarbeitet werden.
Überarbeitungen standen häufig im Widerspruch zu bestehenden Regeln.

Was CYC bewies, war nicht sein Potenzial, sondern seine Grenzen.
Die Weltontologie von einem kleinen Expertenteam entwerfen zu lassen,
wird im großen Maßstab unwartbar.

---

## Was bereits existiert: Wikidata

Wikidata wurde 2012 gestartet.

Eine strukturierte Wissensbasis, betrieben von der Wikimedia Foundation.
Jeder kann sie bearbeiten.
Stand des Dumps vom 19. Oktober 2026: rund 121,97 Millionen Entitäten.
Davon 13.991 Eigenschaften.
Rund 1,78 Milliarden Aussagen.
Bezeichnungen in über 600 Sprachcodes.

Den Umfang, den CYC in 30 Jahren mit einem Expertenteam nicht erreichen konnte,
erreichte Wikidata in 14 Jahren mit einer Community.

Betrachten wir, was Wikidata bietet.

**Entitätsidentifikatoren.** Q-IDs. Samsung Electronics ist Q20718. Seoul ist Q8684. Yi Sun-sin ist Q217300. Weltweit eindeutige Identifikatoren. Sprachunabhängig.

**Eigenschaftsidentifikatoren.** P-IDs. „Hauptsitz" ist P159. „Gründungsdatum" ist P571. „Bevölkerung" ist P1082. Relationen und Eigenschaften werden eindeutig identifiziert.

**Hierarchische Struktur.** P31 (instance of) und P279 (subclass of) bilden eine Typhierarchie. „Seoul → Stadt → menschliche Siedlung → geographische Entität." Das Klassifikationssystem der Welt wird durch diese beiden Eigenschaften ausgedrückt.

**Mehrsprachige Bezeichnungen.** Die koreanische Bezeichnung für Q20718 ist „삼성전자", die englische „Samsung Electronics", die japanische „サムスン電子". Ein Identifikator, verschiedene Namen für jede Sprache.

**Community-Validierung.** Bearbeiter auf der ganzen Welt. Vandalismuserkennung. Quellenanforderungen. Nicht perfekt, aber skalierbarer als ein kleines Expertenteam.

Es gibt keinen Grund, dies von Grund auf neu zu bauen.

---

## GEUL übernimmt Wikidata, wie es ist

GEUL erfindet keine neuen Identifikatoren für Wikidata.
Es verwendet sie, wie sie sind.

Die Grammatik von GEUL hat eigene References für Wikidata.
[WIKIDATA-QID](/de/grammar/reference/wikidata-qid/) schreibt die Zahl einer Q-ID, [WIKIDATA-PID](/de/grammar/reference/wikidata-pid/) die Zahl einer P-ID als vorzeichenlose Ganzzahl.
Q42 ist die Ganzzahl 42. P31 ist die Ganzzahl 31.
Weil es Ganzzahlen und keine Zeichenketten sind, braucht ein Gleichheitsvergleich keine Normalisierung.

Der Weg sieht so aus.

**Schritt 1: Verlustfreies Laden.**
[wikipg](/de/repos/#wikipg) lädt den JSON-Dump von Wikidata in PostgreSQL.
Es speichert Entitäten, Bezeichnungen, Beschreibungen, Aliasse, Aussagen, Qualifier, Referenzen und Sitelinks in Dump-Reihenfolge
und bewahrt jede Zeile des Dumps wörtlich auf.
Auch die Dump-Datei selbst (URL, Größe, Prüfsummen, Commit des Laders) wird festgehalten.
Nur wenn nichts weggeworfen wird, lässt sich später prüfen, was übernommen und was übersprungen wurde.

**Schritt 2: Ein Dokument pro Entität.**
[wikigeul](/de/repos/#wikigeul) liest den geladenen Dump und erzeugt für jedes Item und jede Eigenschaft ein GEUL-Dokument.
Es enthält Bezeichnungen, Beschreibungen, Aliasse, Aussagen mit ihren Qualifiern und Referenzen sowie Sitelinks.
Alle Sprachen stehen im selben Dokument. Nach Sprachen wird nicht getrennt.

Alle Dokumente haben einen einzigen Issuer, `0x00010000` (wikidata.geul.org).
Eine Dokument-ID hat 64 Bit. Das oberste Byte ist der Buchstabe der Entitätsart, die unteren 56 Bit sind ihre Nummer.
Das Dokument von Q42 ist `0x510000000000002a`. `0x51` ist `Q`, `0x2a` ist 42.
Das Dokument von P31 ist `0x500000000000001f`.
Schon am Hex-Wert sieht man, zu welcher Entität das Dokument gehört.
Ein echtes Dokument lässt sich in [Beispiel: Wikidata-Eintrag](/de/grammar/example/) von Anfang bis Ende lesen.

**Schritt 3: Zitieren mit Ganzzahlen.**
In Aussagen werden Items und Eigenschaften als Ganzzahlen geschrieben.
„Q42 ist ein Mensch (Q5)" ist ein TRIPLE aus drei Ganzzahlen: P31, Q42 und Q5.
Diese Ganzzahl ist die Nummer in der Dokument-ID.
Von jeder Aussage aus gelangt man direkt zum Dokument dessen, was sie nennt.

Auch die Referenzen werden übernommen.
Eine Wikidata-Referenz wird zu einer GEUL-SOURCE.
Der Kopf jedes Dokuments hält fest, aus welchem Dump es stammt und welches Werkzeug (Commit) es umgewandelt hat.

**Schritt 4: Veröffentlichung als pack-Archive.**
120 Millionen Entitäten lassen sich nicht als 120 Millionen Dateien veröffentlichen.
Die Dokumente werden je Issuer in einem pack-Archiv gebündelt, die Datensätze mit zstd komprimiert.
Wer liest, holt nur die Dokumente, die er braucht, nicht das ganze Archiv.

Derzeit wird die Umwandlung am Bereich Q1–Q10000 geprüft.
Hin- und Rückweg über die Rückumwandlung, das Archiv und die Vollständigkeit werden lückenlos geprüft.
Vollständige Umwandlung und Veröffentlichung folgen danach.

---

## SIDX kommt danach

Eine Q-ID ist eine Nummer, die in der Reihenfolge der Registrierung vergeben wird.
Nahe Nummern bedeuten keine nahe Bedeutung.
Q42 ist Douglas Adams; Q41 ist Griechenland, Q43 die Türkei.

GEUL erforscht auch eine andere Art von Identifikator.
[SIDX](/de/grammar/reference/geul-sidx/) (Semantic-aligned Index), ein semantisch ausgerichteter Identifikator, der Dingen mit naher Bedeutung nahe Werte gibt.
Das Ziel ist, die Bedeutung in die Bits selbst zu legen,
sodass schon die oberen Bits verraten, ob etwas eine Person, ein Ort oder eine Organisation ist.

SIDX ist noch Forschung vor v1.
Die Grammatik reserviert nur einen Platz dafür: die Reference GEUL-SIDX.
Die Breite steht nicht fest. 64 Bit, 256 Bit und andere werden geprüft; die Wahl richtet sich nach der Statistik.
Es ist noch keine SIDX vergeben.
Deshalb werden die heutigen Wikidata-Dokumente mit Q-IDs geschrieben, ohne SIDX.
Sobald SIDX-Werte vergeben sind, werden der bestehende Identifikator und die SIDX desselben Dings mit [SAME-NODE](/de/grammar/edge/same-node/) verbunden.

Hier kommt Wikidata erneut ins Spiel.
Die SIDX-Forschung geht vom Klassifikationssystem und den Häufigkeitsstatistiken von Wikidata aus.
Die untersuchte Richtung ist folgende.

**Typextraktion.**
Die Q-IDs sammeln, die als Objekte von P31 (instance of) verwendet werden.
Das ist die Liste der „Typen".
„Mensch (Q5)", „Stadt (Q515)", „Staat (Q6256)", „Unternehmen (Q4830453)"...
Die Instanzen jedes Typs zählen.

**Hierarchieaufbau.**
Aus den P279-Relationen (subclass of) zwischen Typen einen Baum bauen.
„Stadt → menschliche Siedlung → geographische Entität → Entität."
Wie mit Mehrfachvererbung umzugehen ist, wenn ein Typ zu mehreren Obertypen gehört, ist eine offene Frage.

**Bitzuweisung.**
Die Baumstruktur wird zur Präfixbeziehung der Bitmuster.
Untertypen desselben Obertyps teilen sich dasselbe Präfix.
„Stadt" und „Dorf" teilen sich das Präfix von „menschliche Siedlung".
Typen mit vielen Instanzen erhalten ein kürzeres Präfix, also einen größeren Nummernraum.
Das ist dieselbe Idee wie bei der Huffman-Kodierung.

Das ist noch eine Hypothese.
Es bleiben Probleme zu lösen.
Eine einmal vergebene SIDX darf sich nicht verschieben, wenn sich die Statistik ändert.
Derselbe Wert darf nie zwei Dingen zugewiesen werden.
Auch das Format, in dem Codebuch und Registry veröffentlicht werden, muss noch festgelegt werden.

---

## Was Wikidata liefert

Auf diesem Weg liefert Wikidata drei Dinge.

**Identifikatoren.**
Die Antwort auf „worauf in der Welt zeigen wir?".
Q-IDs und P-IDs werden, wie sie sind, zu ganzzahligen References von GEUL.
Das Wissen von Wikidata lässt sich in GEUL-Dokumente übernehmen,
und Wikidata-Identifikatoren lassen sich direkt aus GEUL-Dokumenten lesen.

**Klassifikationssystem.**
Die Antwort auf „welche Arten von Dingen gibt es in der Welt?".
CYC ließ dies von einem Expertenteam entwerfen.
GEUL nimmt es aus Wikidata.
Ziel der Forschung ist, das Klassifikationssystem, auf das sich die Bearbeiter in 14 Jahren geeinigt haben,
in den Bitbaum von SIDX zu überführen.

**Häufigkeitsstatistiken.**
Die Antwort auf „wie viele Dinge jeder Art gibt es in der Welt?".
Wenn es 9 Millionen menschliche Entitäten und 1 Million Asteroiden gibt,
sollte der Typ „Mensch" einen effizienteren Code erhalten als „Asteroid".
Die tatsächliche Nutzungshäufigkeit wird zur Grundlage des Codeentwurfs.

---

## Was Wikidata nicht liefert

Wikidata ist ein Wörterbuch. Ein Wörterbuch ist keine Sprache.

Ein Wörterbuch liefert eine Liste von Wörtern.
Eine Sprache liefert die Grammatik, um aus Wörtern Sätze zu bilden.

Was Wikidata nicht liefert, ist das, was GEUL hinzufügt.

**Von Fakten zu Behauptungen.**
Die Grundeinheit von Wikidata ist eine Tatsache (Fact).
„Die Bevölkerung von Seoul beträgt 9,74 Millionen."
Sie ist entweder wahr oder falsch.

Die Grundeinheit von GEUL ist eine Behauptung (Claim).
„Laut A beträgt die Bevölkerung von Seoul etwa 9,74 Millionen. (Konfidenz 0,9, Stand 2023)"
Wer behauptet, mit welcher Sicherheit, und zu welchem Zeitpunkt — all das ist in der Aussage eingebettet.
Dieser Unterschied wird ausführlich in [Warum Behauptungen, nicht Fakten](/de/why/claims-not-facts/) behandelt.

**Verbqualifikatoren.**
Wikidata hat keinen Platz, um die Nuancen von Verben auszudrücken.
In „Yi Sun-sin gewann die Schlacht von Myeongnyang" —
wo befinden sich Tempus, Aspekt, Evidentialität, Modus und Konfidenz?
In Wikidata werden diese teilweise durch Qualifier ausgedrückt,
aber ein systematisches Verbqualifikationssystem gibt es nicht.

GEUL entwirft ein Verbqualifikationssystem, das jeder Aussage strukturell
Dimensionen wie Tempus, Aspekt, Polarität, Evidentialität, Modus, Volitivität und Konfidenz beifügt.
Auch das ist Arbeit vor v1.

**16-Bit-Wörter.**
Wikidatas Darstellung wurde nicht für Kontextfenster entworfen.
JSON-LD, RDF, SPARQL.
Maschinenlesbar, aber nicht tokeneffizient.

GEUL ist eine Folge von 16-Bit-Wörtern.
Das erste Wort eines Datensatzes (das TAG WORD) gibt Art und Länge dieses Datensatzes an.
Datensätze lassen sich auch ohne Codebuch filtern und überspringen.
Ein Darstellungssystem, das auf der Prämisse endlicher Kontextfenster aufgebaut ist.
Dies wurde bereits in [Warum nicht MD/JSON/XML](/de/why/not-md-json-xml/) behandelt.

**Kontextpipeline.**
Wikidata ist ein Speicher. GEUL ist Teil einer Pipeline.
Klärung, Validierung, Filterung, Konsistenzprüfung, Exploration — alles, was in dieser Serie diskutiert wurde, arbeitet auf GEULs strukturierter Darstellung.
Wikidata hat diese Pipeline nicht.
Und braucht sie auch nicht. Wikidatas Zweck ist ein anderer.

---

## Das Verhältnis zwischen Wörterbuch und Sprache

Zusammengefasst:

Wikidata ist der Wortschatz der Welt.
Welche Entitäten existieren,
welche Relationen existieren,
welche Typen es gibt und wie sie klassifiziert werden.
Eine Community hat dies in 14 Jahren aufgebaut.

GEUL setzt Grammatik auf diesen Wortschatz.
Die Identifikatoren des Wortschatzes → die ganzzahligen References von GEUL.
Die Einträge des Wortschatzes → ein GEUL-Dokument pro Entität.
Klassifikationssystem und Häufigkeitsstatistiken des Wortschatzes → Material für die SIDX-Forschung.

Und es ergänzt, was dem Wortschatz fehlt.
Behauptungsstruktur. Verbqualifikation. 16-Bit-Wörter. Kontextpipeline.

Könnte man GEUL ohne Wikidata bauen?
Ja. Indem man die Ontologie von Grund auf entwirft, wie CYC.
Aber das wurde vor 40 Jahren versucht, und die Ergebnisse liegen vor.

Weil es Wikidata gibt, entwirft GEUL keine Ontologie.
Es übernimmt einen bestehenden Konsens.

---

## Zusammenfassung

Eine künstliche Sprache braucht einen Wortschatz.
Ihn von Grund auf neu zu bauen, hat CYC versucht, und 30 Jahre haben die Grenzen dieses Ansatzes bewiesen.

Wikidata ist der Wortschatz der Welt, mit rund 120 Millionen Entitäten und rund 1,78 Milliarden Aussagen (Dump vom Oktober 2026).
Eine Community hat ihn in 14 Jahren aufgebaut.

GEUL übernimmt diesen Wortschatz, wie er ist.
wikipg lädt den Dump verlustfrei in PostgreSQL,
und wikigeul macht aus jeder Entität ein GEUL-Dokument, das alle Sprachen enthält.
Items und Eigenschaften werden als Ganzzahlen zitiert, die Dokumente als pack-Archive veröffentlicht.

SIDX ist die Forschung, die danach kommt.
Sie entwirft einen semantisch ausgerichteten Identifikator aus den Instanzhäufigkeiten von P31 und der Hierarchie von P279.
Weder Breite noch Zuweisungen stehen bisher fest.

Wikidata ist ein Wörterbuch; GEUL ist eine Sprache.
Ein Wörterbuch liefert Wörter; eine Sprache liefert Grammatik.
GEUL baut Behauptungsstruktur, Verbqualifikation, 16-Bit-Wörter und eine Kontextpipeline auf dem Wortschatz von Wikidata auf.

GEUL lehnt Wikidata nicht ab.
Es steht darauf.
