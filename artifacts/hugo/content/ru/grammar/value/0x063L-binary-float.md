---
title: "BINARY-FLOAT (0x063L)"
weight: 99
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BINARY-FLOAT — Value, представляющий скаляр двоичного обменного формата IEEE 754."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Параметр | Значение |
|---|---|
| Имя | `BINARY-FLOAT` (документ спецификации BIND `BINARY-FLOAT`) |
| TAG ID | `0x063L` |
| Codec ID | `0x00000630` |
| Документ спецификации | `0x00000000/codecs/0x00000630/` (цель DECLARE `0630`) |
| Раздел | 3 `0011` (Value), смещение внутри раздела C = 3 |
| Kind | Value · семейство: NUMERIC |
| TAG WORD | `0000 0110 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание индекса | скаляр IEEE 754 binary16/32/64/128 при Payload 1/2/4/8 WORD |
| На стороне Hugo | `value/numeric/binary-float.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD внутри документа — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `ieee-binary` | #2 | остаток, простое значение (`0xFFFF`) |  |  |

BINARY-FLOAT — Value, представляющий скаляр двоичного обменного формата (binary interchange) IEEE 754. Прямой код Value `0x063L`, семейство NUMERIC. Payload из 1/2/4/8 WORD соответствует binary16/32/64/128. Битовая строка interchange сохраняется как есть, другие размеры Payload не допускаются.

## Раскладка {#레이아웃}

```
TAG WORD          0000 0110 0011 LLLL      Codec 0x063L
[Length-расширяющий TAG] если всего 15 WORD и более
Payload WORD 1st  (старшее WORD)   IEEE Binary Interchange 1st
...
Payload WORD Nth  (младшее WORD)   IEEE Binary Interchange Nth
```

## Интерпретация {#해석}

- WORD Payload склеиваются в порядке big-endian и читаются как битовая строка IEEE 754 binary interchange соответствующей ширины.
- Битовые образы interchange сохраняются, включая NaN payload и signed zero.
- Декодер не должен заменять NaN каким-либо одним каноническим NaN или стирать знак signed zero.
- Режим округления и арифметическое поведение этим форматом сериализации не определяются.

## Длина {#길이}

Общая длина — число WORD: TAG 1 WORD, Length-расширяющий TAG (если есть) и Payload ([Запись и TAG WORD](../record.md)).

| Формат | Payload | Код Length | Length-расширяющий TAG | Общая Length |
|---|---:|---|---|---:|
| binary16 | 1 WORD | `0001` | нет | 2 WORD |
| binary32 | 2 WORD | `0010` | нет | 3 WORD |
| binary64 | 4 WORD | `0100` | нет | 5 WORD |
| binary128 | 8 WORD | `1000` | нет | 9 WORD |

binary128 тоже попадает в прямой диапазон 1~14 WORD, поэтому Length-расширяющий TAG не используется.

## Действительность {#유효성}

- Payload — строго одно из 1, 2, 4, 8 WORD.
- Каждый размер Payload должен точно соответствовать представлению Length из таблицы выше.
- Перекодирование с изменением ширины и padding WORD до или после Payload не допускаются.

## Пример {#예시}

| Формат | TAG | Length-расширяющий TAG | Пример Payload | Вердикт |
|---|---|---|---|---|
| binary16 | `0631` | нет | `0000` | канонично |
| binary32 | `0632` | нет | `0000 0000` | канонично |
| binary64 | `0634` | нет | `0000 0000 0000 0000` | канонично |
| binary128 | `0638` | нет | битовая строка из 8 WORD | канонично |
| любой | не совпадает с размером, указанным в Length | любой | любой | invalid |

## Стандартное обоснование {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): применяется кодирование interchange binary16, binary32, binary64, binary128. GEUL добавляет к этой битовой строке только TAG и 16-битное WORD-обрамление big-endian.

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x00000630/latest.geul`, прочитанный командой `geul show` (16-ричные цифры в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000063000000000
BODY
#1 DECLARE 0x0630
#2 FIELD #1 rest
#3 BIND #1 "BINARY-FLOAT"
#4 BIND #2 "ieee-binary"
```
