---
title: "Por qué los comentarios deben ser índices"
weight: 20
date: 2026-03-01T15:00:00+09:00
lastmod: 2026-03-01T15:00:00+09:00
tags: ["índice", "anotación", "código", "AST", "patrón-de-diseño"]
summary: "Los comentarios se escriben para humanos. Pero cuando hay 10.000 funciones, las máquinas también deben leerlos. Si convertimos los comentarios de narrativa a índice, el escaneo completo se convierte en búsqueda instantánea."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Los comentarios se escriben para humanos.

```go
// GetUser retrieves a user by ID from the database.
func GetUser(id string) (*User, error) {
```

Este comentario es útil cuando lo lee un humano. Pero cuando lo lee una máquina, no sabe nada. No sabe si "retrieves" significa Read o Search. No sabe qué entidad es "user". No sabe si esta función sigue el patrón Service o el patrón Repository.

Es porque el comentario es una narrativa.

---

## Cuando hay 10.000 funciones

Cuando hay 10 funciones, no importa. Un humano puede leerlas todas.

Cuando hay 10.000 funciones, es diferente. Cuando pides "muéstrame todas las funciones relacionadas con pagos", ni los humanos ni las máquinas pueden encontrarlas. Solo encuentran las que tienen "payment" en el nombre. Si no está en el nombre, se pierden.

Lo mismo ocurre cuando un agente de IA modifica código. Si le dices a Claude Code "corrige el manejo del error PaymentFailed", el agente vuelve a leer todo el código. Cada vez. Analiza 10.000 funciones desde cero cada vez. El código que leyó ayer lo lee otra vez hoy. Aunque haya comentarios, da igual. Porque los comentarios son narrativas para humanos. Para que una máquina extraiga significado de una narrativa, necesita inferencia. Y eso es costoso.

---

## Si los comentarios fueran índices

```go
// CreateOrder processes a new order creation.
//
// # Pattern: Service, Transactional
// # Entity: Order
// # Action: Create
// # Input: CreateOrderRequest {items:[]Item, userID:string}
//          pre: items>0 userID!=''
// # Output: *OrderResponse, error
//          errs: [StockInsufficient, PaymentFailed]
// # Deps: InventorySvc, PaymentGateway
func (s *OrderService) CreateOrder(req CreateOrderRequest) (*OrderResponse, error) {
```

Este comentario lo pueden leer tanto humanos como máquinas.

"Todas las funciones con patrón Service" → búsqueda por campo Pattern. Instantáneo.
"Todas las funciones relacionadas con la entidad Order" → búsqueda por campo Entity. Instantáneo.
"Funciones que generan PaymentFailed" → búsqueda por campo errs. Instantáneo.

El escaneo completo se convierte en búsqueda por índice. O(n) se convierte en O(1).

---

## No es necesario que los humanos lo escriban

No es necesario que los humanos escriban este índice.

Cuando se modifica el código, se detecta automáticamente. Monitoreo de archivos.
La función modificada se separa mediante AST. Mecánicamente.
El cuerpo de la función se pasa a un LLM pequeño. "Determina el patrón, la entidad y la acción de esta función."
El resultado se inserta en el formato definido. Mecánicamente.

El humano no hace nada. Solo escribe código. El índice se agrega automáticamente.

En todo el pipeline, el LLM interviene en un solo punto: determinar el significado de la función. Todo lo demás es código determinista.

---

## De la inferencia a las reglas

Se puede ir un paso más allá.

Cuando el LLM pequeño asigna repetidamente el mismo índice al mismo patrón, se detecta esa repetición. Si "sufijo Service con método receiver implica Pattern:Service" se repitió 100 veces, se consolida como regla. A partir de entonces no se llama al LLM. La regla se encarga.

Las llamadas al LLM disminuyen progresivamente. Las reglas aumentan progresivamente. El costo converge a cero.

Los comentarios pasan de narrativa a índice,
el índice pasa de manual a automático,
y lo automático pasa de inferencia a reglas.

---

## Por qué es posible: los patrones de diseño como libro de códigos

Hay una razón por la que esto es posible.

La programación ya cuenta con un vocabulario semántico estandarizado. Son los patrones de diseño.

Singleton, Factory, Observer, MVC, Service. Desde que el GoF sistematizó 23 patrones en 1994, la industria del software ha expandido y estandarizado este vocabulario durante 30 años.

Los 23 patrones GoF. Enterprise Application Patterns. Cloud Design Patterns. Go Concurrency Patterns. Todo ya está sistematizado.

Este vocabulario no es ambiguo. Singleton es Singleton. Los desarrolladores no lo interpretan de manera diferente. Las definiciones están consensuadas, las condiciones de implementación son claras, y las violaciones se detectan en la revisión de código.

Este sistema de vocabulario se convierte en el libro de códigos del índice. No es necesario crear uno nuevo. Ya existe.

El lenguaje natural no tiene esto. "Grandioso" tiene una definición en el diccionario, pero cada persona lo usa de manera diferente. En el código, Service no se usa de manera diferente según la persona.

---

## Por qué el código es el dominio más fácil

El pipeline de contexto de GEUL — [clarificación](/es/why/clarification/), [indexación](/es/why/semantically-aligned-index/), [verificación](/es/why/mechanical-verification/), [filtrado](/es/why/filter/), [consistencia](/es/why/consistency-check/), [exploración](/es/why/exploration/) — es difícil de aplicar al lenguaje natural. Aplicarlo al código es fácil.

Clarificación: el lenguaje natural es ambiguo. Si el código pasa el compilador, su significado está determinado.
Indexación: las entidades del lenguaje natural requieren contexto para identificarse. Las entidades del código ya están parseadas por el AST.
Verificación: la validez del lenguaje natural no se puede definir. La validez del código la determina el compilador.
Filtrado: la relevancia del lenguaje natural debe ser juzgada por un LLM. La relevancia del código se puede determinar mecánicamente mediante el grafo de llamadas.
Consistencia: las contradicciones del lenguaje natural requieren inferencia para descubrirse. Las contradicciones del código las detectan el sistema de tipos y las pruebas.
Exploración: el conocimiento en lenguaje natural es plano. El código ya tiene una estructura jerárquica: paquete → archivo → tipo → método.

El mismo pipeline funciona con mucho menor costo en el dominio del código. Demostrar primero en el lugar más fácil y luego expandir hacia lo más difícil. Eso es ingeniería.

---

## Resumen

Los comentarios originalmente eran para humanos.
Ahora también deben ser para máquinas.
Comentarios que los humanos puedan leer, pero que las máquinas puedan buscar.
Comentarios que sean narrativa y al mismo tiempo índice.

El código ya tiene significado, ya tiene estructura, ya tiene vocabulario.
Lo único que falta es el índice.
Basta con que los comentarios se conviertan en ese índice.
