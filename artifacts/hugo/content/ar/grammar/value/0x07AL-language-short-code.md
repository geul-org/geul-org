---
title: "LANGUAGE-SHORT-CODE (0x07AL)"
weight: 122
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE رمز لغة مضغوط في GEUL يحمل في 1 WORD وسم BCP 47 واحداً خُصص له رقم في GEUL Language Registry."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-SHORT-CODE رمز لغة مضغوط في GEUL يحمل في 1 WORD وسم BCP 47 واحداً خُصص له رقم في GEUL Language Registry.

| البند | القيمة |
|---|---|
| الاسم | `LANGUAGE-SHORT-CODE` (BIND في مستند المواصفة `LANGUAGE-SHORT-CODE`) |
| TAG ID | `0x07AL` |
| Codec ID | `0x000007A0` |
| مستند المواصفة | `0x00000000/codecs/0x000007A0/` (هدف DECLARE `07A0`) |
| القسم | 3 `0011` (Value)، الإزاحة C داخل القسم = 26 |
| Kind | Value · العائلة: TEXT |
| TAG WORD | `0000 0111 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | وسم BCP 47 مكتوب برقم GEUL Language Registry (Payload بـ 1 WORD) |
| جهة Hugo | `value/text/language-short-code.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | قيمة خام بـ 1 WORD |  | ENUM بعدد 8678. أمثلة: `0x0001` aa, `0x0002` aaa, `0x0003` aab, `0x0004` aac, `0x0005` aad … |

LANGUAGE-SHORT-CODE رمز لغة مضغوط في GEUL يحمل في 1 WORD وسم BCP 47 واحداً خُصص له رقم في GEUL Language Registry. Payload هو 1 WORD بالضبط.

## التخطيط {#레이아웃}

- الرمز: رمز مباشر لـ Value هو `0x07AL`. العائلة TEXT.
- Payload رمز غير موقّع من 16 بت في 1 WORD بالضبط.

```
TAG WORD          0x07A1 (0000 0111 1010 0001)  المجموع 2 WORD
Payload WORD 1st (16 بت)           رقم GEUL Language Registry (uint16)
```

## التفسير والصلاحية {#해석과-유효성}

- يُقرأ Payload بـ 1 WORD كعدد صحيح غير موقّع من 16 بت.
- هذه القيمة وسم واحد خصصه GEUL Language Registry. الصيغة الرسمية للـ registry هي مستند مواصفة هذا Codec `0x00000000/codecs/0x000007A0`. لكل قيمة رمز [ENUM](../edge/0x0BDL-enum.md) واحد في FIELD `code`، والاسم المربوط بـ [BIND](../edge/0x0A3L-bind.md) إلى Edge Id ذلك الـ ENUM هو وسم BCP 47 بحالة الأحرف المعيارية.
- الـ registry قائمة مغلقة. القيمة التي لا ENUM لها في مستند المواصفة invalid. وقاعدة هذا الـ Codec مقدَّمة على القاعدة العامة لـ ENUM («قيمة الرمز غير المعلنة ليست خطأ»).
- الأهداف التي يُخصَّص لها رقم ثلاثة.
  - سجلات `Type: language` في IANA Language Subtag Registry باستثناء `Scope: private-use` (`qaa..qtz`). ولا تُستثنى collection وmacrolanguage وspecial (`mul`·`und`·`zxx`·`mis`).
  - الوسوم التي سجلتها IANA كاملة: grandfathered وredundant (`zh-Hans` و`sr-Latn` و`zh-min-nan` وغيرها).
  - وسوم التركيبات الصالحة المرصودة في مصادر CC0 العامة (`pt-BR` و`en-GB` و`be-tarask` وغيرها). وهي وسوم مكونة من subtag من نوع language وextlang وscript وregion وvariant فقط. ولا تُقبل الوسوم التي فيها extension (`-u-`·`-t-`) أو private-use (`-x-`).
- الوسم الذي لا رقم له لا يمكن كتابته بهذه الصيغة. يُكتب بـ [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) (`0x076L`·`0x077L`). ولا مسار escape داخل SHORT-CODE.
- لا يُخصَّص `0x0000` و`0xFFFF` أبداً. وهما في هذا Value invalid. ولا يُستعملان بمعنى `null` ولا `unknown` ولا `und`.
- مديات القيم أعراف تخصيص. ولا يستنتج المفكّك نوع الوسم من مدى القيمة. ولا يأتي معنى القيمة إلا من مستند المواصفة.

| المدى | الاستعمال |
|---|---|
| `0x0000` | غير مخصص (invalid) |
| `0x0001`–`0x3FFF` | وسوم من subtag واحد من نوع language |
| `0x4000`–`0x7FFF` | وسوم من subtag اثنين فأكثر (وسوم IANA الكاملة ووسوم التركيبات المرصودة) |
| `0x8000`–`0xFFFE` | الفائض. يُتابَع التخصيص هنا إذا امتلأت الكتل أعلاه |
| `0xFFFF` | غير مخصص (invalid) |

- في الإصدار الأول تُعطى الأرقام داخل الكتلة بترتيب ASCII للوسم بأحرف صغيرة. وفي كتلة `0x4000` تأتي وسوم IANA الكاملة (بترتيب ASCII مع خلط grandfathered وredundant) ثم وسوم التركيبات المرصودة (بترتيب ASCII). الترتيب الفيزيائي لملف IANA وتكرار الاستعمال ليسا قاعدة ترقيم.
- التخصيص بالإلحاق فقط (append-only). تُلحق الوسوم الجديدة بنهاية الكتلة، وإذا امتلأت الكتلة تُلحق بمدى الفائض. ولا يتغير وسم الرقم الذي أُعطي (دون تمييز حالة الأحرف)، ولا يُحذف الرقم ولا يُعاد استعماله.
- تُضاف الوسوم الجديدة بإلحاق ENUM وBIND في إصدار جديد من مستند المواصفة. ولا يُعدَّل ENUM وBIND القائمان. فكل إصدار مجموعة شاملة للإصدار الذي قبله.
- إذا امتلأت الأرقام الـ 65,534 كلها لم يُخصَّص مزيد. وتُكتب الوسوم الجديدة بعد ذلك بـ LANGUAGE-BCP47-CODE. فلا تنقص القدرة التعبيرية، وإنما يغيب كسب الضغط فقط.
- اللغة نفسها: SHORT-CODE `n` ووسم LANGUAGE-BCP47-CODE الذي يربطه الـ registry بـ `n` (دون تمييز حالة الأحرف) هما اللغة نفسها.
- إصدار الـ registry هو إصدار مستند المواصفة. يدوّن كل إصدار ملف IANA registry الذي استند إليه (File-Date وSHA-256) في [SOURCE](../edge/0x0C0L-source.md) على HEAD في مستند المواصفة. وعند الحاجة إلى بيان الإصدار الذي فُسِّرت به القيمة يُبقى معها ذلك الإصدار [CODEC-POINTER](../reference/0x042L-codec-pointer.md) (`0x00000000` و`0x000007A0` ومعرّف الإصدار `n`).
- يجوز لمواصفة Codec أن تحمل رمز الـ WORD الواحد نفسه في حقل قيمة خام بلا TAG (الـ [CODEC](../codec-spec.md#codec) في حقل القيمة الخام). وهذه قاعدة مواصفة ذلك الـ Codec، أما wire form لـ Value المستقل فهو دائماً TAG بـ 1 WORD ثم Payload بـ 1 WORD.

## المرجع المعياري {#표준-근거}

- يتبع معنى الوسم وصلاحية subtag كلاً من [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry) و[RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646). وتضع IANA وIETF حقوقهما في registry البروتوكولات تحت CC0 1.0 ([IANA Licensing Terms](https://www.iana.org/help/licensing-terms)).
- من قواعد GEUL: أرقام الـ registry (تخصيص append-only بترتيب ASCII، وتكوين الكتل، وعدم تخصيص `0x0000` و`0xFFFF`، والقائمة المغلقة)، وكون ENUM في مستند المواصفة هو الصيغة الرسمية، والتمييز عن التضمين في حقل القيمة الخام بلا TAG.

## الطول {#길이}

- المجموع هو TAG بـ 1 WORD مع Payload بـ 1 WORD أي 2 WORD بالضبط، ويستعمل الطول المباشر `LLLL=0001`. لا TAG Length ممتد ولا descriptor ولا padding.
- يُرفض إن لم يكن Payload 1 WORD بالضبط.

## مثال {#예시}

هذه أرقام الـ registry v2 (الإصدار 2 من مستند المواصفة `0x00000000/codecs/0x000007A0`، وIANA File-Date 2026-09-17). خُصص 8,678 رقماً (language 8,275، وgrandfathered 26، وredundant 67، وتركيبات مرصودة 310).

| الوسم | الرمز | مجموع WORD |
|---|---|---|
| `en` | `0x0784` | `07A1 0784` |
| `ko` | `0x0D06` | `07A1 0D06` |
| `zh-Hans` | `0x404C` | `07A1 404C` |
| `pt-BR` | `0x4130` | `07A1 4130` |

- في مستند المواصفة `en` هو `ENUM #2 0x0784` و`BIND "en"` المربوط بـ Edge Id ذلك الـ ENUM.
- `de-x-formal` (private-use) و`nl-u-sd-bebru` (extension) لا رقم لهما، فيُكتبان بـ LANGUAGE-BCP47-CODE.

## مسائل مفتوحة {#열린-문제}

- التفسير بين الإصدارات: إذا صادف القارئ رقماً أحدث من إصداره، فهل يُهمَل كـ invalid أم يُعامل كـ«رمز مجهول» مع حفظ القيمة الأصلية. بما أن الـ registry append-only فإصدار واحد حديث يكفي دائماً، لكن المفكّكات غير المتصلة تحتاج إلى قاعدة.
- الصيغة المعيارية: هل يجب (SHOULD/MUST) كتابة الوسم الذي له رقم بـ SHORT-CODE. إن كان MUST استقر شكل الكتابة على واحد، لكن المستندات المكتوبة قبل صدور إصدار جديد تفقد صيغتها المعيارية.
- طريقة إظهار الوسوم المهجورة (deprecated) وPreferred-Value في مستند المواصفة (ليست في الإصدار الحالي).
- إجراء إلحاق وسوم التركيبات المرصودة (المصدر وحد الرصد الأدنى).

## صفحات ذات صلة {#관련-페이지}

- [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md)، [UTF8-LANGUAGE-TEXT](0x078L-utf8-language-text.md)، [LABEL](../edge/0x0A4L-label.md)
- [مستند مواصفة Codec](../codec-spec.md)، [ENUM](../edge/0x0BDL-enum.md)، [BIND](../edge/0x0A3L-bind.md)، [SOURCE](../edge/0x0C0L-source.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x000007A0/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007A000000000
#17368 SOURCE #0 #17362
#17369 QUALIFIER P577 #17368 GREGORIAN-DATE(2026-09-17)
#17370 QUALIFIER P813 #17368 GREGORIAN-DATE(2026-10-29)
#17371 QUALIFIER P4092 #17368 SHA-256-DIGEST(0x755FAD43283BE7B41EBE3C89AD054B6EAF928F404F9C0EDB74799E0EAB74BEB1)
#17372 SOURCE #0 Q2013
#17373 QUALIFIER P813 #17372 GREGORIAN-DATE(2026-10-29)
BODY
#1 DECLARE 0x07A0
#2 FIELD #1 0x0001
#3 BIND #1 "LANGUAGE-SHORT-CODE"
#4 BIND #2 "code"
#5 ENUM #2 0x0001
#6 BIND #5 "aa"
#7 ENUM #2 0x0002
#8 BIND #7 "aaa"
#9 ENUM #2 0x0003
#10 BIND #9 "aab"
#11 ENUM #2 0x0004
#12 BIND #11 "aac"
#13 ENUM #2 0x0005
#14 BIND #13 "aad"
… (حُذف 17346 سطراً من ENUM وBIND)
#17361 REFERENCE-NODE #17362 <https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry>
#17363 TRIPLE P275 #17362 Q6938433 normal
#17364 REFERENCE-NODE #17365 <https://www.iana.org/help/licensing-terms>
#17366 SOURCE #17363 #17365
#17367 QUALIFIER P813 #17366 GREGORIAN-DATE(2026-10-29)
```
