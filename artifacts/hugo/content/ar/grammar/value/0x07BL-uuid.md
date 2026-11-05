---
title: "UUID (0x07BL)"
weight: 123
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "UUID هو Value ثابت العرض يحمل قيمة UUID بطول 128 بت وفق RFC 9562."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `UUID` (BIND في مستند المواصفة `UUID`) |
| TAG ID | `0x07BL` |
| Codec ID | `0x000007B0` |
| مستند المواصفة | `0x00000000/codecs/0x000007B0/` (هدف DECLARE `07B0`) |
| القسم | 3 `0011` (Value)، الإزاحة C داخل القسم = 27 |
| Kind | Value · العائلة: BINARY |
| TAG WORD | `0000 0111 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | UUID بطول 128 بت وفق RFC 9562 في Payload ثابت من 8 WORD |
| جهة Hugo | `value/binary/uuid.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `uuid` | #2 | قيمة خام بـ 8 WORD |  |  |

UUID هو Value ثابت العرض يحمل قيمة UUID بطول 128 بت وفق RFC 9562. وهو رمز مباشر لـ Value هو `0x07BL`، والعائلة BINARY. Payload هو 8 WORD بالضبط (16 octet، 128 بت).

## التخطيط {#레이아웃}

```
TAG WORD          0x07B8 (0000 0111 1011 1000)  المجموع 9 WORD
Payload           8 WORD (128 بت)  UUID octet 0 → octet 15
```

## التفسير والصلاحية {#해석과-유효성}

- تُجمع octets الـ UUID المعيارية في RFC 9562 من octet 0 إلى octet 15 بالترتيب، كل octet اثنين معاً. والـ octet الأول هو الـ 8 بت العليا في WORD. ولا يُعاد ترتيب field وversion bit وvariant bit في UUID ولا يُعاد ترميزها.
- سلسلة hex-and-dash بصيغة `8-4-4-4-12` تمثيل للإدخال والإخراج فقط. لا تدخل حالة الأحرف ولا الشرطات في Payload، وإنما تُخزَّن الـ 16 octet الناتجة من التحليل فقط.
- يحفظ Value الـ UUID هذا نمط الـ 128 بت دون فقد. في variant `10xx` من RFC 9562 تكون version 1 و3 و4 و5 و6 و7 بتخطيط معياري، وversion 8 صيغة UUID مخصصة (custom). أما version 2 فمحجوزة لـ DCE Security ولم يحدد RFC تخطيطها، وversion 0 غير مستعملة، وversion 9–15 محجوزة لتعريفات مستقبلية. وvariant الأخرى كذلك محجوزة للتوافق أو لتعريفات مستقبلية.
- Nil UUID قيمة خاصة كل بتاتها الـ 128 أصفار، وMax UUID كل بتاتها الـ 128 آحاد. ولا تُستبعد بنيوياً أنماط الـ 128 بت التي فيها version/variant محجوزة أو غير مستعملة، ويُحكم على معنى النمط وإمكان التشغيل البيني بالمعيار المطبَّق والسياق الخارجي.
- يُحكم على تطابق UUID بتساوي قيمة الـ 128 بت في Payload. وكون القيمة نفسها لا يضمن أصالة الهدف ولا ملكيته ولا وجوده الحالي ولا إمكان حله ولا صلاحية الوصول إليه.
- عند تخزين Microsoft COM GUID لا يُنسخ تمثيل الذاكرة أو التسلسل mixed-endian كما هو. بل يُحوَّل أولاً إلى 16 octet بترتيب field/octet المعياري في RFC 9562.
- يُرفض إن لم يكن Payload 8 WORD بالضبط.

## المرجع المعياري {#표준-근거}

- يعرّف [RFC 9562 — Universally Unique IDentifiers (UUIDs)](https://www.rfc-editor.org/rfc/rfc9562.html) الـ UUID بأنه 16 octet (128 بت)، ويرمّز الـ field بأعلى بايت أولاً (most-significant-byte-first) فتتصل الـ field في الصيغة الثنائية بترتيب big-endian. وvariant في البتات العليا من octet 8، وversion في البتات الأربع العليا من octet 6، وتحفظ هذه الصيغة موضعيهما كما هما.
- تميّز الأقسام 4.1–5.10 من RFC 9562 بين variant وversion 1–8 وNil وMax والمديات المحجوزة. وبما أن RFC 9562 حلّ محل RFC 4122 فالمعيار الساري لهذه الصيغة هو RFC 9562.
- ABNF بصيغة hex-and-dash في RFC 9562 تمثيل نصي، وقد نبّه كذلك على تحفظ COM GUID little-endian. ولا تضع GEUL في Payload إلا الـ 16 octet المعيارية للـ UUID.
- TAG في GEUL والطول المباشر وتأطير WORD ذي 16 بت ليست من RFC 9562، بل قواعد تضيفها هذه الصيغة.

## الطول {#길이}

- المجموع هو TAG بـ 1 WORD مع Payload بـ 8 WORD أي 9 WORD بالضبط، ويستعمل الطول المباشر `LLLL=1000`. لا TAG Length ممتد ولا descriptor ولا padding.
- يُرفض إن لم يكن Payload 8 WORD بالضبط.

## مثال {#예시}

متجه الاختبار UUIDv7 في RFC 9562 الملحق A.6 `017f22e2-79b0-7cc3-98c4-dc0c0c07398f`:

```
07B8 017F 22E2 79B0 7CC3 98C4 DC0C 0C07 398F
```

- TAG `07B8`، وPayload `017F 22E2 79B0 7CC3 98C4 DC0C 0C07 398F`.

## نص مستند المواصفة {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x000007B0/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007B000000000
BODY
#1 DECLARE 0x07B0
#2 FIELD #1 0x0008
#3 BIND #1 "UUID"
#4 BIND #2 "uuid"
```
