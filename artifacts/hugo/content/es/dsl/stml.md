---
title: "STML — SSOT Template Markup Language"
weight: 1
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-08T12:00:00+09:00
tags: ["STML", "DSL", "SSOT", "frontend", "React", "OpenAPI"]
summary: "Un lenguaje de declaración de UI independiente del framework. Define qué muestran y hacen las páginas con atributos HTML5 data-*, valida simbólicamente contra OpenAPI y genera código React."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**SSOT Template Markup Language** — declaración de UI independiente del framework.

El código frontend mezcla dos cosas: **tus decisiones** y **el cableado del framework**. Qué API llamar, qué campos mostrar, en qué orden, bajo qué condiciones — estas decisiones quedan enterradas en React hooks o Vue composables. Al cambiar de framework o refactorizar, las decisiones se reinterpretan o se pierden.

STML las separa. Las decisiones permanecen en HTML estándar con atributos `data-*`. El cableado del framework se genera o se delega.

<a href="https://github.com/geul-org/stml" target="_blank" rel="noopener">Repositorio GitHub</a>

## Estructura

```
┌─────────────────────────────────┐
│  STML (specs/)                  │  Tus decisiones. Independiente del framework.
│  Qué obtener, mostrar, enviar   │  Sobrevive a cualquier reescritura.
├─────────────────────────────────┤
│  Codegen / LLM                  │  Genera el cableado del framework.
│  React, Vue, Svelte, cualquiera │  Reemplazable.
├─────────────────────────────────┤
│  Runtime (artifacts/)           │  React TSX, Vue SFC, etc.
│  Hooks, estado, renderizado     │  Generado. No editar.
└─────────────────────────────────┘
```

## Lo que se preserva

Todo en el HTML de STML es una decisión del usuario:

- **Qué endpoints API** llamar (`data-fetch`, `data-action`)
- **Qué campos** mostrar o recoger (`data-bind`, `data-field`)
- **En qué orden** aparecen los elementos (estructura DOM)
- **Cómo se ve** (clases Tailwind, etiquetas HTML)
- **Qué texto** ven los usuarios (títulos, placeholders, etiquetas de botones)
- **Qué condiciones** controlan la visibilidad (`data-state`)
- **Qué componentes** manejan UX especial (`data-component`)
- **Comportamiento de listas** — paginación, ordenación, filtrado

No es React. No es Vue. Es lo que hace tu página, declarado en HTML5 estándar.

## Ejemplo

```html
<main class="max-w-4xl mx-auto p-6">
  <h1 class="text-2xl font-bold mb-6">Mis Reservas</h1>

  <section data-fetch="ListMyReservations"
           data-paginate data-sort="StartAt:desc" data-filter="Status">
    <ul data-each="reservations" class="space-y-3">
      <li class="flex justify-between p-4 border rounded">
        <span data-bind="RoomID" class="font-semibold"></span>
        <span data-bind="Status" class="text-sm text-gray-500"></span>
      </li>
    </ul>
    <p data-state="reservations.empty" class="text-gray-400">Sin reservas</p>
  </section>

  <div data-action="CreateReservation">
    <input data-field="RoomID" type="number" placeholder="Número de sala" />
    <button type="submit">Reservar</button>
  </div>
</main>
```

El mismo archivo puede producir diferentes objetivos:

| Objetivo | Cómo |
|---|---|
| React TSX | `stml gen` (codegen determinista integrado) |
| Vue SFC | Dar STML + OpenAPI al LLM: "implementar en Vue" |
| Svelte | Dar STML + OpenAPI al LLM: "implementar en Svelte" |
| Flutter | Dar STML + OpenAPI al LLM: "implementar en Flutter" |

Las decisiones se preservan. Solo cambia el cableado del framework.

## Validación

El validador integrado verifica STML contra OpenAPI antes de generar código:

- ¿Existe el operationId? ¿Es correcto el método HTTP?
- ¿Coinciden los campos de request, response y parámetros con el schema?
- ¿Están las columnas de sort/filter/include en las listas permitidas?
- ¿Existen los componentes referenciados?

Detecta desajustes frontend-API en CI, no en runtime.

```bash
stml validate specs/my-project    # 12 verificaciones simbólicas contra OpenAPI
```

## Atributos data-*

| Atributo | Lo que declara |
|---|---|
| `data-fetch` | Carga datos desde un endpoint GET |
| `data-action` | Envía datos a un endpoint POST/PUT/DELETE |
| `data-field` | Recoge un campo del cuerpo de la solicitud |
| `data-bind` | Muestra un campo de la respuesta |
| `data-param-*` | La operación necesita un parámetro de ruta/query |
| `data-each` | Itera sobre un campo array |
| `data-state` | Se muestra condicionalmente |
| `data-component` | Delega a un componente personalizado |
| `data-paginate` | Lista paginada |
| `data-sort` | Lista ordenable (columna y dirección por defecto) |
| `data-filter` | Lista filtrable (qué columnas) |
| `data-include` | Incluye recursos relacionados |

## Licencia

MIT — <a href="https://github.com/geul-org/stml" target="_blank" rel="noopener">GitHub</a>
