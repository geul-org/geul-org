---
title: "Por qué Wikidata"
weight: 13
date: 2026-02-26T12:00:17+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["Wikidata", "Ontología", "wikigeul", "SIDX"]
summary: "GEUL no rechaza Wikidata. Carga el volcado sin pérdidas y convierte cada una de sus cerca de 120 millones de entidades en un documento GEUL con todos los idiomas. Diseñar un identificador semánticamente alineado (SIDX) a partir de su clasificación y sus estadísticas de frecuencia es investigación en curso."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

## GEUL no rechaza Wikidata. Se alza sobre ella.

---

## No se puede crear un idioma sin un diccionario

Todo idioma necesita un vocabulario.

El coreano tiene el diccionario coreano.
El inglés tiene el diccionario inglés.
Los lenguajes de programación tienen bibliotecas estándar.

Lo mismo ocurre con un idioma artificial.
Una lista de entidades, una lista de relaciones, una lista de propiedades.
¿Qué código representa a "Samsung Electronics" en este idioma?
¿Qué código representa la relación "capital"?
Se necesita un vocabulario antes de poder escribir una oración.

¿Cómo se construye este vocabulario?
Hay dos caminos.

Construirlo desde cero.
O utilizar lo que ya existe.

---

## Construir desde cero: la lección de CYC

El proyecto CYC comenzó en 1984.

Su objetivo era formalizar y almacenar conocimiento de sentido común general.
La ontología se diseñó desde cero.
Se definieron conceptos, se definieron relaciones, se definieron reglas.
Los expertos los ingresaron manualmente.

Pasaron treinta años.
Se ingresaron millones de reglas.

Sin embargo, estaba lejos de cubrir el conocimiento del mundo.
Cada dominio requería diseñar una ontología separada.
Mantener la coherencia entre dominios resultaba difícil.
Cada vez que surgía un concepto nuevo, la ontología debía revisarse.
Las revisiones entraban en conflicto con las reglas existentes con frecuencia.

Lo que CYC demostró no fue su potencial, sino sus límites.
Que un pequeño equipo de expertos diseñe la ontología del mundo
se vuelve insostenible a escala.

---

## Lo que ya existe: Wikidata

Wikidata comenzó en 2012.

Una base de conocimiento estructurada gestionada por la Fundación Wikimedia.
Cualquiera puede editarla.
Según el volcado del 19 de octubre de 2026: unos 121,97 millones de entidades.
De ellas, 13.991 son propiedades.
Unos 1780 millones de declaraciones.
Etiquetas en más de 600 códigos de idioma.

Lo que CYC no logró en 30 años con equipos de expertos,
Wikidata lo logró en 14 años con una comunidad.

Veamos lo que tiene Wikidata.

**Identificadores de entidades.** Q-ID. Samsung Electronics es Q20718. Seúl es Q8684. Yi Sun-sin es Q217300. Identificadores únicos en todo el mundo. Independientes del idioma.

**Identificadores de propiedades.** P-ID. "Sede" es P159. "Fecha de fundación" es P571. "Población" es P1082. Las relaciones y propiedades se identifican de forma única.

**Jerarquía.** P31 (instance of) y P279 (subclass of) forman una jerarquía de tipos. "Seúl → ciudad → asentamiento humano → entidad geográfica." El sistema de clasificación del mundo se expresa con estas dos propiedades.

**Etiquetas multilingües.** Q20718 tiene la etiqueta española "Samsung Electronics", la coreana "삼성전자" y la japonesa "サムスン電子". Un identificador, un nombre distinto en cada idioma.

**Verificación comunitaria.** Editores de todo el mundo. Detección de vandalismo. Exigencia de fuentes. No es perfecta, pero escala mejor que un pequeño grupo de expertos.

No hay razón para construir esto desde cero.

---

## GEUL traslada Wikidata tal como es

GEUL no inventa identificadores nuevos para Wikidata.
Los usa tal como son.

La gramática de GEUL tiene References dedicadas a Wikidata.
[WIKIDATA-QID](/es/grammar/reference/wikidata-qid/) escribe el número de un Q-ID, y [WIKIDATA-PID](/es/grammar/reference/wikidata-pid/) el de un P-ID, como entero sin signo.
Q42 es el entero 42. P31 es el entero 31.
Como son enteros y no cadenas, compararlos no requiere normalización.

El camino es este.

**Paso 1: Carga sin pérdidas.**
[wikipg](/es/repos/#wikipg) carga el volcado JSON de Wikidata en PostgreSQL.
Guarda entidades, etiquetas, descripciones, alias, declaraciones, calificadores, referencias y enlaces a sitios en el orden del volcado,
y conserva cada línea del volcado tal cual.
También registra el propio archivo del volcado (URL, tamaño, sumas de verificación, commit del cargador).
Solo si no se descarta nada se puede comprobar después qué se trasladó y qué se omitió.

**Paso 2: Un documento por entidad.**
[wikigeul](/es/repos/#wikigeul) lee el volcado cargado y produce un documento GEUL por cada elemento y cada propiedad.
Contiene etiquetas, descripciones, alias, declaraciones con sus calificadores y referencias, y enlaces a sitios.
Todos los idiomas van en el mismo documento. No se divide por idioma.

Todos los documentos comparten un único Issuer, `0x00010000` (wikidata.geul.org).
Un ID de documento tiene 64 bits. El byte superior es la letra del tipo de entidad y los 56 bits inferiores son su número.
El documento de Q42 es `0x510000000000002a`. `0x51` es `Q` y `0x2a` es 42.
El documento de P31 es `0x500000000000001f`.
Basta el hexadecimal para saber de qué entidad es el documento.
Un documento real puede leerse de principio a fin en [Ejemplo: un elemento de Wikidata](/es/grammar/example/).

**Paso 3: Citar con enteros.**
Dentro de las declaraciones, elementos y propiedades se escriben como enteros.
"Q42 es un ser humano (Q5)" es un TRIPLE de tres enteros: P31, Q42 y Q5.
Ese entero es el número del ID de documento.
Desde cualquier declaración se llega directamente al documento de aquello que nombra.

Las referencias también se trasladan.
Una referencia de Wikidata se convierte en un SOURCE de GEUL.
La cabecera de cada documento registra de qué volcado procede y qué herramienta (commit) lo convirtió.

**Paso 4: Publicar como archivos pack.**
No se pueden publicar 120 millones de entidades como 120 millones de archivos.
Los documentos se agrupan en un archivo pack por Issuer, y los registros se comprimen con zstd.
Quien lee obtiene solo los documentos que necesita, no el archivo entero.

Ahora mismo la conversión se está verificando en el rango Q1–Q10000.
Se comprueban de forma exhaustiva el viaje de ida y vuelta por la conversión inversa, el archivo y la completitud.
La conversión completa y la publicación vienen después.

---

## SIDX viene después

Un Q-ID es un número asignado por orden de registro.
Números cercanos no significan significados cercanos.
Q42 es Douglas Adams; Q41 es Grecia y Q43 es Turquía.

GEUL también investiga otro tipo de identificador.
[SIDX](/es/grammar/reference/geul-sidx/) (Semantic-aligned Index), un identificador semánticamente alineado que da valores cercanos a cosas de significado cercano.
El objetivo es poner el significado en los propios bits,
de modo que los bits superiores basten para saber si algo es una persona, un lugar o una organización.

SIDX sigue siendo investigación anterior a v1.
La gramática solo le reserva un lugar: la Reference GEUL-SIDX.
Su anchura no está decidida. Se estudian 64 bits, 256 bits y otras, y se elegirá según las estadísticas.
Todavía no se ha asignado ningún SIDX.
Por eso los documentos actuales de Wikidata se escriben con Q-ID, sin SIDX.
Cuando se asignen valores SIDX, el identificador existente y el SIDX de una misma cosa se enlazarán con [SAME-NODE](/es/grammar/edge/same-node/).

Aquí vuelve a entrar Wikidata.
La investigación de SIDX parte del sistema de clasificación y de las estadísticas de frecuencia de Wikidata.
La dirección que se estudia es esta.

**Extracción de tipos.**
Reunir los Q-ID usados como objeto de P31 (instance of).
Esa es la lista de "tipos".
"Ser humano (Q5)", "ciudad (Q515)", "país (Q6256)", "empresa (Q4830453)"...
Contar las instancias de cada tipo.

**Construcción de la jerarquía.**
Construir un árbol con las relaciones P279 (subclass of) entre tipos.
"Ciudad → asentamiento humano → entidad geográfica → entidad."
Cómo tratar la herencia múltiple, cuando un tipo pertenece a varios tipos superiores, es un problema abierto.

**Asignación de bits.**
La estructura del árbol se convierte en la relación de prefijos de los patrones de bits.
Los subtipos de un mismo tipo superior comparten prefijo.
"Ciudad" y "pueblo" comparten el prefijo de "asentamiento humano".
Los tipos con muchas instancias reciben un prefijo más corto, es decir, un espacio de números más amplio.
Es la misma idea que la codificación de Huffman.

Esto es todavía una hipótesis.
Quedan problemas por resolver.
Un SIDX ya asignado no debe moverse cuando cambian las estadísticas.
Nunca debe asignarse el mismo valor a dos cosas.
También hay que decidir el formato en que se publicarán el libro de códigos y el registro.

---

## Lo que Wikidata proporciona

En este camino, Wikidata proporciona tres cosas.

**Identificadores.**
La respuesta a "¿a qué del mundo señalamos?".
Los Q-ID y P-ID se convierten tal cual en References enteras de GEUL.
El conocimiento de Wikidata puede trasladarse a documentos GEUL,
y los identificadores de Wikidata pueden leerse directamente en los documentos GEUL.

**Sistema de clasificación.**
La respuesta a "¿qué tipos de cosas existen en el mundo?".
CYC lo hizo diseñar a un equipo de expertos.
GEUL lo toma de Wikidata.
El objetivo de la investigación es convertir el sistema de clasificación que los editores han consensuado durante 14 años
en el árbol de bits de SIDX.

**Estadísticas de frecuencia.**
La respuesta a "¿cuántas cosas de cada tipo hay en el mundo?".
Si hay 9 millones de entidades humanas y 1 millón de asteroides,
el tipo "ser humano" debería recibir un código más eficiente que "asteroide".
La frecuencia de uso real se convierte en la base del diseño de códigos.

---

## Lo que Wikidata no proporciona

Wikidata es un diccionario. Un diccionario no es un lenguaje.

Un diccionario proporciona una lista de palabras.
Un lenguaje proporciona la gramática para construir oraciones con palabras.

Lo que Wikidata no proporciona es lo que GEUL añade.

**De hecho a afirmación.**
La unidad básica de Wikidata es el hecho (Fact).
"La población de Seúl es de 9,74 millones."
Es verdadero o falso.

La unidad básica de GEUL es la afirmación (Claim).
"Según A, la población de Seúl es de aproximadamente 9,74 millones. (confianza 0,9, a fecha de 2023)"
Quién lo afirma, con qué certeza y a partir de cuándo forman parte de la declaración.
Esta diferencia se analiza en detalle en [Por qué afirmaciones, no hechos](/es/why/claims-not-facts/).

**Calificadores verbales.**
Wikidata no tiene lugar para expresar los matices de los verbos.
En "Yi Sun-sin ganó la batalla de Myeongnyang",
¿dónde están el tiempo, el aspecto, la evidencialidad, el modo y la confianza?
En Wikidata se expresan parcialmente mediante calificadores,
pero no hay un sistema sistemático de calificación verbal.

GEUL está diseñando un sistema de calificación verbal que añade a cada declaración, de forma estructural,
dimensiones como tiempo, aspecto, polaridad, evidencialidad, modo, volitividad y certeza.
Esto también es trabajo anterior a v1.

**Palabras de 16 bits.**
Las representaciones de Wikidata no se diseñaron para ventanas de contexto.
JSON-LD, RDF, SPARQL.
Legibles por máquina, pero no eficientes en tokens.

GEUL es una secuencia de palabras de 16 bits.
La primera palabra de un registro (la TAG WORD) indica el tipo y la longitud de ese registro.
Los registros pueden filtrarse y saltarse incluso sin libro de códigos.
Es una representación construida sobre la premisa de que la ventana de contexto es finita.
Esto ya se discutió en [Por qué no MD/JSON/XML](/es/why/not-md-json-xml/).

**Pipeline de contexto.**
Wikidata es un almacén. GEUL es parte de un pipeline.
Clarificación, verificación, filtrado, comprobación de coherencia, exploración: todo lo discutido en esta serie
opera sobre la representación estructurada de GEUL.
Wikidata no tiene ese pipeline.
Ni lo necesita. Wikidata tiene otro propósito.

---

## La relación entre diccionario y lenguaje

En resumen:

Wikidata es el vocabulario del mundo.
Qué entidades existen,
qué relaciones existen,
qué tipos hay y cómo se clasifican.
Una comunidad lo construyó durante 14 años.

GEUL pone gramática sobre este vocabulario.
Los identificadores del vocabulario → References enteras de GEUL.
Las entradas del vocabulario → un documento GEUL por entidad.
El sistema de clasificación y las estadísticas de frecuencia del vocabulario → material para la investigación de SIDX.

Y añade lo que le falta al vocabulario.
Estructura de afirmaciones. Calificación verbal. Palabras de 16 bits. Un pipeline de contexto.

¿Se podría construir GEUL sin Wikidata?
Sí. Se podría diseñar una ontología desde cero, como hizo CYC.
Pero eso se intentó hace 40 años, y los resultados están a la vista.

Como existe Wikidata, GEUL no diseña una ontología.
Traslada un consenso que ya existe.

---

## Resumen

Un lenguaje artificial necesita un vocabulario.
Construirlo desde cero lo intentó CYC, y 30 años demostraron sus límites.

Wikidata es el vocabulario del mundo, con unos 120 millones de entidades y unos 1780 millones de declaraciones (volcado de octubre de 2026).
Una comunidad lo construyó durante 14 años.

GEUL traslada este vocabulario tal como es.
wikipg carga el volcado en PostgreSQL sin pérdidas,
y wikigeul convierte cada entidad en un documento GEUL que contiene todos los idiomas.
Elementos y propiedades se citan como enteros, y los documentos se publican como archivos pack.

SIDX es la investigación que viene después.
Diseña un identificador semánticamente alineado a partir de las frecuencias de instancias de P31 y de la jerarquía de P279.
Ni su anchura ni sus asignaciones están decididas aún.

Wikidata es un diccionario; GEUL es un lenguaje.
Un diccionario proporciona palabras; un lenguaje proporciona gramática.
GEUL construye estructura de afirmaciones, calificación verbal, palabras de 16 bits y un pipeline de contexto sobre el vocabulario de Wikidata.

GEUL no rechaza Wikidata.
Se apoya sobre él.
