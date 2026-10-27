---
title: "TRANSFORMED-BY"
weight: 52
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "TRANSFORMED-BY هو Meta نسب يكتب الأداة التي حوّلت من تمثيل آخر إلى هذا المستند وإصدار مصدرها (digest الـ commit)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

يكتب كيف حُوِّل إلى هذا المستند من تمثيل آخر (مثل محوّل ويكي بيانات ومرمِّز اللغة الطبيعية). Tool هي ما حُوِّل به، وVersion هو أي مصدر لتلك الأداة حُوِّل به. ولا بد من الاثنين ليمكن إعادة إنتاج المستند نفسه من المدخل نفسه.

## التخطيط

```
TAG WORD          0001 1LLL L011 0011      Codec 0x33
[Length ممتد TAG]
Tool              سجل Reference واحد (أداة التحويل أو قواعده)
Version           سجل Value واحد (SHA-256-DIGEST أو SHA1-DIGEST)
```

- Codec: Meta `0x33`، فئة النسب (`011`)
- Payload: Reference مضمّن (الأداة) + Value مضمّنة (digest إصدار المصدر)
- العدد: يمكن أكثر من واحد (واحد لكل أداة)

## التفسير والصلاحية

- Tool هو سجل Reference كامل واحد بالضبط. ويجوز أي Reference يشير إلى أداة.
  - أداة من مستند أدوات geul.org: [EXTERNAL-ISSUER](/ar/grammar/reference/external-issuer/) (`0x0000`، ومعرّف المستند `0x0001xxxx xxxxxxxx`، وLOCAL الخاص بها). مستند واحد لكل أداة (مستند تعريف المصطلحات في [Issuer](/ar/grammar/issuer/)).
  - إذا كان الـ codec مستند GEUL فيُشار إلى ذلك المستند بـ [DOC-POINTER](/ar/grammar/reference/doc-pointer/).
- Version هو سجل Value كامل واحد بالضبط، وهو معرّف كائن إدارة الإصدارات لمصدر Tool. وفي git هو معرّف كائن commit كاملاً.
  - إذا كان تنسيق الكائن في مستودع git هو SHA-256 فهو [SHA-256-DIGEST](/ar/grammar/value/binary/sha-256-digest/) (`0x61`، 16 WORD)، وإذا كان SHA-1 فهو [SHA1-DIGEST](/ar/grammar/value/binary/sha1-digest/) (`0x62`، 10 WORD). ويُتحقق من تنسيق المستودع بـ `git rev-parse --show-object-format`.
  - لا تُستخدم المعرّفات المختصرة (مثل `2bd496f`). فقيمة digest لا تسمح بالاقتطاع.
  - لا يُكتب بنص hex (UTF8-TEXT). فالقيمة نفسها 22 WORD في SHA-1 (11 بالصيغة الثنائية) و34 WORD في SHA-256 (18 بالصيغة الثنائية).
- Version إلزامي. فسجل أداة لا يُعرف إصدار مصدرها لا يصلح سنداً لإعادة الإنتاج. وإذا كانت الأداة خارج إدارة الإصدارات فيُستخدم SHA-256 للمنتَج الموزَّع (SHA-256-DIGEST).
- يشير Version إلى مصدر تم commit. ولا يُكتب معرّف commit في مستند أُنتج بشجرة عمل فيها تغييرات لم يتم commit لها (يُوصى بأن ترفض الأداة التنفيذ).
- إذا كانت الأداة تعتمد على كود خارج المستودع (مثل مكتبة محلية أشار إليها Go `replace`) فيُكتب ذلك الكود أيضاً بـ TRANSFORMED-BY على حدة. فمعرّف commit الأداة وحده لا يحدد ذلك الكود.
- الأداة التي تكتفي بنقل المصدر دون فقد (مثل أداة تحمّل dump في قاعدة البيانات كما هو) لا تحدد محتوى المستند فلا تُكتب. أما التحميل الذي فيه فقد فيغيّر المستند فتُكتب أداته.
- تكتب مواصفة geul.org (`0x1833`) حقلا سجل هما Tool (العرض 0، أي Reference فلا CODEC) وVersion (العرض 0، [CODEC](/ar/grammar/edge/codec/) `0861`·`0862`).

## الطول

```
المجموع = 1 + N_len + N_tool + N_version WORD
```

- يجب أن يتطابق المؤشر بعد قراءة آخر سجل مع نهاية Meta تماماً.
- إذا كانت Tool هي EXTERNAL-ISSUER-1WORD (7 WORD) وVersion هي SHA1-DIGEST (11 WORD) فالمجموع 1 + 1 + 7 + 11 = 20 WORD ويُستخدم الطول الممتد. وإذا كانت SHA-256-DIGEST (18 WORD) فالمجموع 27 WORD.

## أمثلة

مثال غير معياري. الأداة هي LOCAL 2 (`0360 0000 0001 0000 0000 0001 0002`) في مستند أدوات geul.org `0x0001000000000001`، والمصدر هو commit `ddc0719974a32aaa7b422ee84221a9721085ce4c` (SHA-1).

```
1F33 0014
0360 0000 0001 0000 0000 0001 0002
0D62 ddc0 7199 74a3 2aaa 7b42 2ee8 4221 a972 1085 ce4c
```

## مسائل مفتوحة

- هل يُغيَّر إصدار [GENERATED-BY](/ar/grammar/meta/lineage/generated-by/) بالطريقة نفسها (digest إلزامي أو صيغة أخرى). فإصدار النموذج ليس معرّف commit.

## صفحات ذات صلة

- [Meta](/ar/grammar/meta/)، [GENERATED-BY](/ar/grammar/meta/lineage/generated-by/)، [DERIVED-FROM](/ar/grammar/meta/lineage/derived-from/)
- [EXTERNAL-ISSUER](/ar/grammar/reference/external-issuer/)، [DOC-POINTER](/ar/grammar/reference/doc-pointer/)، [SHA-256-DIGEST](/ar/grammar/value/binary/sha-256-digest/)، [SHA1-DIGEST](/ar/grammar/value/binary/sha1-digest/)، [CODEC](/ar/grammar/edge/codec/)
