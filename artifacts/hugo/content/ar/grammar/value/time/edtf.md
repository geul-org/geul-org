---
title: "EDTF"
weight: 37
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "EDTF قيمة Value تحمل تاريخاً بسلسلة تاريخ ممتدة وفق ISO 8601-2 كدقة السنة والشهر وما قبل الميلاد وعدم اليقين والفترات (Codec 0x24/0x25)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDTF قيمة Value تحمل التاريخ بسلسلة [Extended Date/Time Format](https://www.loc.gov/standards/datetime/edtf.html) (مكتبة الكونغرس الأمريكية، ISO 8601-2:2019). تمثل دقة أخشن من اليوم، وما قبل الميلاد، وعدم اليقين والتقريب والمجهول جزئياً، والفترات.

## التخطيط

- الرمز: الرمز المباشر في Value هو `0x24` (عدد بايتات زوجي) و`0x25` (عدد بايتات فردي). العائلة TIME. Payload سلسلة نصية لكنها توضع في عائلة TIME ليتعامل معها المفكك والفهرس كقيمة زمنية دون معرفة الصيغة.
- يُحدد عدد البايتات بأقل بت في Codec وبعدد WORD في Payload: `2 × عدد WORD في Payload − أقل بت`، ولا يوجد Byte Count ([Value](/ar/grammar/value/)).

```
TAG WORD          0000 1LLL L010 010P      Codec 0x24/0x25 (P = عدد بايتات فردي)
[Length ممتد TAG] عندما يبلغ المجموع 15 WORD فأكثر
Payload WORD 1st ... Nth          بايتات ASCII لسلسلة EDTF / إن كان فردياً فآخرها 0x00
```

## التفسير والصلاحية

- سلسلة البايتات سلسلة ASCII وفق نحو EDTF من المستوى 0 و1 و2. السلسلة الفارغة invalid.
- أمثلة: يوم `1952-03-11`، وشهر `1952-03`، وسنة `1952`، وعقد `195X`، وسنة 44 قبل الميلاد `-0043`، وغير مؤكد `1974?`، وتقريبي `~1974`، وفترة `1952/2001`، وسنة كبيرة `Y-13799999999`.
- السنة بالنمط الفلكي في ISO 8601. `0000` هي سنة 1 قبل الميلاد و`-0043` هي سنة 44 قبل الميلاد. وعند النقل من الكتابة التاريخية تُنقل بفارق سنة.
- هو التقويم الميلادي. لا يتناول EDTF تقاويم أخرى. الكتابة الأصلية في تقويم آخر كاليولياني تُحفظ بـ [GEDCOM-DATE](/ar/grammar/value/time/gedcom-date/). أما القيمة المنقولة إلى التقويم الميلادي لليوم أو الفترة نفسها فيمكن كتابتها بـ EDTF أو GREGORIAN-DATE.
- **الصيغة القياسية:** التاريخ الذي يمكن كتابته بدقة بـ [GREGORIAN-DATE](/ar/grammar/value/time/gregorian-date/)، أي `[-]YYYY-MM-DD` بلا مؤهِّلات (`?` و`~` و`%`) ولا أرقام مجهولة (`X`) ولا فترة ولا بادئة `Y`، يُكتب بـ GREGORIAN-DATE. كتابة مثل هذا التاريخ بـ EDTF هي invalid. فاليوم نفسه يجب أن يُكتب بصيغة واحدة حتى يمكن فهرسته ومقارنته زمنياً.
- لا يفحص schema نحو EDTF بعد. يفحصه المنتِج بمحلل EDTF. مثلاً `parser.ParseString` في `github.com/sfomuseum/go-edtf` (BSD-3-Clause). ولا يُستخدم `parser.IsValid` لأنه ينظر في النحو فقط فيمرّر `2023-02-29` و`1974-13` أيضاً. وهذا المحلل لا يدعم بعد السنة ذات البادئة `Y`.

## الطول

- المجموع هو عدد WORD لـ: TAG (1 WORD)، وLength ممتد TAG (إن وجد)، وPayload ([Length](/ar/grammar/record/)).

## أمثلة

| التاريخ | البايتات | كل WORD |
|---|---|---|
| `1974` | 4 (زوجي) | `0924 3139 3734` |
| `197X` | 4 (زوجي) | `0924 3139 3758` |
| `1952-03` | 7 (فردي) | `0A25 3139 3532 2d30 3300` |

## السند المعياري

- [Library of Congress, Extended Date/Time Format (EDTF) Specification](https://www.loc.gov/standards/datetime/edtf.html). المستوى 0 مجموعة جزئية من ISO 8601-1، والمستويان 1 و2 من إمكانات ISO 8601-2.
- في RDF تُعرض السلسلة نفسها بنوع البيانات `http://id.loc.gov/datatypes/edtf`.

## مسائل مفتوحة

- فحص المدقق لنحو EDTF (هل يعتمد المدقق على مكتبة خارجية).
- قاعدة نقل دقة القرن والألفية في ويكي بيانات إلى أرقام EDTF المجهولة.

## صفحات ذات صلة

- [Value](/ar/grammar/value/)، [GREGORIAN-DATE](/ar/grammar/value/time/gregorian-date/)، [GEDCOM-DATE](/ar/grammar/value/time/gedcom-date/)
