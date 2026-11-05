---
title: "LABEL (0x134L)"
weight: 308
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LABEL هو Codec من نوع LINK يكتب علاقة في رسم TOULMIN."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LABEL هو Codec من نوع LINK يكتب علاقة في رسم TOULMIN. المعنى: عقدة → TEXT، كتابة الاسم.

| البند | القيمة |
|---|---|
| الاسم | `LABEL` (مستند المواصفة BIND `LABEL`) |
| TAG ID | `0x134L` |
| Codec ID | `0x00001340` |
| مستند المواصفة | `0x00000000/codecs/0x00001340/` (هدف DECLARE هو `1340`) |
| القسم | 9 `1001` (Edge صيغة TOULMIN)، الإزاحة داخل القسم C = 20 |
| Kind | Edge · العائلة: صيغة TOULMIN، التخطيط: LINK |
| TAG WORD | `0001 0011 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | عقدة → TEXT، كتابة الاسم |
| جهة Hugo | `edge/toulmin/link.md` |

## التخطيط {#레이아웃}

التخطيط هو [LINK](_index.md#link) (ID وsrc وdst وflags والحقول الشرطية وSPAN).

| البند | القيمة |
|---|---|
| TANGEUL | اسم بين علامتَي backtick |
| src → dst | عقدة → TEXT. كتابة الاسم |

- dst هو REF لسجل TEXT. وهل يوضع الاسم بين علامتَي backtick في [LABEL](../edge/0x0A4L-label.md) أو [BIND](../edge/0x0A3L-bind.md) السرديين مسألة مفتوحة ([TOULMIN](_index.md#열린-문제)).
- لا يُستخدم F_FORCE (يُرفض إن كان مفعّلًا).
- تتبع الحقول المشتركة (ID وREF وSPAN) وقواعد الأعداد ما في [TOULMIN](_index.md#공통-필드).

## مستند Codec {#코덱-문서}

يتضمن مستند Codec عنصر DECLARE (الهدف `1340`). لا يمكن إعلان الحقول الشرطية في تخطيط LINK وعرض SPAN الذي يحدده SOURCE بواسطة FIELD، لذا فإعلان الحقول مسألة مفتوحة ([TOULMIN](_index.md#열린-문제)).

## صفحات ذات صلة {#관련-페이지}

- [LINK](_index.md#link)، [TOULMIN](_index.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يعرضه `geul show` عند قراءة مستند المواصفة `0x00000000/codecs/0x00001340/latest.geul` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000134000000000
BODY
#1 DECLARE 0x1340
#2 BIND #1 "LABEL"
```
