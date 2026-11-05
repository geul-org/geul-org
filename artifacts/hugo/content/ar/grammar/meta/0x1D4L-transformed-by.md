---
title: "TRANSFORMED-BY (0x1D4L)"
weight: 468
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "يكتب طريقة التحويل من تمثيل آخر إلى هذا المستند (مثلاً: محوّل ويكي بيانات، مشفّر اللغة الطبيعية)."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `TRANSFORMED-BY` (BIND مستند المواصفة `TRANSFORMED-BY`) |
| TAG ID | `0x1D4L` |
| Codec ID | `0x00001D40` |
| مستند المواصفة | `0x00000000/codecs/0x00001D40/` (هدف DECLARE `1D40`) |
| القسم | 14 `1110` (Meta)، الإزاحة داخل القسم C = 20 |
| Kind | Meta · الفئة: النسب |
| TAG WORD | `0001 1101 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | طريقة التحويل. الأداة والقواعد والإصدار |
| جهة Hugo | `meta/lineage/transformed-by.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `tool` | #2 | سجل | أي سجل (باستثناء علامة الموضع) |  |
| 2 | `version` | #3 | سجل | `07C0` SHA-256-DIGEST، `07D0` SHA1-DIGEST |  |

يكتب طريقة التحويل من تمثيل آخر إلى هذا المستند (مثلاً: محوّل ويكي بيانات، مشفّر اللغة الطبيعية). Tool هو ما جرى به التحويل، وVersion هو أي مصدر لتلك الأداة جرى به التحويل. وبوجودهما معاً يمكن إعادة إنتاج المستند نفسه من المدخل نفسه.

## التخطيط {#레이아웃}

```
TAG WORD          0001 1101 0100 LLLL      Codec 0x1D4L
[Length TAG ممتد]
Tool              سجل Reference واحد (أداة التحويل أو القواعد)
Version           سجل Value واحد (SHA-256-DIGEST أو SHA1-DIGEST)
```

- Codec: Meta `0x1D4L`، فئة النسب
- Payload: Reference مضمّن (الأداة) + Value مضمّنة (digest إصدار المصدر)
- العدد: يجوز تعدده (واحد لكل أداة)

## التفسير والصلاحية {#해석과-유효성}

- Tool هو سجل Reference كامل واحد بالضبط. ويصح أي Reference يشير إلى أداة.
  - أداة في مستند أدوات geul.org: [EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md) (`0x00000000`، معرّف المستند `0x0001xxxx xxxxxxxx`، وLOCAL فيه). مستند واحد لكل أداة (مستند تعريف المصطلحات في [Issuer](../issuer.md)).
  - إذا كان الـ Codec مستند GEUL فيُشار إلى مستند ذلك الـ Codec بـ [CODEC-POINTER](../reference/0x042L-codec-pointer.md).
- Version هو سجل Value كامل واحد بالضبط، وهو معرّف الكائن في نظام التحكم بالإصدارات لمصدر Tool. وفي git هو معرّف كائن commit كاملاً.
  - إذا كان تنسيق كائنات مستودع git هو SHA-256 فـ [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md) (`0x07CL`، 16 WORD)، وإذا كان SHA-1 فـ [SHA1-DIGEST](../value/0x07DL-sha1-digest.md) (`0x07DL`، 10 WORD). ويُتحقق من تنسيق المستودع بـ `git rev-parse --show-object-format`.
  - لا تُستخدم المعرّفات المختصرة (مثل `2bd496f`). فقيمة digest لا تقبل القيمة المقتطعة.
  - لا يُكتب بنص hex (UTF8-TEXT). فالقيمة نفسها تكون 22 WORD في SHA-1 (11 في الثنائي) و34 WORD في SHA-256 (18 في الثنائي).
- Version إلزامي. فسجل أداة لا يُعرف إصدار مصدرها لا يصلح أساساً لإعادة الإنتاج. وإذا كانت الأداة خارج التحكم بالإصدارات فيُستخدم SHA-256 للحزمة الموزَّعة (SHA-256-DIGEST).
- Version يشير إلى مصدر مُودَع (committed). ولا يُكتب معرّف commit ذاك في مستند أُنتج بشجرة عمل فيها تغييرات غير مُودَعة (يُوصى بأن ترفض الأداة التنفيذ).
- إذا اعتمدت الأداة على شيفرة خارج المستودع (مثلاً: مكتبة محلية أشار إليها `replace` في Go) فتُكتب تلك الشيفرة أيضاً منفصلةً في TRANSFORMED-BY. فمعرّف commit للأداة وحده لا يحدد تلك الشيفرة.
- الأداة التي تنقل المصدر دون فقد فقط (مثلاً: أداة تحمّل الـ dump في قاعدة البيانات كما هو) لا تحدد محتوى المستند فلا تُكتب. أما التحميل الذي فيه فقد فيغيّر المستند فيُكتب أداةً.
- مستند مواصفة geul.org (`0x1D40`) يُكتب بسجلين: Tool (العرض 0، أي Reference فلا CODEC) وVersion (العرض 0، [CODEC](../edge/0x0BEL-codec.md) `07C0` و`07D0`).

## الطول {#길이}

```
المجموع = 1 + N_len + N_tool + N_version WORD
```

- يجب أن يطابق المؤشر بعد قراءة آخر سجل نهاية Meta تماماً.
- إذا كان Tool هو EXTERNAL-ISSUER-2WORD (8 WORD) وVersion هو SHA1-DIGEST (11 WORD) فالمجموع 1 + 1 + 8 + 11 = 21 WORD ويُستخدم الطول الممتد. وإذا كان SHA-256-DIGEST (18 WORD) فالمجموع 28 WORD.

## مثال {#예시}

مثال غير معياري. الأداة هي LOCAL 2 في مستند أدوات geul.org `0x0001000000000001` (`02F7 0000 0000 0001 0000 0000 0001 0002`)، والمصدر هو commit `ddc0719974a32aaa7b422ee84221a9721085ce4c` (SHA-1).

```
1D4E 0015
02F7 0000 0000 0001 0000 0000 0001 0002
07DA DDC0 7199 74A3 2AAA 7B42 2EE8 4221 A972 1085 CE4C
```

## مسائل مفتوحة {#열린-문제}

- هل يُغيَّر إصدار [GENERATED-BY](0x1D3L-generated-by.md) أيضاً بالطريقة نفسها (digest إلزامي أو صيغة أخرى). فإصدار النموذج ليس معرّف commit.

## صفحات ذات صلة {#관련-페이지}

- [Meta](_index.md)، [GENERATED-BY](0x1D3L-generated-by.md)، [DERIVED-FROM](0x1D2L-derived-from.md)
- [EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md)، [DOC-POINTER](../reference/0x041L-doc-pointer.md)، [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md)، [SHA1-DIGEST](../value/0x07DL-sha1-digest.md)، [CODEC](../edge/0x0BEL-codec.md)

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001D40/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D4000000000
BODY
#1 DECLARE 0x1D40
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "TRANSFORMED-BY"
#5 BIND #2 "tool"
#6 BIND #3 "version"
#7 CODEC #3 0x07C0
#8 CODEC #3 0x07D0
```
