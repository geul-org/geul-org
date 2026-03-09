---
title: "SSaC — Service Sequences as Code"
weight: 2
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-08T12:00:00+09:00
tags: ["SSaC", "DSL", "SSOT", "Go", "codegen"]
summary: "Объявление сервисной логики в комментариях Go и генерация кода реализации. 10 фиксированных типов последовательностей покрывают все операции бинарного контракта на сервисном уровне."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Service Sequences as Code** — генерация сервисного кода из DSL Go-комментариев.

Сервисная логика — это серия решений: какую модель запросить, от чего защититься, когда отклонить, что вернуть. Эти решения принадлежат тому, кто понимает бизнес — но они тонут в шаблонном коде, разбросаны по слоям и теряются при переписывании.

SSaC сохраняет эти решения как декларативную спецификацию. Вы объявляете **что** происходит и **в каком порядке**. Инструмент генерирует реализацию.

```
specs/service/*.go  →  ssac validate  →  ssac gen  →  artifacts/service/*.go
```

<a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub</a>

## Ключевая идея

Каждая сервисная функция — последовательность шагов. Каждый шаг следует бинарному контракту: **успех → следующая строка, неудача → return**. Это не абстракция, которую мы изобрели — так сервисная логика уже работает. SSaC делает это явным.

10 фиксированных типов последовательностей покрывают все операции сервисного уровня, следующие этому контракту. Что не подходит — делегируется в `call`. Множество закрыто по дизайну.

Без LLM, без вывода — чистая символьная кодогенерация из шаблонов. Спецификация — единственный источник истины.

## Пример

```go
// @sequence get
// @model Project.FindByID
// @param ProjectID request
// @result project Project

// @sequence guard nil project
// @message "project not found"

// @sequence post
// @model Session.Create
// @param ProjectID request
// @param Command request
// @result session Session

// @sequence response json
// @var session
func CreateSession(w http.ResponseWriter, r *http.Request) {}
```

Эта 10-строчная декларация генерирует следующий код:

```go
func CreateSession(w http.ResponseWriter, r *http.Request) {
    projectID := r.FormValue("ProjectID")
    command := r.FormValue("Command")

    project, err := projectModel.FindByID(projectID)
    if err != nil {
        http.Error(w, "Project lookup failed", http.StatusInternalServerError)
        return
    }

    if project == nil {
        http.Error(w, "project not found", http.StatusNotFound)
        return
    }

    session, err := sessionModel.Create(projectID, command)
    if err != nil {
        http.Error(w, "Session creation failed", http.StatusInternalServerError)
        return
    }

    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(map[string]interface{}{
        "session": session,
    })
}
```

## Типы последовательностей (10)

| Тип | Роль |
|---|---|
| `authorize` | Проверка прав (OPA и т.д.) |
| `get` | Поиск ресурса |
| `guard nil` | Выход при null |
| `guard exists` | Выход при наличии |
| `post` | Создание ресурса |
| `put` | Обновление ресурса |
| `delete` | Удаление ресурса |
| `password` | Сравнение паролей |
| `call` | Внешний вызов (@component / @func) |
| `response` | Возврат ответа (json) |

## Возможности кодогенерации

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
      allowed: [room, user]
```

## Лицензия

MIT — <a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub</a>
