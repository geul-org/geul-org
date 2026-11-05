---
title: "IMPORT-DOC (0x1E4L)"
weight: 484
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "يستورد مستنداً خارجياً بـ IMPORT ID."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `IMPORT-DOC` (BIND مستند المواصفة `IMPORT-DOC`) |
| TAG ID | `0x1E4L` |
| Codec ID | `0x00001E40` |
| مستند المواصفة | `0x00000000/codecs/0x00001E40/` (هدف DECLARE `1E40`) |
| القسم | 15 `1111` (Meta)، الإزاحة داخل القسم C = 4 |
| Kind | Meta · الفئة: IMPORT |
| TAG WORD | `0001 1110 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | يستورد مستنداً خارجياً بـ IMPORT ID. Reference مضمّن `DOC-POINTER` (ومستند Codec يستخدم `CODEC-POINTER`) + IMPORT ID |
| جهة Hugo | `meta/import/import-doc.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)).

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المستقبِلة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #4 | سجل | `0410` DOC-POINTER، `0420` CODEC-POINTER |  |
| 2 | `import-id` | #2 | قيمة خام للباقي (`0xFFFF`) |  |  |

يستورد مستنداً خارجياً بـ IMPORT ID. المستند المستورَد يشير إليه [DOC-POINTER](../reference/0x041L-doc-pointer.md)، وعرض Issuer يحمله DOC-POINTER أيضاً.

## التخطيط {#레이아웃}

```
TAG WORD          0001 1110 0100 LLLL      Codec 0x1E4L
[Length TAG ممتد]
المستند           سجل Reference من DOC-POINTER (Issuer، معرّف المستند، معرّف الإصدار. الإصدار 0 هو الأحدث). ومستند Codec يستخدم CODEC-POINTER
IMPORT ID         كل الباقي. unsigned بأقصر عرض
```

- Codec: Meta `0x1E4L`، فئة IMPORT
- Payload: Reference مضمّن `DOC-POINTER` (Issuer، معرّف المستند، معرّف الإصدار) + IMPORT ID قيمة خام
- العدد: يجوز تعدده (واحد لكل IMPORT ID)

## التفسير والصلاحية {#해석과-유효성}

- المستند هو سجل DOC-POINTER واحد بالضبط. وعند استيراد مستند Codec يكون سجل [CODEC-POINTER](../reference/0x042L-codec-pointer.md) (Issuer، Codec ID، معرّف الإصدار). وينتهي بـ Length الخاص به، والباقي هو IMPORT ID.
- IMPORT ID هو 1 WORD فأكثر بأقصر عرض. ويتحدد عرض IMPORT ID هنا بطول السجل، وفي [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md) بالـ Codec.
- لا يُعيَّن IMPORT ID نفسه مرتين في مستند واحد.
- إذا كُتب معرّف الإصدار فالربط بتلك النسخة، وإذا كان `0` فالربط بأحدث نسخة وقت التفسير (أو النسخة السارية في الوقت المحدد) ([التعديل](../document.md#개정)).
- يشير [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md) في BODY إلى LOCAL في المستند المستورَد بـ IMPORT ID. أما المستند المستورَد نفسه فيُشار إليه بـ DOC-POINTER.
- لا يُستورد HEAD للمستند المستورَد. وتُفسَّر أهداف ذلك المستند وفق تصريحاته هو.
- لا يمكن البحث عبر المستندات بـ IMPORT ID. والمستودع الذي يحمّل عدة مستندات يحل IMPORT ID إلى المسار الكامل (Issuer، معرّف المستند، معرّف الإصدار، LOCAL ID) ويخزنه.

## مثال {#예시}

- IMPORT ID 1، وIssuer `0x00000002`، والمستند `0x…0002`، والأحدث: `1E4A 0418 0000 0002 0000 0000 0000 0002 0000 0000 0001` (TAG لـ Meta 1 + DOC-POINTER 9 + IMPORT ID 1 = 11 WORD)

## نص مستند المواصفة {#규격-문서-원문}

هذه هي صورة مستند المواصفة `0x00000000/codecs/0x00001E40/latest.geul` عند قراءته بـ `geul show` (الأرقام الستة عشرية بأحرف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E4000000000
BODY
#1 DECLARE 0x1E40
#4 FIELD #1 record
#10 CODEC #4 0x0410
#2 FIELD #1 rest
#6 BIND #1 "IMPORT-DOC"
#7 BIND #2 "import-id"
#9 BIND #4 "doc"
#11 CODEC #4 0x0420
```
