---
title: "Value"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "Value سجل يحمل القيمة نفسها."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Value سجل يحمل القيمة نفسها. ويحدد Codec تفسير Payload.

## التخطيط {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      القسمان 3 و4 (0x060L~0x09FL)
[Length ممتد TAG]
[Codec ممتد TAG]  عند صيغة Issuer
Payload
```

- `LLLL` هو عدد WORD الكلي شاملاً TAG WORD ناقصاً 1. من 1 إلى 14 WORD طول مباشر، ومن 15 WORD فأكثر طول ممتد.
- في صيغة Issuer يوضع في TAG Codec الممتد Issuer (بعرض 2/4/16 WORD يحدده Codec) ورقم Codec بـ 2 WORD. ورقم Codec يحدده Issuer.
- يعرف المفكّك حتى لو لم يعرف الصيغة: Kind وLength وIssuer ورقم Codec.

## العائلة {#계열}

رقم Value لا يدل على العائلة. فالرموز المباشرة لا تدل بالبتات على العائلة، ولا قاعدة للعائلة في صيغ Issuer كذلك. والعائلة تجميع موضوعي.

| العائلة | الرموز المباشرة |
|---|---|
| NUMERIC | `0x060L~0x067L` |
| DECIMAL | `0x068L~0x069L` |
| TIME | `0x06AL~0x071L`, `0x081L` |
| TEXT | `0x072L~0x07AL` |
| BINARY | `0x07BL~0x080L` |

- القيم العددية مثل المتجهات والتنسورات والأعداد المركبة والكسور والمجالات هي NUMERIC. واستثناؤها BIT-VECTOR فهو BINARY. ورموز اللغات TEXT.
- يلحق بسجل صيغة Issuer TAG Codec الممتد (Issuer ورقم Codec). وإذا طال Payload (المجموع 15 WORD فأكثر) يُستعمل TAG Length الممتد.

## الرموز المباشرة {#직접-코드}

| Codec | الاسم | العائلة | الوصف |
|---|---|---|---|
| `0x060L` | [BOOL](0x060L-bool.md) | NUMERIC | false أو true |
| `0x061L` | [SIGNED-INTEGER](0x061L-signed-integer.md) | NUMERIC | عدد صحيح بتكميل الاثنين بأقل عدد من WORD |
| `0x062L` | [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) | NUMERIC | عدد صحيح غير موقّع بأقل عدد من WORD |
| `0x063L` | [BINARY-FLOAT](0x063L-binary-float.md) | NUMERIC | IEEE 754 binary16/32/64/128 |
| `0x064L` | [COORDINATE-EARTH](0x064L-coordinate-earth.md) | NUMERIC | خط العرض والطول على الأرض (WGS 84) وعدم اليقين (Reference الوحدة) |
| `0x065L` | [COORDINATE-GEO](0x065L-coordinate-geo.md) | NUMERIC | Reference الجرم السماوي وخط العرض والطول وعدم اليقين (Reference الوحدة) |
| `0x066L` | [QUANTITY](0x066L-quantity.md) | NUMERIC | كمية عددية (عدد صحيح·BINARY-FLOAT·عدد عشري·كسر) وReference الوحدة والحد الأدنى والأعلى |
| `0x067L` | [FRACTION](0x067L-fraction.md) | NUMERIC | كسر يحفظ الكتابة (سجلا البسط والمقام، دون اختزال) |
| `0x068L` | [SIGNED-DECIMAL](0x068L-signed-decimal.md) | DECIMAL | `C × 10^E`، معامل موقّع |
| `0x069L` | [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md) | DECIMAL | `C × 10^E`، معامل غير موقّع |
| `0x06AL` | [GREGORIAN-DATE](0x06AL-gregorian-date.md) | TIME | عدد الأيام منذ 1970-01-01 (التقويم الغريغوري) |
| `0x06BL` | [CIVIL-TIME-NANOSECONDS](0x06BL-civil-time-nanoseconds.md) | TIME | النانوثانية منذ منتصف الليل |
| `0x06CL` | [POSIX-TIMESTAMP-SECONDS](0x06CL-posix-timestamp-seconds.md) | TIME | الثواني منذ Unix epoch |
| `0x06DL` | [DURATION-SECONDS](0x06DL-duration-seconds.md) | TIME | الزمن المنقضي (بالثواني) |
| `0x06EL`/`0x06FL` | [EDTF](0x06EL-edtf.md) | TIME | سلسلة تاريخ ممتدة في ISO 8601-2 (دقة السنة والشهر، وعدم اليقين، والمدى) |
| `0x070L`/`0x071L` | [GEDCOM-DATE](0x070L-gedcom-date.md) | TIME | سلسلة تاريخ GEDCOM 7 (التقاويم الأخرى كاليولياني) |
| `0x072L`/`0x073L` | [UTF8-TEXT](0x072L-utf8-text.md) | TEXT | سلسلة UTF-8 بلا لغة |
| `0x074L`/`0x075L` | [URI](0x074L-uri.md) | TEXT | URI وفق RFC 3986 |
| `0x076L`/`0x077L` | [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) | TEXT | وسم لغة BCP 47 |
| `0x078L`/`0x079L` | [UTF8-LANGUAGE-TEXT](0x078L-utf8-language-text.md) | TEXT | نص موسوم بلغته |
| `0x07AL` | [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md) | TEXT | رمز لغة مضغوط بـ 1 WORD |
| `0x07BL` | [UUID](0x07BL-uuid.md) | BINARY | UUID وفق RFC 9562 |
| `0x07CL` | [SHA-256-DIGEST](0x07CL-sha-256-digest.md) | BINARY | ناتج SHA-256 |
| `0x07DL` | [SHA1-DIGEST](0x07DL-sha1-digest.md) | BINARY | ناتج SHA-1 (لأغراض التعريف كمعرّف كائن git) |
| `0x07EL`/`0x07FL` | [OPAQUE-BYTES](0x07EL-opaque-bytes.md) | BINARY | سلسلة بايتات مجهولة المعنى والصيغة. بايتات زوجية·فردية |
| `0x080L` | [BIT-VECTOR](0x080L-bit-vector.md) | BINARY | N بت مخزَّنة بترتيب MSB-first بعد bit-count |
| `0x081L` | [DURATION-NANOSECONDS](0x081L-duration-nanoseconds.md) | TIME | الزمن المنقضي (بالنانوثانية) |

- الرموز المقترنة زوجياً/فردياً هي سلاسل بايتات متغيرة الطول. الرمز الزوجي لعدد البايتات الزوجي، والفردي للفردي ([السجل وTAG WORD](../record.md)).
- الرموز المباشرة في `0x060L~0x081L` بلا Reserved. أما `0x082L~0x09CL` فهي Reserved، و`0x09DL~0x09FL` هي [VALUE-ISSUER-2WORD](0x09DL-value-issuer-2word.md)·[4WORD](0x09EL-value-issuer-4word.md)·[16WORD](0x09FL-value-issuer-16word.md).

## صيغ Issuer {#issuer-형식}

الصيغة التي ليست في الرموز المباشرة توضع برقم Codec تحت Issuer الجهة التي وضعتها. والصيغ العرفية التي لا جهة واضعة لها توضع تحت ADHOC (`0x00000002`). أما الصيغ الخاصة بـ GEUL (OPAQUE-BYTES وBIT-VECTOR وDURATION-NANOSECONDS) فهي رموز مباشرة.

| Issuer | أمثلة على الصيغ |
|---|---|
| ADHOC `0x00000002` | BFLOAT16، متجهات الأعداد الصحيحة·الحقيقية، التنسورات، الأعداد المركبة، الكسور، المجالات، الرباعيات (quaternion)، BLAKE3 |
| IETF `0x00000007` | URI النسبي، CRC32C، عناوين IPv4·IPv6 |
| IEEE `0x0000000D` | IEEE 754 decimal32/64/128، ختم POSIX زمني بالنانوثانية، عنوان MAC |
| KHRONOS `0x0000000E` | بكسلات RGBA8·BGRA8 |
| ONNX `0x00000010`, OCP `0x00000011` | FP8, FP4 |
| BIPM `0x00000013` | ختم TAI الزمني |
| NIST `0x00000015` | SHA-512, SHA3-256 |
| GPS `0x00000016` | ختم GPS الزمني |

- يعرف المفكّك الذي لا يعرف الصيغة Issuer ورقم Codec ويتخطى الباقي بـ Length.
- يوضع مستند Codec تحت `codecs/` عند ذلك Issuer برقم Codec السجل. مثال: CRC32C في IETF هو `0x00000007/codecs/0x0000C000/` ([عناوين النشر وقائمة الإصدارات](../publishing.md)).
- يُوصى بالإحالة إلى القيم الكبيرة كالصور والفيديو بـ URI وSHA-256 بدل وضعها مباشرة.
- المصنفات داخل سلسلة البايتات تخضع لترخيصها الأصلي. يُسجَّل المصدر والترخيص في Meta.

## حزم الصيغ {#형식-묶음}

شرح كل حزمة أدناه. أما تخطيط كل صيغة وتفسيرها وصلاحيتها وأمثلتها ففي مستندها الخاص.

| الحزمة | العائلة | الصيغ |
|---|---|---|
| [numeric](#numeric) | NUMERIC | BOOL، الأعداد الصحيحة، الفاصلة العائمة، الإحداثيات، QUANTITY، FRACTION |
| [decimal](#decimal) | DECIMAL | SIGNED-DECIMAL، UNSIGNED-DECIMAL، IEEE 754 decimal32/64/128 |
| [time](#time) | TIME | التاريخ، الوقت، الأختام الزمنية، الزمن المنقضي، EDTF، تاريخ GEDCOM |
| [text](#text) | TEXT | نص UTF-8، النص الموسوم بلغته، URI، رموز اللغات |
| [binary](#binary) | BINARY | UUID، الملخصات (digest)، CRC، عناوين الشبكة، البايتات المجهولة، متجه البتات |
| [vector](#vector) | NUMERIC | متجهات كثيفة من الأعداد الصحيحة·الحقيقية، النقاط·صناديق الإحاطة، بكسلات RGBA·BGRA |
| [tensor](#tensor) | NUMERIC | تنسورات dense·packed ذات صيغة وrank وshape |
| [etc](#etc) | NUMERIC | الأعداد المركبة، الكسور، المجالات المغلقة، الرباعيات |

- حزم vector وtensor وetc كلها صيغ Issuer (ADHOC وKHRONOS) من عائلة NUMERIC.

### numeric {#numeric}

صيغ الأعداد الأساسية في عائلة NUMERIC. توضع في الرموز المباشرة `0x060L~0x067L`.

- وتشمل BOOL والأعداد الصحيحة الموقّعة وغير الموقّعة والفاصلة العائمة binary في IEEE 754 والإحداثيات على الأرض (WGS 84) والأجرام السماوية، وQUANTITY الذي يجمع الكمية والوحدة والحدود، وFRACTION للكسر بكتابته الأصلية.
- يُكتب العدد الصحيح بأقل عدد من WORD تتسع له القيمة.
- صيغ Issuer للقيم الصغيرة (BFLOAT16 وFP8 وFP4) خُصصت لها أرقام Codec فقط وليست لها مواصفة مفصلة ([Value](#열린-문제) مسائل مفتوحة).
- المتجهات والتنسورات والأعداد المركبة والكسر المختزل (RATIONAL-I64) والمجالات من عائلة NUMERIC أيضاً، لكنها صيغ Issuer فتوضع في حزم [vector](#vector) و[tensor](#tensor) و[etc](#etc).

### decimal {#decimal}

عائلة DECIMAL صيغ الأعداد العشرية الدقيقة. توضع في الرموز المباشرة `0x068L~0x069L`.

- يُكتب SIGNED-DECIMAL وUNSIGNED-DECIMAL المباشران بالشكل `C × 10^E` ويحملان عدد خانات الكتابة الأصلية كما هو. فـ `1.20` (`C=120, E=−2`) و`1.2` (`C=12, E=−1`) سجلان مختلفان. أما تكافؤ القيمتين وحفظ quantum فمسألة مفتوحة في [SIGNED-DECIMAL](0x068L-signed-decimal.md#열린-문제).
- ترميز DPD وBID في IEEE 754 decimal32/64/128 صيغة من Issuer الخاص بـ IEEE (`0x0000000D`).

### time {#time}

عائلة TIME صيغ التاريخ والوقت. توضع في الرموز المباشرة `0x06AL~0x071L` و`0x081L` (DURATION-NANOSECONDS).

| الدقة | الصيغة |
|---|---|
| التاريخ (الغريغوري) | GREGORIAN-DATE |
| السنة·الشهر، وعدم اليقين، والمدى | EDTF |
| الكتابة الأصلية لتقويم آخر (اليولياني وغيره) | GEDCOM-DATE |
| الوقت | أختام POSIX·TAI·GPS الزمنية |
| الزمن المنقضي | DURATION-SECONDS، DURATION-NANOSECONDS |

- التاريخ الذي يمكن كتابته بـ GREGORIAN-DATE لا يُكتب بـ EDTF.
- الختم الزمني بالنانوثانية وصيغتا TAI وGPS صيغ تحت Issuer الهيئات المعيارية (IEEE وBIPM وGPS).

### text {#text}

عائلة TEXT صيغ النصوص ومعرّفات السلاسل. توضع في الرموز المباشرة `0x072L~0x07AL`.

- السلسلة بلا لغة هي UTF8-TEXT، والنص الذي له لغة كالأسماء والعناوين والجمل هو UTF8-LANGUAGE-TEXT.
- رموز اللغات (LANGUAGE-SHORT-CODE وLANGUAGE-BCP47-CODE) من عائلة TEXT أيضاً.
- سلاسل البايتات المتغيرة الطول تُوضع في زوج Codec زوجي/فردي. إن كان أدنى بت `1` فعدد البايتات فردي وبايت آخر WORD الأدنى هو padding بـ `0x00` ([السجل وTAG WORD](../record.md)).

### binary {#binary}

عائلة BINARY صيغ سلاسل البايتات. توضع في الرموز المباشرة `0x07BL~0x080L`.

- UUID وSHA-256 وSHA-1 والبايتات المجهولة (OPAQUE-BYTES) ومتجه البتات (BIT-VECTOR) رموز مباشرة. أما بقية الملخصات وCRC32C وعناوين IPv4·IPv6·MAC فهي صيغ Issuer.
- القيم ذات الحجم الثابت (UUID والملخصات والعناوين) حجمها محدد، فلا يُنشأ لها زوج زوجي/فردي.
- الوسائط العامة كالصور والفيديو توضع كصيغة من Issuer الخاص بـ IANA (`0x00000008`). تُخصَّص أرقام Codec في أزواج زوجي/فردي، وPayload سلسلة بايتات. الحد الأقصى لـ Length هو 2^32−1 WORD. يُوصى بالإحالة إلى القيم الكبيرة بـ URI وSHA-256 بدل وضعها مباشرة.
- المصنفات داخل سلسلة البايتات تخضع لترخيصها الأصلي. يُسجَّل المصدر والترخيص في Meta.

### vector {#vector}

صيغ المتجهات صيغ Issuer من عائلة NUMERIC. المتجهات الكثيفة من الأعداد الصحيحة·الحقيقية والنقاط·صناديق الإحاطة توضع تحت ADHOC (`0x00000002`) بأرقام Codec من `0x00000500` إلى `0x0000050C`، وصيغ البكسلات تحت KHRONOS (`0x0000000E`).

- تُخزَّن عناصر المتجه الكثيف متصلة بترتيب big-endian.
- ولأنها صيغ Issuer يلحق بـ TAG Codec الممتد Issuer بـ 2 WORD ورقم Codec بـ 2 WORD.

### tensor {#tensor}

صيغ التنسورات صيغ Issuer من عائلة NUMERIC. توضع تحت ADHOC (`0x00000002`) بأرقام Codec من `0x00000600` إلى `0x00000601`.

- يحمل DESCRIBED-DENSE-TENSOR صيغة العنصر وrank وshape وpayload كثيفاً بترتيب C-contiguous.
- يحمل DESCRIBED-PACKED-TENSOR صيغة packed وrank وshape وpayload مكدّساً بترتيب low-bit-first داخل octet.

### etc {#etc}

صيغ الأعداد الأخرى صيغ Issuer من عائلة NUMERIC. توضع تحت ADHOC (`0x00000002`) بأرقام Codec من `0x00000700` إلى `0x00000704`.

- وتشمل الأعداد المركبة (COMPLEX64 وCOMPLEX128) والكسر المطبَّع (RATIONAL-I64) والمجال المغلق بـ binary64 والرباعيات بـ binary32.

## النص {#텍스트}

النص الذي له لغة والنص الذي بلا لغة قيمتان مختلفتان. فـ «Paris» (سلسلة) و«Paris» (بالفرنسية) ليستا متساويتين.

| الصيغة | موضع الاستعمال |
|---|---|
| UTF8-TEXT | السلاسل التي لا لغة لها كالمعرّفات والرموز وأسماء الملفات والمعرّفات الخارجية |
| UTF8-LANGUAGE-TEXT | النص الذي له لغة كالأسماء والعناوين والجمل |

```
UTF8-LANGUAGE-TEXT
TAG WORD          0000 0111 100P LLLL   (P = بايتات النص فردية)
[Length ممتد TAG]
اللغة             سجل LANGUAGE-SHORT-CODE أو LANGUAGE-BCP47-CODE
النص              بايتات UTF-8 (إن كان العدد فردياً فآخر بايت 0x00)
```

- النص UTF-8 سليم التكوين ويُحفظ كما في الأصل. ويتولى التطبيع الجهة التي تقارن أو تفهرس.
- الاسم المشترك بين لغات كثيرة يُكتب بلغة `mul`، واللغة غير المحددة `und`. والسلسلة التي بلا محتوى لغوي هي UTF8-TEXT.

مثال: `"Douglas Adams"@en` (13 بايتاً، فردي)

```
0799  0761 656E  446F 7567 6C61 7320 4164 616D 7300
TAG   اللغة en   D o  u g  l a  s ␠  A d  a m  s (padding)
```

## الأعداد العشرية والكميات {#10진수와-수량}

يُكتب العدد العشري الدقيق بالشكل `C × 10^E`. الأس `E` من 32 بت، والمعامل `C` بتكميل الاثنين بأقل عدد من WORD. ويُحمل عدد خانات الكتابة الأصلية كما هو: `1.20` هو `C=120, E=−2`، و`1.2` هو `C=12, E=−1`. الكتابتان تمثلان العدد نفسه لكنهما سجلان منفصلان مختلفا البايتات. ولا يطبّع المرمِّز الكتابة اعتباطاً. أما تكافؤ القيمة بين السجلين ومعنى quantum (الأرقام المعنوية) فمسألة مفتوحة ([SIGNED-DECIMAL](0x068L-signed-decimal.md#열린-문제)).

يحمل QUANTITY الكمية والوحدة والحدود في قيمة واحدة.

```
TAG WORD          0000 0110 0110 LLLL
[Length ممتد TAG]
الكمية            سجل Value عددي (عدد صحيح·BINARY-FLOAT·عدد عشري·كسر)
الوحدة            سجل Reference (بند الوحدة)، وإن لم تكن وحدة فـ 0x0000
الحد الأدنى       سجل Value عددي، وإن حُذف فـ 0x0000 ABSENT
الحد الأعلى       سجل Value عددي، وإن حُذف فـ 0x0000 ABSENT
```

- الوحدة جزء من القيمة. فلا تُفصل وتُكتب في موضع آخر (فبدونها لا يُعرف هل `652` كيلومترات أم أمتار).
- لا تُحمل القيمة المحوّلة إلى وحدات SI. فيمكن حسابها من الوحدة وجدول التحويل.
- `0x0000` علامة ABSENT على حذف الحقل الاختياري ([مستند مواصفة Codec](../codec-spec.md)).

مثال: `652 km`، المدى `[651, 653]` (km = Q828224 في Wikidata)

```
066E 0011                    TAG (طول ممتد 17 WORD)
0683 0000 0000 028C          الكمية 652
0142 000C A340               الوحدة Q828224
0683 0000 0000 028B          الحد الأدنى 651
0683 0000 0000 028D          الحد الأعلى 653
```

## التاريخ {#날짜}

| الدقة | الصيغة |
|---|---|
| التاريخ (الغريغوري) | GREGORIAN-DATE |
| السنة·الشهر، وعدم اليقين (`1971~`)، والمدى | EDTF |
| الكتابة الأصلية لتقويم آخر (اليولياني وغيره) | GEDCOM-DATE |
| الوقت | أختام POSIX·TAI·GPS الزمنية |

- التاريخ الذي يمكن كتابته بـ GREGORIAN-DATE لا يُكتب بـ EDTF.

## مسائل مفتوحة {#열린-문제}

- صيغ الوسائط العامة (JPEG وPNG وMP4 وMOV وغيرها) توضع برقم Codec عند Issuer الخاص بـ IANA (`0x00000008`). طريقة إدارة جدول المطابقة بين نوع الوسائط ورقم Codec.
- القائمة النهائية لرموز Value المباشرة. تُحدَّد بقياس تكرار Value في عينات القوانين ومحادثات العمل (مرشحات: المبالغ والنسب المئوية ومدى التواريخ).
- المواصفة المفصلة وموضع القيم الصغيرة السبع (BFLOAT16 في ADHOC، وأربعة FP8 في ONNX، وFP8-E8M0FNU وFP4-E2M1FN في OCP). لم يُقرَّر نقلها إلى رموز مباشرة. وحالياً خُصصت لها أرقام Codec فقط.
