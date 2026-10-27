---
title: "BIND"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "BIND -- описательный Edge, который привязывает к Subject имя, по которому его находит машина (UTF8-TEXT без языка) (Codec 0x03)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIND -- описательный Edge, который привязывает к Subject имя, по которому его находит машина. Codec `0x03`.

Это именование. Имя, которое читает человек (заголовок на конкретном языке), ведёт [LABEL](/ru/grammar/edge/label/). Имя символа программы и имя адреса документа записываются одной и той же записью.

## Раскладка

```
TAG WORD          0001 0LLL L000 0011
[TAG расширения Length]
Edge Id           запись LOCAL Reference
Subject           1 запись Reference или 1 WORD TAG WORD кодека
Имя               1 Value UTF8-TEXT-*
```

## Интерпретация и допустимость

- Subject -- ровно одна полная запись [Reference](/ru/grammar/reference/). Если это LOCAL, то объект этого документа (символ и т. п.), если указывающий Reference -- объект другого документа. Сам документ -- [DOC-POINTER](/ru/grammar/reference/doc-pointer/), сам Issuer -- [ISSUER-POINTER](/ru/grammar/reference/issuer-pointer/).
- Либо Subject -- один TAG WORD кодека (только Kind и Codec, `LLLL = 0`, без Payload). Это не запись с пустым Payload, а указание на сам этот прямой код, то есть на его документ спецификации (документ GEUL Issuer `0x000000000000<TAG>`) ([документ спецификации Codec](/ru/grammar/codec-spec/), [DECLARE](/ru/grammar/edge/declare/)). Пример: `1018` -- PUBLICATION. В индексе имён используют Subject DOC-POINTER. Кодеки формата Issuer не используют.
- Другие записи (Value и т. п.) Subject быть не могут. FIELD в документе спецификации BIND объявляет Subject только с шириной `0` (запись), так что это ограничение -- правило тела BIND.
- Имя -- ровно один Value [UTF8-TEXT](/ru/grammar/value/text/utf8-text/). Языка нет, нормализации нет. Имена совпадают только при совпадении байтов.
- Область имени -- документ, содержащий BIND. В одном документе одно и то же имя не привязывают к разным Subject.
- К одному Subject можно привязать несколько имён (псевдоним, прежнее имя). Если документ не определяет иначе, основное имя -- последний BIND.
- Другие записи указывают на объект не по имени, а по LOCAL ID. Имя служит для сопоставления с внешним миром (функции хоста, ввод адреса, человек).
- Допустимые в имени символы определяет назначение. Имя для адреса документа следует правилу имён документов (slug из строчных ASCII) ([адрес публикации и список версий](/ru/grammar/publishing/#имя-документа)).

## Длина

```
всего = 1 + N_len + N_id + N_subject + N_name WORD
```

## Пример (ненормативный)

Символ программы: Edge Id `0003`, Subject LOCAL 7, имя `main`.

- Имя `main` -- 4 байта (чётное), то есть `0940 6d61 696e`, 3 WORD.
- Edge -- TAG 1 + Edge Id 2 + Subject 2 + имя 3 = 8 WORD, TAG `1383`.

```
1383 0088 0003 0088 0007 0940 6d61 696e
```

Имя документа (внутри документа списка версий этого документа `0x0000/0xffff000000000002/versions.geul`): Edge Id `0005`, Subject `DOC-POINTER` (Issuer `0x0000`, документ `0xffff000000000002`, версия `0` = сам документ), имя `this-is-sample-doc`.

- Subject -- TAG `03B8` + Issuer 1 + ID документа 4 + ID версии 2 = 8 WORD.
- Имя -- 18 байт (чётное), то есть TAG `0CC0` + 9 WORD = 10 WORD.
- Edge -- TAG 1 + расширение Length 1 + Edge Id 2 + Subject 8 + имя 10 = 22 WORD, поэтому `LLLL=1110`, TAG `1703`, расширение `0016`.

```
1703 0016 0088 0005 03B8 0000 ffff 0000 0000 0002 0000 0000 0CC0 7468 6973 2d69 732d 7361 6d70 6c65 2d64 6f63
```

## Связанные страницы

- [Edge](/ru/grammar/edge/), [LABEL](/ru/grammar/edge/label/), [PUBLICATION](/ru/grammar/edge/publication/) (имя документа в документе списка версий)
- [LOCAL](/ru/grammar/reference/local/), [DOC-POINTER](/ru/grammar/reference/doc-pointer/), [ISSUER-POINTER](/ru/grammar/reference/issuer-pointer/)
