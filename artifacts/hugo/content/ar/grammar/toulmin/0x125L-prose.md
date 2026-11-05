---
title: "PROSE (0x125L)"
weight: 293
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "PROSE سجل النص الأصلي والتقسيم في مستند TOULMIN."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PROSE سجل النص الأصلي والتقسيم في مستند TOULMIN. المعنى: فقرة سردية.

| البند | القيمة |
|---|---|
| الاسم | `PROSE` (مستند المواصفة BIND `PROSE`) |
| TAG ID | `0x125L` |
| Codec ID | `0x00001250` |
| مستند المواصفة | `0x00000000/codecs/0x00001250/` (هدف DECLARE هو `1250`) |
| القسم | 9 `1001` (Edge صيغة TOULMIN)، الإزاحة داخل القسم C = 5 |
| Kind | Edge · العائلة: صيغة TOULMIN، التخطيط: ID وSPAN |
| TAG WORD | `0001 0010 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | فقرة سردية |
| جهة Hugo | `edge/toulmin/source.md` |

## التخطيط {#레이아웃}

هذه فقرة سردية ليست قاعدة. تشير إلى نطاق (SPAN) في النص الأصلي فقط.

```
ID
SPAN             العرض الذي يحدده SOURCE × 2 (بايت البداية، عدد البايتات)
```

- ID هو Edge Id، وREF هو Edge Id لسجل في هذا المستند (الحقول المشتركة في [TOULMIN](_index.md#공통-필드)). يأتي Payload بعد TAG دون خانتَي Issuer ورقم Codec.

## مستند Codec {#코덱-문서}

يتضمن مستند Codec عنصر DECLARE (الهدف `1250`). عرض SPAN يحدده SOURCE فلا يمكن إعلانه بواسطة FIELD، لذا فإعلان الحقول مسألة مفتوحة ([TOULMIN](_index.md#열린-문제)).

## صفحات ذات صلة {#관련-페이지}

- [SOURCE والتقسيم](_index.md#source와-구획)، [TOULMIN](_index.md)

## نص مستند المواصفة {#규격-문서-원문}

هذا ما يعرضه `geul show` عند قراءة مستند المواصفة `0x00000000/codecs/0x00001250/latest.geul` (الأرقام السداسية عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000125000000000
BODY
#1 DECLARE 0x1250
#2 BIND #1 "PROSE"
```
