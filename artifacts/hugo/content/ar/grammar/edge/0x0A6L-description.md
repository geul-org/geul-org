---
title: "DESCRIPTION (0x0A6L)"
weight: 166
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DESCRIPTION هو Edge عبارة يربط بـ Object وصفاً واحداً بلغة معينة لهدف Subject."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `DESCRIPTION` (BIND مستند المواصفة `DESCRIPTION`) |
| TAG ID | `0x0A6L` |
| Codec ID | `0x00000A60` |
| مستند المواصفة | `0x00000000/codecs/0x00000A60/` (هدف DECLARE `0A60`) |
| القسم | 5 `0101` (Edge العبارة)، الإزاحة داخل القسم C = 6 |
| Kind | Edge · العائلة: العبارة، الحزمة: الإشارة والاسم |
| TAG WORD | `0000 1010 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | ربط الوصف (description) بلغة معينة لـ Subject. تخطيطه مثل LABEL |
| جانب Hugo | `edge/description.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)). لا يُصرَّح بـ Edge Id الخاص بـ Edge عبر FIELD.

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | سجل | أي سجل (عدا علامة الموضع) |  |
| 2 | `object` | #3 | سجل | `0780` UTF8-LANGUAGE-TEXT، `0790` UTF8-LANGUAGE-TEXT، `0050` LOCAL |  |

DESCRIPTION هو Edge عبارة يربط بـ Object وصفاً واحداً بلغة معينة لهدف Subject. Codec `0x0A6L`.

الوصف عبارة قصيرة تميّز الهدف (description في ويكيداتا، مثل «عاصمة ألمانيا وأكبر مدنها»). وليس تعريفاً للهدف ولا ادعاءً. تُكتب القضايا المتعلقة بالهدف بـ [TRIPLE](0x0AAL-triple.md). التخطيط مثل [LABEL](0x0A4L-label.md). يوضع الوصف ولغته في Object واحد هو [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md). فلا يوجد حقل قيمة خام.

## التخطيط {#레이아웃}

```
TAG WORD          0000 1010 0110 LLLL
[Length TAG ممتد]
Edge Id           سجل LOCAL Reference
Subject           سجل Reference واحد
Object            Value من نوع UTF8-LANGUAGE-TEXT أو سجل LOCAL Reference واحد
```

## التفسير والصلاحية {#해석과-유효성}

- قواعد Subject وObject مثل [LABEL](0x0A4L-label.md). Subject هو سجل Reference واحد كامل تماماً. وObject هو سجل UTF8-LANGUAGE-TEXT (`0x078L`·`0x079L`) واحد كامل تماماً، أو LOCAL Reference يُحلّ إلى UTF8-LANGUAGE-TEXT بربط [REFERENCE-NODE](0x0A0L-reference-node.md) في الوثيقة نفسها.
- لا يصلح النص بلا لغة (UTF8-TEXT) أن يكون DESCRIPTION. الوصف واحد لكل لغة، فلا تقوم تلك القاعدة إلا بوجود اللغة. يُكتب الوصف المشترك بين عدة لغات بلغة `mul`.
- لا يزيد DESCRIPTION لـ Subject واللغة نفسيهما على واحد.
- يُستخدم الوصف للتمييز عن هدف آخر بالاسم نفسه. والأفضل ألا يتكرر زوج LABEL وDESCRIPTION في اللغة نفسها لهدفين، لكن المواصفة لا تفحص ذلك (وهو توصية في ويكيداتا أيضاً لا إلزام).
- يقيِّد مستند مواصفة geul.org الـ Object بـ [CODEC](0x0BEL-codec.md) (`0780`·`0790`·`0050`، مثل LABEL).

## الطول {#길이}

```
الكل = 1 + N_len + N_id + N_subject + N_object WORD
```

- سجل اللغة وعدد بايتات النص في Object من مسؤولية سجل Object. يجب أن يطابق المؤشر بعد قراءة السجل الأخير نهاية Edge تماماً.
- الوصف أطول من label، فيسهل أن يتجاوز كل من Object وEdge 15 WORD. عندئذ يُستخدم Length الممتد ([السجل](../record.md)).

## مثال (غير معياري) {#예시-비규범}

Edge Id هو `0009`، وSubject هو Q64 (`0141 0040`)، وObject هو `capital and largest city of Germany` (en). اللغة هنا مثال على صيغة LANGUAGE-BCP47-CODE (لـ `en` رقم في السجل هو `0x0784` فيمكن استخدام SHORT-CODE أيضاً).

- Object: اللغة `0761 656E` (BCP47 `en`، 2 WORD) + نص من 35 byte (فردي، 18 WORD)، فهو `0x079L`، وTAG 1 + TAG ممتد 1 + 20 = 22 WORD، `079E 0016 …`.
- Edge هو TAG 1 + TAG ممتد 1 + Edge Id 2 + Subject 2 + Object 22 = 28 WORD، فـ `LLLL=1110`، وTAG هو `0A6E`، وTAG الممتد `001C`.

```
0A6E 001C 0051 0009 0141 0040
079E 0016 0761 656E 6361 7069 7461 6C20 616E 6420 6C61 7267 6573 7420 6369 7479 206F 6620 4765 726D 616E 7900
```

## مقابلة ويكيداتا {#위키데이터-대응}

- `descriptions` للعنصر (واحد لكل لغة) ← DESCRIPTION واحد لكل لغة. يُنقل رمز اللغة بجدول مقابلة رموز اللغات نفسه الذي في LABEL.

## مسائل مفتوحة {#열린-문제}

- هل توجد حالات تستدعي السماح بوصف UTF8-TEXT بلا لغة (غير مسموح الآن).

## صفحات ذات صلة {#관련-페이지}

- [Edge](_index.md)، [LABEL](0x0A4L-label.md)، [ALIAS](0x0A5L-alias.md)، [CODEC](0x0BEL-codec.md)
- [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)، [LOCAL](../reference/0x005L-local.md)، [REFERENCE-NODE](0x0A0L-reference-node.md)

## نص مستند المواصفة الأصلي {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000A60/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بحروف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A6000000000
BODY
#1 DECLARE 0x0A60
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "DESCRIPTION"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
