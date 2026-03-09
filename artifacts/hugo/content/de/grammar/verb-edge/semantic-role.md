---
title: "Teilnehmerrollen"
weight: 10
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "participant", "semantic-role"]
summary: "16 Participant zur Definition semantischer Rollen innerhalb eines Ereignisses. Die 4-Bit-Kodierung deckt Kernrollen wie Agent, Theme und Recipient sowie ergaenzende Rollen wie Cause und Purpose ab."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Der **Participant** ist ein Edge, der die **semantische Rolle** einer an einem Ereignis beteiligten Entitaet innerhalb einer Praedikation spezifiziert.

```
Event Node (Verb)
    ├─ PARTICIPANT Edge (role=Agent) ──→ Entity Node
    ├─ PARTICIPANT Edge (role=Theme) ──→ Entity Node
    └─ PARTICIPANT Edge (role=Instrument) ──→ Entity Node
```

## Designprinzipien

### Trennungsprinzip

| Kategorie | Zugehoerigkeit | Beispiel |
|-----------|---------------|----------|
| **Participant** | Event-Ebene | Agent, Theme, Recipient |
| **Pragmatische Information** | Context/Claim-Ebene | Speaker, Listener, Evidentiality |

Speaker (Sprecher), Listener (Hoerer), Source (Informationsquelle) sind keine Participant, sondern werden in den **[semantischen Qualifikatoren](../qualifier/)** oder auf Context/Claim-Ebene behandelt.

### Kodierung

- **4 Bit** (0x0~0xF), maximal 16 semantische Rollen
- Mustererkennung durch SIMD-Bitoperationen moeglich

## Liste der semantischen Rollen (16)

### Kernteilnehmer (Core Participants)

| ID | Code | Rolle | Definition | Beispiel |
|----|------|-------|------------|----------|
| 0x0 | **AGT** | Agent (Handelnder) | Subjekt, das absichtlich eine Handlung ausfuehrt | "**Hans** trat den Ball" |
| 0x1 | **EXP** | Experiencer (Erfahrender) | Subjekt, das Emotion/Kognition/Wahrnehmung erlebt | "**Anna** war traurig" |
| 0x2 | **THM** | Theme (Thema) | Objekt, das bewegt wird oder dessen Zustand beschrieben wird | "Hans trat **den Ball**" |
| 0x3 | **PAT** | Patient (Betroffener) | Objekt, dessen Zustand sich durch eine Handlung aendert | "**Das Fenster** zerbrach" |
| 0x4 | **RCP** | Recipient (Empfaenger) | Empfaenger von etwas | "Er gab **Maria** ein Buch" |
| 0x5 | **BNF** | Beneficiary (Beguenstigter) | Nutzniesser einer Handlung | "Er machte es **fuer das Kind**" |

### Werkzeuge und Mittel (Instruments & Means)

| ID | Code | Rolle | Definition | Beispiel |
|----|------|-------|------------|----------|
| 0x6 | **INS** | Instrument (Werkzeug) | Werkzeug zur Ausfuehrung der Handlung | "Er schlug den Nagel **mit einem Hammer** ein" |
| 0x7 | **MNR** | Manner (Art und Weise) | Weise, wie die Handlung ausgefuehrt wird | "Er rannte **schnell**" |

### Raeumlich (Spatial)

| ID | Code | Rolle | Definition | Beispiel |
|----|------|-------|------------|----------|
| 0x8 | **LOC** | Location (Ort) | Ort, an dem das Ereignis stattfindet | "Er lebte **in Berlin**" |
| 0x9 | **SRC** | Source (Ausgangspunkt) | Startpunkt der Bewegung | "Er ging **von zu Hause** los" |
| 0xA | **DST** | Destination (Ziel) | Ankunftspunkt der Bewegung | "Er ging **zur Schule**" |
| 0xB | **PTH** | Path (Weg) | Durchgangsort der Bewegung | "Er ging **durch den Park**" |

### Kausal (Causal)

| ID | Code | Rolle | Definition | Beispiel |
|----|------|-------|------------|----------|
| 0xC | **CAU** | Cause (Ursache) | Ursache des Ereignisses | "Es wurde **wegen des Regens** abgesagt" |
| 0xD | **PRP** | Purpose (Zweck) | Zweck der Handlung | "Er ging hin, **um Sport zu treiben**" |

### Sonstige (Others)

| ID | Code | Rolle | Definition | Beispiel |
|----|------|-------|------------|----------|
| 0xE | **COM** | Comitative (Begleiter) | Begleitende Person/Sache | "Er ging **mit einem Freund**" |
| 0xF | **ATR** | Attribute (Attribut) | Zustands-/Eigenschaftsbeschreibung | "Der Himmel ist **blau**" |

## Struktur des Participant Edge

```
PARTICIPANT Edge {
    source:     Event SIDX       // Verbknoten
    target:     Entity SIDX      // Entitaetsknoten
    role:       4-bit            // Semantische Rolle (0x0~0xF)
    gram_role:  2-bit (optional) // Grammatische Rolle (Subjekt/Objekt/Komplement)
    focus:      4-bit (optional) // Betonungsgrad (0~15 → 0.0~1.0)
    quant_ref:  TID (optional)   // Qualifikator-Referenz
}
```

| Feld | Bits | Beschreibung |
|------|------|--------------|
| role | 4 | Semantische Rolle (Pflicht) |
| gram_role | 2 | 0=nicht angegeben, 1=Subjekt, 2=Objekt, 3=Komplement |
| focus | 4 | Informationswichtigkeit (0=Hintergrund, 15=maximale Betonung) |
| quant_ref | 16 | Qualifikator-TID "alle", "die meisten" usw. |

## Theme vs Patient

| Rolle | Zustandsaenderung | Beispiel |
|-------|-------------------|----------|
| Theme | Nein (Bewegung/Beschreibung) | "Er hat den Ball **geworfen**" (Ball bleibt intakt) |
| Patient | Ja (betroffen) | "Er hat das Glas **zerbrochen**" (Glas aendert Zustand) |

In der Praxis kann man unter Theme vereinheitlichen und bei Bedarf durch die Verbsemantik unterscheiden.

## Beispiele

### Einfacher Satz: "Hans gab Maria ein Buch"

```
Event: give.v.01
├─ PARTICIPANT (AGT) → Hans
├─ PARTICIPANT (THM) → Buch
└─ PARTICIPANT (RCP) → Maria
```

### Komplexer Satz: "Wegen des Regens rannte er schnell mit einem Freund von zu Hause zur Schule"

```
Event: run.v.01
├─ PARTICIPANT (AGT) → [Sprecher]
├─ PARTICIPANT (CAU) → Regen
├─ PARTICIPANT (COM) → Freund
├─ PARTICIPANT (SRC) → Zuhause
├─ PARTICIPANT (DST) → Schule
└─ PARTICIPANT (MNR) → schnell
```

### Zustandsbeschreibung: "Der Himmel ist sehr blau"

```
Event: be.v.01
├─ PARTICIPANT (THM) → Himmel
└─ PARTICIPANT (ATR) → blau (focus=15)
```

## Aktiv/Passiv-Normalisierung

| Oberflaechenform | Agent | Theme |
|------------------|-------|-------|
| "Apple hat Tesla uebernommen" | Apple | Tesla |
| "Tesla wurde von Apple uebernommen" | Apple | Tesla |

Bei der Analyse wird auf ein einheitliches Muster normalisiert.
