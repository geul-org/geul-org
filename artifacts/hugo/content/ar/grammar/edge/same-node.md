---
title: "SAME-NODE"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SAME-NODE هو Edge وصف للتطابق بلا اتجاه يصرّح بأن سجلَّي Reference يشيران إلى الهدف نفسه (Codec 0x01)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SAME-NODE هو Edge وصف للتطابق بلا اتجاه يصرّح بأن سجلَّي Reference يشيران إلى referent واحد. Codec `0x01`.

لا يعني أن ترميز byte أو Codec أو معرّف سجلَّي Reference متطابق. وخلافاً لـ [REFERENCE-NODE](/ar/grammar/edge/reference-node/) الذي هو ربط اتجاهي `Reference → سجل`، يمثل SAME-NODE التطابق المرجعي (referential identity) بين سجلَّي Reference.

## التخطيط

```
TAG WORD          0001 0LLL L000 0001
[Length ممتد TAG]
Edge Id           سجل Reference من نوع LOCAL
Subject           سجل Reference واحد
Object            سجل Reference واحد
```

## التفسير والصلاحية

- يُسلسَل Subject وObject بهذا الترتيب، ويجب أن يكون كل منهما سجل [Reference](/ar/grammar/reference/) كاملاً واحداً بالضبط. تُعرف الحدود بـ Length كل سجل.
- يكون invalid إذا كان Subject أو Object سجل Value أو Edge أو سجلاً ناقصاً.
- علاقة SAME-NODE انعكاسية ومتناظرة ومتعدية. وترتيب Subject/Object في wire لأجل framing ولا ينشئ اتجاهاً في المعنى. ويجب أن يستطيع التنفيذ البحث في هذه العلاقة في الاتجاهين.
- معرّفا [LOCAL](/ar/grammar/reference/local/) المختلفان هما Reference مختلفان فقط، وليسا دليلاً على أن referent متطابق أو مختلف. وكون سجلَّي Reference يشيران إلى referent واحد يُبيَّن بـ SAME-NODE.
- يجب أن يحفظ التفسير والاستدلال مصدر المستند الذي يحمل ذلك الـ Edge ورسم الحكم ووقته وworld ونطاق policy. ولا يُستخدم SAME-NODE سنداً لدمج عام بغض النظر عن السياق.
- لا يُمحى ولا يُستبدل سجل Reference الأصلي ولا نسبه ولو وُجد SAME-NODE.
- ليس وجود SAME-NODE و[DIFFERENT-NODE](/ar/grammar/edge/different-node/) معاً للزوج نفسه خطأ في wire. يُحفظ سياق كل دعوى وتُقيَّم على أنها تعارض.
- يُربط Reference من نوع Variable بـ Reference من نوع Identified بـ SAME-NODE لحل المتغير ([Reference](/ar/grammar/reference/) Variable).

## الطول

```
المجموع = 1 + N_len + N_id + N_subject + N_object WORD
```

## أمثلة (غير معيارية)

Edge Id `0009`، وSubject هو LOCAL 1، وObject هو LOCAL 2.

- Edge هو TAG (1) + Edge Id (2) + Subject (2) + Object (2) = 7 WORD و`LLLL=0110`. وTAG هو `0001 0 0110 0000001` = `1301`.

```
1301 0088 0009 0088 0001 0088 0002
```

## صفحات ذات صلة

- [Edge](/ar/grammar/edge/)، [REFERENCE-NODE](/ar/grammar/edge/reference-node/)، [DIFFERENT-NODE](/ar/grammar/edge/different-node/)
- [Reference](/ar/grammar/reference/)، [LOCAL](/ar/grammar/reference/local/)
