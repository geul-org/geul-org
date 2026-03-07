---
title: "¿Por qué se necesita un lenguaje artificial?"
weight: 7
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["lenguaje artificial", "lenguaje natural", "alucinación", "LLVM IR"]
summary: "El lenguaje natural evolucionó para la comunicación humana. La ambigüedad, la redundancia y la implicación son ventajas para los humanos, pero causas de alucinación para la IA. Ni los lenguajes de programación ni los marcos semánticos existentes son la respuesta. Se necesita un nuevo lenguaje artificial que satisfaga seis condiciones simultáneamente."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

## El lenguaje natural trajo a la humanidad hasta aquí. Pero no puede llevarnos más lejos.

---

## El mayor invento: el lenguaje natural

La tecnología más grande jamás creada por la humanidad es el lenguaje natural.

No fue el descubrimiento del fuego, ni la invención de la rueda, ni siquiera el semiconductor.
Lo que hizo posible todo eso fue el lenguaje natural.

Gracias al lenguaje natural, el conocimiento pudo transmitirse.
Gracias al lenguaje natural, la cooperación fue posible.
Gracias al lenguaje natural, los pensamientos de los muertos pudieron ser heredados por los vivos.

La razón por la que Homo sapiens llegó a dominar la Tierra no fue la fuerza muscular, sino el lenguaje.
Durante decenas de miles de años, el lenguaje natural fue el medio de toda actividad intelectual humana.

Y ahora, el lenguaje natural se ha convertido en el cuello de botella de la era de la IA.

---

## Por qué nació el lenguaje natural

Para comprender el problema, debemos volver al propósito original del lenguaje natural.

El lenguaje natural evolucionó para la **comunicación en tiempo real entre seres humanos**.

Cuando los primeros humanos cazaban en la sabana,
lo que se necesitaba para transmitir "¡Hay un león allí!"
no era una estructura lógica precisa, sino una transmisión rápida.

Esta presión evolutiva determinó todas las características del lenguaje natural.

**La ambigüedad es una función.**
No es necesario saber exactamente a cuántos metros está "allí".
El oyente gira la cabeza y ve al león.
El contexto compensa la ambigüedad.

**La redundancia es una función.**
Incluso si la mitad del mensaje se pierde con el viento, el significado debe llegar.
Por eso el lenguaje natural expresa la misma idea de múltiples formas.

**La implicación es una función.**
En muchas culturas hispanohablantes, preguntar "¿Qué tal?" no requiere una respuesta detallada:
es una forma de mostrar interés por el otro.
El contexto cultural compartido decodifica la implicación.

Todas estas características son ventajas en la comunicación entre personas.
Rápida, flexible y adaptable al contexto.

El problema surge cuando intentamos usar esto para la IA.

---

## Qué significa el lenguaje natural para la IA

Los LLM actuales reciben entrada en lenguaje natural, razonan en lenguaje natural y producen salida en lenguaje natural.

Es como realizar un experimento químico
registrando cada medición como "bastante", "un poco" o "más o menos esto".

"Yi Sun-sin, el almirante coreano del siglo XVI, fue grande."

¿Qué ocurre cuando una IA procesa esta oración?

¿Quién dijo que fue grande? ¿El hablante? ¿La comunidad académica? ¿La sociedad coreana?
¿Con qué criterio fue grande? ¿Militar? ¿Moral? ¿Por su impacto histórico?
¿En referencia a cuándo? ¿Su propia época? ¿El presente?
¿Con cuánta certeza? ¿Es un hecho? ¿Una opinión? ¿Una especulación?

Nada de esto está especificado en la oración en lenguaje natural.
Todo está simplemente implicado: "dedúcelo del contexto."

Los humanos tienen decenas de miles de años de hardware evolutivo para decodificar estas implicaciones.
Expresiones faciales, tono de voz, experiencias compartidas, trasfondo cultural.
La IA no tiene nada de esto. Solo tiene texto.

Así que la IA adivina. Y expresa sus suposiciones como si fueran certezas.
A esto lo llamamos "Alucinación (Hallucination)."

La alucinación no es un error de software. Mientras el lenguaje natural se use como lenguaje de razonamiento de la IA,
es un resultado estructuralmente inevitable.

---

## La alucinación nace de la ambigüedad del lenguaje natural

Precisemos aún más este punto.

Cuando un LLM responde "Yi Sun-sin murió en la Batalla de Noryang",
¿cuál es la base de esta oración?

Que patrones similares a esta oración aparecieron con alta probabilidad en los datos de entrenamiento.

Pero de qué fuente provinieron esos patrones,
cuán fiable es esa fuente,
a qué fecha se refiere esta información,
si existen relatos contradictorios --
nada de esto puede expresarse estructuralmente en la salida del lenguaje natural.

El lenguaje natural no tiene espacio reservado para metadatos.

"Yi Sun-sin murió en la Batalla de Noryang" y
"Los Anales de la Dinastía Joseon registran que Yi Sun-sin murió en la Batalla de Noryang"
son, en lenguaje natural, simplemente dos oraciones de diferente longitud.

Pero epistemológicamente son tipos de afirmaciones completamente diferentes.
Una es una afirmación fáctica; la otra es una narración con fuente.

El lenguaje natural no puede distinguir estructuralmente entre ambas.
Por lo tanto, la IA tampoco puede distinguirlas.
Por lo tanto, ocurre la alucinación.

---

## Los lenguajes de programación no son la respuesta

"Entonces, ¿por qué no usar un lenguaje de programación?"

Los lenguajes de programación no son ambiguos. Son estructurados. Son precisos.
Pero los lenguajes de programación son **lenguajes para describir procedimientos**,
no **lenguajes para describir el mundo**.

Intenta expresar "Yi Sun-sin fue grande" en Python:

```python
is_great("Yi Sun-sin") == True
```

Esto no es una descripción, sino un veredicto booleano.
Quién emitió el juicio, con qué fundamento, en qué contexto, con qué grado de certeza --
los lenguajes de programación no tienen estructura para nada de esto.

Los formatos de datos como JSON, XML y RDF son iguales.
Tienen estructura, pero no un sistema unificado para definir el significado de esa estructura.
Cada proyecto crea su propio esquema,
y esos esquemas son incompatibles entre sí.

El lenguaje natural es rico en significado pero carece de estructura.
Los lenguajes de programación tienen estructura pero carecen de significado.
Los formatos de datos tienen estructura y significado pero carecen de unificación.

Lo que se necesita es un tipo diferente de lenguaje.

---

## El camino señalado por LLVM

Existe un precedente exacto en la informática.

En la década de 1990, había decenas de lenguajes de programación
y decenas de arquitecturas de procesador.
Para que todos los lenguajes soportaran todas las arquitecturas,
se necesitaban N x M compiladores.

La solución de LLVM fue una representación intermedia (IR, Intermediate Representation).

Todos los lenguajes se traducen a LLVM IR.
LLVM IR se traduce a todas las arquitecturas.
Solo se necesitan N + M traductores.

Los usuarios nunca ven LLVM IR.
Escriben en C++ y reciben un ejecutable.
LLVM IR trabaja tras bambalinas.

GEUL es el LLVM IR para la IA.

Todos los lenguajes naturales se traducen a GEUL.
GEUL se almacena en WMS, se usa para el razonamiento y se traduce de vuelta al lenguaje natural.
Los usuarios nunca ven GEUL.
Preguntan en lenguaje natural y reciben respuestas en lenguaje natural.
GEUL trabaja tras bambalinas.

---

## Las condiciones que un lenguaje artificial debe cumplir

Para superar las limitaciones del lenguaje natural sin perder su poder expresivo,
un lenguaje artificial debe satisfacer simultáneamente las siguientes condiciones.

**1. Eliminación de la ambigüedad**

Cuando se ingresa "Yi Sun-sin fue grande",
"quién lo afirmó, en qué contexto, con qué fundamento, con qué grado de certeza"
debe estar estructuralmente especificado.
Si un campo está vacío, debe marcarse como vacío.
Sin dependencia de la implicación.

**2. Metadatos integrados**

Cada enunciado debe incluir fuente, marca temporal, grado de confianza y punto de vista (POV)
como parte de la estructura del propio enunciado, no como anotaciones separadas.
Sin esto, la IA de caja blanca es imposible.

**3. Compatibilidad con LLM**

Los LLM deben poder "aprender" este lenguaje.
No necesita ser fácil de entender para los humanos.
Lo que importa es que sea tokenizable, que los patrones sean regulares
y que siga una estructura fija.

**4. Expresividad de grafos**

El mundo no es una tabla, es un grafo.
Las entidades son nodos y las relaciones son aristas.
Un lenguaje artificial debe poder serializar grafos de forma natural.

**5. Separación entre hecho y narración**

"Yi Sun-sin murió en 1598" no es un hecho.
"Los Anales de la Dinastía Joseon registran que Yi Sun-sin murió en 1598" es el dato primario.
Un lenguaje artificial debe imponer estructuralmente esta distinción.

**6. Extensibilidad futura**

El sistema definido hoy debe mantenerse compatible hacia atrás y extensible
dentro de diez años, de cien años y en un futuro inimaginable.

---

## Por qué los enfoques existentes son insuficientes

Este no es el primer intento.

**Esperanto** fue un lenguaje artificial diseñado para humanos.
Es estructurado, pero no fue diseñado para albergar el razonamiento de la IA.
Priorizó la facilidad de aprendizaje sobre la precisión del significado.

**OWL/RDF** fue un sistema de representación semántica diseñado para máquinas.
Lógicamente riguroso, pero diseñado en la era anterior a los LLM.
La traducción desde y hacia el lenguaje natural es difícil, y las expresiones son verbosas.
Y fatalmente lento: el razonamiento a gran escala no es práctico.

**Los grafos de conocimiento (Wikidata, Freebase)** representaron el mundo como un grafo.
Pero almacenan "hechos", no "narraciones."
Almacenan "Yi Sun-sin fue un general" como un triple,
pero no quién lo afirmó ni con qué grado de confianza.

**Chain-of-Thought** registra el proceso de razonamiento de un LLM en lenguaje natural.
Una buena dirección, pero dado que el medio de registro es el lenguaje natural,
no puede resolver fundamentalmente el problema de la ambigüedad.

Cada uno de estos enfoques satisface una o dos de las condiciones,
pero ninguno satisface las seis simultáneamente.

---

## GEUL: la intersección de seis condiciones

GEUL se sitúa en la intersección de estas seis condiciones.

Un formato de flujo basado en palabras de 16 bits.
El contexto, la fuente y la confianza están estructuralmente integrados en cada enunciado.
Los grafos se serializan mediante paquetes de nodos y aristas.
Sigue patrones fijos que se mapean 1:1 con los tokens del LLM.
Trata la narración (Claim), no el hecho, como dato primario.
Reserva el 50% del espacio total de direcciones para el futuro.

GEUL es invisible para los usuarios.
Los usuarios hablan en lenguaje natural y reciben respuestas en lenguaje natural.
Entre ambos, GEUL estructura el razonamiento,
lo registra, lo acumula y lo hace reutilizable.

---

## La era del lenguaje natural no termina

Hay algo que no debe malinterpretarse.

GEUL no reemplaza al lenguaje natural.
Los humanos seguirán hablando, escribiendo y pensando en lenguaje natural.
El lenguaje natural sobrevivirá para siempre como el lenguaje de la humanidad.

Lo que GEUL reemplaza es
el rol que el lenguaje natural ha estado desempeñando dentro de la IA.

El medio del razonamiento.
El formato de almacenamiento del conocimiento.
El protocolo de comunicación entre sistemas.

En este rol, el lenguaje natural ya ha alcanzado su límite.
Ese límite se manifiesta como alucinación, como cajas negras, como ineficiencia.

El lenguaje natural trajo a la humanidad hasta aquí.
Ese logro es eterno.
Pero para alcanzar la siguiente etapa, se necesita un nuevo lenguaje.

Esa es la razón por la que se necesita un lenguaje artificial.

---

## Resumen

La ambigüedad del lenguaje natural es una función en la comunicación humana, pero un defecto en el razonamiento de la IA.

1. El lenguaje natural no tiene espacio estructural para metadatos.
2. Por lo tanto, la IA razona sin fuente, sin confianza y sin contexto.
3. Por lo tanto, ocurre la alucinación. Esto no es un error, es una inevitabilidad estructural.
4. Los lenguajes de programación describen procedimientos; no pueden describir el mundo.
5. Los sistemas de representación semántica existentes satisfacen solo una o dos condiciones cada uno.
6. Se necesita un nuevo lenguaje artificial que satisfaga las seis condiciones simultáneamente.

Así como LLVM IR es el puente invisible entre los lenguajes de programación y el hardware,
GEUL es el puente invisible entre el lenguaje natural y el razonamiento de la IA.
