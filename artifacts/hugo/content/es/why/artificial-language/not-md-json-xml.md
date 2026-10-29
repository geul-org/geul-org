---
title: "Por que MD/JSON/XML no funcionan"
weight: 9
date: 2026-02-26T12:00:15+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["formato", "JSON", "XML"]
summary: "Markdown, JSON y XML se crearon para épocas y propósitos distintos. Tienen estructura pero no un significado unificado, ni un lugar para las fuentes. Por qué hace falta un formato aparte para registrar y acumular el razonamiento de la IA."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

## Los formatos estructurados ya existen. Entonces, por que se necesita un nuevo lenguaje?

---

## La objecion mas comun

Cuando alguien se encuentra por primera vez con la idea de un lenguaje de razonamiento de IA, lo primero que dice es:

"Los formatos estructurados ya existen, no?"

Tienen razon. Existen. Muchos de ellos.

Existe Markdown.
Existe JSON.
Existe XML.
YAML, TOML, Protocol Buffers, MessagePack, CSV...

El mundo rebosa de formatos de datos.
Entonces, por que la IA sigue pensando en lenguaje natural?

Para responder esta pregunta, debemos senalar exactamente que hace bien cada formato
y que no puede hacer.

---

## Markdown: la memoria actual de los agentes de IA

A partir de 2026, el formato mas ampliamente usado por los agentes de IA es Markdown.

Claude Code recuerda en archivos `.md`.
Los agentes basados en GPT tambien dejan notas en Markdown.
CLAUDE.md, memory.md, notes.md.
La memoria a largo plazo de la IA se sostiene sobre Markdown en este mismo momento.

Por que Markdown? La razon es simple.
Los LLM leen y escriben bien en Markdown.
Markdown es abundante en los datos de entrenamiento,
y su estructura es lo suficientemente simple para generar y parsear facilmente.

Pero Markdown es **un formato de documento destinado a que los humanos lean.**

```markdown
# Estado del Proyecto
## Estrategia de Cache
- Mascara de bits SIMD adoptada (decidido 1/28)
- Aceleracion GPU en revision
## Sin resolver
- Metodo de generacion de consultas TBD
```

Como interpreta esto una maquina?

Hay un encabezado de seccion llamado "Estrategia de Cache."
Debajo, hay un item "Mascara de bits SIMD adoptada."
Hay una fecha "(1/28)" entre parentesis.

Una maquina no puede entender esto estructuralmente.
Puede decir por `##` que "Estrategia de Cache" es un encabezado de seccion,
pero la relacion semantica de que es "un subtema de arquitectura" no existe en Markdown.
Un humano sabe que "1/28" es una fecha, pero una maquina tiene que adivinar.
28 de enero, o un veintiocho-avo?

En ultima instancia, para "entender" Markdown, un LLM debe realizar interpretacion de lenguaje natural.
Markdown es lenguaje natural con indentacion superpuesta ---
no son datos estructurados.

---

## JSON: estructura sin significado

JSON va un paso mas alla que Markdown.

```json
{
  "entity": "Yi Sun-sin",
  "birth": "1545",
  "death": "1598",
  "occupation": "naval_commander"
}
```

Hay estructura. Los pares clave-valor son explicitos.
Una maquina puede parsearlo. Los campos son accesibles.

Pero hay un problema.

**JSON no sabe que significa la clave "entity".**

La persona que creo este JSON sabe que "entity" significa "un objeto."
En el JSON de otra persona, el mismo concepto podria ser "name", "subject" o "item."

```json
{"name": "Yi Sun-sin"}
{"subject": "Yi Sun-sin"}
{"item": "Yi Sun-sin"}
{"entity": "Yi Sun-sin"}
```

Cuatro JSON expresan lo mismo,
pero una maquina no puede saber que son lo mismo.

JSON carece de **semantica compartida.**
Hay estructura, pero no hay acuerdo sobre lo que esa estructura significa.

Cada proyecto crea su propio esquema.
Cada API usa sus propios nombres de campo.
Conectar el esquema A con el esquema B requiere otra capa de transformacion.

Esto es la Torre de Babel.
La estructura existe, pero nadie entiende la estructura del otro.

---

## XML: el impuesto de la verbosidad

XML intento resolver el problema de JSON.

Namespaces, definiciones de esquema (XSD), definiciones de tipo de documento (DTD).
Proporciona meta-estructuras que definen el significado de las estructuras.

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

El significado puede definirse. La estructura puede imponerse con esquemas.
Es mas riguroso que JSON.

Pero XML tiene un problema fatal.

**Es verboso.**

En el XML anterior, la informacion real es "Yi Sun-sin, 1545, 1598, killed_in_action."
Todo lo demas son etiquetas. Las etiquetas de apertura y cierre superan en numero a la informacion.

Por que es esto un problema para la IA?

La ventana de contexto de un LLM es finita.
Si transmitir la misma informacion requiere 3x los tokens,
la cantidad de informacion que cabe en el contexto se reduce a un tercio.

XML es verboso para que los humanos puedan leerlo facilmente.
Un lenguaje de razonamiento de IA no debe tener este desperdicio.
Para un LLM, la etiqueta `<name>` es desperdicio.

Y XML es un diseño de finales de los años noventa.
Se creó en una época en que los LLM no existían, para humanos y software tradicional.
Nunca se diseñó como lenguaje de razonamiento para IA.

---

## La limitación compartida

Markdown, JSON, XML.
Cada uno de los tres formatos tiene sus fortalezas, pero comparten limitaciones.

**Están basados en texto.**
Todos se serializan como cadenas.
Una máquina debe analizarlos para procesarlos.
El análisis es un costo.

GEUL es una secuencia de palabras de 16 bits.
La primera palabra de cada registro indica su tipo y su longitud,
así que los límites de los registros se conocen de inmediato, sin interpretar cadenas.

**Se diseñaron antes de la era de los LLM.**
Markdown es de 2004. JSON, de 2001. XML, de 1998.
Se diseñaron en una época en que el concepto de LLM no existía,
para humanos o software tradicional.

Un lenguaje de razonamiento para IA debe diseñarse en la era de los LLM, para los LLM.
Dimensionar la palabra de 16 bits al vocabulario de los LLM
presupone la existencia de los LLM.

**Su sistema semántico unificado falta o es incompleto.**
Markdown no tiene ningún sistema semántico.
JSON tiene estructura pero no significado.
XML puede definir esquemas, pero no están unificados.

GEUL apunta a los objetos por ID, no por nombre:
Reference como un QID de Wikidata o un ID de documento emitido por un Issuer.
Donde sea que se use, el mismo ID es el mismo objeto. No hace falta conversión.

---

## Resumen

| Formato | Estructura | Significado | Apto para LLM | Binario | Lugar para fuentes | Calificadores |
|--------|-----------|---------|---------------|--------|---------------|----------------|
| Markdown | Débil | Ninguno | Alto | No | Ninguno | Ninguno |
| JSON | Sí | Ninguno | Medio | No | Ninguno | Ninguno |
| XML | Sí | Parcial | Bajo | No | Ninguno | Ninguno |
| **Lenguaje de razonamiento ideal** | **Sí** | **Sí** | **Alto** | **Sí** | **Sí** | **Sí** |

Un nuevo formato se necesita no porque los formatos existentes sean malos.
Es porque los formatos existentes fueron hechos en una era diferente, para un proposito diferente.

Markdown fue hecho para documentos que los humanos leen.
JSON fue hecho para intercambio de datos en APIs web.
XML fue hecho para serializacion de proposito general de documentos y datos.

Un formato para registrar y acumular el razonamiento de la IA. Eso aun no existe.

Cuando el proposito es diferente, la herramienta debe ser diferente.
