---
title: "COORDINATE-GEO (0x065L)"
weight: 101
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-GEO — координатный Value, задающий точку на указанном небесном теле (планете, спутнике, астероиде и т. п.) широтой, долготой и неопределённостью."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Параметр | Значение |
|---|---|
| Имя | `COORDINATE-GEO` (документ спецификации BIND `COORDINATE-GEO`) |
| TAG ID | `0x065L` |
| Codec ID | `0x00000650` |
| Документ спецификации | `0x00000000/codecs/0x00000650/` (цель DECLARE `0650`) |
| Раздел | 3 `0011` (Value), смещение внутри раздела C = 5 |
| Kind | Value · семейство: NUMERIC |
| TAG WORD | `0000 0110 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание индекса | Reference на небесное тело, широта и долгота в binary64, неопределённость в binary32 и Reference на её единицу |
| На стороне Hugo | `value/numeric/coordinate-geo.md` |

## Поля (документ спецификации) {#필드-규격-문서}

Порядок FIELD внутри документа — это порядок полей Payload ([документ спецификации Codec](../codec-spec.md)).

| Порядок | Поле (BIND) | FIELD | Ширина | Принимаемый формат (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `globe` | #2 | запись | `0050` LOCAL, `00A0` GEUL, `00F0` GEUL-SIDX, `0140` WIKIDATA-QID, `0200` EXTERNAL-POINTER-1WORD, `0250` EXTERNAL-POINTER-2WORD, `02A0` EXTERNAL-POINTER-4WORD, `02F0` EXTERNAL-ISSUER-2WORD, `0340` EXTERNAL-ISSUER-4WORD, `0390` EXTERNAL-ISSUER-16WORD |  |
| 2 | `latitude` | #3 | простое значение, 4 WORD | `0630` BINARY-FLOAT |  |
| 3 | `longitude` | #4 | простое значение, 4 WORD | `0630` BINARY-FLOAT |  |
| 4 | `uncertainty` | #5 | простое значение, 2 WORD | `0630` BINARY-FLOAT |  |
| 5 | `unit` | #26 | запись | `000F` весь раздел 0 (шаблон, Reference), `020F` весь раздел 1 (шаблон, Reference), `040F` весь раздел 2 (шаблон, Reference), `0000` ABSENT (необязательное поле) |  |

COORDINATE-GEO — координатный Value, задающий точку на указанном небесном теле (планете, спутнике, астероиде и т. п.) широтой, долготой и неопределённостью. Прямой код Value `0x065L`, семейство NUMERIC. Это формат [COORDINATE-EARTH](0x064L-coordinate-earth.md) (`0x064L`) с добавленным впереди Reference на небесное тело (Globe); правила широты, долготы, неопределённости и единицы те же, что у COORDINATE-EARTH.

## Раскладка {#레이아웃}

```
TAG WORD          0000 0110 0101 LLLL      Codec 0x065L
[Length-расширяющий TAG] если всего 15 WORD и более
Globe             одна запись Reference (Reference на небесное тело, Quantifier Identified)
Latitude          4 WORD, простое значение, IEEE 754 binary64 (градусы)
Longitude         4 WORD, простое значение, IEEE 754 binary64 (градусы)
Uncertainty       2 WORD, простое значение, IEEE 754 binary32 (в единицах Unit)
Unit              одна запись Reference или маркер места 0x0000 ABSENT
```

## Интерпретация и действительность {#해석과-유효성}

- Payload начинается с записи Globe. Globe — ровно одна полная запись Reference с Quantifier Identified. Подойдёт любой Reference, указывающий на небесное тело: [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) (именованное небесное тело), [GEUL](../reference/0x00AL-geul.md), [LOCAL](../reference/0x005L-local.md) того же документа (тело, определённое внутри документа), небесное тело из другого документа ([EXTERNAL-POINTER](../reference/0x020L-external-pointer-1word.md)·[EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md)) и т. д. Небесных тел бесчисленное множество, а тела с QID — лишь их часть.
- После Globe идут 10 WORD (Latitude 4, Longitude 4, Uncertainty 2) и одна запись Unit. Курсор после чтения Unit должен совпасть с концом записи.
- Latitude: `-90 ≤ φ ≤ 90`, Longitude: `-360 ≤ λ ≤ 360`. Диапазон шире земного, чтобы без изменений вмещать значения небесных систем координат, где долгота считается от 0 до 360° (восточная и западная долгота), и отрицательные значения, записанные в обратном направлении. Диапазон совпадает с моделью данных globecoordinate Викиданных (Wikibase `LatLongValue`). `λ` и `λ ± 360` — один и тот же меридиан, и GEUL их не нормализует. Остальные правила (binary64, конечные значения, порядок осей, смысл Uncertainty·Unit, представление неизвестного) те же, что у COORDINATE-EARTH.
- Система координат для каждого небесного тела следует соглашениям этого тела (планетоцентрическая широта, восточная или западная долгота 0~360° и т. п.). Системы координат отдельных тел определяются отдельными документами GEUL.
- Uncertainty в единицах расстояния (метры и т. п.) — расстояние по поверхности небесного тела. Угловые единицы (градус, угловая минута, угловая секунда) — угловой радиус по широте и долготе независимо от размера тела.
- Для координат Земли (Q2) рекомендуется COORDINATE-EARTH. Запись Земли в этом формате не invalid, и сравнивающая сторона приводит её к той же координате.
- Документ спецификации geul.org `0x00000000/codecs/0x00000650` задаёт для полей простых значений Latitude·Longitude·Uncertainty [CODEC](../edge/0x0BEL-codec.md) BINARY-FLOAT (`0630`), а для поля записи Unit — CODEC `000F`·`020F`·`040F` (любой Reference) и `0000` (ABSENT).

## Длина {#길이}

- Общая длина — TAG 1 WORD + (Length-расширяющий TAG) + запись Globe + 10 WORD + запись Unit.
- Если Globe занимает 2 WORD (QID умещается в 1 WORD), а Unit равен ABSENT, всего 14 WORD, `LLLL=1101`, TAG `065D`. Если Unit — Reference (2 WORD и более), всего получается больше 15 WORD и используется расширенная длина: TAG `065E`, а в следующем WORD общее число WORD ([Запись и TAG WORD](../record.md)).

## Соответствие Викиданным {#위키데이터-대응}

- globecoordinate, у которого globe не Земля (Q2), записывается в этом формате. Globe = WIKIDATA-QID (элемент globe). Соответствие широты, долготы и precision → Uncertainty·Unit то же, что у COORDINATE-EARTH (precision — разрешение записи в градусах, поэтому переносится как есть независимо от размера тела).
- Небесные тела вне Земли в выборке Викиданных (около 24 тысяч утверждений о координатах): Марс (Q111), Церера (Q596), Луна (Q405), Меркурий (Q308), Венера (Q313) и др. — 23 случая. 41 случай с пустым globe не преобразуется, исходный текст сохраняется как UTF8-TEXT.

## Пример {#예시}

Марс (Q111) 4.5, 137.4, неопределённость неизвестна:

```
065D 0141 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 0000 0000 0000
```

- TAG `065D` (Codec `0x065L`, `LLLL=1101`, 14 WORD), Globe `0141 006F` (WIKIDATA-QID Q111), Latitude `4012 0000 0000 0000`, Longitude `4061 2CCC CCCC CCCD`, Uncertainty `0000 0000` (+0), Unit `0000` (ABSENT, неизвестно).
- Текстовая запись: `COORDINATE-GEO(Q111, 4.5, 137.4, 0, ABSENT)`.

Та же точка, precision 0.1° (Unit градус Q28390):

```
065E 0010 0141 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 3DCC CCCD 0141 6EE6
```

- TAG `065E` (`LLLL=1110`, расширенная длина), общая длина `0010` (16 WORD), Uncertainty `3DCC CCCD` (binary32 0.1), Unit `0141 6EE6` (Q28390).

## Стандартное обоснование {#표준-근거}

- Смысл: широта, долгота и `u` (когда Unit — метр) из [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870). Единственная система координат, зарегистрированная для `crs` в RFC 5870, — `wgs84`, поэтому небесные тела вне Земли задаются Reference Globe в GEUL.
- Числа: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (широта и долгота), binary32 (неопределённость).
- Диапазон долготы: `-360 ≤ λ ≤ 360` в модели данных globecoordinate Викиданных [DataValues Geo `LatLongValue`](https://github.com/DataValues/Geo).

## Открытые проблемы {#열린-문제}

1. Документы систем координат отдельных небесных тел: определение широты (планетоцентрическая, планетографическая) и направление и диапазон долготы для каждого тела.

## Связанные страницы {#관련-페이지}

- [Value](_index.md), [COORDINATE-EARTH](0x064L-coordinate-earth.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md), [GEUL](../reference/0x00AL-geul.md), [LOCAL](../reference/0x005L-local.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x00000650/latest.geul`, прочитанный командой `geul show` (16-ричные цифры в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000065000000000
BODY
#1 DECLARE 0x0650
#2 FIELD #1 record
#3 FIELD #1 0x0004
#4 FIELD #1 0x0004
#5 FIELD #1 0x0002
#6 BIND #1 "COORDINATE-GEO"
#7 BIND #2 "globe"
#8 BIND #3 "latitude"
#9 BIND #4 "longitude"
#10 BIND #5 "uncertainty"
#11 CODEC #3 0x0630
#12 CODEC #4 0x0630
#13 CODEC #2 0x0050
#14 CODEC #2 0x00A0
#15 CODEC #2 0x00F0
#16 CODEC #2 0x0140
#17 CODEC #2 0x0200
#18 CODEC #2 0x0250
#19 CODEC #2 0x02A0
#22 CODEC #2 0x02F0
#23 CODEC #2 0x0340
#24 CODEC #2 0x0390
#25 CODEC #5 0x0630
#26 FIELD #1 record
#27 BIND #26 "unit"
#28 CODEC #26 0x000F
#30 CODEC #26 0x020F
#31 CODEC #26 0x040F
#29 CODEC #26 0x0000
```
