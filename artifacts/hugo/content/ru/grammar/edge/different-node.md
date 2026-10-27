---
title: "DIFFERENT-NODE"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DIFFERENT-NODE -- описательный Edge нетождества: два Reference указывают на разные объекты (Codec 0x02)."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DIFFERENT-NODE -- описательный Edge нетождества: два Reference указывают на разные referent. Codec `0x02`.

Это не значит, что byte-кодирование, Codec или ID двух записей Reference различаются. Его нужно отличать от направленной привязки [REFERENCE-NODE](/ru/grammar/edge/reference-node/) и от тождества [SAME-NODE](/ru/grammar/edge/same-node/).

## Раскладка

```
TAG WORD          0001 0LLL L000 0010
[TAG расширения Length]
Edge Id           запись LOCAL Reference
Subject           1 запись Reference
Object            1 запись Reference
```

## Интерпретация и допустимость

- Subject и Object должны быть каждый ровно одной полной записью [Reference](/ru/grammar/reference/). Границу находят по Length каждой записи; если это Value или Edge, либо запись неполная, это invalid.
- Subject и Object указывают на разные referent. Различие referent не выводят только из различия в последовательности байтов, Codec или ID записей Reference.
- В частности, разные [LOCAL](/ru/grammar/reference/local/) ID -- это лишь разные Reference, а не признак того, что различаются и referent в реальности. Из различия LOCAL ID DIFFERENT не выводят.
- Нетождество симметрично, антирефлексивно и не транзитивно. `DIFFERENT(A, B)` -- то же отношение, что и `DIFFERENT(B, A)`. Но из `DIFFERENT(A, B)` и `DIFFERENT(B, C)` не выводят `DIFFERENT(A, C)`.
- Порядок Subject/Object в wire -- лишь порядок сериализации для framing и не создаёт направления смысла. Реализация должна уметь обходить отношение в обе стороны.
- Позиция после чтения обоих компонентов должна точно совпасть с концом Edge.

Само отношение антирефлексивно, но структурно valid утверждение `DIFFERENT(A, A)` или утверждение, в котором SAME и DIFFERENT сталкиваются, нельзя удалять как ошибку грамматики wire. Такие утверждения сохраняют контекст и родословную и рассматриваются как противоречие на уровне вердикта. При интерпретации или выводе DIFFERENT сохраняют источник, момент, world и policy scope документа, содержащего этот Edge, и не расширяют результат до глобального вывода без их учёта.

## Длина

```
всего = 1 + N_len + N_id + N_subject + N_object WORD
```

## Пример (ненормативный)

Edge Id `000a`, Subject -- LOCAL 1, Object -- LOCAL 2.

- Edge -- TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD, `LLLL=0110`. TAG -- `0001 0 0110 0000010` = `1302`.

```
1302 0088 000a 0088 0001 0088 0002
```

Различие LOCAL ID в этом примере нужно лишь для демонстрации кодирования. Эту последовательность превращают в DIFFERENT-NODE только тогда, когда есть отдельное утверждение, что ID 1 и ID 2 указывают на разные referent.

## Связанные страницы

- [Edge](/ru/grammar/edge/), [REFERENCE-NODE](/ru/grammar/edge/reference-node/), [SAME-NODE](/ru/grammar/edge/same-node/)
- [Reference](/ru/grammar/reference/), [LOCAL](/ru/grammar/reference/local/)
