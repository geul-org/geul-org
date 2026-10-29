---
title: "Por que un indice semanticamente alineado?"
weight: 16
date: 2026-02-26T12:00:03+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["SIDX", "alineacion semantica", "indice"]
summary: "Si un ID fuera conocimiento y no una dirección, una sola operación de bits podría acotar los candidatos sin ningún JOIN. Este ensayo presenta SIDX, el identificador semánticamente alineado que GEUL está investigando, y por qué su anchura se fijará con estadísticas de uso."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

## Que sucede cuando un ID es conocimiento, no una direccion

---

## Una direccion no sabe nada

Para encontrar a Yi Sun-sin en una base de datos, necesitas un ID.

En Wikidata, el ID de Yi Sun-sin es `Q50184`.

Este numero apunta a Yi Sun-sin.
Pero la cadena `Q50184` en si misma no sabe nada.

No sabe si se trata de una persona o un edificio.
No sabe si es coreano o ciudadano frances.
No sabe si es una figura del siglo XVI o del siglo XXI.
No sabe si esta vivo o muerto.

`Q50184` es una direccion.
Un cartero que entrega correo no tiene idea de lo que esta escrito dentro del sobre.
Simplemente mira la direccion en el sobre y lo entrega.

UUID es igual. `550e8400-e29b-41d4-a716-446655440000`.
128 bits de numeros aleatorios. Unico solo para evitar colisiones --
no te dice nada sobre lo que referencia.

Durante los ultimos cincuenta anos, los IDs de las bases de datos han funcionado asi.
Un ID es una direccion, y para saber algo, debes seguir esa direccion y leer los datos.

---

## Hay que seguirlo para saber

Por que es esto un problema?

Supongamos que quieres encontrar "un filosofo varon de nacionalidad alemana nacido en el siglo XIX".

En una base de datos tradicional, esto funciona asi:

```
1. Filtrar la tabla de personas donde genero = 'masculino'
2. JOIN con la tabla de nacionalidades y filtrar pais = 'Alemania'
3. JOIN con la tabla de fechas de nacimiento y filtrar anio BETWEEN 1800 AND 1899
4. JOIN con la tabla de ocupaciones y filtrar ocupacion = 'filosofo'
```

Cuatro operaciones JOIN.
Cada JOIN compara filas entre dos tablas.
Si las tablas son grandes, recorre un indice; si no hay indice, realiza un escaneo completo.
Con mil millones de registros, este proceso toma de segundos a decenas de segundos.

Por que es tan complejo?

Porque el ID no sabe nada.
Mirando `Q50184`, no puedes decir si es aleman o coreano,
asi que debes ir a otra tabla para obtener esa informacion.

Para cada pregunta, hay que seguir a donde apunta el ID.
Este es el costo que las bases de datos han pagado durante cincuenta anos.

---

## Y si el ID ya supiera?

Invirtamos la premisa.

Y si el ID mismo contuviera la informacion esencial?

Y si, simplemente mirando el ID,
pudieras saber si se refiere a un humano, de que pais es,
a que epoca pertenece y como esta clasificado?

Para encontrar "un filosofo varon aleman del siglo XIX",
los JOIN se vuelven innecesarios.

Escaneando mil millones de IDs,
puedes determinar instantaneamente si cada uno coincide examinando sus bits.

Esta es la idea central detras del Indice Semanticamente Alineado.

---

## Alinear el significado en el ID

SIDX (Semantically-Aligned Index) es la investigación para construir un ID así.
La gramática GEUL ya tiene un espacio de Reference que apunta a un objeto mediante SIDX ([GEUL-SIDX](/es/grammar/reference/geul-sidx/)).
Pero su anchura y su método de asignación aún no están decididos. Se fijarán a partir de estadísticas de uso acumuladas.
A continuación, se usan 64 bits como ejemplo para la explicación.

Los bits de un SIDX no son números aleatorios.
A la posición de cada bit se le asigna un significado.

Los bits superiores contienen la información más importante.
¿Qué tipo de entidad es? ¿Una persona, un lugar, un evento, un concepto?

Los siguientes bits contienen información de clasificación.
Si es una persona, ¿de qué época? ¿De qué región?

Los bits inferiores llevan información cada vez más específica.

El principio clave es este:

> El orden de los bits es el orden de importancia de la información.

La clasificación más fundamental arriba,
las distinciones más finas abajo.

Esto no es un simple ordenamiento.
Es una filosofía de diseño.

---

## De mil millones a diez mil, en una sola pasada

El poder práctico de SIDX se ve en los números.

Supongamos mil millones de entidades, cada una con un SIDX de 64 bits.
Tamaño total: mil millones × 8 bytes = 8 GB.

Estos 8 GB caben enteros en memoria.

Quieres encontrar "entidades que son humanas y proceden de Asia oriental".
Si los bits superiores contienen una marca de "humano" y un código de "Asia oriental",
puedes filtrar con una sola máscara de bits.

```
mask   = 0xFF00_0000_0000_0000  (8 bits superiores: tipo + región)
target = 0x8100_0000_0000_0000  (humano + Asia oriental)

for each sidx in mil_millones:
    if (sidx & mask) == target:
        añadir a candidatos
```

Esta operación se paraleliza con SIMD.
El límite no es el cálculo sino el ancho de banda de memoria.
En una medición preliminar para [SILK](/es/projects/silk/), escanear con una máscara 100 millones de firmas de 128 bits (1,6 GB) llevó unos 27 milisegundos con 8 hilos de Go.
Al mismo ritmo, mil millones de SIDX de 64 bits (8 GB) tomarían algo más de 0,1 segundos.

Mil millones de registros reducidos a diez mil.
Filtrar en detalle los diez mil restantes es instantáneo.

Cero JOIN.
Cero recorridos de árbol de índices.
Solo un AND de bits.

---

## ¿Qué anchura debería tener?

Al principio pensé que hacía falta un espacio mayor.

32 bytes (256 bits). Un vector FP16 de 32 dimensiones.
Intenté meter en el ID todos los atributos clave de una entidad.
Si es humano, sexo, nacionalidad, época, ocupación, región, si vive, ruta de clasificación...

Pero me di cuenta de algo.

**El ID no necesita saberlo todo.**

Solo necesita reducir mil millones de registros a diez mil.
La verificación precisa se encarga del resto.

Es como un puesto de control.
En un peaje de autopista, para determinar por la matrícula
que "este vehículo va hacia la provincia de Gyeonggi",
no hace falta saber qué lleva en el maletero.

Entonces quizá basten 64 bits.
Con los bits superiores para el tipo y la clasificación general,
y los inferiores para la clasificación fina,
reducir mil millones de registros a diez mil parece holgadamente posible.
64 bits = cuatro palabras de 16 bits. Ligero incluso dentro de un flujo.

Pero esto sigue siendo una hipótesis.
GEUL no decide la anchura en un escritorio.
Con candidatos como 4 WORD (64 bits) y 16 WORD, la decidirá a partir de estadísticas de uso reales.
Hasta entonces, los objetos se referencian con ID asignados en secuencia,
y una vez asignado un SIDX, ambos ID se enlazan como el mismo objeto.

---

## Degradacion elegante: el significado sobrevive incluso cuando los bits se truncan

Otra fortaleza de la alineacion semantica son sus caracteristicas de degradacion.

Porque los bits de SIDX estan ordenados de mas a menos importante,
incluso si los bits inferiores se danan o truncan,
la informacion central en los bits superiores se preserva.

```
64 bits completos:  "Yi Sun-sin, comandante naval de Joseon del siglo XVI"
48 bits:            "Oficial militar de Joseon del siglo XVI"
32 bits:            "Humano del este de Asia del siglo XVI"
16 bits:            "Humano"
8 bits:             "Entidad fisica"
```

A medida que la informacion se trunca, se pierde especificidad,
pero la clasificacion mas fundamental sobrevive hasta el final.

Esta es una implementacion a nivel de bits del principio de "degradacion elegante".

Incluso si una interrupcion de red entrega solo datos parciales,
el sistema sabe "no se exactamente quien es, pero al menos es una historia sobre un humano"
y puede continuar razonando.

Un contorno borroso es mejor que el silencio total.
La comprension parcial es mejor que el fallo completo.

---

## Una consulta se convierte en un ID

La posibilidad más fascinante que abre la indexación semánticamente alineada:

¿Y si una consulta en lenguaje natural pudiera convertirse en un SIDX temporal?

Un usuario pregunta: "¿Quién fue el general que derrotó a la armada japonesa durante la guerra de Imjin?"

El codificador analiza la pregunta.
Humano. Asia oriental. Siglo XVI. Relacionado con lo militar.
Al ensamblar estos atributos en bits se obtiene un SIDX temporal.

Este SIDX temporal escanea mil millones de SIDX.
Las entidades con patrones de bits más parecidos surgen como candidatas.
Yi Sun-sin, Won Gyun, Gwon Yul, Yi Eok-gi...

Contrastando la información detallada con estos candidatos se obtiene la respuesta final.

La búsqueda y la vinculación de entidades (entity linking) podrían convertirse en un único mecanismo.
Sin un motor de búsqueda aparte,
sin una canalización de NER (reconocimiento de entidades nombradas) aparte,
con una sola comparación de SIDX.

---

## ¿Por qué no un B-Tree?

Las bases de datos tradicionales usan índices B-Tree.

Los B-Tree destacan al encontrar un valor concreto en datos ordenados en O(log n).
Para "encontrar Q50184", son óptimos.

Pero para "encontrar todas las entidades humanas originarias de Asia oriental", son débiles.
Las búsquedas con condiciones compuestas exigen intersecar varios índices,
y el costo de la intersección crece bruscamente con la escala de los datos.

El escaneo exhaustivo SIDX + SIMD es otro enfoque.

Si un B-Tree es una guía telefónica que responde rápido "quién vive en esta dirección",
un escaneo SIDX es un perfilado que responde rápido "quién tiene estas características".

El tipo de pregunta es distinto, y por eso también lo es la estructura de datos óptima.

| Tipo de consulta | B-Tree | Escaneo SIDX |
|-----------|--------|-----------|
| Búsqueda por ID concreto | O(log n), óptimo | Innecesario (se resuelve con hash) |
| Filtrado por condiciones compuestas | Requiere JOIN, lento | Un AND de bits, rápido |
| Búsqueda de entidades similares | Imposible | Posible por similitud de bits |
| Inserción | O(log n), rebalanceo | O(1), anexar |
| Complejidad de implementación | Alta | Baja |

No compiten: se reparten el trabajo.
Hoy SILK resuelve consultas exactas como "documentos cuyo predicado es P106 y cuyo objeto es Q169470" con corridas ordenadas y búsqueda binaria.
El escaneo de firmas de bits, como primer filtro delante de eso, está planeado como siguiente paso.

Simple. A fuerza bruta. Rápido.

---

## La sabiduría de Huffman

La asignación de bits de SIDX sigue el principio de la codificación de Huffman.

En la codificación de Huffman, los símbolos frecuentes reciben códigos cortos
y los raros, códigos largos.

En SIDX, la información de clasificación más necesaria ocupa los bits superiores,
y los detalles poco necesarios, los inferiores.

La asignación de Codec en la gramática GEUL sigue el mismo principio.
Los formatos de frecuencia comprobada reciben un código directo corto dentro de la TAG WORD,
y los raros pasan a formatos de Issuer con TAG de extensión.

La sabiduría de Huffman atraviesa todo este diseño.
El menor costo para lo que más se usa.

---

## Resumen

Un ID tradicional es una dirección. Una dirección no sabe nada.

1. Si el ID no lleva significado, hay que seguirlo hasta los datos cada vez. Eso es un JOIN.
2. Cuatro JOIN sobre mil millones de registros son lentos.
3. SIDX es la investigación para codificar el significado en el propio ID mediante alineación semántica.
4. Un solo AND con máscara de bits puede reducir mil millones de registros a diez mil. Cero JOIN.
5. El ID no necesita saberlo todo; solo tiene que acotar los candidatos. La anchura se fijará con estadísticas de uso.
6. Como la información más importante está en los bits superiores, el núcleo del significado sobrevive aunque se trunquen bits.
7. Si una consulta en lenguaje natural puede convertirse en un SIDX temporal, la búsqueda se vuelve una operación de bits.

En el momento en que un ID deja de ser una dirección y se convierte en conocimiento,
las reglas de la base de datos cambian.
