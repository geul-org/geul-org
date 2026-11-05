---
title: "UNSIGNED-INTEGER (0x062L)"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "UNSIGNED-INTEGER قيمة Value تمثل عدداً صحيحاً بلا إشارة."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `UNSIGNED-INTEGER` (مستند المواصفة BIND `UNSIGNED-INTEGER`) |
| TAG ID | `0x062L` |
| Codec ID | `0x00000620` |
| مستند المواصفة | `0x00000000/codecs/0x00000620/` (هدف DECLARE هو `0620`) |
| القسم | 3 `0011` (Value)، الإزاحة داخل القسم C = 2 |
| Kind | Value · العائلة: NUMERIC |
| TAG WORD | `0000 0110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | عدد صحيح unsigned magnitude بترتيب big-endian وبأقل عدد من WORD |
| جهة Hugo | `value/numeric/unsigned-integer.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `magnitude` | #2 | القيمة الخام المتبقية (`0xFFFF`) |  |  |

UNSIGNED-INTEGER قيمة Value تمثل عدداً صحيحاً بلا إشارة. الرمز المباشر في Value هو `0x062L` والعائلة NUMERIC. يُقرأ Payload كله على أنه unsigned magnitude بدقة اعتباطية بترتيب WORD من نوع big-endian. Payload لا يقل عن 1 WORD، ولا يُسمح إلا بالتمثيل القياسي بأقل عدد من WORD.

## التخطيط {#레이아웃}

```
TAG WORD          0000 0110 0010 LLLL      Codec 0x062L
[TAG ممتد لـ Length] عندما يبلغ المجموع 15 WORD أو أكثر
Payload WORD 1st  (WORD العليا)   Unsigned Magnitude 1st
...
Payload WORD Nth  (WORD الدنيا)   Unsigned Magnitude Nth
```

## التفسير {#해석}

- أول Payload WORD هي أعلى خانة، وآخر WORD هي أدنى خانة.
- إذا كان Payload بطول N WORD فيُقرأ unsigned magnitude واحداً بعرض `16N` bit.
- هذا العرض ليس عرض تخزين مُعلَناً، ولا يوجد bit width descriptor.

## التمثيل القياسي {#정규-표현}

- العدد 0 هو Payload من 1 WORD هي `0000`.
- إذا كان Payload من WORD اثنتين أو أكثر وكانت أول WORD هي `0000` فهو غير قياسي، لأن حذفها لا يغيّر القيمة.
- يجب على المفكّك أن يرفض التمثيل الذي فيه WORD أصفار سابقة لا حاجة إليها.

## الطول {#길이}

- المجموع هو عدد WORD في TAG (1 WORD) وTAG الممتد لـ Length (إن وُجد) وPayload معاً. يُستخدم الطول المباشر حتى 14 WORD، والطول الممتد `1110`·`1111` من 15 WORD فأكثر، وتُحسب TAG الممتدة ضمن المجموع ([السجل وTAG WORD](../record.md)).
- لا يُحفظ العرض المُعلَن مثل UINT8 وUINT16 وUINT32، بل تُحفظ القيمة العددية فقط.

## مثال {#예시}

| القيمة | Payload WORD | الحكم |
|---:|---|---|
| 0 | `0000` | قياسي |
| 1 | `0001` | قياسي |
| 65535 | `FFFF` | قياسي |
| 65536 | `0001 0000` | قياسي |
| 1 | `0000 0001` | غير قياسي: `0000` سابقة لا حاجة إليها |
| Payload من 7 WORD | 7 WORD بعد TAG `0627` (طول مباشر `LLLL=0111`، المجموع 8 WORD) | قياسي |
| Payload من 7 WORD | 7 WORD بعد TAG الطول الممتد والقيمة الممتدة `0009` | غير قياسي: يُستخدم الطول المباشر حتى 14 WORD |

## مكانة الصيغة {#형식-지위}

- هذا التمثيل الذي يوحّد unsigned magnitude اعتباطي الدقة في سلسلة WORD بحد أدنى 16 بت ويجمعه مع TAG الخاصة بـ GEUL هو scalar profile خاص بـ GEUL.
- عند التبادل مع أنواع خارجية ثابتة العرض مثل UINT8/16/32/64 يلزم فحص المدى وتحويل صريح للعرض.

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يظهر عند قراءة مستند المواصفة `0x00000000/codecs/0x00000620/latest.geul` بالأمر `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000062000000000
BODY
#1 DECLARE 0x0620
#2 FIELD #1 rest
#3 BIND #1 "UNSIGNED-INTEGER"
#4 BIND #2 "magnitude"
```
