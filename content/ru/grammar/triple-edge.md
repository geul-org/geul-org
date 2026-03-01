---
title: "Triple Edge"
weight: 30
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "triple", "property"]
summary: "Тип Edge для представления связей и свойств в форме (Subject, Property, Object). Двойная структура из базового режима (4 слова) и расширенного (5 слов) оптимизирует Top 63 высокочастотных свойства."
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Triple Edge — тип Edge для представления **связей/свойств** в форме `(Subject, Property, Object)`.

## Двухрежимная архитектура

- **Базовый режим (4 слова):** PropCode 0~62 (Top 63 свойств)
- **Расширенный режим (5 слов):** PropCode=63 покрывает все P-ID (16-бит семант. выравнивание)

## Базовый режим (4 слова = 64 бита)

```
1st WORD (16 бит)
┌────────────────────┬────────────────────┐
│      Prefix        │     PropCode       │
│      10bit         │       6bit         │
└────────────────────┴────────────────────┘

2nd WORD: Edge TID (16 бит)
3rd WORD: Subject TID (16 бит)
4th WORD: Object TID (16 бит)
```

| Поле | Биты | Описание |
|------|------|----------|
| Prefix | 10 | `1100 000 001` |
| PropCode | 6 | 0~62: Top 63 свойств, 63: расширенный режим |
| Edge TID | 16 | TID этого Edge |
| Subject TID | 16 | TID подлежащего Entity/Node |
| Object TID | 16 | TID дополнения Entity/Node/Quantity |

## Расширенный режим (5 слов = 80 бит)

Если PropCode = 63, в 3-м слове добавляется 16-бит P-ID.

```
1st WORD: [Prefix 10bit] + [PropCode=63 6bit]
2nd WORD: Edge TID (16 бит)
3rd WORD: P-ID семант. выравнивание (16 бит)
4th WORD: Subject TID (16 бит)
5th WORD: Object TID (16 бит)
```

## Top 63 свойств (PropCode 0~62)

Свойства отобраны на основе частоты использования в Wikidata.

### Классификация/тип (Code 0~7)

| Code | P-ID | Свойство | Описание |
|------|------|----------|----------|
| 0 | P31 | instance of | Экземпляр класса |
| 1 | P279 | subclass of | Подкласс |
| 2 | P361 | part of | Часть целого |
| 3 | P527 | has part | Содержит часть |
| 4 | P1552 | has quality | Качество/свойство |
| 5 | P460 | same as | Тождественно |
| 6 | P1889 | different from | Отличается от |
| 7 | P156 | followed by | Следует за |

### Пространство/местоположение (Code 8~15)

| Code | P-ID | Свойство | Описание |
|------|------|----------|----------|
| 8 | P17 | country | Страна |
| 9 | P131 | located in | Местоположение (адм. район) |
| 10 | P276 | location | Местоположение (место) |
| 11 | P625 | coordinate | Координаты |
| 12 | P30 | continent | Континент |
| 13 | P36 | capital | Столица |
| 14 | P150 | contains | Содержит (территория) |
| 15 | P206 | located next to | Прилегающий водоём |

### Время (Code 16~23)

| Code | P-ID | Свойство | Описание |
|------|------|----------|----------|
| 16 | P569 | date of birth | Дата рождения |
| 17 | P570 | date of death | Дата смерти |
| 18 | P571 | inception | Дата основания |
| 19 | P576 | dissolved | Дата роспуска |
| 20 | P577 | publication date | Дата публикации |
| 21 | P580 | start time | Начало |
| 22 | P582 | end time | Окончание |
| 23 | P585 | point in time | Момент времени |

### Основные данные о персонах (Code 24~31)

| Code | P-ID | Свойство | Описание |
|------|------|----------|----------|
| 24 | P19 | place of birth | Место рождения |
| 25 | P20 | place of death | Место смерти |
| 26 | P21 | sex or gender | Пол |
| 27 | P27 | citizenship | Гражданство |
| 28 | P735 | given name | Имя |
| 29 | P734 | family name | Фамилия |
| 30 | P1559 | name in native language | Имя на родном языке |
| 31 | P742 | pseudonym | Псевдоним |

### Отношения/принадлежность (Code 32~39)

| Code | P-ID | Свойство | Описание |
|------|------|----------|----------|
| 32 | P22 | father | Отец |
| 33 | P25 | mother | Мать |
| 34 | P26 | spouse | Супруг(а) |
| 35 | P40 | child | Ребёнок |
| 36 | P3373 | sibling | Брат/сестра |
| 37 | P463 | member of | Членство |
| 38 | P108 | employer | Работодатель |
| 39 | P1027 | conferred by | Присуждено (орган) |

### Профессия/деятельность (Code 40~47)

| Code | P-ID | Свойство | Описание |
|------|------|----------|----------|
| 40 | P106 | occupation | Профессия |
| 41 | P39 | position held | Должность |
| 42 | P69 | educated at | Образование |
| 43 | P101 | field of work | Область деятельности |
| 44 | P1344 | participant in | Участие (событие) |
| 45 | P166 | award received | Награда |
| 46 | P800 | notable work | Главная работа |
| 47 | P1412 | languages spoken | Языки |

### Медиа/идентификация (Code 48~55)

| Code | P-ID | Свойство | Описание |
|------|------|----------|----------|
| 48 | P18 | image | Изображение |
| 49 | P154 | logo | Логотип |
| 50 | P41 | flag image | Флаг |
| 51 | P373 | Commons category | Викимедиа |
| 52 | P856 | official website | Офиц. сайт |
| 53 | P214 | VIAF ID | VIAF |
| 54 | P227 | GND ID | GND |
| 55 | P213 | ISNI | ISNI |

### Произведения/творчество (Code 56~62)

| Code | P-ID | Свойство | Описание |
|------|------|----------|----------|
| 56 | P50 | author | Автор |
| 57 | P57 | director | Режиссёр |
| 58 | P86 | composer | Композитор |
| 59 | P175 | performer | Исполнитель |
| 60 | P136 | genre | Жанр |
| 61 | P364 | original language | Язык оригинала |
| 62 | P123 | publisher | Издатель |

Code 63 зарезервирован как **маркер расширенного режима**.

## Сводка PropCode

```
┌─────────────────────────────────────────────┐
│  0~7:   Классификация/тип (P31, P279, ...) │
│  8~15:  Пространство/место (P17, P131, ...)│
│  16~23: Время (P569, P570, ...)            │
│  24~31: Персоны (P19, P20, ...)            │
│  32~39: Отношения/принадл. (P22, P25, ...) │
│  40~47: Профессия/деятельность (P106, ...)  │
│  48~55: Медиа/идентификация (P18, P856, ...)│
│  56~62: Произведения (P50, P57, ...)       │
├─────────────────────────────────────────────┤
│  63: Маркер расширенного режима             │
└─────────────────────────────────────────────┘
```

## Примеры

### Базовый режим: «Apple — это компания»

```
P31 (instance of) → PropCode = 0

Triple Edge:
  1st: [1100 000 001] + [000000]  - Prefix + PropCode 0
  2nd: [TID: 0x0101]              - Edge TID
  3rd: [TID: 0x0010]              - Apple (Subject)
  4th: [TID: 0x0020]              - компания (Object)

Всего: 4 слова
```

### Расширенный режим: «Высота Эйфелевой башни — 330 м»

```
P2048 (height) → вне Top 63 → расширенный режим

Triple Edge:
  1st: [1100 000 001] + [111111]  - Prefix + Ext(63)
  2nd: [TID: 0x0102]              - Edge TID
  3rd: [0xA800]                   - семант. выравнивание P2048
  4th: [TID: 0x0030]              - Эйфелева башня (Subject)
  5th: [TID: 0x0050]              - 330m Quantity (Object)

Всего: 5 слов
```

## Разбор

```python
def parse_triple_edge(data: bytes) -> dict:
    word1 = int.from_bytes(data[0:2], 'big')

    prefix = word1 >> 6
    assert prefix == 0b1100000001, "Not Triple Edge"

    prop_code = word1 & 0x3F

    if prop_code < 63:
        # Базовый режим (4 слова)
        return {
            'mode': 'basic',
            'prop_code': prop_code,
            'edge_tid': int.from_bytes(data[2:4], 'big'),
            'subject_tid': int.from_bytes(data[4:6], 'big'),
            'object_tid': int.from_bytes(data[6:8], 'big'),
            'words': 4
        }
    else:
        # Расширенный режим (5 слов)
        return {
            'mode': 'extended',
            'p_id': int.from_bytes(data[4:6], 'big'),
            'edge_tid': int.from_bytes(data[2:4], 'big'),
            'subject_tid': int.from_bytes(data[6:8], 'big'),
            'object_tid': int.from_bytes(data[8:10], 'big'),
            'words': 5
        }
```
