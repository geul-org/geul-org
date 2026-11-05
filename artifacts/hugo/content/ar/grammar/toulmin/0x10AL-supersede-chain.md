---
title: "SUPERSEDE-CHAIN (0x10AL)"
weight: 266
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SUPERSEDE-CHAIN هو Codec من نوع Edge في TOULMIN."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SUPERSEDE-CHAIN هو Codec من نوع Edge في TOULMIN. المعنى: سلسلة أولوية `A > B > C`. اختصار لـ SUPERSEDES الزوجية.

| البند | القيمة |
|---|---|
| الاسم | `SUPERSEDE-CHAIN` (مستند المواصفة BIND `SUPERSEDE-CHAIN`) |
| TAG ID | `0x10AL` |
| Codec ID | `0x000010A0` |
| مستند المواصفة | `0x00000000/codecs/0x000010A0/` (هدف DECLARE هو `10A0`) |
| القسم | 8 `1000` (Edge TOULMIN)، الإزاحة داخل القسم C = 10 |
| Kind | Edge · العائلة: TOULMIN، الحزمة: العلاقة |
| TAG WORD | `0001 0000 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | سلسلة أولوية `A > B > C`. اختصار لـ SUPERSEDES الزوجية. التخطيط غير محدد |
| جهة Hugo | `edge/toulmin/_index.md` |

## التخطيط {#레이아웃}

لم يُخصَّص سوى الرمز، ولا يوجد تخطيط بعد ([TOULMIN](_index.md#열린-문제)).

- تُكتب الآن [SUPERSEDES](0x109L-supersedes.md) واحدةً لكل زوج. وهل يكفي ذلك للسلسلة مسألة مفتوحة.

## مستند Codec {#코덱-문서}

لم يتحدد التخطيط. يتضمن مستند Codec عنصر DECLARE فقط (الهدف `10A0`). تُضاف FIELD بعد تحديد التخطيط.

## صفحات ذات صلة {#관련-페이지}

- [TOULMIN](_index.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يعرضه `geul show` عند قراءة مستند المواصفة `0x00000000/codecs/0x000010A0/latest.geul` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000010A000000000
BODY
#1 DECLARE 0x10A0
#2 BIND #1 "SUPERSEDE-CHAIN"
```
