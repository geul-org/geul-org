---
title: "GENERATED-BY"
weight: 51
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "GENERATED-BY ist ein Abstammungs-Meta, das die Instanz (Mensch, Modell, Regelmaschine) und deren Version festhält, die das Dokument erzeugt hat."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Hält die Instanz fest, die das Dokument erzeugt hat. Das kann ein Mensch, ein Modell oder eine Regelmaschine sein.

## Layout

```
TAG WORD          0001 1LLL L011 0010      Codec 0x32
[Length-Erweiterungs-TAG]
Erzeugende Instanz   Reference (Mensch, Modell, Regelmaschine)
Version              UTF8-TEXT-Value, oder Auslassungsmarker 0x0000 (optionales Feld)
```

- Codec: Meta `0x32`, Abstammungsklasse (`011`)
- Payload: eingebettete Reference + Versionstext (optional)
- Anzahl: mehrere möglich

## Interpretation und Gültigkeit

- Bei einem Modell wird zugleich die Modellversion angegeben.
- Ist die Version unbekannt oder nicht vorgesehen, wird ihre Stelle ausgelassen und ABSENT (`0x0000`) geschrieben (optionales Feld von [CODEC](/de/grammar/edge/codec/)). Die geul.org-Spezifikation `0x1832` ist ein Zwei-Record-Feld aus agent (ohne CODEC) und version (`0840`, `0841`, `0000`).
- Für die Quellversion (Commit) eines Programms ist das Format von [TRANSFORMED-BY](/de/grammar/meta/lineage/transformed-by/) (Digest, Pflicht) genauer. In der Version von GENERATED-BY steht als Text, was keine Commit-ID ist, etwa Modellname und -version.
- In bei geul.org veröffentlichte Dokumente setzt man keine Reference auf natürliche Personen ([Issuer und Veröffentlichung](/de/grammar/issuer/#veröffentlichung-bei-geulorg)). Man verweist auf Organisationen oder Issuer. Ausnahmsweise ist es erlaubt, natürliche Personen über [WIKIDATA-QID](/de/grammar/reference/wikidata-qid/) anzusprechen.
