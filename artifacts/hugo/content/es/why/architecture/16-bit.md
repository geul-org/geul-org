---
title: "Por que 16 bits?"
weight: 17
date: 2026-02-26T12:00:04+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["16-bit", "binario", "flujo"]
summary: "Una sola palabra de 16 bits está diseñada para ser la unidad de tres mundos: el flujo de red, el formato de archivo y el vocabulario del LLM. Por qué 16 bits y no 8, 32 ni longitud variable."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

## Una sola palabra penetra tres mundos

---

## Tres mundos

Existen tres mundos en la informatica.

**El mundo de las redes.**
Los datos fluyen como flujos de bytes.
Los bytes entran por sockets TCP y los bytes salen.
El vocabulario del ingeniero de redes son paquetes, encabezados y cargas utiles.

**El mundo del almacenamiento.**
Los datos se persisten en formatos de archivo.
Se escriben en disco, se leen del disco.
El vocabulario del ingeniero de almacenamiento son bloques, offsets y alineacion.

**El mundo de la IA.**
Los datos se procesan como secuencias de tokens.
Los LLM reciben tokens y producen tokens.
El vocabulario del ingeniero de IA son embeddings, atencion y contexto.

Estos tres mundos hablan idiomas diferentes.
Y entre ellos, siempre se requiere traduccion.

---

## El costo de la traduccion

Sigamos el camino que recorren los datos en un sistema de IA moderno.

El conocimiento se almacena en un archivo. Como JSON o texto plano.

Para entregarselo a una IA:

1. Abrir el archivo y leer el texto.
2. Parsear el texto. Si es JSON, interpretar la estructura y extraer campos.
3. Introducir el texto extraido en un tokenizador.
4. El tokenizador convierte el texto en una secuencia de IDs de tokens.
5. La secuencia de tokens se alimenta al LLM.

Cuando la IA genera una respuesta:

6. El LLM produce una secuencia de tokens.
7. Decodificar los tokens de vuelta a texto.
8. Serializar el texto en un formato estructurado.
9. Escribir los datos serializados en un archivo.

Una simple operacion de "leer y escribir" requiere nueve pasos.

Cada paso cuesta tiempo.
Cada paso cuesta memoria.
Cada paso arriesga perdida de informacion.

Los pasos 3 y 4 -- el proceso de tokenizacion -- son notoriamente problematicos.
Porque los limites de las palabras en lenguaje natural no se alinean con los limites de los tokens del tokenizador,
un nombre propio como "Yi Sun-sin" puede dividirse en fragmentos arbitrarios,
o una sola unidad semantica se dispersa entre multiples tokens.

Este es el precio de que tres mundos hablen idiomas diferentes.

---

## ¿Y si una sola unidad atravesara los tres mundos?

En este lenguaje, una palabra son 16 bits (2 bytes).

Una sola palabra de 16 bits está diseñada para cumplir tres funciones a la vez.

**Unidad del flujo de bytes.**
Las palabras de 16 bits llegan en flujo continuo por la red.
Big Endian. Alineadas a 2 bytes.
Basta con leerlas en el orden en que llegan.

**Unidad del formato de archivo.**
Escribe el flujo tal cual en disco y eso es tu archivo.
Lee los bytes del disco y envíalos tal cual por la red, y eso es tu flujo.
Sin serialización. Sin deserialización.

**Unidad del vocabulario del LLM.**
16 bits = 65.536 símbolos distintos.
El tamaño de vocabulario de los LLM modernos va de decenas de miles a cientos de miles.
GPT-2 usa unos 50.000; los modelos recientes, entre 100.000 y 200.000.
65.536 cae dentro de ese rango.
Una palabra de 16 bits es una unidad de un tamaño que un LLM puede aprender como vocabulario.

Tres mundos comparten la misma unidad.
La traducción se reduce.

---

## El flujo es el archivo

Veamos qué significa esto en concreto.

**Enfoque convencional: 9 pasos**

```
[Archivo] -> Leer -> Analizar -> Extraer texto -> Tokenizar -> [LLM]
[LLM] -> Decodificar -> Serializar -> Escribir -> [Archivo]
```

**El enfoque GEUL**

```
[Flujo] = [Archivo]                            mismos bytes
[Archivo] -> leer registro a registro, saltando   sin libro de códigos
```

Escribe un flujo tal cual y es un archivo. Envía un archivo tal cual y es un flujo.
Sin serialización ni deserialización.
La primera palabra de cada registro (la TAG WORD) indica su tipo y su longitud,
así que los registros que no necesitas se saltan sin interpretarlos.

El lado del LLM sigue siendo una meta.
Una palabra no equivale a un token.
Un registro ocupa varias palabras, y el texto va como cadena de bytes.
Aun así, cuando la unidad está fija en 16 bits,
el tokenizador no tiene que adivinar los límites; sigue límites que ya están dados.
"Yi Sun-sin" no se parte en un lugar arbitrario, porque es un único registro Reference que apunta a Wikidata Q50184.

---

## Por que no 8 bits?

8 bits te dan 256 simbolos distintos.

256 simbolos son demasiado pocos para representar el mundo.
Asigna el alfabeto, los digitos y la puntuacion basica, y ya se fue la mitad del espacio.

Si usas 8 bits como tu unidad fundamental,
la mayoria de los tokens significativos terminan requiriendo 2 o mas bytes.
Eso fuerza una codificacion de longitud variable,
y la longitud variable hace el parseo complejo.

Adecuado como unidad de flujo de bytes,
pero insuficiente como unidad de token.

---

## ¿Por qué no 32 bits?

32 bits dan unos 4.300 millones de símbolos distintos.

El poder expresivo sobra.
Pero el problema es la eficiencia.

El registro más pequeño de este lenguaje ocupa 1 palabra: marcadores como BODY y END, que constan de una sola TAG WORD.
Una Reference a Wikidata Q42 ocupa 2 palabras,
y un TRIPLE que dice "Q42 es un ser humano" ocupa 10.
Con palabras de 16 bits, ese TRIPLE son 20 bytes. Con palabras de 32 bits, serían 40.
El mismo registro duplica su tamaño.

Desde la perspectiva del LLM también hay un problema.
Un vocabulario de 32 bits, con 4.300 millones de símbolos, es decenas de miles de veces mayor que cualquier vocabulario de LLM.
No hay datos ni modelos para aprender un vocabulario tan grande.

Una palabra de 32 bits es excesiva como unidad de este lenguaje.

---

## Por que no longitud variable?

UTF-8 es una codificacion de longitud variable.
La longitud de un caracter varia de 1 byte a 4 bytes dependiendo del caracter.

Esto ofrece ventajas en eficiencia de almacenamiento,
pero introduce una debilidad fatal en eficiencia de procesamiento.

Para encontrar el n-esimo caracter, hay que contar desde el principio.
El acceso aleatorio es imposible.
El procesamiento paralelo con SIMD se vuelve dificil.

Este lenguaje usa palabras de 16 bits de ancho fijo como su unidad fundamental.
La posicion de la n-esima palabra es siempre n * 2 bytes.
El acceso aleatorio es O(1).
SIMD puede comparar multiples palabras en una sola instruccion.
Las GPU pueden escanear miles de millones de palabras en paralelo.

Aun así, a nivel de registro se permite la longitud variable.
Los registros van de 1 palabra a 2³²−1 palabras, y la longitud está escrita en la primera palabra.
La unidad de palabra es fija, pero la unidad de registro es flexible.

La eficiencia de procesamiento del ancho fijo combinada con la expresividad de la longitud variable.
La palabra de 16 bits logra ambas simultaneamente.

---

## El camino que Unicode demostró

Unicode es el estándar de codificación más exitoso que ha creado la humanidad.

La unidad básica de UTF-16 son 16 bits (2 bytes).
Representa los caracteres del Plano Multilingüe Básico (BMP) en una sola palabra
y extiende los demás con pares sustitutos (2 palabras = 4 bytes).

GEUL sigue la misma estructura.
Los formatos frecuentes van como código directo dentro de una sola TAG WORD,
y los raros se amplían con TAG de extensión.

Así como Unicode expresa todos los caracteres del mundo
sobre la unidad básica "un carácter = 2 bytes",
GEUL expresa afirmaciones, sus fuentes y sus fundamentos
sobre la unidad básica "una palabra = 2 bytes".

---

## Compatibilidad hacia atras y extension hacia arriba

Otra fortaleza de 16 bits es la alineacion.

16 es multiplo de 8, divisor de 32, divisor de 64 y divisor de 128.

Esto significa que la alineacion nunca se rompe, sin importar en que direccion te extiendas.

Y si la arquitectura transformer cambia en el futuro
y los tokens se convierten en 32 bits?
Dos palabras de 16 bits hacen un token. Sin problemas de alineacion.

Y 64 bits?
Cuatro palabras de 16 bits hacen un token. Sigue sin problemas de alineacion.

A la inversa, que pasa si un sistema embebido de 8 bits procesa este formato?
Simplemente lee cada palabra de 16 bits como un byte alto y un byte bajo.

La compatibilidad hacia atras debe mantenerse absolutamente.
La palabra de 16 bits garantiza esto a nivel fisico.

No podemos predecir el tamano de palabra de las inteligencias futuras,
pero la alineacion multiple de 16 bits garantiza compatibilidad con cualquier tamano.

---

## La estructura triple

Resumamos.

Una sola palabra de 16 bits está diseñada para ser la unidad de tres mundos.

| Mundo | Papel de una palabra |
|-------|---------------------|
| Red | Unidad del flujo de bytes |
| Almacenamiento | Unidad del formato de archivo |
| IA | Unidad del vocabulario del LLM (meta) |

Una sola unidad atraviesa los tres mundos.

Guarda un flujo tal cual y es un archivo.
Envía un archivo tal cual y es un flujo.
Hacer que encaje con los LLM palabra a palabra es el siguiente paso.

Menos conversión.
Menos traducción.
Menos pérdida.

Por eso 16 bits.
Ni 8, ni 32, ni longitud variable.
El número que está justo en la intersección de tres mundos.

16.
