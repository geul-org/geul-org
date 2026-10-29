---
title: "UTF8-LANGUAGE-TEXT"
weight: 75
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-LANGUAGE-TEXT نص مرفق بلغة، يحمل سجل Value للغة وسلسلة UTF-8 في قيمة Value واحدة (Codec 0x4A/0x4B)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-LANGUAGE-TEXT نص مرفق بلغة. يحمل سجل Value للغة وسلسلة بايتات UTF-8 في قيمة Value واحدة.

[UTF8-TEXT](/ar/grammar/value/text/utf8-text/) سلسلة بلا لغة (معرّفات ورموز وأسماء ملفات وبايتات نص أصلية)، أما هذه الصيغة فنص له لغة (أسماء وعناوين وشعارات وجمل). هما قيمتان مختلفتان حتى لو تطابقت البايتات. "Paris" (سلسلة) و"Paris" (بالفرنسية) ليسا متساويين. كما يفصل RDF بين `xsd:string` و`rdf:langString`.

## التخطيط

- الرمز: الرمز المباشر في Value هو `0x4A` (نص بعدد بايتات زوجي) و`0x4B` (نص بعدد بايتات فردي). العائلة TEXT.

```
TAG WORD          0000 1LLL L100 101P      Codec 0x4A/0x4B (P = النص بعدد بايتات فردي)
[Length ممتد TAG] عندما يبلغ المجموع 15 WORD فأكثر
Language          سجل Value واحد من LANGUAGE-SHORT-CODE أو LANGUAGE-BCP47-CODE (مع TAG)
Text WORD 1st ... Nth             UTF-8 bytes / إن كان فردياً فآخرها 0x00
```

## التفسير والصلاحية

- يبدأ Payload بسجل اللغة. تُقرأ أول WORD في Payload كـ TAG ويكون السجل بطول Length الخاص بها هو سجل اللغة، والباقي بايتات النص. سجل اللغة إلزامي. إذا لم تكن هناك لغة فيُستخدم UTF8-TEXT لا هذه الصيغة.
- سجل اللغة هو سجل واحد كامل بالضبط من [LANGUAGE-SHORT-CODE](/ar/grammar/value/text/language-short-code/) (`0x48`) أو [LANGUAGE-BCP47-CODE](/ar/grammar/value/text/language-bcp47-code/) (`0x46`·`0x47`). وإن كان من Codec آخر أو ناقصاً فهو invalid. وتتبع صلاحية سجل اللغة قواعد تلك الصيغة.
- يمكن استخدام صيغتي اللغة كلتيهما. قاعدة مقارنة اللغة نفسها هي قاعدة [LABEL](/ar/grammar/edge/label/). SHORT-CODE ووسم BCP 47 الذي يربطه السجل برقمه هما اللغة نفسها.
- لا يُستخدم `zxx` (لا محتوى لغوي). مثل هذه السلسلة هي UTF8-TEXT. أما `und` (لغة غير محددة) و`mul` (لغات متعددة) فهما نص له لغة فيجوز استخدامهما.
- تتبع بايتات النص قواعد UTF8-TEXT نفسها. يجب أن تكون UTF-8 سليمة التكوين، ويُحظر BOM في البداية، ولا يُفرض التطبيع بل يُحفظ النص الأصلي كما هو. وتطابقه جهة المقارنة والفهرسة بـ NFC.
- عدد بايتات النص هو `2 × (عدد WORD في Payload − عدد WORD في سجل اللغة) − P`. P (أقل بت في Codec) يدل على فردية عدد بايتات النص أو زوجيته فقط. إذا كان فردياً فيجب أن يكون byte الأدنى في آخر WORD هو `00`.
- النص الفارغ (0 byte) يوضع فيه سجل اللغة فقط مع رمز زوجي.

## موضع الاستخدام

- قيمة monolingualtext في ويكي بيانات: `{"text":"Bundesrepublik Deutschland","language":"de"}` تصير هذه الصيغة وحدها. وتدخل كما هي في Object في [TRIPLE](/ar/grammar/edge/triple/) وفي Value في [QUALIFIER](/ar/grammar/edge/qualifier/). أما الخاصية وrank وqualifier فيتولاها TRIPLE.
- Object في [LABEL](/ar/grammar/edge/label/) و[ALIAS](/ar/grammar/edge/alias/). تحمل هذه القيمة وحدها الاسم واللغة.
- النصوص ذات اللغة المحددة مثل عناوين القوانين والبحوث.

## مقابلة رموز اللغات (ويكي بيانات)

- ليست كل رموز اللغات في ويكي بيانات وويكيميديا وسوماً من BCP 47 (مثل `simple` و`map-bms`). تُنقل إلى وسم BCP 47 بجدول مقابلة. والرموز التي لا يمكن نقلها تُعالج بحسب الاستخدام.
  - القيمة (monolingualtext): يُحفظ نص datavalue الأصلي كـ UTF8-TEXT. القيمة جزء من القضية، وإن أُسقطت تغيّرت القضية.
  - التسميات والأوصاف والأسماء البديلة: تُتخطى وتُسجَّل في التقرير. هذه الـ Edge لا تقوم إلا بوجود لغة (النص بلا لغة invalid)، ويبقى النص الأصلي في بيانات المصدر.
- إن كان للوسم الناتج رقم في GEUL Language Registry يُستخدم LANGUAGE-SHORT-CODE، وإلا فـ LANGUAGE-BCP47-CODE.

## الطول

- المجموع هو عدد WORD لـ: TAG (1 WORD)، وLength ممتد TAG (إن وجد)، وسجل اللغة، وWORD النص. الطول 14 WORD فأقل طول مباشر، و15 WORD فأكثر يستخدم الطول الممتد ([Length](/ar/grammar/record/)).
- سجل اللغة هو 2 WORD إن كان SHORT-CODE، وإن كان BCP 47 فهو `ceil(بايتات tag/2) + 1` WORD (`de` هو 2 WORD و`zh-Hant` هو 5 WORD).

## أمثلة

اللغات كلها أمثلة على صيغة LANGUAGE-BCP47-CODE. لـ `fr` و`ko` و`de` أرقام في السجل، فيمكن كتابتها أيضاً بصيغة SHORT-CODE ‏(2 WORD).

| القيمة | بايتات النص | كل WORD |
|---|---|---|
| "Paris" (fr) | 5 (فردي) | `0ACB 08C6 6672 5061 7269 7300` |
| "" (ko) | 0 | `094A 08C6 6B6F` |
| "Bundesrepublik Deutschland" (de) | 26 (زوجي) | `0F4A 0011 08C6 6465 4275 6E64 6573 7265 7075 626C 696B 2044 6575 7473 6368 6C61 6E64` |

- "Paris": TAG `0ACB` (Codec `0x4B` و`LLLL=0101` والمجموع 6 WORD)، واللغة `08C6 6672` (BCP 47 `fr`)، والنص `5061 7269 7300` (5 bytes وآخرها `00`).
- الثالث مجموعه 17 WORD فيُستخدم Length ممتد (`LLLL=1110` في `0F4A`، وTAG الممتد `0011`).

## السند المعياري

- وسم اللغة: [RFC 5646 (BCP 47)](https://www.rfc-editor.org/rfc/rfc5646). `zxx` و`und` و`mul` رموز special في IANA Language Subtag Registry.
- النص: [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- التمييز بين السلسلة والنص المرفق بلغة: [RDF 1.1 Concepts — language-tagged string](https://www.w3.org/TR/rdf11-concepts/#dfn-language-tagged-string).

## مسائل مفتوحة

- فحص نحو وسم BCP 47 في schema. حالياً لا يُفحص إلا أنه ASCII وغير فارغ.

## صفحات ذات صلة

- [Value](/ar/grammar/value/)، [UTF8-TEXT](/ar/grammar/value/text/utf8-text/)، [LANGUAGE-SHORT-CODE](/ar/grammar/value/text/language-short-code/)، [LANGUAGE-BCP47-CODE](/ar/grammar/value/text/language-bcp47-code/)، [LABEL](/ar/grammar/edge/label/)
