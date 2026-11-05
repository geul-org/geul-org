---
title: "SIGNED-DECIMAL (0x068L)"
weight: 104
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "SIGNED-DECIMAL — Value, представляющий точное десятичное число (exact decimal) со знаковым coefficient."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Параметр | Значение |
|---|---|
| Имя | `SIGNED-DECIMAL` (документ спецификации BIND `SIGNED-DECIMAL`) |
| TAG ID | `0x068L` |
| Codec ID | `0x00000680` |
| Документ спецификации | `0x00000000/codecs/0x00000680/` (цель DECLARE `0680`) |
| Раздел | 3 `0011` (Value), смещение внутри раздела C = 8 |
| Kind | Value · семейство: DECIMAL |
| TAG WORD | `0000 0110 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание индекса | `C×10^E` со знаковой экспонентой `E` и coefficient `C` в дополнительном коде минимальной длины в WORD |
| На стороне Hugo | `value/decimal/signed-decimal.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD внутри документа — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `exponent` | #2 | простое значение, 2 WORD |  |  |
| 2 | `coefficient` | #3 | остаток, простое значение (`0xFFFF`) |  |  |

SIGNED-DECIMAL — Value, представляющий точное десятичное число (exact decimal) со знаковым coefficient. Прямой код Value `0x068L`, семейство DECIMAL. Первые 2 WORD Payload — десятичная экспонента `E` (signed 32 бита), остальное — coefficient `C` в дополнительном коде минимальной длины в WORD; значение равно `C×10^E`.

## Раскладка {#레이아웃}

```
TAG WORD          0000 0110 1000 LLLL      Codec 0x068L
[Length-расширяющий TAG] если всего 15 WORD и более
Payload WORD 1st–2nd (32 бита)         Signed Base-10 Exponent E
Payload WORD 3rd–Nth (1 WORD и более)  Signed Two's-complement Coefficient C
```

## Интерпретация {#해석}

- `E` — signed 32-битное целое в дополнительном коде, big-endian, записанное начиная со старшего WORD.
- `C` — целое произвольной точности в дополнительном коде, склеенное из всех оставшихся WORD начиная со старшего.
- `C` следует тому же правилу минимальной длины в WORD, что и [SIGNED-INTEGER](0x061L-signed-integer.md). Ведущие WORD `0000` или `FFFF`, которые можно удалить, запрещены.

## Длина и действительность {#길이와-유효성}

- Общая длина — число WORD: TAG 1 WORD, Length-расширяющий TAG (если есть) и Payload. До 14 WORD используется прямая длина, от 15 WORD — расширенная длина `1110`·`1111`, и расширяющий TAG тоже входит в общее число ([Запись и TAG WORD](../record.md)).
- Payload состоит из экспоненты 2 WORD и coefficient от 1 WORD, поэтому минимум — 3 WORD.
- Каноничность байтового представления проверяется только по представлению coefficient минимальной длины в WORD.

## Пример {#예시}

| Представление значения | Payload (`E` + `C`) | Вердикт |
|---|---|---|
| `1×10^0` | `0000 0000 0001` | байтовое представление каноничное |
| `10×10^-1` | `FFFF FFFF 000A` | байтовое представление каноничное; canonical-отношение к предыдущему представлению — открытая проблема |
| `1×10^0` | `0000 0000 0000 0001` | неканонично: ведущее `0000` в coefficient лишнее |
| Payload 7 WORD | прямая длина `LLLL=0111`, всего 8 WORD | каноническая структура длины |

## Статус формата {#형식-지위}

- Это расположение, объединяющее signed 32-битную экспоненту `E` и coefficient `C` минимальной длины в WORD, — собственный формат GEUL, а не десятичный interchange IEEE 754 и не `DECIMAL` Apache Parquet.
- `DECIMAL` в Parquet использует `unscaledValue × 10^(-scale)` и обязательные метаданные precision/scale, хранит unscaled value физического типа byte-array как big-endian дополнительный код, а scale неотрицателен. Данный формат помещает signed `E` в тело и не имеет метаданных precision, поэтому это не тот же формат.
- Для обмена с десятичными числами IEEE 754 или `DECIMAL` Parquet нужно явное преобразование, определяющее диапазон, precision/scale, quantum и политику особых значений.
- Основания для сравнения: [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/), [Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## Открытые проблемы {#열린-문제}

- Существует несколько пар exponent/coefficient, представляющих одно и то же число, например `10×10^-1` и `1×10^0`.
- Сохраняет ли этот формат quantum, как определяется равенство значений и как нормализуется canonical-экспонента — пока не определено.
- Поэтому реализация не должна произвольно навязывать нормализацию exponent/coefficient сверх правила минимальной длины coefficient в WORD.

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x00000680/latest.geul`, прочитанный командой `geul show` (16-ричные цифры в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000068000000000
BODY
#1 DECLARE 0x0680
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "SIGNED-DECIMAL"
#5 BIND #2 "exponent"
#6 BIND #3 "coefficient"
```
