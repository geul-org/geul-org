---
title: "Value"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "Value سجل يحمل القيمة نفسها. أعلى بتّين في Codec يحددان العائلة (الأعداد والأعداد العشرية، الزمن، النص، الثنائي). الصيغ الشائعة لها رموز مباشرة، وبقية الصيغ توضع تحت Issuer الجهة المعيارية."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Value سجل يحمل القيمة نفسها. يحدد Codec كيفية تفسير Payload.

## التخطيط

```
TAG WORD          0000 1LLL LCCC CCCC
[Length ممتد TAG]
[Codec ممتد TAG]  في صيغة Issuer
Payload
```

- `LLLL` هو العدد الكلي لـ WORD شاملاً TAG WORD ناقص 1. الطول من 1 إلى 14 WORD طول مباشر، والطول 15 WORD فأكثر طول ممتد.
- في صيغة Issuer يحمل Codec ممتد TAG الـ Issuer (بعرض 1/2/4/16 WORD يحدده Codec) ورقم الصيغة في WORD واحد. أعلى بتّين في رقم الصيغة هما العائلة.
- يعرف المفكك العائلة والطول حتى لو لم يعرف الصيغة.

## العائلات

أعلى بتّين في Codec هما العائلة. الرمز المباشر (7 بتات) ورقم صيغة Issuer (16 بت) يتبعان القاعدة نفسها، فتُعرف العائلة دون كتاب رموز.

| أعلى بتّين | العائلة | الرمز المباشر | رقم الصيغة |
|---|---|---|---|
| `00` | NUMERIC / DECIMAL | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | TIME | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | TEXT | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | BINARY | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

- تنقسم NUMERIC / DECIMAL مرة أخرى بالبت الثالث. `000` هي NUMERIC و`001` هي DECIMAL.
- القيم العددية مثل المتجهات والتنسورات والأعداد المركبة والكسور والفترات هي NUMERIC. الاستثناء BIT-VECTOR فهو BINARY. رموز اللغات من TEXT.
- يلحق بسجل صيغة Issuer كل من Codec ممتد TAG (Issuer ورقم الصيغة). وإذا طال Payload (15 WORD فأكثر في المجموع) يُستخدم Length ممتد TAG.

## الرموز المباشرة

| Codec | الاسم | العائلة | الوصف |
|---|---|---|---|
| `0x00` | [BOOL](/ar/grammar/value/numeric/bool/) | NUMERIC | false أو true |
| `0x01` | [SIGNED-INTEGER](/ar/grammar/value/numeric/signed-integer/) | NUMERIC | عدد صحيح بمتمم اثنين بأقل عدد من WORD |
| `0x02` | [UNSIGNED-INTEGER](/ar/grammar/value/numeric/unsigned-integer/) | NUMERIC | عدد صحيح بلا إشارة بأقل عدد من WORD |
| `0x03` | [BINARY-FLOAT](/ar/grammar/value/numeric/binary-float/) | NUMERIC | IEEE 754 binary16/32/64/128 |
| `0x04` | [COORDINATE-EARTH](/ar/grammar/value/numeric/coordinate-earth/) | NUMERIC | خط العرض وخط الطول على الأرض (WGS 84) مع عدم اليقين (Reference الوحدة) |
| `0x05` | [COORDINATE-GEO](/ar/grammar/value/numeric/coordinate-geo/) | NUMERIC | Reference الجرم السماوي مع خط العرض وخط الطول وعدم اليقين (Reference الوحدة) |
| `0x06` | [QUANTITY](/ar/grammar/value/numeric/quantity/) | NUMERIC | كمية رقمية (عدد صحيح، BINARY-FLOAT، عدد عشري، كسر) وReference الوحدة والحد الأدنى والأعلى |
| `0x07` | [FRACTION](/ar/grammar/value/numeric/fraction/) | NUMERIC | كسر يحفظ كتابته (سجلا البسط والمقام، بلا اختزال) |
| `0x10` | [SIGNED-DECIMAL](/ar/grammar/value/decimal/signed-decimal/) | DECIMAL | `C × 10^E`، معامل بإشارة |
| `0x11` | [UNSIGNED-DECIMAL](/ar/grammar/value/decimal/unsigned-decimal/) | DECIMAL | `C × 10^E`، معامل بلا إشارة |
| `0x20` | [GREGORIAN-DATE](/ar/grammar/value/time/gregorian-date/) | TIME | عدد الأيام منذ 1970-01-01 (التقويم الميلادي) |
| `0x21` | [CIVIL-TIME-NANOSECONDS](/ar/grammar/value/time/civil-time-nanoseconds/) | TIME | النانوثانية منذ منتصف الليل |
| `0x22` | [POSIX-TIMESTAMP-SECONDS](/ar/grammar/value/time/posix-timestamp-seconds/) | TIME | الثواني منذ Unix epoch |
| `0x23` | [DURATION-SECONDS](/ar/grammar/value/time/duration-seconds/) | TIME | الزمن المنقضي (بالثواني) |
| `0x24`/`0x25` | [EDTF](/ar/grammar/value/time/edtf/) | TIME | سلسلة تاريخ ممتدة وفق ISO 8601-2 (دقة السنة والشهر، عدم اليقين، الفترات) |
| `0x26`/`0x27` | [GEDCOM-DATE](/ar/grammar/value/time/gedcom-date/) | TIME | سلسلة تاريخ GEDCOM 7 (تقاويم أخرى مثل التقويم اليولياني) |
| `0x40`/`0x41` | [UTF8-TEXT](/ar/grammar/value/text/utf8-text/) | TEXT | سلسلة UTF-8 بلا لغة |
| `0x44`/`0x45` | [URI](/ar/grammar/value/text/uri/) | TEXT | URI وفق RFC 3986 |
| `0x46`/`0x47` | [LANGUAGE-BCP47-CODE](/ar/grammar/value/text/language-bcp47-code/) | TEXT | وسم لغة BCP 47 |
| `0x48` | [LANGUAGE-SHORT-CODE](/ar/grammar/value/text/language-short-code/) | TEXT | رمز لغة مضغوط في 1 WORD |
| `0x4A`/`0x4B` | [UTF8-LANGUAGE-TEXT](/ar/grammar/value/text/utf8-language-text/) | TEXT | نص مرفق بلغة |
| `0x60` | [UUID](/ar/grammar/value/binary/uuid/) | BINARY | UUID وفق RFC 9562 |
| `0x61` | [SHA-256-DIGEST](/ar/grammar/value/binary/sha-256-digest/) | BINARY | ناتج SHA-256 |
| `0x62` | [SHA1-DIGEST](/ar/grammar/value/binary/sha1-digest/) | BINARY | ناتج SHA-1 (لأغراض التعريف مثل معرّف كائن git) |

- الرموز المزدوجة (زوجي/فردي) هي سلاسل بايتات متغيرة الطول. الرمز الزوجي لعدد زوجي من البايتات والرمز الفردي لعدد فردي ([السجل وTAG WORD](/ar/grammar/record/)).
- الرموز المباشرة غير المذكورة في الجدول محجوزة.

## صيغ Issuer

الصيغة غير الموجودة بين الرموز المباشرة توضع برقم صيغة تحت Issuer الجهة التي وضعتها. الصيغ العُرفية التي لا جهة واضعة لها توضع تحت ADHOC (`0x0001`)، وصيغ GEUL الخاصة تحت GEUL (`0x0000`).

| Issuer | أمثلة على الصيغ |
|---|---|
| GEUL `0x0000` | DURATION-NANOSECONDS, OPAQUE-BYTES, BIT-VECTOR |
| ADHOC `0x0001` | BFLOAT16، متجهات الأعداد الصحيحة والحقيقية، التنسورات، الأعداد المركبة، الكسور، الفترات، الرباعيات، BLAKE3 |
| IETF `0x0020` | URI نسبي، CRC32C، عناوين IPv4 وIPv6 |
| IEEE `0x0040` | IEEE 754 decimal32/64/128، الطابع الزمني POSIX بالنانوثانية، عنوان MAC |
| KHRONOS `0x0041` | بكسلات RGBA8 وBGRA8 |
| ONNX `0x0043`, OCP `0x0044` | FP8, FP4 |
| BIPM `0x0060` | الطابع الزمني TAI |
| NIST `0x0062` | SHA-512, SHA3-256 |
| GPS `0x0063` | الطابع الزمني GPS |

- المفكك الذي لا يعرف الصيغة يعرف عائلتها من رقم الصيغة فقط ويتخطى Payload.
- يُوصى بالإشارة إلى القيم الكبيرة مثل الصور والفيديو عبر URI وSHA-256 بدل وضعها مباشرة.
- المصنفات داخل سلسلة البايتات تخضع لترخيصها الأصلي. يُسجَّل المصدر والترخيص في Meta.

## حزم الصيغ

تفصيل كل صيغة (التخطيط، التفسير، الصلاحية، الأمثلة) في وثيقة الحزمة.

| الحزمة | العائلة | الصيغ |
|---|---|---|
| [numeric](/ar/grammar/value/numeric/) | NUMERIC | BOOL، الأعداد الصحيحة، الفاصلة العائمة، الإحداثيات، QUANTITY، FRACTION |
| [decimal](/ar/grammar/value/decimal/) | DECIMAL | SIGNED-DECIMAL, UNSIGNED-DECIMAL, IEEE 754 decimal32/64/128 |
| [time](/ar/grammar/value/time/) | TIME | التاريخ، الوقت، الطابع الزمني، الزمن المنقضي، EDTF، تاريخ GEDCOM |
| [text](/ar/grammar/value/text/) | TEXT | نص UTF-8، النص المرفق بلغة، URI، رموز اللغات |
| [binary](/ar/grammar/value/binary/) | BINARY | UUID، الملخصات، CRC، عناوين الشبكة، البايتات المبهمة، متجه البتات |
| [vector](/ar/grammar/value/vector/) | NUMERIC | متجهات كثيفة صحيحة وحقيقية، النقاط والمربعات الحدية، بكسلات RGBA وBGRA |
| [tensor](/ar/grammar/value/tensor/) | NUMERIC | تنسورات dense وpacked مع الصيغة وrank وshape |
| [etc](/ar/grammar/value/etc/) | NUMERIC | الأعداد المركبة، الكسور، الفترات المغلقة، الرباعيات |

- حزم vector وtensor وetc كلها صيغ Issuer (ADHOC وKHRONOS) من عائلة NUMERIC.

## النص

النص ذو اللغة والنص بلا لغة قيمتان مختلفتان. "Paris" (سلسلة) و"Paris" (بالفرنسية) ليسا متساويين.

| الصيغة | موضع الاستخدام |
|---|---|
| UTF8-TEXT | السلاسل بلا لغة مثل المعرّفات والرموز وأسماء الملفات والمعرّفات الخارجية |
| UTF8-LANGUAGE-TEXT | النصوص ذات اللغة مثل الأسماء والعناوين والجمل |

```
UTF8-LANGUAGE-TEXT
TAG WORD          0000 1LLL L100 101P   (P = عدد بايتات النص فردي)
[Length ممتد TAG]
اللغة             سجل LANGUAGE-SHORT-CODE أو LANGUAGE-BCP47-CODE
النص              بايتات UTF-8 (إذا كان العدد فردياً فآخرها 0x00)
```

- النص UTF-8 سليم التكوين ويُحفظ كما هو في الأصل. التطبيع من شأن جهة المقارنة والفهرسة.
- الاسم المشترك بين لغات كثيرة يُكتب بلغة `mul`، واللغة غير المحددة `und`. السلسلة التي لا محتوى لغوياً فيها هي UTF8-TEXT.

مثال: `"Douglas Adams"@en` (13 بايت، فردي)

```
0CCB  08C6 656E  446F 7567 6C61 7320 4164 616D 7300
TAG   اللغة en    D o  u g  l a  s ␠  A d  a m  s (حشو)
```

## الأعداد العشرية والكميات

العدد العشري الدقيق يُكتب `C × 10^E`. الأس `E` من 32 بت، والمعامل `C` متمم اثنين بأقل عدد من WORD. تُحفظ خانات الكتابة الأصلية كما هي: `1.20` هو `C=120, E=−2` و`1.2` هو `C=12, E=−1`. الكتابتان تمثلان العدد نفسه لكنهما سجلان منفصلان بايتاتهما مختلفة. لا يطبّع المرمّز الكتابة من تلقاء نفسه. معنى تساوي القيمة بين السجلين وquantum (الأرقام المعنوية) مسألة مفتوحة ([SIGNED-DECIMAL](/ar/grammar/value/decimal/signed-decimal/#مسائل-مفتوحة)).

QUANTITY تحمل الكمية والوحدة والحدود في قيمة واحدة.

```
TAG WORD          0000 1LLL L000 0110
[Length ممتد TAG]
الكمية            سجل Value رقمي (عدد صحيح، BINARY-FLOAT، عدد عشري، كسر)
الوحدة            سجل Reference (عنصر الوحدة)، وإن لم تكن هناك وحدة فـ 0x0000
الحد الأدنى       سجل Value رقمي، وإن حُذف فـ 0x0000 ABSENT
الحد الأعلى       سجل Value رقمي، وإن حُذف فـ 0x0000 ABSENT
```

- الوحدة جزء من القيمة. لا تُفصل الوحدة وتُكتب في مكان آخر (فبعد الفصل لا يُعرف هل `652` كيلومترات أم أمتار).
- لا تُحمل القيمة المحوّلة إلى وحدات SI. يمكن حسابها من الوحدة وجدول التحويل.
- `0x0000` (ABSENT) علامة على حذف حقل اختياري ([مواصفة Codec](/ar/grammar/codec-spec/)).

مثال: `652 km`، المدى `[651, 653]` (km = ويكي بيانات Q828224)

```
0F06 0011                    TAG (طول ممتد 17 WORD)
0990 0000 0000 028C          الكمية 652
0120 000C A340               الوحدة Q828224
0990 0000 0000 028B          الحد الأدنى 651
0990 0000 0000 028D          الحد الأعلى 653
```

## التاريخ

| الدقة | الصيغة |
|---|---|
| تاريخ (التقويم الميلادي) | GREGORIAN-DATE |
| السنة والشهر، عدم اليقين (`1971~`)، الفترة | EDTF |
| الكتابة الأصلية في تقويم آخر (اليولياني وغيره) | GEDCOM-DATE |
| الوقت | الطوابع الزمنية POSIX وTAI وGPS |

- التاريخ الذي يمكن كتابته بـ GREGORIAN-DATE لا يُكتب بـ EDTF.

## مسائل مفتوحة

- صيغ الوسائط العامة (JPEG وPNG وMP4 وMOV وغيرها) توضع برقم صيغة BINARY تحت Issuer الخاص بـ IANA (`0x0021`). كيفية إدارة جدول المقابلة بين نوع الوسائط ورقم الصيغة.
- القائمة النهائية للرموز المباشرة في Value. تُحدد بقياس تكرار Value في عينات القوانين والحوارات المهنية (مرشحات: المبلغ، النسبة المئوية، فترة التاريخ).
- المواصفة التفصيلية وموضع الكميات العددية الصغيرة السبع (ADHOC BFLOAT16، وFP8 الأربعة من ONNX، وFP8-E8M0FNU وFP4-E2M1FN من OCP). لم يتقرر هل تُنقل إلى النطاق المحجوز للرموز المباشرة في NUMERIC (`0x08`~`0x0F`). حالياً أُعطيت أرقام صيغ فقط.
