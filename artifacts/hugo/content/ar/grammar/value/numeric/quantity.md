---
title: "QUANTITY"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "QUANTITY قيمة Value تحمل كمية واحدة في أربعة سجلات: مقدار هو سجل Value رقمي (عدد صحيح، BINARY-FLOAT، عدد عشري، كسر) وReference للوحدة وحد أدنى وحد أعلى."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUANTITY قيمة Value تمثل كمية واحدة بعدد ووحدة وحد أدنى وحد أعلى. الرمز المباشر في Value هو `0x06` والعائلة NUMERIC. كل جزء من الأجزاء الأربعة سجل كامل. الوحدة والحدود [حقول اختيارية](/ar/grammar/codec-spec/) فإذا حُذفت كُتبت ABSENT (`0x0000`).

## التخطيط

```
TAG WORD          0000 1LLL L000 0110      Codec 0x06
[Length ممتد TAG] عندما يبلغ المجموع 15 WORD فأكثر
amount            سجل Value رقمي (عدد صحيح، BINARY-FLOAT، عدد عشري، كسر)
unit              سجل Reference (عنصر الوحدة)، وإن لم تكن هناك وحدة فـ 0x0000
lower             سجل Value رقمي، وإن حُذف فـ 0x0000 ABSENT
upper             سجل Value رقمي، وإن حُذف فـ 0x0000 ABSENT
```

## التفسير والصلاحية

- amount سجل Value رقمي كامل واحد. الـ Codec المقبولة ستة: [SIGNED-INTEGER](/ar/grammar/value/numeric/signed-integer/) (`0x01`) و[UNSIGNED-INTEGER](/ar/grammar/value/numeric/unsigned-integer/) (`0x02`) و[BINARY-FLOAT](/ar/grammar/value/numeric/binary-float/) (`0x03`) و[FRACTION](/ar/grammar/value/numeric/fraction/) (`0x07`) و[SIGNED-DECIMAL](/ar/grammar/value/decimal/signed-decimal/) (`0x10`) و[UNSIGNED-DECIMAL](/ar/grammar/value/decimal/unsigned-decimal/) (`0x11`). القائمة مغلقة وليست حرفاً بديلاً (wildcard). لا تُقبل BOOL ولا COORDINATE-EARTH وCOORDINATE-GEO ولا QUANTITY نفسها (لا تداخل، العمق ثابت) ولا أي Value آخر. لا يجوز وضع علامة موضع (`0x0000` وما شابه) في amount.
- السجلات الداخلية أيضاً تتبع الصيغة القانونية لكل Codec (أقل عدد من WORD للأعداد الصحيحة وcoefficient، و1/2/4/8 WORD لـ BINARY-FLOAT، وFRACTION وفق قواعده). إذا كان سجل داخلي غير قانوني فالـ QUANTITY كلها invalid.
- إذا كان amount أو lower أو upper من نوع BINARY-FLOAT فيجب أن تكون القيمة منتهية. NaN و±Infinity كلاهما invalid (القاعدة نفسها لخط العرض وخط الطول في [COORDINATE-EARTH](/ar/grammar/value/numeric/coordinate-earth/)).
- صيغة العدد تتبع الكتابة الأصلية كما هي. الأصل الصحيح يُحمل INTEGER، والأصل ذو الكسور العشرية DECIMAL، والأصل الكسري FRACTION، وقيمة IEEE 754 الثنائية BINARY-FLOAT، ولا يغيّر المرمِّز الصيغة لتوحيدها. يحمل C وE في DECIMAL خانات الكتابة الأصلية كما هي: `1.20` = `120×10^-2` و`1.2` = `12×10^-1`. هما العدد نفسه لكن أرقامهما المعنوية مختلفة فهما قيمتان Value مختلفتان. لا حد أعلى لعدد خانات العدد الصحيح وcoefficient (أقل عدد من WORD، طول متغير).
- unit إما سجل Reference كامل واحد بالضبط أو `0x0000`. يمكن استخدام أي Reference يشير إلى عنصر وحدة (وحدات ويكي بيانات هي WIKIDATA-QID). `0x0000` تعني بلا وحدة (عدد أو نسبة أو تعداد سكان وما شابه).
- كل من lower وupper إما سجل من أحد الـ Codec الستة نفسها في amount أو `0x0000` ABSENT. علامة الموضع الوحيدة المقبولة هي الحذف ABSENT. يجوز وجود أحدهما فقط. لا يلزم أن يتحد Codec الأعداد الثلاثة. المدى المتماثل (`652 ± 1`) يُكتب أيضاً بحد أدنى وحد أعلى (`651` و`653`). وبما أن المدى غير المتماثل يحتاج إلى القيمتين على أي حال، فلا توجد صيغة تختزلهما إلى ± واحدة.
- تُقارن lower ≤ amount ≤ upper بالقيمة العددية لا بالبايتات ولا بالـ Codec. حتى إن اختلفت الأنواع تُقارن كأعداد (مثلاً SIGNED-INTEGER `652` وSIGNED-DECIMAL `651.5`). ويُقارن FRACTION بوصفه عدداً نسبياً دقيقاً.
- الوحدة جزء من القيمة. لا تُفصل الوحدة في QUALIFIER وما شابه (فبعد الفصل لا يُعرف هل `652` كيلومترات أم أمتار).
- إذا استُخرج سجل amount فهو كما هو سجل Value مستقل. وإذا احتيج إلى العدد بلا وحدة يُستخدم ذلك السجل دون إعادة ترميز.
- لا تُحمل القيمة المحوّلة إلى وحدات SI. فهي قيمة مشتقة يمكن حسابها من الوحدة وجدول التحويل.
- يجب أن يتطابق المؤشر بعد قراءة السجلات الأربعة مع نهاية Payload تماماً. أي شكل آخر invalid.
- تكتب مواصفة geul.org ذلك بأربعة حقول سجلات: amount (`0801`·`0802`·`0803`·`0807`·`0810`·`0811`) وunit (`0780`·`0000`) وlower·upper (`0801`·`0802`·`0803`·`0807`·`0810`·`0811`·`0000`) ([مواصفة Codec](/ar/grammar/codec-spec/)).

## الطول

- المجموع هو TAG (1 WORD) + (Length ممتد TAG) + السجلات الأربعة. سجل العدد الصحيح هو TAG (1) + Payload (1 WORD فأكثر)، وسجل BINARY-FLOAT هو 2 أو 3 أو 5 أو 9 WORD، وسجل العدد العشري هو TAG (1) + الأس (2) + coefficient (1 WORD فأكثر). وسجل FRACTION هو 5 WORD فأكثر.
- العدد الصحيح الصغير بلا وحدة ولا حدود يأخذ 6 WORD، والعدد العشري الصغير 8 WORD. وإذا بلغ 15 WORD فأكثر استُخدم الطول الممتد ([السجل وTAG WORD](/ar/grammar/record/)).

## أمثلة

`1.20` بلا وحدة:

```
0B86 0990 FFFF FFFE 0078 0000 0000 0000
```

- TAG `0B86` (Codec `0x06`، 8 WORD)، وamount `0990 FFFF FFFE 0078` (E = -2, C = 120)، وunit وlower وupper كلها `0000`.

العدد الصحيح `42` بلا وحدة:

```
0A86 0881 002A 0000 0000 0000
```

- TAG `0A86` (6 WORD)، وamount `0881 002A` (SIGNED-INTEGER 42)، وunit وlower وupper كلها `0000`.

الكسر `2/3` بلا وحدة (ثلثا حقوق التصويت الحاضرة):

```
0C06 0A07 0881 0002 0882 0003 0000 0000 0000
```

- TAG `0C06` (9 WORD)، وamount `0A07 0881 0002 0882 0003` ([FRACTION](/ar/grammar/value/numeric/fraction/) 2/3)، وunit وlower وupper كلها `0000`.

`652 km`، المدى `[651, 653]` (km = Q828224):

```
0F06 0011
0990 0000 0000 028C
0120 000C A340
0990 0000 0000 028B
0990 0000 0000 028D
```

- المجموع 17 WORD فـ `LLLL=1110`، وTAG الممتد `0011`.

## المقابل في ويكي بيانات

- datavalue من نوع `quantity` `{"amount","unit","lowerBound","upperBound"}` ← amount وunit وlower وupper. تُنقل سلاسل amount والحدود (`+1.20` بما فيها صيغة الأس) إلى C وE بعدد الخانات كما هو.
- amount والحدود في ويكي بيانات سلاسل عشرية، لذا تُنقل إلى SIGNED-DECIMAL حتى لو كانت بشكل عدد صحيح (`+652`). لا يستخدم تحويل ويكي بيانات أي Codec رقمي آخر.
- الوحدة `"1"` هي بلا وحدة (`0x0000`)، و`http://www.wikidata.org/entity/Qn` هي WIKIDATA-QID. الوحدات الأخرى والأعداد والحدود غير المطابقة للصيغة لا تُحوَّل بل يُحفظ نصها الأصلي كـ UTF8-TEXT.
- عينة من ويكي بيانات (نحو 42 ألف quantity من بداية الـ dump): بلا وحدة 61%، بها حدود 13% (منها متماثلة 93%)، وأطول amount هو 31 حرفاً.

## السند المعياري

- التمثيل العشري وحفظ عدد الخانات: مفاهيم coefficient وexponent وquantum في decimal من [IEEE 754-2008](https://standards.ieee.org/ieee/754/6210/) (SIGNED-DECIMAL في GEUL).
- نموذج الكمية في ويكي بيانات: `QuantityValue` في Wikibase DataModel.

## صفحات ذات صلة

- [Value](/ar/grammar/value/)، [SIGNED-DECIMAL](/ar/grammar/value/decimal/signed-decimal/)، [COORDINATE-GEO](/ar/grammar/value/numeric/coordinate-geo/)، [CODEC](/ar/grammar/edge/codec/)، [WIKIDATA-QID](/ar/grammar/reference/wikidata-qid/)
