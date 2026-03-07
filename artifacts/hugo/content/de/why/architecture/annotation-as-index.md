---
title: "Warum Annotationen Indizes sein sollten"
weight: 20
date: 2026-03-01T15:00:00+09:00
lastmod: 2026-03-01T15:00:00+09:00
tags: ["Index", "Annotation", "Code", "AST", "Entwurfsmuster"]
summary: "Annotationen werden für Menschen geschrieben. Aber wenn es 10.000 Funktionen gibt, müssen auch Maschinen sie lesen können. Wenn man Annotationen von Erzählung in Index verwandelt, wird ein Full-Scan zur sofortigen Suche."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Annotationen werden für Menschen geschrieben.

```go
// GetUser retrieves a user by ID from the database.
func GetUser(id string) (*User, error) {
```

Diese Annotation ist nützlich, wenn ein Mensch sie liest. Aber wenn eine Maschine sie liest, versteht sie nichts. Sie weiß nicht, ob "retrieves" Read oder Search bedeutet. Sie weiß nicht, welche Entität "user" ist. Sie weiß nicht, ob diese Funktion das Service-Pattern oder das Repository-Pattern verwendet.

Weil die Annotation eine Erzählung ist.

---

## Wenn es 10.000 Funktionen gibt

Bei 10 Funktionen ist es egal. Ein Mensch kann alles lesen.

Bei 10.000 Funktionen ist es anders. Wenn man sagt „Zeig mir alle zahlungsbezogenen Funktionen", kann weder der Mensch noch die Maschine sie finden. Man findet nur die, die "payment" im Namen haben. Wenn es nicht im Namen steht, wird es übersehen.

Wenn ein KI-Agent Code modifiziert, ist es genauso. Wenn man Claude Code sagt „Korrigiere die PaymentFailed-Fehlerbehandlung", liest der Agent den gesamten Code erneut. Jedes Mal. Er analysiert 10.000 Funktionen jedes Mal von Anfang an. Code, der gestern gelesen wurde, wird heute wieder gelesen. Auch mit Annotationen ist es dasselbe. Weil Annotationen menschliche Erzählungen sind. Damit eine Maschine Bedeutung aus einer Erzählung extrahiert, braucht sie Inferenz. Das ist teuer.

---

## Wenn die Annotation ein Index ist

```go
// CreateOrder processes a new order creation.
//
// # Pattern: Service, Transactional
// # Entity: Order
// # Action: Create
// # Input: CreateOrderRequest {items:[]Item, userID:string}
//          pre: items>0 userID!=''
// # Output: *OrderResponse, error
//          errs: [StockInsufficient, PaymentFailed]
// # Deps: InventorySvc, PaymentGateway
func (s *OrderService) CreateOrder(req CreateOrderRequest) (*OrderResponse, error) {
```

Diese Annotation ist sowohl für Menschen als auch für Maschinen lesbar.

„Alle Funktionen mit dem Service-Pattern" → Pattern-Feld durchsuchen. Sofort.
„Alle Funktionen zur Order-Entität" → Entity-Feld durchsuchen. Sofort.
„Funktionen, die PaymentFailed auslösen" → errs-Feld durchsuchen. Sofort.

Der Full-Scan wird zur Index-Suche. O(n) wird zu O(1).

---

## Menschen müssen nichts schreiben

Dieser Index muss nicht von Menschen erstellt werden.

Wenn Code geändert wird, erfolgt die Erkennung automatisch. File-Watching.
Die geänderte Funktion wird per AST isoliert. Mechanisch.
Der Funktionskörper wird an ein kleines LLM übergeben. „Bestimme Pattern, Entität und Aktion dieser Funktion."
Das Ergebnis wird in einem vordefinierten Format eingefügt. Mechanisch.

Der Mensch tut nichts. Er schreibt nur Code. Der Index wird automatisch angefügt.

Im gesamten Pipeline gibt es nur einen Punkt, an dem das LLM eingreift — die Bedeutung der Funktion zu beurteilen. Der Rest ist vollständig deterministischer Code.

---

## Von Inferenz zu Regeln

Hier geht es noch einen Schritt weiter.

Wenn ein kleines LLM demselben Pattern wiederholt denselben Index zuweist — wird diese Wiederholung erkannt. Wenn „Service-Suffix mit Receiver-Method ergibt Pattern:Service" 100 Mal wiederholt wurde, wird es als Regel verfestigt. Danach wird das LLM nicht mehr aufgerufen. Die Regel übernimmt.

LLM-Aufrufe nehmen schrittweise ab. Regeln nehmen schrittweise zu. Die Kosten konvergieren gegen null.

Annotationen wandeln sich von Erzählung zu Index,
Index wandelt sich von manuell zu automatisch,
automatisch wandelt sich von Inferenz zu Regel.

---

## Warum es möglich ist: Design Patterns als Codebook

Es gibt einen Grund, warum das funktioniert.

In der Programmierung gibt es bereits ein standardisiertes semantisches Vokabular. Die Design Patterns.

Singleton, Factory, Observer, MVC, Service. Seit die GoF 1994 23 Patterns formalisiert haben, hat die Softwarebranche dieses Vokabular 30 Jahre lang erweitert und standardisiert.

GoF 23 Patterns. Enterprise Application Patterns. Cloud Design Patterns. Go Concurrency Patterns. Alles ist bereits katalogisiert.

Dieses Vokabular ist nicht mehrdeutig. Singleton ist Singleton. Entwickler interpretieren es nicht unterschiedlich. Die Definition ist konsensual, die Implementierungsbedingungen sind klar, und Verstöße werden im Code-Review erkannt.

Dieses Vokabularsystem wird zum Codebook des Index. Ein neues muss nicht geschaffen werden. Es existiert bereits.

Die natürliche Sprache hat das nicht. „Großartig" hat eine Wörterbuchdefinition, aber jeder Mensch verwendet es anders. Im Code wird Service nicht von verschiedenen Entwicklern unterschiedlich verwendet.

---

## Warum Code die einfachste Domäne ist

Die Kontext-Pipeline von GEUL — [Klärung](/de/why/clarification/), [Indexierung](/de/why/semantically-aligned-index/), [Verifikation](/de/why/mechanical-verification/), [Filterung](/de/why/filter/), [Konsistenz](/de/why/consistency-check/), [Exploration](/de/why/exploration/) — auf natürliche Sprache anzuwenden, ist schwierig. Auf Code anzuwenden, ist einfach.

Klärung: Natürliche Sprache ist mehrdeutig. Code — wenn der Compiler ihn durchlässt — hat eine feststehende Bedeutung.
Indexierung: Entitäten natürlicher Sprache erfordern Kontext. Entitäten im Code sind bereits vom AST geparst.
Verifikation: Die Gültigkeit natürlicher Sprache lässt sich nicht definieren. Die Gültigkeit von Code beurteilt der Compiler.
Filterung: Die Relevanz natürlicher Sprache muss ein LLM beurteilen. Die Relevanz von Code lässt sich mechanisch über den Call-Graph bestimmen.
Konsistenz: Widersprüche in natürlicher Sprache werden erst durch Inferenz entdeckt. Widersprüche im Code werden vom Typsystem und von Tests gefunden.
Exploration: Wissen in natürlicher Sprache ist flach. Code hat bereits eine hierarchische Struktur: Package → Datei → Typ → Methode.

Dieselbe Pipeline funktioniert in der Code-Domäne zu weitaus geringeren Kosten. Dort zuerst beweisen, wo es am einfachsten ist, dann auf das Schwierigere ausweiten. Das ist Ingenieurwesen.

---

## Zusammenfassung

Annotationen waren ursprünglich für Menschen gedacht.
Jetzt müssen sie auch für Maschinen gedacht sein.
Annotationen, die Menschen lesen und Maschinen durchsuchen können.
Annotationen, die zugleich Erzählung und Index sind.

Code hat bereits Bedeutung, bereits Struktur, bereits Vokabular.
Was fehlt, ist nur der Index.
Die Annotation muss dieser Index werden.
