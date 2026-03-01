---
title: "SILK — Indice Simbolico para el Conocimiento de LLM"
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["SILK", "search", "SIDX", "neuro-symbolic"]
summary: "Arquitectura de busqueda neuro-simbolica basada en enteros de 64 bits. Busca 100 millones de entidades de Wikidata en menos de un segundo sin vector DB, grafos ANN ni modelos de embedding."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Symbolic Index for LLM Knowledge** — arquitectura de busqueda neuro-simbolica.

Busca con enteros de 64 bits. No requiere vector DB, grafos ANN ni modelos de embedding.

<a href="https://github.com/park-jun-woo/silk" target="_blank" rel="noopener">Repositorio en GitHub</a>

## Proposicion central

La busqueda no era un problema dificil, sino un **sintoma de datos sin estructura**.
Si se asigna una estructura de 64 bits en el momento de la escritura, el sintoma desaparece.

```python
results = index[(index & mask) == pattern]
```

100 millones de entidades de Wikidata en 1.3 GB de memoria, busqueda en menos de un segundo.
Solo con Python (NumPy) supera a vector DBs optimizadas en C++/Rust — una victoria de la arquitectura.

## Por que no embeddings vectoriales

Los embeddings vectoriales destruyen la estructura.

```
"El Cid fue un caudillo militar de la Espana medieval"
 → Un humano identifica de inmediato: espanol, militar, siglo XI

Modelo de embedding:
 [0.234, -0.891, 0.445, ..., 0.112] (384 dimensiones float)
 → Estructura destruida. No se puede leer si es person o location.

Para recuperar la estructura destruida:
 Grafos ANN (HNSW, IVF-PQ), cross-encoders, re-rankers, filtros de metadatos...
```

SILK preserva la estructura.

```
SIDX: [Human / military / europe / medieval]
 → La estructura vive en los bits. Se puede leer.
 → No hay nada que recuperar. Nunca se destruyo.
```

La clave es la inversion del orden.

```
Convencional: primero escribir → estructurar despues (indexacion)
SILK:         estructurar al escribir → la busqueda es gratuita
```

## Disposicion de bits SIDX

SIDX sigue la especificacion Entity Node de la [gramatica GEUL](/es/grammar/).

```
[prefix 7 | mode 3 | entity_type 6 | attrs 48]
 MSB(63)                                  LSB(0)
```

| Campo | Bits | Tamano | Descripcion |
|-------|------|--------|-------------|
| prefix | 63-57 | 7 | Cabecera de protocolo GEUL (`0001001` fijo, ignorado en busqueda) |
| mode | 56-54 | 3 | Modo de cuantificacion/numero (entidad registrada=0, definido, universal, existencial, etc. 8 tipos) |
| entity_type | 53-48 | 6 | 64 tipos de nivel superior (Human=0 ~ Election=62, sin clasificar=63) |
| attrs | 47-0 | 48 | Codificacion de atributos por tipo (definida por codebook) |

Objetivo de busqueda: entity_type 6 bits + attrs 48 bits = **54 bits**.
El QID no esta incluido en el SIDX; se almacena en un array separado.

### attrs 48 bits — esquema por tipo

```
Human(0):       subclass 5 | occupation 6 | country 8 | era 4 | decade 4 | gender 2 | notability 3 | ...
Star(12):       constellation 7 | spectral_type 4 | luminosity 3 | magnitude 4 | ra_zone 4 | dec_zone 4 | ...
Settlement(28): country 8 | admin_level 4 | admin_code 8 | lat_zone 4 | lon_zone 4 | population 4 | ...
Organization(44): country 8 | org_type 4 | legal_form 6 | industry 8 | era 4 | size 4 | ...
Film(51):       country 8 | year 7 | genre 6 | language 8 | color 2 | duration 4 | ...
```

Actualmente se han definido las disposiciones de bits de atributos para 5 tipos. El resto solo codifica entity_type.

## Arquitectura

SILK tiene dos pipelines: **codificacion** (al escribir) y **busqueda** (al consultar).
Ambos siguen el mismo principio: lo simbolico captura la estructura, el LLM procesa el significado.

```
Pipeline de codificacion (al escribir)
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│  Etiquetado  │──►│ Validacion   │──►│ Codificacion │
│  LLM         │   │ VALID        │   │ por codebook │
│  Doc → JSON  │   │ Valores      │   │ JSON → SIDX  │
│ (clasif.     │   │ validos del  │   │ (ensamblaje  │
│  semantica)  │   │ codebook     │   │  de bits)    │
│              │   │ Alucinacion  │   │              │
│              │   │ → descarte   │   │              │
└──────────────┘   └──────────────┘   └──────────────┘
  LLM etiqueta      Codigo valida    Codificacion por codebook
```

```
Pipeline de busqueda (al consultar)
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│ Interpretac. │──►│ Filtro bit   │──►│  Juicio LLM  │
│ de consulta  │   │ AND          │   │ Solo pocos   │
│ Lookup en    │   │ NumPy SIMD   │   │ candidatos   │
│ codebook     │   │ 100M → unas  │   │ Candidatos   │
│ + asist. LLM │   │ decenas      │   │ → respuesta  │
└──────────────┘   └──────────────┘   └──────────────┘
  Extracc. semantica  Filtrado amplio  Juicio preciso
```

Estrategia clave: **filtrar ampliamente sin perder nada con bit AND de SIDX**, luego **el LLM juzga solo los pocos candidatos**.

```
Cada uno hace lo que mejor sabe:
 Humano: disenar estructura (codebook)
 LLM:    clasificacion semantica (etiquetado) + juicio semantico (busqueda)
 Codigo: validacion de reglas (VALID) + ensamblaje de bits
 CPU:    comparacion masiva (NumPy SIMD)
```

### Codificacion: etiquetado LLM → validacion VALID

El LLM lee el documento y lo etiqueta como JSON. VALID realiza una verificacion mecanica basada en el codebook.
Valores fuera del codebook, violaciones de consistencia entre tipos y violaciones de restricciones **fisicamente no pueden entrar al indice**.

```
Etiquetado LLM: {"type": "Human", "occupation": "military", "country": "spain"}
VALID:          occupation="military" ∈ codebook? ✓  country="spain" ∈ codebook? ✓
                Human con campo constellation? ✗ Descartado
Codificacion:   codebook "military"→6 bits, "spain"→8 bits → ensamblaje de bits → SIDX uint64
```

El LLM puede alucinar. Pero como VALID actua de guardian, la posibilidad de contaminacion del indice es 0.
Solo el JSON que pasa VALID se codifica como entero SIDX de 64 bits basado en el codebook.

### Busqueda: filtrado amplio, el LLM refina

```
1. Extraccion semantica    Lookup en codebook 80% / asistencia LLM 20%
2. Ensamblaje de mascara   Determinista — algoritmo
3. Bit AND con NumPy       Determinista — escaneo completo de 100M en 20ms
4. Juicio final LLM        Solo pocos candidatos — juicio semantico preciso
```

### El 80% de las busquedas son consultas estructurales

```
"El Cid"        → Q189511 exact match. Bit AND. Fin.
"noticias Samsung" → org/company + doc_meta/news. Bit AND. Fin.
"cumbre Biden-Xi"  → Q6279 ∩ Q15031 ∩ meeting. Interseccion. Fin.
```

```
Consulta estructural (80%): completada con bit AND de SILK. Sin LLM.
Consulta semantica  (15%): SILK reduce candidatos → LLM juzga 5-10 items.
Consulta generativa  (5%): SILK localiza documentos → LLM genera.
```

## Multi-SIDX

Un solo documento/evento puede tener multiples SIDX.

```
Noticia "Reunion de ejecutivos de Samsung, NVIDIA e Hyundai":

SIDX[0]: [Human / business / east_asia ]  Lee Jae-yong
SIDX[1]: [Org   / company / east_asia ]  Samsung Electronics
SIDX[2]: [Human / business / n_america]  Jensen Huang
SIDX[3]: [Org   / company / n_america]  NVIDIA
SIDX[4]: [Human / business / east_asia ]  Chung Eui-sun
SIDX[5]: [Org   / company / east_asia ]  Hyundai Motor
SIDX[6]: [Event / meeting / east_asia ]  Reunion
```

Todos son el mismo SIDX de 64 bits. Mismo indice. Misma busqueda por bit AND.
El campo entity_type distingue entidades (Human, Org) de eventos (Event).

## Estructura del indice

```python
sidx_array = np.array([...], dtype=np.uint64)  # 108.8M × 8B = 870MB
qid_array  = np.array([...], dtype=np.uint32)  # 108.8M × 4B = 435MB
# Total ~1.3GB en memoria
```

```
Construccion del indice:
 Elasticsearch: tokenizacion → analisis → indice invertido → merge de segmentos
 Pinecone:      embedding → grafo HNSW → clustering
 SILK:          sort
```

Sin estructura de datos. Un solo array ordenado.

## Comparacion con vector DB

|  | SILK | Vector DB |
|------|------|-----------|
| Tamano del indice (1B registros) | 12TB | 1.5PB (125x) |
| Construccion del indice | sort | HNSW dias |
| Arranque en frio | Inmediato al abrir archivo | Horas construyendo grafo |
| Escaneo particionado | Posible (resultado identico) | Imposible (grafo roto) |
| Condiciones compuestas | Interseccion (exacta) | Comprimido en 1 vector (aproximado) |
| Resultado | Exacto (operacion de conjuntos) | Aproximado (ranking por similitud) |
| Auditoria | JSON (caja blanca) | Imposible (caja negra) |

```
Bit AND es independiente del orden, sin estado, acumulable.
Vector DB: todo el grafo debe estar en memoria. Particionar = destruir.
SILK:      funciona donde se corte. Particionar = solo mas lento. Mismo resultado.
```

## Pipeline de auditoria

Los embeddings vectoriales son caja negra: no se pueden auditar. SIDX es JSON: se puede auditar.

```
Fase 1 — Etiquetado con LLM pequeno    Llama 8B / GPT-4o-mini. Precision 85-90%.
Fase 2 — Verificacion mecanica VALID    Valores validos, consistencia, restricciones. Costo $0.
Fase 3 — Auditoria con LLM grande      Solo confidence=low. Precision 99%+.

VALID como guardian: alucinaciones fuera de valores validos del codebook fisicamente no entran al indice.
```

## Licencia

MIT — <a href="https://github.com/park-jun-woo/silk" target="_blank" rel="noopener">GitHub</a>
