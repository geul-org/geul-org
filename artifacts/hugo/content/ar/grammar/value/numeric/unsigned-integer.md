---
title: "UNSIGNED-INTEGER"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "UNSIGNED-INTEGER قيمة Value تحمل عدداً صحيحاً بلا إشارة كمقدار big-endian بأقل عدد من WORD."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNSIGNED-INTEGER قيمة Value تمثل عدداً صحيحاً بلا إشارة. الرمز المباشر في Value هو `0x02` والعائلة NUMERIC. يُقرأ Payload كله كمقدار (magnitude) بلا إشارة بدقة اعتباطية بترتيب WORD وفق big-endian. Payload لا يقل عن 1 WORD ولا يُسمح إلا بالتمثيل القياسي بأقل عدد من WORD.

## التخطيط

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x02
[Length ممتد TAG] عندما يبلغ المجموع 15 WORD فأكثر
Payload WORD 1st  (أعلى WORD)   Unsigned Magnitude 1st
...
Payload WORD Nth  (أدنى WORD)   Unsigned Magnitude Nth
```

## التفسير

- أول WORD في Payload هي الخانة الأعلى وآخر WORD هي الخانة الأدنى.
- إذا كان Payload من N WORD فيُقرأ كمقدار واحد بلا إشارة بعرض `16N` bit.
- هذا العرض ليس عرض تخزين معلناً، ولا يوجد bit width descriptor.

## التمثيل القياسي

- الصفر هو Payload من 1 WORD وهي `0000`.
- عندما يكون Payload من 2 WORD فأكثر وأول WORD هي `0000` يكون التمثيل غير قياسي لأن حذفها لا يغيّر القيمة.
- يجب على المفكك أن يرفض التمثيل الذي فيه WORD أصفار بادئة غير لازمة.

## الطول

- المجموع هو عدد WORD لـ: TAG (1 WORD)، وLength ممتد TAG (إن وجد)، وPayload. الطول 14 WORD فأقل طول مباشر، و15 WORD فأكثر يستخدم الطول الممتد `1110`·`1111`، ويُحسب الـ TAG الممتد ضمن المجموع ([السجل وTAG WORD](/ar/grammar/record/)).
- لا يُحفظ العرض المعلن مثل UINT8 وUINT16 وUINT32، بل القيمة العددية فقط.

## أمثلة

| القيمة | WORD الـ Payload | الحكم |
|---:|---|---|
| 0 | `0000` | قياسي |
| 1 | `0001` | قياسي |
| 65535 | `ffff` | قياسي |
| 65536 | `0001 0000` | قياسي |
| 1 | `0000 0001` | غير قياسي: `0000` بادئة غير لازمة |
| Payload من 7 WORD | 7 WORD بعد TAG `0b82` (طول مباشر `LLLL=0111`، المجموع 8 WORD) | قياسي |
| Payload من 7 WORD | 7 WORD بعد TAG الطول الممتد والقيمة الممتدة `0009` | غير قياسي: 14 WORD فأقل تُكتب بطول مباشر |

## وضع الصيغة

- هذا التمثيل الذي يوحّد المقدار بلا إشارة ذا الدقة الاعتباطية في سلسلة WORD ذات 16 بت بأقل عدد ممكن ويربطها بـ TAG في GEUL هو scalar profile خاص بـ GEUL.
- عند التبادل مع أنواع خارجية ثابتة العرض مثل UINT8/16/32/64 يلزم فحص النطاق وتحويل صريح للعرض.
