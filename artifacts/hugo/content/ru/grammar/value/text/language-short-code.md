---
title: "LANGUAGE-SHORT-CODE"
weight: 73
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE — Value кода языка GEUL, сжимающий только primary language subtag в 1 WORD (Codec 0x48)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-SHORT-CODE — сжатый код языка GEUL, который хранит не полный тег BCP 47, а только primary language subtag. Payload — ровно 1 WORD.

## Раскладка

- Код: прямой код Value `0x48`. Семейство TEXT.
- Payload — ровно 1 WORD, беззнаковый 16-битный код.

```
TAG WORD          0x08C8 (0000 1000 1100 1000)  всего 2 WORD
Payload WORD 1st (16 бит)           код языка GEUL (uint16)
```

## Интерпретация и допустимость

- 1 WORD Payload читается как беззнаковое 16-битное целое.
- Это значение — сжатый код primary language subtag. Script, region, variant, extension и private-use в него не входят. Если такая информация нужна, используйте [LANGUAGE-BCP47-CODE](/ru/grammar/value/text/language-bcp47-code/) (`0x46`, `0x47`).
- `0x0000..0xfffe` — диапазон назначений GEUL Language Registry. Даже внутри этого диапазона значение, фактически не назначенное в данной версии registry, недопустимо.
- Начальные назначения получают открытые записи `Type: language` конкретного snapshot IANA Language Subtag Registry, кроме `Scope: private-use`. Collections, macrolanguage и special не исключаются.
- При начальном назначении эти открытые записи сортируются по ASCII subtag и получают ID. Физический порядок файла IANA правилом для ID не является.
- Новые subtag `Type: language`, появляющиеся позже, добавляются в конец без изменения существующих номеров (append-only).
- ID deprecated language subtag не удаляется и не используется повторно. Связь Preferred-Value и состояние deprecated сохраняются в metadata registry.
- `0xffff` зарезервирован как escape расширения. Пока формат расширения не определён отдельно, в самостоятельном Value LANGUAGE-SHORT-CODE он недопустим. Его нельзя использовать в смысле `null`, `unknown` или `und`.
- Отдельная схема, например Lemma Edge, в будущем может определить правило интерпретации после `0xffff`. Но это не значит, что такое правило увеличивает длину Payload этого формата или разрешает следующий за ним Payload.
- Некоторые схемы Lemma Edge могут встраивать тот же 1-WORD код как compact field без TAG. Это правило схемы Edge; wire form самостоятельного Value всегда TAG 1 WORD + Payload 1 WORD.
- Чтобы определить смысл значения, нужно вместе с ним сохранять версию GEUL Language Registry и дату snapshot IANA registry, зафиксированного этой версией.

## Основание в стандартах

- Исходный registry primary language subtag и metadata deprecated/Preferred-Value следуют [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- Базовый смысл системы language subtag BCP 47 следует [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- Назначение ID append-only в порядке ASCII, резервирование `0xffff` и отличие от compact-встраивания Lemma без TAG — правила GEUL.

## Длина

- Всего — ровно 2 WORD (TAG 1 WORD и Payload 1 WORD), используется прямая длина `LLLL=0001`. Length extension TAG, descriptor и padding нет.
- Если Payload не равен ровно 1 WORD, значение отклоняется.

## Примеры

- Snapshot registry и реальная таблица кодов ещё не определены, поэтому числовых ID конкретных языков здесь нет.

## Открытые вопросы

- Дата начального snapshot IANA, название версии GEUL Language Registry и полная таблица соответствий. Пока они не определены, конкретные числовые примеры и таблица кодов не фиксируются.
