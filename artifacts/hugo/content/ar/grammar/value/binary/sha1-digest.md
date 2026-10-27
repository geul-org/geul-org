---
title: "SHA1-DIGEST"
weight: 99
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA1-DIGEST قيمة Value ثابتة من 11 WORD تحمل ناتج SHA-1 كاملاً (160bit)، وتُستخدم لأغراض التعريف فقط مثل معرّف كائن git."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA1-DIGEST قيمة Value ثابتة العرض تحمل ناتج SHA-1 كاملاً. الرمز المباشر في Value هو `0x62` والعائلة BINARY. Payload هو 10 WORD (160 bit) تماماً، ولا يُسمح بالاقتطاع (truncation).

**تُستخدم لأغراض التعريف فقط.** كُسرت مقاومة SHA-1 للتصادم (SHAttered عام 2017). يُستخدم [SHA-256-DIGEST](/ar/grammar/value/binary/sha-256-digest/) أساساً للسلامة والتوقيع. وُضعت هذه الصيغة لحمل المعرّفات التي حُدِّدت أصلاً بـ SHA-1 كما هي، وأبرزها معرّف كائن (معرّف commit) في مستودع git الذي يستخدم SHA-1. مثلاً تحمل Version (معرّف commit) في [TRANSFORMED-BY](/ar/grammar/meta/lineage/transformed-by/) في 11 WORD بدل نص hex (22 WORD).

## التخطيط

```
TAG WORD          0x0D62 (0000 1101 0110 0010)  LLLL=1010
Payload           10 WORD  SHA-1 Digest
```

## التفسير والصلاحية

- تُقرأ octets الـ 20 في Payload بترتيب ناتج SHA-1 كما هو. في كل WORD يأتي octet الأعلى أولاً (framing نفسه في SHA-256-DIGEST).
- يُرفض التمثيل الذي لا يكون Payload فيه 10 WORD أو الذي اقتُطع فيه الناتج تعسفاً (مثل معرّف git المختصر). لا يوجد descriptor ولا padding.
- معرّف كائن git هو القيمة التي حسبها git كما هي. SHA-1 في git نسخة معدّلة تضيف كشف التصادم (SHA-1DC)، لكن مع المدخلات التي ليست هجوم تصادم تكون النتيجة مطابقة لـ SHA-1.

## السند المعياري

- خوارزمية SHA-1 والناتج ذو 160bit يتبعان NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- قواعد TAG وframing بـ WORD ذات 16bit في GEUL هي ما تضيفه هذه الصيغة.

## الطول

- المجموع هو TAG (1 WORD) وPayload (10 WORD)، أي 11 WORD تماماً، ويُستخدم `LLLL=1010`. لا يوجد Length ممتد.

## أمثلة

commit في git `ddc0719974a32aaa7b422ee84221a9721085ce4c`:

```
0D62 ddc0 7199 74a3 2aaa 7b42 2ee8 4221 a972 1085 ce4c
```

## صفحات ذات صلة

- [Value](/ar/grammar/value/)، [SHA-256-DIGEST](/ar/grammar/value/binary/sha-256-digest/)، [TRANSFORMED-BY](/ar/grammar/meta/lineage/transformed-by/)
