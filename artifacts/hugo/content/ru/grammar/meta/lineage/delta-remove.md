---
title: "DELTA-REMOVE"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DELTA-REMOVE — это Meta родословной, которая в diff перечисляет LOCAL ID (Edge Id), исключаемые из BODY базового снимка."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

В diff ([DELTA-BASE](/ru/grammar/meta/lineage/delta-base/)) указывает LOCAL ID (Edge Id) записей, которые нужно исключить из BODY базового снимка («статья X отменена»).

## Раскладка

```
TAG WORD          0001 1LLL L011 1011      Codec 0x3B
[Length extension TAG]
LOCAL ID для удаления   записи Reference LOCAL × 1 и более
```

- Codec: Meta `0x3B`, класс родословной (`011`)
- Payload: одна или несколько записей Reference [LOCAL](/ru/grammar/reference/local/)
- Количество: не более одного

## Интерпретация и валидность

- Указывается только в документах с `DELTA-BASE`.
- Каждый LOCAL ID должен быть Edge Id, имеющимся в BODY базового снимка. Если его нет, это invalid. Двукратное указание одного и того же ID — invalid.
- Повторное указание того же Edge Id в BODY того же diff — invalid (удаление и правку одновременно выполнить нельзя).
- Удалённый LOCAL ID в последующих версиях не назначается другому объекту заново ([Редакции](/ru/grammar/document/#редакции)).
- Отсутствие записи в BODY diff означает «не изменялось». Поэтому удаление выражается только этой Meta.
- HEAD Edge ([SOURCE](/ru/grammar/edge/source/#источник-всего-документа) всего документа и его QUALIFIER) не указываются. HEAD целиком заменяется на HEAD diff ([Хранение diff](/ru/grammar/document/#хранение-diff)).

## Пример

Удаление LOCAL `#7` и `#12`:

```
1A3B 0088 0007 0088 000C
```

- TAG `1A3B` (Meta `0x3B`, `LLLL=0100`, 5 WORD), Reference LOCAL `0088 0007`, `0088 000C`.
