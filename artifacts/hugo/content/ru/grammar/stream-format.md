---
title: "Формат потока"
weight: 100
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "stream", "TID"]
summary: "Поток GEUL — это последовательность пакетов, начинающаяся и заканчивающаяся Meta Node. Определяет скоупинг TID, прямые ссылки и правила порядка пакетов."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Поток GEUL — это **последовательность пакетов, начинающаяся и заканчивающаяся Meta Node**, представляющая один завершённый документ GEUL.

## Ключевые особенности

- **Явные границы:** STREAM_START / STREAM_END (Meta Node)
- **Область TID:** Действует только внутри потока
- **Прямые ссылки:** Можно ссылаться только на уже объявленные TID
- **Big Endian:** Network Byte Order

## Структура потока

```
┌─────────────────────────────────────┐
│          STREAM_START               │  ← обязательный (Meta Node)
│          (объявление ширины TID)     │     0xC000 (16-бит TID)
├─────────────────────────────────────┤
│          Метаданные (опционально)    │
│          - VERSION    (0xC014)      │
│          - CREATED_AT (0xC008)      │
│          - CREATOR    (0xC010)      │
├─────────────────────────────────────┤
│          Пакеты основного тела       │
│          - Entity Node              │
│          - Quantity Node            │
│          - Verb Edge                │
│          - Triple Edge              │
│          - Event6 Edge              │
│          - Clause Edge              │
│          - Context Edge             │
│          - Group Edge               │
│          - Faber Edge               │
├─────────────────────────────────────┤
│          STREAM_END                 │  ← опциональный (рекоменд.)
└─────────────────────────────────────┘
```

Минимальный поток: `STREAM_START`(1 слово) + `STREAM_END`(1 слово) = 2 слова (4 байта); пустой поток тоже валиден.

## Принципы назначения TID

| Правило | Описание |
|---------|----------|
| **Обязательность** | Каждый Edge/Node в потоке имеет TID |
| **Уникальность** | TID уникален в пределах потока |
| **Область** | TID действителен только внутри данного потока |
| **Прямая ссылка** | Можно ссылаться только на уже объявленный TID |

### Расположение TID

| Тип | Расположение TID | Расположение ссылок |
|-----|------------------|---------------------|
| **Meta Node** | Нет | Нет |
| **Entity Node** | Последнее слово | Нет |
| **Quantity Node** | Последнее слово | Нет |
| **Tiny Verb Edge** | Нет | Нет (инлайн) |
| **Verb Edge** | Область заголовка | После payload |
| **Triple Edge** | Область заголовка | После payload |
| **Event6 Edge** | Область заголовка | После payload |
| **Clause Edge** | Область заголовка | После payload |
| **Context Edge** | Область заголовка | После payload |
| **Group Edge** | 2-е слово | 3-е+ слово |

**Node** только определяют себя, поэтому TID в конце; **Edge** ссылаются на другие TID, поэтому TID стоит перед ссылками.

### Зарезервированные TID

| TID | Назначение |
|-----|------------|
| 0x0000 | **Маркер завершения** ([Group Edge](../group-edge/) и др.) |
| 0xFFFF | Зарезервирован (для 16-бит) |

## Правила порядка пакетов

### Порядок объявления-ссылки

```
Правильно:
  [Entity: Иван, TID=0x0001]
  [Entity: Мария, TID=0x0002]
  [Verb Edge: встретить, Subject=0x0001, Object=0x0002]

Неправильно:
  [Verb Edge: встретить, Subject=0x0001, Object=0x0002]  ← 0x0001 не объявлен
  [Entity: Иван, TID=0x0001]
  [Entity: Мария, TID=0x0002]
```

### Рекомендуемый порядок

```
1. STREAM_START
2. Метаданные (VERSION, CREATED_AT, CREATOR)
3. Entity Node (объявления сущностей)
4. Quantity Node (числа/литералы)
5. Group Edge (определения групп)
6. Tiny Verb Edge (инлайн-предикаты)
7. Verb Edge (обычные предикаты)
8. Triple Edge (свойства/связи)
9. Event6 Edge (события)
10. Clause Edge (дискурсивные связи)
11. Context Edge (контексты)
12. Faber Edge (код/AST)
13. STREAM_END
```

Это рекомендуемый порядок; можно размещать свободно, если соблюдается правило объявления-ссылки.

### Запрет циклических ссылок

Циклические ссылки вида A → B → A невозможны. При необходимости циклических отношений используйте отдельные Edge.

```
Допустимо:
  [Entity A, TID=0x0001]
  [Entity B, TID=0x0002]
  [Edge: A→B, TID=0x0003]
  [Edge: B→A, TID=0x0004]
```

## Пример потока

### «Иван встретил Марию»

```
1. STREAM_START (TID 16 бит)
   0xC0 0x00

2. Entity: Иван (TID=0x0001)
   [Entity пакет...] 0x00 0x01

3. Entity: Мария (TID=0x0002)
   [Entity пакет...] 0x00 0x02

4. Verb Edge: meet (TID=0x0100)
   Subject: 0x0001
   Object: 0x0002

5. STREAM_END
   0xC0 0x04
```

### «Иван и Мария встретились в школе»

```
1. STREAM_START
   0xC0 0x00

2. Entity: Иван (TID=0x0001)
3. Entity: Мария (TID=0x0002)
4. Entity: школа (TID=0x0003)

5. Group Edge: AND (TID=0x0010)
   Члены: 0x0001, 0x0002, 0x0000 (завершение)

6. Verb Edge: meet (TID=0x0100)
   Subject: 0x0010 (группа)
   Location: 0x0003

7. STREAM_END
   0xC0 0x04
```

## Валидация потока

### Обязательные проверки

| Пункт | Проверка |
|-------|----------|
| Начало | Начинается с STREAM_START? |
| Уникальность TID | Нет дублирующихся TID? |
| Валидность ссылок | Все TID, на которые ссылаются, объявлены? |
| Прямая ссылка | На момент ссылки TID уже объявлен? |

### Код валидации

```python
def validate_stream(packets: list) -> dict:
    """Валидация потока"""
    errors = []
    declared_tids = set()

    # Проверка начала
    if not packets or packets[0].type != "STREAM_START":
        errors.append("Поток не начинается с STREAM_START")

    for packet in packets:
        # Проверка уникальности TID
        if packet.tid is not None:
            if packet.tid in declared_tids:
                errors.append(f"Дублирующийся TID: {packet.tid}")
            declared_tids.add(packet.tid)

        # Проверка валидности ссылок
        for ref_tid in packet.references:
            if ref_tid not in declared_tids:
                errors.append(f"Ссылка на необъявленный TID: {ref_tid}")

    return {
        "valid": len(errors) == 0,
        "errors": errors,
        "tid_count": len(declared_tids)
    }
```

## Множественные потоки

Каждый поток независим, область TID разделена по потокам. TID=0x0001 потока A и TID=0x0001 потока B — это разные сущности.

Перекрёстные ссылки (Cross-reference) между потоками пока не поддерживаются. В будущем возможно расширение через введение Stream ID и механизма Import/Export.
