---
title: "LANGUAGE-SHORT-CODE"
weight: 73
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE قيمة Value لرمز لغة في GEUL تحمل في 1 WORD وسم BCP 47 واحداً أعطاه GEUL Language Registry رقماً (Codec 0x48). والسجل هو عناصر ENUM في مستند مواصفة هذا الـ Codec."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-SHORT-CODE رمز لغة مضغوط في GEUL يحمل في 1 WORD وسم BCP 47 واحداً له رقم في GEUL Language Registry. Payload هو 1 WORD تماماً.

## التخطيط

- الرمز: رمز Value مباشر `0x48`. العائلة TEXT.
- Payload هو 1 WORD تماماً، رمز unsigned بطول 16 بت.

```
TAG WORD          0x08C8 (0000 1000 1100 1000)  المجموع 2 WORD
Payload WORD 1st (16 بت)           رقم GEUL Language Registry (uint16)
```

## التفسير والصلاحية

- يُقرأ WORD الخاص بـ Payload عدداً صحيحاً unsigned بطول 16 بت.
- هذه القيمة وسم واحد خصّصه GEUL Language Registry. الصورة الرسمية للسجل هي مستند مواصفة هذا الـ Codec ‏`0x0000/0x0000000000000848`. لكل قيمة رمز [ENUM](/ar/grammar/edge/enum/) واحد على FIELD ‏`code`، والاسم المربوط بـ Edge Id ذلك الـ ENUM عبر [BIND](/ar/grammar/edge/bind/) هو وسم BCP 47 بحالة الأحرف القياسية.
- السجل قائمة مغلقة. القيمة التي ليس لها ENUM في مستند المواصفة invalid. وتتقدّم قاعدة هذا الـ Codec على قاعدة ENUM العامة («قيمة الرمز غير المعلنة ليست خطأ»).
- تُخصَّص الأرقام لثلاثة أنواع من الوسوم.
  - سجلات `Type: language` في IANA Language Subtag Registry ما عدا `Scope: private-use` ‏(`qaa..qtz`). ولا تُستبعد collection وmacrolanguage وspecial ‏(`mul`·`und`·`zxx`·`mis`).
  - الوسوم التي تسجّلها IANA كاملة: grandfathered وredundant ‏(`zh-Hans` و`sr-Latn` و`zh-min-nan` وغيرها).
  - الوسوم المركّبة الصالحة المرصودة في مصادر CC0 عامة (`pt-BR` و`en-GB` و`be-tarask` وغيرها). وهي لا تتكوّن إلا من subtag من نوع language وextlang وscript وregion وvariant. ولا تُقبل الوسوم التي فيها extension ‏(`-u-`·`-t-`) أو private-use ‏(`-x-`).
- لا يمكن كتابة وسم بلا رقم بهذه الصيغة، بل يُكتب بصيغة [LANGUAGE-BCP47-CODE](/ar/grammar/value/text/language-bcp47-code/) ‏(`0x46`·`0x47`). ولا يوجد في SHORT-CODE مسار escape.
- لا يُخصَّص `0x0000` ولا `0xffff` أبداً. وكلاهما invalid في هذه الـ Value. ولا يُستعمل أيّ منهما بمعنى `null` أو `unknown` أو `und`.
- نطاقات القيم عُرف في التخصيص. لا يستنتج المفكّك نوع الوسم من نطاق القيمة. ومعنى القيمة يأتي من مستند المواصفة وحده.

| النطاق | الاستعمال |
|---|---|
| `0x0000` | لا يُخصَّص (invalid) |
| `0x0001`–`0x3fff` | وسوم من language subtag واحدة |
| `0x4000`–`0x7fff` | وسوم من subtag اثنتين فأكثر (وسوم IANA الكاملة، والوسوم المركّبة المرصودة) |
| `0x8000`–`0xfffe` | فائض. إذا امتلأت كتلة أعلاه يستمر التخصيص هنا |
| `0xffff` | لا يُخصَّص (invalid) |

- يرقّم الإصدار الأول الوسوم داخل كل كتلة بترتيب ASCII للأحرف الصغيرة. في كتلة `0x4000` تأتي أولاً وسوم IANA الكاملة (grandfathered وredundant مختلطة بترتيب ASCII)، ثم الوسوم المركّبة المرصودة (بترتيب ASCII). ليس الترتيب الفعلي لملف IANA ولا تكرار الاستعمال قاعدةً للترقيم.
- التخصيص إضافة فقط (append-only). يُضاف الوسم الجديد في آخر كتلته، فإن امتلأت ففي نطاق الفائض. ولا يُغيَّر وسم رقمٍ أُعطي مرة (دون تمييز حالة الأحرف) ولا يُحذف ولا يُعاد استعماله.
- يدخل الوسم الجديد بإضافة ENUM وBIND في إصدار جديد من مستند المواصفة. ولا تُعدَّل عناصر ENUM وBIND القائمة. لذلك فكل إصدار مجموعة شاملة للإصدار الذي قبله.
- إذا استُنفدت الأرقام الـ 65,534 كلها فلا يُخصَّص شيء بعدها. وتُكتب الوسوم الجديدة اللاحقة بصيغة LANGUAGE-BCP47-CODE. لا تنقص القدرة التعبيرية، وإنما يضيع ربح الضغط فقط.
- اللغة نفسها: SHORT-CODE ‏`n` وLANGUAGE-BCP47-CODE للوسم الذي يربطه السجل بـ `n` (دون تمييز حالة الأحرف) هما اللغة نفسها.
- إصدار السجل هو إصدار مستند المواصفة. ويسجّل كل إصدار ملف سجل IANA الذي بُني عليه (File-Date وSHA-256) بوصفه [SOURCE](/ar/grammar/edge/source/) في HEAD مستند المواصفة. وإذا لزم بيان الإصدار الذي فُسّرت به قيمة ما، يُحفظ ذلك الإصدار (`0x0000/0x0000000000000848@n`) معها.
- يجوز لمواصفة Codec أن تحمل رمز 1 WORD نفسه في حقل قيمة خام بلا TAG (‏[CODEC](/ar/grammar/codec-spec/#codec) لحقل القيمة الخام). وهذه قاعدة تلك المواصفة، أما wire form للـ Value المستقلة فهي دائماً TAG ‏1 WORD + Payload ‏1 WORD.

## السند المعياري

- يتبع معنى الوسوم وصلاحية الـ subtag كلاً من [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry) و[RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646). وتضع IANA وIETF حقوقهما في سجلات البروتوكولات تحت CC0 1.0 ‏([IANA Licensing Terms](https://www.iana.org/help/licensing-terms)).
- أرقام السجل (التخصيص append-only بترتيب ASCII، وتقسيم الكتل، وعدم تخصيص `0x0000` و`0xffff`، والقائمة المغلقة)، وكون عناصر ENUM في مستند المواصفة هي الصورة الرسمية، والتمييز عن التضمين بلا TAG في حقل قيمة خام، كلها قواعد GEUL.

## الطول

- المجموع 2 WORD تماماً: TAG ‏1 WORD وPayload ‏1 WORD، بطول مباشر `LLLL=0001`. لا يوجد TAG ممتد للـ Length ولا descriptor ولا padding.
- إن لم يكن Payload هو 1 WORD تماماً يُرفض.

## أمثلة

هذه أرقام السجل v2 (مستند المواصفة `0x0000/0x0000000000000848` الإصدار 2، وIANA File-Date ‏2026-09-17). خُصّص فيه 8,678 وسماً (language ‏8,275، grandfathered ‏26، redundant ‏67، مركّبة مرصودة 310).

| الوسم | الرمز | كل WORD |
|---|---|---|
| `en` | `0x0784` | `08C8 0784` |
| `ko` | `0x0d06` | `08C8 0D06` |
| `zh-Hans` | `0x404c` | `08C8 404C` |
| `pt-BR` | `0x4130` | `08C8 4130` |

- في مستند المواصفة، `en` هو `ENUM #2 0x0784` و`BIND "en"` على Edge Id الخاص به.
- ليس لـ `de-x-formal` ‏(private-use) ولا لـ `nl-u-sd-bebru` ‏(extension) رقم، فيُكتبان بصيغة LANGUAGE-BCP47-CODE.

## مسائل مفتوحة

- القراءة بين الإصدارات: هل يُطرح الرقم الأحدث من إصدار القارئ بوصفه invalid، أم يُحفظ بقيمته الخام «رمزاً غير معروف»؟ ولأن التخصيص append-only فالإصدار الأحدث كافٍ دائماً، لكن المفكّكات غير المتصلة تحتاج إلى قاعدة.
- الصورة القياسية: هل يجب (SHOULD/MUST) كتابة الوسم الذي له رقم بصيغة SHORT-CODE؟ مع MUST تتوحّد الكتابة، لكن صدور إصدار جديد يجعل المستندات المكتوبة قبله غير قياسية.
- طريقة التعبير عن الوسوم deprecated وPreferred-Value في مستند المواصفة (لا وجود لها في الإصدار الحالي).
- إجراء إضافة الوسوم المركّبة المرصودة (المصادر، وحدّ الرصد الأدنى).

## صفحات ذات صلة

- [LANGUAGE-BCP47-CODE](/ar/grammar/value/text/language-bcp47-code/)، [UTF8-LANGUAGE-TEXT](/ar/grammar/value/text/utf8-language-text/)، [LABEL](/ar/grammar/edge/label/)
- [مواصفة Codec](/ar/grammar/codec-spec/)، [ENUM](/ar/grammar/edge/enum/)، [BIND](/ar/grammar/edge/bind/)، [SOURCE](/ar/grammar/edge/source/)
