---
title: "Direcciones de publicación y lista de versiones"
weight: 85
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "Un documento GEUL publicado se sirve desde una dirección fija determinada por su ID (Issuer, ID de documento, ID de versión) y se verifica con una lista de versiones firmada por el lugar de publicación. Esta página fija la notación de ID, las direcciones, la designación de formato, el índice de nombres, la lista de versiones y las capas de confianza."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL señala los documentos con un ID (Issuer, ID de documento, ID de versión), no con una URL en forma de cadena. La dirección se determina a partir del ID. Esta página fija las reglas de publicación necesarias para que codificadores, decodificadores e intérpretes funcionen de forma engranada. Los grados de Issuer y el modo de divulgación los fija [Issuer y publicación](/es/grammar/issuer/).

## Notación de ID

Los ID que se usan en las direcciones se escriben en hex.

- El prefijo es `0x` en minúsculas, y los dígitos hex también en minúsculas.
- El número de dígitos se fija en ancho × 4. No se omiten los ceros a la izquierda, y el número de dígitos es el ancho.
- El ID de Issuer se escribe con el ancho más corto en que quepa el valor. No existe una notación ensanchada como `0x00000005` (`0x0005`).

| Objeto | Ancho | Dígitos | Ejemplo |
|---|---|---|---|
| Issuer | 1 WORD | 4 | `0x0001` |
| Issuer | 2 WORD | 8 | `0x00010000` |
| Issuer | 4 WORD | 16 | `0x0000000100000000` |
| Issuer | 16 WORD | 64 | `0x` + 64 dígitos |
| ID de documento | 4 WORD | 16 | `0x0000000000000000` |
| ID de versión | 2 WORD | 8 | `0x00000003` |
| Hash de contenido | 16 WORD | 64 | `0x` + 64 dígitos |

- Las solicitudes que no estén en forma canónica (`0X`, mayúsculas, ceros omitidos) se redirigen con `301` a la dirección canónica. Así la clave de caché y el objeto de la firma quedan determinados de forma única.
- Las reglas del ID de versión (desde 1, `0` es la última, asignación por el lugar de publicación, nuevo ID de documento al agotarse) las fija [Documento](/es/grammar/document/#versión).

## Dirección de publicación

```
/.well-known/geul/<Issuer>/<ID de documento>.geul              Última versión. Se envía con 302 a la dirección canónica (mutable)
/.well-known/geul/<Issuer>/<ID de documento>/<ID de versión>.geul    Un ejemplar del documento (inmutable, dirección canónica)
/.well-known/geul/<Issuer>/<ID de documento>/versions.geul     Documento de lista de versiones (mutable, firmado)
/.well-known/geul/h/<hash de contenido>.geul                   Consulta por hash de contenido (inmutable)
```

Ejemplo: `/.well-known/geul/0x0001/0x0000000000000000.geul`

- La ruta sigue `.well-known` de RFC 8615. geul.org y las publicaciones privadas usan la misma ruta y solo cambia el dominio. El único sufijo que se registra es `geul`.
- El contenido del documento solo sale de direcciones inmutables. La dirección de la última versión no entrega contenido sino que envía con `302` a la dirección canónica de esa versión.
- La dirección canónica de una versión es `/<Issuer>/<ID de documento>/<ID de versión>.geul`. Las demás direcciones que entregan el mismo contenido señalan la dirección canónica con `Link: rel=canonical`.
- Las direcciones inmutables pueden ir a caché permanente y CDN. Quien las recibe verifica con el hash de contenido de la lista de versiones (o del registro de bloqueo).
- El ID siempre empieza por `0x`. Por eso los nombres reservados (`h`, `keys`, `issuers.geul`, `documents.geul`, `versions.geul`) o los nombres puestos por personas no chocan con un ID, aunque sean palabras solo hex como `add` o `cafe`.
- La ubicación (desde qué servidor se recibe) no se incluye en el contenido del documento. Si se incluyera, el hash de contenido cambiaría cuando cambiase la dirección. La ubicación la fija la configuración de quien recibe el documento.

### Designación de formato

- Si hay extensión, se está designando el formato. `.geul` es binario (`application/vnd.geul`).
- Si no hay extensión, se sigue la cabecera `Accept`. A los navegadores se les da una vista HTML y a las herramientas el binario. Ejemplo: `/<Issuer>/<ID de documento>/<ID de versión>`
- La versión canónica del documento es el binario. El hash de contenido y la firma se calculan solo sobre el binario.

### Nombre de dominio

Un Issuer que haya pasado la prueba de propiedad de dominio puede usar ese dominio en lugar del ID en la posición `<Issuer>` de la dirección.

```
/.well-known/geul/<dominio>/<ID de documento>.geul              → 302 → /<Issuer>/<ID de documento>.geul
/.well-known/geul/<dominio>/<ID de documento>/<ID de versión>.geul    → 302 → /<Issuer>/<ID de documento>/<ID de versión>.geul
/.well-known/geul/<dominio>/<ID de documento>/                  → 302 → /<Issuer>/<ID de documento>/
```

Ejemplo: `/.well-known/geul/geul.org/0x0000000000001018/0x00000001.geul`

- La dirección de dominio no entrega contenido sino que envía con `302` a la dirección de ID. La dirección canónica, la clave de caché y el objeto de la firma son la dirección de ID. Como la correspondencia puede cambiar, no se usa redirección permanente.
- El dominio se escribe en minúsculas, y los dominios internacionalizados en forma IDNA (punycode). No se añade el `.` final. Si no está en forma canónica, se redirige con `301` a la forma canónica.
- Como el dominio contiene `.`, no choca con los ID que empiezan por `0x` ni con los nombres reservados.
- Cuando el intérprete recibe una dirección de dominio, comprueba la correspondencia con el índice de nombres de Issuer, la convierte en ID y la deja en el registro de bloqueo.
- Los Issuer de 16 WORD, que no tienen registro, y los entornos aislados de la red que no llegan a geul.org no pueden usar nombres de dominio. Usan direcciones de ID.

### Nombre del Issuer

El índice de nombres de Issuer es un único documento, `/.well-known/geul/issuers.geul`.

```
BODY
  BIND   Subject = ISSUER-POINTER(Issuer)   nombre = "geul.org"
  …
```

- El Subject es [ISSUER-POINTER](/es/grammar/reference/issuer-pointer/) (el propio Issuer) y el nombre se vincula con [BIND](/es/grammar/edge/bind/).
- El nombre es un dominio que ha pasado la prueba de propiedad de dominio. Va en minúsculas y los dominios internacionalizados se escriben en IDNA (punycode). Un nombre se vincula a un único Issuer.
- El nombre para mostrar del Issuer legible por personas (por idioma) se añade al mismo Subject con una afirmación [LABEL](/es/grammar/edge/label/).
- Lo firma geul.org (el Issuer GEUL) y, cuando cambia, se añade sin corregir (la misma regla de cadena que la lista de versiones).
- El nombre reservado `issuers.geul` tiene `.`, por lo que tiene forma de dominio. Aunque aparezca un dominio con el mismo nombre, esta ruta sigue siendo el índice de nombres de Issuer.

### Nombre del documento

También se puede usar en la dirección el nombre del documento en lugar del ID de documento. En la posición `<Issuer>` se usa el ID o el nombre de dominio.

```
/.well-known/geul/<Issuer|dominio>/<nombre de documento>.geul              → 302 → /<Issuer>/<ID de documento>.geul
/.well-known/geul/<Issuer|dominio>/<nombre de documento>/<ID de versión>.geul    → 302 → /<Issuer>/<ID de documento>/<ID de versión>.geul
/.well-known/geul/<Issuer|dominio>/<nombre de documento>/                  → 302 → /<Issuer>/<ID de documento>/
```

Ejemplo: `/.well-known/geul/geul.org/publication/0x00000001.geul` → `/0x0000/0x0000000000001018/0x00000001.geul`

**El nombre del documento lo vincula con BIND el índice de nombres del Issuer `/<Issuer>/documents.geul`.** El intérprete hace corresponder el nombre con un ID de documento mediante este índice.

```
BODY
  BIND   Subject = DOC-POINTER(Issuer, ID de documento, versión 0)   nombre = "publication"
  …
```

- El Subject es [DOC-POINTER](/es/grammar/reference/doc-pointer/) (Issuer, ID de documento, versión `0`). El nombre se vincula al documento, no a una versión.
- El Issuer del Subject debe ser el mismo que el Issuer que tiene el índice. Los documentos de otros Issuer se ignoran.
- El nombre solo se vincula a documentos publicados.
- El nombre del documento es un slug ASCII en minúsculas: `a-z`, `0-9`, `-`. No empieza ni termina por `-` y no empieza por `0x`. Por eso no choca con un ID de documento (`0x…`) ni con nombres reservados (`h`, `versions.geul`, etc.) ([BIND](/es/grammar/edge/bind/)).
- Dentro de un Issuer, un nombre se vincula a un único documento, y un nombre ya vinculado no se reutiliza para otro documento. Si se cambia el nombre, se añade un nuevo BIND. El nombre antiguo sigue enviando al mismo documento. Si el mismo nombre aparece varias veces, el último BIND es el representativo.
- Dentro del documento no se escribe su propio nombre. La dirección canónica, la clave de caché y el objeto de la firma son la dirección de ID. IMPORT y las citas dentro de un documento se hacen solo con ID.
- El título legible por personas (por idioma) no es el nombre. Se añade con una afirmación `LABEL`.
- El documento de lista de versiones también puede llevar el mismo BIND de nombre de documento ([PUBLICATION](/es/grammar/edge/publication/#nombre-del-documento)). Si lo lleva, debe ser igual al índice de nombres. El intérprete lee solo el índice de nombres.

### Documentos eliminados

- La dirección de una versión eliminada legalmente o de oficio devuelve `410 Gone` y una lápida (ID de versión, hash de contenido, fecha de eliminación, categoría del motivo).
- En la lista de versiones queda como registro [TOMBSTONE](/es/grammar/edge/publication/).

## Capas

GEUL expresa como documentos GEUL incluso la procedencia, los metadatos y las listas. Lo mínimo necesario para leerlos viene incorporado en el decodificador para cortar la circularidad. Cada capa depende solo de las capas inferiores.

| Capa | Contenido | De qué depende |
|---|---|---|
| Capa 0 | Reglas incorporadas en el decodificador: framing, hash de contenido, verificación de firmas, Codec de los registros de la lista de versiones (`PUBLICATION`·`DEPRECATION`·`TOMBSTONE`), vocabulario de especificación de Codec (`DECLARE`·`FIELD`·`ENUM`·`CODEC`), [marcador de posición](/es/grammar/reference/slot-marker/) (`0x0000`~`0x0002`), claves de confianza recibidas fuera del documento | De nada. No se consulta |
| Capa 1 | Documento de lista de versiones | Capa 0 |
| Capa 2 | Documentos normales, libros de códigos, documentos de especificación de Codec, documentos de claves de verificación de Issuer | Se encuentran con la capa 1 y se verifican con la capa 0 |

- Ninguna capa depende de sí misma ni de las superiores.
- Se distingue entre lo que se expresa en GEUL y lo que solo se lee interpretando GEUL. La capa 0 se puede expresar en GEUL, pero su interpretación no requiere consultas.
- Lo que no se puede convertir en documentos TOULMIN, como el significado del juicio, el núcleo fijo, también se coloca aquí ([TOULMIN](/es/grammar/edge/toulmin/#metacognición-y-autorrevisión)).

## Lista de versiones

El lugar de publicación va escribiendo, por cada documento, un documento de lista de versiones (`/<Issuer>/<ID de documento>/versions.geul`). El formato de los registros y la estructura del documento los fija [PUBLICATION](/es/grammar/edge/publication/).

```
DOC-*
  SPEC-VERSION
  PARENT          hash de contenido de la lista anterior
  RECORDED-AT     momento en que se emitió esta lista
  NEXT-LOCAL-ID   siguiente LOCAL ID por asignar
  SIGNATURE       firma del lugar de publicación
BODY
  PUBLICATION     #1  documento@1  hash de contenido
  PUBLICATION     #2  documento@2  hash de contenido
  DEPRECATION     #3  documento@1
  …
END
```

| Edge | Significado |
|---|---|
| PUBLICATION | Publica una versión del documento y su hash de contenido |
| DEPRECATION | Marca una versión publicada con una recomendación de dejar de usarla. Se sigue interpretando |
| TOMBSTONE | Elimina una versión publicada (eliminación legal o de oficio). Se anota la categoría del motivo |

- Los registros solo se añaden. No se corrigen, borran ni reordenan. Deprecar o eliminar también se hace añadiendo un registro. La nueva lista conserva delante el BODY de la lista anterior tal cual y le añade registros, y las listas se enlazan entre sí en una cadena de hashes `PARENT`.
- Significa que el registro de publicación no se corrige, y es distinto de la revisión del contenido del documento ([Documento](/es/grammar/document/#revisión)). El estado actual de una versión se calcula aplicando los registros en orden.
- Los ID de versión son ascendentes desde 1 sin huecos. El mismo contenido no se vuelve a publicar.
- La última versión es la más alta que no sea ni recomendada para abandono ni eliminada.
- Los registros no llevan hora. La hora de publicación es el `RECORDED-AT` de la primera lista en que figura ese registro.
- Los documentos de lista no llevan `DOC-ID`. El ID de documento de los registros dice de qué es la lista.
- Los documentos de lista no llevan IMPORT y solo usan Codec de la capa 0.
- Un documento de lista no se incluye en otra lista (no hay lista de listas). Las listas anteriores solo se señalan por su hash de contenido (`h/<hash de contenido>.geul`) y el historial se enlaza con la cadena `PARENT`.
- La única dirección mutable es la dirección de la última lista (`/<Issuer>/<ID de documento>/versions.geul`). Como un puntero mutable no se puede hacer con documentos, se verifica con la firma, el `RECORDED-AT` y el `PARENT` de la lista recibida.

### Sujeto de la firma

| Firma | Sujeto | Objeto |
|---|---|---|
| Firma del documento | El Issuer de ese documento | Hash de contenido del documento ([Issuer y publicación](/es/grammar/issuer/#firma)) |
| Firma de la lista | El lugar de publicación que asignó los ID de versión | Hash de contenido del documento de lista |

- En la publicación en geul.org, geul.org (el Issuer GEUL) asigna los ID de versión y firma la lista; en la publicación privada lo hace el propio Issuer.
- El autor responde del contenido y el lugar de publicación responde de la numeración y el orden.

### Verificación

- La firma se excluye del hash de contenido, así que si se borra el hash sigue igual. Por eso se verifica no con "si hay firma, se comprueba" sino con "debe haber una firma de la clave establecida". La clave que se exige la fijan la configuración de confianza del intérprete y el registro de bloqueo.
- El intérprete deja en el registro de bloqueo el hash de contenido de la última lista que vio. Si en la cadena `PARENT` de una lista recién recibida no está ese hash, la rechaza (evita retrocesos y bifurcaciones).
- Los espejos y los entornos aislados de la red copian juntos la cadena de documentos de lista. Con solo la clave pública se verifica sin conexión.
- Un documento recibido, venga de donde venga, se verifica con su hash de contenido. No hace falta confiar en la procedencia.

## Resolución de dependencias

- Un documento anota los documentos de los que depende con [IMPORT-DOC](/es/grammar/meta/import/import-doc/) en el HEAD.
- Una nueva versión no promete compatibilidad con la anterior. Por eso en todo el grafo no se unifica en una sola la versión de un documento (no se usa la selección de versión mínima).
- Cada `IMPORT-DOC` queda ligado a la edición que fijó. En un mismo grafo pueden coexistir varias ediciones de un mismo documento (una sentencia que cita la ley anterior y otra que cita la ley vigente). Las referencias se resuelven con (documento, versión, LOCAL ID).
- Una importación de la última versión (versión `0`) queda ligada a la edición más reciente en el momento de la interpretación. Si se interpreta fijando un momento, queda ligada a la edición vigente en ese momento ([Documento](/es/grammar/document/#revisión)).
- Una importación fijada por ID de versión es reproducible (el contenido de un ID de versión es inmutable y se verifica con el registro de bloqueo).

## Tipo de medio

- El tipo de medio de los documentos GEUL es `application/vnd.geul`. La extensión es `.geul`.
- Aunque se pase al árbol estándar `application/geul`, se seguirá aceptando `application/vnd.geul`.

## Problemas abiertos

- Hasta dónde sirve geul.org directamente los documentos de Issuer de 1, 2, 4 y 16 WORD y desde dónde envía a la dirección del registro. Los códigos de estado en ese caso (canónica 308, última 302·307).
- Qué hacer cuando los ID de versión divergen (mismo ID de versión, distinto contenido) en publicaciones privadas, Issuer de 16 WORD y entornos aislados de la red.
- La definición de la representación textual y la negociación de contenido (según `Accept`, binario, texto o vista HTML).
- La relación entre el índice de nombres de documentos `documents.geul` y el BIND de la lista de versiones (si unificarlos en uno), y la firma del índice.
- La composición del HEAD de `issuers.geul` y el formato de firma y cadena. Reglas de nombres para Issuer sin dominio (1 y 4 WORD), tratamiento de disputas de nombres y límite de longitud.
- Si permitir que los Issuer de 1 WORD pasen también, de forma opcional, por la prueba de dominio y usen nombres de dominio.
- Cuándo y en qué formato pasar, cuando la lista crezca, de la cadena completa a un log Merkle (pruebas de inclusión y consistencia).
- Un Meta que anote en el HEAD el Issuer que proporciona la ubicación.
