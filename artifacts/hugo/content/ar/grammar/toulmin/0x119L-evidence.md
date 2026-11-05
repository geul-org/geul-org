---
title: "EVIDENCE (0x119L)"
weight: 281
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EVIDENCE هو Codec من نوع Edge في TOULMIN."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EVIDENCE هو Codec من نوع Edge في TOULMIN. المعنى: دليل الحكم. الموضع والقيمة المتوقعة والقيمة الفعلية (Fact).

| البند | القيمة |
|---|---|
| الاسم | `EVIDENCE` (مستند المواصفة BIND `EVIDENCE`) |
| TAG ID | `0x119L` |
| Codec ID | `0x00001190` |
| مستند المواصفة | `0x00000000/codecs/0x00001190/` (هدف DECLARE هو `1190`) |
| القسم | 8 `1000` (Edge TOULMIN)، الإزاحة داخل القسم C = 25 |
| Kind | Edge · العائلة: TOULMIN، الحزمة: النتيجة |
| TAG WORD | `0001 0001 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | دليل الحكم. الموضع والقيمة المتوقعة والقيمة الفعلية (Fact). التخطيط غير محدد |
| جهة Hugo | `edge/toulmin/_index.md` |

## التخطيط {#레이아웃}

لم يُخصَّص سوى الرمز، ولا يوجد تخطيط بعد ([TOULMIN](_index.md#열린-문제)).

- تُوضع نتيجة الحكم في مستند غير مستند الهدف المحكوم عليه ([TOULMIN](_index.md#판정-결과)).

## مستند Codec {#코덱-문서}

لم يتحدد التخطيط. يتضمن مستند Codec عنصر DECLARE فقط (الهدف `1190`). تُضاف FIELD بعد تحديد التخطيط.

## صفحات ذات صلة {#관련-페이지}

- [TOULMIN](_index.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يعرضه `geul show` عند قراءة مستند المواصفة `0x00000000/codecs/0x00001190/latest.geul` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000119000000000
BODY
#1 DECLARE 0x1190
#2 BIND #1 "EVIDENCE"
```
