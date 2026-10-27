---
title: "Issuer y publicación"
weight: 80
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "El Issuer es la entidad que define documentos y formatos. La forma de emisión depende del ancho (1, 2, 4 o 16 WORD). Esta página fija los grados de Issuer y la tabla de asignación de 1 WORD, el modo de divulgación de los documentos, y la firma y la divulgación de claves de verificación."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL no concentra el sistema de identificación en un solo lugar. Cada Issuer define sus objetos y formatos, y los demás documentos usan las definiciones publicadas. Las definiciones se mantienen confidenciales o se publican en geul.org (CC0) o en una publicación privada (con la licencia que fije el Issuer). Qué definiciones se usan lo decide el usuario.

La dirección de publicación, la designación de formato, el índice de nombres, la lista de versiones y las capas de confianza las fija [Direcciones de publicación y lista de versiones](/es/grammar/publishing/).

## Lo que define un Issuer

| Objeto | Método |
|---|---|
| Objetos (entidades, conceptos, términos) | Se declaran como LOCAL en sus propios documentos |
| Formato de Value | Se define con un número de formato bajo el código del Issuer |
| Formato de Edge | Se define con un número de formato bajo el código del Issuer |

- La definición de los formatos de Value y Edge también se publica como documento.

## Principios

- Todos los ID tienen alcance de documento. Los LOCAL ID (incluidos Edge Id y variables) y los IMPORT ID solo son válidos dentro de ese documento.
- Un objeto definido por un Issuer es un LOCAL de un documento publicado por ese Issuer. Los demás documentos lo citan directamente con una declaración de señalamiento (`EXTERNAL-ISSUER-*`), o lo traen con `IMPORT-DOC` y lo señalan con `EXTERNAL-POINTER-*`.
- Para un objeto al que se deba apuntar desde fuera del documento se emite un LOCAL de un documento publicado. Ese documento debe tener [DOC-ID](/es/grammar/meta/declaration/doc-id/).

## Grados de Issuer

| Ancho | Rango de valores | Emisión |
|---|---|---|
| 1 WORD | `0x0000`~`0xFFFF` | geul.org lo asigna a organismos de normalización y a instituciones principales ([tabla de asignación de 1 WORD](#tabla-de-asignación-de-1-word)) |
| 2 WORD | `0x00010000`~`0xFFFFFFFF` | Registro en geul.org. Pasa por la prueba de propiedad de dominio |
| 4 WORD | `2^32`~`2^64−1` | Registro en geul.org. Sin prueba de propiedad |
| 16 WORD | `2^64` o más | Autoemisión. Se calcula a partir de la clave pública |

- **El ID de Issuer es un valor entero.** Si el valor es el mismo, es el mismo Issuer (`0x0001` y `0x00000001` son el mismo valor). El ancho no forma parte del identificador.
- **La forma canónica es el ancho más corto.** Se escribe con el ancho más corto en que quepa el valor y se rechaza la notación con un ancho mayor. Por eso, la asignación de cada ancho empieza en el valor siguiente al final del rango del ancho inmediatamente inferior (2 WORD empieza en `0x00010000`).

## Tabla de asignación de 1 WORD

geul.org asigna los Issuer de 1 WORD a organismos de normalización y a instituciones principales. Los formatos propios diseñados por GEUL se colocan bajo `GEUL`, y los estándares de facto o formatos de uso común sin organismo promulgador, bajo `ADHOC`.

| Issuer | Nombre | Organización | Formatos representativos |
|---|---|---|---|
| `0x0000` | GEUL | geul.org | Formatos propios de GEUL, libro de códigos |
| `0x0001` | ADHOC | geul.org | Formatos de uso común sin organismo promulgador. BFLOAT16, BLAKE3, complejos·fracciones·intervalos·cuaterniones, vectores·tensores |
| `0x0002`~`0x000F` | Reservado | | |
| `0x0010` | ISO | International Organization for Standardization | ISO 8601, ISO 4217 (monedas), ISO 3166 (países) |
| `0x0011` | IEC | International Electrotechnical Commission | IEC 80000 (notación de unidades) |
| `0x0012` | ISO-IEC-JTC1 | ISO/IEC Joint Technical Committee 1 | Estándares de tecnología de la información ISO/IEC |
| `0x0013` | ITU-T | ITU Telecommunication Standardization Sector | X.509, X.690 (codificación ASN.1) |
| `0x0014`~`0x001F` | Reservado | Organismos de normalización internacionales | |
| `0x0020` | IETF | Internet Engineering Task Force | URI (RFC 3986), UUID (RFC 9562), CRC32C, IPv4·IPv6 |
| `0x0021` | IANA | Internet Assigned Numbers Authority | Tipos de medio, registro de subetiquetas de idioma |
| `0x0022` | W3C | World Wide Web Consortium | Tipos de datos de XML Schema, RDF |
| `0x0023` | WHATWG | Web Hypertext Application Technology Working Group | URL, HTML |
| `0x0024` | UNICODE | Unicode Consortium | Codificación de caracteres, normalización, CLDR |
| `0x0025` | ECMA | Ecma International | JSON (ECMA-404) |
| `0x0026`~`0x003F` | Reservado | Organismos de normalización de internet y la web | |
| `0x0040` | IEEE | Institute of Electrical and Electronics Engineers | Punto flotante y decimal IEEE 754, direcciones MAC (802) |
| `0x0041` | KHRONOS | Khronos Group | Formatos de píxel (RGBA8·BGRA8 UNORM), glTF |
| `0x0042` | OGC | Open Geospatial Consortium | Coordenadas·cajas delimitadoras, familia GeoJSON |
| `0x0043` | ONNX | ONNX (LF AI & Data Foundation) | FP8 E4M3FN·E4M3FNUZ·E5M2·E5M2FNUZ |
| `0x0044` | OCP | Open Compute Project | Formatos Microscaling (E8M0, FP4 E2M1) |
| `0x0045` | OASIS | OASIS Open | Estándares de documentos y de seguridad |
| `0x0046`~`0x005F` | Reservado | Organismos de normalización industriales | |
| `0x0060` | BIPM | Bureau International des Poids et Mesures | Unidades SI, TAI |
| `0x0061` | IERS | International Earth Rotation and Reference Systems Service | Segundo intercalar, UTC−TAI |
| `0x0062` | NIST | National Institute of Standards and Technology | SHA-2 (FIPS 180-4), SHA-3 (FIPS 202) |
| `0x0063` | GPS | Entidad que opera el GPS para el gobierno | Tiempo GPS |
| `0x0064`~`0x00FF` | Reservado | Metrología y organismos gubernamentales | |
| `0x0100` | KATS | Agencia Coreana de Tecnología y Normas | Estándares KS |
| `0x0101`~`0x01FF` | Reservado | Organismos nacionales de normalización | |
| `0x0200`~`0xFFFF` | Reservado | Asignación posterior | |

- Los formatos de extensión se colocan bajo el Issuer del organismo que promulgó el formato. Los números de formato bajo un Issuer los define cada Issuer.
- Los bits superiores del número de formato deben seguir la regla de familia del Kind correspondiente. Así la familia se conoce sin libro de códigos.
- Si un organismo de normalización no gestiona directamente los números de formato de GEUL, geul.org registra con un número el estándar de ese organismo en su nombre. El número se anota junto con el identificador del documento del estándar.
- La asignación se hace desde los números bajos dentro del rango de cada tipo de organización. Los rangos son una comodidad de clasificación y el decodificador no tiene obligación de interpretarlos.

## Issuer de 16 WORD

```
Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ ID del algoritmo de firma (2 bytes) ‖ clave pública)
```

- Los 32 bytes del resultado se escriben en 16 WORD empezando por el byte superior.
- Cualquiera puede crearlo sin registro. La propiedad se demuestra con la firma de la clave privada.
- La clave pública y el algoritmo se declaran con [ISSUER-KEY](/es/grammar/meta/verification/issuer-key/) en el HEAD del documento. El algoritmo de firma `0x0001` es Ed25519 y los demás valores están reservados.
- El prefijo `GEUL-ISSUER-v1` evita que salga el mismo ID cuando la misma clave se usa para otro fin (separación de usos).
- Aunque cambie el algoritmo de firma (ejemplo: Ed25519 → ML-DSA), el ancho del ID sigue siendo de 16 WORD.
- Si el resultado es menor que `2^64` (la probabilidad es prácticamente cero), no se crea un Issuer con esa clave, porque chocaría con la regla del ancho más corto.

## Prueba de dominio

- La prueba de propiedad de dominio de un Issuer de 2 WORD se comprueba solo en el momento del registro. Después, la gestión del dominio es responsabilidad del Issuer.
- Un dominio corresponde a un único Issuer. Un Issuer puede tener varios dominios. La correspondencia se anota con BIND en el índice de nombres de Issuer `issuers.geul` ([Direcciones de publicación y lista de versiones](/es/grammar/publishing/#nombre-del-issuer)).
- Aunque el dominio caduque o pase a otras manos, la correspondencia permanece con el Issuer que lo demostró primero. El nuevo propietario no puede usar ese dominio como nombre de Issuer.
- El nombre de dominio sirve para introducir y mostrar direcciones. Dentro de un documento GEUL solo se escribe el ID de Issuer.

## Documentos de definición de términos

- Los términos que define un Issuer (herramientas, programas, roles, conceptos dentro de una organización) se colocan en **un documento por término**. El término es el LOCAL de ese documento; su nombre se vincula con [BIND](/es/grammar/edge/bind/) y el objeto externo al que apunta (URI, etc.) se enlaza con [REFERENCE-NODE](/es/grammar/edge/reference-node/).
- Los demás documentos señalan el término con `EXTERNAL-ISSUER-*` (Issuer, ID de documento, LOCAL ID). La misma definición no se repite en cada documento. Ejemplo: la herramienta de [TRANSFORMED-BY](/es/grammar/meta/lineage/transformed-by/).
- El tramo de ID de documento de los documentos de definición de términos lo fija el Issuer. geul.org (`0x0000`) usa `0x0001xxxx xxxxxxxx` ([Documento de especificación de Codec](/es/grammar/codec-spec/#id-de-documento-del-issuer-geul)).
- El ID de documento `0x0000000000000000` de cada Issuer se reserva para el **documento índice de definición de términos** de ese Issuer: `<Issuer>/0x0000000000000000/`. Es el lugar donde se enumeran los documentos de definición de términos.
- El documento índice se **recomienda** a todos los Issuer. No es obligatorio. Si no hay índice, los documentos de definición de términos se encuentran con el índice de nombres `documents.geul`.
- Orden para apuntar a un objeto externo: (1) si hay un Codec de Reference adecuado, ese (WIKIDATA-QID, etc.); (2) si hay un documento GEUL que defina ese objeto, ese (DOC-POINTER·EXTERNAL-ISSUER); (3) si no, se define como LOCAL en el propio documento de definición de términos y se apunta a él.

## Modo de divulgación de documentos

| Modo | Destinatarios | Licencia | Control de versiones | Pervivencia |
|---|---|---|---|---|
| Confidencial | Todos los Issuer | Interna del Issuer | Issuer | Depende del Issuer |
| Publicación en geul.org | Issuer de 1·2 WORD | CC0 | geul.org | geul.org lo conserva |
| Publicación privada | Todos los Issuer | La fija el Issuer | Issuer | Depende del Issuer |

### Publicación en geul.org

- Los Issuer de 1·2 WORD pueden registrar y publicar documentos en geul.org. Los documentos registrados son CC0.
  - Los Issuer de 1 WORD publican tras una revisión previa de geul.org.
  - Los Issuer de 2 WORD publican en cuanto se registran, y los problemas se tratan a posteriori.
- Las definiciones que se pueden publicar son conceptos y códecs. **Un Reference que apunte a una persona física no se puede publicar en geul.org.** Se hace de forma confidencial o con publicación privada.
  - Excepción: se permite apuntar a una persona física con [WIKIDATA-QID](/es/grammar/reference/wikidata-qid/).
- Las versiones registradas no se modifican ni se borran, y aunque desaparezca el Issuer el documento permanece (conservación de la ley anterior). Las excepciones son la eliminación legal y la eliminación de oficio ([TOMBSTONE](/es/grammar/edge/publication/)).
- Un Issuer solo puede marcar una definición con una recomendación de dejar de usarla (deprecated). Las definiciones con esa recomendación se siguen interpretando.
- La nueva versión de un mismo documento puede crear, revisar o eliminar definiciones ([Documento](/es/grammar/document/#revisión)). **Los ID de entidad y los números de formato eliminados no se reutilizan para otros objetos.** El layout wire de un número de formato no se revisa.

### Publicación privada

- Un Issuer que quiera publicar con una licencia distinta de CC0 sirve los documentos en una red privada (dominio propio, etc.). La licencia se declara con [LICENSE](/es/grammar/meta/policy/license/) en el HEAD del documento.
- La publicación privada usa las mismas rutas que geul.org ([Direcciones de publicación y lista de versiones](/es/grammar/publishing/)).
- El control de versiones, la disponibilidad, el mantenimiento del dominio y las condiciones de licencia los fija el Issuer. geul.org no interviene ni garantiza las publicaciones privadas.

### Confidencial

- Los documentos confidenciales no se publican. Se les aplica control de acceso y se marcan con [ACCESS](/es/grammar/meta/policy/access/).
- Si se envía al exterior un documento que usa definiciones confidenciales, quien lo recibe no puede interpretar esos Reference, Value y Edge y los salta. Las definiciones que se intercambien con el exterior se publican.

### Elección del usuario

- El usuario elige los documentos que usa viendo la licencia declarada y la viabilidad de pervivencia del Issuer.
- No se usarán las definiciones con licencias excesivamente restrictivas o de Issuer cuya pervivencia es incierta.
- Para referencias que deban conservarse mucho tiempo se usan documentos publicados en geul.org.

## Firma

- La firma es obligatoria en los documentos publicados. Se coloca en el HEAD con [SIGNATURE](/es/grammar/meta/verification/signature/). Un documento sin firma también es un documento GEUL válido, y los documentos confidenciales e internos también se firman si es posible.
- Lo que se firma es el **hash de contenido** del documento ([Documento](/es/grammar/document/#hash-de-contenido)). No se firma solo el BODY.
  - El HEAD tiene reglas de interpretación. Si se cambia el destino de `IMPORT-DOC`, el mismo BODY apunta a otro destino.
  - Si no se firman `LICENSE` y `PARENT`, se pueden falsificar la licencia y el historial.
- Un documento puede llevar varias firmas. Todas firman el mismo hash de contenido, por lo que añadir firmas no cambia el hash de contenido.
- Comprobación de la clave de firma:
  - Issuer de 1·2·4 WORD: la clave registrada en geul.org (véase la divulgación de claves de verificación más abajo).
  - Issuer de 16 WORD: el `ISSUER-KEY` del mismo documento. El ID de Issuer calculado con esa clave pública debe ser igual al del firmante.
- Quien lee reduce la confianza si no hay firma, y si hay firma pero falla la verificación la reduce más, por ser evidencia de manipulación o suplantación.
- La firma del documento la hace el Issuer de ese documento, y la firma de la lista de versiones la hace el lugar de publicación que asignó los ID de versión ([Direcciones de publicación y lista de versiones](/es/grammar/publishing/#sujeto-de-la-firma)).

## Divulgación de claves de verificación

- geul.org divulga las claves de verificación de firma de los Issuer registrados (1·2·4 WORD).
- La lista de claves se emite como documento publicado del Issuer GEUL (`0x0000`). Es CC0 y la firma geul.org.
  - Campos: Issuer, ID del algoritmo de firma, clave pública, momento de inicio de validez, momento y motivo de revocación.
- Las claves revocadas tampoco se borran. Las firmas pasadas se verifican con la clave que era válida en el momento de la firma.
- El cambio de clave se registra firmando la clave nueva con la clave antigua. Quien verifica puede comprobar la continuidad de la clave sin fiarse de geul.org.
- El registro de cambios de claves se mantiene como un log de solo adición (como Certificate Transparency y Go sumdb). Si se altera el historial, se hace evidente.
- Si se pierde la clave y no se puede firmar con la antigua, geul.org vuelve a comprobar la identidad y registra la clave nueva. Los Issuer de 2 WORD pasan de nuevo por la prueba de propiedad de dominio. En este caso hay que confiar en geul.org, y el motivo se deja en el log.
- No se aplica a los Issuer de 16 WORD. Como el ID de Issuer se calcula a partir de la clave pública, se verifica solo con el `ISSUER-KEY` del documento.

## Importación

IMPORT solo trae documentos.

```
IMPORT-DOC                      DOC-POINTER (Issuer + ID de documento + ID de versión) + IMPORT ID
EXTERNAL-POINTER-1/2/4/8WORD    IMPORT ID + LOCAL ID
EXTERNAL-ISSUER-1/2/4/16WORD    Issuer + ID de documento + LOCAL ID (sin IMPORT)
ISSUER-POINTER                  Issuer (el propio Issuer)
DOC-POINTER                     Issuer + ID de documento + ID de versión (2 WORD; 0 es la última)
```

- Un Issuer de cualquier ancho y sus documentos se pueden señalar sin IMPORT con una declaración de señalamiento. El propio Issuer con `ISSUER-POINTER`, el propio documento con `DOC-POINTER` y un LOCAL del documento con `EXTERNAL-ISSUER-*`. La declaración de señalamiento sigue la última versión; para fijar la versión se usan `IMPORT-DOC` (ID de versión) y `EXTERNAL-POINTER-*`.
- Los Reference del cuerpo usan solo IMPORT ID + ID de destino en lugar de la ruta completa (Issuer + documento + ID de destino).
- El ancho del IMPORT ID lo fija la longitud en `IMPORT-DOC` y el Codec en `EXTERNAL-POINTER-*`. Solo es válido dentro de ese documento ([IMPORT-DOC](/es/grammar/meta/import/import-doc/)).
- Si se importa sin ID de versión, se sigue la última versión. Si se anota el ID de versión, queda fijado a esa versión. Los documentos publicados anotan el ID de versión.

## Licencia

- Los documentos publicados en geul.org y los del Issuer GEUL (`0x0000`) son CC0.
- La licencia de los documentos de publicación privada la fija el Issuer. GEUL no la impone.
- Los productos centrales de GEUL no copian el contenido de documentos de Issuer que no sean CC0.

## Problemas abiertos

- Si se permite la publicación en geul.org de los Issuer de 4 WORD y 16 WORD.
- El método de prueba de propiedad de dominio (DNS TXT `_geul.<dominio>`, HTTP `.well-known`) y si ligar a la prueba la huella de la clave de firma.
- La respuesta al robo de dominio en la recuperación por pérdida de clave. Si se registra una clave nueva solo con una nueva prueba del dominio, quien robó el dominio podría quedarse con el Issuer. Se estudian la comprobación del contacto de registro, un periodo de gracia con objeción de la clave antigua y la aplicación mutatis mutandis del resultado de disputas de dominio.
- El formato de registro del documento índice de definición de términos (ID de documento `0`) (Edge que enumera los documentos de definición de términos).
- El valor por defecto del algoritmo de firma (se recomienda Ed25519).
