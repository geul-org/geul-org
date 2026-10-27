---
title: "LINK"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LINK هو تخطيط يكتب العلاقات بين عقد TOULMIN (الهجوم والإقصاء والتنفيذ وربط الحكم والتعريف والاسم). يتكون من REF المصدر والهدف وWORD flags وبوابة ثقة اختيارية وSPAN."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LINK هو تخطيط يكتب العلاقات بين العقد في رسم TOULMIN. يحدد Codec (أو رقم صيغة GEUL ISSUER) نوع العلاقة.

## Codec

| Codec | الاسم | TANGEUL | src → dst |
|---|---|---|---|
| `0x68` | ATTACKS | `don't X when Y` | قاعدة → قاعدة. ينقص الحكم تدريجياً |
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
flags 1 WORD     b0 F_ONCE، b1 F_GATE، b2 F_STRIKE، b3 F_ORDERED
[F_GATE]         مُعامل (1 WORD، أعلى بتّين) + قيمة UNSIGNED-DECIMAL (نسبة مئوية)
SPAN             العرض الذي يحدده SOURCE × 2
```

| flag | المعنى |
|---|---|
| b0 F_ONCE | يُنفَّذ مرة واحدة (`once` في UNDO) |
| b1 F_GATE | يوجد حقل بوابة الثقة |
| b2 F_STRIKE | علاقة مشطوبة بخط |
| b3 F_ORDERED | تنتمي إلى قائمة مرقمة `1.` |

| مُعامل البوابة | المعنى |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

## التفسير والصلاحية

- REF هو Edge Id لسجل في هذا المستند (الحقول المشتركة في [TOULMIN](/ar/grammar/edge/toulmin/#الحقول-المشتركة)).
- يحدد Codec شكل dst. فـ DO·DO-ONCE·UNDO هو FuncRef (REF(ALIAS، وإن لم يوجد 0) + VerbCode في 1 WORD، [NODE](/ar/grammar/edge/toulmin/node/#الحقول))، وLABEL·IMPORTED-FROM هو REF لسجل TEXT، والباقي REF لعقدة.
- `do … once` يمثله Codec DO-ONCE. ولا يُستخدم F_ONCE في flags الخاصة بـ DO-ONCE (يُرفض إن كان مفعَّلاً). أما `once` في UNDO فيُكتب بـ F_ONCE.
- مُعامل البوابة هو أعلى بتّين من WORD المُعامل، والبتات الـ 14 الباقية أصفار. والنسبة المئوية قيمة UNSIGNED-DECIMAL ذات `E=0` وبين 0 و100.
- البتات b4~b15 في flags محجوزة ويجب أن تكون 0. وإلا رُفض.
- سلسلة `A > B > C` في SUPERSEDES تُكتب بـ SUPERSEDES واحد لكل زوج.

## صفحات ذات صلة

- [TOULMIN](/ar/grammar/edge/toulmin/)، [NODE](/ar/grammar/edge/toulmin/node/)، [SOURCE والأقسام](/ar/grammar/edge/toulmin/source/)
- [UNSIGNED-DECIMAL](/ar/grammar/value/decimal/unsigned-decimal/)
