---
title: "UUID"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "UUID — Value фиксированной длины 9 WORD, хранящий 128 bit UUID по RFC 9562 как canonical 16 octet."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UUID — это Value фиксированной ширины, хранящий 128-битное значение UUID по RFC 9562. Прямой код Value `0x60`, семейство BINARY. Payload — ровно 8 WORD (16 octet, 128 bit).

## Раскладка

```
TAG WORD          0x0C60 (0000 1100 0110 0000)  всего 9 WORD
Payload           8 WORD (128 бит)  octet 0 → octet 15 UUID
```

## Интерпретация и допустимость

- Canonical octet UUID по RFC 9562 с octet 0 по octet 15 по порядку группируются по два octet. Первый octet — старшие 8 bit WORD. Field, version bit и variant bit UUID не переставляются и не кодируются заново.
- Строка hex-and-dash вида `8-4-4-4-12` — лишь представление для ввода-вывода. Регистр и дефисы в Payload не попадают, сохраняются только 16 octet — результат разбора.
- Этот Value UUID без потерь сохраняет 128-битный pattern. При variant `10xx` из RFC 9562 version 1, 3, 4, 5, 6, 7 — стандартный layout, а version 8 — custom UUID format. Version 2 зарезервирована для DCE Security, и layout для неё RFC не задаёт; version 0 unused, version 9–15 зарезервированы для будущих определений. Остальные variant тоже зарезервированы для совместимости или будущих определений.
- Nil UUID — специальное значение из 128 нулевых bit, Max UUID — из 128 единичных bit. Структурно не исключаются и 128-битные pattern с зарезервированными или unused version/variant; их смысл и совместимость определяются применимым стандартом и внешним контекстом.
- Идентичность UUID определяется равенством 128-битных значений в Payload. Равенство значений не гарантирует аутентификацию объекта, владение, его текущее существование, разрешимость и права доступа.
- При хранении Microsoft COM GUID нельзя копировать его mixed-endian представление в памяти или при сериализации как есть. Сначала его нужно перевести в 16 octet в canonical порядке field/octet из RFC 9562.
- Если Payload не равен ровно 8 WORD, значение отклоняется.

## Основание в стандартах

- [RFC 9562 — Universally Unique IDentifiers (UUIDs)](https://www.rfc-editor.org/rfc/rfc9562.html) определяет UUID как 16 octet (128 bit) и требует кодировать field в порядке most-significant-byte-first, так что в binary format field идут подряд в порядке big-endian. Variant находится в старших bit octet 8, version — в старших 4 bit octet 6; этот формат сохраняет эти позиции без изменений.
- RFC 9562, разделы 4.1–5.10, различает variant, version 1–8, Nil, Max и зарезервированные диапазоны. RFC 9562 заменяет RFC 4122, поэтому действующая норма этого формата — RFC 9562.
- Hex-and-dash ABNF из RFC 9562 — текстовое представление, а оговорку о little-endian у COM GUID RFC указывает отдельно. GEUL кладёт в Payload только canonical 16 octet UUID по RFC.
- GEUL TAG, прямая Length и framing 16-битными WORD — не часть RFC 9562, а правила, которые добавляет этот формат.

## Длина

- Всего ровно 9 WORD: 1 WORD TAG и 8 WORD Payload; используется прямая длина `LLLL=1000`. Расширяющего Length TAG, descriptor и padding нет.
- Если Payload не равен ровно 8 WORD, значение отклоняется.

## Примеры

Тестовый вектор UUIDv7 из RFC 9562, Appendix A.6, `017f22e2-79b0-7cc3-98c4-dc0c0c07398f`:

```
0c60 017f 22e2 79b0 7cc3 98c4 dc0c 0c07 398f
```

- TAG `0c60`, Payload `017f 22e2 79b0 7cc3 98c4 dc0c 0c07 398f`.
