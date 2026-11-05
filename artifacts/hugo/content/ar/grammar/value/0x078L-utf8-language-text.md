---
title: "UTF8-LANGUAGE-TEXT (0x078L·0x079L)"
weight: 120
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-LANGUAGE-TEXT نص موسوم بلغته، يحمل في Value واحد سجل Value لغة واحداً ونص UTF-8 (Codec 0x078L/0x079L)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-LANGUAGE-TEXT نص موسوم بلغته، يحمل في Value واحد سجل Value لغة واحداً ونص UTF-8 (Codec 0x078L/0x079L).

| البند | القيمة |
|---|---|
| الاسم | `UTF8-LANGUAGE-TEXT` (حزمة زوجي/فردي. اسم كل رمز في جدول الأعضاء أدناه) |
| TAG ID | `0x078L`·`0x079L` |
| القسم | 3 `0011` (Value)، الإزاحة C داخل القسم = 24~25 |
| Kind | Value · العائلة: TEXT |
| وصف الفهرس | نص موسوم بلغته. سجل Value لغة (LANGUAGE-SHORT-CODE أو LANGUAGE-BCP47-CODE) وبايتات UTF-8. زوجية·فردية بايتات النص |
| جهة Hugo | `value/text/utf8-language-text.md` |

## الأعضاء {#구성원}

تتناول هذه الصفحة رمزين من زوج زوجي/فردي معاً. الرمز الزوجي للقيم ذات عدد البايتات الزوجي، والرمز الفردي لذات العدد الفردي ([السجل وTAG WORD](../record.md#가변-길이-바이트열)). مستند الـ Codec واحد لكل رمز. حقول المستندين متطابقة، ولا يختلفان إلا في هدف DECLARE والاسم (BIND).

| TAG ID | الاسم | عدد البايتات | Codec ID | مستند المواصفة | TAG WORD |
|---|---|---|---|---|---|
| `0x078L` | `UTF8-LANGUAGE-TEXT-EVEN` | زوجي | `0x00000780` | `0x00000000/codecs/0x00000780/` | `0000 0111 1000 LLLL` |
| `0x079L` | `UTF8-LANGUAGE-TEXT-ODD` | فردي | `0x00000790` | `0x00000000/codecs/0x00000790/` | `0000 0111 1001 LLLL` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `language` | #2 | سجل | `07A0` LANGUAGE-SHORT-CODE, `0760` LANGUAGE-BCP47-CODE-EVEN, `0770` LANGUAGE-BCP47-CODE-ODD |  |
| 2 | `bytes` | #3 | قيمة خام للباقي (`0xFFFF`) |  |  |

UTF8-LANGUAGE-TEXT نص موسوم بلغته. يحمل في Value واحد سجل Value لغة واحداً وسلسلة بايتات UTF-8.

[UTF8-TEXT](0x072L-utf8-text.md) سلسلة بلا لغة (معرّف أو رمز أو اسم ملف أو بايتات أصلية)، أما هذه الصيغة فنص له لغة (اسم أو عنوان أو شعار أو جملة). وهما قيمتان مختلفتان وإن تطابقت بايتاتهما. فـ «Paris» (سلسلة) و«Paris» (بالفرنسية) ليستا متساويتين، كما يفصل RDF بين `xsd:string` و`rdf:langString`.

## التخطيط {#레이아웃}

- الرمز: رمز مباشر لـ Value هو `0x078L` (بايتات النص زوجية) و`0x079L` (بايتات النص فردية). العائلة TEXT.

```
TAG WORD          0000 0111 100P LLLL      Codec 0x078L/0x079L (P = بايتات النص فردية)
[Length ممتد TAG] عندما يبلغ المجموع 15 WORD فأكثر
Language          سجل Value واحد من LANGUAGE-SHORT-CODE أو LANGUAGE-BCP47-CODE (مع TAG)
Text WORD 1st ... Nth             UTF-8 bytes / إن كان العدد فردياً فآخر بايت 0x00
```

## التفسير والصلاحية {#해석과-유효성}

- يبدأ Payload بسجل اللغة. يُقرأ أول WORD في Payload كـ TAG، والقدر الذي يحدده Length هو سجل اللغة، والباقي بايتات النص. سجل اللغة إلزامي. وإن لم تكن هناك لغة فيُستعمل UTF8-TEXT لا هذه الصيغة.
- سجل اللغة هو بالضبط سجل واحد كامل من [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md) (`0x07AL`) أو [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) (`0x076L`·`0x077L`). إن كان من Codec آخر أو ناقصاً فهو invalid. وتتبع صلاحية سجل اللغة قواعد صيغته.
- يجوز استعمال صيغتي اللغة كلتيهما. وقاعدة مقارنة كون اللغتين واحدة هي نفسها في [LABEL](../edge/0x0A4L-label.md). SHORT-CODE ووسم BCP 47 الذي يربطه الـ registry بذلك الرقم هما اللغة نفسها.
- لا يُستعمل `zxx` (لا محتوى لغوي). فمثل هذه السلسلة هي UTF8-TEXT. أما `und` (لغة غير محددة) و`mul` (لغات متعددة) فيجوز استعمالهما لأنهما نص له لغة.
- تتبع بايتات النص قواعد UTF8-TEXT نفسها. يجب أن تكون UTF-8 سليمة التكوين، ويُسمح بـ U+FEFF في البداية كمحرف، ولا يُفرض تطبيع، وتُحفظ كما في الأصل. وتتولى الجهة التي تقارن أو تفهرس المقارنة بعد توحيدها إلى NFC.
- عدد بايتات النص هو `2 × (عدد WORD في Payload − عدد WORD في سجل اللغة) − P`. وP (أدنى بت في Codec) يدل على زوجية بايتات النص أو فرديتها فقط. إن كان فردياً وجب أن يكون البايت الأدنى في آخر WORD هو `00`.
- النص الفارغ (0 بايت) يوضع في الرمز الزوجي مع سجل اللغة وحده.

## موضع الاستعمال {#쓰는-곳}

- قيم monolingualtext في Wikidata: `{"text":"Bundesrepublik Deutschland","language":"de"}` تصبح هذه الصيغة وحدها. وتدخل كما هي في Object في [TRIPLE](../edge/0x0AAL-triple.md) وفي Value في [QUALIFIER](../edge/0x0ABL-qualifier.md). أما الخاصية وrank وqualifier فيتولاها TRIPLE.
- Object في [LABEL](../edge/0x0A4L-label.md) و[ALIAS](../edge/0x0A5L-alias.md). يحمل هذا Value وحده الاسم واللغة.
- النصوص التي تتحدد لغتها، كعناوين القوانين والأوراق البحثية.

## مطابقة رموز اللغة (Wikidata) {#언어-코드-대응-위키데이터}

- ليست كل رموز اللغات في Wikidata وWikimedia من BCP 47 (مثل `simple` و`map-bms`). تُنقل إلى وسوم BCP 47 بجدول مطابقة. وتُعالج الرموز التي لا يمكن نقلها بحسب الاستعمال.
  - القيم (monolingualtext): يُحفظ نص datavalue الأصلي في UTF8-TEXT. فالقيمة جزء من القضية، وإسقاطها يغيّر القضية.
  - التسميات والأوصاف والأسماء البديلة: تُتخطى وتُسجَّل في التقرير. فهذه الـ Edge لا تصح إلا بلغة (النص بلا لغة invalid)، ويبقى نصها الأصلي في بيانات المصدر.
- إن كان للوسم المنقول رقم في GEUL Language Registry فيُكتب بـ LANGUAGE-SHORT-CODE، وإلا فبـ LANGUAGE-BCP47-CODE.

## الطول {#길이}

- المجموع هو عدد WORD في TAG واحد، وTAG Length الممتد (إن وُجد)، وسجل اللغة، وWORD النص. حتى 14 WORD يُستعمل الطول المباشر، ومن 15 WORD فأكثر الطول الممتد ([Length](../record.md)).
- سجل اللغة 2 WORD إن كان SHORT-CODE، وإن كان BCP 47 فـ `ceil(بايتات الوسم/2) + 1` WORD (`de` يساوي 2 WORD، و`zh-Hant` يساوي 5 WORD).

## مثال {#예시}

اللغة في الأمثلة كلها بصيغة LANGUAGE-BCP47-CODE. أما `fr` و`ko` و`de` فلها أرقام في الـ registry فيمكن كتابتها أيضاً بـ SHORT-CODE (2 WORD).

| القيمة | بايتات النص | مجموع WORD |
|---|---|---|
| "Paris" (fr) | 5 (فردي) | `0795 0761 6672 5061 7269 7300` |
| "" (ko) | 0 | `0782 0761 6B6F` |
| "Bundesrepublik Deutschland" (de) | 26 (زوجي) | `078E 0011 0761 6465 4275 6E64 6573 7265 7075 626C 696B 2044 6575 7473 6368 6C61 6E64` |

- "Paris": TAG `0795` (Codec `0x079L`، `LLLL=0101`، المجموع 6 WORD)، اللغة `0761 6672` (BCP 47 `fr`)، النص `5061 7269 7300` (5 بايتات، وآخرها `00`).
- الثالث مجموعه 17 WORD فيستعمل Length ممتداً (`LLLL=1110` في `078E`، وTAG الممتد `0011`).

## المرجع المعياري {#표준-근거}

- وسم اللغة: [RFC 5646 (BCP 47)](https://www.rfc-editor.org/rfc/rfc5646). `zxx` و`und` و`mul` رموز special في IANA Language Subtag Registry.
- النص: [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- التمييز بين السلسلة والنص الموسوم بلغته: [RDF 1.1 Concepts — language-tagged string](https://www.w3.org/TR/rdf11-concepts/#dfn-language-tagged-string).

## مسائل مفتوحة {#열린-문제}

- فحص نحو وسم BCP 47 في schema. يُفحص الآن أنه ASCII وغير فارغ فقط.

## صفحات ذات صلة {#관련-페이지}

- [Value](_index.md)، [UTF8-TEXT](0x072L-utf8-text.md)، [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md)، [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md)، [LABEL](../edge/0x0A4L-label.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000780/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000078000000000
BODY
#1 DECLARE 0x0780
#2 FIELD #1 record
#3 FIELD #1 rest
#4 BIND #1 "UTF8-LANGUAGE-TEXT-EVEN"
#5 BIND #2 "language"
#6 BIND #3 "bytes"
#7 CODEC #2 0x07A0
#8 CODEC #2 0x0760
#9 CODEC #2 0x0770
```

ما سبق مستند Codec للرمز `UTF8-LANGUAGE-TEXT-EVEN` (`0x078L`). أما مستند Codec للعضو الآخر (`UTF8-LANGUAGE-TEXT-ODD`) فلا يختلف إلا في Codec ID داخل DOC-ID، وهدف DECLARE، والاسم المربوط في `#1` (BIND).
