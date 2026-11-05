---
title: "LANGUAGE-BCP47-CODE (0x076L·0x077L)"
weight: 118
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-BCP47-CODE هو Value يحمل وسم لغة BCP 47 كاملاً على هيئة بايتات ASCII."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-BCP47-CODE هو Value يحمل وسم لغة BCP 47 كاملاً على هيئة بايتات ASCII. يستعمل زوج الرمزين الزوجي/الفردي 0x076L/0x077L.

| البند | القيمة |
|---|---|
| الاسم | `LANGUAGE-BCP47-CODE` (حزمة زوجي/فردي. اسم كل رمز في جدول الأعضاء أدناه) |
| TAG ID | `0x076L`·`0x077L` |
| القسم | 3 `0011` (Value)، الإزاحة C داخل القسم = 22~23 |
| Kind | Value · العائلة: TEXT |
| وصف الفهرس | بايتات ASCII لوسم لغة BCP 47 كامل بحالة الأحرف المعيارية (canonical casing). بايتات زوجية·فردية |
| جهة Hugo | `value/text/language-bcp47-code.md` |

## الأعضاء {#구성원}

تتناول هذه الصفحة رمزين من زوج زوجي/فردي معاً. الرمز الزوجي للقيم ذات عدد البايتات الزوجي، والرمز الفردي لذات العدد الفردي ([السجل وTAG WORD](../record.md#가변-길이-바이트열)). مستند الـ Codec واحد لكل رمز. حقول المستندين متطابقة، ولا يختلفان إلا في هدف DECLARE والاسم (BIND).

| TAG ID | الاسم | عدد البايتات | Codec ID | مستند المواصفة | TAG WORD |
|---|---|---|---|---|---|
| `0x076L` | `LANGUAGE-BCP47-CODE-EVEN` | زوجي | `0x00000760` | `0x00000000/codecs/0x00000760/` | `0000 0111 0110 LLLL` |
| `0x077L` | `LANGUAGE-BCP47-CODE-ODD` | فردي | `0x00000770` | `0x00000000/codecs/0x00000770/` | `0000 0111 0111 LLLL` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | قيمة خام للباقي (`0xFFFF`) |  |  |

LANGUAGE-BCP47-CODE هو Value يحمل وسم لغة BCP 47 كاملاً. يُستعمل لكتابة اللغة بدقة حتى script وregion وvariant.

## التخطيط {#레이아웃}

- الرمز: رمز مباشر لـ Value هو `0x076L` (بايتات زوجية) و`0x077L` (بايتات فردية). العائلة TEXT.
- يُحدَّد عدد البايتات بأدنى بت في Codec وبعدد WORD في Payload. هو `2 × عدد WORD في Payload − أدنى بت`، ولا يوجد Byte Count ([Value](_index.md)).
- Payload ليس نص UTF-8 بل بايتات ASCII لوسم BCP 47.

```
TAG WORD          0000 0111 011P LLLL      Codec 0x076L/0x077L
[Length ممتد TAG] عندما يبلغ المجموع 15 WORD فأكثر
Payload WORD 1st ... Nth          BCP 47 tag bytes / final zero padding
```

## التفسير والصلاحية {#해석과-유효성}

- يجب أن تكون سلسلة البايتات وسم لغة BCP 47 سليم التكوين (well-formed) وفق RFC 5646. السلسلة الفارغة غير مسموحة.
- يستعمل Payload حروف ASCII والأرقام وhyphen-minus `-` فقط. الفاصل هو ASCII `-` حتماً، ولا يُسمح بـ `_` ولا بالمسافات ولا بالمحارف غير ASCII.
- مقارنة وسوم BCP 47 لا تميّز حالة الأحرف. يكتب ملف GEUL المعياري (canonical profile) كل الفواصل بـ `-`، ويُسلسل subtag كل من language وextlang وvariant وextension وprivate-use بأحرف صغيرة، وscript بصيغة Titlecase، وregion بأحرف كبيرة.
- سلامة التكوين وحدها لا تكفي. يُحكم على صلاحية subtag المسجَّلة ووسوم grandfathered استناداً إلى snapshot محدد من IANA Language Subtag Registry، ويجب حفظ تاريخ ذلك snapshot أو إصدار registry معها.
- يُسمح بوسم private-use وsubtag من نوع private-use ما دامت سليمة التكوين وفق نحو RFC 5646. غير أن معناها منوط باتفاق الأطراف ولا يعرّفه IANA registry، فلا تضمن التشغيل البيني العام.
- إذا كان لـ subtag مهجور (deprecated) أو وسم grandfathered قيمة Preferred-Value في snapshot نفسه، فإن الصيغة المعيارية في GEUL تكتب القيمة البديلة بحالة الأحرف المعيارية. ويمكن تفسير الوسم بصيغته المهجورة مدخلاً، لكنها ليست صيغة التخزين المعيارية.
- BCP 47 ملف ASCII، فلا ينطبق عليه شرط Unicode normalization مثل UTF-8 NFC.
- في WORD الواحد يأتي البايت الأعلى أولاً. وإذا كان عدد البايتات فردياً (الرمز الفردي) وجب أن يكون البايت الأدنى غير المستعمل في آخر WORD هو `00`.
- عدد WORD في Payload هو `ceil(عدد البايتات/2)`. يُرفض الرمز الفردي إذا لم يكن البايت الأدنى في آخر WORD هو `00`.

## المرجع المعياري {#표준-근거}

- يتبع نحو وسم اللغة، وتفسيره دون تمييز حالة الأحرف، ومفهوم deprecated/Preferred-Value المرجع [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- الـ registry الذي يُحكم به على صلاحية الوسم هو [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- زوج الرمزين الزوجي/الفردي وzero padding وسياسة التخزين بحالة الأحرف المعيارية وحساب Length هي قواعد framing في GEUL.

## الطول {#길이}

- المجموع هو عدد WORD في TAG واحد، وTAG Length الممتد (إن وُجد)، وPayload. حتى 14 WORD يُستعمل الطول المباشر، ومن 15 WORD فأكثر يُستعمل الطول الممتد `1110`·`1111`، ويدخل TAG الممتد في المجموع ([Length](../record.md)).

## العلاقة بـ LANGUAGE-SHORT-CODE {#language-short-code와의-관계}

- الوسم الذي له رقم في GEUL Language Registry يمكن كتابته في 1 WORD بـ [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md).
- الوسم الذي لا رقم له في الـ registry (ومنه الوسوم التي فيها extension أو private-use) يُكتب بـ LANGUAGE-BCP47-CODE. ويُستعمل LANGUAGE-BCP47-CODE أيضاً عند الحاجة إلى حفظ نص الوسم الكامل الأصلي.
- SHORT-CODE `n` ووسم LANGUAGE-BCP47-CODE الذي يربطه الـ registry بـ `n` (دون تمييز حالة الأحرف) هما اللغة نفسها.

## مثال {#예시}

- `ko-KR` هو 5 بايتات ASCII (فردي) فهو `LANGUAGE-BCP47-CODE-ODD` (`0x077L`)، وPayload هو `6B6F 2D4B 5200`.
- TAG بـ 1 WORD وPayload بـ 3 WORD، فالمجموع 4 WORD و`LLLL=0011`. فالكل `0773 6B6F 2D4B 5200`.

## نص مستند المواصفة {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000760/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000076000000000
BODY
#1 DECLARE 0x0760
#2 FIELD #1 rest
#3 BIND #1 "LANGUAGE-BCP47-CODE-EVEN"
#4 BIND #2 "bytes"
```

ما سبق مستند Codec للرمز `LANGUAGE-BCP47-CODE-EVEN` (`0x076L`). أما مستند Codec للعضو الآخر (`LANGUAGE-BCP47-CODE-ODD`) فلا يختلف إلا في Codec ID داخل DOC-ID، وهدف DECLARE، والاسم المربوط في `#1` (BIND).
