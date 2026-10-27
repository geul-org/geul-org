---
title: "NODE"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "NODE هو تخطيط يكتب عقد رسم TOULMIN (القضية والقاعدة والتعريف ونقطة الدخول والمحفّز والدالة والحقل والكنية والحزمة). علامات flag في ترويسة من 1 WORD تحدد الحقول الشرطية التي تتبعها."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NODE هو تخطيط يكتب عقد رسم الحكم والتنفيذ في TOULMIN. يحدد Codec (أو رقم صيغة GEUL ISSUER) نوع العقدة، وتحدد ترويسة من 1 WORD الدور وLevel وشكل Claim والحقول الشرطية.

## Codec

| Codec | الاسم | TANGEUL | العقدة |
|---|---|---|---|
| `0x60` | CASE-DECLARE | `in case of` | قضية |
| `0x62` | SPEC-DECLARE | بند في Definitions (`means` و`has`) | معيار الحكم (Backing). role هو نوع التعريف |
| `0x63` | RULE-DECLARE | general rule | دعوى (Warrant) |
| `0x64` | COUNTER-DECLARE | counter rule | دحض (Rebuttal) |
| `0x65` | EXCEPT-DECLARE | except rule | استثناء (Defeater) |
| `0x75` | ENTRY | `provides x` | نقطة دخول خارجية |
| `0x76` | TRIGGER | `on` و`every` و`until` | نقطة دخول لحدث أو دورة |
| ISSUER `0x0000`/`0xC010` | NAMESPACE | `this document is` | فضاء أسماء المستند |
| ISSUER `0x0000`/`0xC011` | FUNC | إشارة إلى دالة | دالة خارجية (مثل `bank.withdraw`) |
| ISSUER `0x0000`/`0xC012` | FIELD | `x is required [as Type]` | حقل إلزامي |
| ISSUER `0x0000`/`0xC013` | ALIAS | `see a from path` | كنية حزمة مستوردة |
| ISSUER `0x0000`/`0xC014` | GROUP | قائمة مرقمة `1.` | حزمة تنفيذ مرتبة |

تضع صيغة ISSUER في Codec ممتد TAG، بعد `ISSUER-1WORD` (`0x7C`)، الرقم Issuer `0x0000` ثم رقم الصيغة ([TOULMIN](/ar/grammar/edge/toulmin/)).

## التخطيط

```
ID               سجل Reference من نوع LOCAL (Edge Id)
ترويسة 1 WORD    role 2b | محجوز 2b | F_GROUNDS 1b | level 2b | نوع object 2b | flags 7b
[F_FUNC]         FuncRef: REF(ALIAS، وإن لم يوجد 0) + VerbCode في 1 WORD
[F_QUAL]         قيمة SIGNED-DECIMAL. Qualifier
[F_CHECK]        REF(قضية)
[F_CLAIM]        Claim: REF(subject) + predicate في 1 WORD + object + mode في 1 WORD
[F_VERDICT]      قيمة SIGNED-DECIMAL. القيمة الأولية للحكم
[F_WITH]         العدد (قيمة UNSIGNED-INTEGER) + REF(TEXT) × العدد
[F_GROUNDS]      العدد (قيمة UNSIGNED-INTEGER) + REF(TEXT) × العدد
SPAN             العرض الذي يحدده SOURCE × 2 (بايت البداية وعدد البايتات)
```

### WORD الترويسة

| البتات | الحقل | القيمة |
|---|---|---|
| 15–14 | role | 0 general، 1 counter، 2 except |
| 13–12 | محجوز | 0 |
| 11 | F_GROUNDS | توجد قائمة أدلة |
| 10–9 | level | 0 Unset، 1 Fail، 2 Review (3 محجوز) |
| 8–7 | نوع object | شكل object في Claim. 0 REF، 1 قيمة UNSIGNED-INTEGER، 2 SPAN |
| 6–0 | flags | الجدول أدناه |

| البت | flag | المعنى |
|---|---|---|
| b0 | F_FUNC | يوجد حقل FuncRef |
| b1 | F_QUAL | يوجد حقل Qualifier |
| b2 | F_CHECK | يوجد حقل القضية الهدف لـ `checking` |
| b3 | F_CLAIM | يوجد حقل Claim |
| b4 | F_VERDICT | يوجد حقل القيمة الأولية للحكم |
| b5 | F_STRIKE | تصريح مشطوب بخط. لا حقل له |
| b6 | F_WITH | يوجد حقل قائمة المعايير |

- توضع الحقول الشرطية بترتيب flag (F_FUNC وF_QUAL وF_CHECK وF_CLAIM وF_VERDICT وF_WITH وF_GROUNDS). والحقل الذي أُطفئ flag الخاص به لا يشغل موضعاً.
- يُرفض إذا كان flag مفعَّلاً ولا حقل له. ويجب أن يتطابق الموضع الذي بلغته قراءة الحقول بالترتيب بعد SPAN مع نهاية السجل تماماً.

## الحقول

| الحقل | الوصف |
|---|---|
| FuncRef | موضع الدالة. REF هو سجل ALIAS الذي استورد تلك الدالة، وإن كانت دالة هذا المستند فهو `0`. VerbCode رمز في 1 WORD لم يُخصَّص بعد (`0x0000` مسموح). والكتابة الأصلية لاسم الدالة تُكتب على حدة بـ TEXT + [LABEL](/ar/grammar/edge/toulmin/link/) |
| Qualifier | ثقة العقدة (0~1) |
| قضية | F_CHECK: القضية التي تحكم فيها هذه العقدة فقط (`checking c`) |
| Claim | القضية التي تحملها العقدة. subject REF وpredicate في 1 WORD وobject وmode في 1 WORD. ويحدد نوع object في الترويسة شكل object |
| قيمة الحكم | القيمة الأولية لقيمة الحكم (−1~1) |
| F_WITH | معيار الحكم وقت التصريح (`기준으로 하는`، "بمعيار"). قائمة REF لسجلات TEXT |
| F_GROUNDS | أسماء الحقائق الخارجية التي تُفسَّر وقت التقييم (`근거로 하는`، "بدليل"). قائمة REF لسجلات TEXT |
| SPAN | نطاق النص الأصلي الذي جاء منه هذا التصريح |

- تكتب قيمة الحكم وQualifier بقواعد القيم العددية في [TOULMIN](/ar/grammar/edge/toulmin/#القيم-العددية).
- عدد القائمة هو سجل Value مضمّن من [UNSIGNED-INTEGER](/ar/grammar/value/numeric/unsigned-integer/).
- الشكل الأساسي لـ Claim الوصفي هو أن subject وpredicate يساويان `0` وobject هو SPAN (نوع object 2). فيُثبَّت على الكتابة الأصلية.

## التفسير والصلاحية

- يجب أن يطابق role الخاص بـ Codec في RULE-DECLARE وCOUNTER-DECLARE وEXCEPT-DECLARE (0 general و1 counter و2 except). وفي SPEC-DECLARE هو نوع التعريف. وفي بقية Codec هو 0.
- إذا كان level يساوي 0 (Unset) استُخدمت القيمة الافتراضية للمحرك: Fail لـ COUNTER-DECLARE وReview لـ EXCEPT-DECLARE.
- قاعدة دالة المضيف في `tangl:규칙` ("القاعدة") في TANGEUL (`쓰는 규칙이다`، "تستخدم القاعدة") تُكتب بـ NODE من RULE-DECLARE خارج القضية. الدالة بـ F_FUNC والمعيار بـ F_WITH والدليل بـ F_GROUNDS. وقاعدة تعبير الشرط فقط يوضع قبلها [PREDICATE-DECLARE](/ar/grammar/edge/toulmin/expr/).
- يجب أن تكون البتات المحجوزة (13–12) صفراً. ويُرفض إذا فُعّلت بتة محجوزة أو لم يطابق role الخاص بـ Codec.

## صفحات ذات صلة

- [TOULMIN](/ar/grammar/edge/toulmin/)، [LINK](/ar/grammar/edge/toulmin/link/)، [EXPR](/ar/grammar/edge/toulmin/expr/)، [SOURCE والأقسام](/ar/grammar/edge/toulmin/source/)
- [LOCAL](/ar/grammar/reference/local/)، [SIGNED-DECIMAL](/ar/grammar/value/decimal/signed-decimal/)
