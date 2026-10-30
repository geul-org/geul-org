---
title: "LINK"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-31T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LINK هو تخطيط يكتب العلاقات بين عقد TOULMIN (الهجوم والإقصاء والتنفيذ وربط الحكم والتعريف والاسم). يتكون من REF المصدر والهدف وWORD flags وبوابة ثقة اختيارية وشدة هجوم اختيارية وSPAN."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LINK هو تخطيط يكتب العلاقات بين العقد في رسم TOULMIN. يحدد Codec (أو رقم صيغة GEUL ISSUER) نوع العلاقة.

## Codec

| Codec | الاسم | TANGEUL | src → dst |
|---|---|---|---|
| `0x68` | ATTACKS | `don't X when Y` | قاعدة → قاعدة. ينقص الحكم تدريجياً بقدر شدة الهجوم |
| `0x69` | SUPERSEDES | `X supersedes Y` | قاعدة → قاعدة. إذا كانت Active أخرجت الهدف من التجميع |
| `0x70` | RUN | `run c when n` | قاعدة → قضية |
| `0x71` | DO | `do fn when n` | قاعدة → FuncRef |
| `0x72` | DO-ONCE | `do fn once when n` | قاعدة → FuncRef |
| `0x73` | UNDO | `undo fn when n` | قاعدة → FuncRef |
| `0x74` | CHECKING | `checking c` | قاعدة → قضية. حكم بلا آثار جانبية |
| ISSUER `0x0000`/`0xC020` | REQUIRES | `f is required` | قضية → حقل |
| ISSUER `0x0000`/`0xC021` | MEANS | `means` في Definitions | بند تعريف → قيمة أو نوع |
| ISSUER `0x0000`/`0xC022` | HAS | `has` في Definitions | بند تعريف → حقل |
| ISSUER `0x0000`/`0xC023` | RUNS | `run c` في نقطة دخول | نقطة دخول → قضية (تنفيذ) |
| ISSUER `0x0000`/`0xC024` | EVALUATES | `check c` في نقطة دخول | نقطة دخول → قضية (حكم) |
| ISSUER `0x0000`/`0xC025` | TRIGGERS | `run c` في محفّز | محفّز → قضية |
| ISSUER `0x0000`/`0xC026` | UNTIL | `every … until c` | محفّز → قضية |
| ISSUER `0x0000`/`0xC027` | SAME-AS | | عقدة → معرّف عام |
| ISSUER `0x0000`/`0xC028` | IMPORTED-FROM | `see a from path` | كنية → مسار (TEXT) |
| ISSUER `0x0000`/`0xC029` | LABEL | اسم بين علامتي backtick | عقدة → TEXT. كتابة الاسم |

## التخطيط

```
ID               سجل Reference من نوع LOCAL (Edge Id)
src              REF
dst              REF. وفي DO·DO-ONCE·UNDO هو FuncRef
flags 1 WORD     b0 F_ONCE، b1 F_GATE، b2 F_STRIKE، b3 F_ORDERED، b4 F_FORCE
[F_GATE]         مُعامل (1 WORD، أعلى بتّين) + قيمة UNSIGNED-DECIMAL (نسبة مئوية)
[F_FORCE]        Value من SIGNED-DECIMAL. شدة الهجوم (0~1). لـ ATTACKS فقط
SPAN             العرض الذي يحدده SOURCE × 2
```

| flag | المعنى |
|---|---|
| b0 F_ONCE | يُنفَّذ مرة واحدة (`once` في UNDO) |
| b1 F_GATE | يوجد حقل بوابة الثقة |
| b2 F_STRIKE | علاقة مشطوبة بخط |
| b3 F_ORDERED | تنتمي إلى قائمة مرقمة `1.` |
| b4 F_FORCE | يوجد حقل شدة الهجوم. لـ ATTACKS فقط |

| مُعامل البوابة | المعنى |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

- توضع الحقول الشرطية بترتيب flags (F_GATE ثم F_FORCE). الحقل الذي flag الخاص به مطفأ لا يشغل مكاناً.

## شدة الهجوم

شدة الهجوم (Force) تبيّن مدى شدة هجوم حافة ATTACKS واحدة على هدفها. مداها 0~1، وتساوي 1 عند غياب F_FORCE.

- في الحكم تُضرب مساهمة `(v+1)/2` لقيمة حكم المهاجم v في الشدة F. يدخل هجوم الدحض (COUNTER) حدَّ المقام بصيغة `F·(v+1)/2`، ويدخل هجوم الاستثناء (EXCEPT) البوابة `Π(1 − F·(v+1)/2)`. وإذا كانت F تساوي 0 فلا أثر للهجوم في الحكم.
- تتبع القيمة قواعد الأعداد في [TOULMIN](/ar/grammar/edge/toulmin/#القيم-العددية). يحذف المُرمِّز الأصفار في آخر المعامل (0.5 هي `C=5, E=−1`، و1.0 هي `C=1, E=0`). ويقبل فاك الترميز حتى 4 منازل عشرية.
- السطح الذي لا يكتب الشدة (`don't X when Y`، وبالكورية `` `Y` 면 `X` 는 무효다``) يطفئ F_FORCE.
- السطح الذي يكتب الشدة (بالكورية `` `Y` 면 `X` 를 0.5의 세기로 공격한다``) يشعل F_FORCE ويحمل القيمة. وحتى إذا كُتبت 1 كما في `1.0의 세기로` يُشعَل F_FORCE ويحمل 1. وبذلك يعود سطح النص الأصلي كما هو.
- شدة الهجوم محور مختلف عن قوة العقدة (Strict وDefeasible وDefeater). القوة تخص العقدة، وشدة الهجوم تخص حافة ATTACKS.

### مثال

`` `Y` 면 `X` 를 0.5의 세기로 공격한다``. Edge Id 5، والمهاجم Y هو Edge Id 3، والهدف X هو Edge Id 2، وعرض SPAN هو 1 WORD.

```
16E8                  TAG WORD: Edge، المجموع 14 WORD، Codec 0x68 (ATTACKS)
0088 0005             ID      LOCAL 5
0088 0003             src     LOCAL 3 (Y, المهاجم)
0088 0002             dst     LOCAL 2 (X, الهدف)
0010                  flags   F_FORCE
0990 FFFF FFFF 0005   F_FORCE SIGNED-DECIMAL, E=−1, C=5 (0.5)
0040 001A             SPAN    بايت البداية 0x40، عدد البايتات 0x1A
```

الحافة نفسها بلا شدة قيمة flags فيها `0000` ولا حقل F_FORCE فيها. وTAG WORD الخاص بها `14E8` (المجموع 10 WORD).

## التفسير والصلاحية

- REF هو Edge Id لسجل في هذا المستند (الحقول المشتركة في [TOULMIN](/ar/grammar/edge/toulmin/#الحقول-المشتركة)).
- يحدد Codec شكل dst. فـ DO·DO-ONCE·UNDO هو FuncRef (REF(ALIAS، وإن لم يوجد 0) + VerbCode في 1 WORD، [NODE](/ar/grammar/edge/toulmin/node/#الحقول))، وLABEL·IMPORTED-FROM هو REF لسجل TEXT، والباقي REF لعقدة.
- `do … once` يمثله Codec DO-ONCE. ولا يُستخدم F_ONCE في flags الخاصة بـ DO-ONCE (يُرفض إن كان مفعَّلاً). أما `once` في UNDO فيُكتب بـ F_ONCE.
- مُعامل البوابة هو أعلى بتّين من WORD المُعامل، والبتات الـ 14 الباقية أصفار. والنسبة المئوية قيمة UNSIGNED-DECIMAL ذات `E=0` وبين 0 و100.
- البتات b5~b15 في flags محجوزة ويجب أن تكون 0. وإلا رُفض.
- لا يُستعمل F_FORCE إلا في ATTACKS. وإذا كان مشعلاً في Codec آخر (SUPERSEDES، وروابط التنفيذ والحكم، وعلاقات صيغة ISSUER) رُفض.
- إذا لم تكن شدة الهجوم Value من SIGNED-DECIMAL، أو خرجت عن 0~1، أو تعذّر كتابتها بدقة بأربع منازل عشرية، رُفضت.
- سلسلة `A > B > C` في SUPERSEDES تُكتب بـ SUPERSEDES واحد لكل زوج.

## صفحات ذات صلة

- [TOULMIN](/ar/grammar/edge/toulmin/)، [NODE](/ar/grammar/edge/toulmin/node/)، [SOURCE والأقسام](/ar/grammar/edge/toulmin/source/)
- [UNSIGNED-DECIMAL](/ar/grammar/value/decimal/unsigned-decimal/), [SIGNED-DECIMAL](/ar/grammar/value/decimal/signed-decimal/)
