---
title: "Meta"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance", "lineage", "import"]
summary: "Meta — это записи не о мире, а о документе. Делится на семь классов: структура, объявление, происхождение, родословная, проверка, политика и IMPORT; размещается в HEAD документа."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Meta — это записи не о мире, а о документе. Кроме записей структуры документа (DOC, BODY, END), все они размещаются в HEAD документа. Кроме Meta, в HEAD также помещаются Edge основания [SOURCE](/ru/grammar/edge/source/#источник-всего-документа) всего документа и его QUALIFIER.

## Раскладка

```
TAG WORD          0001 1LLL LCCC CCCC
[Length extension TAG]
Payload           сырое значение либо встроенные записи Value и Reference
```

- У Meta нет формата Issuer. Meta — общая спецификация, которой следуют все Issuer, и определяет её только GEUL.
- `LLLL` — это общее число WORD, включая TAG WORD, минус 1. Codec, которых нет в таблице, зарезервированы.

## Формат Payload

| Формат | Когда | Примеры |
|---|---|---|
| Сырое значение | Формат определяется однозначно. Не опирается на другие Codec записей | длина `DOC-*`, `SPEC-VERSION`, `ISSUER-KEY` |
| Встроенный Value | Нужно выбрать один из нескольких форматов. Формат сообщает TAG Value | `PROFILE`, `EFFECTIVE-*`, время, хеш содержимого |
| Встроенный Reference | Запись указывает на объект: человека, организацию, инструмент, документ | `DOC-ID`, `AUTHOR`, `CO-AUTHOR`, `RECORDED-BY`, `SIGNED-OFF`, подписант в `SIGNATURE` |
| Нет | Маркер в 1 WORD | `BODY`, `END` |

- Встроенные записи не являются самостоятельными записями и принадлежат своей Meta. Каждая находит свою границу по собственной Length, а позиция после чтения последней записи должна точно совпадать с концом Meta.
- Какие Meta можно указать в документе только один раз, а какие несколько, определяет пункт «Количество» в документе каждого Codec.

## Классы

Класс задают старшие 3 бита Codec.

| Старшие 3 бита | Класс | Прямой код | О чём |
|---|---|---|---|
| `000` | Структура | `0x00`~`0x0F` | Границы и длина документа |
| `001` | Объявление | `0x10`~`0x1F` | Объявления, влияющие на интерпретацию |
| `010` | Происхождение | `0x20`~`0x2F` | Кто, когда, откуда |
| `011` | Родословная | `0x30`~`0x3F` | Из чего и как получен |
| `100` | Проверка | `0x40`~`0x4F` | Можно ли верить |
| `101` | Политика | `0x50`~`0x5F` | Как с ним обращаться |
| `110` | IMPORT | `0x60`~`0x6F` | Импорт внешнего документа |
| `111` | Резерв | `0x70`~`0x7F` | |

- **Meta, нужные для интерпретации**: структура, объявление, IMPORT. Если их удалить, записи нельзя прочитать или интерпретация меняется. Их должен обрабатывать каждый декодер. Эти Codec входят в **основной кодекбук GEUL**.
- **Meta, не меняющие интерпретацию**: происхождение, родословная, проверка, политика. После удаления содержимое описания остаётся прежним. Пропадает лишь материал для оценки доверия и порядка обращения.
- Основание пишется не в Meta, а через Edge основания [SOURCE](/ru/grammar/edge/source/) и QUALIFIER. Основание отдельной записи помещается в BODY, а первоисточник всего документа — в HEAD как SOURCE с Target `0` ([Документ](/ru/grammar/document/#head-и-body)).

## Структура

Сводная страница: [Meta — Структура](/ru/grammar/meta/structure/)

| Codec | Имя | Значение |
|---|---|---|
| `0x00`~`0x02` | [DOC-1WORD / 2WORD / 4WORD](/ru/grammar/meta/structure/doc/) | Открывает документ, задавая полную длину |
| `0x0E` | [BODY](/ru/grammar/meta/structure/body/) | Завершает HEAD и открывает BODY |
| `0x0F` | [END](/ru/grammar/meta/structure/end/) | Закрывает документ |

Подробные правила изложены в разделе [Документ](/ru/grammar/document/).

## Объявление

Сводная страница: [Meta — Объявление](/ru/grammar/meta/declaration/)

| Codec | Имя | Значение |
|---|---|---|
| `0x10` | [SPEC-VERSION](/ru/grammar/meta/declaration/spec-version/) | Версия спецификации, которой следует документ. Одно целое число |
| `0x11` | [PROFILE](/ru/grammar/meta/declaration/profile/) | Применяемый профиль |
| `0x12` | [DOC-ID](/ru/grammar/meta/declaration/doc-id/) | Идентификатор этого документа. DOC-POINTER, указывающий на сам документ (версия 0) |
| `0x13` | [EFFECTIVE-FROM](/ru/grammar/meta/declaration/effective-from/) | Дата вступления этой версии в силу. Если нет — момент публикации |
| `0x14` | [EFFECTIVE-UNTIL](/ru/grammar/meta/declaration/effective-until/) | Конец срока действия этой версии (срочный закон). Если нет — до вступления в силу следующей версии |
| `0x16` | [DEFAULT-LANGUAGE](/ru/grammar/meta/declaration/default-language/) | Язык по умолчанию |

- Адресное имя документа в Meta не указывается. Его привязывает через BIND индекс имён Issuer `documents.geul` ([Адрес публикации и список версий](/ru/grammar/publishing/#имя-документа)). Заголовок для чтения человеком привязывается через LABEL в BODY.

## Происхождение

Сводная страница: [Meta — Происхождение](/ru/grammar/meta/provenance/)

| Codec | Имя | Значение |
|---|---|---|
| `0x20` | [AUTHOR](/ru/grammar/meta/provenance/author/) | Автор (Reference) |
| `0x21` | [CO-AUTHOR](/ru/grammar/meta/provenance/co-author/) | Соавтор |
| `0x22` | [CREATED-AT](/ru/grammar/meta/provenance/created-at/) | Время создания |
| `0x23` | [MODIFIED-AT](/ru/grammar/meta/provenance/modified-at/) | Время изменения |
| `0x24` | [RECORDED-BY](/ru/grammar/meta/provenance/recorded-by/) | Кто записал |
| `0x25` | [RECORDED-AT](/ru/grammar/meta/provenance/recorded-at/) | Когда записано |
| `0x26`~`0x2F` | Reserved | |

- Первоисточник пишется не в Meta, а в HEAD как Edge основания [SOURCE](/ru/grammar/edge/source/#источник-всего-документа) (Target `0`), а диапазон в исходном тексте, время получения и хеш исходного текста — как QUALIFIER, прикреплённые к этому SOURCE.

## Родословная

Сводная страница: [Meta — Родословная](/ru/grammar/meta/lineage/)

Родословная следует модели коммитов git. Единица, соответствующая коммиту, — документ.

| Codec | Имя | Значение |
|---|---|---|
| `0x30` | [PARENT](/ru/grammar/meta/lineage/parent/) | Хеш содержимого непосредственно предыдущей версии. Если их несколько — слияние |
| `0x31` | [DERIVED-FROM](/ru/grammar/meta/lineage/derived-from/) | Производная от материала из другой родословной |
| `0x32` | [GENERATED-BY](/ru/grammar/meta/lineage/generated-by/) | Создатель (человек, модель, движок правил) |
| `0x33` | [TRANSFORMED-BY](/ru/grammar/meta/lineage/transformed-by/) | Инструмент преобразования и версия его исходников (дайджест коммита) |
| `0x34` | [CHERRY-PICKED-FROM](/ru/grammar/meta/lineage/cherry-picked-from/) | Исходная версия перенесённого изменения |
| `0x35` | [REVERTS](/ru/grammar/meta/lineage/reverts/) | Версия, изменения которой отменены |
| `0x36` | [REPLACES](/ru/grammar/meta/lineage/replaces/) | Версия, переписанная заново. Исходная версия не удаляется |
| `0x37` | [SQUASHED-FROM](/ru/grammar/meta/lineage/squashed-from/) | Исходные версии, слитые в одну |
| `0x38` | [MESSAGE](/ru/grammar/meta/lineage/message/) | Причина изменения. По одному на язык |
| `0x39` | [TAG](/ru/grammar/meta/lineage/tag/) | Неизменяемое имя, данное версии |
| `0x3A` | [DELTA-BASE](/ru/grammar/meta/lineage/delta-base/) | Этот файл — diff относительно базовой версии |
| `0x3B` | [DELTA-REMOVE](/ru/grammar/meta/lineage/delta-remove/) | Список LOCAL ID, исключаемых из diff |
| `0x3C` | [NEXT-LOCAL-ID](/ru/grammar/meta/lineage/next-local-id/) | LOCAL ID, который будет назначен следующим. Размещается в документе списка версий |

- История не удаляется. Исправления выпускаются как новая версия.
- Изменяемые указатели вроде branch в документе не хранятся. Ими управляют хранилище и индекс.

## Проверка

Сводная страница: [Meta — Проверка](/ru/grammar/meta/verification/)

| Codec | Имя | Значение |
|---|---|---|
| `0x40` | [ISSUER-KEY](/ru/grammar/meta/verification/issuer-key/) | Алгоритм подписи и открытый ключ самостоятельно выданного Issuer |
| `0x41` | [SIGNATURE](/ru/grammar/meta/verification/signature/) | Подпись хеша содержимого. Алгоритм, подписант, подпись |
| `0x42` | [SIGNED-OFF](/ru/grammar/meta/verification/signed-off/) | Подтверждение права на вклад |
| `0x43` | [CONFIDENCE](/ru/grammar/meta/verification/confidence/) | Степень доверия |
| `0x44` | [VERDICT](/ru/grammar/meta/verification/verdict/) | Вердикт по всему документу (Pass, Review, Fail) |

- Класс проверки исключается из вычисления хеша содержимого. Поэтому хеш содержимого не меняется ни от того, что подпись лежит внутри документа, ни от добавления новых подписей.

## Политика

Сводная страница: [Meta — Политика](/ru/grammar/meta/policy/)

| Codec | Имя | Значение |
|---|---|---|
| `0x50` | [LICENSE](/ru/grammar/meta/policy/license/) | Лицензия |
| `0x51` | [ACCESS](/ru/grammar/meta/policy/access/) | Область доступа |
| `0x52` | [PRIVACY](/ru/grammar/meta/policy/privacy/) | Уровень персональных данных |
| `0x53` | [RETENTION](/ru/grammar/meta/policy/retention/) | Срок хранения |
| `0x54` | [CONSENT](/ru/grammar/meta/policy/consent/) | Область и основание согласия |
| `0x55` | [USAGE](/ru/grammar/meta/policy/usage/) | Ограничения использования |

- Политика не меняет интерпретацию, а определяет порядок обращения.

## IMPORT

Сводная страница: [Meta — IMPORT](/ru/grammar/meta/import/)

```
TAG WORD          0001 1LLL L110 0000      IMPORT-DOC (0x60)
[Length extension TAG]
Документ          запись DOC-POINTER (Issuer, ID документа, ID версии)
IMPORT ID         остаток. Целое число наименьшей ширины
```

- Используется только [IMPORT-DOC](/ru/grammar/meta/import/import-doc/) (`0x60`). IMPORT импортирует только документы. Объект внутри импортированного документа указывается в BODY через `EXTERNAL-POINTER-*` (IMPORT ID, LOCAL ID).
- Если указан ID версии, привязка идёт к этой редакции, а при `0` — к последней редакции на момент интерпретации. Опубликованные документы указывают версию.
- В одном документе один и тот же IMPORT ID не назначается дважды.
- HEAD импортированного документа не импортируется. Объекты этого документа интерпретируются по его собственным объявлениям.

Пример: импортировать последнюю версию документа `0x0000000000000002` Issuer `0x0001` с IMPORT ID 1.

```
1CE0 03B8 0001 0000 0000 0000 0002 0000 0000 0001
```
