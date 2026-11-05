---
title: "EVALUATES (0x12FL)"
weight: 303
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EVALUATES هو Codec من نوع LINK يكتب علاقة في رسم TOULMIN."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EVALUATES هو Codec من نوع LINK يكتب علاقة في رسم TOULMIN. المعنى: نقطة دخول → قضية، حكم.

| البند | القيمة |
|---|---|
| الاسم | `EVALUATES` (مستند المواصفة BIND `EVALUATES`) |
| TAG ID | `0x12FL` |
| Codec ID | `0x000012F0` |
| مستند المواصفة | `0x00000000/codecs/0x000012F0/` (هدف DECLARE هو `12F0`) |
| القسم | 9 `1001` (Edge صيغة TOULMIN)، الإزاحة داخل القسم C = 15 |
| Kind | Edge · العائلة: صيغة TOULMIN، التخطيط: LINK |
| TAG WORD | `0001 0010 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | نقطة دخول → قضية، حكم |
| جهة Hugo | `edge/toulmin/link.md` |

## التخطيط {#레이아웃}

التخطيط هو [LINK](_index.md#link) (ID وsrc وdst وflags والحقول الشرطية وSPAN).

| البند | القيمة |
|---|---|
| TANGEUL | نقطة دخول `check c` |
| src → dst | نقطة دخول → قضية (حكم) |

- dst هو REF للعقدة.
- لا يُستخدم F_FORCE (يُرفض إن كان مفعّلًا).
- تتبع الحقول المشتركة (ID وREF وSPAN) وقواعد الأعداد ما في [TOULMIN](_index.md#공통-필드).

## مستند Codec {#코덱-문서}

يتضمن مستند Codec عنصر DECLARE (الهدف `12F0`). لا يمكن إعلان الحقول الشرطية في تخطيط LINK وعرض SPAN الذي يحدده SOURCE بواسطة FIELD، لذا فإعلان الحقول مسألة مفتوحة ([TOULMIN](_index.md#열린-문제)).

## صفحات ذات صلة {#관련-페이지}

- [LINK](_index.md#link)، [TOULMIN](_index.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يعرضه `geul show` عند قراءة مستند المواصفة `0x00000000/codecs/0x000012F0/latest.geul` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000012F000000000
BODY
#1 DECLARE 0x12F0
#2 BIND #1 "EVALUATES"
```
