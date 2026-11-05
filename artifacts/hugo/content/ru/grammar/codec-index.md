---
title: "Индекс кодов"
weight: 60
date: 2026-11-05T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar"]
summary: "Эта страница — индекс всех Codec."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Эта страница — индекс всех Codec. Нажмите на имя, чтобы перейти к подробному документу этого Codec. Прямые коды, которых нет в таблицах, — Reserved.

## Kind {#kind}

TAG WORD имеет вид `000K KKKC CCCC LLLL`. Старшие 4 бита `KKKK` — раздел, `C` — 5-битное смещение внутри раздела, `LLLL` — Length. Девять бит раздела и `C` вместе образуют место Codec. TAG ID записывается как `0x000L`: первые три разряда — эти 9 бит (`w >> 4`), а `L` — место Length ([Запись и TAG WORD](record.md)).

| Раздел | TAG ID | Категория | Описание |
|---|---|---|---|
| 0–2 | `0x000L~0x05FL` | [Reference](reference/_index.md) | записи, указывающие на объект |
| 3 и 4 | `0x060L~0x09FL` | [Value](value/_index.md) | записи значений |
| 5–13 | `0x0A0L~0x1BFL` | [Edge](edge/_index.md) | составные записи |
| 14 и 15 | `0x1C0L~0x1FFL` | [Meta](meta/_index.md) | записи о документе и о записях |

- Раздел — это `S = w >> 9` (4 бита), в одном разделе 32 ячейки.
- Kind определяется по диапазону раздела: `w < 0x0600` — Reference, `w < 0x0A00` — Value, `w < 0x1C00` — Edge, остальное — Meta. Исключений нет.
- Последние три ячейки областей Reference, Value и Edge — ISSUER (`..DL` 2 WORD, `..EL` 4 WORD, `..FL` 16 WORD). В Meta ISSUER нет.

## Reference {#reference}

`0x000L~0x05FL` — [Reference](reference/_index.md)

### Codec {#codec}

| TAG ID | Имя | Категория | ID объекта |
|---|---|---|---|
| `0x000L~0x002L` | [Маркер места](slot-marker.md) | маркер места | группа однословных маркеров, не указывающих на объект (таблица ниже) |
| `0x005L~0x009L` | [LOCAL](reference/0x005L-local.md) | объявление | ID, выданный этим документом |
| `0x00AL~0x00EL` | [GEUL](reference/0x00AL-geul.md) | объявление | сущность, выдаваемая geul.org под CC0. Малые номера назначаются сущностям с высокой частотой |
| `0x00FL~0x013L` | [GEUL-SIDX](reference/0x00FL-geul-sidx.md) | объявление | GEUL SIDX (Semantic-aligned Index). Идентификатор, биты которого несут смысл |
| `0x014L~0x018L` | [WIKIDATA-QID](reference/0x014L-wikidata-qid.md) | объявление | элемент Викиданных. Целое число после `Q` |
| `0x019L~0x01DL` | [WIKIDATA-PID](reference/0x019L-wikidata-pid.md) | объявление | свойство Викиданных. Целое число после `P` |
| `0x020L~0x024L` | [EXTERNAL-POINTER-1WORD](reference/0x020L-external-pointer-1word.md) | указание | LOCAL ID документа, импортированного через `IMPORT-DOC`. IMPORT ID 1 WORD |
| `0x025L~0x029L` | [EXTERNAL-POINTER-2WORD](reference/0x025L-external-pointer-2word.md) | указание | то же. IMPORT ID 2 WORD |
| `0x02AL~0x02EL` | [EXTERNAL-POINTER-4WORD](reference/0x02AL-external-pointer-4word.md) | указание | то же. IMPORT ID 4 WORD |
| `0x02FL~0x033L` | [EXTERNAL-ISSUER-2WORD](reference/0x02FL-external-issuer-2word.md) | указание и объявление | LOCAL ID документа Issuer из 2 WORD |
| `0x034L~0x038L` | [EXTERNAL-ISSUER-4WORD](reference/0x034L-external-issuer-4word.md) | указание и объявление | LOCAL ID документа Issuer из 4 WORD |
| `0x039L~0x03DL` | [EXTERNAL-ISSUER-16WORD](reference/0x039L-external-issuer-16word.md) | указание и объявление | LOCAL ID документа Issuer из 16 WORD |
| `0x040L` | [ISSUER-POINTER](reference/0x040L-issuer-pointer.md) | указание и объявление | сам Issuer. Payload — только Issuer (2/4/16 WORD), ID объекта нет |
| `0x041L` | [DOC-POINTER](reference/0x041L-doc-pointer.md) | указание и объявление | одна версия документа Issuer. Issuer + ID документа 4 WORD + ID версии 2 WORD, ID объекта нет |
| `0x042L` | [CODEC-POINTER](reference/0x042L-codec-pointer.md) | указание и объявление | одна версия Codec Issuer. Issuer + ID Codec 2 WORD + ID версии 2 WORD, ID объекта нет |
| `0x05DL` | [REFERENCE-ISSUER-2WORD](reference/0x05DL-reference-issuer-2word.md) | формат Issuer | Issuer 2 WORD и номер Codec 2 WORD. Категорию и объект определяет документ Issuer |
| `0x05EL` | [REFERENCE-ISSUER-4WORD](reference/0x05EL-reference-issuer-4word.md) | формат Issuer | Issuer 4 WORD и номер Codec 2 WORD. То же |
| `0x05FL` | [REFERENCE-ISSUER-16WORD](reference/0x05FL-reference-issuer-16word.md) | формат Issuer | Issuer 16 WORD и номер Codec 2 WORD. То же |

- Reference занимает три раздела. Раздел 0 — сущности `0x000L~0x01FL` (маркеры места, система 5Q), раздел 1 — EXTERNAL `0x020L~0x03FL`, раздел 2 — прочее `0x040L~0x05FL` (указатели, REFERENCE-ISSUER). Reserved — это `0x003L~0x004L`, `0x01EL~0x01FL`, `0x03EL~0x03FL`, `0x043L~0x05CL`.
- Группа из 5 ячеек (от LOCAL до EXTERNAL-ISSUER-16WORD) — по одной ячейке в порядке Quantifier ниже. Пример: WIKIDATA-QID Identified `0x014L`, Generic `0x015L`.

### Маркер места (`0x000L~0x002L`) {#자리-표지-0x000l0x002l}

`0x0000`, `0x0010`, `0x0020` — [Маркер места](slot-marker.md). Появляется в поле, только если список CODEC этого поля точно содержит такое WORD.

| WORD | Имя | Значение | Викиданные |
|---|---|---|---|
| `0x0000` | [ABSENT](reference/0x000L-absent.md) | не записано. Необязательное поле опущено. О мире ничего не утверждается | snak отсутствует |
| `0x0010` | [UNKNOWN-VALUE](reference/0x001L-unknown-value.md) | неизвестно. Значение есть, но неизвестно, какое | `somevalue` |
| `0x0020` | [NO-VALUE](reference/0x002L-no-value.md) | отсутствует. Значения нет | `novalue` |

### Quantifier {#quantifier}

| `C % 5` | Имя | Смысл | Пример |
|---|---|---|---|
| `0` | Identified | идентифицированный объект | Илон Маск, Республика Корея |
| `1` | Generic | общее, определяющее высказывание о целом классе. Допускает исключения. | солдат подчиняется приказам |
| `2` | Free-choice | произвольный объект, удовлетворяющий условию | любой солдат |
| `3` | Universal | все объекты заданного диапазона | все солдаты |
| `4` | Variable | переменная дискурса | тот человек, эта женщина |

- Квантификация читается по смещению `C` внутри раздела. В разделе 0 при `5 <= C < 30` квантификация — `C % 5`, система — `C / 5` (1–5). В разделе 1 при `C < 30` квантификация — `C % 5`, система — `6 + C / 5` (6–11). К маркерам (раздел 0, `C < 3`) и разделу 2 (указатели, REFERENCE-ISSUER) это не применяется.
- ISSUER-POINTER, DOC-POINTER и CODEC-POINTER — одна ячейка без квантификации. Квантификацию REFERENCE-ISSUER определяет документ Codec, выпущенный Issuer.

## Issuer {#issuer}

Issuer — субъект, определяющий документы и форматы — [Issuer и публикация](issuer.md)

| Место | Значение |
|---|---|
| коды ISSUER Reference, Value, Edge (три последние ячейки каждой области) | формат, определённый этим Issuer |
| Meta `DOC-ID` | Issuer, выпустивший этот документ |
| Meta `IMPORT-DOC` | Issuer, выпустивший импортируемый документ |
| Reference `EXTERNAL-ISSUER-*`, `DOC-POINTER`, `CODEC-POINTER` | Issuer, выпустивший документ или Codec, на которые указывают (2/4/16 WORD) |
| Reference `ISSUER-POINTER` | сам Issuer, на которого указывают (2/4/16 WORD) |

| Ширина Issuer | Выдача |
|---|---|
| 2 WORD | регистрация в geul.org. Issuer, прошедший подтверждение владения доменом (например, company.com). К этой ширине относятся и номера, назначенные geul.org организациям по стандартизации и ключевым учреждениям ([таблица назначения 2 WORD](issuer.md#2-word-배정표)). |
| 4 WORD | регистрация в geul.org. Issuer, зарегистрированный без подтверждения владения |
| 16 WORD | самостоятельная выдача. Без регистрации вычисляется из открытого ключа. Следует правилу генерации ниже. |

### Алгоритм подписи Issuer 16 WORD {#16-word-issuer-서명-알고리즘}

| ID алгоритма подписи | Алгоритм |
|---|---|
| `0x0001` | Ed25519 |
| Иначе | Reserved |

## Edge {#edge}

`0x0A0L~0x1BFL` — [Edge](edge/_index.md)

Семейство прямого кода — это `(код − 0xA0) >> 5` (код — первые три разряда TAG ID). В семействе по 32 ячейки, и оно равно разделу `w >> 9` минус 5. Назначенные прямые коды относятся к пяти семействам ниже. `0x135L~0x1BCL` — Reserved (разделы 10–12 целиком Reserved). У формата Issuer правила семейств нет.

| Раздел | Семейство | Прямой код |
|---|---|---|
| 5 | высказывание | `0x0A0L~0x0BFL` |
| 6 | основание | `0x0C0L~0x0DFL` |
| 7 | исполнение | `0x0E0L~0x0FFL` |
| 8 | [TOULMIN](toulmin/_index.md) | `0x100L~0x11BL` |
| 9 | формат [TOULMIN](toulmin/_index.md) | `0x120L~0x134L` |

- `0x11CL~0x11FL` — Reserved.
- `0x1BDL~0x1BFL` (три последние ячейки раздела 13) — EDGE-ISSUER (см. ниже, формат Edge ISSUER).

### Высказывание (`0x0A0L~0x0BFL`) {#서술-0x0a0l0x0bfl}

| Codec | Имя | Подформат | Описание |
|---|---|---|---|
| `0x0A0L` | [REFERENCE-NODE](edge/0x0A0L-reference-node.md) |  | направленная привязка: Subject, являющийся Reference, указывает на Object |
| `0x0A1L` | [SAME-NODE](edge/0x0A1L-same-node.md) |  | тождество: две Reference указывают на один и тот же объект |
| `0x0A2L` | [DIFFERENT-NODE](edge/0x0A2L-different-node.md) |  | нетождество: две Reference указывают на разные объекты |
| `0x0A3L` | [BIND](edge/0x0A3L-bind.md) |  | связывает с Subject имя (`UTF8-TEXT-*`), по которому его ищет машина. Должно быть уникальным в области и совпадать точно, языка нет |
| `0x0A4L` | [LABEL](edge/0x0A4L-label.md) |  | связывает с Subject его имя на языке (label). Object — UTF8-LANGUAGE-TEXT |
| `0x0A5L` | [ALIAS](edge/0x0A5L-alias.md) |  | связывает с Subject другое имя (псевдоним). Раскладка такая же, как у LABEL |
| `0x0A6L` | [DESCRIPTION](edge/0x0A6L-description.md) |  | связывает с Subject его описание на языке (description). Раскладка такая же, как у LABEL |
| `0x0A7L` | Reserved |  |  |
| `0x0A8L` | [VERB-SHORT](edge/0x0A8L-verb-short.md) |  | сокращённое глагольное высказывание |
| `0x0A9L` | [VERB](edge/0x0A9L-verb.md) |  | глагольное высказывание |
| `0x0AAL` | [TRIPLE](edge/0x0AAL-triple.md) |  | суждение в порядке Predicate, Subject, Object и rank. Object — значение или маркер UNKNOWN-VALUE или NO-VALUE. Смысл — это совокупность всех QUALIFIER, указывающих на его Edge Id |
| `0x0ABL` | [QUALIFIER](edge/0x0ABL-qualifier.md) |  | одно условие, ограничивающее суждение другого Edge. Property, Target (Edge Id), Value (значение или маркер UNKNOWN-VALUE или NO-VALUE). Является частью суждения |
| `0x0ACL~0x0AFL` | Reserved |  |  |
| `0x0B0L` | [WORLD](edge/0x0B0L-world.md) | есть | структура для выражения картины мира |
| `0x0B1L` | [TIMELINE](edge/0x0B1L-timeline.md) | есть | структура, выражающая порядок миров и событий |
| `0x0B2L` | [SCENE](edge/0x0B2L-scene.md) | есть | структура сцены для описания свойств сценария |
| `0x0B3L~0x0B7L` | Reserved |  |  |
| `0x0B8L` | [PUBLICATION](edge/0x0B8L-publication.md) |  | публикация документа. DOC-POINTER, хеш содержимого |
| `0x0B9L` | [DEPRECATION](edge/0x0B9L-deprecation.md) |  | признание опубликованной версии устаревшей (deprecate). DOC-POINTER |
| `0x0BAL` | [TOMBSTONE](edge/0x0BAL-tombstone.md) |  | удаление опубликованной версии (надгробие). DOC-POINTER, категория причины |
| `0x0BBL` | [DECLARE](edge/0x0BBL-declare.md) |  | объявление состава Payload одного Codec. Целевые Kind и Codec |
| `0x0BCL` | [FIELD](edge/0x0BCL-field.md) |  | одно поле Payload. DECLARE, которому оно принадлежит; ширина: запись (Length TAG) или простое значение из n WORD |
| `0x0BDL` | [ENUM](edge/0x0BDL-enum.md) |  | одно кодовое значение поля с простым значением. Поле, кодовое значение |
| `0x0BEL` | [CODEC](edge/0x0BEL-codec.md) |  | один Kind и Codec, которые принимает поле. Поле, целевое WORD (`000K KKKC CCCC LLLL`; LLLL 0000 — точно, 1111 — шаблон (все 32 ячейки этого раздела); маркеры места — только точными целевыми `0000`, `0010`, `0020`). У поля-записи таких несколько (закрытый список), у поля с простым значением — одно (это Value без TAG) |
| `0x0BFL` | Reserved |  |  |

| TAG ID | Группа |
|---|---|
| `0x0A0L~0x0A7L` | указание и имена |
| `0x0A8L~0x0AFL` | суждения |
| `0x0B0L~0x0B7L` | структура |
| `0x0B8L~0x0BFL` | прочее |

### Основание (`0x0C0L~0x0DFL`) {#근거-0x0c0l0x0dfl}

| Codec | Имя | Подформат | Описание |
|---|---|---|---|
| `0x0C0L` | [SOURCE](edge/0x0C0L-source.md) |  | связывает одну запись или весь документ с её источником. Target (Edge Id в BODY, в HEAD `0` = весь документ), Origin (Reference, ABSENT или UNKNOWN-VALUE). Свойства источника записываются через TRIPLE с источником в роли Subject, свойства цитирования (дата обращения, положение, хеш подлинника) — через QUALIFIER, присоединённый к SOURCE. SOURCE всего документа и его QUALIFIER помещаются в HEAD |
| `0x0C1L~0x0DFL` | Reserved |  |  |

- Диапазон подлинника, создающий субъект, достоверность, срок действия по статьям и устаревшие записи записываются через QUALIFIER, а версия, в которой запись появилась впервые, вычисляется по истории версий ([SOURCE](edge/0x0C0L-source.md#다른-근거의-표현)).

### Исполнение (`0x0E0L~0x0FFL`) {#실행-0x0e0l0x0ffl}

| Codec | Имя | Описание |
|---|---|---|
| `0x0E0L` | Reserved |  |
| `0x0E1L` | [FUNCTION-DECLARE](edge/0x0E1L-function-declare.md) | объявление функции. Символ, список символов параметров, тип возврата, тело (BLOCK) |
| `0x0E2L` | [TYPE-DECLARE](edge/0x0E2L-type-declare.md) | объявление типа. Символ и состав (список символов полей, значения перечисления, цель псевдонима) |
| `0x0E3L~0x0E7L` | Reserved |  |
| `0x0E8L` | [CONST](edge/0x0E8L-const.md) | константное выражение. Одно встроенное Value |
| `0x0E9L` | [UNARY](edge/0x0E9L-unary.md) | унарное выражение. Оператор 1 WORD, операнд |
| `0x0EAL` | [BINARY](edge/0x0EAL-binary.md) | бинарное выражение. Оператор 1 WORD, левый, правый |
| `0x0EBL` | [CALL](edge/0x0EBL-call.md) | вызов. Целевая функция, число аргументов, аргумент × число аргументов |
| `0x0ECL` | [MEMBER](edge/0x0ECL-member.md) | доступ к члену. Цель, символ поля |
| `0x0EDL` | [INDEX](edge/0x0EDL-index.md) | доступ по индексу. Цель, индекс |
| `0x0EEL` | [CONSTRUCT](edge/0x0EEL-construct.md) | создание составного значения (список, запись). Тип, число элементов, элемент × число элементов |
| `0x0EFL` | [CONDITIONAL](edge/0x0EFL-conditional.md) | условное выражение. Условие, значение при истине, значение при лжи |
| `0x0F0L` | [BLOCK](edge/0x0F0L-block.md) | упорядоченная группа операторов. Число операторов, оператор × число операторов |
| `0x0F1L` | [ASSIGN](edge/0x0F1L-assign.md) | присваивание. Цель (символ, MEMBER, INDEX), значение |
| `0x0F2L` | [IF](edge/0x0F2L-if.md) | условное ветвление. Условие, BLOCK при истине, ветвь при лжи (BLOCK или IF, при отсутствии 0) |
| `0x0F3L` | [SWITCH](edge/0x0F3L-switch.md) | многозначное ветвление. Цель, число ветвей, (значение, BLOCK) × число ветвей, BLOCK по умолчанию (при отсутствии 0) |
| `0x0F4L` | [WHILE](edge/0x0F4L-while.md) | цикл с условием. Условие, BLOCK тела |
| `0x0F5L` | [FOREACH](edge/0x0F5L-foreach.md) | цикл-обход. Символ элемента, цель, BLOCK тела |
| `0x0F6L` | [JUMP](edge/0x0F6L-jump.md) | управление циклом. Вид 1 WORD (break, continue), целевой цикл |
| `0x0F7L` | [RETURN](edge/0x0F7L-return.md) | возврат. Значение (при отсутствии 0) |
| `0x0F8L` | [RAISE](edge/0x0F8L-raise.md) | возбуждение ошибки. Значение ошибки |
| `0x0F9L` | [TRY](edge/0x0F9L-try.md) | обработка ошибок. BLOCK тела, символ ошибки, BLOCK обработки, BLOCK завершения (при отсутствии 0) |
| `0x0FAL~0x0FFL` | Reserved |  |

| TAG ID | Группа |
|---|---|
| `0x0E0L~0x0E7L` | объявления |
| `0x0E8L~0x0EFL` | выражения |
| `0x0F0L~0x0F7L` | операторы |
| `0x0F8L~0x0FFL` | ошибки |

### TOULMIN (`0x100L~0x11BL`) {#toulmin-0x100l0x11bl}

Подробнее: [TOULMIN](toulmin/_index.md)

| Codec | Имя | Описание |
|---|---|---|
| `0x100L` | [CASE-DECLARE](toulmin/0x100L-case-declare.md) | объявление дела. Граф вердиктов, содержащий узлы и отношения |
| `0x101L` | [PREDICATE-DECLARE](toulmin/0x101L-predicate-declare.md) | объявление предиката. Функция или выражение вердикта, критерий (Spec), контракт фактов (Ground) |
| `0x102L` | [SPEC-DECLARE](toulmin/0x102L-spec-declare.md) | объявление критерия. Константы и списки (Backing) |
| `0x103L` | [RULE-DECLARE](toulmin/0x103L-rule-declare.md) | объявление утверждения. Помещает предикат в деле как общее правило (Warrant). Может быть атакован. |
| `0x104L` | [COUNTER-DECLARE](toulmin/0x104L-counter-declare.md) | объявление возражения. Атакует со своим выводом. Level по умолчанию — Fail |
| `0x105L` | [EXCEPT-DECLARE](toulmin/0x105L-except-declare.md) | объявление исключения. Атакует без собственного вывода. Level по умолчанию — Review |
| `0x106L~0x107L` | Reserved |  |
| `0x108L` | [ATTACKS](toulmin/0x108L-attacks.md) | отношение атаки. Вердикт атакующего постепенно подрезает вердикт цели. |
| `0x109L` | [SUPERSEDES](toulmin/0x109L-supersedes.md) | отношение отстранения. Если атакующий Active, он решающим образом исключает цель из агрегирования. |
| `0x10AL` | [SUPERSEDE-CHAIN](toulmin/0x10AL-supersede-chain.md) | цепочка приоритета `A > B > C`. Сокращение попарных SUPERSEDES. Раскладка не определена |
| `0x10BL~0x10FL` | Reserved |  |
| `0x110L` | [RUN](toulmin/0x110L-run.md) | композиция исполнения. Если узел Active, исполняет вложенное дело (DAG). |
| `0x111L` | [DO](toulmin/0x111L-do.md) | действие, выполняемое, если узел Active |
| `0x112L` | [DO-ONCE](toulmin/0x112L-do-once.md) | действие, выполняемое только один раз даже при повторных попытках |
| `0x113L` | [UNDO](toulmin/0x113L-undo.md) | компенсирующее действие для DO (saga). Если последующий шаг не удался, выполняется в обратном порядке. |
| `0x114L` | [CHECKING](toulmin/0x114L-checking.md) | связь, только выносящая вердикт без побочных эффектов |
| `0x115L` | [ENTRY](toulmin/0x115L-entry.md) | внешняя точка входа. Исполняет дело или выносит по нему вердикт |
| `0x116L` | [TRIGGER](toulmin/0x116L-trigger.md) | точка входа по событию или расписанию без внешнего вызова |
| `0x117L` | Reserved |  |
| `0x118L` | [VERDICT](toulmin/0x118L-verdict.md) | результат вердикта по узлу или записи. Результат (Pass, Review, Fail), значение вердикта, Activated, Excluded, Level. Раскладка не определена. Вердикт всего документа — Meta [VERDICT](meta/0x1E9L-verdict.md) (`0x1E9L`) |
| `0x119L` | [EVIDENCE](toulmin/0x119L-evidence.md) | доказательство вердикта. Положение, ожидаемое значение, фактическое значение (Fact). Раскладка не определена |
| `0x11AL~0x11BL` | Reserved |  |
| `0x11CL~0x11FL` | Reserved |  |

| TAG ID | Группа |
|---|---|
| `0x100L~0x107L` | объявления |
| `0x108L~0x10FL` | отношения |
| `0x110L~0x117L` | исполнение |
| `0x118L~0x11FL` | результат (`0x11CL~0x11FL` — Reserved) |

### Формат TOULMIN (`0x120L~0x134L`) {#toulmin-형식-0x120l0x134l}

Исходный текст, членения, вспомогательные узлы и отношения документа [TOULMIN](toulmin/_index.md).

| Codec | Имя | Описание |
|---|---|---|
| `0x120L` | [SOURCE](toulmin/0x120L-source.md) | авторский исходный текст. Ширина SPAN и UTF8 Value |
| `0x121L` | [TEXT](toulmin/0x121L-text.md) | имя или строка |
| `0x122L` | [SECTION](toulmin/0x122L-section.md) | начало раздела. Код раздела |
| `0x123L` | [CASE-BEGIN](toulmin/0x123L-case-begin.md) | начало области дела |
| `0x124L` | [CASE-END](toulmin/0x124L-case-end.md) | конец области дела |
| `0x125L` | [PROSE](toulmin/0x125L-prose.md) | абзац описания (SPAN) |
| `0x126L` | [NAMESPACE](toulmin/0x126L-namespace.md) | NODE. `this document is` |
| `0x127L` | [FUNC](toulmin/0x127L-func.md) | NODE. ссылка на функцию |
| `0x128L` | [FIELD](toulmin/0x128L-field.md) | NODE. `is required` |
| `0x129L` | [ALIAS](toulmin/0x129L-alias.md) | NODE. `see … from` |
| `0x12AL` | [GROUP](toulmin/0x12AL-group.md) | NODE. упорядоченная группа исполнения |
| `0x12BL` | [REQUIRES](toulmin/0x12BL-requires.md) | LINK. дело → поле |
| `0x12CL` | [MEANS](toulmin/0x12CL-means.md) | LINK. определяемый элемент → значение или тип |
| `0x12DL` | [HAS](toulmin/0x12DL-has.md) | LINK. определяемый элемент → поле |
| `0x12EL` | [RUNS](toulmin/0x12EL-runs.md) | LINK. точка входа → дело, исполнение |
| `0x12FL` | [EVALUATES](toulmin/0x12FL-evaluates.md) | LINK. точка входа → дело, вердикт |
| `0x130L` | [TRIGGERS](toulmin/0x130L-triggers.md) | LINK. триггер → дело |
| `0x131L` | [UNTIL](toulmin/0x131L-until.md) | LINK. триггер → дело (`every … until`) |
| `0x132L` | [SAME-AS](toulmin/0x132L-same-as.md) | LINK. узел → глобальный идентификатор |
| `0x133L` | [IMPORTED-FROM](toulmin/0x133L-imported-from.md) | LINK. псевдоним → путь (TEXT) |
| `0x134L` | [LABEL](toulmin/0x134L-label.md) | LINK. узел → TEXT, запись имени |

- `0x135L~0x1BCL` — Reserved.

### Формат Edge ISSUER {#edge-issuer-형식}

После `0x1BDL`~`0x1BFL` ([EDGE-ISSUER-2WORD](edge/0x1BDL-edge-issuer-2word.md), [-4WORD](edge/0x1BEL-edge-issuer-4word.md), [-16WORD](edge/0x1BFL-edge-issuer-16word.md)) в расширяющем TAG Codec помещаются Issuer и номер Codec 2 WORD. Сейчас ни один формат Edge ISSUER не внесён.

## Value {#value}

`0x060L~0x09FL` — [Value](value/_index.md)

Номер Value не означает семейство. Прямые коды `0x060L~0x081L` расположены без Reserved. `0x082L~0x09CL` — Reserved, а `0x09DL~0x09FL` — VALUE-ISSUER. Имена семейств (NUMERIC, DECIMAL, TIME, TEXT, BINARY) — тематические группы. Пары чётный и нечётный начинаются с чётного кода.

| Семейство | Прямой код |
|---|---|
| [NUMERIC](value/_index.md#numeric) | `0x060L~0x067L` |
| [DECIMAL](value/_index.md#decimal) | `0x068L~0x069L` |
| [TIME](value/_index.md#time) | `0x06AL~0x071L`, `0x081L` |
| [TEXT](value/_index.md#text) | `0x072L~0x07AL` |
| [BINARY](value/_index.md#binary) | `0x07BL~0x080L` |

### Прямые коды {#직접-코드}

| Codec | Имя | Семейство | Описание |
|---|---|---|---|
| `0x060L` | [BOOL](value/0x060L-bool.md) | NUMERIC | фиксированные 1 WORD, false или true |
| `0x061L` | [SIGNED-INTEGER](value/0x061L-signed-integer.md) | NUMERIC | знаковое целое в дополнительном коде минимальным числом WORD |
| `0x062L` | [UNSIGNED-INTEGER](value/0x062L-unsigned-integer.md) | NUMERIC | целое big-endian unsigned magnitude минимальным числом WORD |
| `0x063L` | [BINARY-FLOAT](value/0x063L-binary-float.md) | NUMERIC | скаляр IEEE 754 binary16/32/64/128 в Payload 1/2/4/8 WORD |
| `0x064L` | [COORDINATE-EARTH](value/0x064L-coordinate-earth.md) | NUMERIC | широта и долгота Земли (WGS 84) в binary64, неопределённость в binary32 и Reference её единицы (ABSENT = неизвестно) |
| `0x065L` | [COORDINATE-GEO](value/0x065L-coordinate-geo.md) | NUMERIC | Reference небесного тела, широта и долгота в binary64, неопределённость в binary32 и Reference её единицы |
| `0x066L` | [QUANTITY](value/0x066L-quantity.md) | NUMERIC | числовое Value amount (целое, BINARY-FLOAT, десятичное, дробь), Reference единицы, нижняя и верхняя границы. Единицу и границы можно опустить (ABSENT `0x0000`) |
| `0x067L` | [FRACTION](value/0x067L-fraction.md) | NUMERIC | дробь с сохранением исходной записи: числитель — целое или десятичное, знаменатель — беззнаковое целое или десятичное. Не сокращается |
| `0x068L` | [SIGNED-DECIMAL](value/0x068L-signed-decimal.md) | DECIMAL | `C×10^E` из signed exponent `E` и коэффициента `C` в дополнительном коде минимальным числом WORD |
| `0x069L` | [UNSIGNED-DECIMAL](value/0x069L-unsigned-decimal.md) | DECIMAL | `C×10^E` из signed exponent `E` и unsigned coefficient `C` минимальным числом WORD |
| `0x06AL` | [GREGORIAN-DATE](value/0x06AL-gregorian-date.md) | TIME | signed число дней от proleptic Gregorian `1970-01-01` |
| `0x06BL` | [CIVIL-TIME-NANOSECONDS](value/0x06BL-civil-time-nanoseconds.md) | TIME | unsigned счётчик nanosecond после полуночи гражданского дня |
| `0x06CL` | [POSIX-TIMESTAMP-SECONDS](value/0x06CL-posix-timestamp-seconds.md) | TIME | signed счётчик секунд от эпохи Unix/POSIX |
| `0x06DL` | [DURATION-SECONDS](value/0x06DL-duration-seconds.md) | TIME | signed прошедшее время в SI-секундах без эпохи |
| `0x06EL`/`0x06FL` | [EDTF](value/0x06EL-edtf.md) | TIME | строка даты EDTF (ISO 8601-2). Чётное и нечётное число байт. Дата, которую можно записать как GREGORIAN-DATE, не записывается так |
| `0x070L`/`0x071L` | [GEDCOM-DATE](value/0x070L-gedcom-date.md) | TIME | строка значения даты GEDCOM 7. Сохраняет исходную запись других календарей (юлианского и т. д.). Чётное и нечётное число байт |
| `0x072L` | [UTF8-TEXT-EVEN](value/0x072L-utf8-text.md) | TEXT | последовательность байт valid UTF-8, не подразумевающая нормализации. Чётное число байт |
| `0x073L` | [UTF8-TEXT-ODD](value/0x072L-utf8-text.md) | TEXT | то же. Нечётное число байт |
| `0x074L` | [URI-EVEN](value/0x074L-uri.md) | TEXT | ASCII-последовательность байт по production `URI` RFC 3986. Чётное число байт |
| `0x075L` | [URI-ODD](value/0x074L-uri.md) | TEXT | то же. Нечётное число байт |
| `0x076L` | [LANGUAGE-BCP47-CODE-EVEN](value/0x076L-language-bcp47-code.md) | TEXT | ASCII-последовательность байт полного языкового тега BCP 47 в canonical casing. Чётное число байт |
| `0x077L` | [LANGUAGE-BCP47-CODE-ODD](value/0x076L-language-bcp47-code.md) | TEXT | то же. Нечётное число байт |
| `0x078L`/`0x079L` | [UTF8-LANGUAGE-TEXT](value/0x078L-utf8-language-text.md) | TEXT | текст с указанием языка. Запись Value языка (LANGUAGE-SHORT-CODE или LANGUAGE-BCP47-CODE) и байты UTF-8. Чётность или нечётность числа байт текста |
| `0x07AL` | [LANGUAGE-SHORT-CODE](value/0x07AL-language-short-code.md) | TEXT | тег BCP 47, записанный номером GEUL Language Registry (Payload 1 WORD) |
| `0x07BL` | [UUID](value/0x07BL-uuid.md) | BINARY | UUID RFC 9562 из 128 бит, фиксированный Payload 8 WORD |
| `0x07CL` | [SHA-256-DIGEST](value/0x07CL-sha-256-digest.md) | BINARY | результат SHA-256, фиксированный Payload 16 WORD |
| `0x07DL` | [SHA1-DIGEST](value/0x07DL-sha1-digest.md) | BINARY | результат SHA-1, фиксированный Payload 10 WORD. Только для идентификации, как ID объектов git |
| `0x07EL` | [OPAQUE-BYTES-EVEN](value/0x07EL-opaque-bytes.md) | BINARY | последовательность байт неизвестного смысла и формата. Чётное число байт |
| `0x07FL` | [OPAQUE-BYTES-ODD](value/0x07EL-opaque-bytes.md) | BINARY | то же. Нечётное число байт |
| `0x080L` | [BIT-VECTOR](value/0x080L-bit-vector.md) | BINARY | N бит, хранимых MSB-first после bit-count |
| `0x081L` | [DURATION-NANOSECONDS](value/0x081L-duration-nanoseconds.md) | TIME | signed прошедшее время в nanosecond без эпохи |
| `0x09DL`~`0x09FL` | [VALUE-ISSUER-2WORD](value/0x09DL-value-issuer-2word.md), [-4WORD](value/0x09EL-value-issuer-4word.md), [-16WORD](value/0x09FL-value-issuer-16word.md) |  | формат, определённый Issuer. См. «Формат Value ISSUER» ниже |

### Формат Value ISSUER {#value-issuer-형식}

После `0x09DL`~`0x09FL` ([VALUE-ISSUER-2WORD](value/0x09DL-value-issuer-2word.md), [-4WORD](value/0x09EL-value-issuer-4word.md), [-16WORD](value/0x09FL-value-issuer-16word.md)) в расширяющем TAG Codec помещаются Issuer и номер Codec 2 WORD. Документ Codec размещается в `codecs/` этого Issuer под номером Codec записи. Пример: IETF CRC32C — `0x00000007/codecs/0x0000C000/` ([Адрес публикации и список версий](publishing.md)).

| Issuer | Номер Codec | Имя | Описание |
|---|---|---|---|
| `0x00000002` ADHOC | `0x00000000` | BFLOAT16 | биты обмена BF16, фиксированный Payload 1 WORD |
| `0x00000002` ADHOC | `0x00000500` | [DENSE-I16-VECTOR](value/adhoc.geul.org/dense-i16-vector.md) | непрерывный big-endian int16 vector |
| `0x00000002` ADHOC | `0x00000501` | [DENSE-U16-VECTOR](value/adhoc.geul.org/dense-u16-vector.md) | непрерывный big-endian uint16 vector |
| `0x00000002` ADHOC | `0x00000502` | [DENSE-I32-VECTOR](value/adhoc.geul.org/dense-i32-vector.md) | непрерывный big-endian int32 vector |
| `0x00000002` ADHOC | `0x00000503` | [DENSE-U32-VECTOR](value/adhoc.geul.org/dense-u32-vector.md) | непрерывный big-endian uint32 vector |
| `0x00000002` ADHOC | `0x00000504` | [DENSE-I64-VECTOR](value/adhoc.geul.org/dense-i64-vector.md) | непрерывный big-endian int64 vector |
| `0x00000002` ADHOC | `0x00000505` | [DENSE-U64-VECTOR](value/adhoc.geul.org/dense-u64-vector.md) | непрерывный big-endian uint64 vector |
| `0x00000002` ADHOC | `0x00000506` | [DENSE-BINARY16-VECTOR](value/adhoc.geul.org/dense-binary16-vector.md) | непрерывный IEEE 754 binary16 vector |
| `0x00000002` ADHOC | `0x00000507` | [DENSE-BFLOAT16-VECTOR](value/adhoc.geul.org/dense-bfloat16-vector.md) | непрерывный BF16 vector |
| `0x00000002` ADHOC | `0x00000508` | [DENSE-BINARY32-VECTOR](value/adhoc.geul.org/dense-binary32-vector.md) | непрерывный IEEE 754 binary32 vector |
| `0x00000002` ADHOC | `0x00000509` | [DENSE-BINARY64-VECTOR](value/adhoc.geul.org/dense-binary64-vector.md) | непрерывный IEEE 754 binary64 vector |
| `0x00000002` ADHOC | `0x0000050A` | [POINT2-BINARY64](value/adhoc.geul.org/point2-binary64.md) | двумерный vector IEEE binary64 в порядке `(x,y)` |
| `0x00000002` ADHOC | `0x0000050B` | [POINT3-BINARY64](value/adhoc.geul.org/point3-binary64.md) | трёхмерный vector IEEE binary64 в порядке `(x,y,z)` |
| `0x00000002` ADHOC | `0x0000050C` | [BBOX2-BINARY64](value/adhoc.geul.org/bbox2-binary64.md) | vector IEEE binary64 в порядке `(minX,minY,maxX,maxY)` |
| `0x00000002` ADHOC | `0x00000600` | [DESCRIBED-DENSE-TENSOR](value/adhoc.geul.org/described-dense-tensor.md) | element-format, rank, shape и C-contiguous dense payload |
| `0x00000002` ADHOC | `0x00000601` | [DESCRIBED-PACKED-TENSOR](value/adhoc.geul.org/described-packed-tensor.md) | packed-format, rank, shape и packed payload с low-bit-first внутри octet |
| `0x00000002` ADHOC | `0x00000700` | [COMPLEX64](value/adhoc.geul.org/complex64.md) | два binary32 в порядке `(real, imag)` |
| `0x00000002` ADHOC | `0x00000701` | [COMPLEX128](value/adhoc.geul.org/complex128.md) | два binary64 в порядке `(real, imag)` |
| `0x00000002` ADHOC | `0x00000702` | [RATIONAL-I64](value/adhoc.geul.org/rational-i64.md) | нормализованный int64 numerator и положительный int64 denominator |
| `0x00000002` ADHOC | `0x00000703` | [CLOSED-INTERVAL-BINARY64](value/adhoc.geul.org/closed-interval-binary64.md) | замкнутый интервал binary64 с `lower ≤ upper` |
| `0x00000002` ADHOC | `0x00000704` | [QUATERNION-BINARY32](value/adhoc.geul.org/quaternion-binary32.md) | четыре binary32 в порядке `(x,y,z,w)` |
| `0x00000002` ADHOC | `0x0000C000` | [BLAKE3-256-DIGEST](value/adhoc.geul.org/blake3-256-digest.md) | результат BLAKE3 по умолчанию, фиксированный Payload 16 WORD |
| `0x00000007` IETF | `0x00008000` | [URI-RELATIVE-REF-EVEN](value/ietf.geul.org/uri-relative-ref.md) | ASCII-последовательность байт relative-ref RFC 3986. Чётное число байт |
| `0x00000007` IETF | `0x00008001` | [URI-RELATIVE-REF-ODD](value/ietf.geul.org/uri-relative-ref.md) | то же. Нечётное число байт |
| `0x00000007` IETF | `0x0000C000` | [CRC32C](value/ietf.geul.org/crc32c.md) | результат CRC-32C Castagnoli, фиксированный Payload 2 WORD |
| `0x00000007` IETF | `0x0000C001` | [IPV4-ADDRESS](value/ietf.geul.org/ipv4-address.md) | 32-битный адрес IPv4, фиксированный Payload 2 WORD |
| `0x00000007` IETF | `0x0000C002` | [IPV6-ADDRESS](value/ietf.geul.org/ipv6-address.md) | 128-битный адрес IPv6, фиксированный Payload 8 WORD |
| `0x0000000D` IEEE | `0x00002000` | [IEEE-DECIMAL32-DPD](value/ieee.geul.org/ieee-decimal32-dpd.md) | IEEE 754 decimal32 DPD, фиксированный Payload 2 WORD |
| `0x0000000D` IEEE | `0x00002001` | [IEEE-DECIMAL64-DPD](value/ieee.geul.org/ieee-decimal64-dpd.md) | IEEE 754 decimal64 DPD, фиксированный Payload 4 WORD |
| `0x0000000D` IEEE | `0x00002002` | [IEEE-DECIMAL128-DPD](value/ieee.geul.org/ieee-decimal128-dpd.md) | IEEE 754 decimal128 DPD, фиксированный Payload 8 WORD |
| `0x0000000D` IEEE | `0x00002003` | [IEEE-DECIMAL32-BID](value/ieee.geul.org/ieee-decimal32-bid.md) | IEEE 754 decimal32 BID, фиксированный Payload 2 WORD |
| `0x0000000D` IEEE | `0x00002004` | [IEEE-DECIMAL64-BID](value/ieee.geul.org/ieee-decimal64-bid.md) | IEEE 754 decimal64 BID, фиксированный Payload 4 WORD |
| `0x0000000D` IEEE | `0x00002005` | [IEEE-DECIMAL128-BID](value/ieee.geul.org/ieee-decimal128-bid.md) | IEEE 754 decimal128 BID, фиксированный Payload 8 WORD |
| `0x0000000D` IEEE | `0x00004000` | [POSIX-TIMESTAMP-NANOSECONDS](value/ieee.geul.org/posix-timestamp-nanoseconds.md) | signed счётчик nanosecond от эпохи Unix/POSIX |
| `0x0000000D` IEEE | `0x0000C000` | [MAC-48-ADDRESS](value/ieee.geul.org/mac-48-address.md) | 48-битный MAC-адрес IEEE 802, фиксированный Payload 3 WORD |
| `0x0000000E` KHRONOS | `0x00000000` | [RGBA8-UNORM](value/khronos.geul.org/rgba8-unorm.md) | фиксированный packed vector 4×UNORM8 в порядке R, G, B, A |
| `0x0000000E` KHRONOS | `0x00000001` | [BGRA8-UNORM](value/khronos.geul.org/bgra8-unorm.md) | фиксированный packed vector 4×UNORM8 в порядке B, G, R, A |
| `0x00000010` ONNX | `0x00000000` | FP8-E4M3FN | скаляр ONNX E4M3FN в старшем octet Payload |
| `0x00000010` ONNX | `0x00000001` | FP8-E4M3FNUZ | скаляр ONNX E4M3FNUZ в старшем octet Payload |
| `0x00000010` ONNX | `0x00000002` | FP8-E5M2 | скаляр ONNX E5M2 в старшем octet Payload |
| `0x00000010` ONNX | `0x00000003` | FP8-E5M2FNUZ | скаляр ONNX E5M2FNUZ в старшем octet Payload |
| `0x00000011` OCP | `0x00000000` | FP8-E8M0FNU | unsigned скаляр exponent-only E8M0FNU в старшем octet Payload |
| `0x00000011` OCP | `0x00000001` | FP4-E2M1FN | скаляр ONNX/DLPack E2M1FN в старшем nibble Payload |
| `0x00000013` BIPM | `0x00004000` | [TAI-TIMESTAMP-SECONDS](value/bipm.geul.org/tai-timestamp-seconds.md) | signed счётчик SI-секунд от `1970-01-01T00:00:00 TAI` |
| `0x00000013` BIPM | `0x00004001` | [TAI-TIMESTAMP-NANOSECONDS](value/bipm.geul.org/tai-timestamp-nanoseconds.md) | signed счётчик nanosecond от той же эпохи TAI |
| `0x00000015` NIST | `0x0000C000` | [SHA-512-DIGEST](value/nist.geul.org/sha-512-digest.md) | результат SHA-512, фиксированный Payload 32 WORD |
| `0x00000015` NIST | `0x0000C001` | [SHA3-256-DIGEST](value/nist.geul.org/sha3-256-digest.md) | результат SHA3-256, фиксированный Payload 16 WORD |
| `0x00000016` GPS | `0x00004000` | [GPS-TIMESTAMP-SECONDS](value/gps.geul.org/gps-timestamp-seconds.md) | signed счётчик секунд от эпохи GPS |
| `0x00000016` GPS | `0x00004001` | [GPS-TIMESTAMP-NANOSECONDS](value/gps.geul.org/gps-timestamp-nanoseconds.md) | signed счётчик nanosecond от эпохи GPS |

## Meta {#meta}

`0x1C0L~0x1FFL` — [Meta](meta/_index.md)

Номер Meta не выражает класс битами. Класс определяется по таблице диапазонов ниже. Класс проверки — это записи с `C >= 5` в разделе 15, то есть `w >= 0x1E50`; его знают без кодовой книги. У Meta кодов ISSUER нет.

| Класс | Прямой код | Что охватывает |
|---|---|---|
| [структура](meta/_index.md#구조) | `0x1C0L~0x1C4L` | границы и длина документа |
| [объявление](meta/_index.md#정의) | `0x1C5L~0x1CAL` | объявления интерпретации |
| [происхождение](meta/_index.md#출처) | `0x1CBL~0x1D0L` | кто, когда, откуда |
| [родословная](meta/_index.md#계보) | `0x1D1L~0x1DDL` | из чего и как получено |
| [политика](meta/_index.md#정책) | `0x1DEL~0x1E3L` | как с этим обращаться |
| [IMPORT](meta/_index.md#import) | `0x1E4L` | импорт внешнего документа по IMPORT ID (`IMPORT-DOC`) |
| [проверка](meta/_index.md#검증) | `0x1E5L~0x1E9L` | можно ли доверять |
| Reserved (только для проверки) | `0x1EAL~0x1FFL` |  |

- Номера идут от `0x1C0L` без Reserved. Новый Meta вне проверки нельзя вставить перед проверкой. Задний Reserved `0x1EAL~0x1FFL` предназначен только для проверки. Meta вне проверки, помещённый сюда, выпадает из хеша содержимого.

### Структура (`0x1C0L~0x1C4L`) {#구조-0x1c0l0x1c4l}

| Codec | Имя | Описание |
|---|---|---|
| `0x1C0L` | [DOC-1WORD](meta/0x1C0L-doc-1word.md) | начало документа с полной длиной в Payload 1 WORD |
| `0x1C1L` | [DOC-2WORD](meta/0x1C1L-doc-2word.md) | начало документа с полной длиной в Payload 2 WORD |
| `0x1C2L` | [DOC-4WORD](meta/0x1C2L-doc-4word.md) | начало документа с полной длиной в Payload 4 WORD |
| `0x1C3L` | [BODY](meta/0x1C3L-body.md) | 1 WORD. Завершает HEAD документа и начинает BODY. |
| `0x1C4L` | [END](meta/0x1C4L-end.md) | 1 WORD. Закрывает документ. |

### Объявление (`0x1C5L~0x1CAL`) {#정의-0x1c5l0x1cal}

| Codec | Имя | Описание |
|---|---|---|
| `0x1C5L` | [SPEC-VERSION](meta/0x1C5L-spec-version.md) | редакция спецификации GEUL, которой следует документ. Payload — это и есть unsigned целое наименьшей ширины. v1 — `0x0001` (запись `0x1C51 0x0001`) |
| `0x1C6L` | [PROFILE](meta/0x1C6L-profile.md) | применяемый профиль |
| `0x1C7L` | [DOC-ID](meta/0x1C7L-doc-id.md) | идентификатор этого документа. Встроенная Reference `DOC-POINTER` (Issuer, ID документа, версия 0). Документ Codec — `CODEC-POINTER` (Issuer, ID Codec, версия 0) |
| `0x1C8L` | [EFFECTIVE-FROM](meta/0x1C8L-effective-from.md) | дата вступления этой версии в силу. Value GREGORIAN-DATE или POSIX-TIMESTAMP. Если нет — момент публикации |
| `0x1C9L` | [EFFECTIVE-UNTIL](meta/0x1C9L-effective-until.md) | конец срока действия этой версии (срочный закон). Если нет — до вступления в силу следующей версии |
| `0x1CAL` | [DEFAULT-LANGUAGE](meta/0x1CAL-default-language.md) | язык по умолчанию |

### Происхождение (`0x1CBL~0x1D0L`) {#출처-0x1cbl0x1d0l}

| Codec | Имя | Описание |
|---|---|---|
| `0x1CBL` | [AUTHOR](meta/0x1CBL-author.md) | автор. Reference (git author) |
| `0x1CCL` | [CO-AUTHOR](meta/0x1CCL-co-author.md) | соавтор. Reference (git `Co-authored-by`) |
| `0x1CDL` | [CREATED-AT](meta/0x1CDL-created-at.md) | время создания. Value TIME (git author date) |
| `0x1CEL` | [MODIFIED-AT](meta/0x1CEL-modified-at.md) | время изменения. Value TIME |
| `0x1CFL` | [RECORDED-BY](meta/0x1CFL-recorded-by.md) | субъект, сделавший запись. Reference (git committer) |
| `0x1D0L` | [RECORDED-AT](meta/0x1D0L-recorded-at.md) | время записи. Value TIME (git commit date) |

- Исходные материалы, их диапазон, время получения и хеш записываются не в Meta, а через Edge-основание HEAD [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처) (Target `0`) и его QUALIFIER.

### Родословная (`0x1D1L~0x1DDL`) {#계보-0x1d1l0x1ddl}

| Codec | Имя | Описание |
|---|---|---|
| `0x1D1L` | [PARENT](meta/0x1D1L-parent.md) | хеш содержимого непосредственно предыдущей версии (git parent). Если нет — первая версия, если несколько — слияние (git merge commit). |
| `0x1D2L` | [DERIVED-FROM](meta/0x1D2L-derived-from.md) | производное от записей или материалов другой родословной. Чтобы зафиксировать определённую версию внешнего материала, к [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처) в HEAD присоединяют QUALIFIER хеша подлинника (P4092) (git submodule). |
| `0x1D3L` | [GENERATED-BY](meta/0x1D3L-generated-by.md) | порождающий субъект. Человек, модель, механизм правил |
| `0x1D4L` | [TRANSFORMED-BY](meta/0x1D4L-transformed-by.md) | способ преобразования. Инструмент, правила, версия |
| `0x1D5L` | [CHERRY-PICKED-FROM](meta/0x1D5L-cherry-picked-from.md) | хеш содержимого исходной версии, изменение которой перенесено из другой родословной (git cherry-pick `-x`) |
| `0x1D6L` | [REVERTS](meta/0x1D6L-reverts.md) | хеш содержимого версии, изменение которой отменено (git revert) |
| `0x1D7L` | [REPLACES](meta/0x1D7L-replaces.md) | хеш содержимого переписанной версии (git amend, rebase). Исходная версия не удаляется. |
| `0x1D8L` | [SQUASHED-FROM](meta/0x1D8L-squashed-from.md) | хеши содержимого исходных версий, объединённых в одну (git squash) |
| `0x1D9L` | [MESSAGE](meta/0x1D9L-message.md) | причина изменения. Value UTF8-LANGUAGE-TEXT, по одному на язык (git commit message) |
| `0x1DAL` | [TAG](meta/0x1DAL-tag.md) | неизменяемое имя, присвоенное версии. Value TEXT и хеш содержимого (git annotated tag) |
| `0x1DBL` | [DELTA-BASE](meta/0x1DBL-delta-base.md) | файл этой версии — diff относительно базовой версии того же документа (ID версии 2 WORD) (git packfile delta) |
| `0x1DCL` | [DELTA-REMOVE](meta/0x1DCL-delta-remove.md) | список LOCAL ID (Edge Id), которые diff удаляет из базового BODY |
| `0x1DDL` | [NEXT-LOCAL-ID](meta/0x1DDL-next-local-id.md) | LOCAL ID, который будет назначен следующим (auto increment). Помещается в HEAD списка версий `versions.geul` |

### Политика (`0x1DEL~0x1E3L`) {#정책-0x1del0x1e3l}

| Codec | Имя | Описание |
|---|---|---|
| `0x1DEL` | [LICENSE](meta/0x1DEL-license.md) | лицензия. Reference |
| `0x1DFL` | [ACCESS](meta/0x1DFL-access.md) | область раскрытия |
| `0x1E0L` | [PRIVACY](meta/0x1E0L-privacy.md) | уровень персональных данных |
| `0x1E1L` | [RETENTION](meta/0x1E1L-retention.md) | срок хранения |
| `0x1E2L` | [CONSENT](meta/0x1E2L-consent.md) | объём и основание согласия |
| `0x1E3L` | [USAGE](meta/0x1E3L-usage.md) | ограничения использования |

### IMPORT (`0x1E4L`) {#import-0x1e4l}

| Codec | Имя | Описание |
|---|---|---|
| `0x1E4L` | [IMPORT-DOC](meta/0x1E4L-import-doc.md) | импортирует внешний документ по IMPORT ID. Встроенная Reference `DOC-POINTER` (для документа Codec — `CODEC-POINTER`) + IMPORT ID |

### Проверка (`0x1E5L~0x1E9L`) {#검증-0x1e5l0x1e9l}

| Codec | Имя | Описание |
|---|---|---|
| `0x1E5L` | [ISSUER-KEY](meta/0x1E5L-issuer-key.md) | объявление ID алгоритма подписи и открытого ключа самостоятельно выдающего Issuer |
| `0x1E6L` | [SIGNATURE](meta/0x1E6L-signature.md) | подпись цели. Подпись документа — это подпись хеша содержимого (git подписанные коммиты и теги) |
| `0x1E7L` | [SIGNED-OFF](meta/0x1E7L-signed-off.md) | подтверждение права на вклад. Reference (git `Signed-off-by`, DCO) |
| `0x1E8L` | [CONFIDENCE](meta/0x1E8L-confidence.md) | достоверность |
| `0x1E9L` | [VERDICT](meta/0x1E9L-verdict.md) | результат вердикта по всему документу. Pass, Review, Fail. На уровне узлов и записей — `VERDICT` ([TOULMIN](toulmin/_index.md), Edge `0x118L`) |

## Полная таблица назначения {#전체-배정표}

Назначено 227 ячеек, 176 md. Для системы 5Q и пар «чётный и нечётный» на каждого члена по одной строке, а md — это md-заголовок группы.

| TAG ID | Codec ID | Имя | Kind | Раздел | md | Группа |
|---|---|---|---|---|---|---|
| `0x000L` | `0x00000000` | ABSENT | Reference | 0 | [0x000L-absent.md](reference/0x000L-absent.md) |  |
| `0x001L` | `0x00000010` | UNKNOWN-VALUE | Reference | 0 | [0x001L-unknown-value.md](reference/0x001L-unknown-value.md) |  |
| `0x002L` | `0x00000020` | NO-VALUE | Reference | 0 | [0x002L-no-value.md](reference/0x002L-no-value.md) |  |
| `0x005L` | `0x00000050` | LOCAL-IDENTIFIED | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x006L` | `0x00000060` | LOCAL-GENERIC | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x007L` | `0x00000070` | LOCAL-FREE-CHOICE | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x008L` | `0x00000080` | LOCAL-UNIVERSAL | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x009L` | `0x00000090` | LOCAL-VARIABLE | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x00AL` | `0x000000A0` | GEUL-IDENTIFIED | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00BL` | `0x000000B0` | GEUL-GENERIC | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00CL` | `0x000000C0` | GEUL-FREE-CHOICE | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00DL` | `0x000000D0` | GEUL-UNIVERSAL | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00EL` | `0x000000E0` | GEUL-VARIABLE | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00FL` | `0x000000F0` | GEUL-SIDX-IDENTIFIED | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x010L` | `0x00000100` | GEUL-SIDX-GENERIC | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x011L` | `0x00000110` | GEUL-SIDX-FREE-CHOICE | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x012L` | `0x00000120` | GEUL-SIDX-UNIVERSAL | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x013L` | `0x00000130` | GEUL-SIDX-VARIABLE | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x014L` | `0x00000140` | WIKIDATA-QID-IDENTIFIED | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x015L` | `0x00000150` | WIKIDATA-QID-GENERIC | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x016L` | `0x00000160` | WIKIDATA-QID-FREE-CHOICE | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x017L` | `0x00000170` | WIKIDATA-QID-UNIVERSAL | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x018L` | `0x00000180` | WIKIDATA-QID-VARIABLE | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x019L` | `0x00000190` | WIKIDATA-PID-IDENTIFIED | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01AL` | `0x000001A0` | WIKIDATA-PID-GENERIC | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01BL` | `0x000001B0` | WIKIDATA-PID-FREE-CHOICE | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01CL` | `0x000001C0` | WIKIDATA-PID-UNIVERSAL | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01DL` | `0x000001D0` | WIKIDATA-PID-VARIABLE | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x020L` | `0x00000200` | EXTERNAL-POINTER-1WORD-IDENTIFIED | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x021L` | `0x00000210` | EXTERNAL-POINTER-1WORD-GENERIC | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x022L` | `0x00000220` | EXTERNAL-POINTER-1WORD-FREE-CHOICE | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x023L` | `0x00000230` | EXTERNAL-POINTER-1WORD-UNIVERSAL | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x024L` | `0x00000240` | EXTERNAL-POINTER-1WORD-VARIABLE | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x025L` | `0x00000250` | EXTERNAL-POINTER-2WORD-IDENTIFIED | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x026L` | `0x00000260` | EXTERNAL-POINTER-2WORD-GENERIC | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x027L` | `0x00000270` | EXTERNAL-POINTER-2WORD-FREE-CHOICE | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x028L` | `0x00000280` | EXTERNAL-POINTER-2WORD-UNIVERSAL | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x029L` | `0x00000290` | EXTERNAL-POINTER-2WORD-VARIABLE | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x02AL` | `0x000002A0` | EXTERNAL-POINTER-4WORD-IDENTIFIED | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02BL` | `0x000002B0` | EXTERNAL-POINTER-4WORD-GENERIC | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02CL` | `0x000002C0` | EXTERNAL-POINTER-4WORD-FREE-CHOICE | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02DL` | `0x000002D0` | EXTERNAL-POINTER-4WORD-UNIVERSAL | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02EL` | `0x000002E0` | EXTERNAL-POINTER-4WORD-VARIABLE | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02FL` | `0x000002F0` | EXTERNAL-ISSUER-2WORD-IDENTIFIED | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x030L` | `0x00000300` | EXTERNAL-ISSUER-2WORD-GENERIC | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x031L` | `0x00000310` | EXTERNAL-ISSUER-2WORD-FREE-CHOICE | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x032L` | `0x00000320` | EXTERNAL-ISSUER-2WORD-UNIVERSAL | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x033L` | `0x00000330` | EXTERNAL-ISSUER-2WORD-VARIABLE | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x034L` | `0x00000340` | EXTERNAL-ISSUER-4WORD-IDENTIFIED | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x035L` | `0x00000350` | EXTERNAL-ISSUER-4WORD-GENERIC | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x036L` | `0x00000360` | EXTERNAL-ISSUER-4WORD-FREE-CHOICE | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x037L` | `0x00000370` | EXTERNAL-ISSUER-4WORD-UNIVERSAL | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x038L` | `0x00000380` | EXTERNAL-ISSUER-4WORD-VARIABLE | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x039L` | `0x00000390` | EXTERNAL-ISSUER-16WORD-IDENTIFIED | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03AL` | `0x000003A0` | EXTERNAL-ISSUER-16WORD-GENERIC | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03BL` | `0x000003B0` | EXTERNAL-ISSUER-16WORD-FREE-CHOICE | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03CL` | `0x000003C0` | EXTERNAL-ISSUER-16WORD-UNIVERSAL | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03DL` | `0x000003D0` | EXTERNAL-ISSUER-16WORD-VARIABLE | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x040L` | `0x00000400` | ISSUER-POINTER | Reference | 2 | [0x040L-issuer-pointer.md](reference/0x040L-issuer-pointer.md) |  |
| `0x041L` | `0x00000410` | DOC-POINTER | Reference | 2 | [0x041L-doc-pointer.md](reference/0x041L-doc-pointer.md) |  |
| `0x042L` | `0x00000420` | CODEC-POINTER | Reference | 2 | [0x042L-codec-pointer.md](reference/0x042L-codec-pointer.md) |  |
| `0x05DL` | `0x000005D0` | REFERENCE-ISSUER-2WORD | Reference | 2 | [0x05DL-reference-issuer-2word.md](reference/0x05DL-reference-issuer-2word.md) |  |
| `0x05EL` | `0x000005E0` | REFERENCE-ISSUER-4WORD | Reference | 2 | [0x05EL-reference-issuer-4word.md](reference/0x05EL-reference-issuer-4word.md) |  |
| `0x05FL` | `0x000005F0` | REFERENCE-ISSUER-16WORD | Reference | 2 | [0x05FL-reference-issuer-16word.md](reference/0x05FL-reference-issuer-16word.md) |  |
| `0x060L` | `0x00000600` | BOOL | Value | 3 | [0x060L-bool.md](value/0x060L-bool.md) |  |
| `0x061L` | `0x00000610` | SIGNED-INTEGER | Value | 3 | [0x061L-signed-integer.md](value/0x061L-signed-integer.md) |  |
| `0x062L` | `0x00000620` | UNSIGNED-INTEGER | Value | 3 | [0x062L-unsigned-integer.md](value/0x062L-unsigned-integer.md) |  |
| `0x063L` | `0x00000630` | BINARY-FLOAT | Value | 3 | [0x063L-binary-float.md](value/0x063L-binary-float.md) |  |
| `0x064L` | `0x00000640` | COORDINATE-EARTH | Value | 3 | [0x064L-coordinate-earth.md](value/0x064L-coordinate-earth.md) |  |
| `0x065L` | `0x00000650` | COORDINATE-GEO | Value | 3 | [0x065L-coordinate-geo.md](value/0x065L-coordinate-geo.md) |  |
| `0x066L` | `0x00000660` | QUANTITY | Value | 3 | [0x066L-quantity.md](value/0x066L-quantity.md) |  |
| `0x067L` | `0x00000670` | FRACTION | Value | 3 | [0x067L-fraction.md](value/0x067L-fraction.md) |  |
| `0x068L` | `0x00000680` | SIGNED-DECIMAL | Value | 3 | [0x068L-signed-decimal.md](value/0x068L-signed-decimal.md) |  |
| `0x069L` | `0x00000690` | UNSIGNED-DECIMAL | Value | 3 | [0x069L-unsigned-decimal.md](value/0x069L-unsigned-decimal.md) |  |
| `0x06AL` | `0x000006A0` | GREGORIAN-DATE | Value | 3 | [0x06AL-gregorian-date.md](value/0x06AL-gregorian-date.md) |  |
| `0x06BL` | `0x000006B0` | CIVIL-TIME-NANOSECONDS | Value | 3 | [0x06BL-civil-time-nanoseconds.md](value/0x06BL-civil-time-nanoseconds.md) |  |
| `0x06CL` | `0x000006C0` | POSIX-TIMESTAMP-SECONDS | Value | 3 | [0x06CL-posix-timestamp-seconds.md](value/0x06CL-posix-timestamp-seconds.md) |  |
| `0x06DL` | `0x000006D0` | DURATION-SECONDS | Value | 3 | [0x06DL-duration-seconds.md](value/0x06DL-duration-seconds.md) |  |
| `0x06EL` | `0x000006E0` | EDTF-EVEN | Value | 3 | [0x06EL-edtf.md](value/0x06EL-edtf.md) | чёт-нечёт `EDTF` |
| `0x06FL` | `0x000006F0` | EDTF-ODD | Value | 3 | [0x06EL-edtf.md](value/0x06EL-edtf.md) | чёт-нечёт `EDTF` |
| `0x070L` | `0x00000700` | GEDCOM-DATE-EVEN | Value | 3 | [0x070L-gedcom-date.md](value/0x070L-gedcom-date.md) | чёт-нечёт `GEDCOM-DATE` |
| `0x071L` | `0x00000710` | GEDCOM-DATE-ODD | Value | 3 | [0x070L-gedcom-date.md](value/0x070L-gedcom-date.md) | чёт-нечёт `GEDCOM-DATE` |
| `0x072L` | `0x00000720` | UTF8-TEXT-EVEN | Value | 3 | [0x072L-utf8-text.md](value/0x072L-utf8-text.md) | чёт-нечёт `UTF8-TEXT` |
| `0x073L` | `0x00000730` | UTF8-TEXT-ODD | Value | 3 | [0x072L-utf8-text.md](value/0x072L-utf8-text.md) | чёт-нечёт `UTF8-TEXT` |
| `0x074L` | `0x00000740` | URI-EVEN | Value | 3 | [0x074L-uri.md](value/0x074L-uri.md) | чёт-нечёт `URI` |
| `0x075L` | `0x00000750` | URI-ODD | Value | 3 | [0x074L-uri.md](value/0x074L-uri.md) | чёт-нечёт `URI` |
| `0x076L` | `0x00000760` | LANGUAGE-BCP47-CODE-EVEN | Value | 3 | [0x076L-language-bcp47-code.md](value/0x076L-language-bcp47-code.md) | чёт-нечёт `LANGUAGE-BCP47-CODE` |
| `0x077L` | `0x00000770` | LANGUAGE-BCP47-CODE-ODD | Value | 3 | [0x076L-language-bcp47-code.md](value/0x076L-language-bcp47-code.md) | чёт-нечёт `LANGUAGE-BCP47-CODE` |
| `0x078L` | `0x00000780` | UTF8-LANGUAGE-TEXT-EVEN | Value | 3 | [0x078L-utf8-language-text.md](value/0x078L-utf8-language-text.md) | чёт-нечёт `UTF8-LANGUAGE-TEXT` |
| `0x079L` | `0x00000790` | UTF8-LANGUAGE-TEXT-ODD | Value | 3 | [0x078L-utf8-language-text.md](value/0x078L-utf8-language-text.md) | чёт-нечёт `UTF8-LANGUAGE-TEXT` |
| `0x07AL` | `0x000007A0` | LANGUAGE-SHORT-CODE | Value | 3 | [0x07AL-language-short-code.md](value/0x07AL-language-short-code.md) |  |
| `0x07BL` | `0x000007B0` | UUID | Value | 3 | [0x07BL-uuid.md](value/0x07BL-uuid.md) |  |
| `0x07CL` | `0x000007C0` | SHA-256-DIGEST | Value | 3 | [0x07CL-sha-256-digest.md](value/0x07CL-sha-256-digest.md) |  |
| `0x07DL` | `0x000007D0` | SHA1-DIGEST | Value | 3 | [0x07DL-sha1-digest.md](value/0x07DL-sha1-digest.md) |  |
| `0x07EL` | `0x000007E0` | OPAQUE-BYTES-EVEN | Value | 3 | [0x07EL-opaque-bytes.md](value/0x07EL-opaque-bytes.md) | чёт-нечёт `OPAQUE-BYTES` |
| `0x07FL` | `0x000007F0` | OPAQUE-BYTES-ODD | Value | 3 | [0x07EL-opaque-bytes.md](value/0x07EL-opaque-bytes.md) | чёт-нечёт `OPAQUE-BYTES` |
| `0x080L` | `0x00000800` | BIT-VECTOR | Value | 4 | [0x080L-bit-vector.md](value/0x080L-bit-vector.md) |  |
| `0x081L` | `0x00000810` | DURATION-NANOSECONDS | Value | 4 | [0x081L-duration-nanoseconds.md](value/0x081L-duration-nanoseconds.md) |  |
| `0x09DL` | `0x000009D0` | VALUE-ISSUER-2WORD | Value | 4 | [0x09DL-value-issuer-2word.md](value/0x09DL-value-issuer-2word.md) |  |
| `0x09EL` | `0x000009E0` | VALUE-ISSUER-4WORD | Value | 4 | [0x09EL-value-issuer-4word.md](value/0x09EL-value-issuer-4word.md) |  |
| `0x09FL` | `0x000009F0` | VALUE-ISSUER-16WORD | Value | 4 | [0x09FL-value-issuer-16word.md](value/0x09FL-value-issuer-16word.md) |  |
| `0x0A0L` | `0x00000A00` | REFERENCE-NODE | Edge | 5 | [0x0A0L-reference-node.md](edge/0x0A0L-reference-node.md) |  |
| `0x0A1L` | `0x00000A10` | SAME-NODE | Edge | 5 | [0x0A1L-same-node.md](edge/0x0A1L-same-node.md) |  |
| `0x0A2L` | `0x00000A20` | DIFFERENT-NODE | Edge | 5 | [0x0A2L-different-node.md](edge/0x0A2L-different-node.md) |  |
| `0x0A3L` | `0x00000A30` | BIND | Edge | 5 | [0x0A3L-bind.md](edge/0x0A3L-bind.md) |  |
| `0x0A4L` | `0x00000A40` | LABEL | Edge | 5 | [0x0A4L-label.md](edge/0x0A4L-label.md) |  |
| `0x0A5L` | `0x00000A50` | ALIAS | Edge | 5 | [0x0A5L-alias.md](edge/0x0A5L-alias.md) |  |
| `0x0A6L` | `0x00000A60` | DESCRIPTION | Edge | 5 | [0x0A6L-description.md](edge/0x0A6L-description.md) |  |
| `0x0A8L` | `0x00000A80` | VERB-SHORT | Edge | 5 | [0x0A8L-verb-short.md](edge/0x0A8L-verb-short.md) |  |
| `0x0A9L` | `0x00000A90` | VERB | Edge | 5 | [0x0A9L-verb.md](edge/0x0A9L-verb.md) |  |
| `0x0AAL` | `0x00000AA0` | TRIPLE | Edge | 5 | [0x0AAL-triple.md](edge/0x0AAL-triple.md) |  |
| `0x0ABL` | `0x00000AB0` | QUALIFIER | Edge | 5 | [0x0ABL-qualifier.md](edge/0x0ABL-qualifier.md) |  |
| `0x0B0L` | `0x00000B00` | WORLD | Edge | 5 | [0x0B0L-world.md](edge/0x0B0L-world.md) |  |
| `0x0B1L` | `0x00000B10` | TIMELINE | Edge | 5 | [0x0B1L-timeline.md](edge/0x0B1L-timeline.md) |  |
| `0x0B2L` | `0x00000B20` | SCENE | Edge | 5 | [0x0B2L-scene.md](edge/0x0B2L-scene.md) |  |
| `0x0B8L` | `0x00000B80` | PUBLICATION | Edge | 5 | [0x0B8L-publication.md](edge/0x0B8L-publication.md) |  |
| `0x0B9L` | `0x00000B90` | DEPRECATION | Edge | 5 | [0x0B9L-deprecation.md](edge/0x0B9L-deprecation.md) |  |
| `0x0BAL` | `0x00000BA0` | TOMBSTONE | Edge | 5 | [0x0BAL-tombstone.md](edge/0x0BAL-tombstone.md) |  |
| `0x0BBL` | `0x00000BB0` | DECLARE | Edge | 5 | [0x0BBL-declare.md](edge/0x0BBL-declare.md) |  |
| `0x0BCL` | `0x00000BC0` | FIELD | Edge | 5 | [0x0BCL-field.md](edge/0x0BCL-field.md) |  |
| `0x0BDL` | `0x00000BD0` | ENUM | Edge | 5 | [0x0BDL-enum.md](edge/0x0BDL-enum.md) |  |
| `0x0BEL` | `0x00000BE0` | CODEC | Edge | 5 | [0x0BEL-codec.md](edge/0x0BEL-codec.md) |  |
| `0x0C0L` | `0x00000C00` | SOURCE | Edge | 6 | [0x0C0L-source.md](edge/0x0C0L-source.md) |  |
| `0x0E1L` | `0x00000E10` | FUNCTION-DECLARE | Edge | 7 | [0x0E1L-function-declare.md](edge/0x0E1L-function-declare.md) |  |
| `0x0E2L` | `0x00000E20` | TYPE-DECLARE | Edge | 7 | [0x0E2L-type-declare.md](edge/0x0E2L-type-declare.md) |  |
| `0x0E8L` | `0x00000E80` | CONST | Edge | 7 | [0x0E8L-const.md](edge/0x0E8L-const.md) |  |
| `0x0E9L` | `0x00000E90` | UNARY | Edge | 7 | [0x0E9L-unary.md](edge/0x0E9L-unary.md) |  |
| `0x0EAL` | `0x00000EA0` | BINARY | Edge | 7 | [0x0EAL-binary.md](edge/0x0EAL-binary.md) |  |
| `0x0EBL` | `0x00000EB0` | CALL | Edge | 7 | [0x0EBL-call.md](edge/0x0EBL-call.md) |  |
| `0x0ECL` | `0x00000EC0` | MEMBER | Edge | 7 | [0x0ECL-member.md](edge/0x0ECL-member.md) |  |
| `0x0EDL` | `0x00000ED0` | INDEX | Edge | 7 | [0x0EDL-index.md](edge/0x0EDL-index.md) |  |
| `0x0EEL` | `0x00000EE0` | CONSTRUCT | Edge | 7 | [0x0EEL-construct.md](edge/0x0EEL-construct.md) |  |
| `0x0EFL` | `0x00000EF0` | CONDITIONAL | Edge | 7 | [0x0EFL-conditional.md](edge/0x0EFL-conditional.md) |  |
| `0x0F0L` | `0x00000F00` | BLOCK | Edge | 7 | [0x0F0L-block.md](edge/0x0F0L-block.md) |  |
| `0x0F1L` | `0x00000F10` | ASSIGN | Edge | 7 | [0x0F1L-assign.md](edge/0x0F1L-assign.md) |  |
| `0x0F2L` | `0x00000F20` | IF | Edge | 7 | [0x0F2L-if.md](edge/0x0F2L-if.md) |  |
| `0x0F3L` | `0x00000F30` | SWITCH | Edge | 7 | [0x0F3L-switch.md](edge/0x0F3L-switch.md) |  |
| `0x0F4L` | `0x00000F40` | WHILE | Edge | 7 | [0x0F4L-while.md](edge/0x0F4L-while.md) |  |
| `0x0F5L` | `0x00000F50` | FOREACH | Edge | 7 | [0x0F5L-foreach.md](edge/0x0F5L-foreach.md) |  |
| `0x0F6L` | `0x00000F60` | JUMP | Edge | 7 | [0x0F6L-jump.md](edge/0x0F6L-jump.md) |  |
| `0x0F7L` | `0x00000F70` | RETURN | Edge | 7 | [0x0F7L-return.md](edge/0x0F7L-return.md) |  |
| `0x0F8L` | `0x00000F80` | RAISE | Edge | 7 | [0x0F8L-raise.md](edge/0x0F8L-raise.md) |  |
| `0x0F9L` | `0x00000F90` | TRY | Edge | 7 | [0x0F9L-try.md](edge/0x0F9L-try.md) |  |
| `0x100L` | `0x00001000` | CASE-DECLARE | Edge | 8 | [0x100L-case-declare.md](toulmin/0x100L-case-declare.md) |  |
| `0x101L` | `0x00001010` | PREDICATE-DECLARE | Edge | 8 | [0x101L-predicate-declare.md](toulmin/0x101L-predicate-declare.md) |  |
| `0x102L` | `0x00001020` | SPEC-DECLARE | Edge | 8 | [0x102L-spec-declare.md](toulmin/0x102L-spec-declare.md) |  |
| `0x103L` | `0x00001030` | RULE-DECLARE | Edge | 8 | [0x103L-rule-declare.md](toulmin/0x103L-rule-declare.md) |  |
| `0x104L` | `0x00001040` | COUNTER-DECLARE | Edge | 8 | [0x104L-counter-declare.md](toulmin/0x104L-counter-declare.md) |  |
| `0x105L` | `0x00001050` | EXCEPT-DECLARE | Edge | 8 | [0x105L-except-declare.md](toulmin/0x105L-except-declare.md) |  |
| `0x108L` | `0x00001080` | ATTACKS | Edge | 8 | [0x108L-attacks.md](toulmin/0x108L-attacks.md) |  |
| `0x109L` | `0x00001090` | SUPERSEDES | Edge | 8 | [0x109L-supersedes.md](toulmin/0x109L-supersedes.md) |  |
| `0x10AL` | `0x000010A0` | SUPERSEDE-CHAIN | Edge | 8 | [0x10AL-supersede-chain.md](toulmin/0x10AL-supersede-chain.md) |  |
| `0x110L` | `0x00001100` | RUN | Edge | 8 | [0x110L-run.md](toulmin/0x110L-run.md) |  |
| `0x111L` | `0x00001110` | DO | Edge | 8 | [0x111L-do.md](toulmin/0x111L-do.md) |  |
| `0x112L` | `0x00001120` | DO-ONCE | Edge | 8 | [0x112L-do-once.md](toulmin/0x112L-do-once.md) |  |
| `0x113L` | `0x00001130` | UNDO | Edge | 8 | [0x113L-undo.md](toulmin/0x113L-undo.md) |  |
| `0x114L` | `0x00001140` | CHECKING | Edge | 8 | [0x114L-checking.md](toulmin/0x114L-checking.md) |  |
| `0x115L` | `0x00001150` | ENTRY | Edge | 8 | [0x115L-entry.md](toulmin/0x115L-entry.md) |  |
| `0x116L` | `0x00001160` | TRIGGER | Edge | 8 | [0x116L-trigger.md](toulmin/0x116L-trigger.md) |  |
| `0x118L` | `0x00001180` | VERDICT | Edge | 8 | [0x118L-verdict.md](toulmin/0x118L-verdict.md) |  |
| `0x119L` | `0x00001190` | EVIDENCE | Edge | 8 | [0x119L-evidence.md](toulmin/0x119L-evidence.md) |  |
| `0x120L` | `0x00001200` | SOURCE | Edge | 9 | [0x120L-source.md](toulmin/0x120L-source.md) |  |
| `0x121L` | `0x00001210` | TEXT | Edge | 9 | [0x121L-text.md](toulmin/0x121L-text.md) |  |
| `0x122L` | `0x00001220` | SECTION | Edge | 9 | [0x122L-section.md](toulmin/0x122L-section.md) |  |
| `0x123L` | `0x00001230` | CASE-BEGIN | Edge | 9 | [0x123L-case-begin.md](toulmin/0x123L-case-begin.md) |  |
| `0x124L` | `0x00001240` | CASE-END | Edge | 9 | [0x124L-case-end.md](toulmin/0x124L-case-end.md) |  |
| `0x125L` | `0x00001250` | PROSE | Edge | 9 | [0x125L-prose.md](toulmin/0x125L-prose.md) |  |
| `0x126L` | `0x00001260` | NAMESPACE | Edge | 9 | [0x126L-namespace.md](toulmin/0x126L-namespace.md) |  |
| `0x127L` | `0x00001270` | FUNC | Edge | 9 | [0x127L-func.md](toulmin/0x127L-func.md) |  |
| `0x128L` | `0x00001280` | FIELD | Edge | 9 | [0x128L-field.md](toulmin/0x128L-field.md) |  |
| `0x129L` | `0x00001290` | ALIAS | Edge | 9 | [0x129L-alias.md](toulmin/0x129L-alias.md) |  |
| `0x12AL` | `0x000012A0` | GROUP | Edge | 9 | [0x12AL-group.md](toulmin/0x12AL-group.md) |  |
| `0x12BL` | `0x000012B0` | REQUIRES | Edge | 9 | [0x12BL-requires.md](toulmin/0x12BL-requires.md) |  |
| `0x12CL` | `0x000012C0` | MEANS | Edge | 9 | [0x12CL-means.md](toulmin/0x12CL-means.md) |  |
| `0x12DL` | `0x000012D0` | HAS | Edge | 9 | [0x12DL-has.md](toulmin/0x12DL-has.md) |  |
| `0x12EL` | `0x000012E0` | RUNS | Edge | 9 | [0x12EL-runs.md](toulmin/0x12EL-runs.md) |  |
| `0x12FL` | `0x000012F0` | EVALUATES | Edge | 9 | [0x12FL-evaluates.md](toulmin/0x12FL-evaluates.md) |  |
| `0x130L` | `0x00001300` | TRIGGERS | Edge | 9 | [0x130L-triggers.md](toulmin/0x130L-triggers.md) |  |
| `0x131L` | `0x00001310` | UNTIL | Edge | 9 | [0x131L-until.md](toulmin/0x131L-until.md) |  |
| `0x132L` | `0x00001320` | SAME-AS | Edge | 9 | [0x132L-same-as.md](toulmin/0x132L-same-as.md) |  |
| `0x133L` | `0x00001330` | IMPORTED-FROM | Edge | 9 | [0x133L-imported-from.md](toulmin/0x133L-imported-from.md) |  |
| `0x134L` | `0x00001340` | LABEL | Edge | 9 | [0x134L-label.md](toulmin/0x134L-label.md) |  |
| `0x1BDL` | `0x00001BD0` | EDGE-ISSUER-2WORD | Edge | 13 | [0x1BDL-edge-issuer-2word.md](edge/0x1BDL-edge-issuer-2word.md) |  |
| `0x1BEL` | `0x00001BE0` | EDGE-ISSUER-4WORD | Edge | 13 | [0x1BEL-edge-issuer-4word.md](edge/0x1BEL-edge-issuer-4word.md) |  |
| `0x1BFL` | `0x00001BF0` | EDGE-ISSUER-16WORD | Edge | 13 | [0x1BFL-edge-issuer-16word.md](edge/0x1BFL-edge-issuer-16word.md) |  |
| `0x1C0L` | `0x00001C00` | DOC-1WORD | Meta | 14 | [0x1C0L-doc-1word.md](meta/0x1C0L-doc-1word.md) |  |
| `0x1C1L` | `0x00001C10` | DOC-2WORD | Meta | 14 | [0x1C1L-doc-2word.md](meta/0x1C1L-doc-2word.md) |  |
| `0x1C2L` | `0x00001C20` | DOC-4WORD | Meta | 14 | [0x1C2L-doc-4word.md](meta/0x1C2L-doc-4word.md) |  |
| `0x1C3L` | `0x00001C30` | BODY | Meta | 14 | [0x1C3L-body.md](meta/0x1C3L-body.md) |  |
| `0x1C4L` | `0x00001C40` | END | Meta | 14 | [0x1C4L-end.md](meta/0x1C4L-end.md) |  |
| `0x1C5L` | `0x00001C50` | SPEC-VERSION | Meta | 14 | [0x1C5L-spec-version.md](meta/0x1C5L-spec-version.md) |  |
| `0x1C6L` | `0x00001C60` | PROFILE | Meta | 14 | [0x1C6L-profile.md](meta/0x1C6L-profile.md) |  |
| `0x1C7L` | `0x00001C70` | DOC-ID | Meta | 14 | [0x1C7L-doc-id.md](meta/0x1C7L-doc-id.md) |  |
| `0x1C8L` | `0x00001C80` | EFFECTIVE-FROM | Meta | 14 | [0x1C8L-effective-from.md](meta/0x1C8L-effective-from.md) |  |
| `0x1C9L` | `0x00001C90` | EFFECTIVE-UNTIL | Meta | 14 | [0x1C9L-effective-until.md](meta/0x1C9L-effective-until.md) |  |
| `0x1CAL` | `0x00001CA0` | DEFAULT-LANGUAGE | Meta | 14 | [0x1CAL-default-language.md](meta/0x1CAL-default-language.md) |  |
| `0x1CBL` | `0x00001CB0` | AUTHOR | Meta | 14 | [0x1CBL-author.md](meta/0x1CBL-author.md) |  |
| `0x1CCL` | `0x00001CC0` | CO-AUTHOR | Meta | 14 | [0x1CCL-co-author.md](meta/0x1CCL-co-author.md) |  |
| `0x1CDL` | `0x00001CD0` | CREATED-AT | Meta | 14 | [0x1CDL-created-at.md](meta/0x1CDL-created-at.md) |  |
| `0x1CEL` | `0x00001CE0` | MODIFIED-AT | Meta | 14 | [0x1CEL-modified-at.md](meta/0x1CEL-modified-at.md) |  |
| `0x1CFL` | `0x00001CF0` | RECORDED-BY | Meta | 14 | [0x1CFL-recorded-by.md](meta/0x1CFL-recorded-by.md) |  |
| `0x1D0L` | `0x00001D00` | RECORDED-AT | Meta | 14 | [0x1D0L-recorded-at.md](meta/0x1D0L-recorded-at.md) |  |
| `0x1D1L` | `0x00001D10` | PARENT | Meta | 14 | [0x1D1L-parent.md](meta/0x1D1L-parent.md) |  |
| `0x1D2L` | `0x00001D20` | DERIVED-FROM | Meta | 14 | [0x1D2L-derived-from.md](meta/0x1D2L-derived-from.md) |  |
| `0x1D3L` | `0x00001D30` | GENERATED-BY | Meta | 14 | [0x1D3L-generated-by.md](meta/0x1D3L-generated-by.md) |  |
| `0x1D4L` | `0x00001D40` | TRANSFORMED-BY | Meta | 14 | [0x1D4L-transformed-by.md](meta/0x1D4L-transformed-by.md) |  |
| `0x1D5L` | `0x00001D50` | CHERRY-PICKED-FROM | Meta | 14 | [0x1D5L-cherry-picked-from.md](meta/0x1D5L-cherry-picked-from.md) |  |
| `0x1D6L` | `0x00001D60` | REVERTS | Meta | 14 | [0x1D6L-reverts.md](meta/0x1D6L-reverts.md) |  |
| `0x1D7L` | `0x00001D70` | REPLACES | Meta | 14 | [0x1D7L-replaces.md](meta/0x1D7L-replaces.md) |  |
| `0x1D8L` | `0x00001D80` | SQUASHED-FROM | Meta | 14 | [0x1D8L-squashed-from.md](meta/0x1D8L-squashed-from.md) |  |
| `0x1D9L` | `0x00001D90` | MESSAGE | Meta | 14 | [0x1D9L-message.md](meta/0x1D9L-message.md) |  |
| `0x1DAL` | `0x00001DA0` | TAG | Meta | 14 | [0x1DAL-tag.md](meta/0x1DAL-tag.md) |  |
| `0x1DBL` | `0x00001DB0` | DELTA-BASE | Meta | 14 | [0x1DBL-delta-base.md](meta/0x1DBL-delta-base.md) |  |
| `0x1DCL` | `0x00001DC0` | DELTA-REMOVE | Meta | 14 | [0x1DCL-delta-remove.md](meta/0x1DCL-delta-remove.md) |  |
| `0x1DDL` | `0x00001DD0` | NEXT-LOCAL-ID | Meta | 14 | [0x1DDL-next-local-id.md](meta/0x1DDL-next-local-id.md) |  |
| `0x1DEL` | `0x00001DE0` | LICENSE | Meta | 14 | [0x1DEL-license.md](meta/0x1DEL-license.md) |  |
| `0x1DFL` | `0x00001DF0` | ACCESS | Meta | 14 | [0x1DFL-access.md](meta/0x1DFL-access.md) |  |
| `0x1E0L` | `0x00001E00` | PRIVACY | Meta | 15 | [0x1E0L-privacy.md](meta/0x1E0L-privacy.md) |  |
| `0x1E1L` | `0x00001E10` | RETENTION | Meta | 15 | [0x1E1L-retention.md](meta/0x1E1L-retention.md) |  |
| `0x1E2L` | `0x00001E20` | CONSENT | Meta | 15 | [0x1E2L-consent.md](meta/0x1E2L-consent.md) |  |
| `0x1E3L` | `0x00001E30` | USAGE | Meta | 15 | [0x1E3L-usage.md](meta/0x1E3L-usage.md) |  |
| `0x1E4L` | `0x00001E40` | IMPORT-DOC | Meta | 15 | [0x1E4L-import-doc.md](meta/0x1E4L-import-doc.md) |  |
| `0x1E5L` | `0x00001E50` | ISSUER-KEY | Meta | 15 | [0x1E5L-issuer-key.md](meta/0x1E5L-issuer-key.md) |  |
| `0x1E6L` | `0x00001E60` | SIGNATURE | Meta | 15 | [0x1E6L-signature.md](meta/0x1E6L-signature.md) |  |
| `0x1E7L` | `0x00001E70` | SIGNED-OFF | Meta | 15 | [0x1E7L-signed-off.md](meta/0x1E7L-signed-off.md) |  |
| `0x1E8L` | `0x00001E80` | CONFIDENCE | Meta | 15 | [0x1E8L-confidence.md](meta/0x1E8L-confidence.md) |  |
| `0x1E9L` | `0x00001E90` | VERDICT | Meta | 15 | [0x1E9L-verdict.md](meta/0x1E9L-verdict.md) |  |
