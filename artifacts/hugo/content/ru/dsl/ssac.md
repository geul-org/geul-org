---
title: "SSaC — Service Sequences as Code"
weight: 3
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-10T12:00:00+09:00
tags: ["SSaC", "DSL", "SSOT", "Go", "codegen"]
summary: "Один комментарий Go — одна последовательность. 10 фиксированных типов последовательностей покрывают все бинарные ветвления на сервисном уровне, а символьная кодогенерация создаёт gin-обработчики."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Service Sequences as Code** — один комментарий Go — одна последовательность. Объявите — и gin-обработчик будет сгенерирован.

Сервисная логика — это серия решений: какую модель запросить, от чего защититься, когда отклонить, что вернуть. Эти решения принадлежат тому, кто понимает бизнес, — но они тонут в шаблонном коде, разбросаны по слоям и теряются при переписывании.

SSaC сохраняет эти решения как декларативную спецификацию. Объявите **что** происходит и **в каком порядке**, по одной строке, — и инструмент сгенерирует реализацию.

```
specs/service/*.go  →  ssac validate  →  ssac gen  →  artifacts/service/*.go
   (комментарии DSL)     (валидация)      (кодогенерация)  (gin + gofmt)
```

<a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">Репозиторий на GitHub</a>

## Ключевая идея

Каждая сервисная функция — последовательность шагов. Каждый шаг следует бинарному контракту: **успех → следующая строка, неудача → return**. Это не абстракция, которую мы изобрели — так сервисная логика уже работает. SSaC делает это явным.

10 фиксированных типов последовательностей покрывают все операции сервисного уровня, следующие этому контракту. Что не подходит — делегируется в `@call`. Множество закрыто по дизайну.

Без LLM, без вывода — чистая символьная кодогенерация из шаблонов. Спецификация — единственный источник истины.

## Синтаксис — одна строка, одна последовательность

Начиная с v2 каждая последовательность — это одна строка комментария. Только `@response` использует многострочный блок.

**CRUD — операции с моделями**

```go
// @get Type var = Model.Method(args...)        — чтение (результат обязателен)
// @post Type var = Model.Method(args...)       — создание (результат обязателен)
// @put Model.Method(args...)                   — обновление (без результата)
// @delete Model.Method(args...)                — удаление (без результата)
```

Формат аргументов: `source.Field` или `"литерал"`

- `request.CourseID` — из HTTP-запроса
- `course.InstructorID` — из переменной предыдущего результата
- `currentUser.ID` — из контекста авторизации
- `"cancelled"` — строковый литерал

**Гарды**

```go
// @empty target "message"                      — ошибка при nil/zero (404)
// @exists target "message"                     — ошибка при не-nil/zero (409)
```

Цель: переменная (`course`) или переменная.поле (`course.InstructorID`)

**Переходы состояний**

```go
// @state diagramID {key: var.Field, ...} "transition" "message"
```

**Проверка прав — OPA**

```go
// @auth "action" "resource" {key: var.Field, ...} "message"
```

**Внешние вызовы**

```go
// @call Type var = package.Func(args...)       — с результатом
// @call package.Func(args...)                  — без результата
```

**Ответ — блок маппинга полей**

```go
// @response {
//   fieldName: variable,
//   fieldName: variable.Member,
//   fieldName: "literal"
// }
```

## Пример

```go
package service

import "myapp/auth"

// @auth "cancel" "reservation" {id: request.ReservationID} "нет доступа"
// @get Reservation reservation = Reservation.FindByID(request.ReservationID)
// @empty reservation "бронирование не найдено"
// @state reservation {status: reservation.Status} "cancel" "отмена невозможна"
// @call Refund refund = billing.CalculateRefund(reservation.ID, reservation.StartAt, reservation.EndAt)
// @put Reservation.UpdateStatus(request.ReservationID, "cancelled")
// @get Reservation reservation = Reservation.FindByID(request.ReservationID)
// @response {
//   reservation: reservation,
//   refund: refund
// }
func CancelReservation() {}
```

10 строк объявлений. Каждая строка — одна последовательность, выполняемая сверху вниз по порядку. Авторизация → чтение → гард → переход состояния → внешний вызов → обновление → повторное чтение → ответ.

## Типы последовательностей (10)

| Тип | Роль |
|---|---|
| `@auth` | Проверка прав (OPA-политика) |
| `@get` | Чтение ресурса |
| `@empty` | Выход при nil/zero (404) |
| `@exists` | Выход при не-nil/zero (409) |
| `@post` | Создание ресурса |
| `@put` | Обновление ресурса |
| `@delete` | Удаление ресурса |
| `@state` | Валидация перехода состояния |
| `@call` | Вызов функции внешнего пакета |
| `@response` | Возврат ответа (маппинг полей) |

## Валидация

Внутренняя валидация (всегда):
- Отсутствие обязательных аргументов по типу
- Формат `Model.Method`
- Поток переменных (ссылка до объявления)

Внешняя перекрёстная валидация SSOT (при обнаружении структуры проекта):
- Существование модели/метода (sqlc-запросы, Go-интерфейсы)
- Существование полей запроса/ответа (OpenAPI)
- Существование пакета/функции (Go-интерфейсы)
- Предупреждение об устаревших данных: response после put/delete без повторного чтения (WARNING)
- Существование диаграммы состояний и валидность переходов
- Существование файла OPA-политики

## Возможности кодогенерации

При наличии внешних SSOT (таблиц символов) `ssac gen` предоставляет дополнительные возможности. Генерируемый код использует фреймворк gin.

- **Преобразование типов**: типы столбцов DDL → `strconv.ParseInt`, `time.Parse`, ранний возврат 400 Bad Request
- **Типы значений гардов**: типозависимые проверки на ноль (`int` → `== 0`/`> 0`, указатель → `== nil`/`!= nil`)
- **Вывод интерфейсов моделей**: перекрёстная проверка 3 источников SSOT → `<outDir>/model/models_gen.go`
- **Кодогенерация @state**: вызов `CanTransition` из пакета диаграммы состояний
- **Кодогенерация @auth**: вызов `authz.Check(currentUser, "action", "resource", authz.Input{...})`
- **Кодогенерация @call**: стиль гарда (401) без результата, стиль значения (500) с результатом
- **Доменная структура папок**: `service/auth/login.go` → `outDir/auth/login.go`, `package auth`

## Расширения OpenAPI x-

Инфраструктурные параметры (пагинация, сортировка, фильтрация, включение связей) объявляются в расширениях OpenAPI `x-`. В спецификациях SSaC объявляются только бизнес-параметры. Кодогенератор читает `x-` и автоматически формирует `QueryOpts`.

```yaml
/api/reservations:
  get:
    operationId: ListReservations
    x-pagination:
      style: offset
      defaultLimit: 20
      maxLimit: 100
    x-sort:
      allowed: [start_at, created_at]
      default: start_at
      direction: desc
    x-filter:
      allowed: [status, room_id]
    x-include:
      allowed: [room_id:rooms.id, user_id:users.id]
```

## Лицензия

MIT — <a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">Репозиторий на GitHub</a>
