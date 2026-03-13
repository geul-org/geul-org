---
title: "Fullend — Full-stack SSOT Orchestrator"
weight: 1
date: 2026-03-09T12:00:00+09:00
lastmod: 2026-03-13T12:00:00+09:00
tags: ["Fullend", "DSL", "SSOT", "cross-validation", "vibe-coding"]
summary: "CLI для перекрёстной валидации 10 SSOT и генерации кода. Заполняет трещины вайб-кодинга структурой."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Full-stack SSOT Orchestrator** — CLI для перекрёстной валидации 10 SSOT и генерации кода.

<a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">Репозиторий на GitHub</a>

## Трещины вайб-кодинга

С распространением вайб-кодинга стала проявляться закономерность.

Просишь AI: «Сделай бронирование» — делает. «Добавь отмену» — добавляет. При добавлении пятой функции ломается вторая. Изменили схему API, но не обновили фронтенд. Добавили колонку в БД, но сервисный слой о ней не знает.

Причина проста: AI не может удержать в памяти весь код.

Что делают люди: обнаружив поломку, говорят AI «Исправь и это». Исправляет — ломается другое. «И это тоже исправь.» Цикл повторяется. Чем больше проект, тем длиннее цикл, и в какой-то момент приходит мысль: «Быстрее переписать с нуля».

## Почему код разрастается

В коде смешаны две вещи.

**Решения**: что показывать, какой API вызывать, в каком порядке обрабатывать, что сохранять.
**Проводка**: код, реализующий эти решения в конкретном фреймворке.

Допустим, мы создаём систему бронирования.

```
Решение: "При отмене брони: проверка прав → поиск → валидация перехода состояния → расчёт возврата → смена статуса → ответ"
```

Это одно решение разбрасывается по React-хукам, Go-обработчикам, SQL-запросам, API-схемам и Terraform-ресурсам. Каждое оборачивается в синтаксис своего фреймворка, обрастает обработкой ошибок и преобразованиями типов.

Из 100 000 строк кода решения занимают 12 500 строк. Остальные 87 500 — проводка.

Контекстное окно AI-агента конечно. При добавлении десятой функции он не помнит предыдущие девять — потому что не может прочитать 100 000 строк целиком.

Если выделить только решения — 12 500 строк. Это 55% контекста в 200K токенов. Размер, который AI может охватить за один раз.

## 10 SSOT

Fullend разделяет все решения программного обеспечения на 10 декларативных спецификаций. Каждая спецификация становится единственным источником истины (SSOT) для своей области ответственности.

| Область ответственности | SSOT | Что декларирует |
|---|---|---|
| Настройки проекта | fullend.yaml | Технический стек, middleware, пути модулей |
| Экран | [STML](/ru/dsl/stml/) (HTML5 + data-*) | Что показывать и что делать |
| API-контракт | OpenAPI 3.x | Какие запросы принимать и какие ответы возвращать |
| Поток сервиса | [SSaC](/ru/dsl/ssac/) (.ssac DSL) | В каком порядке обрабатывать |
| Структура данных | SQL DDL + sqlc | Что хранить |
| Внешние функции | Func Spec (Go) | Интерфейс и реализация кастомной логики |
| Переходы состояний | Mermaid stateDiagram | Какие состояния проходит ресурс |
| Политика авторизации | OPA Rego | Кто что может делать |
| Сценарии | Gherkin (.feature) | Проверка бизнес-потоков между эндпоинтами |
| Инфраструктура | Terraform HCL | Где запускать |

OpenAPI, SQL DDL и Terraform — отраслевые стандарты. Для остальных областей соответствующих SSOT DSL не существовало. Потоки сервиса были рассыпаны по Go-обработчикам, решения фронтенда тонули в React-хуках, переходы состояний прятались в if-else-ветвлениях, права доступа были захардкожены в middleware. Поэтому были спроектированы STML, SSaC, Func Spec, интеграция stateDiagram, интеграция OPA и интеграция Gherkin.

```
specs/my-project/
├── fullend.yaml             → Настройки проекта
├── api/openapi.yaml         → OpenAPI 3.x
├── db/*.sql                 → SQL DDL + sqlc-запросы
├── service/**/*.ssac        → SSaC (расширение .ssac)
├── model/*.go               → Go-структуры (// @dto)
├── func/<pkg>/*.go          → Func Spec
├── states/*.md              → Mermaid stateDiagram
├── policy/*.rego            → OPA Rego
├── scenario/*.feature       → Gherkin
├── frontend/*.html          → STML
└── terraform/*.tf           → HCL
```

`specs/` — источник истины. `artifacts/` можно пересоздать в любой момент.

## Индивидуальная валидация уже существует

Инструменты проверки для нескольких слоёв уже есть.

- sqlc проверяет согласованность DDL и запросов.
- Валидаторы OpenAPI проверяют корректность схемы.
- Terraform проверяет синтаксис и зависимости HCL.

Для STML и SSaC также созданы встроенные валидаторы. SSaC проверяет внутреннюю согласованность потоков сервиса; STML проверяет соответствие UI-деклараций и OpenAPI.

Каждый SSOT может быть проверен внутри себя. Проблемы возникают **между** ними.

Фронтенд отображает поле через `data-bind="memo"`, но в схеме ответа API поля `memo` нет. SSaC вызывает `@delete Reservation.SoftDelete(request.ReservationID)`, но в sqlc-запросах метода `SoftDelete` нет. Диаграмма состояний определяет переход `PublishCourse`, но в SSaC нет соответствующей функции. OPA-политика проверяет владение ресурсом `course` по `courses.instructor_id`, но в DDL такой колонки нет.

Каждый инструмент видит только свой слой. Трещины между слоями остаются невидимыми.

## Скрыть структуру

«Но ведь придётся учить 10 DSL?»

Да. Но структуру не обязательно показывать пользователю.

Если в системный промпт агента заранее заложить технический стек и правила SSOT, пользователю достаточно сказать «Сделай бронирование». Агент сам добавит эндпоинт в OpenAPI, создаст таблицу в DDL, объявит поток сервиса в SSaC, нарисует диаграмму состояний, напишет OPA-политику, нарисует экран в STML и запустит `fullend validate` для проверки согласованности.

Пользователь видит только результат. Структуру потребляет агент, а не изучает пользователь.

Опыт вайб-кодинга остаётся прежним. Меняется одно: за кулисами ничего не ломается.

## Что делает Fullend

Fullend — это перекрёстный валидатор. Он не переизобретает отдельные инструменты. Он вызывает каждый из них и проверяет границы между SSOT.

```bash
fullend validate <specs-dir>
fullend validate --skip states,terraform <specs-dir>
```

Валидирует каждый из 10 SSOT по отдельности, затем выполняет перекрёстную валидацию. Func проверяется только при наличии директории `func/`. Используйте `--skip` для исключения определённых SSOT.

```
✓ Config       my-project, go/gin, typescript/react
✓ OpenAPI      7 endpoints
✓ DDL          3 tables, 18 columns
✓ SSaC         7 service functions
✓ Model        3 files
✓ STML         4 pages, 6 bindings
✓ States       1 diagrams, 3 transitions
✓ Policy       1 files, 5 rules, 3 ownership mappings
✓ Scenario     4 features, 5 scenarios
✓ Func         3 funcs
✓ Terraform    2 files
✓ Cross        0 mismatches

All SSOT sources are consistent.
```

Если какая-либо проверка не пройдена:

```
✓ DDL          3 tables, 18 columns
✓ OpenAPI      7 endpoints
✗ SSaC         CancelReservation
               @delete Reservation.SoftDelete — method not found in sqlc queries
✗ States       course: PublishCourse transition → no SSaC function
✗ Cross        2 mismatches

FAILED: Fix errors before codegen.
```

После прохождения валидации генерируется код. Опция `--skip` работает так же, как и в validate.

```bash
fullend gen <specs-dir> <artifacts-dir>
fullend gen --skip terraform <specs-dir> <artifacts-dir>
```

sqlc генерирует модели БД, oapi-codegen — типы API, SSaC — gin-обработчики, STML — React-компоненты, генерируются пакеты конечного автомата и OPA Authorizer, из Gherkin создаются Hurl-тесты, а Fullend генерирует связующий код между ними.

### gen-model

Генерирует Go-файл модели (интерфейс + типы + HTTP-клиент) из внешнего документа OpenAPI. Принимает локальный путь к файлу или URL.

```bash
fullend gen-model <openapi-source> <output-dir>
fullend gen-model https://api.stripe.com/openapi.yaml ./external/
```

### chain

Отслеживает все SSOT-узлы, связанные с одной API-операцией. На вход — один operationId, на выходе — полная карта файл:строка по всем слоям.

```bash
fullend chain <operationId> <specs-dir>
```

```
── Feature Chain: AcceptProposal ──

  OpenAPI    api/openapi.yaml:296                          POST /proposals/{id}/accept
  SSaC       service/proposal/accept_proposal.ssac:19      @get @empty @auth @state @put @call @post @response
  DDL        db/gigs.sql:1                                 CREATE TABLE gigs
  DDL        db/proposals.sql:1                            CREATE TABLE proposals
  DDL        db/transactions.sql:1                         CREATE TABLE transactions
  Rego       policy/authz.rego:3                           resource: gig
  StateDiag  states/gig.md:7                               diagram: gig → AcceptProposal
  StateDiag  states/proposal.md:6                          diagram: proposal → AcceptProposal
  FuncSpec   func/billing/hold_escrow.go:8                 @func billing.HoldEscrow
  Gherkin    scenario/gig_lifecycle.feature:4              Scenario: Happy Path - Full Gig Lifecycle
```

### status

Показывает сводку обнаруженных SSOT и их статистику.

```bash
fullend status <specs-dir>
```

```
SSOT Status:
  OpenAPI      api/openapi.yaml               7 endpoints
  DDL          db                             3 tables, 18 columns
  SSaC         service                        7 functions
  STML         frontend                       4 pages
  States       states                         1 diagrams, 3 transitions
  Policy       policy                         1 files, 5 rules
  Scenario     scenario                       4 features, 5 scenarios
  Func         func                           3 funcs
```

## Встроенные функции и модели

Fullend поставляется с часто используемыми реализациями функций и интерфейсами моделей. Их можно вызывать через `@call` в SSaC.

### Стандартные функции (pkg/)

| Пакет | Функция | Описание |
|---|---|---|
| `auth` | `hashPassword` | Хеширование пароля bcrypt |
| `auth` | `verifyPassword` | Проверка пароля bcrypt |
| `auth` | `issueToken` | Генерация JWT access-токена (24 ч) |
| `auth` | `verifyToken` | Проверка JWT-токена + извлечение claims |
| `auth` | `refreshToken` | Генерация refresh-токена (7 дней) |
| `auth` | `generateResetToken` | Случайный hex-токен для сброса пароля |
| `crypto` | `encrypt` | Симметричное шифрование AES-256-GCM |
| `crypto` | `decrypt` | Расшифровка AES-256-GCM |
| `crypto` | `generateOTP` | TOTP-секрет + URL для QR-кода |
| `crypto` | `verifyOTP` | Проверка TOTP-кода |
| `storage` | `uploadFile` | Загрузка файла (S3-совместимая) |
| `storage` | `deleteFile` | Удаление файла (S3-совместимое) |
| `storage` | `presignURL` | Предподписанный URL для скачивания из S3 |
| `mail` | `sendEmail` | Отправка текстового письма через SMTP |
| `mail` | `sendTemplateEmail` | HTML-письмо на основе Go-шаблона через SMTP |
| `text` | `generateSlug` | Unicode в URL-безопасный slug |
| `text` | `sanitizeHTML` | Санитизация HTML для защиты от XSS |
| `text` | `truncateText` | Unicode-безопасное усечение текста |
| `image` | `ogImage` | Генерация OG-изображения (1200x630, PNG) |
| `image` | `thumbnail` | Генерация миниатюры (200x200, PNG) |

Проекты могут переопределить эти функции, поместив собственные реализации в `specs/<project>/func/<pkg>/`.

### Встроенные модели (pkg/)

Интерфейсы @model с пакетным префиксом для нереляционного ввода-вывода. Настраиваются через `fullend.yaml`.

| Пакет | Интерфейс | Бэкенды | Использование в SSaC |
|---|---|---|---|
| `session` | `SessionModel` (Set/Get/Delete + TTL) | PostgreSQL, Memory | `session.Session.Get({key: ...})` |
| `cache` | `CacheModel` (Set/Get/Delete + TTL) | PostgreSQL, Memory | `cache.Cache.Set({key: ..., value: ..., ttl: ...})` |
| `file` | `FileModel` (Upload/Download/Delete) | S3, LocalFile | `file.File.Upload({key: ..., body: ...})` |
| `queue` | Singleton Pub/Sub (Publish/Subscribe) | PostgreSQL, Memory | `@publish "topic" {payload}` |

### Middleware (генерируемый)

Fullend генерирует проектный `internal/middleware/bearerauth.go` из конфигурации claims в `fullend.yaml`.

| Middleware | Триггер | Описание |
|---|---|---|
| `BearerAuth(secret)` | `securitySchemes.bearerAuth` + `backend.auth.claims` | Извлекает JWT и устанавливает `*model.CurrentUser` в контексте gin |

Группировка маршрутов определяется полем `security` в OpenAPI. Операции с `security: [{bearerAuth: []}]` попадают в auth-группу; операции без — в публичную группу.

## Правила перекрёстной валидации

Уникальная ценность Fullend — в перекрёстной валидации. После того как каждый инструмент проверит свой слой, Fullend выявляет несоответствия между SSOT.

**fullend.yaml ↔ OpenAPI**
| Объект проверки | Правило |
|---|---|
| Имя middleware | Совпадает ли с ключом securitySchemes? |

**OpenAPI ↔ DDL**
| Объект проверки | Правило |
|---|---|
| x-sort.allowed | Существует ли колонка в таблице? |
| x-sort ↔ DDL index | Есть ли индекс на колонку? (WARNING) |
| x-filter.allowed | Существует ли колонка в таблице? |
| x-include.allowed | Связана ли таблица через FK? |

**SSaC ↔ DDL**
| Объект проверки | Правило |
|---|---|
| Model.Method | Существует ли метод в sqlc-запросах? |
| @result Type | Совпадает ли тип с производным от DDL-таблицы? |
| Поля аргументов | Можно ли их сопоставить с колонками DDL? |

**SSaC ↔ OpenAPI**
| Объект проверки | Правило |
|---|---|
| Имя функции | Совпадает ли с operationId? |
| Аргументы request | Существует ли поле в схеме запроса? |
| Поля @response | Существует ли поле в схеме ответа? |

**States ↔ SSaC ↔ OpenAPI ↔ DDL**
| Объект проверки | Правило |
|---|---|
| Событие перехода | Совпадает ли с именем функции SSaC? |
| Событие перехода | Совпадает ли с operationId OpenAPI? |
| SSaC @state | Существует ли ссылаемая stateDiagram? |
| Поле @state | Существует ли как колонка DDL? |

**Policy ↔ SSaC ↔ DDL ↔ States**
| Объект проверки | Правило |
|---|---|
| allow (action, resource) | Совпадает ли с SSaC @auth? |
| @ownership table.column | Существует ли в DDL? |
| @ownership via join | Существует ли FK join-таблицы в DDL? |
| Событие перехода состояния | Есть ли соответствующее правило Rego для переходов с @auth? |

**Func ↔ SSaC**
| Объект проверки | Правило |
|---|---|
| Ссылка @call | Есть ли соответствующая реализация Func? |
| Количество аргументов | Совпадает ли число аргументов @call с количеством полей Request? |
| Типы аргументов | Совпадают ли позиционные типы через DDL/OpenAPI? |
| Результат/ответ | Согласованы ли result/response? |
| Тело функции | Не является ли заглушкой TODO? (WARNING) |

**Scenario ↔ OpenAPI ↔ States**
| Объект проверки | Правило |
|---|---|
| operationId | Существует ли в OpenAPI? |
| HTTP method | Совпадает ли с методом OpenAPI? |
| Поля JSON | Существуют ли в схеме запроса? |
| Порядок шагов | Соответствует ли правилам перехода состояний? |

**Queue (Pub/Sub)**
| Объект проверки | Правило |
|---|---|
| @publish topic | Есть ли соответствующая функция @subscribe? |
| Поля payload/message | Согласованы ли они? |
| Конфигурация очереди | Есть ли конфигурация queue в fullend.yaml? |

**STML ↔ SSaC** — оба ссылаются на один и тот же operationId OpenAPI. Если обе проверки пройдены, соответствие API, вызываемого фронтендом, и API, обрабатываемого бэкендом, гарантируется автоматически.

## Тестирование в рантайме

`fullend gen` генерирует тесты [Hurl](https://hurl.dev) из спецификаций OpenAPI и сценариев Gherkin.

```bash
# После запуска сервера:
hurl --test --variable host=http://localhost:8080 artifacts/my-project/tests/*.hurl
```

Генерируемые тесты:
- **smoke.hurl** — smoke-тесты эндпоинтов OpenAPI (автогенерация)
- **scenario-*.hurl** — тесты бизнес-сценариев (из файлов .feature)
- **invariant-*.hurl** — тесты межэндпоинтных инвариантов (из файлов .feature)

## Спроектирован для агентов

Fullend спроектирован для AI-агентов.

Чтобы агент мог писать спецификации, ему нужно знать 10 типов последовательностей SSaC, атрибуты data-* STML, расширения OpenAPI x-, правила stateDiagram, шаблоны OPA-политик, синтаксис Gherkin-сценариев, правила Func Spec и правила сопоставления имён. Для этого предоставляется руководство для AI объёмом около 830 строк. Его достаточно один раз добавить в системный промпт агента.

Цикл валидации после написания спецификаций прост.

```
Рабочий процесс агента:
1. Изменить specs/
2. fullend validate specs/my-project
3. Есть ошибки → исправить соответствующий SSOT → перейти к шагу 2
4. Ошибок 0 → fullend gen specs/my-project artifacts/my-project
```

Не нужно понимать всю систему. Достаточно исправить то, на что указывает validate, — и согласованность восстанавливается. Умная модель попадает с первого раза, маленькая — с третьего. Результат одинаков.

## Размер SSOT по масштабу

| Масштаб | Пример | SSOT | Код реализации | Доля контекста |
|---|---|---|---|---|
| Малый | Запись в салон | ~1 500 строк | ~10 000 строк | ~8% |
| Средний | Уровня Jira/Notion | ~12 500 строк | ~100 000 строк | ~55% |
| Крупный | Уровня Shopify | ~30 000 строк | ~300 000 строк | ~90% |

При контексте в 200K токенов. Для среднего SaaS агент может прочитать всю архитектуру за один раз.

## Превращение исключений в паттерны

То, что не укладывается в 10 типов последовательностей, уходит в `@call`. То, что не выражается через data-*, уходит в `custom.ts`. Если эти аварийные выходы превышают 20% от целого, смысл структуризации размывается.

Однако исключение, будучи изолированным, становится наблюдаемым. Когда множество проектов будут структурированы через Fullend, в `@call` и `custom.ts` проявятся повторяющиеся паттерны.

10 типов последовательностей SSaC не были спроектированы заранее. Они сходились к десяти в результате наблюдения сотен реализаций сервисного кода. Тот же принцип повторится и с аварийными выходами. Часто встречающиеся паттерны `@call` станут новыми типами последовательностей; часто встречающиеся паттерны `custom.ts` — новыми атрибутами data-*.

Исключения не уменьшаются — из исключений вырастает структура.

## Расширение технического стека

Сейчас Fullend привязан к Go(gin) + React + PostgreSQL + Terraform. Это намеренно. На стадии PoC важнее пройти один стек насквозь.

Однако значительная часть из 10 SSOT (OpenAPI, SQL DDL, Terraform, Mermaid, OPA Rego, Gherkin) уже не зависит от языка. 10 типов последовательностей SSaC — паттерны, не привязанные к языку; они лишь выражены через Go-комментарии. STML использует атрибуты HTML5 data-*, не зависящие от фреймворка.

Расширение сводится к добавлению бэкендов кодогенерации. Логика валидации и правила перекрёстной проверки остаются прежними.

## Связь с GEUL

10 SSOT составляют совокупность всех решений программного обеспечения. SSOT — это структурированные данные. Структурированные данные — это граф. Граф можно закодировать в GEUL.

`data-fetch="ListReservations"` в STML — это связь между сущностями. `@get → @empty → @state → @call → @put → @response` в SSaC — это последовательность событий. Переходы в stateDiagram — это граф состояний. OPA-политики — это связи авторизации. Определения эндпоинтов OpenAPI — это контракты. Всё это семантические структуры, выразимые через тройные рёбра, рёбра event6 и узлы сущностей GEUL.

Способ, которым Fullend выполняет перекрёстную валидацию 10 SSOT — символьное сопоставление, проверка типовой согласованности, контроль ссылочной целостности — основан на том же принципе, что и механическая верификация в потоках GEUL.

## Лицензия

MIT — <a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">GitHub</a>
