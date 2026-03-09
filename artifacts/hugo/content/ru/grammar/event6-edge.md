---
title: "Event6 Edge"
weight: 50
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "event6", "5W1H"]
summary: "Edge переменной длины для представления событий по принципу 5W1H (Who, What, Whom, When, Where, Why). Битовая маска Presence реализует переменную структуру от 3 до 8 слов."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Event6 Edge — тип Edge для одновременного выражения **5W1H** (Who, What, Whom, When, Where, Why) в одном событии.

## Элементы 5W1H

| Элемент | Англ. | Бит | Значение | Ссылка на TID |
|---------|-------|-----|----------|---------------|
| Who | Agent | 0 | Действующее лицо | [Entity Node](../entity-node/) |
| What | Action | 1 | Действие | [Verb Edge](../verb-edge/) |
| Whom | Patient | 2 | Объект/пациенс | [Entity Node](../entity-node/) |
| When | Time | 3 | Время | Quantity/Entity |
| Where | Location | 4 | Место | [Entity Node](../entity-node/) |
| Why | Reason | 5 | Причина/цель | [Clause Edge](../clause-edge/)/Entity |

## Структура пакета

```
1st WORD (16 бит)
┌────────────────────┬────────────────────┐
│      Prefix        │     Presence       │
│      10bit         │       6bit         │
└────────────────────┴────────────────────┘

2nd WORD (16 бит)
┌────────────────────────────────────────────┐
│                Edge TID                    │
└────────────────────────────────────────────┘

3rd+ WORD: TID элементов (в порядке Presence)
```

### Битовая маска Presence (6 бит)

| Бит | Элемент | Если установлен |
|-----|---------|-----------------|
| 0 | Who | TID включён |
| 1 | What | TID включён |
| 2 | Whom | TID включён |
| 3 | When | TID включён |
| 4 | Where | TID включён |
| 5 | Why | TID включён |

Всего слов = 2 (заголовок + Edge TID) + popcount(Presence). Диапазон: 3~8 слов (48~128 бит).

## Структура по режимам

### Минимальный режим (3 слова)

```
Пример: «Пошёл дождь» (только What)

1st: [Prefix] + [000010]      - только What
2nd: [Edge TID]
3rd: [What TID]               - "rain" Verb Edge
```

### Ключевой режим (5 слов)

Who + What + Whom. Самая частая конфигурация.

```
Пример: «Иван ударил Петра»

1st: [Prefix] + [000111]      - Who, What, Whom
2nd: [Edge TID]
3rd: [Who TID]                - Иван
4th: [What TID]               - "hit" Verb Edge
5th: [Whom TID]               - Петр
```

### Стандартный режим (6 слов)

```
Пример: «Иван вчера встретил Марию»

1st: [Prefix] + [001111]      - Who, What, Whom, When
2nd: [Edge TID]
3rd: [Who TID]                - Иван
4th: [What TID]               - "meet" Verb Edge
5th: [Whom TID]               - Мария
6th: [When TID]               - вчера
```

### Полный режим (8 слов)

```
Пример: «Иван из любви вчера в школе подарил Марии подарок»

1st: [Prefix] + [111111]      - все элементы
2nd: [Edge TID]
3rd: [Who TID]                - Иван
4th: [What TID]               - "give" Verb Edge
5th: [Whom TID]               - Мария
6th: [When TID]               - вчера
7th: [Where TID]              - школа
8th: [Why TID]                - любовь (причина)
```

## Подробности элементов

### What (действие)

What ссылается на TID [Verb Edge](../verb-edge/). В соответствующем Verb Edge содержится информация о времени, виде и других квалификаторах.

### Why (причина)

Простая причина — TID Entity («любовь»), сложная — TID [Clause Edge](../clause-edge/) («из-за дождя»).

## Сравнение Event6 и Verb Edge

| | Verb Edge | Event6 Edge |
|--|-----------|-------------|
| **Фокус** | Предикат/действие | Завершённое событие |
| **Участники** | Структура Participant | TID по 5W1H |
| **Пространство-время** | Отдельное выражение | When/Where встроены |
| **Причина** | Отдельный Clause | Why встроен |
| **Слов** | 2~5 | 3~8 |
| **Применение** | Предикативное выражение | Хранение событий |

**Руководство по выбору:** Для анализа предикатов/предложений — Verb Edge, для хранения событий/записей — Event6 Edge, для простых фактов — [Triple Edge](../triple-edge/).

## Примеры

### «Apple приобрела Tesla»

```
Who:  Apple (Q312)     → Entity TID 0x0001
What: acquire          → Verb Edge TID 0x0100
Whom: Tesla (Q478214)  → Entity TID 0x0002

Event6 Edge:
  1st: [1100 000 011] + [000111]  - Prefix + Who,What,Whom
  2nd: [TID: 0x0200]              - Edge TID
  3rd: [TID: 0x0001]              - Apple (Who)
  4th: [TID: 0x0100]              - acquire (What)
  5th: [TID: 0x0002]              - Tesla (Whom)

Всего: 5 слов
```

### «Суворов перешёл Альпы в 1799 году в Швейцарии»

```
Who:   Суворов          → Entity TID 0x0010
What:  cross (перейти)   → Verb Edge TID 0x0101
When:  1799             → Entity TID 0x0011
Where: Альпы            → Entity TID 0x0012

Event6 Edge:
  1st: [1100 000 011] + [011011]  - Who,What,When,Where
  2nd: [TID: 0x0202]
  3rd: [TID: 0x0010]              - Суворов
  4th: [TID: 0x0101]              - cross
  5th: [TID: 0x0011]              - 1799
  6th: [TID: 0x0012]              - Альпы

Всего: 6 слов
```

## Разбор

```python
def parse_event6(data: bytes) -> dict:
    word1 = int.from_bytes(data[0:2], 'big')

    prefix = word1 >> 6
    assert prefix == 0b1100000011, "Not Event6 Edge"

    presence = word1 & 0x3F
    edge_tid = int.from_bytes(data[2:4], 'big')

    elements = {}
    element_names = ['who', 'what', 'whom', 'when', 'where', 'why']
    offset = 4

    for i, name in enumerate(element_names):
        if presence & (1 << i):
            tid = int.from_bytes(data[offset:offset+2], 'big')
            elements[name] = tid
            offset += 2

    return {
        'presence': presence,
        'edge_tid': edge_tid,
        'elements': elements,
        'words': 2 + bin(presence).count('1')
    }
```
