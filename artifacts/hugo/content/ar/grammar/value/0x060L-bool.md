---
title: "BOOL (0x060L)"
weight: 96
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BOOL قيمة Value تمثل القيمتين المنطقيتين false وtrue."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `BOOL` (مستند المواصفة BIND `BOOL`) |
| TAG ID | `0x060L` |
| Codec ID | `0x00000600` |
| مستند المواصفة | `0x00000000/codecs/0x00000600/` (هدف DECLARE هو `0600`) |
| القسم | 3 `0011` (Value)، الإزاحة داخل القسم C = 0 |
| Kind | Value · العائلة: NUMERIC |
| TAG WORD | `0000 0110 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | قيمة false أو true في WORD ثابتة واحدة |
| جهة Hugo | `value/numeric/bool.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | قيمة خام 1 WORD |  | `0x0000` false، `0x0001` true |

BOOL قيمة Value تمثل القيمتين المنطقيتين false وtrue. الرمز المباشر في Value هو `0x060L` والعائلة NUMERIC. وهو نوع مختلف عن SIGNED-INTEGER وUNSIGNED-INTEGER اللذين يحملان الرقمين 0 و1.

## التخطيط {#레이아웃}

```
TAG WORD          0x0601 (0000 0110 0000 0001)  المجموع 2 WORD
Payload           1 WORD  Boolean Code
```

## التفسير والصلاحية {#해석과-유효성}

- Payload `0000` هو false و`0001` هو true.
- لا يوجد padding ولا descriptor.
- Payload هو بالضبط `0000` أو `0001`. أي قيمة أخرى من 16 بت تُرفض لأنها invalid.
- أي تمثيل آخر لـ Length يُرفض لأنه invalid.

## الطول {#길이}

- المجموع هو TAG (1 WORD) وPayload (1 WORD)، أي 2 WORD تماماً، ويُستخدم الطول المباشر `LLLL=0001`. لا يوجد TAG ممتد لـ Length ولا descriptor ولا padding.
- يُرفض ما لا يكون Payload فيه 1 WORD تماماً.

## مثال {#예시}

| السجل الكامل (TAG + Payload) | Payload | الحكم |
|---|---|---|
| `0601 0000` | `0000` | false، قياسي |
| `0601 0001` | `0001` | true، قياسي |
| `0601 0002` | `0002` | invalid |
| `0601 FFFF` | `FFFF` | invalid |
| TAG بـ Length غير `0001` + `0000` أو `0001` | `0000` أو `0001` | invalid |

## مكانة الصيغة {#형식-지위}

- هذا التمثيل الذي يجمع كلمة code ذات 16 بت (`0000`/`0001`) مع TAG الخاصة بـ GEUL هو scalar profile خاص بـ GEUL.
- القيمة المنطقية نفسها عامة، لكن لا ندّعي وجود معيار صناعي واحد يطابق هذا التمثيل بـ 1 WORD.

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يظهر عند قراءة مستند المواصفة `0x00000000/codecs/0x00000600/latest.geul` بالأمر `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000060000000000
BODY
#1 DECLARE 0x0600
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 BIND #1 "BOOL"
#6 BIND #2 "code"
#7 BIND #3 "false"
#8 BIND #4 "true"
```
