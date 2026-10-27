---
title: "DIFFERENT-NODE"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DIFFERENT-NODE هو Edge وصف لعدم التطابق: سجلا Reference يشيران إلى هدفين مختلفين (Codec 0x02)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DIFFERENT-NODE هو Edge وصف لعدم التطابق يعني أن سجلَّي Reference يشيران إلى referent مختلفين. Codec `0x02`.

لا يعني أن ترميز byte أو Codec أو معرّف سجلَّي Reference مختلف. ويُميَّز عن الربط الاتجاهي في [REFERENCE-NODE](/ar/grammar/edge/reference-node/) وعن التطابق في [SAME-NODE](/ar/grammar/edge/same-node/).

## التخطيط

```
TAG WORD          0001 0LLL L000 0010
[Length ممتد TAG]
Edge Id           سجل Reference من نوع LOCAL
Subject           سجل Reference واحد
Object            سجل Reference واحد
```

## التفسير والصلاحية

- يجب أن يكون كل من Subject وObject سجل [Reference](/ar/grammar/reference/) كاملاً واحداً بالضبط. تُعرف الحدود بـ Length كل سجل، ويكون invalid إن كان Value أو Edge أو ناقصاً.
- يشير Subject وObject إلى referent مختلفين. ولا يُستنتج اختلاف referent من اختلاف سلسلة byte أو Codec أو المعرّف في سجل Reference وحده.
- وبخاصة، معرّفا [LOCAL](/ar/grammar/reference/local/) المختلفان هما Reference مختلفان فقط، ولا يعني ذلك أن referent الواقعي مختلف. ولا يُستنتج DIFFERENT من اختلاف معرّف LOCAL وحده.
- عدم التطابق متناظر وغير انعكاسي وغير متعدٍّ. فـ `DIFFERENT(A, B)` هي العلاقة نفسها `DIFFERENT(B, A)`. لكن لا يُستنتج `DIFFERENT(A, C)` من `DIFFERENT(A, B)` و`DIFFERENT(B, C)`.
- ترتيب Subject/Object في wire هو ترتيب تسلسل لأجل framing فقط ولا ينشئ اتجاهاً في المعنى. ويجب أن يستطيع التنفيذ البحث في الاتجاهين.
- يجب أن يتطابق المؤشر بعد قراءة المكوّنين مع نهاية Edge تماماً.

العلاقة نفسها غير انعكاسية، لكن لا يجوز محو دعوى `DIFFERENT(A, A)` السليمة بنيوياً ولا الدعاوى التي يتصادم فيها SAME وDIFFERENT على أنها خطأ نحوي في wire. تُحفظ مثل هذه الدعاوى بسياقها ونسبها وتُعالج على أنها تناقض في طبقة الحكم. وعند تفسير DIFFERENT أو استنتاجه تُحفظ مصدر المستند الذي يحمل ذلك الـ Edge ووقته وworld ونطاق policy، ولا يُوسَّع إلى نتيجة عامة تتجاهلها.

## الطول

```
المجموع = 1 + N_len + N_id + N_subject + N_object WORD
```

## أمثلة (غير معيارية)

Edge Id `000a`، وSubject هو LOCAL 1، وObject هو LOCAL 2.

- Edge هو TAG (1) + Edge Id (2) + Subject (2) + Object (2) = 7 WORD، و`LLLL=0110`. وTAG هو `0001 0 0110 0000010` = `1302`.

```
1302 0088 000a 0088 0001 0088 0002
```

اختلاف معرّف LOCAL في هذا المثال لإظهار الترميز فقط. ولا يُجعل هذا التسلسل DIFFERENT-NODE إلا حين توجد دعوى مستقلة بأن المعرّف 1 والمعرّف 2 يشيران إلى referent مختلفين.

## صفحات ذات صلة

- [Edge](/ar/grammar/edge/)، [REFERENCE-NODE](/ar/grammar/edge/reference-node/)، [SAME-NODE](/ar/grammar/edge/same-node/)
- [Reference](/ar/grammar/reference/)، [LOCAL](/ar/grammar/reference/local/)
