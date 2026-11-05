---
title: "EXCEPT-DECLARE (0x105L)"
weight: 261
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EXCEPT-DECLARE هو Codec من نوع NODE يكتب عقدة في رسم TOULMIN."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXCEPT-DECLARE هو Codec من نوع NODE يكتب عقدة في رسم TOULMIN. المعنى: إعلان استثناء. يهاجم دون استنتاج خاص به. Level الافتراضي هو Review.

| البند | القيمة |
|---|---|
| الاسم | `EXCEPT-DECLARE` (مستند المواصفة BIND `EXCEPT-DECLARE`) |
| TAG ID | `0x105L` |
| Codec ID | `0x00001050` |
| مستند المواصفة | `0x00000000/codecs/0x00001050/` (هدف DECLARE هو `1050`) |
| القسم | 8 `1000` (Edge TOULMIN)، الإزاحة داخل القسم C = 5 |
| Kind | Edge · العائلة: TOULMIN، الحزمة: الإعلان، التخطيط: NODE |
| TAG WORD | `0001 0000 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | إعلان استثناء. يهاجم دون استنتاج خاص به. Level الافتراضي هو Review |
| جهة Hugo | `edge/toulmin/node.md` |

## التخطيط {#레이아웃}

التخطيط هو [NODE](_index.md#node). تحدد ترويسة من 1 WORD قيمة role وlevel وشكل Claim والحقول الشرطية.

| البند | القيمة |
|---|---|
| TANGEUL | except rule |
| العقدة | استثناء (Defeater) |

- يجب أن يكون role بالقيمة 2 (except). إذا كان level بالقيمة 0 (Unset) استُخدمت القيمة الافتراضية للمحرك وهي Review.
- تتبع الحقول المشتركة (ID وREF وSPAN) وقواعد الأعداد ما في [TOULMIN](_index.md#공통-필드).

## مستند Codec {#코덱-문서}

يتضمن مستند Codec عنصر DECLARE (الهدف `1050`). لا يمكن إعلان الحقول الشرطية في تخطيط NODE وعرض SPAN الذي يحدده SOURCE بواسطة FIELD، لذا فإعلان الحقول مسألة مفتوحة ([TOULMIN](_index.md#열린-문제)).

## صفحات ذات صلة {#관련-페이지}

- [NODE](_index.md#node)، [TOULMIN](_index.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يعرضه `geul show` عند قراءة مستند المواصفة `0x00000000/codecs/0x00001050/latest.geul` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000105000000000
BODY
#1 DECLARE 0x1050
#2 BIND #1 "EXCEPT-DECLARE"
```
