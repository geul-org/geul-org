---
title: "Issuer y publicación"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "issuer", "publication", "signature"]
summary: "GEUL no concentra el sistema de identificación en un solo lugar."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL no concentra el sistema de identificación en un solo lugar. Cada Issuer define sus objetos y formatos, y los demás documentos toman y usan las definiciones publicadas. Las definiciones pueden usarse con carácter confidencial, o publicarse en geul.org (CC0) o mediante publicación privada (con la licencia que fije el Issuer). Qué definición creer y usar lo decide el usuario.

Las direcciones de publicación, la designación de formatos, la lista de Issuer, la lista de versiones y los niveles de confianza los determina [direcciones de publicación y lista de versiones](publishing.md).

## Lo que define un Issuer {#issuer가-정의하는-것}

| Objeto | Método |
|---|---|
| Objeto (entidad, concepto, término) | Se declara como LOCAL de su propio documento |
| Formato Reference | Se define con un número de Codec de 2 WORD bajo el código del Issuer |
| Formato Value | Se define con un número de Codec de 2 WORD bajo el código del Issuer |
| Formato Edge | Se define con un número de Codec de 2 WORD bajo el código del Issuer |

- Las definiciones de los formatos Reference, Value y Edge también se publican como documentos.

## Principios {#원칙}

- Un objeto definido por un Issuer es un LOCAL de un documento publicado por ese Issuer. Los demás documentos lo citan directamente con una declaración de designación (`EXTERNAL-ISSUER-*`), o lo importan con `IMPORT-DOC` y lo señalan con `EXTERNAL-POINTER-*`. El significado de un registro [REFERENCE-ISSUER](reference/_index.md#reference-issuer) lo determina el documento de Codec emitido por el Issuer.
- Para un objeto que debe señalarse desde fuera del documento se emite un LOCAL de un documento publicado. Ese documento debe tener un [DOC-ID](meta/0x1C7L-doc-id.md).

## Niveles de Issuer {#issuer-등급}

| Ancho | Rango de valores | Emisión |
|---|---|---|
| 2 WORD | `0x00000000`~`0xFFFFFFFF` | Registro en geul.org. Pasa por la prueba de propiedad del dominio. Los números que geul.org asigna a organismos de normalización e instituciones principales también son de este ancho ([tabla de asignación de 2 WORD](#2-word-배정표)) |
| 4 WORD | `2^32`~`2^64−1` | Registro en geul.org. Sin prueba de propiedad |
| 16 WORD | `2^64` o más | Autoemisión. Se calcula a partir de la clave pública |

- **El Issuer ID es un valor entero.** Si el valor es igual, es el mismo Issuer. El ancho no forma parte del identificador.
- **La notación larga que antepone ceros a un Issuer ID corto es el mismo Issuer** (2 → 4, 2 → 16, 4 → 16 WORD). `0x00000001` y `0x0000000000000001` son el mismo Issuer. Por eso no se asignan `0x00000000XXXXXXXX` como Issuer de 4 WORD ni valores con los 12 WORD superiores en 0 como Issuer de 16 WORD.
- **La forma canónica es el ancho más corto.** En un registro se escribe con el ancho más corto en que quepa el valor, y se rechaza la notación de un ancho mayor. Por eso la asignación de cada ancho empieza en el valor siguiente al final del rango del ancho inmediatamente inferior. 2 WORD es el ancho más corto. En una dirección de publicación se escribe con el número de dígitos del ancho de emisión (8 dígitos para 2 WORD, 16 para 4 WORD, 64 para 16 WORD) y en hexadecimal en mayúsculas (una dirección escrita en minúsculas se convierte a mayúsculas para buscarla), y al leer se acepta también la notación ensanchada como el mismo Issuer ([direcciones de publicación y lista de versiones](publishing.md#id-표기)).

## Tabla de asignación de 2 WORD {#2-word-배정표}

geul.org asigna números de Issuer de 2 WORD a organismos de normalización e instituciones principales, en orden desde el principio. Los estándares de facto o formatos de uso común sin organismo de normalización se colocan bajo `ADHOC` (`adhoc.geul.org`). Los formatos propios diseñados por GEUL son códigos directos. El Issuer de un organismo de normalización es un Issuer de subdominio de geul.org. El nombre del subdominio es el nombre de la institución en minúsculas (`<nombre de la institución>.geul.org`, por ejemplo `iso.geul.org`, `iec.geul.org`). Los dominios se indican en la tabla siguiente.

| Issuer | Nombre | Dominio | Organismo | Formatos representativos |
|---|---|---|---|---|
| `0x00000000` | GEUL | `geul.org` | geul.org | Documentos de especificación de códigos directos (codebook) |
| `0x00000001` | wikidata.geul.org | `wikidata.geul.org` | geul.org | Documentos de elementos y propiedades de Wikidata |
| `0x00000002` | ADHOC | `adhoc.geul.org` | geul.org | Formatos de uso común sin organismo de normalización. BFLOAT16, BLAKE3, números complejos, fracciones, intervalos, cuaterniones, vectores y tensores |
| `0x00000003` | ISO | `iso.geul.org` | International Organization for Standardization | ISO 8601, ISO 4217 (monedas), ISO 3166 (países) |
| `0x00000004` | IEC | `iec.geul.org` | International Electrotechnical Commission | IEC 80000 (notación de unidades) |
| `0x00000005` | ISO-IEC-JTC1 | `iso-iec-jtc1.geul.org` | ISO/IEC Joint Technical Committee 1 | Normas de tecnologías de la información ISO/IEC |
| `0x00000006` | ITU-T | `itu-t.geul.org` | ITU Telecommunication Standardization Sector | X.509, X.690 (codificación ASN.1) |
| `0x00000007` | IETF | `ietf.geul.org` | Internet Engineering Task Force | URI (RFC 3986), UUID (RFC 9562), CRC32C, IPv4·IPv6 |
| `0x00000008` | IANA | `iana.geul.org` | Internet Assigned Numbers Authority | Tipos de medios, registro de subetiquetas de idioma |
| `0x00000009` | W3C | `w3c.geul.org` | World Wide Web Consortium | Tipos de datos de XML Schema, RDF |
| `0x0000000A` | WHATWG | `whatwg.geul.org` | Web Hypertext Application Technology Working Group | URL, HTML |
| `0x0000000B` | UNICODE | `unicode.geul.org` | Unicode Consortium | Codificación de caracteres, normalización, CLDR |
| `0x0000000C` | ECMA | `ecma.geul.org` | Ecma International | JSON (ECMA-404) |
| `0x0000000D` | IEEE | `ieee.geul.org` | Institute of Electrical and Electronics Engineers | Coma flotante y decimal IEEE 754, direcciones MAC (802) |
| `0x0000000E` | KHRONOS | `khronos.geul.org` | Khronos Group | Formatos de píxel (RGBA8·BGRA8 UNORM), glTF |
| `0x0000000F` | OGC | `ogc.geul.org` | Open Geospatial Consortium | Coordenadas y cuadros delimitadores, familia GeoJSON |
| `0x00000010` | ONNX | `onnx.geul.org` | ONNX (LF AI & Data Foundation) | FP8 E4M3FN·E4M3FNUZ·E5M2·E5M2FNUZ |
| `0x00000011` | OCP | `ocp.geul.org` | Open Compute Project | Formatos Microscaling (E8M0, FP4 E2M1) |
| `0x00000012` | OASIS | `oasis.geul.org` | OASIS Open | Normas de documentos y seguridad |
| `0x00000013` | BIPM | `bipm.geul.org` | Bureau International des Poids et Mesures | Unidades SI, TAI |
| `0x00000014` | IERS | `iers.geul.org` | International Earth Rotation and Reference Systems Service | Segundos intercalares, UTC−TAI |
| `0x00000015` | NIST | `nist.geul.org` | National Institute of Standards and Technology | SHA-2 (FIPS 180-4), SHA-3 (FIPS 202) |
| `0x00000016` | GPS | `gps.geul.org` | Entidad gubernamental que opera el GPS | Hora GPS |
| `0x00000017` | KATS | `kats.geul.org` | Agencia Coreana de Tecnología y Normas (국가기술표준원) | Normas KS |

- Un formato de extensión se coloca bajo el Issuer del organismo que lo estableció. Los números de Codec bajo un Issuer los define cada Issuer.
- El número de Codec lo fija el Issuer. GEUL no determina su significado. Un número de Codec no se solapa dentro de ese Issuer, independientemente del Kind ([direcciones de publicación y lista de versiones](publishing.md#id-표기)).
- Si un organismo de normalización no gestiona directamente los números de Codec de GEUL, geul.org registra con números las normas de ese organismo en su lugar. El número se registra junto con el identificador del documento de la norma.
- Un nuevo organismo de normalización recibe el siguiente número libre.
- **El dominio puede cambiar.** El vínculo entre Issuer y dominio puede cambiar más adelante. El Issuer ID no cambia. Cuando la institución pase a gestionarlo directamente, se sustituye por el dominio oficial de esa institución.
- **Los subdominios de geul.org no son editores oficiales.** Un subdominio de geul.org que usa el nombre de un organismo de normalización no es el editor oficial de ese organismo. Por ejemplo, `iso.geul.org` no es el editor oficial de ISO.

## Issuer de 16 WORD {#16-word-issuer}

```
Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ ID del algoritmo de firma (2 bytes) ‖ clave pública)
```

- Los 32 bytes resultantes se escriben en los 16 WORD empezando por el byte más significativo.
- Cualquiera puede crearlo sin registro. La propiedad se demuestra con la firma de la clave privada.
- La clave pública y el algoritmo se declaran con [ISSUER-KEY](meta/0x1E5L-issuer-key.md) en el HEAD del documento. El algoritmo de firma `0x0001` es Ed25519, y los demás valores son Reserved.
- El prefijo `GEUL-ISSUER-v1` evita que se obtenga el mismo ID cuando la misma clave se usa con otro fin (separación de usos).
- Aunque cambie el algoritmo de firma (por ejemplo, Ed25519 → ML-DSA), el ancho del ID sigue siendo de 16 WORD.
- Si el resultado es menor que `2^64` (la probabilidad es prácticamente 0), no se crea un Issuer con esa clave, porque chocaría con la regla del ancho más corto.

## Prueba de dominio {#도메인-증명}

- La prueba de propiedad del dominio de un Issuer de 2 WORD solo se comprueba en el momento del registro. Después, la gestión del dominio es responsabilidad del Issuer.
- Un dominio corresponde a un solo Issuer. Un Issuer puede tener varios dominios. La correspondencia se escribe con BIND en la lista de Issuer `issuers/` ([direcciones de publicación y lista de versiones](publishing.md#issuer-목록)).
- Aunque el dominio caduque o cambie de manos, la correspondencia permanece con el Issuer que lo demostró primero. El nuevo propietario no puede usar ese dominio como nombre de Issuer.
- El nombre de dominio es para la entrada y visualización en el intérprete y la CLI. No es una dirección URL de publicación ([direcciones de publicación y lista de versiones](publishing.md#도메인-이름)). En un documento GEUL solo se escribe el Issuer ID.

## Documentos de definición de términos {#용어-정의-문서}

- Los términos que define un Issuer (herramientas, programas, roles, conceptos dentro de una organización) se ponen **un documento por término**. El término es un LOCAL de ese documento; su nombre se enlaza con [BIND](edge/0x0A3L-bind.md) y el objeto externo al que apunta (URI, etc.) con [REFERENCE-NODE](edge/0x0A0L-reference-node.md).
- Los demás documentos señalan el término con `EXTERNAL-ISSUER-*` (Issuer, ID de documento, LOCAL ID). La misma definición no se repite en cada documento. Por ejemplo, la herramienta de [TRANSFORMED-BY](meta/0x1D4L-transformed-by.md).
- El intervalo de ID de documento de los documentos de definición de términos lo fija el Issuer. geul.org (`0x00000000`) usa `0x0001xxxx xxxxxxxx`.
- Todo Issuer reserva los ID de documento `0x0000000000000000` y `0xFFFFFFFFFFFFFFFF`. Sus usos actuales son los dos siguientes.
- El ID de documento `0x0000000000000000` es el lugar del **documento índice de definición de términos** de ese Issuer: `<Issuer>/docs/0x0000000000000000/`. Es el lugar donde se enumeran los documentos de definición de términos.
- El ID de documento `0xFFFFFFFFFFFFFFFF` se usa en la lista de Issuer `issuers/` del Issuer geul.org (`0x00000000`). Los demás Issuer no usan este ID. Este ID no se recibe en ningún Issuer con la dirección `<Issuer>/docs/<ID de documento>/` (404) ([direcciones de publicación y lista de versiones](publishing.md#목록-문서)).
- El documento índice se **recomienda** a todos los Issuer. No es obligatorio.
- Orden para señalar un objeto externo: (1) si existe un Codec Reference adecuado, ese (WIKIDATA-QID, etc.); (2) si existe un documento GEUL que define ese objeto, ese (DOC-POINTER·EXTERNAL-ISSUER); (3) si no, se define como LOCAL en el propio documento de definición de términos y se señala.

## Modos de publicación de documentos {#문서-공개-방식}

| Modo | Destino | Licencia | Gestión de versiones | Persistencia |
|---|---|---|---|---|
| Confidencial | Todos los Issuer | Interna del Issuer | Issuer | Depende del Issuer |
| Publicación en geul.org | Issuer de 2 WORD | CC0 | geul.org | geul.org lo conserva |
| Publicación privada | Todos los Issuer | La fija el Issuer | Issuer | Depende del Issuer |

### Publicación en geul.org {#geulorg-공표}

- Un Issuer de 2 WORD puede publicar documentos registrándolos en geul.org. Los documentos registrados son CC0. Al registrarse se publican de inmediato, y los problemas se tratan a posteriori.
- Las definiciones que se pueden publicar son conceptos y Codecs. **Un Reference que señale a una persona física no puede publicarse en geul.org.** Se hace de forma confidencial o mediante publicación privada.
  - Excepción: se permite señalar a una persona física con [WIKIDATA-QID](reference/0x014L-wikidata-qid.md).
- Una versión registrada no se modifica ni se borra, y aunque el Issuer desaparezca, el documento permanece (conservación de la ley antigua). Las excepciones son la supresión legal y la de oficio ([TOMBSTONE](edge/0x0BAL-tombstone.md)).
- El Issuer solo puede marcar en una definición una recomendación de baja de uso (deprecated). Las definiciones recomendadas para baja se siguen interpretando.
- Una versión nueva del mismo documento puede crear, revisar o eliminar definiciones ([documento](document.md#개정)). **Un ID de entidad o un número de Codec eliminado no se reutiliza para otro objeto.** El layout wire de un número de Codec no se revisa.

### Publicación privada {#사설-공표}

- Un Issuer que quiera publicar con una licencia distinta de CC0 sirve los documentos en una red privada (dominio propio, etc.). La licencia se declara con [LICENSE](meta/0x1DEL-license.md) en el HEAD del documento.
- La publicación privada también usa las mismas rutas que geul.org ([direcciones de publicación y lista de versiones](publishing.md)).
- La gestión de versiones, la disponibilidad, el mantenimiento del dominio y las condiciones de licencia las fija el Issuer. geul.org no interviene en la publicación privada ni la garantiza.

### Confidencial {#대외비}

- Un documento confidencial no se publica. Se le aplica control de acceso y se marca con [ACCESS](meta/0x1DFL-access.md).
- Si se envía al exterior un documento que usa definiciones confidenciales, quien lo recibe no puede interpretar esos Reference, Value y Edge y los salta. Las definiciones que se intercambien con el exterior se publican.

### Elección del usuario {#사용자의-선택}

- El usuario elige los documentos que usa según la licencia declarada y la viabilidad de persistencia del Issuer.
- No se usan las definiciones de licencias excesivamente restrictivas ni de Issuer cuya persistencia es dudosa.
- Para referencias que deban conservarse mucho tiempo se usan documentos publicados en geul.org.

## Firma {#서명}

- La firma es obligatoria en los documentos publicados. Se pone en el HEAD como [SIGNATURE](meta/0x1E6L-signature.md). Un documento sin firma también es un documento GEUL válido, y los documentos confidenciales o internos también se firman si es posible.
- Lo que se firma es el **hash de contenido** del documento ([documento](document.md#내용-해시)). No se firma solo el BODY.
  - El HEAD contiene reglas de interpretación. Si se cambia el destino de `IMPORT-DOC`, el mismo BODY señala un objeto distinto.
  - Si no se firman `LICENSE` y `PARENT`, la licencia y el historial pueden falsificarse.
- Un documento puede llevar varias firmas. Todas firman el mismo hash de contenido, por lo que añadir firmas no cambia el hash de contenido.
- Comprobación de la clave de firma:
  - Issuer de 2·4 WORD: la clave registrada en geul.org (publicación de claves de verificación, más abajo).
  - Issuer de 16 WORD: el `ISSUER-KEY` del mismo documento. El Issuer ID calculado con esa clave pública debe ser igual al firmante.
- Quien lee reduce la confianza si no hay firma y, si hay firma pero la verificación falla, la reduce más porque es prueba de manipulación o suplantación.
- La firma del documento la hace el Issuer de ese documento, y la de la lista de versiones, el publicador que asignó los ID de versión ([direcciones de publicación y lista de versiones](publishing.md#서명-주체)).

## Publicación de claves de verificación {#검증키-공개}

- geul.org publica las claves de verificación de firma de los Issuer registrados (2·4 WORD).
- La lista de claves se emite como documento publicado del Issuer GEUL (`0x00000000`). Es CC0 y la firma geul.org.
  - Elementos: Issuer, ID del algoritmo de firma, clave pública, instante de inicio de validez, instante y motivo de revocación.
- Las claves revocadas tampoco se borran. Las firmas pasadas se verifican con la clave que era válida en el momento de la firma.
- El cambio de clave se registra firmando la nueva clave con la antigua. Quien verifica puede comprobar la continuidad de la clave sin confiar en geul.org.
- El registro de cambios de clave se deja en un log de solo añadir (como Certificate Transparency y Go sumdb). Si se altera el historial, queda a la vista.
- Si se pierde la clave y no se puede firmar con la antigua, geul.org vuelve a confirmar la identidad y registra la nueva clave. Un Issuer de 2 WORD vuelve a pasar la prueba de propiedad del dominio. En este caso hay que confiar en geul.org, y el motivo se deja en el log.
- No se aplica a los Issuer de 16 WORD. Como el Issuer ID se calcula a partir de la clave pública, se verifican solo con el `ISSUER-KEY` del documento.

## Importación {#가져오기}

IMPORT solo importa documentos.

```
IMPORT-DOC                      DOC-POINTER(Issuer + ID de documento + ID de versión) + IMPORT ID
                                un documento de Codec usa CODEC-POINTER(Issuer + Codec ID + ID de versión) + IMPORT ID
EXTERNAL-POINTER-1/2/4WORD      IMPORT ID + LOCAL ID
EXTERNAL-ISSUER-2/4/16WORD      Issuer + ID de documento + LOCAL ID (sin IMPORT)
ISSUER-POINTER                  Issuer (el propio Issuer)
DOC-POINTER                     Issuer + ID de documento + ID de versión (2 WORD, 0 = última)
CODEC-POINTER                   Issuer + Codec ID + ID de versión (2 WORD, 0 = última)
```

- Un Issuer de cualquier ancho y sus documentos pueden señalarse con una declaración de designación sin IMPORT. El propio Issuer es `ISSUER-POINTER`, el propio documento es `DOC-POINTER` y el LOCAL de un documento es `EXTERNAL-ISSUER-*`. Una declaración de designación sigue la última versión; para fijar la versión se usan `IMPORT-DOC` (ID de versión) y `EXTERNAL-POINTER-*`.
- Un Reference del cuerpo que señala un objeto de un documento externo escribe solo IMPORT ID + ID del objeto, en lugar de la ruta completa (Issuer + documento + ID del objeto). [REFERENCE-ISSUER](reference/_index.md#reference-issuer) escribe el Issuer y el número de Codec.
- El ancho del IMPORT ID lo determina la longitud en `IMPORT-DOC` y el Codec en `EXTERNAL-POINTER-*` ([IMPORT-DOC](meta/0x1E4L-import-doc.md)).
- Una importación sin ID de versión sigue la última versión. Si se escribe el ID de versión, queda fijada a esa versión. Los documentos publicados escriben el ID de versión.

## Licencia {#라이선스}

- Los documentos publicados en geul.org y los documentos del Issuer GEUL (`0x00000000`) son CC0.
- La licencia de los documentos de publicación privada la fija el Issuer. GEUL no la impone.
- **Licencia de los formatos de un Issuer.** Solo los códigos directos y las publicaciones que proporciona geul.org son CC0. La licencia de los formatos de un Issuer la fija ese Issuer.
- **Indicación del Issuer.** GEUL hace depender el Resolve de la indicación del Issuer. En un documento que usa Codecs de otro Issuer, ese Issuer siempre se indica.
- Los productos centrales de GEUL no copian el contenido de documentos de Issuer que no sean CC0.

## Problemas abiertos {#열린-문제}

- El método de prueba de propiedad del dominio (DNS TXT `_geul.<dominio>`, HTTP `.well-known`) y si se ata la huella de la clave de firma al valor de la prueba.
- La respuesta al secuestro de dominio en la recuperación por pérdida de clave. Si se registra una nueva clave solo con volver a probar el dominio, el secuestrador puede apropiarse del Issuer. Se estudian la confirmación del contacto de registro, un período de gracia con objeción por parte de la clave antigua y la aplicación análoga del resultado de las disputas de dominio.
- El formato de registro del documento índice de definición de términos (ID de documento `0`) (los Edge que enumeran los documentos de definición de términos).
- El valor predeterminado del algoritmo de firma (se recomienda Ed25519).
