---
title: "GEDCOM-DATE"
weight: 39
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GEDCOM-DATE قيمة Value تحمل سلسلة قيمة تاريخ GEDCOM 7 فتحفظ تواريخ التقاويم الأخرى كاليولياني كما كُتبت (Codec 0x26/0x27)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEDCOM-DATE قيمة Value تحمل سلسلة قيمة التاريخ (`DateValue`) في [GEDCOM 7](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html) (FamilySearch). تحفظ **كما كُتب** التاريخ الذي كتبه الأصل بتقويم غير الميلادي (اليولياني وغيره).

## التخطيط

- الرمز: الرمز المباشر في Value هو `0x26` (عدد بايتات زوجي) و`0x27` (عدد بايتات فردي). العائلة TIME.
- يُحدد عدد البايتات بأقل بت في Codec وبعدد WORD في Payload: `2 × عدد WORD في Payload − أقل بت`، ولا يوجد Byte Count ([Value](/ar/grammar/value/)).

```
TAG WORD          0000 1LLL L010 011P      Codec 0x26/0x27 (P = عدد بايتات فردي)
[Length ممتد TAG] عندما يبلغ المجموع 15 WORD فأكثر
Payload WORD 1st ... Nth          بايتات ASCII لسلسلة تاريخ GEDCOM / إن كان فردياً فآخرها 0x00
```

## التفسير والصلاحية

- سلسلة البايتات سلسلة ASCII وفق نحو `DateValue` في GEDCOM 7. السلسلة الفارغة invalid. يسمح GEDCOM بـ `DateValue` فارغ، لكن إذا لم تكن هناك قيمة فلا يُكتب السجل.
- خلاصة النحو: `[التقويم] [[اليوم] الشهر] السنة [BCE]`. وتسبقها `ABT` و`CAL` و`EST` (تقريب) أو `BEF` و`AFT` و`BET … AND …` (مدى) أو `FROM … TO …` (مدة). الفاصل مسافة واحدة.
- التقويم: `GREGORIAN` (الافتراضي إن حُذف) و`JULIAN` و`FRENCH_R` و`HEBREW` ووسوم التوسعة. أسماء الأشهر محددة لكل تقويم (التقويم اليولياني `JAN`…`DEC` نفسها في التقويم الميلادي).
- السنة بالنمط **التاريخي**. لا توجد سنة 0، وما قبل الميلاد يُلحق به `BCE` (`44 BCE` = سنة 44 قبل الميلاد). فهو يختلف بسنة واحدة عن النمط الفلكي في EDTF وGREGORIAN-DATE.
- لا يفحص schema إلا صيغة البايتات: ASCII `0x20`~`0x7E`، وألا تكون فارغة، وألا تكون فيها مسافة في البداية أو النهاية. أما النحو وهل اليوم موجود فعلاً فيفحصه المنتِج. مثلاً `gedcom.ParseDate` في `github.com/cacack/gedcom-go/v3` (MIT). `Validate` في هذه المكتبة تفحص اليوم في التقويم الميلادي فقط فتمرّر `JULIAN 30 FEB 1100`، و`ToGregorian` لا تحوّل فعلياً دقة السنة والشهر. فيُجرى فحص وجود التاريخ وتطبيعه على حدة.
- **موضع الاستخدام:** تُكتب التواريخ الميلادية بـ [GREGORIAN-DATE](/ar/grammar/value/time/gregorian-date/) أو [EDTF](/ar/grammar/value/time/edtf/). ويُستخدم GEDCOM-DATE لتواريخ التقاويم الأخرى التي يجب حفظ كتابتها الأصلية.

## الاستخدام مع القيمة المطبَّعة

- لمقارنة التاريخ نفسه وفهرسته على المحور الزمني تلزم قيمة ميلادية. دقة اليوم تقابلها بدقة GREGORIAN-DATE لليوم نفسه، ودقة السنة والشهر تقابلها بدقة EDTF لفترة ميلادية تشمل تلك المدة (`JULIAN 1300` → `1300-01-09/1301-01-08`).
- لم تتحدد بعد طريقة حمل الكتابة الأصلية (GEDCOM-DATE) والقيمة المطبَّعة معاً في قيمتين Value (مسألة مفتوحة).

## الطول

- المجموع هو عدد WORD لـ: TAG (1 WORD)، وLength ممتد TAG (إن وجد)، وPayload ([Length](/ar/grammar/record/)).

## أمثلة

| التاريخ | البايتات | كل WORD |
|---|---|---|
| `JULIAN 1300` | 11 (فردي) | `0B27 4a55 4c49 414e 2031 3330 3000` |

## السند المعياري

- [FamilySearch GEDCOM 7, Data types — Date](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#date) و[Appendix A: Calendars and Dates](https://gedcom.io/specifications/FamilySearchGEDCOMv7.html#A-calendars). ترخيص مستودع المواصفة هو Apache 2.0. يشير GEUL إلى الصيغة فقط ولا ينقل نص المواصفة.
- لا يوجد التقويم اليولياني في ISO 8601 وEDTF وXSD ومعرّفات تقويم CLDR (`u-ca`). أما GEDCOM 7 فهو صيغة تبادل عامة تتناول بادئة التقويم وما قبل الميلاد والدقة والمؤهِّلات في نحو واحد.

## مسائل مفتوحة

- طريقة كتابة الكتابة الأصلية والقيمة المطبَّعة معاً (كيفية ربط الاثنتين في TRIPLE واحدة).
- فحص schema لنحو GEDCOM.
- دقة القرن والعقد. لا توجد في GEDCOM صيغة لذلك. التواريخ التي لا يمكن نقلها من ويكي بيانات يُترك نصها الأصلي كـ UTF8-TEXT.

## صفحات ذات صلة

- [Value](/ar/grammar/value/)، [EDTF](/ar/grammar/value/time/edtf/)، [GREGORIAN-DATE](/ar/grammar/value/time/gregorian-date/)
