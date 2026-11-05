---
title: "EXCEPT-DECLARE (0x105L)"
weight: 261
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EXCEPT-DECLARE — NODE Codec, записывающий узел графа TOULMIN."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXCEPT-DECLARE — NODE Codec, записывающий узел графа TOULMIN. Значение: объявление исключения. Атакует без собственного вывода. Level по умолчанию — Review.

| Пункт | Значение |
|---|---|
| Имя | `EXCEPT-DECLARE` (BIND `EXCEPT-DECLARE` документа спецификации) |
| TAG ID | `0x105L` |
| Codec ID | `0x00001050` |
| Документ спецификации | `0x00000000/codecs/0x00001050/` (объект DECLARE `1050`) |
| Раздел | 8 `1000` (Edge TOULMIN), смещение внутри раздела C = 5 |
| Kind | Edge · семейство: TOULMIN, группа: объявление, раскладка: NODE |
| TAG WORD | `0001 0000 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Описание в индексе | объявление исключения. Атакует без собственного вывода. Level по умолчанию — Review |
| Сторона Hugo | `edge/toulmin/node.md` |

## Раскладка {#레이아웃}

Раскладка — [NODE](_index.md#node). Заголовок в 1 WORD задаёт role, level, форму Claim и условные поля.

| Пункт | Значение |
|---|---|
| TANGEUL | except rule |
| Узел | исключение (Defeater) |

- role должен быть 2 (except). Если level равен 0 (Unset), используется значение движка по умолчанию — Review.
- Общие поля (ID, REF, SPAN) и числовые правила следуют [TOULMIN](_index.md#공통-필드).

## Документ Codec {#코덱-문서}

Документ Codec содержит DECLARE (объект `1050`). Условные поля раскладки NODE и ширину SPAN, задаваемую SOURCE, нельзя объявить через FIELD, поэтому объявление полей остаётся открытой проблемой ([TOULMIN](_index.md#열린-문제)).

## Связанные страницы {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Исходный текст документа спецификации {#규격-문서-원문}

Так выглядит документ спецификации `0x00000000/codecs/0x00001050/latest.geul`, прочитанный через `geul show` (шестнадцатеричные значения в верхнем регистре).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000105000000000
BODY
#1 DECLARE 0x1050
#2 BIND #1 "EXCEPT-DECLARE"
```
