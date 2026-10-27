---
title: "REFERENCE-NODE"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "REFERENCE-NODE -- направленный описательный Edge, который привязывает один Reference к одной записи Object и тем самым определяет, чем является этот Reference (Codec 0x00)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REFERENCE-NODE -- направленный описательный Edge, который связывает один Reference с одной записью Object и определяет или привязывает, чем является этот Reference. Codec `0x00`.

Subject указывает на Object. Эта привязка -- не [SAME-NODE](/ru/grammar/edge/same-node/), утверждающий смысловое тождество, и не означает, что байты двух записей совпадают.

## Раскладка

```
TAG WORD          0001 0LLL L000 0000
[TAG расширения Length]
Edge Id           запись LOCAL Reference
Subject           1 запись Reference
Object            1 запись Reference или Value
```

## Интерпретация и допустимость

- Subject должен быть ровно одной полной записью [Reference](/ru/grammar/reference/). Границу находят по Length самого Subject; если это не Reference или запись неполная, это invalid.
- Object должен быть ровно одной полной записью Reference или Value. Границу находят по Length самого Object; если это Edge, Meta или запись неполная, это invalid.
- Если Object -- Reference, цепочка Reference, по которой идут через привязки REFERENCE-NODE, не должна быть циклической, а LOCAL в конце концов должен разрешаться. Цикл разрешения и висячий LOCAL invalid.
- Если один LOCAL ID в одном документе привязан к конфликтующим Object, это invalid. Область LOCAL, ID, минимальная ширина и правила слияния определяются [LOCAL](/ru/grammar/reference/local/).
- Не каждый Reference обязан быть привязан через REFERENCE-NODE.
- Типичное применение -- `LOCAL → UTF8-LANGUAGE-TEXT`. Когда в Object [LABEL](/ru/grammar/edge/label/) стоит LOCAL, текст разрешается этой привязкой того же документа.

Направление, в котором Subject указывает на Object, нельзя интерпретировать наоборот. Смысл и подробные правила SAME и DIFFERENT каждый формат определяет отдельно.

## Длина

```
всего = 1 + N_len + N_id + N_subject + N_object WORD
```

`N_len` -- число WORD расширения TAG Length, `N_id` -- число WORD записи LOCAL для Edge Id, `N_subject` и `N_object` -- полное число WORD каждой записи. Позиция после чтения Subject и Object должна точно совпасть с концом Edge.

## Пример (ненормативный)

Edge Id `0008`, Subject -- LOCAL 1, Object -- [UTF8-LANGUAGE-TEXT](/ru/grammar/value/text/utf8-language-text/) для `Donald Trump` (en).

- Edge Id -- `0088 0008`, 2 WORD.
- Subject -- `0088 0001`, 2 WORD.
- Object -- язык `08C6 656e` (BCP47 `en`) + текст 12 байт (чётное), то есть `UTF8-LANGUAGE-TEXT-EVEN` (`0x4A`), всего 9 WORD. TAG -- `0C4A`.
- Edge -- TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, `LLLL=1101`. TAG -- `1680`.

```
1680 0088 0008 0088 0001 0C4A 08C6 656e 446f 6e61 6c64 2054 7275 6d70
```

## Связанные страницы

- [Edge](/ru/grammar/edge/), [SAME-NODE](/ru/grammar/edge/same-node/), [DIFFERENT-NODE](/ru/grammar/edge/different-node/), [LABEL](/ru/grammar/edge/label/)
- [Reference](/ru/grammar/reference/), [LOCAL](/ru/grammar/reference/local/), [UTF8-LANGUAGE-TEXT](/ru/grammar/value/text/utf8-language-text/)
