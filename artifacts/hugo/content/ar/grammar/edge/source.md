---
title: "SOURCE"
weight: 33
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SOURCE هو Edge دليل يصل سجلاً واحداً أو المستند كله بمصدره (Codec 0x20). خصائص المصدر تُكتب بـ TRIPLE يكون المصدر فيه Subject، وخصائص الاقتباس (تاريخ الاطلاع وموضعه داخل المصدر وتجزئة النص الأصلي) بـ QUALIFIER تُلحق بـ SOURCE. وSOURCE الخاص بالمستند كله يوضع في HEAD."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SOURCE هو Edge دليل يصل سجلاً واحداً (الهدف) أو المستند كله بالمصدر الذي جاء منه. Codec `0x20`. وهو الرمز المباشر الوحيد في عائلة الدليل (`01`).

يعادل SOURCE واحد مرجعاً (reference، مجموعة مصادر) واحداً في ويكي بيانات. فإذا كان لسجل واحد عدة مصادر فهناك عدة SOURCE.

## التخطيط

```
TAG WORD          0001 0LLL L010 0000
[Length ممتد TAG]
Edge Id           سجل Reference من نوع LOCAL
Target            سجل Reference من نوع LOCAL (في BODY هو Edge Id الخاص بالـ Edge الذي يُلحق به الدليل، وفي HEAD هو 0 = المستند كله)
Origin            سجل Reference، أو علامة موضع 0x0000 ABSENT·0x0001 UNKNOWN-VALUE
```

- يشير Origin إلى المصدر. فإن وُجد Reference مناسب للمصدر فهو (WIKIDATA-QID أو DOC-POINTER وEXTERNAL-ISSUER لمستند GEUL وغيرها)، وإلا فهو عقدة LOCAL في هذا المستند.
- إذا لم يصف المرجع المصدر (مثل مرجع في ويكي بيانات فيه "imported from" (P143) وتاريخ الاطلاع فقط) فـ Origin هو [ABSENT](/ar/grammar/reference/slot-marker/) (غير مكتوب). فالكاتب لم يكتب المصدر فقط ولا يقرر شيئاً عن المصدر. وبقية المرجع موجودة في QUALIFIER كما هي.
- لا يُستخدم [UNKNOWN-VALUE](/ar/grammar/reference/slot-marker/) إلا حين يقرر الكاتب أن "المصدر موجود لكن لا يُعرف ما هو" (مثل السجلات التي يكتبها الإنسان). أما المحوّل الذي ينقل من مادة مصدرية فلا يقرر ما لم يقله المصدر، فيستخدم ABSENT.
- Origin الذي هو ABSENT أو UNKNOWN-VALUE مستقل في كل ظهور. ولا يُقرأ مصدرا SOURCE على أنهما واحد.

## طبقتان

المعلومات عن المصدر نوعان. ولا يُخلطان.

| الطبقة | ماذا | كيف تُكتب | مثال |
|---|---|---|---|
| المصدر | خصائص المصدر نفسه. هي ذاتها أياً كان من يقتبس | [TRIPLE](/ar/grammar/edge/triple/) يكون المصدر فيه Subject (rank normal) | URL (P854) والعنوان (P1476) والمؤلف (P50·P2093) وتاريخ النشر (P577) والمطبوعة (P1433) والناشر (P123) واللغة (P407) |
| الاقتباس | خصائص فعل اقتباس هذا السجل للمصدر | [QUALIFIER](/ar/grammar/edge/qualifier/) يكون Target فيه هو Edge Id الخاص بـ SOURCE | تاريخ الاطلاع (P813) والموضع داخل المصدر (الصفحة P304 والفقرة P958 والمعرّف الخارجي P227·P1417) ومصدر النقل (P143) وطريقة الاستنتاج (P887) وتجزئة النص الأصلي (P4092) |

- **معنى SOURCE هو مجموع كل QUALIFIER التي تشير إلى Edge Id الخاص به.** مرجعان لمصدر واحد اطُّلع عليه في يومين مختلفين مصدرهما واحد وQUALIFIER فيهما مختلفة.
- TRIPLE المصدر دعوى عن المصدر. والخاصية التي لم يتحدد في أي طبقة هي توضع في جهة الاقتباس (QUALIFIER). والأسلم ألا يُدّعى شيء عن المصدر.
- المصدر نفسه داخل المستند يُصرَّح به مرة واحدة فقط بـ LOCAL واحد وتشير إليه عدة SOURCE معاً.
- المصدر الذي يوصف بـ URL واحد فقط يُعرَّف بـ [REFERENCE-NODE](/ar/grammar/edge/reference-node/) (LOCAL → URI). وهذا مثل صفحة مستند sitelink.

## التفسير والصلاحية

- Target وOrigin كل منهما سجل كامل واحد بالضبط. ويجب أن يتطابق المؤشر بعد قراءة Origin مع نهاية Edge.
- Target هو Reference من نوع LOCAL. وSOURCE في BODY يشير إلى Edge Id في BODY في المستند نفسه. و`0` (المستند كله) لا يستخدمه إلا SOURCE في HEAD ([مصدر المستند كله](#مصدر-المستند-كله)). ووجود SOURCE في BODY بـ Target `0` هو invalid. وسجل المستند الآخر يُلحق به الدليل داخل ذلك المستند.
- Origin هو Reference. ولا تقبل علامة الموضع إلا `0x0000` (ABSENT) و`0x0001` (UNKNOWN-VALUE). ولا تقبل NO-VALUE (`0x0002`) ولا Value.
- تضع مواصفة geul.org `0x0000/0x0000000000001020` (الاسم `source`) في Target [CODEC](/ar/grammar/edge/codec/) من LOCAL (`0008`)، وفي Origin CODEC `0780` (أي Reference) و`0000` (ABSENT، اختياري) و`0001` (UNKNOWN-VALUE).
- لا معنى للترتيب بين SOURCE ذات Target واحد. ولا معنى لترتيب البنود داخل مرجع واحد أيضاً (ترتيب قيم الخاصية نفسها يبقى بترتيب المستند).
- لا يغيّر SOURCE صحة الهدف أو خطأه. إنما يكتب من أين جاء الهدف. ونتيجة الحكم من شأن [TOULMIN](/ar/grammar/edge/toulmin/) `VERDICT`.

## مصدر المستند كله

مصدر المستند كله (dump الأصل والإصدار وملف النص الأصلي) يُكتب في **HEAD بـ SOURCE ذي Target `0`**. وتوضع في HEAD أيضاً QUALIFIER التي تجعل ذلك SOURCE هو Target (تجزئة النص الأصلي P4092 ووقت الاستلام P813 ونطاق النص الأصلي وغيرها) ([المستند](/ar/grammar/document/#head-وbody)).

- هاتان هما Edge الوحيدتان اللتان يجوز وضعهما في HEAD. أما بقية Edge فتوضع في BODY.
- تُوضع QUALIFIER في HEAD بعد SOURCE الذي تشير إليه في HEAD. فيقرأ المفكك من البداية ويفصل بين HEAD وBODY.
- يكون invalid وضع QUALIFIER في BODY هدفها SOURCE في HEAD. ولا يشير SOURCE وQUALIFIER في BODY إلى Edge في HEAD.
- **يشترك HEAD وBODY في فضاء أرقام واحد لـ Edge Id.** فهو فريد في المستند، ويؤخذ من [NEXT-LOCAL-ID](/ar/grammar/meta/lineage/next-local-id/) كبقية Edge، وعند إعادة البناء بالمحتوى نفسه يُورَّث الرقم نفسه. وحتى في إصدار سقطت منه Edge في HEAD لا يُعاد استخدام ذلك الرقم.
- إذا كان Origin هو LOCAL فتوضع تعريفاته (REFERENCE-NODE وTRIPLE المصدر) في BODY. فنطاق LOCAL هو المستند كله.
- Edge في HEAD ليست Meta من فئة التحقق، لذلك تدخل في [تجزئة المحتوى](/ar/grammar/document/#تجزئة-المحتوى). وفي diff تتغير مع HEAD كاملاً (ولا تُكتب في `DELTA-REMOVE`).
- لا يوجد Meta خاص بمصدر المستند كله. فنطاق النص الأصلي ووقت الحصول المكتوبان بـ Meta لا يمكن أن يُعرف إذا تعددت المصادر لأي مصدر هما. أما QUALIFIER المُلحق بـ SOURCE فيحدد ذلك بـ Target.

مثال: HEAD في مستند Q42 المنقول من dump ويكي بيانات (Edge Id للتوضيح فقط).

```
SPEC-VERSION  0x0001
DOC-ID        0x00010000/0x510000000000002a
TRANSFORMED-BY …
#1738 SOURCE     #0     #1735                                         إصدار الكيان (revision)
#1741 SOURCE     #0     #1740                                         ملف dump
#1742 QUALIFIER  P4092  #1741  SHA-256-DIGEST(0xa249…0774)            تجزئة الملف
#1743 QUALIFIER  P813   #1741  POSIX-TIMESTAMP-SECONDS(1792996483)    وقت الاستلام
BODY
#1736 TRIPLE     P577   #1735  POSIX-TIMESTAMP-SECONDS(1792210885) normal                      وقت حفظ الإصدار
#1737 TRIPLE     P854   #1735  <https://www.wikidata.org/w/index.php?oldid=2557857485> normal  العنوان الدائم للإصدار
#1739 REFERENCE-NODE    #1740  <https://dumps.wikimedia.org/wikidatawiki/entities/20261019/wikidata-20261019-all.json.bz2>
…
```

- الإصدار وdump مصدران مختلفان فيوضع SOURCE اثنان. الإصدار مصدر المحتوى (ويمكن استلام المحتوى نفسه من جديد بالعنوان الدائم)، وdump هو الملف الذي استُلم منه ذلك الإصدار. وتجزئة الملف ووقت الاستلام من خصائص الاقتباس المتعلقة بملف dump فتُلحق بـ SOURCE الخاص بـ dump.

## تمثيل الأدلة الأخرى

لا يوضع في عائلة الدليل إلا SOURCE. وبقية الأدلة تُكتب بـ QUALIFIER.

| الدليل | كيف يُكتب | Property |
|---|---|---|
| النطاق داخل النص الأصلي | QUALIFIER على SOURCE. SOURCE واحد لكل نطاق | الصفحة P304 والفقرة P958 والاقتباس P1683. ونطاق الحروف مصطلح في GEUL (لم يتحدد) |
| وقت استلام المادة المصدرية | QUALIFIER على SOURCE | تاريخ الاطلاع P813 |
| تجزئة بايتات النص الأصلي (تثبيت الإصدار) | QUALIFIER على SOURCE | checksum P4092، والقيمة [SHA-256-DIGEST](/ar/grammar/value/binary/sha-256-digest/) وغيرها |
| الجهة المنتِجة (إنسان أو نموذج أو محرك قواعد) | QUALIFIER على SOURCE (الجهة التي أنتجت الاقتباس) أو على الهدف | مصطلح في GEUL (لم يتحدد) |
| الموثوقية | QUALIFIER على الهدف | مصطلح في GEUL (لم يتحدد)، والقيمة من 0 إلى 1 مثل Meta [CONFIDENCE](/ar/grammar/meta/verification/confidence/) |
| فترة سريان كل مادة | QUALIFIER على الهدف | البداية P580 والنهاية P582 |
| السجل القديم قبل النقل والتقسيم والدمج | QUALIFIER على الهدف، والقيمة هي Edge Id القديم (LOCAL) | P1365 (replaces) |
| الإصدار الذي دخل فيه أول مرة | لا يُخزَّن. يُحسب من سجل الإصدارات (git blame) | |

## أمثلة (غير معيارية)

Q42 P19 (مكان الميلاد) Q350، وTRIPLE الهدف `#178`. لهذه العبارة في dump ويكي بيانات في 2026-10-19 خمسة مراجع، نعرض منها ثلاثة. حُذف ③ مقال التلغراف (`#1358`~`#1367`) لأنه بشكل ②، و⑤ Store norske leksikon (Q746368) لأنه بشكل ①.

```
SOURCE     #1347  #178   Q5375741                     ① بريتانيكا: بلا وصف للمصدر، P248 واحدة فقط
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"

TRIPLE     #1350  P50    #1349  Q18145749  normal     ② مقال الغارديان #1349
TRIPLE     #1351  P407   #1349  Q1860      normal
TRIPLE     #1352  P577   #1349  GREGORIAN-DATE(2001-05-15)  normal
TRIPLE     #1353  P854   #1349  <http://www.theguardian.com/news/2001/may/15/guardianobituaries.books>  normal
TRIPLE     #1354  P1433  #1349  Q5614018   normal
TRIPLE     #1355  P1476  #1349  "Obituary: Douglas Adams"@en  normal
SOURCE     #1356  #178   #1349
QUALIFIER  #1357  P813   #1356  GREGORIAN-DATE(2013-12-07)

SOURCE     #1368  #178   #1158                        ④ GND: LOCAL #1158 الذي صُرِّح به سابقاً (P248 Q36578، وP407 Q188)
QUALIFIER  #1369  P227   #1368  "119033364"
QUALIFIER  #1370  P813   #1368  GREGORIAN-DATE(2022-10-09)
```

- ① لا وصف للمصدر وP248 واحدة فالمصدر هو ذلك العنصر. `#1347` هو TAG (1) + Edge Id (2) + Target (2) + Q5375741 (3) = 8 WORD، وTAG هو `13A0`.

```
13A0 0088 0543 0088 00B2 0120 0052 06FD
```

- مرجع بـ URL واحد فقط: `REFERENCE-NODE #1383 #1384 <http://www.eskimo.com/~rkj/weekly/aa051701a.htm>` و`SOURCE #1385 #180 #1384`.
- مرجع فيه "imported from" ويكيبيديا الإنجليزية فقط: `SOURCE #n #t ABSENT` و`QUALIFIER P143 #n Q328`. وOrigin هو `0x0000` أي 1 WORD.

## مسائل مفتوحة

- مصطلحات GEUL التي تمثل نطاق الحروف والجهة المنتِجة والموثوقية (مستند تعريف المصطلحات ومعرّفاتها).
- إذا لم يُحدد وصف المصدر المصدر (مرجع فيه لغة فقط وما شابه) فإن مشاركة الوصف نفسه في LOCAL واحد تعني الادعاء بأن مصادر مختلفة هي مصدر واحد.
- قائمة خصائص المصدر والاقتباس لمصادر خارج ويكي بيانات (القوانين والاقتباس من الويب).
- مصدر المصدر (سلسلة): هل يُلحق SOURCE مرة أخرى بـ LOCAL المصدر.

## صفحات ذات صلة

- [Edge](/ar/grammar/edge/)، [TRIPLE](/ar/grammar/edge/triple/)، [QUALIFIER](/ar/grammar/edge/qualifier/)، [REFERENCE-NODE](/ar/grammar/edge/reference-node/)، [علامة موضع](/ar/grammar/reference/slot-marker/)
- [المستند](/ar/grammar/document/) (HEAD وBODY)، [Meta — المصدر](/ar/grammar/meta/provenance/)
