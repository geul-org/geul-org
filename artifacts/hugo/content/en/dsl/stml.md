---
title: "STML — SSOT Template Markup Language"
weight: 2
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-08T12:00:00+09:00
tags: ["STML", "DSL", "SSOT", "frontend", "React", "OpenAPI"]
summary: "A framework-independent UI declaration language. Define what pages show and do with HTML5 data-* attributes, validate symbolically against OpenAPI, and generate React code."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**SSOT Template Markup Language** — framework-independent UI declaration.

Frontend code mixes two things: **your decisions** and **framework wiring**. Which API to call, which fields to show, in what order, under what conditions — these decisions get buried inside React hooks or Vue composables. When you switch frameworks or refactor, decisions get reinterpreted or lost.

STML separates them. Decisions stay in standard HTML with `data-*` attributes. Framework wiring is generated or delegated.

<a href="https://github.com/geul-org/stml" target="_blank" rel="noopener">GitHub Repository</a>

## Structure

```
┌─────────────────────────────────┐
│  STML (specs/)                  │  Your decisions. Framework-independent.
│  What to fetch, show, submit    │  Survives any rewrite.
├─────────────────────────────────┤
│  Codegen / LLM                  │  Generates framework wiring.
│  React, Vue, Svelte, anything   │  Replaceable.
├─────────────────────────────────┤
│  Runtime (artifacts/)           │  React TSX, Vue SFC, etc.
│  Hooks, state, rendering        │  Generated. Do not edit.
└─────────────────────────────────┘
```

## What Gets Preserved

Everything in STML HTML is a user decision:

- **Which API endpoints** to call (`data-fetch`, `data-action`)
- **Which fields** to display or collect (`data-bind`, `data-field`)
- **What order** elements appear (DOM structure)
- **What it looks like** (Tailwind classes, HTML tags)
- **What text** users see (headings, placeholders, button labels)
- **What conditions** control visibility (`data-state`)
- **What components** handle special UX (`data-component`)
- **How lists behave** — pagination, sorting, filtering

None of this is React. None of this is Vue. It's what your page does, declared in standard HTML5.

## Example

```html
<main class="max-w-4xl mx-auto p-6">
  <h1 class="text-2xl font-bold mb-6">My Reservations</h1>

  <section data-fetch="ListMyReservations"
           data-paginate data-sort="StartAt:desc" data-filter="Status">
    <ul data-each="reservations" class="space-y-3">
      <li class="flex justify-between p-4 border rounded">
        <span data-bind="RoomID" class="font-semibold"></span>
        <span data-bind="Status" class="text-sm text-gray-500"></span>
      </li>
    </ul>
    <p data-state="reservations.empty" class="text-gray-400">No reservations</p>
  </section>

  <div data-action="CreateReservation">
    <input data-field="RoomID" type="number" placeholder="Room number" />
    <button type="submit">Reserve</button>
  </div>
</main>
```

The same file can produce different targets:

| Target | How |
|---|---|
| React TSX | `stml gen` (built-in deterministic codegen) |
| Vue SFC | Give STML + OpenAPI to LLM: "implement in Vue" |
| Svelte | Give STML + OpenAPI to LLM: "implement in Svelte" |
| Flutter | Give STML + OpenAPI to LLM: "implement in Flutter" |

Decisions are preserved. Only the framework wiring changes.

## Validation

The built-in validator cross-checks STML against OpenAPI before any code is generated:

- Does the operationId exist? Is the HTTP method correct?
- Do request fields, response fields, and parameters match the schema?
- Are sort/filter/include columns within the allowed lists?
- Do referenced components exist?

Catches frontend-API mismatches at CI time, not at runtime.

```bash
stml validate specs/my-project    # 12 symbolic checks against OpenAPI
```

## data-* Attributes

| Attribute | What it declares |
|---|---|
| `data-fetch` | Loads data from a GET endpoint |
| `data-action` | Submits data to a POST/PUT/DELETE endpoint |
| `data-field` | Collects a request body field |
| `data-bind` | Displays a response field |
| `data-param-*` | Operation needs a path/query parameter |
| `data-each` | Repeats over an array field |
| `data-state` | Shows conditionally |
| `data-component` | Delegates to a custom component |
| `data-paginate` | Paginated list |
| `data-sort` | Sortable list (default column and direction) |
| `data-filter` | Filterable list (which columns) |
| `data-include` | Includes related resources |

## License

MIT — <a href="https://github.com/geul-org/stml" target="_blank" rel="noopener">GitHub</a>
