---
title: "VERDICT (0x118L)"
weight: 280
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "VERDICT هو Codec من نوع Edge في TOULMIN."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERDICT هو Codec من نوع Edge في TOULMIN. المعنى: نتيجة الحكم لعقدة أو سجل. النتيجة (Pass وReview وFail) وقيمة الحكم وActivated وExcluded وLevel.

| البند | القيمة |
|---|---|
| الاسم | `VERDICT` (مستند المواصفة BIND `VERDICT`) |
| TAG ID | `0x118L` |
| Codec ID | `0x00001180` |
| مستند المواصفة | `0x00000000/codecs/0x00001180/` (هدف DECLARE هو `1180`) |
| القسم | 8 `1000` (Edge TOULMIN)، الإزاحة داخل القسم C = 24 |
| Kind | Edge · العائلة: TOULMIN، الحزمة: النتيجة |
| TAG WORD | `0001 0001 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | نتيجة الحكم لعقدة أو سجل. النتيجة (Pass وReview وFail) وقيمة الحكم وActivated وExcluded وLevel. التخطيط غير محدد |
| جهة Hugo | `edge/toulmin/_index.md` |

## التخطيط {#레이아웃}

لم يُخصَّص سوى الرمز، ولا يوجد تخطيط بعد ([TOULMIN](_index.md#열린-문제)).

- الحكم على المستند كله من اختصاص Meta [VERDICT](../meta/0x1E9L-verdict.md) (`0x1E9L`). وهما Codec منفصلان من Kind مختلف.
- تُوضع نتيجة الحكم في مستند غير مستند الهدف المحكوم عليه ([TOULMIN](_index.md#판정-결과)).

## مستند Codec {#코덱-문서}

لم يتحدد التخطيط. يتضمن مستند Codec عنصر DECLARE فقط (الهدف `1180`). تُضاف FIELD بعد تحديد التخطيط.

## صفحات ذات صلة {#관련-페이지}

- [TOULMIN](_index.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يعرضه `geul show` عند قراءة مستند المواصفة `0x00000000/codecs/0x00001180/latest.geul` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000118000000000
BODY
#1 DECLARE 0x1180
#2 BIND #1 "VERDICT"
```
