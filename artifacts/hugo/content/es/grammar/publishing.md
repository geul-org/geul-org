---
title: "Direcciones de publicación y lista de versiones"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "GEUL señala los documentos con un ID (Issuer, ID de documento, ID de versión), no con una URL en forma de cadena."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL señala los documentos con un ID (Issuer, ID de documento, ID de versión), no con una URL en forma de cadena. La dirección se determina a partir del ID. Esta página fija las reglas de publicación necesarias para que el codificador, el decodificador y el intérprete funcionen de forma coordinada. Los niveles de Issuer y los modos de publicación los fija [Issuer y publicación](issuer.md).

## Notación de ID {#id-표기}

Los ID que se usan en las direcciones se escriben en hexadecimal.

- El prefijo es `0x` en minúsculas. El hexadecimal se escribe con A-F en mayúsculas. El intérprete también busca una dirección escrita en minúsculas convirtiéndola a mayúsculas.
- El número de dígitos es fijo: ancho × 4. No se omiten los ceros iniciales, y el número de dígitos es el ancho.
- Al escribir una dirección, el Issuer se escribe con el número de dígitos de su ancho de emisión: 8 dígitos para 2 WORD, 16 para 4 WORD y 64 para 16 WORD.
- Al leer, el Issuer se acepta con 8, 16 o 64 dígitos. La notación larga que antepone ceros a un Issuer ID corto se busca como el mismo Issuer (`0x00000001` y `0x0000000000000001` son el mismo Issuer, [Issuer y publicación](issuer.md#issuer-등급)).

| Objeto | Ancho | Dígitos | Ejemplo |
|---|---|---|---|
| Issuer | 2 WORD | 8 | `0x00000001` |
| Issuer | 4 WORD | 16 | `0x0000000100000000` |
| Issuer | 16 WORD | 64 | `0x` + 64 dígitos |
| Codec ID | 2 WORD | 8 | `0x00000AA0` |
| ID de documento | 4 WORD | 16 | `0x0000000000000000` |
| ID de versión | 2 WORD | 8 | `0x00000003` |
| Hash de contenido | 16 WORD | 64 | `0x` + 64 dígitos |

- El Codec ID de un código directo de GEUL es el valor de 32 bits que resulta de escribir su TAG WORD (L=0) (TRIPLE `0x0AAL` → `0x00000AA0`). No se solapa porque el Kind está en el TAG.
- Un Codec de formato ISSUER de otro Issuer se pone bajo el `codecs/` de ese Issuer, con el número de Codec del registro. Por ejemplo, IETF CRC32C es `0x00000007/codecs/0x0000C000/`.
- El Codec ID de un Codec de Issuer es el número de Codec del registro (2 WORD). El Issuer asigna los números de Codec de modo que no se solapen dentro de su `<Issuer>/codecs/`, independientemente del Kind (Reference, Value, Edge). La dirección no se divide por Kind (no hay carpetas como `references/`, `values/` o `edges/`).
- El intérprete considera error que el Kind del registro difiera del Kind del destino de [DECLARE](edge/0x0BBL-declare.md) del documento de Codec.
- La publicación rechaza subir otro Codec con el mismo Codec ID.
- Las reglas del ID de versión (desde 1, `0` es la última, asignación por el publicador, nuevo ID de documento al agotarse) las fija [documento](document.md#버전).

## Direcciones de publicación {#공표-주소}

```
/.well-known/geul/issuers/latest.geul                              Lista de Issuer, última
/.well-known/geul/issuers/<ID de versión>.geul                     Lista de Issuer, versión indicada
/.well-known/geul/issuers/versions.geul                            Lista de versiones de la lista de Issuer
/.well-known/geul/<Issuer>/codecs/<Codec ID>/latest.geul           Codec, último
/.well-known/geul/<Issuer>/codecs/<Codec ID>/<ID de versión>.geul  Codec, versión indicada
/.well-known/geul/<Issuer>/codecs/<Codec ID>/versions.geul         Lista de versiones del Codec
/.well-known/geul/<Issuer>/docs/<ID de documento>/latest.geul      Documento, último
/.well-known/geul/<Issuer>/docs/<ID de documento>/<ID de versión>.geul  Documento, versión indicada
/.well-known/geul/<Issuer>/docs/<ID de documento>/versions.geul    Lista de versiones del documento
/.well-known/geul/<Issuer>/hashes/<hash de contenido>.geul         Consulta por hash de contenido
```

Ejemplo: `/.well-known/geul/0x00000002/docs/0x0000000000000000/latest.geul`

- La ruta sigue `.well-known` de RFC 8615. geul.org y la publicación privada usan la misma ruta y solo cambia el dominio. El único sufijo que hay que registrar es `geul`.
- La lista de Issuer es `issuers/`. Los Codecs, los documentos generales y los hashes se separan bajo la carpeta del Issuer en `codecs/<Codec ID>/`, `docs/<ID de documento>/` y `hashes/`. La lista de Issuer también empieza en la versión 1 y tiene `versions.geul` ([documentos de lista](#목록-문서)).
- `latest.geul` es una palabra reservada y un alias. No se almacena. Busca la versión más reciente en el `versions.geul` de la misma posición y devuelve tal cual los bytes de esa versión. No redirige. Todos los `latest.geul` de la lista de Issuer, de los Codecs y de los documentos son iguales.
- La dirección canónica de una versión es `/<Issuer>/docs/<ID de documento>/<ID de versión>.geul`. Para un Codec es `/<Issuer>/codecs/<Codec ID>/<ID de versión>.geul`. Otra dirección que dé el mismo contenido señala la dirección canónica con `Link: rel=canonical`.
- La dirección con versión indicada y la dirección por hash de contenido son inmutables. Las direcciones inmutables pueden ir en caché permanente y en CDN. Quien las recibe las verifica con el hash de contenido de la lista de versiones (o del registro de bloqueo).
- Para buscar por hash de contenido hay que conocer el Issuer. No existe una consulta global solo por hash.
- Un documento de Codec no tiene ID de documento. Se señala a sí mismo y su versión con un [CODEC-POINTER](reference/0x042L-codec-pointer.md) (Issuer, Codec ID, ID de versión).
- Los ID siempre empiezan por `0x`. Por eso los nombres reservados (`issuers`, `codecs`, `docs`, `hashes`, `latest.geul`, `versions.geul`) o los nombres puestos por personas no se solapan con un ID, aunque sean palabras solo en hexadecimal como `add` o `cafe`.
- La ubicación (desde qué servidor se recibe) no se incluye en el contenido del documento. Si se incluyera, el hash de contenido cambiaría al cambiar la dirección. La ubicación la determina la configuración de quien recibe el documento.

### Forma de publicación y consulta {#공표-형태와-조회}

- La dirección es una dirección lógica. El publicador puede emitir archivos individuales o packs; si es un pack, no puede recibirse directamente con la URL de la dirección y se lee con un intérprete GEUL.
- Se encuentra con la misma dirección tanto si se almacena como archivo individual, como pack o como pack zstd. Una dirección fuera de los 10 formatos anteriores o una dirección que no existe es 404 (no existe).

Herramienta de línea de comandos `geul` ([gogeul](https://github.com/geul-org/gogeul)):

```
geul get <dirección>     emite en la salida estándar el binario puro del documento GEUL
geul show <dirección>    muestra el documento como texto
```

- `geul get` acepta direcciones `file://` y `https://`. Una dirección fuera de los 10 formatos o que no existe termina con 404 (no existe).

El `pkg/resolve` de la biblioteca Go gogeul tiene una función de consulta por cada dirección. Todas devuelven binario GEUL puro (`[]byte`). Como el ID de versión empieza en 1, `Latest` (0) es la última. Una dirección que no existe da el error de no existencia (`ErrNotFound`).

```go
const Latest uint32 = 0

Issuers(ctx, v)               / IssuersVersions(ctx)
Codec(ctx, issuer, codec, v)  / CodecVersions(ctx, issuer, codec)
Doc(ctx, issuer, doc, v)      / DocVersions(ctx, issuer, doc)
Hash(ctx, issuer, hash)

ParseAddr(s string) (Addr, error)   // formatos distintos de los 10: 404 (no existe)
Fetch(ctx, Addr) ([]byte, error)    // geul get = ParseAddr → Fetch → salida estándar
```

### Designación de formato {#형식-지정}

- La dirección de publicación termina en `.geul` y es binaria (`application/vnd.geul`).
- La forma canónica del documento es el binario. El hash de contenido y la firma se calculan solo sobre el binario.

### Documentos de lista {#목록-문서}

El documento de lista es solo la lista de Issuer `issuers/`. Vincula Issuer y dominio ([lista de Issuer](#issuer-목록)). Empieza en la versión 1 y tiene `versions.geul`. El ID de documento de la lista es el ID de documento reservado `0xFFFFFFFFFFFFFFFF` (Issuer geul.org `0x00000000`). Todo Issuer reserva los ID de documento `0x0000000000000000` y `0xFFFFFFFFFFFFFFFF` ([Issuer y publicación](issuer.md#용어-정의-문서)).

- `latest.geul` es un alias que no se almacena. Busca la versión más reciente en `versions.geul` y emite sus bytes.
- PUBLICATION, DEPRECATION y TOMBSTONE de `issuers/versions.geul` señalan las versiones de la lista con un DOC-POINTER (`0x00000000`, `0xFFFFFFFFFFFFFFFF`, ID de versión). Por eso, aunque se reciba por `hashes/`, se sabe de qué es la lista ([PUBLICATION](edge/0x0B8L-publication.md#목록-문서의-버전-목록)).
- El ID de documento `0xFFFFFFFFFFFFFFFF` no se recibe en ningún Issuer con la dirección `<Issuer>/docs/<ID de documento>/` (404). El otro ID de documento reservado, `0x0000000000000000`, es el documento índice de definición de términos de ese Issuer y se pone bajo `docs/` ([Issuer y publicación](issuer.md#용어-정의-문서)).
- Los documentos de lista no llevan `DOC-ID`. De qué es la lista lo dice el DOC-POINTER del registro ([DOC-ID](meta/0x1C7L-doc-id.md)).
- Los documentos y los Codecs se encuentran directamente con el ID calculado a partir del registro, sin lista ([nombre de documento](#문서-이름)).

### Nombre de dominio {#도메인-이름}

Un nombre de dominio no es una dirección URL de publicación. Una dirección que ponga un dominio en la posición de `<Issuer>` o un nombre en la posición de un ID queda fuera de los 10 formatos anteriores y es 404 (no existe). Tampoco hay redirección de un nombre a una dirección por ID.

- El nombre de dominio es una entrada del intérprete y de la CLI. El intérprete convierte el dominio en Issuer ID mediante el BIND de la lista de Issuer `issuers/`. El ID convertido se deja en el registro de bloqueo. No existe una dirección por nombre de documento ([nombre de documento](#문서-이름)).
- La dirección canónica, la clave de caché y el objeto de la firma son la dirección por ID.
- El dominio se escribe en minúsculas, y el dominio internacionalizado, en forma IDNA (punycode). No se añade el `.` final.
- Los Issuer de 16 WORD, que no tienen registro, y los entornos aislados de red que no llegan a geul.org no pueden usar nombres de dominio. Usan el ID.

### Lista de Issuer {#issuer-목록}

La lista de Issuer es un documento bajo `/.well-known/geul/issuers/` (la última es `issuers/latest.geul`). Vincula el Issuer y su nombre (dominio).

```
BODY
  BIND   Subject = ISSUER-POINTER(Issuer)   nombre = "geul.org"
  …
```

- El Subject es un [ISSUER-POINTER](reference/0x040L-issuer-pointer.md) (el propio Issuer) y el nombre se vincula con [BIND](edge/0x0A3L-bind.md).
- El nombre es un dominio que ha pasado la prueba de propiedad del dominio. Va en minúsculas y el dominio internacionalizado se escribe en IDNA (punycode). Un nombre se vincula a un solo Issuer.
- El nombre visible para personas del Issuer (por idioma) se añade al mismo Subject con un [LABEL](edge/0x0A4L-label.md) de enunciado.
- Lo firma geul.org (Issuer GEUL); si cambia, se añade y no se corrige (la misma regla de cadena que la lista de versiones).

### Nombre de documento {#문서-이름}

**No existe una dirección por nombre de documento.** Los documentos y los Codecs se encuentran por ID.

- No se mantiene un índice que convierta nombres de documento o de Codec en ID. En la lista de versiones tampoco se pone un [BIND](edge/0x0A3L-bind.md) de nombre de documento ([PUBLICATION](edge/0x0B8L-publication.md#버전-목록-문서)).
- El índice para que las personas exploren lo genera la herramienta (visor) a partir del inventario de packs.
- La dirección canónica, la clave de caché y el objeto de la firma son la dirección por ID. IMPORT y las citas dentro del documento se hacen solo por ID.
- El título visible para personas (por idioma) se añade con un [LABEL](edge/0x0A4L-label.md) de enunciado.

### Documentos eliminados {#삭제된-문서}

- La dirección de una versión dada de baja por supresión legal o de oficio (TOMBSTONE) también es 404 (no existe), como cualquier otra dirección inexistente.
- Una versión con recomendación de baja de uso (DEPRECATION) no es 404. Se sigue sirviendo con la dirección de esa versión.
- La supresión queda en la lista de versiones con un registro [TOMBSTONE](edge/0x0BAL-tombstone.md) (el DOC-POINTER de esa versión y la categoría del motivo).

## Capas {#층}

GEUL expresa como documentos GEUL hasta la procedencia, los Meta y las listas. Lo mínimo necesario para leerlos se integra en el decodificador para romper la circularidad. Cada capa solo depende de las capas inferiores.

| Capa | Contenido | De qué depende |
|---|---|---|
| Capa 0 | Reglas integradas en el decodificador: framing, hash de contenido, verificación de firma, Codecs de registros de la lista de versiones (`PUBLICATION`·`DEPRECATION`·`TOMBSTONE`), vocabulario de especificación de Codec (`DECLARE`·`FIELD`·`ENUM`·`CODEC`), [marcadores de posición](slot-marker.md) (`0x0000`, `0x0010`, `0x0020`), claves de confianza recibidas fuera del documento | De nada. No se consulta |
| Capa 1 | Documentos de la lista de versiones | Capa 0 |
| Capa 2 | Documentos generales, codebooks, documentos de especificación de Codec, documentos de claves de verificación de Issuer | Se encuentran con la capa 1 y se verifican con la capa 0 |

- Ninguna capa depende de sí misma ni de una capa superior.
- Se distingue entre lo que se expresa en GEUL y lo que solo se lee si se interpreta con GEUL. La capa 0 puede expresarse en GEUL, pero su interpretación no requiere consulta.
- El núcleo fijo que no puede convertirse en documento TOULMIN, como el significado del veredicto, también se coloca aquí ([TOULMIN](toulmin/_index.md#메타-인지와-자기-개정)).

## Lista de versiones {#버전-목록}

El publicador mantiene por cada documento un documento de lista de versiones que va ampliando (`/<Issuer>/docs/<ID de documento>/versions.geul`, para un Codec `/<Issuer>/codecs/<Codec ID>/versions.geul`, para la lista de Issuer `issuers/versions.geul`). El formato de los registros y la estructura del documento los fija [PUBLICATION](edge/0x0B8L-publication.md).

```
DOC-*
  SPEC-VERSION
  PARENT          hash de contenido de la lista de versiones anterior
  RECORDED-AT     instante en que se emitió esta lista
  NEXT-LOCAL-ID   siguiente LOCAL ID que se asignará
  SIGNATURE       firma del publicador
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
| DEPRECATION | Marca en una versión publicada una recomendación de baja de uso. Se sigue interpretando |
| TOMBSTONE | Elimina una versión publicada (supresión legal o de oficio). Se anota la categoría del motivo |

- Los registros solo se añaden. No se corrigen, no se borran ni se reordenan. Deprecar o eliminar también se hace añadiendo un registro. La lista nueva conserva tal cual el BODY de la lista anterior al principio y le añade registros, y las listas se enlazan entre sí con la cadena de hashes `PARENT`.
- Significa que el registro de publicación no se corrige, y es distinto de la revisión del contenido del documento ([documento](document.md#개정)). El estado actual de una versión se calcula aplicando los registros en orden.
- El ID de versión es ascendente desde 1 sin saltos. El mismo contenido no se vuelve a publicar.
- La última versión es la versión más alta que no tiene recomendación de baja ni eliminación.
- En los registros no se pone el instante. El `RECORDED-AT` de la primera lista en que figuró ese registro es el instante de publicación.
- La lista de versiones no lleva `DOC-ID`. El DOC-POINTER del registro (ID de documento; en la lista de Issuer, el ID de documento reservado) dice de qué es la lista.
- La lista de versiones no tiene IMPORT y solo usa Codecs de la capa 0. En el BODY solo hay PUBLICATION, DEPRECATION y TOMBSTONE.
- Las listas de versiones pasadas se señalan solo por hash de contenido (`<Issuer>/hashes/<hash de contenido>.geul`), y el historial se enlaza con la cadena `PARENT`.
- Las direcciones mutables son `latest.geul` y `versions.geul`. Como un puntero mutable no puede convertirse en documento, se verifica con la firma, el `RECORDED-AT` y el `PARENT` de la lista recibida.

### Sujeto de la firma {#서명-주체}

| Firma | Sujeto | Objeto |
|---|---|---|
| Firma del documento | El Issuer de ese documento | Hash de contenido del documento ([Issuer y publicación](issuer.md#서명)) |
| Firma de la lista | El publicador que asignó los ID de versión | Hash de contenido de la lista de versiones |

- En la publicación de geul.org, geul.org (Issuer GEUL) asigna los ID de versión y firma la lista; en la publicación privada lo hace ese Issuer.
- El autor responde del contenido y el publicador, de la numeración y el orden.

### Verificación {#검증}

- La firma se excluye del hash de contenido, por lo que borrarla deja el hash igual. Por eso se verifica no con «si hay firma, se comprueba», sino con «debe haber firma de la clave determinada». La clave que se exige la fijan la configuración de confianza del intérprete y el registro de bloqueo.
- El intérprete deja en el registro de bloqueo el hash de contenido de la última lista vista. Si ese hash no está en la cadena `PARENT` de una lista recién recibida, la rechaza (prevención de retroceso y bifurcación).
- Los espejos y los entornos aislados de red copian también la cadena de listas de versiones. Con solo la clave pública se verifica sin conexión.
- Un documento recibido, venga de la fuente que venga, se verifica con el hash de contenido. No hace falta confiar en la fuente.

## Resolución de dependencias {#의존성-해석}

- Un documento anota los documentos de los que depende con [IMPORT-DOC](meta/0x1E4L-import-doc.md) en el HEAD.
- Una versión nueva no promete compatibilidad con la versión anterior. Por eso no se unifica en una sola la versión de un documento en todo el grafo (no se usa la selección de versión mínima).
- Cada `IMPORT-DOC` queda ligado a la edición que fijó. Pueden coexistir en un grafo varias ediciones del mismo documento (una sentencia que cita la ley antigua y otra que cita la ley vigente). La referencia se resuelve con (documento, versión, LOCAL ID).
- Una importación de la última (versión `0`) queda ligada a la edición más reciente en el momento de la interpretación. Si se interpreta fijando un instante, queda ligada a la edición en vigor en ese instante ([documento](document.md#개정)).
- Una importación fijada con ID de versión es reproducible (el contenido de un ID de versión es inmutable y se verifica con el registro de bloqueo).

## Tipo de medios {#미디어-타입}

- El tipo de medios de un documento GEUL es `application/vnd.geul`. La extensión es `.geul`.
- Aunque se pase al árbol estándar `application/geul`, se sigue aceptando `application/vnd.geul`.

## Problemas abiertos {#열린-문제}

- El tratamiento de la divergencia de ID de versión (mismo ID de versión, distinto contenido) en la publicación privada, los Issuer de 16 WORD y los entornos aislados de red.
- La composición del HEAD de la lista de Issuer `issuers/` y el formato de firma y cadena. La regla de nombres de los Issuer sin dominio (4 WORD), el tratamiento de disputas de nombres y el límite de longitud.
- El momento y el formato para pasar, cuando la lista crece, de la cadena completa a un log de Merkle (pruebas de inclusión y consistencia).
- El Meta que anota en el HEAD el Issuer que proporciona la ubicación.
