---
title: "Meta"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance", "lineage", "import"]
summary: "Meta es un registro sobre el documento, no sobre el mundo. Se divide en siete clases (estructura, definición, procedencia, linaje, verificación, política e IMPORT) y se coloca en el HEAD del documento."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---
Meta no es contenido sobre el mundo sino un registro sobre el documento. Salvo los registros de estructura del documento (DOC·BODY·END), todos se colocan en el HEAD del documento. En el HEAD, además de Meta, también va el Edge de fundamento [SOURCE](/es/grammar/edge/source/#procedencia-del-documento-entero) del documento entero y sus QUALIFIER.

## Layout

```
TAG WORD          0001 1LLL LCCC CCCC
[TAG de extensión de Length]
Payload           valor en bruto o registros Value·Reference incorporados
```

- Meta no tiene formato Issuer. Meta es una especificación común que siguen todos los Issuer y la define solo GEUL.
- `LLLL` es el número total de WORD, incluido el TAG WORD, menos 1. Un Codec que no figure en las tablas está reservado.

## Formato del Payload

| Formato | Cuándo | Ejemplo |
|---|---|---|
| Valor en bruto | Cuando el formato queda fijado de forma única. No depende de otros Codec de registro | Longitud de `DOC-*`, `SPEC-VERSION`, `ISSUER-KEY` |
| Value incorporado | Al elegir entre varios formatos. El TAG del Value indica el formato | `PROFILE`, `EFFECTIVE-*`, momentos, hash de contenido |
| Reference incorporado | Al apuntar a un objeto como una persona, organización, herramienta o documento | `DOC-ID`, `AUTHOR`, `CO-AUTHOR`, `RECORDED-BY`, `SIGNED-OFF`, el firmante de `SIGNATURE` |
| Ninguno | Marcador de 1 WORD | `BODY`, `END` |

- Los registros incorporados no son registros independientes sino que pertenecen a ese Meta. Cada uno encuentra sus límites con su propio Length, y la posición a la que se llega tras leer el último registro debe coincidir exactamente con el final del Meta.
- Qué Meta pueden ponerse una sola vez en un documento y cuáles varias veces lo fija la «cantidad» del documento de cada Codec.

## Clases

Los 3 bits superiores del Codec son la clase.

| 3 bits superiores | Clase | Código directo | Qué trata |
|---|---|---|---|
| `000` | Estructura | `0x00`~`0x0F` | Límites y longitud del documento |
| `001` | Definición | `0x10`~`0x1F` | Declaraciones de interpretación |
| `010` | Procedencia | `0x20`~`0x2F` | Quién, cuándo y dónde |
| `011` | Linaje | `0x30`~`0x3F` | De qué y cómo salió |
| `100` | Verificación | `0x40`~`0x4F` | Si es de fiar |
| `101` | Política | `0x50`~`0x5F` | Cómo se trata |
| `110` | IMPORT | `0x60`~`0x6F` | Trae documentos externos |
| `111` | Reservado | `0x70`~`0x7F` | |

- **Meta necesarios para la interpretación**: estructura, definición e IMPORT. Si se borran, los registros no se pueden leer o la interpretación cambia. Todos los decodificadores deben procesarlos. Estos Codec pertenecen al **libro de códigos central de GEUL**.
- **Meta que no cambian la interpretación**: procedencia, linaje, verificación y política. Aunque se borren, el contenido de las afirmaciones queda igual. Solo desaparece la materia prima del juicio de confianza y del tratamiento.
- El fundamento no se escribe con Meta sino con el Edge de fundamento [SOURCE](/es/grammar/edge/source/) y con QUALIFIER. El fundamento de cada registro va en el BODY, y la fuente del documento entero va en el HEAD como SOURCE de Target `0` ([Documento](/es/grammar/document/#head-y-body)).

## Estructura

Documento de conjunto: [Meta — estructura](/es/grammar/meta/structure/)

| Codec | Nombre | Significado |
|---|---|---|
| `0x00`~`0x02` | [DOC-1WORD / 2WORD / 4WORD](/es/grammar/meta/structure/doc/) | Abre el documento indicando la longitud total |
| `0x0E` | [BODY](/es/grammar/meta/structure/body/) | Termina el HEAD y abre el BODY |
| `0x0F` | [END](/es/grammar/meta/structure/end/) | Cierra el documento |

Las reglas detalladas están en [Documento](/es/grammar/document/).

## Definición

Documento de conjunto: [Meta — definición](/es/grammar/meta/declaration/)

| Codec | Nombre | Significado |
|---|---|---|
| `0x10` | [SPEC-VERSION](/es/grammar/meta/declaration/spec-version/) | Versión de la especificación que se sigue. Un entero |
| `0x11` | [PROFILE](/es/grammar/meta/declaration/profile/) | Perfil aplicado |
| `0x12` | [DOC-ID](/es/grammar/meta/declaration/doc-id/) | Identificador de este documento. Un DOC-POINTER que se apunta a sí mismo (versión 0) |
| `0x13` | [EFFECTIVE-FROM](/es/grammar/meta/declaration/effective-from/) | Fecha de entrada en vigor de esta versión. Si falta, el momento de publicación |
| `0x14` | [EFFECTIVE-UNTIL](/es/grammar/meta/declaration/effective-until/) | Fin de la validez de esta versión (ley temporal). Si falta, hasta que entre en vigor la siguiente versión |
| `0x16` | [DEFAULT-LANGUAGE](/es/grammar/meta/declaration/default-language/) | Idioma por defecto |

- El nombre de dirección de un documento no se pone como Meta. Lo vincula con BIND el índice de nombres del Issuer `documents.geul` ([Direcciones de publicación y lista de versiones](/es/grammar/publishing/#nombre-del-documento)). El título legible por personas se añade con un LABEL del BODY.

## Procedencia

Documento de conjunto: [Meta — procedencia](/es/grammar/meta/provenance/)

| Codec | Nombre | Significado |
|---|---|---|
| `0x20` | [AUTHOR](/es/grammar/meta/provenance/author/) | Autor (Reference) |
| `0x21` | [CO-AUTHOR](/es/grammar/meta/provenance/co-author/) | Coautor |
| `0x22` | [CREATED-AT](/es/grammar/meta/provenance/created-at/) | Momento de creación |
| `0x23` | [MODIFIED-AT](/es/grammar/meta/provenance/modified-at/) | Momento de modificación |
| `0x24` | [RECORDED-BY](/es/grammar/meta/provenance/recorded-by/) | Entidad que lo registró |
| `0x25` | [RECORDED-AT](/es/grammar/meta/provenance/recorded-at/) | Momento del registro |
| `0x26`~`0x2F` | Reserved | |

- El material de origen no se escribe con Meta sino con el Edge de fundamento [SOURCE](/es/grammar/edge/source/#procedencia-del-documento-entero) del HEAD (Target `0`), y el rango del texto original, el momento de obtención y el hash del texto original se escriben con los QUALIFIER que se añaden a ese SOURCE.

## Linaje

Documento de conjunto: [Meta — linaje](/es/grammar/meta/lineage/)

El linaje sigue el modelo de commits de git. La unidad que corresponde a un commit es el documento.

| Codec | Nombre | Significado |
|---|---|---|
| `0x30` | [PARENT](/es/grammar/meta/lineage/parent/) | Hash de contenido de la versión inmediatamente anterior. Si hay varios, es una fusión |
| `0x31` | [DERIVED-FROM](/es/grammar/meta/lineage/derived-from/) | Derivado de material de otro linaje |
| `0x32` | [GENERATED-BY](/es/grammar/meta/lineage/generated-by/) | Entidad generadora (persona, modelo, motor de reglas) |
| `0x33` | [TRANSFORMED-BY](/es/grammar/meta/lineage/transformed-by/) | Herramienta de transformación y la versión de su código fuente (digest del commit) |
| `0x34` | [CHERRY-PICKED-FROM](/es/grammar/meta/lineage/cherry-picked-from/) | Versión original del cambio traído |
| `0x35` | [REVERTS](/es/grammar/meta/lineage/reverts/) | Versión revertida |
| `0x36` | [REPLACES](/es/grammar/meta/lineage/replaces/) | Versión reescrita. La versión original no se borra |
| `0x37` | [SQUASHED-FROM](/es/grammar/meta/lineage/squashed-from/) | Versiones originales unidas en una |
| `0x38` | [MESSAGE](/es/grammar/meta/lineage/message/) | Motivo del cambio. Uno por idioma |
| `0x39` | [TAG](/es/grammar/meta/lineage/tag/) | Nombre inmutable puesto a una versión |
| `0x3A` | [DELTA-BASE](/es/grammar/meta/lineage/delta-base/) | Este archivo es un diff respecto de la versión base |
| `0x3B` | [DELTA-REMOVE](/es/grammar/meta/lineage/delta-remove/) | Lista de LOCAL ID que se quitan en el diff |
| `0x3C` | [NEXT-LOCAL-ID](/es/grammar/meta/lineage/next-local-id/) | Siguiente LOCAL ID por asignar. Se coloca en el documento de lista de versiones |

- El historial no se borra. Lo corregido se emite como una nueva versión.
- Los punteros mutables, como branch, no se colocan en el documento. Los gestionan el repositorio y el índice.

## Verificación

Documento de conjunto: [Meta — verificación](/es/grammar/meta/verification/)

| Codec | Nombre | Significado |
|---|---|---|
| `0x40` | [ISSUER-KEY](/es/grammar/meta/verification/issuer-key/) | Algoritmo de firma y clave pública de un Issuer de autoemisión |
| `0x41` | [SIGNATURE](/es/grammar/meta/verification/signature/) | Firma del hash de contenido. Algoritmo, firmante, firma |
| `0x42` | [SIGNED-OFF](/es/grammar/meta/verification/signed-off/) | Confirmación de derechos de contribución |
| `0x43` | [CONFIDENCE](/es/grammar/meta/verification/confidence/) | Confiabilidad |
| `0x44` | [VERDICT](/es/grammar/meta/verification/verdict/) | Resultado del juicio del documento entero (Pass, Review, Fail) |

- La clase de verificación se excluye del cálculo del hash de contenido. Por eso, ni colocar la firma dentro del documento ni añadir varias firmas cambia el hash de contenido.

## Política

Documento de conjunto: [Meta — política](/es/grammar/meta/policy/)

| Codec | Nombre | Significado |
|---|---|---|
| `0x50` | [LICENSE](/es/grammar/meta/policy/license/) | Licencia |
| `0x51` | [ACCESS](/es/grammar/meta/policy/access/) | Ámbito de divulgación |
| `0x52` | [PRIVACY](/es/grammar/meta/policy/privacy/) | Grado de datos personales |
| `0x53` | [RETENTION](/es/grammar/meta/policy/retention/) | Plazo de conservación |
| `0x54` | [CONSENT](/es/grammar/meta/policy/consent/) | Ámbito y fundamento del consentimiento |
| `0x55` | [USAGE](/es/grammar/meta/policy/usage/) | Restricciones de uso |

- La política no cambia la interpretación sino que fija cómo se trata.

## IMPORT

Documento de conjunto: [Meta — IMPORT](/es/grammar/meta/import/)

```
TAG WORD          0001 1LLL L110 0000      IMPORT-DOC (0x60)
[TAG de extensión de Length]
Documento         registro DOC-POINTER (Issuer, ID de documento, ID de versión)
IMPORT ID         el resto. Entero del ancho más corto
```

- Solo se usa [IMPORT-DOC](/es/grammar/meta/import/import-doc/) (`0x60`). IMPORT solo trae documentos. Los objetos del documento importado se señalan con `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID) en el BODY.
- Si se anota el ID de versión, queda ligado a esa edición, y si es `0`, a la edición más reciente en el momento de la interpretación. Los documentos publicados anotan la versión.
- En un documento no se asigna dos veces el mismo IMPORT ID.
- El HEAD del documento importado no se trae. Los objetos de ese documento se interpretan según las declaraciones de ese documento.

Ejemplo: se trae con el IMPORT ID 1 la última versión del documento del Issuer `0x0001` con ID de documento `0x0000000000000002`.

```
1CE0 03B8 0001 0000 0000 0000 0002 0000 0000 0001
```
