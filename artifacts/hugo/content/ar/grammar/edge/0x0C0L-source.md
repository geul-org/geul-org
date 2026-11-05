---
title: "SOURCE (0x0C0L)"
weight: 192
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SOURCE هو Edge الدليل الذي يصل سجلاً واحداً (الهدف) أو المستند كله بالأصل الذي جاء منه."
author: "جونو بارك"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| البند | القيمة |
|---|---|
| الاسم | `SOURCE` (مستند المواصفة BIND `SOURCE`) |
| TAG ID | `0x0C0L` |
| Codec ID | `0x00000C00` |
| مستند المواصفة | `0x00000000/codecs/0x00000C00/` (هدف DECLARE `0C00`) |
| القسم | 6 `0110` (دليل Edge)، الإزاحة داخل القسم C = 0 |
| Kind | Edge · العائلة: الدليل |
| TAG WORD | `0000 1100 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| وصف الفهرس | يصل سجلاً واحداً أو المستند كله بأصله. Target (Edge Id في BODY، وفي HEAD تعني `0` المستند كله)، Origin (Reference، أو ABSENT أو UNKNOWN-VALUE). خصائص الأصل تُكتب بـ TRIPLE يكون الأصل فيه Subject، وخصائص الاقتباس (تاريخ الاطلاع، الموضع، تجزئة النص الأصلي) بـ QUALIFIER تُلحق بـ SOURCE. وSOURCE الخاص بالمستند كله وQUALIFIER التابع له يوضعان في HEAD |
| جانب Hugo | `edge/source.md` |

## الحقول (مستند المواصفة) {#필드-규격-문서}

ترتيب FIELD داخل المستند هو ترتيب حقول Payload ([مستند مواصفة Codec](../codec-spec.md)). لا يُصرَّح بـ Edge Id الخاص بـ Edge عبر FIELD.

| الترتيب | الحقل (BIND) | FIELD | العرض | الصيغة المقبولة (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `target` | #2 | سجل | `0050` LOCAL |  |
| 2 | `origin` | #3 | سجل | `000F` القسم 0 كاملاً (حرف بدل، Reference)، `020F` القسم 1 كاملاً (حرف بدل، Reference)، `040F` القسم 2 كاملاً (حرف بدل، Reference)، `0010` UNKNOWN-VALUE، `0000` ABSENT (حقل اختياري) |  |

SOURCE هو Edge الدليل الذي يصل سجلاً واحداً (الهدف) أو المستند كله بالأصل الذي جاء منه. Codec `0x0C0L`. وهو الرمز المباشر الوحيد في عائلة الدليل (`01`).

كل reference (مجموعة المصادر) واحد في ويكيداتا يقابله SOURCE واحد. فإذا كان لسجل واحد عدة مصادر فهناك عدة SOURCE.

## التخطيط {#레이아웃}

```
TAG WORD          0000 1100 0000 LLLL
[Length TAG ممتد]
Edge Id           سجل LOCAL Reference
Target            سجل LOCAL Reference (في BODY هو Edge Id الخاص بالـ Edge الذي يُلحق به الدليل، وفي HEAD هو 0 = المستند كله)
Origin            سجل Reference، أو علامة الموضع 0x0000 ABSENT·0x0010 UNKNOWN-VALUE
```

- يشير Origin إلى الأصل. فإن وُجد Reference مناسب للأصل فهو (WIKIDATA-QID، أو DOC-POINTER وEXTERNAL-ISSUER لمستند GEUL، وغيرها)، وإلا فهو عقدة LOCAL في هذا المستند.
- إذا لم يصف المصدر الأصل (مثل مصدر في ويكيداتا فيه "imported from" (P143) وتاريخ الاطلاع فقط) فـ Origin هو [ABSENT](../slot-marker.md) (غير مكتوب). فالكاتب لم يكتب الأصل فقط، ولا يقرر شيئاً عن الأصل. وبقية المصدر موجودة في QUALIFIER كما هي.
- لا يُستخدم [UNKNOWN-VALUE](../slot-marker.md) إلا حين يقرر الكاتب أن "الأصل موجود لكن لا يُعرف ما هو" (مثل السجلات التي يكتبها الإنسان). أما المحوّل الذي ينقل من مادة الأصل فلا يقرر ما لم يقله الأصل، فيستخدم ABSENT.
- Origin الذي هو ABSENT أو UNKNOWN-VALUE مستقل في كل ظهور. ولا يُقرأ أصلا SOURCE على أنهما واحد.

## طبقتان {#두-층}

المعلومات عن المصدر نوعان. لا تُخلط.

| الطبقة | ماذا | طريقة الكتابة | أمثلة |
|---|---|---|---|
| الأصل | خصائص الأصل نفسه. هي نفسها أياً كان من يقتبس | [TRIPLE](0x0AAL-triple.md) يكون الأصل فيه Subject (rank normal) | URL (P854)، العنوان (P1476)، المؤلف (P50 وP2093)، تاريخ النشر (P577)، مكان النشر (P1433)، الناشر (P123)، اللغة (P407) |
| الاقتباس | خصائص فعل اقتباس هذا السجل للأصل | [QUALIFIER](0x0ABL-qualifier.md) يكون Edge Id الخاص بـ SOURCE هو Target فيه | تاريخ الاطلاع (P813)، الموضع داخل الأصل (الصفحة P304، القسم P958، المعرّفات الخارجية P227 وP1417)، مكان الاستيراد (P143)، طريقة الاستدلال (P887)، تجزئة النص الأصلي (P4092) |

- **معنى SOURCE هو مجموع كل QUALIFIER التي تشير إلى Edge Id الخاص به.** مصدران اطُّلع فيهما على الأصل نفسه في يومين مختلفين: الأصل واحد وQUALIFIER مختلفة.
- TRIPLE الأصل إقرار عن الأصل. وأي خاصية يتعذر تحديد طبقتها توضع في جهة الاقتباس (QUALIFIER). الأسلم ألا يُقرَّر شيء عن الأصل.
- الأصل الواحد في المستند يُصرَّح به مرة واحدة بوصفه LOCAL واحداً، وتشير إليه عدة SOURCE معاً.
- الأصل الذي يوصف بـ URL واحد فقط يُعرَّف بـ [REFERENCE-NODE](0x0A0L-reference-node.md) (LOCAL ← URI). وهي الطريقة نفسها لصفحة مستند sitelink.

## التفسير والصلاحية {#해석과-유효성}

- كل من Target وOrigin سجل كامل واحد بالضبط. والمؤشر الذي قرأ Origin يجب أن يوافق نهاية Edge.
- Target هو LOCAL Reference. SOURCE في BODY يشير إلى Edge Id في BODY المستند نفسه. و`0` (المستند كله) لا يستخدمه إلا SOURCE في HEAD ([مصدر المستند كله](#문서-전체의-출처)). وإذا وُجد في BODY عنصر SOURCE هدفه `0` فهو invalid. أما سجلات المستندات الأخرى فيُلحق الدليل بها داخل ذلك المستند.
- Origin هو Reference. علامات الموضع المقبولة هي `0x0000` (ABSENT) و`0x0010` (UNKNOWN-VALUE) فقط. ولا يقبل NO-VALUE (`0x0020`) ولا Value.
- مستند مواصفة geul.org `0x00000000/codecs/0x00000C00` (الاسم `source`) يضع لـ Target قيمة [CODEC](0x0BEL-codec.md) LOCAL (`0050`)، ولـ Origin قيم CODEC `000F` و`020F` و`040F` (أي Reference) و`0000` (ABSENT، اختياري) و`0010` (UNKNOWN-VALUE).
- الترتيب بين عناصر SOURCE ذات الهدف نفسه لا معنى له. وترتيب العناصر داخل مصدر واحد لا معنى له أيضاً (ترتيب قيم الخاصية نفسها يبقى في ترتيب المستند).
- SOURCE لا يغيّر صحة الهدف أو خطأه. هو يكتب فقط من أين جاء الهدف. ونتيجة الحكم من اختصاص [TOULMIN](../toulmin/_index.md) `VERDICT`.

## مصدر المستند كله {#문서-전체의-출처}

أصل المستند كله (ملف التفريغ الأصلي، النسخة، ملف النص الأصلي) يُكتب بـ **SOURCE في HEAD هدفه `0`**. وQUALIFIER التي تشير إلى هذا SOURCE (تجزئة النص الأصلي P4092، وقت الاستلام P813، نطاق النص الأصلي، إلخ) توضع في HEAD أيضاً ([المستند](../document.md#head와-body)).

- هذان فقط ما يجوز وضعه من Edge في HEAD. وما سواهما من Edge يوضع في BODY.
- QUALIFIER في HEAD توضع بعد HEAD SOURCE الذي تشير إليه. ويفصل المفكك بين HEAD وBODY أثناء قراءته من البداية.
- وضع QUALIFIER تشير إلى HEAD SOURCE في BODY هو invalid. فـ SOURCE وQUALIFIER في BODY لا تشير إلى Edge في HEAD.
- **يستخدم HEAD وBODY فضاء أرقام واحداً لـ Edge Id.** هو فريد داخل المستند، ويُؤخذ من [NEXT-LOCAL-ID](../meta/0x1DDL-next-local-id.md) مثل سائر Edge، وعند إعادة الإنشاء بالمحتوى نفسه يرث الرقم نفسه. وحتى في نسخة سقط منها HEAD Edge لا يُعاد استخدام رقمه.
- إذا كان Origin هو LOCAL فتعريفه (REFERENCE-NODE، وTRIPLE الأصل) يوضع في BODY. فنطاق LOCAL هو المستند كله.
- HEAD Edge ليس Meta من فئة التحقق، لذا يدخل في [تجزئة المحتوى](../document.md#내용-해시). وفي diff يتغير مع HEAD دفعة واحدة (لا يُكتب في `DELTA-REMOVE`).
- لا يوجد Meta خاص بمصدر المستند كله. فنطاق النص الأصلي ووقت الحصول عليه إذا كُتبا بوصفهما Meta تعذّر تحديد أي أصل يخصان عند تعدد الأصول. أما QUALIFIER المُلحقة بـ SOURCE فتحدد ذلك بـ Target.

مثال: HEAD لمستند Q42 منقول من تفريغ ويكيداتا (أرقام Edge Id للتوضيح).

```
SPEC-VERSION  0x0001
DOC-ID        0x00000001/0x510000000000002A
TRANSFORMED-BY …
#1738 SOURCE     #0     #1735                                         نسخة الكيان (revision)
#1741 SOURCE     #0     #1740                                         ملف التفريغ
#1742 QUALIFIER  P4092  #1741  SHA-256-DIGEST(0xA249…0774)            تجزئة الملف
#1743 QUALIFIER  P813   #1741  POSIX-TIMESTAMP-SECONDS(1792996483)    وقت الاستلام
BODY
#1736 TRIPLE     P577   #1735  POSIX-TIMESTAMP-SECONDS(1792210885) normal                      وقت حفظ النسخة
#1737 TRIPLE     P854   #1735  <https://www.wikidata.org/w/index.php?oldid=2557857485> normal  العنوان الدائم للنسخة
#1739 REFERENCE-NODE    #1740  <https://dumps.wikimedia.org/wikidatawiki/entities/20261019/wikidata-20261019-all.json.bz2>
…
```

- النسخة (revision) والتفريغ أصلان مختلفان، لذا يوضع SOURCE لكل منهما. النسخة هي أصل المحتوى (يمكن استلام المحتوى نفسه مجدداً بالعنوان الدائم)، والتفريغ هو الملف الذي استُلمت منه تلك النسخة. وتجزئة الملف ووقت الاستلام من خصائص الاقتباس المتعلقة بملف التفريغ، فتُلحق بـ SOURCE التفريغ.

## تمثيل الأدلة الأخرى {#다른-근거의-표현}

في عائلة الدليل لا يوجد إلا SOURCE. أما الأدلة الأخرى فتُكتب بـ QUALIFIER.

| الدليل | طريقة الكتابة | Property |
|---|---|---|
| النطاق داخل النص الأصلي | QUALIFIER على SOURCE. SOURCE واحد لكل نطاق | الصفحة P304، القسم P958، النص المقتبس P1683. نطاق الحروف مصطلح GEUL (غير محدد بعد) |
| وقت استلام مادة الأصل | QUALIFIER على SOURCE | تاريخ الاطلاع P813 |
| تجزئة بايتات النص الأصلي (تثبيت النسخة) | QUALIFIER على SOURCE | المجموع الاختباري P4092، والقيمة [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md) وغيرها |
| الجهة المنشئة (إنسان، نموذج، محرك قواعد) | SOURCE (الجهة التي أنشأت الاقتباس) أو QUALIFIER على الهدف | مصطلح GEUL (غير محدد بعد) |
| درجة الثقة | QUALIFIER على الهدف | مصطلح GEUL (غير محدد بعد)، والقيمة من 0 إلى 1 مثل Meta [CONFIDENCE](../meta/0x1E8L-confidence.md) |
| فترة سريان كل مادة | QUALIFIER على الهدف | البداية P580، النهاية P582 |
| السجل القديم قبل النقل أو التقسيم أو الدمج | QUALIFIER على الهدف، والقيمة Edge Id القديم (LOCAL) | P1365 (replaces) |
| النسخة التي دخل فيها أول مرة | لا يُخزَّن. يُحسب من سجل النسخ (git blame) | |

## مثال (غير معياري) {#예시-비규범}

Q42 P19 (مكان الولادة) Q350، وTRIPLE الهدف `#178`. في تفريغ ويكيداتا بتاريخ 2026-10-19 لهذه العبارة خمسة مصادر، نعرض ثلاثة منها. ③ مقال التلغراف (`#1358` إلى `#1367`) على صيغة ②، و⑤ Store norske leksikon (Q746368) على صيغة ①، فحُذفا.

```
SOURCE     #1347  #178   Q5375741                     ① بريتانيكا: بلا وصف للأصل، P248 فقط
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"

TRIPLE     #1350  P50    #1349  Q18145749  normal     ② مقال الغارديان #1349
TRIPLE     #1351  P407   #1349  Q1860      normal
TRIPLE     #1352  P577   #1349  GREGORIAN-DATE(2001-05-15)  normal
TRIPLE     #1353  P854   #1349  <http://www.theguardian.com/news/2001/may/15/guardianobituaries.books>  normal
TRIPLE     #1354  P1433  #1349  Q5614018   normal
TRIPLE     #1355  P1476  #1349  "Obituary: Douglas Adams"@en  normal
SOURCE     #1356  #178   #1349
QUALIFIER  #1357  P813   #1356  GREGORIAN-DATE(2013-12-07)

SOURCE     #1368  #178   #1158                        ④ GND: LOCAL #1158 المصرَّح به سابقاً (P248 Q36578, P407 Q188)
QUALIFIER  #1369  P227   #1368  "119033364"
QUALIFIER  #1370  P813   #1368  GREGORIAN-DATE(2022-10-09)
```

- ① لا وصف للأصل وفيه P248 واحدة، فالأصل هو ذلك العنصر. `#1347` هو TAG 1 + Edge Id 2 + Target 2 + Q5375741 3 = 8 WORD، وTAG `0C07`.

```
0C07 0051 0543 0051 00B2 0142 0052 06FD
```

- مصدر بـ URL واحد فقط: `REFERENCE-NODE #1383 #1384 <http://www.eskimo.com/~rkj/weekly/aa051701a.htm>`، `SOURCE #1385 #180 #1384`.
- مصدر فيه "imported from" ويكيبيديا الإنجليزية فقط: `SOURCE #n #t ABSENT`، `QUALIFIER P143 #n Q328`. وOrigin `0x0000` هو WORD واحد.

## مسائل مفتوحة {#열린-문제}

- مصطلحات GEUL التي تعبّر عن نطاق الحروف والجهة المنشئة ودرجة الثقة (مستند تعريف المصطلح وID).
- حين لا يحدد وصف الأصل هوية الأصل (مثل مصدر فيه اللغة فقط)، فإن مشاركة الوصف نفسه عبر LOCAL واحد تعني الإقرار بتطابق أصول مختلفة.
- قائمة خصائص الأصل والاقتباس للمصادر من خارج ويكيداتا (القوانين، الاقتباسات من الويب).
- مصدر المصدر (السلسلة): هل يُلحق SOURCE مرة أخرى بـ LOCAL الأصل.

## صفحات ذات صلة {#관련-페이지}

- [Edge](_index.md)، [TRIPLE](0x0AAL-triple.md)، [QUALIFIER](0x0ABL-qualifier.md)، [REFERENCE-NODE](0x0A0L-reference-node.md)، [علامة الموضع](../slot-marker.md)
- [المستند](../document.md) (HEAD وBODY)، [Meta — المصدر](../meta/_index.md#출처)

## نص مستند المواصفة {#규격-문서-원문}

هذا مستند المواصفة `0x00000000/codecs/0x00000C00/latest.geul` كما يُقرأ بـ `geul show` (الأرقام السداسية عشرية بحروف كبيرة).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000C0000000000
BODY
#1 DECLARE 0x0C00
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "SOURCE"
#5 BIND #2 "target"
#6 BIND #3 "origin"
#7 CODEC #2 0x0050
#8 CODEC #3 0x000F
#11 CODEC #3 0x020F
#12 CODEC #3 0x040F
#9 CODEC #3 0x0010
#10 CODEC #3 0x0000
```
