---
title: "URI"
weight: 69
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI قيمة Value تحمل سلسلة بايتات ASCII وفق نحو URI في RFC 3986 (URI مطلق بما فيه scheme). تستخدم زوج الرموز الزوجي/الفردي 0x44/0x45."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI قيمة Value تحمل سلسلة بايتات ASCII وفق نحو `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` في RFC 3986. بما أنه يتضمن scheme فلا يحتاج تفسيره إلى base URI.

## التخطيط

- الرمز: الرمز المباشر في Value هو `0x44` (عدد بايتات زوجي) و`0x45` (عدد بايتات فردي). العائلة TEXT.
- يُحدد عدد البايتات بأقل بت في Codec وبعدد WORD في Payload: `2 × عدد WORD في Payload − أقل بت`، ولا يوجد Byte Count ([Value](/ar/grammar/value/)).

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x44/0x45
[Length ممتد TAG] عندما يبلغ المجموع 15 WORD فأكثر
Payload WORD 1st ... Nth          URI bytes / final zero padding
```

## التفسير والصلاحية

- يجب أن تطابق سلسلة البايتات نحو `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` في RFC 3986. ويجوز أن تتضمن query وfragment.
- المحارف الطرفية (terminal) في نحو URI هي محارف US-ASCII. تُخزَّن محارف ASCII المسموح بها كما هي، وعند ترميز octet بالنسبة المئوية (percent-encoding) تُستخدم الصيغة `pct-encoded = "%" HEXDIG HEXDIG`. لا يجوز وضع محارف غير ASCII مباشرة كـ literal byte.
- يجب أن يتضمن `scheme` و`:`. المرجع النسبي يُكتب بـ [URI-RELATIVE-REF](/ar/grammar/value/text/uri-relative-ref/) (رقما صيغة IETF `0x8000`·`0x8001`).
- production الـ URI في RFC 3986 لا تسمح بالسلسلة الفارغة. سجل 0 byte غير صالح.
- في WORD يأتي byte الأعلى أولاً. إذا كان عدد البايتات فردياً (رمز فردي) فيجب أن يكون byte الأدنى غير المستخدم في آخر WORD هو `00`.
- عدد WORD في Payload هو `ceil(عدد البايتات/2)`. يُرفض ما كان الرمز فيه فردياً لكن byte الأدنى في آخر WORD ليس `00`.

## السند المعياري

- `URI` ومحارف URI ونحو الترميز بالنسبة المئوية يتبع [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986).
- زوج الرموز زوجي/فردي وzero padding وتوزيع TAG/Length في GEUL على WORD ذات 16 بت هي قواعد framing في هذه الصيغة.

## الطول

- المجموع هو عدد WORD لـ: TAG (1 WORD)، وLength ممتد TAG (إن وجد)، وPayload. الطول 14 WORD فأقل طول مباشر، و15 WORD فأكثر يستخدم الطول الممتد `1110`·`1111`، ويدخل الـ TAG الممتد في المجموع ([Length](/ar/grammar/record/)).

## أمثلة

- `https://example.com/` هو 20 byte من ASCII (زوجي) فيكون `URI-EVEN` (`0x44`).
- Payload هو 10 WORD: `6874 7470 733a 2f2f 6578 616d 706c 652e 636f 6d2f`.
- TAG (1 WORD) وPayload (10 WORD) فالمجموع 11 WORD و`LLLL=1010`. السجل الكامل هو `0D44 6874 7470 733a 2f2f 6578 616d 706c 652e 636f 6d2f`.

## GEUL Archive URI

`archive.geul.org` مستودع محتوى غير قابل للتغيير مُخطَّط له، يُستخدم في GEUL للإشارة إلى المحتوى الكبير كالثنائيات والمستندات الخارجية، ولم يبدأ تشغيله بعد. صيغة العنوان الموصى بها هي `https://archive.geul.org/sha256/{digest}`. يجب أن تكون لسلسلة البايتات نفسها URI نفسه، وبعد النشر لا يجوز تغيير بايتات ذلك URI.

قيمة URI تمثل موضع المحتوى الخارجي أو سلسلة عنوانه فقط، ولا تضمن تطابق الهدف نفسه ولا ثباته. الثنائيات والنصوص التي تتجاوز النطاق الأقصى للقيمة Value المضمَّنة يمكن الإشارة إليها بـ archive URI. ويجب أن تُسجَّل في البيانات الوصفية للكائن المخزَّن البنود الآتية:

- URI الأصلي ووقت الجمع
- SHA-256 وByte Length
- MIME type
- license identifier وإصداره
- المؤلف والمصدر والإشعارات
- URI سند الترخيص، ونسخة من السند وقت الجمع عند الحاجة

يُحكم بإمكانية الجمع بما إذا كان حق إعادة التوزيع مؤكداً صراحةً، لا بما إذا كان الوصول مجانياً. يجب الالتزام بشروط الترخيص المنطبقة كذكر المؤلف وعدم الاستخدام التجاري وعدم التعديل والمشاركة بالمثل. يُسجَّل في المستندات والمحتوى ترخيص صريح مثل Creative Commons، ويُستخدم في البرمجيات SPDX License ID قدر الإمكان.

حتى إذا أُوقف التقديم بسبب مسألة حقوق أو تصحيح فلا يجوز وضع بايتات مختلفة في URI الحالي. يعيد ذلك URI tombstone يتضمن سبب الإيقاف ووقته، ويجب حفظ digest الأصلي وسجل التدقيق. غير أنه إذا حظر التزام قانوني حفظ سجل التدقيق فيُقدَّم ذلك الالتزام.

يوفر archive URI موضع الوصول وdigest المحتوى معاً. قاعدتا العنونة بالمحتوى (content-address) وعدم التغيير هاتان سياسة في GEUL Archive profile، أما النحو العام لقيمة URI فلا يرتبط بـ `archive.geul.org`.
