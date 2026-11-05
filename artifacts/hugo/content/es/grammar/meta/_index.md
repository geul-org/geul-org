---
title: "Meta"
weight: 110
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance", "lineage", "import"]
summary: "Meta son registros que tratan del documento, no de contenido sobre el mundo."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta son registros que tratan del documento, no de contenido sobre el mundo. Salvo los registros de estructura del documento (DOC, BODY, END), todos van en el HEAD del documento. En el HEAD, además de los Meta, también van el Edge de fundamento de todo el documento [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) y sus QUALIFIER.

## Layout {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      secciones 14·15 (0x1C0L~0x1FFL)
[TAG de extensión de Length]
Payload           valor en bruto o registros Value·Reference incorporados
```

- Meta no tiene formato de Issuer. Meta es una especificación común que siguen todos los Issuer y solo la define GEUL.
- `LLLL` es el número total de WORD, incluido el TAG WORD, menos 1. Los Codec que no están en la tabla son Reserved.

## Formato del Payload {#payload-형식}

| Formato | Cuándo | Ejemplo |
|---|---|---|
| valor en bruto | Cuando el formato queda fijado en uno solo. No se apoya en el Codec de otros registros | longitud de `DOC-*`, `SPEC-VERSION`, `ISSUER-KEY` |
| Value incorporado | Cuando se elige entre varios formatos. El TAG de Value indica el formato | `PROFILE`, `EFFECTIVE-*`, momentos, hash de contenido |
| Reference incorporado | Cuando se señala un objetivo como una persona, organización, herramienta o documento | `DOC-ID`, `AUTHOR`, `CO-AUTHOR`, `RECORDED-BY`, `SIGNED-OFF`, el firmante de `SIGNATURE` |
| ninguno | Marca de 1 WORD | `BODY`, `END` |

- Los registros incorporados no son registros independientes sino que pertenecen a su Meta. Cada uno encuentra su límite con su propio Length, y la posición tras leer el último registro debe coincidir exactamente con el final del Meta.
- Qué Meta pueden ponerse solo uno por documento y cuáles varios lo fija la «cantidad» de cada documento de Codec.

## Clases {#클래스}

Los números de Meta continúan desde `0x1C0L` sin Reserved. Los bits del número no indican la clase. La clase se conoce por la tabla de intervalos siguiente.

| Clase | Código directo | Qué trata |
|---|---|---|
| estructura | `0x1C0L~0x1C4L` | Límites y longitud del documento |
| definición | `0x1C5L~0x1CAL` | Declaraciones de interpretación |
| procedencia | `0x1CBL~0x1D0L` | Quién, cuándo, dónde |
| linaje | `0x1D1L~0x1DDL` | De qué y cómo surgió |
| política | `0x1DEL~0x1E3L` | Cómo se trata |
| IMPORT | `0x1E4L` | Importa un documento externo |
| verificación | `0x1E5L~0x1E9L` | Si es fiable |
| Reserved (solo verificación) | `0x1EAL~0x1FFL` | |

- La clase de verificación son los registros de la sección 15 con `C >= 5`, es decir, `w >= 0x1E50`. Con esto se reconoce la clase de verificación sin libro de códigos y se excluye del hash de contenido.
- El Reserved final `0x1EAL~0x1FFL` es solo para verificación. Un Meta nuevo ajeno a la verificación no puede insertarse antes de la verificación, y si se pone en el Reserved final queda fuera del hash de contenido.
- Las clases de estructura, definición e IMPORT no se leen por bits. El decodificador las conoce por su tabla de números incorporada.
- **Meta necesarios para la interpretación**: estructura, definición, IMPORT. Si se borran, no se pueden leer los registros o cambia la interpretación. Todo decodificador debe procesarlos. Estos Codec pertenecen al **libro de códigos central de GEUL**.
- **Meta que no cambian la interpretación**: procedencia, linaje, verificación, política. Aunque se borren, el contenido de los enunciados sigue igual. Solo desaparece el material para juzgar la confianza y el tratamiento.
- El fundamento no se escribe con Meta sino con el Edge de fundamento [SOURCE](../edge/0x0C0L-source.md) y QUALIFIER. El fundamento de cada registro va en el BODY, y el origen de todo el documento va en el HEAD como SOURCE con Target `0` ([documento](../document.md#head와-body)).

## Estructura {#구조}

La clase de estructura de Meta (Codec `0x1C0L~0x1C4L`) fija los límites y la longitud del documento. La unidad de los datos GEUL es un documento.

```
DOC-*                  ← inicio del HEAD
  Meta de definición·procedencia·linaje·verificación·política·IMPORT
  SOURCE de todo el documento y su QUALIFIER
BODY                   ← inicio del BODY
  Reference, Value, Edge
END                    ← cierra el documento
```

- Todo documento se abre con `DOC-1WORD/2WORD/4WORD`, que fija la longitud total. El decodificador puede saltar el documento entero de una vez con esta longitud.
- `BODY` y `END` son registros de 1 WORD sin Payload. `END` es obligatorio.
- Los documentos no se anidan. Los demás documentos se señalan con IMPORT.
- Si el HEAD (Meta, SOURCE de todo el documento y su QUALIFIER) está vacío, se omite `BODY`. `BODY` solo puede ponerse una vez por documento.

La estructura completa del documento está en [documento](../document.md).

| Codec | Nombre | Significado |
|---|---|---|
| `0x1C0L~0x1C2L` | [DOC-1WORD / 2WORD / 4WORD](0x1C0L-doc-1word.md) | Abre el documento fijando la longitud total |
| `0x1C3L` | [BODY](0x1C3L-body.md) | Termina el HEAD y abre el BODY |
| `0x1C4L` | [END](0x1C4L-end.md) | Cierra el documento |

Las reglas detalladas están en [documento](../document.md).

## Definición {#정의}

La clase de definición de Meta (Codec `0x1C5L~0x1CAL`) son declaraciones de interpretación. Como las declaraciones cambian las reglas de interpretación, todo decodificador debe procesarlas. El alcance de una declaración es ese documento.

- `SPEC-VERSION` fija cómo se leen los demás registros, por lo que lleva solo un entero, sin Value incorporado. GEUL v1 es `0x0001` (registro `1C51 0001`).
- `DOC-ID` es el `DOC-POINTER` (Issuer, ID de documento, versión `0`) que señala al propio documento. Un documento de Codec usa `CODEC-POINTER` (Issuer, Codec ID, versión `0`). Si falta, es un documento sin nombre y solo se le puede señalar por hash de contenido.
- No existe dirección por nombre de documento. El título legible por personas se pone con el `LABEL` de enunciado ([direcciones de publicación y lista de versiones](../publishing.md#문서-이름)).

| Codec | Nombre | Significado |
|---|---|---|
| `0x1C5L` | [SPEC-VERSION](0x1C5L-spec-version.md) | Edición de la especificación a la que se ajusta. Un solo entero |
| `0x1C6L` | [PROFILE](0x1C6L-profile.md) | Perfil aplicado |
| `0x1C7L` | [DOC-ID](0x1C7L-doc-id.md) | Identificador de este documento. DOC-POINTER (versión 0) que se señala a sí mismo. Un documento de Codec usa CODEC-POINTER (versión 0) |
| `0x1C8L` | [EFFECTIVE-FROM](0x1C8L-effective-from.md) | Fecha de entrada en vigor de esta versión. Si falta, el momento de publicación |
| `0x1C9L` | [EFFECTIVE-UNTIL](0x1C9L-effective-until.md) | Fin del período de vigencia de esta versión (ley temporal). Si falta, hasta que entre en vigor la versión siguiente |
| `0x1CAL` | [DEFAULT-LANGUAGE](0x1CAL-default-language.md) | Idioma por defecto |

- No existe dirección por nombre de documento ([direcciones de publicación y lista de versiones](../publishing.md#문서-이름)). El título legible por personas se pone con el LABEL del BODY.

## Procedencia {#출처}

La clase de procedencia de Meta (Codec `0x1CBL~0x1D0L`) indica quién creó y registró el documento, y cuándo.

- El autor, el registrador y sus momentos siguen el modelo de author y committer de git (`AUTHOR`·`CREATED-AT`, `RECORDED-BY`·`RECORDED-AT`).
- Aunque se borre la procedencia, el contenido de los enunciados no cambia. Solo desaparece el material para juzgar la confianza.
- Los materiales de origen no están en esta clase. El origen de todo el documento se escribe en el HEAD y el de cada registro en el BODY, con el Edge de fundamento [SOURCE](../edge/0x0C0L-source.md). El rango correspondiente en el original, el momento de obtención y el hash del original son QUALIFIER que se añaden a ese SOURCE (página P304·sección P958, fecha de consulta P813, suma de comprobación P4092).
- Si las propiedades propias del origen (rango del original, momento de obtención) se pusieran como Meta, cuando hubiera varios orígenes no se podría decidir de cuál son. Por eso se escriben como QUALIFIER cuyo Target es el SOURCE.

| Codec | Nombre | Significado |
|---|---|---|
| `0x1CBL` | [AUTHOR](0x1CBL-author.md) | Autor (Reference) |
| `0x1CCL` | [CO-AUTHOR](0x1CCL-co-author.md) | Coautor |
| `0x1CDL` | [CREATED-AT](0x1CDL-created-at.md) | Momento de redacción |
| `0x1CEL` | [MODIFIED-AT](0x1CEL-modified-at.md) | Momento de modificación |
| `0x1CFL` | [RECORDED-BY](0x1CFL-recorded-by.md) | Sujeto que registró |
| `0x1D0L` | [RECORDED-AT](0x1D0L-recorded-at.md) | Momento del registro |

- El material de origen no se escribe como Meta sino como el Edge de fundamento [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) del HEAD (Target `0`), y el rango del original, el momento de obtención y el hash del original se escriben como QUALIFIER que se añaden a ese SOURCE.

## Linaje {#계보}

La clase de linaje de Meta (Codec `0x1D1L~0x1DDL`) indica de qué y cómo surgió el documento. El linaje sigue el modelo de commit de git, y la unidad equivalente al commit es el documento.

- El **hash de contenido** señala el contenido de un ejemplar del documento (git commit id). Es el SHA-256 desde el registro de apertura (`DOC-*`) hasta justo antes de `END`, y los registros de la clase de verificación (sección 15 con `C >= 5`, `w >= 0x1E50`) se excluyen del cálculo.
- El **ID de versión** es un entero de 2 WORD que se numera desde 1 en orden de publicación dentro de un documento con nombre. `0` significa que no se ha anotado la versión.
- Los Meta de linaje señalan versiones por hash de contenido. Como el `PARENT` dentro del documento también entra en el hash, el hash de contenido se convierte en una cadena de hashes que enlaza todo el historial.
- El historial no se borra. Lo corregido se publica como una nueva versión. Los punteros cambiantes, como las branch, no se ponen en el documento.
- `DELTA-BASE` y `DELTA-REMOVE` son el formato que guarda una versión como diff respecto de una versión base. La versión siempre se define como instantánea.

Las reglas de revisión están en [documento](../document.md).

El linaje sigue el modelo de commit de git. La unidad equivalente al commit es el documento.

| Codec | Nombre | Significado |
|---|---|---|
| `0x1D1L` | [PARENT](0x1D1L-parent.md) | Hash de contenido de la versión inmediatamente anterior. Si hay varios, fusión |
| `0x1D2L` | [DERIVED-FROM](0x1D2L-derived-from.md) | Derivado de materiales de otro linaje |
| `0x1D3L` | [GENERATED-BY](0x1D3L-generated-by.md) | Sujeto generador (persona, modelo, motor de reglas) |
| `0x1D4L` | [TRANSFORMED-BY](0x1D4L-transformed-by.md) | Herramienta de conversión y la versión de su fuente (resumen del commit) |
| `0x1D5L` | [CHERRY-PICKED-FROM](0x1D5L-cherry-picked-from.md) | Versión original del cambio tomado |
| `0x1D6L` | [REVERTS](0x1D6L-reverts.md) | Versión objetivo que se revirtió |
| `0x1D7L` | [REPLACES](0x1D7L-replaces.md) | Versión objetivo que se reescribió. La versión original no se borra |
| `0x1D8L` | [SQUASHED-FROM](0x1D8L-squashed-from.md) | Versiones originales fusionadas en una |
| `0x1D9L` | [MESSAGE](0x1D9L-message.md) | Motivo del cambio. Uno por idioma |
| `0x1DAL` | [TAG](0x1DAL-tag.md) | Nombre inmutable asignado a una versión |
| `0x1DBL` | [DELTA-BASE](0x1DBL-delta-base.md) | Este archivo es un diff respecto de una versión base |
| `0x1DCL` | [DELTA-REMOVE](0x1DCL-delta-remove.md) | Lista de LOCAL ID que el diff quita |
| `0x1DDL` | [NEXT-LOCAL-ID](0x1DDL-next-local-id.md) | Próximo LOCAL ID a asignar. Se pone en el documento de la lista de versiones |

- El historial no se borra. Lo corregido se publica como una nueva versión.
- Los punteros cambiantes, como las branch, no se ponen en el documento. Los gestionan el repositorio y el índice.

## Verificación {#검증}

La clase de verificación de Meta (Codec `0x1E5L~0x1E9L`) contiene el material para juzgar si el documento es fiable: la clave pública de un Issuer de emisión propia, la firma, la confirmación del derecho de contribución, la confianza y el resultado del veredicto de todo el documento.

- La clase de verificación queda fuera del cálculo del hash de contenido. Por eso, aunque se ponga la firma dentro del documento o se añadan varias firmas, el hash de contenido no cambia (igual que `gpgsig` de git).
- La clase de verificación son los registros de la sección 15 con `C >= 5`, es decir, `w >= 0x1E50`, así que el hash puede calcularse sin libro de códigos. El Reserved final `0x1EAL~0x1FFL` también es solo para verificación y queda fuera del hash.
- El veredicto a nivel de nodo o registro lo asume el Edge `VERDICT` de [TOULMIN](../toulmin/_index.md) (`0x118L`).

| Codec | Nombre | Significado |
|---|---|---|
| `0x1E5L` | [ISSUER-KEY](0x1E5L-issuer-key.md) | Algoritmo de firma y clave pública de un Issuer de emisión propia |
| `0x1E6L` | [SIGNATURE](0x1E6L-signature.md) | Firma del hash de contenido. Algoritmo, firmante, firma |
| `0x1E7L` | [SIGNED-OFF](0x1E7L-signed-off.md) | Confirmación del derecho de contribución |
| `0x1E8L` | [CONFIDENCE](0x1E8L-confidence.md) | Confianza |
| `0x1E9L` | [VERDICT](0x1E9L-verdict.md) | Resultado del veredicto de todo el documento (Pass, Review, Fail) |

- La clase de verificación queda fuera del cálculo del hash de contenido. Por eso, aunque se ponga la firma dentro del documento o se añadan varias firmas, el hash de contenido no cambia.

## Política {#정책}

La clase de política de Meta (Codec `0x1DEL~0x1E3L`) fija cómo se trata el documento: licencia, alcance de divulgación, nivel de datos personales, plazo de conservación, consentimiento y restricciones de uso.

- La política no cambia la interpretación; fija cómo se trata.
- La licencia original de las obras contenidas en la secuencia de bytes se registra con `LICENSE`.

| Codec | Nombre | Significado |
|---|---|---|
| `0x1DEL` | [LICENSE](0x1DEL-license.md) | Licencia |
| `0x1DFL` | [ACCESS](0x1DFL-access.md) | Alcance de divulgación |
| `0x1E0L` | [PRIVACY](0x1E0L-privacy.md) | Nivel de datos personales |
| `0x1E1L` | [RETENTION](0x1E1L-retention.md) | Plazo de conservación |
| `0x1E2L` | [CONSENT](0x1E2L-consent.md) | Alcance del consentimiento y su fundamento |
| `0x1E3L` | [USAGE](0x1E3L-usage.md) | Restricciones de uso |

- La política no cambia la interpretación; fija cómo se trata.

## IMPORT {#import}

La clase IMPORT de Meta (Codec `0x1E4L`) importa un documento externo mediante un IMPORT ID. El Codec es uno solo: `IMPORT-DOC` (`0x1E4L`).

- IMPORT solo importa documentos. Los objetivos dentro del documento importado se señalan con el Reference `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) del BODY ([Reference](../reference/_index.md)).
- Si se escribe un ID de versión, se vincula a esa edición; con `0`, a la última edición en el momento de la interpretación. Los documentos publicados anotan la versión.
- No se importa el HEAD del documento importado. Los registros Reference y Value no se importan sino que se copian.

```
TAG WORD          0001 1110 0100 LLLL      IMPORT-DOC (0x1E4L)
[TAG de extensión de Length]
Documento         registro DOC-POINTER (Issuer, ID de documento, ID de versión). Un documento de Codec usa CODEC-POINTER
IMPORT ID         el resto. Entero del ancho más corto
```

- Solo se usa [IMPORT-DOC](0x1E4L-import-doc.md) (`0x1E4L`). IMPORT solo importa documentos. Los objetivos dentro del documento importado se señalan con `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) del BODY.
- Si se escribe un ID de versión, se vincula a esa edición; con `0`, a la última edición en el momento de la interpretación. Los documentos publicados anotan la versión.
- En un documento no se asigna dos veces el mismo IMPORT ID.
- No se importa el HEAD del documento importado. Los objetivos de ese documento se interpretan según las declaraciones de ese documento.

Ejemplo: se importa con IMPORT ID 1 la última versión del documento `0x0000000000000002` del Issuer `0x00000002`.

```
1E4A 0418 0000 0002 0000 0000 0000 0002 0000 0000 0001
```
