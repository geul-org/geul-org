---
title: "MEANS (0x12CL)"
weight: 300
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "MEANS هو Codec من نوع LINK يكتب علاقة في رسم TOULMIN."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

MEANS هو Codec من نوع LINK يكتب علاقة في رسم TOULMIN. المعنى: بند تعريف → قيمة أو نوع.

| البند | القيمة |
|---|---|
| الاسم | `MEANS` (مستند المواصفة BIND `MEANS`) |
| TAG ID | `0x12CL` |
| Codec ID | `0x000012C0` |
| مستند المواصفة | `0x00000000/codecs/0x000012C0/` (هدف DECLARE هو `12C0`) |
| القسم | 9 `1001` (Edge صيغة TOULMIN)، الإزاحة داخل القسم C = 12 |
| Kind | Edge · العائلة: صيغة TOULMIN، التخطيط: LINK |
| TAG WORD | `0001 0010 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | بند تعريف → قيمة أو نوع |
| جهة Hugo | `edge/toulmin/link.md` |

## التخطيط {#레이아웃}

التخطيط هو [LINK](_index.md#link) (ID وsrc وdst وflags والحقول الشرطية وSPAN).

| البند | القيمة |
|---|---|
| TANGEUL | `means` في Definitions |
| src → dst | بند تعريف → قيمة أو نوع |

- dst هو REF للعقدة.
- لا يُستخدم F_FORCE (يُرفض إن كان مفعّلًا).
- تتبع الحقول المشتركة (ID وREF وSPAN) وقواعد الأعداد ما في [TOULMIN](_index.md#공통-필드).

## مستند Codec {#코덱-문서}

يتضمن مستند Codec عنصر DECLARE (الهدف `12C0`). لا يمكن إعلان الحقول الشرطية في تخطيط LINK وعرض SPAN الذي يحدده SOURCE بواسطة FIELD، لذا فإعلان الحقول مسألة مفتوحة ([TOULMIN](_index.md#열린-문제)).

## صفحات ذات صلة {#관련-페이지}

- [LINK](_index.md#link)، [TOULMIN](_index.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يعرضه `geul show` عند قراءة مستند المواصفة `0x00000000/codecs/0x000012C0/latest.geul` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000012C000000000
BODY
#1 DECLARE 0x12C0
#2 BIND #1 "MEANS"
```
