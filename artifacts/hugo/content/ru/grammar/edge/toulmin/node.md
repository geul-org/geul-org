---
title: "NODE"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "NODE — раскладка для записи узлов графа TOULMIN (дело, правило, определение, точка входа, триггер, функция, поле, алиас, группа). Флаги заголовка в 1 WORD определяют следующие за ним условные поля."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NODE — раскладка для записи узлов графа вердиктов и выполнения TOULMIN. Вид узла задаёт Codec (или номер формата ISSUER GEUL), а заголовок в 1 WORD определяет роль, Level, форму Claim и условные поля.

## Codec

| Codec | Имя | TANGEUL | Узел |
|---|---|---|---|
| `0x60` | CASE-DECLARE | `in case of` | Дело |
| `0x62` | SPEC-DECLARE | Элемент Definitions (`means`, `has`) | Критерий суждения (Backing). role задаёт вид определения |
| `0x63` | RULE-DECLARE | general rule | Утверждение (Warrant) |
| `0x64` | COUNTER-DECLARE | counter rule | Возражение (Rebuttal) |
| `0x65` | EXCEPT-DECLARE | except rule | Исключение (Defeater) |
| `0x75` | ENTRY | `provides x` | Внешняя точка входа |
| `0x76` | TRIGGER | `on`, `every`, `until` | Точка входа по событию или периоду |
| ISSUER `0x0000`/`0xC010` | NAMESPACE | `this document is` | Пространство имён документа |
| ISSUER `0x0000`/`0xC011` | FUNC | ссылка на функцию | Внешняя функция (например, `bank.withdraw`) |
| ISSUER `0x0000`/`0xC012` | FIELD | `x is required [as Type]` | Обязательное поле |
| ISSUER `0x0000`/`0xC013` | ALIAS | `see a from path` | Алиас импортированного пакета |
| ISSUER `0x0000`/`0xC014` | GROUP | нумерованный список `1.` | Упорядоченная группа выполнения |

Формат ISSUER размещается как Issuer `0x0000` и номер формата в Codec extension TAG после `ISSUER-1WORD` (`0x7C`) ([TOULMIN](/ru/grammar/edge/toulmin/)).

## Раскладка

```
ID               запись LOCAL Reference (Edge Id)
Заголовок 1 WORD   role 2b | зарезервировано 2b | F_GROUNDS 1b | level 2b | вид object 2b | flags 7b
[F_FUNC]         FuncRef: REF(ALIAS, 0 если нет) + VerbCode 1 WORD
[F_QUAL]         SIGNED-DECIMAL Value. Qualifier
[F_CHECK]        REF(дело)
[F_CLAIM]        Claim: REF(subject) + predicate 1 WORD + object + mode 1 WORD
[F_VERDICT]      SIGNED-DECIMAL Value. Начальное значение вердикта
[F_WITH]         число (UNSIGNED-INTEGER Value) + REF(TEXT) × число
[F_GROUNDS]      число (UNSIGNED-INTEGER Value) + REF(TEXT) × число
SPAN             ширина, заданная SOURCE × 2 (начальный байт, число байтов)
```

### WORD заголовка

| Биты | Поле | Значение |
|---|---|---|
| 15–14 | role | 0 general, 1 counter, 2 except |
| 13–12 | зарезервировано | 0 |
| 11 | F_GROUNDS | Есть список оснований |
| 10–9 | level | 0 Unset, 1 Fail, 2 Review (3 зарезервировано) |
| 8–7 | вид object | Форма object в Claim. 0 REF, 1 UNSIGNED-INTEGER Value, 2 SPAN |
| 6–0 | flags | таблица ниже |

| Бит | flag | Смысл |
|---|---|---|
| b0 | F_FUNC | Есть поле FuncRef |
| b1 | F_QUAL | Есть поле Qualifier |
| b2 | F_CHECK | Есть поле дела — объекта `checking` |
| b3 | F_CLAIM | Есть поле Claim |
| b4 | F_VERDICT | Есть поле начального значения вердикта |
| b5 | F_STRIKE | Объявление зачёркнуто. Поля нет |
| b6 | F_WITH | Есть поле списка критериев |

- Условные поля идут в порядке флагов (F_FUNC, F_QUAL, F_CHECK, F_CLAIM, F_VERDICT, F_WITH, F_GROUNDS). Поле, чей флаг сброшен, места не занимает.
- Если флаг установлен, а поля нет, запись отклоняется. Позиция после последовательного чтения полей, пройдя SPAN, должна в точности совпасть с концом записи.

## Поля

| Поле | Описание |
|---|---|
| FuncRef | Место функции. REF — запись ALIAS, импортировавшая эту функцию, а для функции этого документа — `0`. VerbCode — код в 1 WORD, пока не назначен (`0x0000` допустим). Исходная запись имени функции записывается отдельно как TEXT + [LABEL](/ru/grammar/edge/toulmin/link/) |
| Qualifier | Уверенность узла (0~1) |
| Дело | F_CHECK: дело, по которому этот узел только выносит вердикт (`checking c`) |
| Claim | Высказывание, которое несёт узел. subject REF, predicate 1 WORD, object, mode 1 WORD. Форму object задаёт вид object в заголовке |
| Значение вердикта | Начальное значение вердикта (−1~1) |
| F_WITH | Критерии на момент объявления (`기준으로 하는`, «берущий за критерий»). Список REF записей TEXT |
| F_GROUNDS | Имена внешних фактов, разрешаемых на момент оценки (`근거로 하는`, «берущий за основание»). Список REF записей TEXT |
| SPAN | Диапазон исходного текста, откуда взято это объявление |

- Запись значения вердикта и Qualifier следует правилам чисел из [TOULMIN](/ru/grammar/edge/toulmin/#числа).
- Число элементов списка — встроенная запись [UNSIGNED-INTEGER](/ru/grammar/value/numeric/unsigned-integer/) Value.
- Основная форма повествовательного Claim: subject·predicate равны `0`, а object — SPAN (вид object 2). Он привязан к записи в исходном тексте.

## Интерпретация и допустимость

- У RULE·COUNTER·EXCEPT-DECLARE role должен совпадать с Codec (0 general, 1 counter, 2 except). У SPEC-DECLARE это вид определения. У остальных Codec он равен 0.
- Если level равен 0 (Unset), используется значение движка по умолчанию: для COUNTER-DECLARE это Fail, для EXCEPT-DECLARE — Review.
- Правило с функцией хоста в TANGEUL `tangl:규칙` («правило») (`쓰는 규칙이다`, «правило, которое использует») записывается как NODE RULE-DECLARE вне дела. Функция — F_FUNC, критерии — F_WITH, основания — F_GROUNDS. Только правилу с условным выражением предшествует [PREDICATE-DECLARE](/ru/grammar/edge/toulmin/expr/).
- Зарезервированные биты (13–12) должны быть равны 0. Если зарезервированный бит установлен или role не соответствует Codec, запись отклоняется.

## Связанные страницы

- [TOULMIN](/ru/grammar/edge/toulmin/), [LINK](/ru/grammar/edge/toulmin/link/), [EXPR](/ru/grammar/edge/toulmin/expr/), [SOURCE и разделы](/ru/grammar/edge/toulmin/source/)
- [LOCAL](/ru/grammar/reference/local/), [SIGNED-DECIMAL](/ru/grammar/value/decimal/signed-decimal/)
