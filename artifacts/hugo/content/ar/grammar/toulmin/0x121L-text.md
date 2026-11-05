---
title: "TEXT (0x121L)"
weight: 289
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "TEXT سجل النص الأصلي والتقسيم في مستند TOULMIN."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TEXT سجل النص الأصلي والتقسيم في مستند TOULMIN. المعنى: اسم أو سلسلة نصية.

| البند | القيمة |
|---|---|
| الاسم | `TEXT` (مستند المواصفة BIND `TEXT`) |
| TAG ID | `0x121L` |
| Codec ID | `0x00001210` |
| مستند المواصفة | `0x00000000/codecs/0x00001210/` (هدف DECLARE هو `1210`) |
| القسم | 9 `1001` (Edge صيغة TOULMIN)، الإزاحة داخل القسم C = 1 |
| Kind | Edge · العائلة: صيغة TOULMIN، التخطيط: ID وقيمة UTF8 Value |
| TAG WORD | `0001 0010 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | اسم أو سلسلة نصية |
| جهة Hugo | `edge/toulmin/source.md` |

## التخطيط {#레이아웃}

هذا اسم أو سلسلة نصية واحدة. تشير إليه بـ REF قوائم F_WITH وF_GROUNDS في NODE، و[LABEL](0x134L-label.md) و[IMPORTED-FROM](0x133L-imported-from.md) في LINK.

```
ID
السلسلة         سجل UTF8-TEXT Value
```

- ID هو Edge Id، وREF هو Edge Id لسجل في هذا المستند (الحقول المشتركة في [TOULMIN](_index.md#공통-필드)). يأتي Payload بعد TAG دون خانتَي Issuer ورقم Codec.

## مستند Codec {#코덱-문서}

يتضمن مستند Codec عنصر DECLARE (الهدف `1210`). يُحدَّد إعلان الحقول مع مستند مواصفة Codec الخاص بـ TOULMIN ([TOULMIN](_index.md#열린-문제)).

## صفحات ذات صلة {#관련-페이지}

- [SOURCE والتقسيم](_index.md#source와-구획)، [TOULMIN](_index.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يعرضه `geul show` عند قراءة مستند المواصفة `0x00000000/codecs/0x00001210/latest.geul` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000121000000000
BODY
#1 DECLARE 0x1210
#2 BIND #1 "TEXT"
```
