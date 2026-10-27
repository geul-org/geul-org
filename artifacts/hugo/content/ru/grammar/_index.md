---
title: "Грамматика GEUL"
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "specification"]
summary: "Спецификация грамматики GEUL v1. Определяет записи на 16-битных словах, четыре вида Kind и все Codec, структуру документа, Issuer и правила публикации."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
showContent: true
---

Спецификация грамматики GEUL v1. Если вы читаете её впервые, читайте в следующем порядке.

1. [Обзор](/ru/grammar/overview/) — что такое GEUL и по каким принципам он спроектирован
2. [Запись и TAG WORD](/ru/grammar/record/) — 16-битный TAG WORD, Kind, Length, Codec
3. [Документ](/ru/grammar/document/) — HEAD и BODY, хеш содержимого, версии и редакции
4. [Reference](/ru/grammar/reference/), [Value](/ru/grammar/value/), [Edge](/ru/grammar/edge/), [Meta](/ru/grammar/meta/) — четыре вида Kind
5. [Issuer и публикация](/ru/grammar/issuer/) — субъекты, выпускающие документы и форматы, таблица назначения 1 WORD, способы раскрытия, подпись и ключ проверки
6. [Адрес публикации и список версий](/ru/grammar/publishing/) — запись ID, адрес публикации, указание формата, индекс имён, список версий, уровни доверия
7. [Спецификация Codec](/ru/grammar/codec-spec/) — как записывать раскладку Codec документом GEUL
8. [Пример: элемент Викиданных](/ru/grammar/example/) — один настоящий документ

Эта страница — указатель всех Codec. Нажмите на имя, чтобы перейти к подробному документу этого Codec. Имена без ссылки пока не имеют подробного документа. Прямые коды, которых нет в таблицах, зарезервированы.

## Kind

TAG WORD — это `000K KLLL LCCC CCCC`. `KK` — Kind, `LLLL` — Length, `CCC CCCC` — 7 бит Codec. Но у Reference — 4 бита Codec и 3 бита Quantifier.

| Значение | Категория | Описание |
|---|---|---|
| `0000 0LLL LCCC CQQQ` | [Reference](/ru/grammar/reference/) | Запись, указывающая на объект. `QQQ` — Quantifier |
| `0000 1LLL LCCC CCCC` | [Value](/ru/grammar/value/) | Запись значения |
| `0001 0LLL LCCC CCCC` | [Edge](/ru/grammar/edge/) | Составная запись |
| `0001 1LLL LCCC CCCC` | [Meta](/ru/grammar/meta/) | Запись о документе и о записях |

## Reference

`0000 0LLL LCCC CQQQ` — [Reference](/ru/grammar/reference/)

### Codec (`CCCC`)

| CCCC | Имя | Категория | ID объекта |
|---|---|---|---|
| `0000` | [Маркер слота](/ru/grammar/reference/slot-marker/) | зарезервировано | Набор маркеров в 1 WORD, не указывающих на объект. Младшие 3 бита — номер маркера (таблица ниже) |
| `0001` | [LOCAL](/ru/grammar/reference/local/) | объявление | ID, выданный этим документом |
| `0010` | [GEUL](/ru/grammar/reference/geul/) | объявление | Сущность, которую geul.org выдаёт под CC0. Малые номера назначаются сущностям с высокой частотой |
| `0011` | [GEUL-SIDX](/ru/grammar/reference/geul-sidx/) | объявление | GEUL SIDX (Semantic-aligned Index). Идентификатор, биты которого несут смысл |
| `0100` | [WIKIDATA-QID](/ru/grammar/reference/wikidata-qid/) | объявление | Элемент Викиданных. Целое число после `Q` |
| `0101` | [WIKIDATA-PID](/ru/grammar/reference/wikidata-pid/) | объявление | Свойство Викиданных. Целое число после `P` |
| `0110` | [ISSUER-POINTER](/ru/grammar/reference/issuer-pointer/) | указатель-объявление | Сам Issuer. Payload — только Issuer (1/2/4/16 WORD), ID объекта нет |
| `0111` | [DOC-POINTER](/ru/grammar/reference/doc-pointer/) | указатель-объявление | Одна версия документа Issuer. Issuer + ID документа 4 WORD + ID версии 2 WORD, ID объекта нет |
| `1000` | [EXTERNAL-POINTER-1WORD](/ru/grammar/reference/external-pointer/) | указатель | LOCAL ID документа, импортированного через `IMPORT-DOC`. IMPORT ID 1 WORD |
| `1001` | [EXTERNAL-POINTER-2WORD](/ru/grammar/reference/external-pointer/) | указатель | То же. IMPORT ID 2 WORD |
| `1010` | [EXTERNAL-POINTER-4WORD](/ru/grammar/reference/external-pointer/) | указатель | То же. IMPORT ID 4 WORD |
| `1011` | [EXTERNAL-POINTER-8WORD](/ru/grammar/reference/external-pointer/) | указатель | То же. IMPORT ID 8 WORD |
| `1100` | [EXTERNAL-ISSUER-1WORD](/ru/grammar/reference/external-issuer/) | указатель-объявление | LOCAL ID документа Issuer в 1 WORD |
| `1101` | [EXTERNAL-ISSUER-2WORD](/ru/grammar/reference/external-issuer/) | указатель-объявление | LOCAL ID документа Issuer в 2 WORD |
| `1110` | [EXTERNAL-ISSUER-4WORD](/ru/grammar/reference/external-issuer/) | указатель-объявление | LOCAL ID документа Issuer в 4 WORD |
| `1111` | [EXTERNAL-ISSUER-16WORD](/ru/grammar/reference/external-issuer/) | указатель-объявление | LOCAL ID документа Issuer в 16 WORD |

### Маркер слота (Codec `0000`)

`0000 0000 0000 0MMM` — [Маркер слота](/ru/grammar/reference/slot-marker/). Появляется на месте поля, только если список CODEC этого поля точно содержит этот WORD.

| WORD | Имя | Смысл | Wikidata |
|---|---|---|---|
| `0x0000` | [ABSENT](/ru/grammar/reference/slot-marker/) | Не записано. Необязательное поле опущено. Ничего не утверждает о мире | snak нет |
| `0x0001` | [UNKNOWN-VALUE](/ru/grammar/reference/slot-marker/) | Неизвестно. Значение есть, но какое — неизвестно | `somevalue` |
| `0x0002` | [NO-VALUE](/ru/grammar/reference/slot-marker/) | Нет. Значения нет | `novalue` |
| `0x0003`~`0x0007` | Reserved | | |

### Quantifier (`QQQ`)

| QQQ | Имя | Смысл | Пример |
|---|---|---|---|
| `000` | Identified | Идентифицированный объект | Илон Маск, Республика Корея |
| `001` | Generic | Общее, определяющее высказывание о целом виде. Допускает исключения. | Солдат подчиняется приказу |
| `010` | Free-choice | Любой объект, удовлетворяющий условию | любой солдат |
| `011` | Universal | Все объекты из заданного диапазона | все солдаты |
| `100` | Variable | Дискурсивная переменная | тот человек, эта женщина |
| `101`~`111` | Reserved |  |  |

- У Codec `0000` (маркер слота) младшие 3 бита — не Quantifier, а номер маркера.

## Issuer

Issuer — субъект, определяющий документы и форматы — [Issuer и публикация](/ru/grammar/issuer/)

| Место | Смысл |
|---|---|
| Коды ISSUER у Value и Edge (`0x7C`~`0x7F`) | Формат, определённый этим Issuer |
| Meta `DOC-ID` | Issuer, выпустивший этот документ |
| Meta `IMPORT-DOC` | Issuer, выпустивший импортированный документ |
| Reference `EXTERNAL-ISSUER-*`, `DOC-POINTER` | Issuer, выпустивший документ, на который указывают (1/2/4/16 WORD) |
| Reference `ISSUER-POINTER` | Сам Issuer, на который указывают (1/2/4/16 WORD) |

| Ширина Issuer | Выдача |
|---|---|
| 1 WORD | geul.org назначает организациям-разработчикам стандартов и основным учреждениям ([таблица назначения 1 WORD](/ru/grammar/issuer/#таблица-назначения-1-word)). |
| 2 WORD | Регистрация в geul.org. Issuer, прошедший подтверждение владения доменом (например, company.com) |
| 4 WORD | Регистрация в geul.org. Issuer, зарегистрированный без подтверждения владения |
| 16 WORD | Самостоятельная выдача. Вычисляется из открытого ключа без регистрации. Следует правилам генерации ниже. |

### Алгоритм подписи Issuer в 16 WORD

| ID алгоритма подписи | Алгоритм |
|---|---|
| `0x0001` | Ed25519 |
| Прочие | Зарезервировано |

## Edge

`0001 0LLL LCCC CCCC` — [Edge](/ru/grammar/edge/)

Семейство задают два старших бита Codec. Прямые коды (7 бит) и номера форматов ISSUER (16 бит) следуют одному правилу.

| Старшие 2 бита | Семейство | Прямой код | Номер формата |
|---|---|---|---|
| `00` | описание | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | основание | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | исполнение | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | [TOULMIN](/ru/grammar/edge/toulmin/) | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

### Описание (`00`)

| CCCCC | Codec | Имя | Подформат | Описание |
|---|---|---|---|---|
| `00000` | `0x00` | [REFERENCE-NODE](/ru/grammar/edge/reference-node/) |  | Направленная привязка, в которой Subject (Reference) указывает на Object |
| `00001` | `0x01` | [SAME-NODE](/ru/grammar/edge/same-node/) |  | Тождество: два Reference указывают на один и тот же объект |
| `00010` | `0x02` | [DIFFERENT-NODE](/ru/grammar/edge/different-node/) |  | Нетождество: два Reference указывают на разные объекты |
| `00011` | `0x03` | [BIND](/ru/grammar/edge/bind/) |  | Привязывает к Subject имя для машинного сопоставления (`UTF8-TEXT-*`). Уникально в области, должно совпадать точно, языка нет |
| `00100` | `0x04` | [LABEL](/ru/grammar/edge/label/) |  | Связывает Subject с названием (label) на языке. Object — UTF8-LANGUAGE-TEXT |
| `00101` | `0x05` | [ALIAS](/ru/grammar/edge/alias/) |  | Связывает Subject с другим именем (псевдонимом). Раскладка как у LABEL |
| `00110` | `0x06` | [DESCRIPTION](/ru/grammar/edge/description/) |  | Связывает Subject с описанием (description) на языке. Раскладка как у LABEL |
| `00111` | `0x07` | Reserved |  |  |
| `01000` | `0x08` | VERB-SHORT |  | Сокращённое описание глагола |
| `01001` | `0x09` | VERB |  | Описание глагола |
| `01010` | `0x0A` | [TRIPLE](/ru/grammar/edge/triple/) |  | Высказывание в порядке Predicate, Subject, Object и rank. Object — значение либо маркер UNKNOWN-VALUE, NO-VALUE. Смысл — совокупность всех QUALIFIER, указывающих на его Edge Id |
| `01011` | `0x0B` | [QUALIFIER](/ru/grammar/edge/qualifier/) |  | Одно условие, уточняющее высказывание другого Edge. Property, Target (Edge Id), Value (значение либо маркер UNKNOWN-VALUE, NO-VALUE). Часть высказывания |
| `01100`~`01111` | `0x0C`~`0x0F` | Reserved |  |  |
| `10000` | `0x10` | WORLD | есть | Структура для выражения мира (мировоззрения) |
| `10001` | `0x11` | TIMELINE | есть | Структура для выражения порядка мира и событий |
| `10010` | `0x12` | SCENE | есть | Структура сцены для описания сценарных свойств |
| `10011`~`10111` | `0x13`~`0x17` | Reserved |  |  |
| `11000` | `0x18` | [PUBLICATION](/ru/grammar/edge/publication/) |  | Публикация документа. DOC-POINTER, хеш содержимого |
| `11001` | `0x19` | DEPRECATION |  | Признание опубликованной версии устаревшей (deprecate). DOC-POINTER |
| `11010` | `0x1A` | TOMBSTONE |  | Удаление опубликованной версии (надгробие). DOC-POINTER, категория причины |
| `11011` | `0x1B` | [DECLARE](/ru/grammar/edge/declare/) |  | Объявление состава Payload одного Codec. Целевые Kind и Codec |
| `11100` | `0x1C` | [FIELD](/ru/grammar/edge/field/) |  | Одно поле Payload. Его DECLARE, ширина: запись (Length в TAG) или сырое значение в n WORD |
| `11101` | `0x1D` | [ENUM](/ru/grammar/edge/enum/) |  | Одно кодовое значение сырого поля. Поле, кодовое значение |
| `11110` | `0x1E` | [CODEC](/ru/grammar/edge/codec/) |  | Один Kind и Codec, принимаемый полем. Поле, целевой WORD (`000K KLLL LCCC CCCC`, LLLL 0000 — точно, 1111 — wildcard; маркер слота — только точным объектом `0000`~`0002`). У поля записи таких объектов несколько (закрытый список), у сырого поля — один (Value без TAG) |
| `11111` | `0x1F` | Reserved |  |  |

| Старшие 2 бита CCCCC | Группа |
|---|---|
| `00` | указатели и имена |
| `01` | высказывания |
| `10` | структура |
| `11` | прочее |

### Основание (`01`)

| Codec | Имя | Подформат | Описание |
|---|---|---|---|
| `0x20` | [SOURCE](/ru/grammar/edge/source/) |  | Связывает одну запись или весь документ с их первоисточником. Target (Edge Id в BODY, в HEAD `0` = весь документ), Origin (Reference, ABSENT или UNKNOWN-VALUE). Свойства первоисточника — TRIPLE с первоисточником в роли Subject, свойства цитирования (дата обращения, место, хеш исходного текста) — QUALIFIER, прикреплённые к SOURCE. SOURCE всего документа и его QUALIFIER помещаются в HEAD |
| `0x21`~`0x3F` | Reserved |  |  |

- Диапазон в исходном тексте, создавший субъект, достоверность, срок действия по статьям и прежние записи записываются как QUALIFIER, а версия, в которой запись появилась впервые, вычисляется по истории версий ([SOURCE](/ru/grammar/edge/source/#представление-других-оснований)).

### Исполнение (`10`)

| CCCCC | Codec | Имя | Описание |
|---|---|---|---|
| `00000` | `0x40` | Reserved |  |
| `00001` | `0x41` | FUNCTION-DECLARE | Объявление функции. Символ, список символов параметров, тип возврата, тело (BLOCK) |
| `00010` | `0x42` | TYPE-DECLARE | Объявление типа. Символ и состав (список символов полей, значения перечисления, целевой тип псевдонима) |
| `00011`~`00111` | `0x43`~`0x47` | Reserved |  |
| `01000` | `0x48` | CONST | Константное выражение. Один встроенный Value |
| `01001` | `0x49` | UNARY | Унарное выражение. Оператор 1 WORD, операнд |
| `01010` | `0x4A` | BINARY | Бинарное выражение. Оператор 1 WORD, левый, правый |
| `01011` | `0x4B` | CALL | Вызов. Целевая функция, число аргументов, аргумент × число аргументов |
| `01100` | `0x4C` | MEMBER | Доступ к члену. Цель, символ поля |
| `01101` | `0x4D` | INDEX | Доступ по индексу. Цель, индекс |
| `01110` | `0x4E` | CONSTRUCT | Создание составного значения (список, запись). Тип, число элементов, элемент × число элементов |
| `01111` | `0x4F` | CONDITIONAL | Условное выражение. Условие, значение при истине, значение при лжи |
| `10000` | `0x50` | BLOCK | Упорядоченная группа операторов. Число операторов, оператор × число операторов |
| `10001` | `0x51` | ASSIGN | Присваивание. Цель (символ, MEMBER, INDEX), значение |
| `10010` | `0x52` | IF | Условное ветвление. Условие, BLOCK при истине, ложь (BLOCK, IF; если нет — 0) |
| `10011` | `0x53` | SWITCH | Многоветвевой выбор. Цель, число ветвей, (значение, BLOCK) × число ветвей, BLOCK по умолчанию (если нет — 0) |
| `10100` | `0x54` | WHILE | Цикл по условию. Условие, BLOCK тела |
| `10101` | `0x55` | FOREACH | Цикл по элементам. Символ элемента, цель, BLOCK тела |
| `10110` | `0x56` | JUMP | Управление циклом. Вид 1 WORD (break, continue), целевой цикл |
| `10111` | `0x57` | RETURN | Возврат. Значение (если нет — 0) |
| `11000` | `0x58` | RAISE | Возбуждение ошибки. Значение ошибки |
| `11001` | `0x59` | TRY | Обработка ошибок. BLOCK тела, символ ошибки, BLOCK обработки, BLOCK завершения (если нет — 0) |
| `11010`~`11111` | `0x5A`~`0x5F` | Reserved |  |

| Старшие 2 бита CCCCC | Группа |
|---|---|
| `00` | объявления |
| `01` | выражения |
| `10` | операторы |
| `11` | ошибки |

### TOULMIN (`11`)

Подробнее: [TOULMIN](/ru/grammar/edge/toulmin/)

| CCCCC | Codec | Имя | Описание |
|---|---|---|---|
| `00000` | `0x60` | [CASE-DECLARE](/ru/grammar/edge/toulmin/node/) | Объявление дела. Граф вердикта, содержащий узлы и отношения |
| `00001` | `0x61` | [PREDICATE-DECLARE](/ru/grammar/edge/toulmin/expr/) | Объявление предиката. Функция или выражение вердикта, критерий (Spec), контракт фактов (Ground) |
| `00010` | `0x62` | [SPEC-DECLARE](/ru/grammar/edge/toulmin/node/) | Объявление критерия. Константы и списки (Backing) |
| `00011` | `0x63` | [RULE-DECLARE](/ru/grammar/edge/toulmin/node/) | Объявление утверждения. Помещает предикат в деле как общее правило (Warrant). Может быть атакован. |
| `00100` | `0x64` | [COUNTER-DECLARE](/ru/grammar/edge/toulmin/node/) | Объявление возражения. Атакует с собственным выводом. Level по умолчанию — Fail |
| `00101` | `0x65` | [EXCEPT-DECLARE](/ru/grammar/edge/toulmin/node/) | Объявление исключения. Атакует без собственного вывода. Level по умолчанию — Review |
| `00110`~`00111` | `0x66`~`0x67` | Reserved |  |
| `01000` | `0x68` | [ATTACKS](/ru/grammar/edge/toulmin/link/) | Отношение атаки. Вердикт атакующего постепенно уменьшает вердикт цели. |
| `01001` | `0x69` | [SUPERSEDES](/ru/grammar/edge/toulmin/link/) | Отношение вытеснения. Если атакующий Active, цель детерминированно исключается из агрегирования. |
| `01010` | `0x6A` | SUPERSEDE-CHAIN | Цепочка приоритета `A > B > C`. Сокращение попарных SUPERSEDES. Раскладка не определена |
| `01011`~`01111` | `0x6B`~`0x6F` | Reserved |  |
| `10000` | `0x70` | [RUN](/ru/grammar/edge/toulmin/link/) | Композиция исполнения. Если узел Active, выполняет нижестоящее дело (DAG). |
| `10001` | `0x71` | [DO](/ru/grammar/edge/toulmin/link/) | Действие, выполняемое, если узел Active |
| `10010` | `0x72` | [DO-ONCE](/ru/grammar/edge/toulmin/link/) | Действие, выполняемое один раз даже при повторных попытках |
| `10011` | `0x73` | [UNDO](/ru/grammar/edge/toulmin/link/) | Компенсирующее действие для DO (saga). Если последующий шаг завершается неудачей, выполняется в обратном порядке. |
| `10100` | `0x74` | [CHECKING](/ru/grammar/edge/toulmin/link/) | Связь, которая только выносит вердикт, без побочных эффектов |
| `10101` | `0x75` | [ENTRY](/ru/grammar/edge/toulmin/node/) | Внешняя точка входа. Выполняет дело или выносит по нему вердикт |
| `10110` | `0x76` | [TRIGGER](/ru/grammar/edge/toulmin/node/) | Точка входа по событию или периоду без внешнего вызова |
| `10111` | `0x77` | Reserved |  |
| `11000` | `0x78` | VERDICT | Результат вердикта узла или записи. Результат (Pass, Review, Fail), значение вердикта, Activated, Excluded, Level. Раскладка не определена. Вердикт по всему документу — Meta [VERDICT](/ru/grammar/meta/verification/verdict/) (`0x44`) |
| `11001` | `0x79` | EVIDENCE | Доказательство вердикта. Положение, ожидаемое значение, фактическое значение (Fact). Раскладка не определена |
| `11010`~`11011` | `0x7A`~`0x7B` | Reserved |  |
| `111xx` | `0x7C`~`0x7F` | ISSUER-* | Формат, определённый Issuer |

| Старшие 2 бита CCCCC | Группа |
|---|---|
| `00` | объявления |
| `01` | отношения |
| `10` | исполнение |
| `11` | результат (`0x7C`~`0x7F` — ISSUER) |

### Форматы Edge ISSUER

После `0x7C`~`0x7F` (ISSUER-1/2/4/16WORD) в Codec extension TAG помещаются Issuer и номер формата. Семейство задают два старших бита номера формата. Пространство номеров форматов отдельно от Value.

| Issuer | Номер формата | Имя | Семейство | Описание |
|---|---|---|---|---|
| `0x0000` GEUL | `0xC000` | [SOURCE](/ru/grammar/edge/toulmin/source/) | TOULMIN | Авторский исходный текст. Ширина SPAN и Value UTF8 |
| `0x0000` GEUL | `0xC001` | [TEXT](/ru/grammar/edge/toulmin/source/) | TOULMIN | Имя или строка |
| `0x0000` GEUL | `0xC002` | [SECTION](/ru/grammar/edge/toulmin/source/) | TOULMIN | Начало раздела. Код раздела |
| `0x0000` GEUL | `0xC003` | [CASE-BEGIN](/ru/grammar/edge/toulmin/source/) | TOULMIN | Начало диапазона дела |
| `0x0000` GEUL | `0xC004` | [CASE-END](/ru/grammar/edge/toulmin/source/) | TOULMIN | Конец диапазона дела |
| `0x0000` GEUL | `0xC005` | [PROSE](/ru/grammar/edge/toulmin/source/) | TOULMIN | Абзац повествования (SPAN) |
| `0x0000` GEUL | `0xC010` | [NAMESPACE](/ru/grammar/edge/toulmin/node/) | TOULMIN | NODE. `this document is` |
| `0x0000` GEUL | `0xC011` | [FUNC](/ru/grammar/edge/toulmin/node/) | TOULMIN | NODE. Ссылка на функцию |
| `0x0000` GEUL | `0xC012` | [FIELD](/ru/grammar/edge/toulmin/node/) | TOULMIN | NODE. `is required` |
| `0x0000` GEUL | `0xC013` | [ALIAS](/ru/grammar/edge/toulmin/node/) | TOULMIN | NODE. `see … from` |
| `0x0000` GEUL | `0xC014` | [GROUP](/ru/grammar/edge/toulmin/node/) | TOULMIN | NODE. Упорядоченная группа исполнения |
| `0x0000` GEUL | `0xC020` | [REQUIRES](/ru/grammar/edge/toulmin/link/) | TOULMIN | LINK. Дело → поле |
| `0x0000` GEUL | `0xC021` | [MEANS](/ru/grammar/edge/toulmin/link/) | TOULMIN | LINK. Определяемый элемент → значение или тип |
| `0x0000` GEUL | `0xC022` | [HAS](/ru/grammar/edge/toulmin/link/) | TOULMIN | LINK. Определяемый элемент → поле |
| `0x0000` GEUL | `0xC023` | [RUNS](/ru/grammar/edge/toulmin/link/) | TOULMIN | LINK. Точка входа → дело, исполнение |
| `0x0000` GEUL | `0xC024` | [EVALUATES](/ru/grammar/edge/toulmin/link/) | TOULMIN | LINK. Точка входа → дело, вердикт |
| `0x0000` GEUL | `0xC025` | [TRIGGERS](/ru/grammar/edge/toulmin/link/) | TOULMIN | LINK. Триггер → дело |
| `0x0000` GEUL | `0xC026` | [UNTIL](/ru/grammar/edge/toulmin/link/) | TOULMIN | LINK. Триггер → дело (`every … until`) |
| `0x0000` GEUL | `0xC027` | [SAME-AS](/ru/grammar/edge/toulmin/link/) | TOULMIN | LINK. Узел → глобальный идентификатор |
| `0x0000` GEUL | `0xC028` | [IMPORTED-FROM](/ru/grammar/edge/toulmin/link/) | TOULMIN | LINK. Псевдоним → путь (TEXT) |
| `0x0000` GEUL | `0xC029` | [LABEL](/ru/grammar/edge/toulmin/link/) | TOULMIN | LINK. Узел → TEXT, запись имени |

## Value

`0000 1LLL LCCC CCCC` — [Value](/ru/grammar/value/)

Семейство задают два старших бита Codec. NUMERIC/DECIMAL дополнительно делятся по третьему старшему биту (`000` NUMERIC, `001` DECIMAL).

| Старшие 2 бита | Семейство | Прямой код | Номер формата |
|---|---|---|---|
| `00` | [NUMERIC](/ru/grammar/value/numeric/)/[DECIMAL](/ru/grammar/value/decimal/) | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | [TIME](/ru/grammar/value/time/) | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | [TEXT](/ru/grammar/value/text/) | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | [BINARY](/ru/grammar/value/binary/) | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

### Прямые коды

| Codec | Имя | Семейство | Описание |
|---|---|---|---|
| `0x00` | [BOOL](/ru/grammar/value/numeric/bool/) | NUMERIC | false или true, фиксированно 1 WORD |
| `0x01` | [SIGNED-INTEGER](/ru/grammar/value/numeric/signed-integer/) | NUMERIC | Знаковое целое в дополнительном коде с минимальным числом WORD |
| `0x02` | [UNSIGNED-INTEGER](/ru/grammar/value/numeric/unsigned-integer/) | NUMERIC | Целое с беззнаковой величиной big-endian с минимальным числом WORD |
| `0x03` | [BINARY-FLOAT](/ru/grammar/value/numeric/binary-float/) | NUMERIC | Скаляр IEEE 754 binary16/32/64/128 с Payload 1/2/4/8 WORD |
| `0x04` | [COORDINATE-EARTH](/ru/grammar/value/numeric/coordinate-earth/) | NUMERIC | Широта и долгота на Земле (WGS 84) в binary64, неопределённость в binary32 и Reference её единицы (ABSENT = неизвестно) |
| `0x05` | [COORDINATE-GEO](/ru/grammar/value/numeric/coordinate-geo/) | NUMERIC | Reference небесного тела, широта и долгота в binary64, неопределённость в binary32 и Reference её единицы |
| `0x06` | [QUANTITY](/ru/grammar/value/numeric/quantity/) | NUMERIC | числовой Value amount (целое, BINARY-FLOAT, десятичное, дробь), Reference единицы, нижняя и верхняя границы. Единицу и границы можно опустить (ABSENT `0x0000`) |
| `0x07` | [FRACTION](/ru/grammar/value/numeric/fraction/) | NUMERIC | Дробь с сохранением исходной записи: числитель — целое или десятичное, знаменатель — целое или десятичное без знака. Не сокращается |
| `0x08`~`0x0F` | Reserved | NUMERIC |  |
| `0x10` | [SIGNED-DECIMAL](/ru/grammar/value/decimal/signed-decimal/) | DECIMAL | `C×10^E` со знаковым показателем `E` и коэффициентом `C` в дополнительном коде с минимальным числом WORD |
| `0x11` | [UNSIGNED-DECIMAL](/ru/grammar/value/decimal/unsigned-decimal/) | DECIMAL | `C×10^E` со знаковым показателем `E` и беззнаковым коэффициентом `C` с минимальным числом WORD |
| `0x12`~`0x1F` | Reserved | DECIMAL |  |
| `0x20` | [GREGORIAN-DATE](/ru/grammar/value/time/gregorian-date/) | TIME | Знаковое число дней от proleptic Gregorian `1970-01-01` |
| `0x21` | [CIVIL-TIME-NANOSECONDS](/ru/grammar/value/time/civil-time-nanoseconds/) | TIME | Беззнаковое число наносекунд после полуночи гражданских суток |
| `0x22` | [POSIX-TIMESTAMP-SECONDS](/ru/grammar/value/time/posix-timestamp-seconds/) | TIME | Знаковое число секунд от эпохи Unix/POSIX |
| `0x23` | [DURATION-SECONDS](/ru/grammar/value/time/duration-seconds/) | TIME | Знаковая длительность в секундах SI без эпохи |
| `0x24`/`0x25` | [EDTF](/ru/grammar/value/time/edtf/) | TIME | Строка даты EDTF (ISO 8601-2). Чётное/нечётное число байт. Дату, которую можно записать как GREGORIAN-DATE, так не записывают |
| `0x26`/`0x27` | [GEDCOM-DATE](/ru/grammar/value/time/gedcom-date/) | TIME | Строка значения даты GEDCOM 7. Сохраняет исходную запись других календарей (юлианского и т. п.). Чётное/нечётное число байт |
| `0x28`~`0x3F` | Reserved | TIME |  |
| `0x40` | [UTF8-TEXT-EVEN](/ru/grammar/value/text/utf8-text/) | TEXT | Valid UTF-8 без подразумеваемой нормализации. Чётное число байт |
| `0x41` | [UTF8-TEXT-ODD](/ru/grammar/value/text/utf8-text/) | TEXT | То же. Нечётное число байт |
| `0x42`/`0x43` | Reserved | TEXT |  |
| `0x44` | [URI-EVEN](/ru/grammar/value/text/uri/) | TEXT | ASCII-последовательность байт по production `URI` RFC 3986. Чётное число байт |
| `0x45` | [URI-ODD](/ru/grammar/value/text/uri/) | TEXT | То же. Нечётное число байт |
| `0x46` | [LANGUAGE-BCP47-CODE-EVEN](/ru/grammar/value/text/language-bcp47-code/) | TEXT | ASCII-последовательность байт полного language tag BCP 47 в canonical регистре. Чётное число байт |
| `0x47` | [LANGUAGE-BCP47-CODE-ODD](/ru/grammar/value/text/language-bcp47-code/) | TEXT | То же. Нечётное число байт |
| `0x48` | [LANGUAGE-SHORT-CODE](/ru/grammar/value/text/language-short-code/) | TEXT | Сжатый код primary language GEUL, фиксированно 1 WORD Payload |
| `0x49` | Reserved | TEXT |  |
| `0x4A`/`0x4B` | [UTF8-LANGUAGE-TEXT](/ru/grammar/value/text/utf8-language-text/) | TEXT | Текст с языком. Запись языкового Value (LANGUAGE-SHORT-CODE или LANGUAGE-BCP47-CODE) и байты UTF-8. Чётность по байтам текста |
| `0x4C`~`0x5F` | Reserved | TEXT |  |
| `0x60` | [UUID](/ru/grammar/value/binary/uuid/) | BINARY | UUID RFC 9562, 128 bit, фиксированно 8 WORD Payload |
| `0x61` | [SHA-256-DIGEST](/ru/grammar/value/binary/sha-256-digest/) | BINARY | Результат SHA-256, фиксированно 16 WORD Payload |
| `0x62` | [SHA1-DIGEST](/ru/grammar/value/binary/sha1-digest/) | BINARY | Результат SHA-1, фиксированно 10 WORD Payload. Только для идентификации, как ID объектов git |
| `0x63`~`0x7B` | Reserved | BINARY |  |
| `0x7C`~`0x7F` | ISSUER-* |  | Формат, определённый Issuer. См. форматы Value ISSUER ниже |

### Форматы Value ISSUER

После `0x7C`~`0x7F` (ISSUER-1/2/4/16WORD) в Codec extension TAG помещаются Issuer и номер формата. Семейство задают два старших бита номера формата.

| Issuer | Номер формата | Имя | Семейство | Описание |
|---|---|---|---|---|
| `0x0000` GEUL | `0x4000` | [DURATION-NANOSECONDS](/ru/grammar/value/time/duration-nanoseconds/) | TIME | Знаковая длительность в наносекундах без эпохи |
| `0x0000` GEUL | `0xC000` | [OPAQUE-BYTES-EVEN](/ru/grammar/value/binary/opaque-bytes/) | BINARY | Последовательность байт неизвестного смысла и формата. Чётное число байт |
| `0x0000` GEUL | `0xC001` | [OPAQUE-BYTES-ODD](/ru/grammar/value/binary/opaque-bytes/) | BINARY | То же. Нечётное число байт |
| `0x0000` GEUL | `0xC002` | [BIT-VECTOR](/ru/grammar/value/binary/bit-vector/) | BINARY | N bit, хранимых MSB-first после bit-count |
| `0x0001` ADHOC | `0x0000` | BFLOAT16 | NUMERIC | Interchange bits BF16, фиксированно 1 WORD Payload |
| `0x0001` ADHOC | `0x0500` | [DENSE-I16-VECTOR](/ru/grammar/value/vector/dense-i16-vector/) | NUMERIC | Непрерывный вектор big-endian int16 |
| `0x0001` ADHOC | `0x0501` | [DENSE-U16-VECTOR](/ru/grammar/value/vector/dense-u16-vector/) | NUMERIC | Непрерывный вектор big-endian uint16 |
| `0x0001` ADHOC | `0x0502` | [DENSE-I32-VECTOR](/ru/grammar/value/vector/dense-i32-vector/) | NUMERIC | Непрерывный вектор big-endian int32 |
| `0x0001` ADHOC | `0x0503` | [DENSE-U32-VECTOR](/ru/grammar/value/vector/dense-u32-vector/) | NUMERIC | Непрерывный вектор big-endian uint32 |
| `0x0001` ADHOC | `0x0504` | [DENSE-I64-VECTOR](/ru/grammar/value/vector/dense-i64-vector/) | NUMERIC | Непрерывный вектор big-endian int64 |
| `0x0001` ADHOC | `0x0505` | [DENSE-U64-VECTOR](/ru/grammar/value/vector/dense-u64-vector/) | NUMERIC | Непрерывный вектор big-endian uint64 |
| `0x0001` ADHOC | `0x0506` | [DENSE-BINARY16-VECTOR](/ru/grammar/value/vector/dense-binary16-vector/) | NUMERIC | Непрерывный вектор IEEE 754 binary16 |
| `0x0001` ADHOC | `0x0507` | [DENSE-BFLOAT16-VECTOR](/ru/grammar/value/vector/dense-bfloat16-vector/) | NUMERIC | Непрерывный вектор BF16 |
| `0x0001` ADHOC | `0x0508` | [DENSE-BINARY32-VECTOR](/ru/grammar/value/vector/dense-binary32-vector/) | NUMERIC | Непрерывный вектор IEEE 754 binary32 |
| `0x0001` ADHOC | `0x0509` | [DENSE-BINARY64-VECTOR](/ru/grammar/value/vector/dense-binary64-vector/) | NUMERIC | Непрерывный вектор IEEE 754 binary64 |
| `0x0001` ADHOC | `0x050A` | [POINT2-BINARY64](/ru/grammar/value/vector/point2-binary64/) | NUMERIC | Двумерный вектор IEEE binary64 в порядке `(x,y)` |
| `0x0001` ADHOC | `0x050B` | [POINT3-BINARY64](/ru/grammar/value/vector/point3-binary64/) | NUMERIC | Трёхмерный вектор IEEE binary64 в порядке `(x,y,z)` |
| `0x0001` ADHOC | `0x050C` | [BBOX2-BINARY64](/ru/grammar/value/vector/bbox2-binary64/) | NUMERIC | Вектор IEEE binary64 в порядке `(minX,minY,maxX,maxY)` |
| `0x0001` ADHOC | `0x0600` | [DESCRIBED-DENSE-TENSOR](/ru/grammar/value/tensor/described-dense-tensor/) | NUMERIC | element-format, rank, shape и C-contiguous dense payload |
| `0x0001` ADHOC | `0x0601` | [DESCRIBED-PACKED-TENSOR](/ru/grammar/value/tensor/described-packed-tensor/) | NUMERIC | packed-format, rank, shape и packed payload с low-bit-first внутри octet |
| `0x0001` ADHOC | `0x0700` | [COMPLEX64](/ru/grammar/value/etc/complex64/) | NUMERIC | Два binary32 в порядке `(real, imag)` |
| `0x0001` ADHOC | `0x0701` | [COMPLEX128](/ru/grammar/value/etc/complex128/) | NUMERIC | Два binary64 в порядке `(real, imag)` |
| `0x0001` ADHOC | `0x0702` | [RATIONAL-I64](/ru/grammar/value/etc/rational-i64/) | NUMERIC | Нормализованный числитель int64 и положительный знаменатель int64 |
| `0x0001` ADHOC | `0x0703` | [CLOSED-INTERVAL-BINARY64](/ru/grammar/value/etc/closed-interval-binary64/) | NUMERIC | Замкнутый интервал binary64 с `lower ≤ upper` |
| `0x0001` ADHOC | `0x0704` | [QUATERNION-BINARY32](/ru/grammar/value/etc/quaternion-binary32/) | NUMERIC | Четыре binary32 в порядке `(x,y,z,w)` |
| `0x0001` ADHOC | `0xC000` | [BLAKE3-256-DIGEST](/ru/grammar/value/binary/blake3-256-digest/) | BINARY | Результат BLAKE3 по умолчанию, фиксированно 16 WORD Payload |
| `0x0020` IETF | `0x8000` | [URI-RELATIVE-REF-EVEN](/ru/grammar/value/text/uri-relative-ref/) | TEXT | ASCII-последовательность байт relative-ref RFC 3986. Чётное число байт |
| `0x0020` IETF | `0x8001` | [URI-RELATIVE-REF-ODD](/ru/grammar/value/text/uri-relative-ref/) | TEXT | То же. Нечётное число байт |
| `0x0020` IETF | `0xC000` | [CRC32C](/ru/grammar/value/binary/crc32c/) | BINARY | Результат CRC-32C Castagnoli, фиксированно 2 WORD Payload |
| `0x0020` IETF | `0xC001` | [IPV4-ADDRESS](/ru/grammar/value/binary/ipv4-address/) | BINARY | 32 bit адреса IPv4, фиксированно 2 WORD Payload |
| `0x0020` IETF | `0xC002` | [IPV6-ADDRESS](/ru/grammar/value/binary/ipv6-address/) | BINARY | 128 bit адреса IPv6, фиксированно 8 WORD Payload |
| `0x0040` IEEE | `0x2000` | [IEEE-DECIMAL32-DPD](/ru/grammar/value/decimal/ieee-decimal32-dpd/) | DECIMAL | IEEE 754 decimal32 DPD, фиксированно 2 WORD Payload |
| `0x0040` IEEE | `0x2001` | [IEEE-DECIMAL64-DPD](/ru/grammar/value/decimal/ieee-decimal64-dpd/) | DECIMAL | IEEE 754 decimal64 DPD, фиксированно 4 WORD Payload |
| `0x0040` IEEE | `0x2002` | [IEEE-DECIMAL128-DPD](/ru/grammar/value/decimal/ieee-decimal128-dpd/) | DECIMAL | IEEE 754 decimal128 DPD, фиксированно 8 WORD Payload |
| `0x0040` IEEE | `0x2003` | [IEEE-DECIMAL32-BID](/ru/grammar/value/decimal/ieee-decimal32-bid/) | DECIMAL | IEEE 754 decimal32 BID, фиксированно 2 WORD Payload |
| `0x0040` IEEE | `0x2004` | [IEEE-DECIMAL64-BID](/ru/grammar/value/decimal/ieee-decimal64-bid/) | DECIMAL | IEEE 754 decimal64 BID, фиксированно 4 WORD Payload |
| `0x0040` IEEE | `0x2005` | [IEEE-DECIMAL128-BID](/ru/grammar/value/decimal/ieee-decimal128-bid/) | DECIMAL | IEEE 754 decimal128 BID, фиксированно 8 WORD Payload |
| `0x0040` IEEE | `0x4000` | [POSIX-TIMESTAMP-NANOSECONDS](/ru/grammar/value/time/posix-timestamp-nanoseconds/) | TIME | Знаковое число наносекунд от эпохи Unix/POSIX |
| `0x0040` IEEE | `0xC000` | [MAC-48-ADDRESS](/ru/grammar/value/binary/mac-48-address/) | BINARY | 48 bit MAC-адреса IEEE 802, фиксированно 3 WORD Payload |
| `0x0041` KHRONOS | `0x0000` | [RGBA8-UNORM](/ru/grammar/value/vector/rgba8-unorm/) | NUMERIC | Фиксированный packed-вектор 4×UNORM8 в порядке R, G, B, A |
| `0x0041` KHRONOS | `0x0001` | [BGRA8-UNORM](/ru/grammar/value/vector/bgra8-unorm/) | NUMERIC | Фиксированный packed-вектор 4×UNORM8 в порядке B, G, R, A |
| `0x0043` ONNX | `0x0000` | FP8-E4M3FN | NUMERIC | Скаляр ONNX E4M3FN в старшем octet Payload |
| `0x0043` ONNX | `0x0001` | FP8-E4M3FNUZ | NUMERIC | Скаляр ONNX E4M3FNUZ в старшем octet Payload |
| `0x0043` ONNX | `0x0002` | FP8-E5M2 | NUMERIC | Скаляр ONNX E5M2 в старшем octet Payload |
| `0x0043` ONNX | `0x0003` | FP8-E5M2FNUZ | NUMERIC | Скаляр ONNX E5M2FNUZ в старшем octet Payload |
| `0x0044` OCP | `0x0000` | FP8-E8M0FNU | NUMERIC | Беззнаковый скаляр E8M0FNU только из показателя в старшем octet Payload |
| `0x0044` OCP | `0x0001` | FP4-E2M1FN | NUMERIC | Скаляр ONNX/DLPack E2M1FN в старшем nibble Payload |
| `0x0060` BIPM | `0x4000` | [TAI-TIMESTAMP-SECONDS](/ru/grammar/value/time/tai-timestamp-seconds/) | TIME | Знаковое число секунд SI от `1970-01-01T00:00:00 TAI` |
| `0x0060` BIPM | `0x4001` | [TAI-TIMESTAMP-NANOSECONDS](/ru/grammar/value/time/tai-timestamp-nanoseconds/) | TIME | Знаковое число наносекунд от той же эпохи TAI |
| `0x0062` NIST | `0xC000` | [SHA-512-DIGEST](/ru/grammar/value/binary/sha-512-digest/) | BINARY | Результат SHA-512, фиксированно 32 WORD Payload |
| `0x0062` NIST | `0xC001` | [SHA3-256-DIGEST](/ru/grammar/value/binary/sha3-256-digest/) | BINARY | Результат SHA3-256, фиксированно 16 WORD Payload |
| `0x0063` GPS | `0x4000` | [GPS-TIMESTAMP-SECONDS](/ru/grammar/value/time/gps-timestamp-seconds/) | TIME | Знаковое число секунд от эпохи GPS |
| `0x0063` GPS | `0x4001` | [GPS-TIMESTAMP-NANOSECONDS](/ru/grammar/value/time/gps-timestamp-nanoseconds/) | TIME | Знаковое число наносекунд от эпохи GPS |

## Meta

`0001 1LLL LCCC CCCC` — [Meta](/ru/grammar/meta/)

Класс задают три старших бита Codec. У Meta нет кодов ISSUER.

| Старшие 3 бита | Класс | Прямой код | О чём |
|---|---|---|---|
| `000` | [Структура](/ru/grammar/meta/structure/) | `0x00`~`0x0F` | Границы и длина документа |
| `001` | [Объявление](/ru/grammar/meta/declaration/) | `0x10`~`0x1F` | Объявления, влияющие на интерпретацию |
| `010` | [Происхождение](/ru/grammar/meta/provenance/) | `0x20`~`0x2F` | Кто и когда |
| `011` | [Родословная](/ru/grammar/meta/lineage/) | `0x30`~`0x3F` | Из чего и как получен |
| `100` | [Проверка](/ru/grammar/meta/verification/) | `0x40`~`0x4F` | Можно ли верить |
| `101` | [Политика](/ru/grammar/meta/policy/) | `0x50`~`0x5F` | Как с ним обращаться |
| `110` | [IMPORT](/ru/grammar/meta/import/) | `0x60`~`0x6F` | Импортирует внешний документ по IMPORT ID (`IMPORT-DOC`) |
| `111` | Reserved | `0x70`~`0x7F` |  |

### Структура (`000`)

| Codec | Имя | Описание |
|---|---|---|
| `0x00` | [DOC-1WORD](/ru/grammar/meta/structure/doc/) | Начало документа, полная длина задана в 1 WORD Payload |
| `0x01` | [DOC-2WORD](/ru/grammar/meta/structure/doc/) | Начало документа, полная длина задана в 2 WORD Payload |
| `0x02` | [DOC-4WORD](/ru/grammar/meta/structure/doc/) | Начало документа, полная длина задана в 4 WORD Payload |
| `0x03`~`0x0D` | Reserved |  |
| `0x0E` | [BODY](/ru/grammar/meta/structure/body/) | 1 WORD. Завершает HEAD документа и начинает BODY. |
| `0x0F` | [END](/ru/grammar/meta/structure/end/) | 1 WORD. Закрывает документ. |

### Объявление (`001`)

| Codec | Имя | Описание |
|---|---|---|
| `0x10` | [SPEC-VERSION](/ru/grammar/meta/declaration/spec-version/) | Версия спецификации GEUL, которой следует документ. Payload — беззнаковое целое наименьшей ширины. Для v1 `0x0001` (запись `0x1890 0x0001`) |
| `0x11` | [PROFILE](/ru/grammar/meta/declaration/profile/) | Применяемый профиль |
| `0x12` | [DOC-ID](/ru/grammar/meta/declaration/doc-id/) | Идентификатор этого документа. Встроенный Reference `DOC-POINTER` (Issuer, ID документа, версия 0) |
| `0x13` | [EFFECTIVE-FROM](/ru/grammar/meta/declaration/effective-from/) | Дата вступления этой версии в силу. Value GREGORIAN-DATE или POSIX-TIMESTAMP. Если нет — момент публикации |
| `0x14` | [EFFECTIVE-UNTIL](/ru/grammar/meta/declaration/effective-until/) | Конец срока действия этой версии (срочный закон). Если нет — до вступления в силу следующей версии |
| `0x15` | Reserved |  |
| `0x16` | [DEFAULT-LANGUAGE](/ru/grammar/meta/declaration/default-language/) | Язык по умолчанию |
| `0x17`~`0x1F` | Reserved |  |

### Происхождение (`010`)

| Codec | Имя | Описание |
|---|---|---|
| `0x20` | [AUTHOR](/ru/grammar/meta/provenance/author/) | Автор. Reference (git author) |
| `0x21` | [CO-AUTHOR](/ru/grammar/meta/provenance/co-author/) | Соавтор. Reference (git `Co-authored-by`) |
| `0x22` | [CREATED-AT](/ru/grammar/meta/provenance/created-at/) | Время создания. Value TIME (git author date) |
| `0x23` | [MODIFIED-AT](/ru/grammar/meta/provenance/modified-at/) | Время изменения. Value TIME |
| `0x24` | [RECORDED-BY](/ru/grammar/meta/provenance/recorded-by/) | Кто записал. Reference (git committer) |
| `0x25` | [RECORDED-AT](/ru/grammar/meta/provenance/recorded-at/) | Когда записано. Value TIME (git commit date) |
| `0x26`~`0x2F` | Reserved |  |

- Исходный материал, его диапазон, время получения и хеш записываются не как Meta, а Edge основания [SOURCE](/ru/grammar/edge/source/#источник-всего-документа) в HEAD (Target `0`) и его QUALIFIER.

### Родословная (`011`)

| Codec | Имя | Описание |
|---|---|---|
| `0x30` | [PARENT](/ru/grammar/meta/lineage/parent/) | Хеш содержимого непосредственно предыдущей версии (git parent). Если нет — первая версия, если несколько — слияние (git merge commit). |
| `0x31` | [DERIVED-FROM](/ru/grammar/meta/lineage/derived-from/) | Производная от записи или материала из другой родословной. Чтобы зафиксировать конкретную версию внешнего материала, к [SOURCE](/ru/grammar/edge/source/#источник-всего-документа) в HEAD добавляется QUALIFIER с хешем исходного текста (P4092) (git submodule). |
| `0x32` | [GENERATED-BY](/ru/grammar/meta/lineage/generated-by/) | Создатель. Человек, модель, движок правил |
| `0x33` | [TRANSFORMED-BY](/ru/grammar/meta/lineage/transformed-by/) | Способ преобразования. Инструмент, правило, версия |
| `0x34` | [CHERRY-PICKED-FROM](/ru/grammar/meta/lineage/cherry-picked-from/) | Хеш содержимого исходной версии, из которой взято изменение другой родословной (git cherry-pick `-x`) |
| `0x35` | [REVERTS](/ru/grammar/meta/lineage/reverts/) | Хеш содержимого версии, изменения которой отменены (git revert) |
| `0x36` | [REPLACES](/ru/grammar/meta/lineage/replaces/) | Хеш содержимого версии, переписанной заново (git amend, rebase). Исходная версия не удаляется. |
| `0x37` | [SQUASHED-FROM](/ru/grammar/meta/lineage/squashed-from/) | Хеши содержимого исходных версий, слитых в одну (git squash) |
| `0x38` | [MESSAGE](/ru/grammar/meta/lineage/message/) | Причина изменения. Value UTF8-LANGUAGE-TEXT, по одному на язык (git commit message) |
| `0x39` | [TAG](/ru/grammar/meta/lineage/tag/) | Неизменяемое имя, данное версии. Value TEXT и хеш содержимого (git annotated tag) |
| `0x3A` | [DELTA-BASE](/ru/grammar/meta/lineage/delta-base/) | Файл этой версии — diff относительно базовой версии (ID версии 2 WORD) того же документа (git packfile delta) |
| `0x3B` | [DELTA-REMOVE](/ru/grammar/meta/lineage/delta-remove/) | Список LOCAL ID (Edge Id), исключаемых из базового BODY в diff |
| `0x3C` | [NEXT-LOCAL-ID](/ru/grammar/meta/lineage/next-local-id/) | LOCAL ID, который будет назначен следующим (auto increment). Размещается в HEAD списка версий `versions.geul` |
| `0x3D`~`0x3F` | Reserved |  |

### Проверка (`100`)

| Codec | Имя | Описание |
|---|---|---|
| `0x40` | [ISSUER-KEY](/ru/grammar/meta/verification/issuer-key/) | Объявление ID алгоритма подписи и открытого ключа самостоятельно выданного Issuer |
| `0x41` | [SIGNATURE](/ru/grammar/meta/verification/signature/) | Подпись цели. Подпись документа ставится на хеш содержимого (git signed commit, tag) |
| `0x42` | [SIGNED-OFF](/ru/grammar/meta/verification/signed-off/) | Подтверждение права на вклад. Reference (git `Signed-off-by`, DCO) |
| `0x43` | [CONFIDENCE](/ru/grammar/meta/verification/confidence/) | Степень доверия |
| `0x44` | [VERDICT](/ru/grammar/meta/verification/verdict/) | Результат вердикта по всему документу. Pass, Review, Fail. На уровне узла и записи — [TOULMIN](/ru/grammar/edge/toulmin/) `VERDICT` (Edge `0x78`) |
| `0x45`~`0x4F` | Reserved |  |

### Политика (`101`)

| Codec | Имя | Описание |
|---|---|---|
| `0x50` | [LICENSE](/ru/grammar/meta/policy/license/) | Лицензия. Reference |
| `0x51` | [ACCESS](/ru/grammar/meta/policy/access/) | Область доступа |
| `0x52` | [PRIVACY](/ru/grammar/meta/policy/privacy/) | Уровень персональных данных |
| `0x53` | [RETENTION](/ru/grammar/meta/policy/retention/) | Срок хранения |
| `0x54` | [CONSENT](/ru/grammar/meta/policy/consent/) | Область и основание согласия |
| `0x55` | [USAGE](/ru/grammar/meta/policy/usage/) | Ограничения использования |
| `0x56`~`0x5F` | Reserved |  |

### IMPORT (`110`)

| Codec | Имя | Описание |
|---|---|---|
| `0x60` | [IMPORT-DOC](/ru/grammar/meta/import/import-doc/) | Импортирует внешний документ по IMPORT ID. Встроенный Reference `DOC-POINTER` + IMPORT ID |
| `0x61`~`0x6F` | Reserved |  |
