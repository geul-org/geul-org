---
title: "ENTRY (0x115L)"
weight: 277
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "ENTRY هو Codec من نوع NODE يكتب عقدة في رسم TOULMIN."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ENTRY هو Codec من نوع NODE يكتب عقدة في رسم TOULMIN. المعنى: نقطة دخول خارجية. تُنفِّذ قضية أو تحكم فيها.

| البند | القيمة |
|---|---|
| الاسم | `ENTRY` (مستند المواصفة BIND `ENTRY`) |
| TAG ID | `0x115L` |
| Codec ID | `0x00001150` |
| مستند المواصفة | `0x00000000/codecs/0x00001150/` (هدف DECLARE هو `1150`) |
| القسم | 8 `1000` (Edge TOULMIN)، الإزاحة داخل القسم C = 21 |
| Kind | Edge · العائلة: TOULMIN، الحزمة: التنفيذ، التخطيط: NODE |
| TAG WORD | `0001 0001 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | نقطة دخول خارجية. تُنفِّذ قضية أو تحكم فيها |
| جهة Hugo | `edge/toulmin/node.md` |

## التخطيط {#레이아웃}

التخطيط هو [NODE](_index.md#node). تحدد ترويسة من 1 WORD قيمة role وlevel وشكل Claim والحقول الشرطية.

| البند | القيمة |
|---|---|
| TANGEUL | provides x |
| العقدة | نقطة دخول خارجية |

- يجب أن يكون role بالقيمة 0.
- تتبع الحقول المشتركة (ID وREF وSPAN) وقواعد الأعداد ما في [TOULMIN](_index.md#공통-필드).

## مستند Codec {#코덱-문서}

يتضمن مستند Codec عنصر DECLARE (الهدف `1150`). لا يمكن إعلان الحقول الشرطية في تخطيط NODE وعرض SPAN الذي يحدده SOURCE بواسطة FIELD، لذا فإعلان الحقول مسألة مفتوحة ([TOULMIN](_index.md#열린-문제)).

## صفحات ذات صلة {#관련-페이지}

- [NODE](_index.md#node)، [TOULMIN](_index.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يعرضه `geul show` عند قراءة مستند المواصفة `0x00000000/codecs/0x00001150/latest.geul` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000115000000000
BODY
#1 DECLARE 0x1150
#2 BIND #1 "ENTRY"
```
