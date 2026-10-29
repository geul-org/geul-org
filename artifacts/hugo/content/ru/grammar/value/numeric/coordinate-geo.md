---
title: "COORDINATE-GEO"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-30T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-GEO — Value, хранящий точку на небесном теле (планете, спутнике и т. п.): Reference небесного тела, широту и долготу в binary64, неопределённость в binary32 и Reference её единицы."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COORDINATE-GEO — координатный Value, представляющий точку на заданном небесном теле (планете, спутнике, астероиде и т. п.) широтой, долготой и неопределённостью. Прямой код Value `0x05`, семейство NUMERIC. Это формат [COORDINATE-EARTH](/ru/grammar/value/numeric/coordinate-earth/) (`0x04`) с добавленным впереди Reference небесного тела (Globe); правила широты, долготы, неопределённости и единицы те же, что у COORDINATE-EARTH.

## Раскладка

```
TAG WORD          0000 1LLL L000 0101      Codec 0x05
[Length extension TAG] если всего 15 WORD и более
Globe             одна запись Reference (Reference на небесное тело, Quantifier Identified)
Latitude          4 WORD сырое значение, IEEE 754 binary64 (градусы)
Longitude         4 WORD сырое значение, IEEE 754 binary64 (градусы)
Uncertainty       2 WORD сырое значение, IEEE 754 binary32 (в единицах Unit)
Unit              одна запись Reference либо маркер слота 0x0000 ABSENT
```

## Интерпретация и допустимость

- Payload начинается с записи Globe. Globe — ровно одна полная запись Reference, Quantifier — Identified (`000`). Можно использовать любой Reference, указывающий на небесное тело: [WIKIDATA-QID](/ru/grammar/reference/wikidata-qid/) (именованное тело), [GEUL](/ru/grammar/reference/geul/), [LOCAL](/ru/grammar/reference/local/) того же документа (тело, определённое в документе), тело другого документа ([EXTERNAL-POINTER](/ru/grammar/reference/external-pointer/), [EXTERNAL-ISSUER](/ru/grammar/reference/external-issuer/)) и т. п. Небесных тел бесчисленное множество, а тела с QID — лишь их часть.
- После Globe идут 10 WORD (Latitude 4, Longitude 4, Uncertainty 2) и одна запись Unit. Позиция после чтения Unit должна совпасть с концом записи.
- Latitude — `-90 ≤ φ ≤ 90`, Longitude — `-360 ≤ λ ≤ 360`. Диапазон шире, чем для Земли, чтобы без изменений хранить значения систем координат небесных тел, где долгота считается от 0 до 360° (восточная или западная), и отрицательные значения, записанные в обратном направлении. Диапазон совпадает с моделью данных globecoordinate Викиданных (Wikibase `LatLongValue`). `λ` и `λ ± 360` — один и тот же меридиан, GEUL их не нормализует. Остальные правила (binary64, конечные значения, порядок осей, смысл Uncertainty и Unit, представление «неизвестно») те же, что у COORDINATE-EARTH.
- Система координат у каждого небесного тела следует его собственным соглашениям (планетоцентрическая широта, восточная или западная долгота от 0 до 360° и т. п.). Системы координат отдельных тел определяются отдельными документами GEUL.
- Uncertainty в единицах расстояния (метры и т. п.) — это расстояние по поверхности небесного тела. Единицы угла (градус, угловая минута, угловая секунда) — угловой радиус по широте и долготе, независимо от размера тела.
- Для земных (Q2) координат рекомендуется COORDINATE-EARTH. Запись Земли в этом формате тоже не invalid, а сравнивающая сторона приводит такие координаты к одним и тем же.
- Документ спецификации geul.org `0x0000/0x0000000000000805` ставит на сырые поля Latitude, Longitude и Uncertainty [CODEC](/ru/grammar/edge/codec/) BINARY-FLOAT (`0803`), а на поле записи Unit — CODEC `0780` (любой Reference) и `0000` (ABSENT).

## Длина

- Всего — TAG 1 WORD + (Length extension TAG) + запись Globe + 10 WORD + запись Unit.
- Если Globe занимает 2 WORD (QID помещается в 1 WORD), а Unit — ABSENT, получается 14 WORD, `LLLL=1101`, TAG `0E85`. Если Unit — Reference (от 2 WORD), то получается больше 15 WORD и используется расширенная длина: TAG `0F05`, а в следующем WORD полное число WORD ([Запись и TAG WORD](/ru/grammar/record/)).

## Соответствие Wikidata

- globecoordinate, у которого globe не Земля (Q2), записывается в этом формате. Globe = WIKIDATA-QID (элемент globe). Соответствие широты, долготы и precision → Uncertainty и Unit то же, что у COORDINATE-EARTH (precision — разрешение записи в градусах, поэтому переносится как есть независимо от размера тела).
- Небесные тела вне Земли в выборке Wikidata (около 24 тыс. утверждений с координатами): Марс (Q111), Церера (Q596), Луна (Q405), Меркурий (Q308), Венера (Q313) и др. — 23 случая. 41 случай с пустым globe не преобразуется, а исходный текст сохраняется как UTF8-TEXT.

## Пример

Марс (Q111) 4.5, 137.4, неопределённость неизвестна:

```
0E85 00A0 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 0000 0000 0000
```

- TAG `0E85` (Codec `0x05`, `LLLL=1101`, 14 WORD), Globe `00A0 006F` (WIKIDATA-QID Q111), Latitude `4012 0000 0000 0000`, Longitude `4061 2CCC CCCC CCCD`, Uncertainty `0000 0000` (+0), Unit `0000` (ABSENT, неизвестно).
- Текстовая запись: `COORDINATE-GEO(Q111, 4.5, 137.4, 0, ABSENT)`.

Та же точка, precision 0,1° (Unit градус Q28390):

```
0F05 0010 00A0 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 3DCC CCCD 00A0 6EE6
```

- TAG `0F05` (`LLLL=1110`, расширенная длина), полное число `0010` (16 WORD), Uncertainty `3DCC CCCD` (binary32 0.1), Unit `00A0 6EE6` (Q28390).

## Основание в стандартах

- Смысл: широта, долгота и `u` (когда Unit — метр) из [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870). В `crs` RFC 5870 зарегистрирована только система координат `wgs84`, поэтому небесные тела вне Земли задаются Reference Globe в GEUL.
- Числа: [IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64 (широта и долгота), binary32 (неопределённость).
- Диапазон долготы: `-360 ≤ λ ≤ 360` модели данных globecoordinate Викиданных, [DataValues Geo `LatLongValue`](https://github.com/DataValues/Geo).

## Открытые вопросы

1. Документы систем координат отдельных тел: определение широты (планетоцентрическая или планетографическая) и направление и диапазон долготы для каждого тела.

## Связанные страницы

- [Value](/ru/grammar/value/), [COORDINATE-EARTH](/ru/grammar/value/numeric/coordinate-earth/), [WIKIDATA-QID](/ru/grammar/reference/wikidata-qid/), [GEUL](/ru/grammar/reference/geul/), [LOCAL](/ru/grammar/reference/local/)
