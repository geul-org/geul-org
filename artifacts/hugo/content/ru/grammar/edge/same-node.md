---
title: "SAME-NODE"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SAME-NODE -- ненаправленный описательный Edge тождества, объявляющий, что два Reference указывают на один и тот же объект (Codec 0x01)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SAME-NODE -- ненаправленный описательный Edge тождества, объявляющий, что два Reference указывают на один и тот же referent. Codec `0x01`.

Это не значит, что byte-кодирование, Codec или ID двух записей Reference совпадают. В отличие от [REFERENCE-NODE](/ru/grammar/edge/reference-node/), направленной привязки `Reference → запись`, SAME-NODE выражает тождество (referential identity) между двумя Reference.

## Раскладка

```
TAG WORD          0001 0LLL L000 0001
[TAG расширения Length]
Edge Id           запись LOCAL Reference
Subject           1 запись Reference
Object            1 запись Reference
```

## Интерпретация и допустимость

- Subject и Object сериализуются в этом порядке и должны быть каждый ровно одной полной записью [Reference](/ru/grammar/reference/). Границу находят по Length каждой записи.
- Если Subject или Object -- Value, Edge или неполная запись, это invalid.
- Отношение SAME-NODE рефлексивно, симметрично и транзитивно. Порядок Subject/Object в wire существует для framing и не создаёт направления смысла. Реализация должна уметь обходить это отношение в обе стороны.
- Разные [LOCAL](/ru/grammar/reference/local/) ID -- лишь разные Reference, а не свидетельство того, что referent одинаковы или различны. То, что два Reference указывают на один referent, выражается через SAME-NODE.
- Интерпретация и вывод должны сохранять источник, момент, world и policy scope документа, содержащего этот Edge, и графа вердиктов. SAME-NODE не используют как основание для глобального слияния вне контекста.
- Даже при наличии SAME-NODE исходные записи Reference и родословную не стирают и не перезаписывают.
- Если для одной пары есть и SAME-NODE, и [DIFFERENT-NODE](/ru/grammar/edge/different-node/), wire не становится invalid. Контекст каждого утверждения сохраняют, а конфликт оценивают.
- Variable Reference связывают с Identified Reference через SAME-NODE и тем самым разрешают переменную ([Reference](/ru/grammar/reference/), Variable).

## Длина

```
всего = 1 + N_len + N_id + N_subject + N_object WORD
```

## Пример (ненормативный)

Edge Id `0009`, Subject -- LOCAL 1, Object -- LOCAL 2.

- Edge -- TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD, `LLLL=0110`. TAG -- `0001 0 0110 0000001` = `1301`.

```
1301 0088 0009 0088 0001 0088 0002
```

## Связанные страницы

- [Edge](/ru/grammar/edge/), [REFERENCE-NODE](/ru/grammar/edge/reference-node/), [DIFFERENT-NODE](/ru/grammar/edge/different-node/)
- [Reference](/ru/grammar/reference/), [LOCAL](/ru/grammar/reference/local/)
