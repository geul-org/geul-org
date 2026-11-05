---
title: "UNTIL (0x131L)"
weight: 305
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "UNTIL هو Codec من نوع LINK يكتب علاقة في رسم TOULMIN."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNTIL هو Codec من نوع LINK يكتب علاقة في رسم TOULMIN. المعنى: محفّز → قضية (`every … until`).

| البند | القيمة |
|---|---|
| الاسم | `UNTIL` (مستند المواصفة BIND `UNTIL`) |
| TAG ID | `0x131L` |
| Codec ID | `0x00001310` |
| مستند المواصفة | `0x00000000/codecs/0x00001310/` (هدف DECLARE هو `1310`) |
| القسم | 9 `1001` (Edge صيغة TOULMIN)، الإزاحة داخل القسم C = 17 |
| Kind | Edge · العائلة: صيغة TOULMIN، التخطيط: LINK |
| TAG WORD | `0001 0011 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | محفّز → قضية (`every … until`) |
| جهة Hugo | `edge/toulmin/link.md` |

## التخطيط {#레이아웃}

التخطيط هو [LINK](_index.md#link) (ID وsrc وdst وflags والحقول الشرطية وSPAN).

| البند | القيمة |
|---|---|
| TANGEUL | `every … until c` |
| src → dst | محفّز → قضية |

- dst هو REF للعقدة.
- لا يُستخدم F_FORCE (يُرفض إن كان مفعّلًا).
- تتبع الحقول المشتركة (ID وREF وSPAN) وقواعد الأعداد ما في [TOULMIN](_index.md#공통-필드).

## مستند Codec {#코덱-문서}

يتضمن مستند Codec عنصر DECLARE (الهدف `1310`). لا يمكن إعلان الحقول الشرطية في تخطيط LINK وعرض SPAN الذي يحدده SOURCE بواسطة FIELD، لذا فإعلان الحقول مسألة مفتوحة ([TOULMIN](_index.md#열린-문제)).

## صفحات ذات صلة {#관련-페이지}

- [LINK](_index.md#link)، [TOULMIN](_index.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يعرضه `geul show` عند قراءة مستند المواصفة `0x00000000/codecs/0x00001310/latest.geul` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000131000000000
BODY
#1 DECLARE 0x1310
#2 BIND #1 "UNTIL"
```
