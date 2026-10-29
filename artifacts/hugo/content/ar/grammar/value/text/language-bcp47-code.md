---
title: "LANGUAGE-BCP47-CODE"
weight: 71
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-BCP47-CODE قيمة Value تحمل وسم لغة BCP 47 كاملاً كسلسلة بايتات ASCII. تستخدم زوج الرموز الزوجي/الفردي 0x46/0x47."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-BCP47-CODE قيمة Value تحمل وسم لغة BCP 47 كاملاً. تُستخدم عندما يلزم كتابة اللغة بدقة حتى script وregion وvariant.

## التخطيط

- الرمز: الرمز المباشر في Value هو `0x46` (عدد بايتات زوجي) و`0x47` (عدد بايتات فردي). العائلة TEXT.
- يُحدد عدد البايتات بأقل بت في Codec وبعدد WORD في Payload: `2 × عدد WORD في Payload − أقل بت`، ولا يوجد Byte Count ([Value](/ar/grammar/value/)).
- Payload ليس نص UTF-8 بل سلسلة بايتات ASCII لوسم BCP 47.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x46/0x47
[Length ممتد TAG] عندما يبلغ المجموع 15 WORD فأكثر
Payload WORD 1st ... Nth          BCP 47 tag bytes / final zero padding
```

## التفسير والصلاحية

- يجب أن تكون سلسلة البايتات وسم لغة BCP 47 سليم التكوين (well-formed) وفق RFC 5646. السلسلة الفارغة غير مسموحة.
- لا يُستخدم في Payload إلا أحرف ASCII والأرقام وhyphen-minus `-`. الفاصل ASCII `-` حتماً، ولا يُسمح بـ `_` ولا المسافة ولا المحارف غير ASCII.
- مقارنة وسوم BCP 47 لا تميز بين الحروف الكبيرة والصغيرة. يكتب profile القياسي في GEUL كل الفواصل `-`، ويسلسل language/extlang/variant/extension/private-use subtag بحروف صغيرة، وscript بصيغة Titlecase، وregion بحروف كبيرة.
- سلامة التكوين وحدها لا تكفي. تُحدد صلاحية registered subtag والوسوم grandfathered بالاعتماد على snapshot معين من IANA Language Subtag Registry، ويجب حفظ تاريخ ذلك snapshot أو إصدار registry معه.
- يُسمح بوسم private-use وsubtag من نوع private-use إذا كان سليم التكوين وفق قواعد RFC 5646. لكن معناه رهن اتفاق الأطراف ولا يعرّفه سجل IANA، فلا يُضمن التشغيل البيني العام.
- إذا كان لـ deprecated subtag أو وسم grandfathered في snapshot نفسه Preferred-Value، فإن الصيغة القياسية في GEUL تكتب القيمة البديلة بحالة الأحرف القياسية. الوسم بالكتابة deprecated نفسها يمكن تفسيره كمُدخل لكنه ليس صيغة التخزين القياسية.
- BCP 47 ملف تعريف ASCII فلا تنطبق عليه متطلبات تطبيع Unicode مثل UTF-8 NFC.
- في WORD يأتي byte الأعلى أولاً. إذا كان عدد البايتات فردياً (رمز فردي) فيجب أن يكون byte الأدنى غير المستخدم في آخر WORD هو `00`.
- عدد WORD في Payload هو `ceil(عدد البايتات/2)`. يُرفض ما كان الرمز فيه فردياً لكن byte الأدنى في آخر WORD ليس `00`.

## السند المعياري

- قواعد نحو وسم اللغة وتفسيره غير الحساس لحالة الأحرف ومفهوما deprecated وPreferred-Value تتبع [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- السجل الذي يُحكم به في صلاحية الوسم هو [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- زوج الرموز زوجي/فردي وzero padding وسياسة تخزين حالة الأحرف القياسية وحساب Length هي قواعد framing في GEUL.

## الطول

- المجموع هو عدد WORD لـ: TAG (1 WORD)، وLength ممتد TAG (إن وجد)، وPayload. الطول 14 WORD فأقل طول مباشر، و15 WORD فأكثر يستخدم الطول الممتد `1110`·`1111`، ويدخل الـ TAG الممتد في المجموع ([Length](/ar/grammar/record/)).

## العلاقة مع LANGUAGE-SHORT-CODE

- الوسم الذي له رقم في GEUL Language Registry يمكن كتابته في 1 WORD بصيغة [LANGUAGE-SHORT-CODE](/ar/grammar/value/text/language-short-code/).
- الوسم الذي ليس له رقم في السجل (ومنه الوسوم التي فيها extension أو private-use) يُكتب بصيغة LANGUAGE-BCP47-CODE. ويُستخدم LANGUAGE-BCP47-CODE أيضاً عند الحاجة إلى حفظ النص الأصلي للوسم الكامل.
- SHORT-CODE ‏`n` وLANGUAGE-BCP47-CODE للوسم الذي يربطه السجل بـ `n` (دون تمييز حالة الأحرف) هما اللغة نفسها.

## أمثلة

- `ko-KR` هو 5 bytes من ASCII (فردي) فيكون `LANGUAGE-BCP47-CODE-ODD` (`0x47`)، وPayload هو `6b6f 2d4b 5200`.
- TAG (1 WORD) وPayload (3 WORD) فالمجموع 4 WORD و`LLLL=0011`. السجل الكامل هو `09C7 6b6f 2d4b 5200`.
