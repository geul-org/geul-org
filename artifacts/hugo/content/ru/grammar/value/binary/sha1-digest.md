---
title: "SHA1-DIGEST"
weight: 99
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA1-DIGEST — Value фиксированной длины 11 WORD, хранящий все 160 bit результата SHA-1; используется только для идентификации, например ID объектов git."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA1-DIGEST — это Value фиксированной ширины, хранящий результат SHA-1 целиком. Прямой код Value `0x62`, семейство BINARY. Payload — ровно 10 WORD (160 bit); усечение (truncation) не допускается.

**Используется только для идентификации.** Устойчивость SHA-1 к коллизиям нарушена (2017, SHAttered). В качестве основания для целостности и подписи используйте [SHA-256-DIGEST](/ru/grammar/value/binary/sha-256-digest/). Этот формат введён, чтобы хранить как есть идентификаторы, уже определённые через SHA-1, прежде всего ID объектов (ID коммитов) репозиториев git на SHA-1. Например, Version (ID коммита) в [TRANSFORMED-BY](/ru/grammar/meta/lineage/transformed-by/) хранится в 11 WORD вместо hex-текста (22 WORD).

## Раскладка

```
TAG WORD          0x0D62 (0000 1101 0110 0010)  LLLL=1010
Payload           10 WORD  SHA-1 Digest
```

## Интерпретация и допустимость

- 20 octet Payload читаются в порядке вывода SHA-1. В каждом WORD сначала идёт старший octet (тот же framing, что и в SHA-256-DIGEST).
- Представление, где Payload не равен 10 WORD или результат произвольно обрезан (сокращённый ID git и т. п.), отклоняется. descriptor и padding нет.
- ID объекта git — это значение, вычисленное самим git, как есть. SHA-1 в git — вариант с обнаружением коллизий (SHA-1DC), но на входах, не являющихся коллизионной атакой, результат совпадает с SHA-1.

## Основание в стандартах

- Алгоритм SHA-1 и 160-битный результат следуют NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- GEUL TAG и framing 16-битными WORD — правила, которые добавляет этот формат.

## Длина

- Всего ровно 11 WORD: 1 WORD TAG и 10 WORD Payload; используется `LLLL=1010`. Length-расширения нет.

## Примеры

Коммит git `ddc0719974a32aaa7b422ee84221a9721085ce4c`:

```
0D62 ddc0 7199 74a3 2aaa 7b42 2ee8 4221 a972 1085 ce4c
```

## Связанные страницы

- [Value](/ru/grammar/value/), [SHA-256-DIGEST](/ru/grammar/value/binary/sha-256-digest/), [TRANSFORMED-BY](/ru/grammar/meta/lineage/transformed-by/)
