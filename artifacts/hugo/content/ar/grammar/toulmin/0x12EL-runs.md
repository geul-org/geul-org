---
title: "RUNS (0x12EL)"
weight: 302
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "RUNS هو Codec من نوع LINK يكتب علاقة في رسم TOULMIN."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RUNS هو Codec من نوع LINK يكتب علاقة في رسم TOULMIN. المعنى: نقطة دخول → قضية، تنفيذ.

| البند | القيمة |
|---|---|
| الاسم | `RUNS` (مستند المواصفة BIND `RUNS`) |
| TAG ID | `0x12EL` |
| Codec ID | `0x000012E0` |
| مستند المواصفة | `0x00000000/codecs/0x000012E0/` (هدف DECLARE هو `12E0`) |
| القسم | 9 `1001` (Edge صيغة TOULMIN)، الإزاحة داخل القسم C = 14 |
| Kind | Edge · العائلة: صيغة TOULMIN، التخطيط: LINK |
| TAG WORD | `0001 0010 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | نقطة دخول → قضية، تنفيذ |
| جهة Hugo | `edge/toulmin/link.md` |

## التخطيط {#레이아웃}

التخطيط هو [LINK](_index.md#link) (ID وsrc وdst وflags والحقول الشرطية وSPAN).

| البند | القيمة |
|---|---|
| TANGEUL | نقطة دخول `run c` |
| src → dst | نقطة دخول → قضية (تنفيذ) |

- dst هو REF للعقدة.
- لا يُستخدم F_FORCE (يُرفض إن كان مفعّلًا).
- تتبع الحقول المشتركة (ID وREF وSPAN) وقواعد الأعداد ما في [TOULMIN](_index.md#공통-필드).

## مستند Codec {#코덱-문서}

يتضمن مستند Codec عنصر DECLARE (الهدف `12E0`). لا يمكن إعلان الحقول الشرطية في تخطيط LINK وعرض SPAN الذي يحدده SOURCE بواسطة FIELD، لذا فإعلان الحقول مسألة مفتوحة ([TOULMIN](_index.md#열린-문제)).

## صفحات ذات صلة {#관련-페이지}

- [LINK](_index.md#link)، [TOULMIN](_index.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يعرضه `geul show` عند قراءة مستند المواصفة `0x00000000/codecs/0x000012E0/latest.geul` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000012E000000000
BODY
#1 DECLARE 0x12E0
#2 BIND #1 "RUNS"
```
