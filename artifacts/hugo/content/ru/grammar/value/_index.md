---
title: "Value"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "Value — запись, хранящая само значение. Старшие 2 бита Codec задают семейство (числа и десятичные числа, время, текст, бинарные данные); часто используемые форматы получают прямые коды, остальные — форматы Issuer по организациям-разработчикам стандартов."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Value — запись, хранящая само значение. Codec определяет, как интерпретировать Payload.

## Раскладка

```
TAG WORD          0000 1LLL LCCC CCCC
[Length extension TAG]
[Codec extension TAG]  для формата Issuer
Payload
```

- `LLLL` — общее число WORD вместе с TAG WORD, минус 1. Для 1–14 WORD длина прямая, для 15 WORD и более — расширенная.
- Для формата Issuer Codec extension TAG содержит Issuer (ширина 1/2/4/16 WORD, задаётся Codec) и номер формата в 1 WORD. Старшие 2 бита номера формата задают семейство.
- Декодер знает семейство и Length, даже если не знает формата.

## Семейства

Семейство задают старшие 2 бита Codec. Прямой код (7 бит) и номер формата Issuer (16 бит) подчиняются одному правилу, поэтому семейство известно и без codebook.

| Старшие 2 бита | Семейство | Прямой код | Номер формата |
|---|---|---|---|
| `00` | NUMERIC / DECIMAL | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | TIME | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | TEXT | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | BINARY | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

- NUMERIC / DECIMAL делится далее по третьему биту: `000` — NUMERIC, `001` — DECIMAL.
- Числовые значения — векторы, тензоры, комплексные числа, дроби, интервалы — относятся к NUMERIC. Исключение: BIT-VECTOR относится к BINARY. Коды языков относятся к TEXT.
- Запись формата Issuer снабжается Codec extension TAG (Issuer и номер формата). Если Payload длинный (всего 15 WORD и более), используется Length extension TAG.

## Прямые коды

| Codec | Имя | Семейство | Описание |
|---|---|---|---|
| `0x00` | [BOOL](/ru/grammar/value/numeric/bool/) | NUMERIC | false или true |
| `0x01` | [SIGNED-INTEGER](/ru/grammar/value/numeric/signed-integer/) | NUMERIC | целое в дополнительном коде, минимальное число WORD |
| `0x02` | [UNSIGNED-INTEGER](/ru/grammar/value/numeric/unsigned-integer/) | NUMERIC | целое без знака, минимальное число WORD |
| `0x03` | [BINARY-FLOAT](/ru/grammar/value/numeric/binary-float/) | NUMERIC | IEEE 754 binary16/32/64/128 |
| `0x04` | [COORDINATE-EARTH](/ru/grammar/value/numeric/coordinate-earth/) | NUMERIC | широта и долгота на Земле (WGS 84) и неопределённость (с Reference единицы) |
| `0x05` | [COORDINATE-GEO](/ru/grammar/value/numeric/coordinate-geo/) | NUMERIC | Reference небесного тела, широта, долгота и неопределённость (с Reference единицы) |
| `0x06` | [QUANTITY](/ru/grammar/value/numeric/quantity/) | NUMERIC | числовая величина (целое, BINARY-FLOAT, десятичное, дробь), Reference единицы, нижняя и верхняя границы |
| `0x07` | [FRACTION](/ru/grammar/value/numeric/fraction/) | NUMERIC | Дробь с сохранением записи (записи числителя и знаменателя, без сокращения) |
| `0x10` | [SIGNED-DECIMAL](/ru/grammar/value/decimal/signed-decimal/) | DECIMAL | `C × 10^E`, коэффициент со знаком |
| `0x11` | [UNSIGNED-DECIMAL](/ru/grammar/value/decimal/unsigned-decimal/) | DECIMAL | `C × 10^E`, коэффициент без знака |
| `0x20` | [GREGORIAN-DATE](/ru/grammar/value/time/gregorian-date/) | TIME | число дней с 1970-01-01 (григорианский календарь) |
| `0x21` | [CIVIL-TIME-NANOSECONDS](/ru/grammar/value/time/civil-time-nanoseconds/) | TIME | наносекунды с полуночи |
| `0x22` | [POSIX-TIMESTAMP-SECONDS](/ru/grammar/value/time/posix-timestamp-seconds/) | TIME | секунды с Unix epoch |
| `0x23` | [DURATION-SECONDS](/ru/grammar/value/time/duration-seconds/) | TIME | прошедшее время (секунды) |
| `0x24`/`0x25` | [EDTF](/ru/grammar/value/time/edtf/) | TIME | расширенная строка даты ISO 8601-2 (точность до года и месяца, неопределённость, интервалы) |
| `0x26`/`0x27` | [GEDCOM-DATE](/ru/grammar/value/time/gedcom-date/) | TIME | строка даты GEDCOM 7 (другие календари, например юлианский) |
| `0x40`/`0x41` | [UTF8-TEXT](/ru/grammar/value/text/utf8-text/) | TEXT | строка UTF-8 без языка |
| `0x44`/`0x45` | [URI](/ru/grammar/value/text/uri/) | TEXT | URI по RFC 3986 |
| `0x46`/`0x47` | [LANGUAGE-BCP47-CODE](/ru/grammar/value/text/language-bcp47-code/) | TEXT | языковой тег BCP 47 |
| `0x48` | [LANGUAGE-SHORT-CODE](/ru/grammar/value/text/language-short-code/) | TEXT | сжатый код языка в 1 WORD |
| `0x4A`/`0x4B` | [UTF8-LANGUAGE-TEXT](/ru/grammar/value/text/utf8-language-text/) | TEXT | текст с указанием языка |
| `0x60` | [UUID](/ru/grammar/value/binary/uuid/) | BINARY | UUID по RFC 9562 |
| `0x61` | [SHA-256-DIGEST](/ru/grammar/value/binary/sha-256-digest/) | BINARY | результат SHA-256 |
| `0x62` | [SHA1-DIGEST](/ru/grammar/value/binary/sha1-digest/) | BINARY | результат SHA-1 (для идентификации, например ID объектов git) |

- Коды, объединённые в чётно-нечётную пару, — байтовые строки переменной длины. Чётный код означает чётное число байтов, нечётный — нечётное ([Записи и TAG WORD](/ru/grammar/record/)).
- Прямые коды, не вошедшие в таблицу, зарезервированы.

## Форматы Issuer

Формат, которого нет среди прямых кодов, размещается под номером формата в Issuer организации, принявшей этот формат. Условные форматы без организации-автора — под ADHOC (`0x0001`), собственные форматы GEUL — под GEUL (`0x0000`).

| Issuer | Примеры форматов |
|---|---|
| GEUL `0x0000` | DURATION-NANOSECONDS, OPAQUE-BYTES, BIT-VECTOR |
| ADHOC `0x0001` | BFLOAT16, целочисленные и вещественные векторы, тензоры, комплексные числа, дроби, интервалы, кватернионы, BLAKE3 |
| IETF `0x0020` | относительный URI, CRC32C, адреса IPv4 и IPv6 |
| IEEE `0x0040` | IEEE 754 decimal32/64/128, метка времени POSIX в наносекундах, MAC-адрес |
| KHRONOS `0x0041` | пиксели RGBA8 и BGRA8 |
| ONNX `0x0043`, OCP `0x0044` | FP8, FP4 |
| BIPM `0x0060` | метка времени TAI |
| NIST `0x0062` | SHA-512, SHA3-256 |
| GPS `0x0063` | метка времени GPS |

- Декодер, не знающий формата, знает только семейство по номеру формата и пропускает Payload.
- Крупные значения вроде изображений и видео лучше не вставлять напрямую, а ссылаться на них через URI и SHA-256.
- Произведения внутри байтовой строки подчиняются исходной лицензии. Источник и лицензия записываются в Meta.

## Группы форматов

Раскладка, интерпретация, допустимость и примеры каждого формата описаны в документах по группам.

| Группа | Семейство | Форматы |
|---|---|---|
| [numeric](/ru/grammar/value/numeric/) | NUMERIC | BOOL, целые, числа с плавающей запятой, координаты, QUANTITY, FRACTION |
| [decimal](/ru/grammar/value/decimal/) | DECIMAL | SIGNED-DECIMAL, UNSIGNED-DECIMAL, IEEE 754 decimal32/64/128 |
| [time](/ru/grammar/value/time/) | TIME | дата, время суток, метка времени, длительность, EDTF, дата GEDCOM |
| [text](/ru/grammar/value/text/) | TEXT | текст UTF-8, текст с языком, URI, коды языков |
| [binary](/ru/grammar/value/binary/) | BINARY | UUID, дайджесты, CRC, сетевые адреса, неопознанные байтовые строки, битовые векторы |
| [vector](/ru/grammar/value/vector/) | NUMERIC | плотные целочисленные и вещественные векторы, точки и ограничивающие рамки, пиксели RGBA и BGRA |
| [tensor](/ru/grammar/value/tensor/) | NUMERIC | плотные (dense) и упакованные (packed) тензоры с форматом, rank и shape |
| [etc](/ru/grammar/value/etc/) | NUMERIC | комплексные числа, дроби, замкнутые интервалы, кватернионы |

- Группы vector, tensor и etc — это форматы Issuer (ADHOC, KHRONOS) семейства NUMERIC.

## Текст

Текст с языком и текст без языка — разные значения. «Paris» (строка) и «Paris» (французский) не равны.

| Формат | Где применяется |
|---|---|
| UTF8-TEXT | строки без языка: идентификаторы, коды, имена файлов, внешние ID |
| UTF8-LANGUAGE-TEXT | текст с языком: имена, заголовки, предложения |

```
UTF8-LANGUAGE-TEXT
TAG WORD          0000 1LLL L100 101P   (P = в тексте нечётное число байтов)
[Length extension TAG]
Язык              запись LANGUAGE-SHORT-CODE или LANGUAGE-BCP47-CODE
Текст             байты UTF-8 (если нечётное число, в конце 0x00)
```

- Текст — well-formed UTF-8, хранится в исходном виде. Нормализация — забота стороны, которая сравнивает и индексирует.
- Имя, общее для нескольких языков, записывается с языком `mul`, неопределённый язык — `und`. Строка без языкового содержания — это UTF8-TEXT.

Пример: `"Douglas Adams"@en` (13 байтов, нечётное число)

```
0CCB  08C6 656E  446F 7567 6C61 7320 4164 616D 7300
TAG   язык en    D o  u g  l a  s ␠  A d  a m  s (padding)
```

## Десятичные числа и величины

Точное десятичное число записывается как `C × 10^E`. Показатель `E` — 32 бита, коэффициент `C` — дополнительный код с минимальным числом WORD. Число знаков исходной записи сохраняется как есть: `1.20` — это `C=120, E=−2`, а `1.2` — `C=12, E=−1`. Две записи обозначают одно число, но это разные записи с разными байтами. Кодировщик не нормализует запись произвольно. Равенство значений двух записей и смысл quantum (значащих цифр) — открытый вопрос ([SIGNED-DECIMAL](/ru/grammar/value/decimal/signed-decimal/#открытые-вопросы)).

QUANTITY объединяет величину, единицу и границы в одно значение.

```
TAG WORD          0000 1LLL L000 0110
[Length extension TAG]
Величина          числовая запись Value (целое, BINARY-FLOAT, десятичное, дробь)
Единица           запись Reference (элемент-единица), 0x0000 для безразмерной величины
Нижняя граница    числовая запись Value, 0x0000 ABSENT, если опущено
Верхняя граница   числовая запись Value, 0x0000 ABSENT, если опущено
```

- Единица — часть значения. Её не отделяют и не записывают в другом месте (без неё нельзя понять, `652` — это км или м).
- Значение, пересчитанное в единицы SI, не хранится. Его можно вычислить по единице и таблице пересчёта.
- `0x0000` (ABSENT) — признак того, что необязательное поле опущено ([Спецификация Codec](/ru/grammar/codec-spec/)).

Пример: `652 km`, диапазон `[651, 653]` (km = Wikidata Q828224)

```
0F06 0011                    TAG (расширенная длина, 17 WORD)
0990 0000 0000 028C          величина 652
0120 000C A340               единица Q828224
0990 0000 0000 028B          нижняя граница 651
0990 0000 0000 028D          верхняя граница 653
```

## Даты

| Точность | Формат |
|---|---|
| Дата (григорианский календарь) | GREGORIAN-DATE |
| Год и месяц, неопределённость (`1971~`), интервал | EDTF |
| Исходная запись в другом календаре (юлианский и др.) | GEDCOM-DATE |
| Время суток | метки времени POSIX, TAI, GPS |

- Дату, которую можно записать как GREGORIAN-DATE, не записывают как EDTF.

## Открытые вопросы

- Открытые медиаформаты (JPEG, PNG, MP4, MOV и др.) размещаются номерами форматов BINARY в Issuer IANA (`0x0021`). Как вести таблицу соответствия медиатипов и номеров форматов.
- Окончательный список прямых кодов Value. Определяется по измерению частоты Value в выборках законов и деловых диалогов (кандидаты: денежная сумма, процент, интервал дат).
- Подробная спецификация и размещение семи малых скаляров (ADHOC BFLOAT16, четыре ONNX FP8, OCP FP8-E8M0FNU и FP4-E2M1FN). Не решено, переносить ли их в зарезервированный диапазон прямых кодов NUMERIC (`0x08`~`0x0F`). Пока назначены только номера форматов.
