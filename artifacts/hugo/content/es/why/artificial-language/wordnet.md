---
title: "¿Por qué WordNet?"
weight: 14
date: 2026-03-01T14:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["WordNet", "verbos", "primitivos semánticos", "synset"]
summary: "Si construyes tú mismo un sistema de verbos, tendrá huecos, será arbitrario y carecerá de fundamento. GEUL aprendió la estructura construyendo un libro de códigos provisional con los 13.767 verbos de WordNet, acumulados durante 40 años. Como WordNet no es CC0 y está atado al inglés, esta edición provisional será reemplazada por un libro de códigos de verbos sin WordNet."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Necesitábamos verbos.

Para que una IA describa el mundo, necesita verbos. En "Yi Sun-sin construyó el barco tortuga", sin "construyó" no hay oración.

Para la identificación de entidades existe Wikidata. Yi Sun-sin es Q50184. El barco tortuga es Q695959. La identificación ya está resuelta.

Para los verbos no existe un equivalente. No hay un ID para "construir". Si "construir", "fabricar" y "producir" significan lo mismo o cosas distintas, no hay un estándar consensuado.

Todo proyecto que trabaje con verbos —ya sea grafos de conocimiento, búsqueda semántica o diseño de lenguaje estructurado— se encuentra inevitablemente con esta pregunta. ¿De dónde sacas tu sistema de verbos?

---

## Construirlo desde cero

Se puede diseñar una lista de verbos partiendo de nada.

move, give, think, feel, say. Eliges unos 50 verbos básicos y les vas colgando sub-verbos. Bajo move: walk, run, crawl. Bajo give: donate, bestow, grant.

Surgen tres problemas.

Primero, lagunas. Cuando una persona enumera verbos de memoria, siempre se le escapa alguno. Se olvida de "adsorber", de "rumiar", de "resignarse". En el momento en que se necesita un verbo ausente, el sistema se rompe.

Segundo, falta de criterios. ¿Son walk y stroll verbos distintos o variantes del mismo? Si lo construyes tú, ese juicio depende de la intuición del diseñador. La intuición varía de persona a persona.

Tercero, jerarquía arbitraria. Pones walk bajo move, pero walk también es un subtipo de travel. Dónde ubicarlo lo decide el diseñador. Esa decisión carece de fundamento.

Un sistema de verbos hecho a mano parece perfecto en la cabeza de su diseñador. Para cualquier otra persona se convierte en "¿Por qué se clasificó así?"

---

## El legado de WordNet

Una base de datos léxica del inglés que comenzó a construirse en la Universidad de Princeton en 1985.

Durante 40 años, lingüistas han agrupado palabras inglesas en unidades de significado (synsets) y las han conectado mediante relaciones jerárquicas. Solo para verbos hay 13.767 synsets. Cada synset tiene un ID único, una definición y relaciones explícitas con otros synsets.

"donate" y "bestow" están agrupados en el mismo synset. Significan lo mismo.
"donate" es un troponym de "give". Es una forma específica de give.
"give" es un troponym de "transfer". Es una forma específica de transfer.

Esta jerarquía ya existe para 13.767 verbos.

Sin lagunas. Los lingüistas la han ido completando durante 40 años.
Con criterios claros. Las definiciones y relaciones de los synsets son explícitas.
Con jerarquía fundamentada. Las relaciones de troponym se basan en análisis lingüístico.

---

## El diccionario y la gramática son cosas distintas

Si WordNet es el diccionario de verbos, cómo usar esos verbos es un asunto aparte.

WordNet te dice qué significa "give" y qué relación tiene con "donate". Pero no te dice cómo usar "give" en una oración —quién da, qué se da, a quién se da— esa estructura no es su cometido.

Es la misma relación que con Wikidata. Wikidata te dice que Yi Sun-sin es Q50184. Pero cómo componer una oración sobre Yi Sun-sin no es responsabilidad de Wikidata.

Se toma prestado el diccionario; la gramática se construye uno mismo.

Qué tomar de WordNet: IDs de synset, definiciones semánticas, árboles jerárquicos de troponym. Los verb frames, las estructuras de participantes y los patrones sintácticos que WordNet también ofrece es mejor que cada proyecto los diseñe por su cuenta. La información sintáctica de WordNet está ligada al inglés, y el sistema semántico de un verbo y su modo de empleo son problemas distintos.

---

## De 13.767 a 10

Enumerar los 13.767 verbos de WordNet no tiene sentido. Se necesita estructura.

Subiendo por el árbol de troponym de WordNet, se llega a nodos superiores sin más niveles arriba. Verbos raíz. Son 559.

Agrupando los 559 semánticamente se obtienen 68 sub-primitivos.
Agrupando los 68 más se obtienen 10 primitivos.

```
13.767 verbos → 559 raíces → 68 sub-primitivos → 10 primitivos

BE          — existencia, posesión, ubicación
PERCEIVE    — percepción, detección, descubrimiento
FEEL        — emoción, preferencia, deseo
THINK       — cognición, juicio, memoria
CHANGE      — cambio, inicio, fin
CAUSE       — acción, creación, destrucción
MOVE        — movimiento, llegada, partida
COMMUNICATE — enunciación, indicación, acuerdo
TRANSFER    — entrega, recepción, intercambio
SOCIAL      — cooperación, competencia, afiliación
```

Estos 10 son los primitivos semánticos de los verbos humanos. No provienen de la intuición de una sola persona, sino de la estructura de 40 años de acumulación de WordNet a lo largo de 13.767 puntos de datos.

Esta jerarquía de cuatro niveles —primitivos, sub-primitivos, raíces, verbos individuales— permite controlar la resolución. A grandes rasgos, hay 10 tipos de acción; en detalle, 13.767. Se corta en la resolución que se necesite.

---

## Expansión y compresión

¿13.767 no son suficientes? Se pueden añadir verbos nuevos. Verbos multilingües, neologismos, terminología especializada. Se añaden bajo el sub-primitivo correspondiente. El sistema existente no se rompe.

¿13.767 son demasiados? Se pueden fusionar synsets sinónimos en uno solo. Redirigir donate → give. Los datos previamente registrados bajo donate encuentran su camino hacia give. El mismo principio que HTTP 301.

Lo importante es el orden. Primero se incluye todo, se ejecuta de verdad, se observan los datos de uso y luego se recorta. Recortar en el escritorio sin datos significa eliminar distinciones que realmente se necesitan.

---

## Más allá: átomos semánticos

Los 13.767 verbos de WordNet son la lista de verbos que los humanos han nombrado. Es exhaustiva, pero no lo es todo.

"give" puede descomponerse aún más: CAUSE + HAVE + MOVE. Es descomponer en primitivas semánticas (semantic primitives). Una vez completada esa descomposición, incluso los verbos que no están en la lista pueden expresarse como combinaciones de átomos.

Si WordNet es la biblioteca estándar, el sistema de átomos semánticos es el compilador. Igual que un compilador puede producir funciones que no están en la biblioteca estándar.

Es una gran tarea de investigación, que conviene intentar después de haber puesto a trabajar de verdad un libro de códigos de verbos.

---

## Por qué es provisional

GEUL construyó un libro de códigos de verbos sobre esta estructura: [wordnet-verb](/es/repos/#wordnet-verb), que da a cada uno de los 13.767 synsets verbales de WordNet 3.0 un código de 16 bits, con códigos cercanos para significados cercanos. Pero es una edición provisional, de referencia. Hay tres razones.

**Licencia.** WordNet está bajo la WordNet 3.0 License. Los resultados públicos de GEUL son CC0. Las listas y definiciones derivadas de WordNet no pueden trasladarse a un libro de códigos CC0.

**Inglés.** Un synset es una unidad de sentido de palabras inglesas. GEUL necesita un sistema de verbos que no esté atado a ningún idioma en particular.

**Lugar.** Aún no se ha decidido cómo se llevarán los códigos de verbos en los registros GEUL.

Por eso esta edición provisional será reemplazada por un libro de códigos de verbos puro que no use WordNet. Lo aprendido de WordNet permanece: la cobertura debe ser completa, los criterios explícitos y la jerarquía fundamentada.

---

## Resumen

Todo proyecto que intenta construir un sistema de verbos se enfrenta a la misma pregunta: ¿de dónde sacarlo?

Si lo construyes tú mismo, hay huecos, arbitrariedad y falta de fundamento.
Si partes de WordNet, no hay huecos, hay consenso y fundamento en los datos.

Por eso GEUL partió de WordNet. Pero es solo un punto de partida.
Los resultados públicos deben ser CC0, y un sistema de verbos no debe estar atado al inglés.
Aprender la estructura de WordNet y reconstruirla con fuentes CC0 y datos reales de uso.
El principio sigue siendo el mismo: tomar prestado el diccionario y construir la gramática uno mismo.
