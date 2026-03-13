---
title: "Fullend — Full-stack SSOT Orchestrator"
weight: 1
date: 2026-03-09T12:00:00+09:00
lastmod: 2026-03-13T12:00:00+09:00
tags: ["Fullend", "DSL", "SSOT", "cross-validation", "vibe-coding"]
summary: "CLI שמאמת את העקביות ההדדית של 10 מקורות SSOT ומייצר קוד. סוגר את הסדקים של vibe coding באמצעות מבנה."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Full-stack SSOT Orchestrator** — CLI שמאמת את העקביות של 10 מקורות SSOT בבת אחת ומייצר קוד.

<a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">מאגר GitHub</a>

## הסדקים של Vibe Coding

עם התפשטות vibe coding, דפוסים מתחילים להתגלות.

אומרים לבינה מלאכותית "בנה פונקציית הזמנה" והיא בונה. "הוסף ביטול" והיא מוסיפה. כשמוסיפים את הפיצ'ר החמישי, השני נשבר. שינו את סכמת API אבל לא תיקנו את הצד הקדמי. הוסיפו עמודה ל-DB אבל שכבת השירות לא יודעת על כך.

הסיבה פשוטה: הבינה המלאכותית לא יכולה לזכור את כל הקוד.

אז מה אנשים עושים: כשמגלים את השבר, אומרים לבינה המלאכותית "תתקן גם את זה". מתקנים, ומשהו אחר נשבר. "תתקן גם את זה." הלולאה חוזרת על עצמה. ככל שהפרויקט גדל, הלולאה מתארכת — עד שבשלב מסוים "להתחיל מחדש יהיה יותר מהר" הופך למסקנה הגיונית.

## למה קוד גדל?

בקוד מעורבבים שני דברים.

**החלטות**: מה להציג, איזה API לקרוא, באיזה סדר לעבד, מה לאחסן.
**חיווט**: הקוד שמממש את ההחלטות האלה בפריימוורק מסוים.

נניח שבונים מערכת הזמנות.

```
החלטה: "בביטול הזמנה — בדיקת הרשאות → שליפה → אימות מעבר מצב → חישוב החזר → שינוי מצב → תשובה"
```

שורת החלטה אחת זו מתפזרת על פני React hooks, Go handlers, שאילתות SQL, סכמות API ומשאבי Terraform. כל אחד עטוף בתחביר הפריימוורק שלו, עם טיפול בשגיאות והמרות טיפוסים.

מתוך 100,000 שורות קוד, 12,500 הן החלטות. 87,500 השורות הנותרות הן חיווט.

לסוכני בינה מלאכותית יש חלון הקשר סופי. כשמוסיפים את הפיצ'ר העשירי, הם לא זוכרים את תשעת הקודמים. לא ניתן לקרוא 100,000 שורות בבת אחת.

אם מפרידים רק את ההחלטות — 12,500 שורות. 55% מהקשר של 200K טוקנים. גודל שהבינה המלאכותית יכולה לקרוא בבת אחת.

## 10 מקורות SSOT

Fullend מפריד את כל ההחלטות בתוכנה ל-10 מפרטים הצהרתיים. כל מפרט הופך למקור אמת יחיד (SSOT) של תחום האחריות שלו.

| תחום אחריות | SSOT | הצהרה |
|---|---|---|
| הגדרת פרויקט | fullend.yaml | ערימת טכנולוגיה, middleware, נתיבי מודולים |
| מסך | [STML](/he/dsl/stml/) (HTML5 + data-*) | מה מוצג ומה קורה |
| חוזה API | OpenAPI 3.x | אילו בקשות מתקבלות ואילו תשובות נשלחות |
| זרימת שירות | [SSaC](/he/dsl/ssac/) (סיומת .ssac) | באיזה סדר מעבדים |
| מבנה נתונים | SQL DDL + sqlc | מה מאוחסן |
| פונקציות חיצוניות | Func Spec (Go) | ממשק ומימוש של לוגיקה מותאמת אישית |
| מעברי מצב | Mermaid stateDiagram | אילו מצבים המשאב עובר |
| מדיניות הרשאות | OPA Rego | מי יכול לעשות מה |
| תרחישים | Gherkin (.feature) | אימות זרימות עסקיות בין נקודות קצה |
| תשתית | Terraform HCL | היכן מריצים |

OpenAPI, SQL DDL ו-Terraform הם תקנים תעשייתיים. לשאר תחומי האחריות לא היה DSL מסוג SSOT מתאים. זרימות שירות התפזרו ב-Go handlers, החלטות מסך שקעו ב-React hooks, מעברי מצב הסתתרו בתנאי if-else, והרשאות היו מקודדות ב-middleware. לכן תוכננו STML, SSaC, Func Spec, שילוב stateDiagram, שילוב OPA ושילוב Gherkin.

```
specs/my-project/
├── fullend.yaml             → הגדרת פרויקט
├── api/openapi.yaml         → OpenAPI 3.x
├── db/*.sql                 → SQL DDL + שאילתות sqlc
├── service/**/*.ssac        → SSaC (סיומת .ssac)
├── model/*.go               → Go structs (// @dto)
├── func/<pkg>/*.go          → Func Spec
├── states/*.md              → Mermaid stateDiagram
├── policy/*.rego            → OPA Rego
├── scenario/*.feature       → Gherkin
├── frontend/*.html          → STML
└── terraform/*.tf           → HCL
```

`specs/` היא האמת. `artifacts/` ניתנת לשחזור בכל עת.

## אימות בודד כבר קיים

כלי אימות למספר שכבות כבר קיימים.

- sqlc בודק את העקביות של DDL ושאילתות.
- מאמתי OpenAPI בודקים את תקפות הסכמה.
- Terraform בודק תחביר ותלויות של HCL.

גם ל-STML וגם ל-SSaC נבנו מאמתים מובנים. SSaC בודק עקביות פנימית של זרימות שירות; STML בודק התאמה בין הצהרות UI ל-OpenAPI.

כל SSOT יכול לאמת את עצמו. הבעיה מתרחשת **ביניהם**.

הצד הקדמי מציג שדה עם `data-bind="memo"`, אבל בסכמת תשובת API אין `memo`. SSaC קורא ל-`@delete Reservation.SoftDelete(request.ReservationID)`, אבל בשאילתות sqlc אין מתודת `SoftDelete`. דיאגרמת מצבים מגדירה מעבר `PublishCourse`, אבל ב-SSaC אין פונקציה מתאימה. מדיניות OPA שואלת על בעלות משאב `course` דרך `courses.instructor_id`, אבל ב-DDL אין עמודה כזו.

כלים בודדים רואים רק את השכבה שלהם. הסדקים בין השכבות נשארים בלתי נראים.

## הסתרת המבנה

"עדיין צריך ללמוד 10 DSLs?"

נכון. אבל אין צורך לחשוף את המבנה למשתמש.

אם מכניסים מראש את ערימת הטכנולוגיה וכללי SSOT לתוך system prompt של הסוכן, המשתמש צריך רק לומר "בנה פונקציית הזמנה". הסוכן מוסיף בעצמו נקודות קצה ב-OpenAPI, יוצר טבלאות ב-DDL, מצהיר זרימות שירות ב-SSaC, מצייר דיאגרמת מצבים, כותב מדיניות OPA, מצייר מסכים ב-STML ומריץ `fullend validate` כדי לבדוק עקביות.

המשתמש רואה רק את התוצאה. מבנה הוא משהו שהסוכן צורך — לא משהו שהמשתמש צריך ללמוד.

חוויית vibe coding נשארת כמו שהיא. מה שמשתנה: מאחורי הקלעים שום דבר לא נשבר.

## התפקיד של Fullend

Fullend הוא מאמת צולב. הוא לא ממציא מחדש כלים בודדים. הוא קורא לכל כלי ובודק את הגבולות בין מקורות ה-SSOT.

```bash
fullend validate <specs-dir>
fullend validate --skip states,terraform <specs-dir>
```

מאמת כל אחד מ-10 מקורות SSOT בנפרד, ואז מבצע אימות צולב ביניהם. Func מאומת רק כשקיימת ספריית `func/`. ניתן להשתמש ב-`--skip` כדי לדלג על מקורות SSOT מסוימים.

```
✓ Config       my-project, go/gin, typescript/react
✓ OpenAPI      7 endpoints
✓ DDL          3 tables, 18 columns
✓ SSaC         7 service functions
✓ Model        3 files
✓ STML         4 pages, 6 bindings
✓ States       1 diagrams, 3 transitions
✓ Policy       1 files, 5 rules, 3 ownership mappings
✓ Scenario     4 features, 5 scenarios
✓ Func         3 funcs
✓ Terraform    2 files
✓ Cross        0 mismatches

All SSOT sources are consistent.
```

אם משהו נכשל:

```
✓ DDL          3 tables, 18 columns
✓ OpenAPI      7 endpoints
✗ SSaC         CancelReservation
               @delete Reservation.SoftDelete — method not found in sqlc queries
✗ States       course: PublishCourse transition → no SSaC function
✗ Cross        2 mismatches

FAILED: Fix errors before codegen.
```

כשהאימות עובר, נוצר קוד. האפשרות `--skip` פועלת כמו ב-validate.

```bash
fullend gen <specs-dir> <artifacts-dir>
fullend gen --skip terraform <specs-dir> <artifacts-dir>
```

sqlc מייצר מודלי DB, oapi-codegen מייצר טיפוסי API, SSaC מייצר gin handlers, STML מייצר רכיבי React, חבילת מכונת מצבים ו-OPA Authorizer נוצרים, מ-Gherkin נוצרים מבחני Hurl, ו-Fullend מייצר את קוד הדבק שמחבר ביניהם.

### gen-model

מייצר קובץ מודל Go (ממשק + טיפוסים + לקוח HTTP) ממסמך OpenAPI חיצוני. מקבל נתיב לקובץ מקומי או URL.

```bash
fullend gen-model <openapi-source> <output-dir>
fullend gen-model https://api.stripe.com/openapi.yaml ./external/
```

### chain

עוקב אחר כל צמתי SSOT המחוברים לפעולת API בודדת. operationId אחד נכנס, מפת file:line מלאה בין שכבות יוצאת.

```bash
fullend chain <operationId> <specs-dir>
```

```
── Feature Chain: AcceptProposal ──

  OpenAPI    api/openapi.yaml:296                          POST /proposals/{id}/accept
  SSaC       service/proposal/accept_proposal.ssac:19      @get @empty @auth @state @put @call @post @response
  DDL        db/gigs.sql:1                                 CREATE TABLE gigs
  DDL        db/proposals.sql:1                            CREATE TABLE proposals
  DDL        db/transactions.sql:1                         CREATE TABLE transactions
  Rego       policy/authz.rego:3                           resource: gig
  StateDiag  states/gig.md:7                               diagram: gig → AcceptProposal
  StateDiag  states/proposal.md:6                          diagram: proposal → AcceptProposal
  FuncSpec   func/billing/hold_escrow.go:8                 @func billing.HoldEscrow
  Gherkin    scenario/gig_lifecycle.feature:4              Scenario: Happy Path - Full Gig Lifecycle
```

### status

מציג סיכום של מקורות SSOT שזוהו והסטטיסטיקות שלהם.

```bash
fullend status <specs-dir>
```

```
SSOT Status:
  OpenAPI      api/openapi.yaml               7 endpoints
  DDL          db                             3 tables, 18 columns
  SSaC         service                        7 functions
  STML         frontend                       4 pages
  States       states                         1 diagrams, 3 transitions
  Policy       policy                         1 files, 5 rules
  Scenario     scenario                       4 features, 5 scenarios
  Func         func                           3 funcs
```

## פונקציות ומודלים מובנים

Fullend מגיע עם מימושי פונקציות נפוצים וממשקי מודלים. ניתן להפעיל אותם באמצעות `@call` ב-SSaC.

### פונקציות ברירת מחדל (pkg/)

| חבילה | פונקציה | תיאור |
|---|---|---|
| `auth` | `hashPassword` | גיבוב סיסמה עם bcrypt |
| `auth` | `verifyPassword` | אימות סיסמה עם bcrypt |
| `auth` | `issueToken` | יצירת access token של JWT (24 שעות) |
| `auth` | `verifyToken` | אימות JWT token + חילוץ claims |
| `auth` | `refreshToken` | יצירת refresh token (7 ימים) |
| `auth` | `generateResetToken` | טוקן hex אקראי לאיפוס סיסמה |
| `crypto` | `encrypt` | הצפנה סימטרית AES-256-GCM |
| `crypto` | `decrypt` | פענוח AES-256-GCM |
| `crypto` | `generateOTP` | סוד TOTP + URL להקצאת QR |
| `crypto` | `verifyOTP` | אימות קוד TOTP |
| `storage` | `uploadFile` | העלאת קובץ תואמת S3 |
| `storage` | `deleteFile` | מחיקת קובץ תואמת S3 |
| `storage` | `presignURL` | URL הורדה חתום מראש של S3 |
| `mail` | `sendEmail` | דוא"ל טקסט רגיל באמצעות SMTP |
| `mail` | `sendTemplateEmail` | דוא"ל HTML עם תבנית Go באמצעות SMTP |
| `text` | `generateSlug` | המרת Unicode ל-slug בטוח ל-URL |
| `text` | `sanitizeHTML` | סניטציית HTML למניעת XSS |
| `text` | `truncateText` | קיצור טקסט בטוח ל-Unicode |
| `image` | `ogImage` | יצירת תמונת OG (1200x630, PNG) |
| `image` | `thumbnail` | יצירת תמונה ממוזערת (200x200, PNG) |

פרויקטים יכולים לדרוס אותם על ידי מתן מימושים מותאמים ב-`specs/<project>/func/<pkg>/`.

### מודלים מובנים (pkg/)

ממשקי @model עם קידומת חבילה לקלט/פלט שאינו DDL. מוגדרים באמצעות `fullend.yaml`.

| חבילה | ממשק | Backends | שימוש ב-SSaC |
|---|---|---|---|
| `session` | `SessionModel` (Set/Get/Delete + TTL) | PostgreSQL, Memory | `session.Session.Get({key: ...})` |
| `cache` | `CacheModel` (Set/Get/Delete + TTL) | PostgreSQL, Memory | `cache.Cache.Set({key: ..., value: ..., ttl: ...})` |
| `file` | `FileModel` (Upload/Download/Delete) | S3, LocalFile | `file.File.Upload({key: ..., body: ...})` |
| `queue` | Singleton Pub/Sub (Publish/Subscribe) | PostgreSQL, Memory | `@publish "topic" {payload}` |

### Middleware (נוצר אוטומטית)

Fullend מייצר `internal/middleware/bearerauth.go` ייחודי לפרויקט מתוך הגדרת claims ב-`fullend.yaml`.

| Middleware | טריגר | תיאור |
|---|---|---|
| `BearerAuth(secret)` | `securitySchemes.bearerAuth` + `backend.auth.claims` | מחלץ JWT ← מציב `*model.CurrentUser` בהקשר gin |

קיבוץ routes נקבע על פי שדה `security` ב-OpenAPI. פעולות עם `security: [{bearerAuth: []}]` עוברות לקבוצת auth; פעולות בלעדיו עוברות לקבוצה ציבורית.

## כללי אימות צולב

הערך הייחודי של Fullend נמצא באימות הצולב. אחרי שכל כלי בודד מאמת את השכבה שלו, Fullend תופס אי-התאמות בין מקורות SSOT.

**fullend.yaml ↔ OpenAPI**
| יעד אימות | כלל |
|---|---|
| שם Middleware | האם הוא תואם למפתח securitySchemes? |

**OpenAPI ↔ DDL**
| יעד אימות | כלל |
|---|---|
| x-sort.allowed | האם העמודה קיימת בטבלה? |
| x-sort ↔ DDL index | האם לעמודה יש אינדקס? (WARNING) |
| x-filter.allowed | האם העמודה קיימת בטבלה? |
| x-include.allowed | האם מדובר בטבלה מחוברת בקשר FK? |

**SSaC ↔ DDL**
| יעד אימות | כלל |
|---|---|
| Model.Method | האם המתודה קיימת בשאילתות sqlc? |
| @result Type | האם היא תואמת לטיפוס שנגזר מטבלת DDL? |
| שדות ארגומנט | האם ניתן למפות לעמודות DDL? |

**SSaC ↔ OpenAPI**
| יעד אימות | כלל |
|---|---|
| שם פונקציה | האם הוא תואם ל-operationId? |
| ארגומנטי request | האם השדה קיים בסכמת הבקשה? |
| שדות @response | האם השדה קיים בסכמת התשובה? |

**States ↔ SSaC ↔ OpenAPI ↔ DDL**
| יעד אימות | כלל |
|---|---|
| אירוע מעבר | האם הוא תואם לשם פונקציה ב-SSaC? |
| אירוע מעבר | האם הוא תואם ל-operationId ב-OpenAPI? |
| SSaC @state | האם ה-stateDiagram המופנה קיים? |
| שדה @state | האם הוא קיים כעמודה ב-DDL? |

**Policy ↔ SSaC ↔ DDL ↔ States**
| יעד אימות | כלל |
|---|---|
| allow (action, resource) | האם הוא תואם ל-@auth ב-SSaC? |
| @ownership table.column | האם הוא קיים ב-DDL? |
| @ownership via join | האם ה-FK של טבלת הצירוף קיים ב-DDL? |
| אירוע מעבר מצב | האם קיים כלל Rego מתאים למעברים עם @auth? |

**Func ↔ SSaC**
| יעד אימות | כלל |
|---|---|
| הפניית @call | האם קיים מימוש Func מתאים? |
| מספר ארגומנטים | האם ארגומנטי @call תואמים למספר שדות Request? |
| טיפוסי ארגומנטים | האם הטיפוסים הפוזיציונליים תואמים דרך DDL/OpenAPI? |
| תוצאה/תשובה | האם result/response עקביים? |
| גוף הפונקציה | האם זהו stub של TODO? (WARNING) |

**Scenario ↔ OpenAPI ↔ States**
| יעד אימות | כלל |
|---|---|
| operationId | האם הוא קיים ב-OpenAPI? |
| HTTP method | האם הוא תואם לשיטה ב-OpenAPI? |
| שדות JSON | האם הם קיימים בסכמת הבקשה? |
| סדר שלבים | האם הוא עוקב אחר כללי מעבר מצב? |

**Queue (Pub/Sub)**
| יעד אימות | כלל |
|---|---|
| @publish topic | האם קיימת פונקציית @subscribe מתאימה? |
| שדות payload/message | האם הם עקביים? |
| הגדרת Queue | האם ב-fullend.yaml יש הגדרת queue? |

**STML ↔ SSaC** — שניהם מפנים לאותו operationId ב-OpenAPI. כשהאימות משני הצדדים עובר, ההתאמה בין ה-API שהצד הקדמי קורא לו לבין ה-API שהצד האחורי מעבד מובטחת אוטומטית.

## בדיקות בזמן ריצה

`fullend gen` מייצר מבחני [Hurl](https://hurl.dev) ממפרטי OpenAPI ותרחישי Gherkin.

```bash
# הפעילו את השרת, ואז:
hurl --test --variable host=http://localhost:8080 artifacts/my-project/tests/*.hurl
```

מבחנים שנוצרים:
- **smoke.hurl** — מבחני עשן לנקודות קצה של OpenAPI (נוצרים אוטומטית)
- **scenario-*.hurl** — מבחני תרחישים עסקיים (מקובצי .feature)
- **invariant-*.hurl** — מבחני אינווריאנטים בין נקודות קצה (מקובצי .feature)

## תכנון לסוכנים

Fullend תוכנן עבור סוכני בינה מלאכותית.

כדי שסוכן יכתוב specs, הוא צריך להכיר את 10 סוגי הרצפים של SSaC, את תכונות data-* של STML, את הרחבות x- של OpenAPI, את כללי stateDiagram, את דפוסי מדיניות OPA, את תחביר תרחישי Gherkin, את כללי Func Spec ואת כללי התאמת שמות. לשם כך מסופק מדריך של כ-830 שורות לבינה מלאכותית. צריך להכניס אותו פעם אחת ל-system prompt של הסוכן.

לולאת האימות אחרי כתיבת ה-specs פשוטה.

```
זרימת עבודה של סוכן:
1. עריכת specs/
2. fullend validate specs/my-project
3. אם יש שגיאות → תיקון ה-SSOT הרלוונטי → חזרה ל-2
4. 0 שגיאות → fullend gen specs/my-project artifacts/my-project
```

אין צורך להבין את כל המערכת. אם מתקנים רק את המקומות ש-validate מצביע עליהם, העקביות משוחזרת. מודלים חכמים מצליחים בניסיון הראשון, מודלים קטנים בשלושה ניסיונות. התוצאה זהה.

## גודל SSOT לפי היקף

| היקף | דוגמה | SSOT | קוד מימוש | ניצול הקשר |
|---|---|---|---|---|
| קטן | הזמנת מספרה | ~1,500 שורות | ~10K שורות | ~8% |
| בינוני | ברמת Jira/Notion | ~12,500 שורות | ~100K שורות | ~55% |
| גדול | ברמת Shopify | ~30,000 שורות | ~300K שורות | ~90% |

על בסיס הקשר של 200K טוקנים. עד לגודל SaaS בינוני, סוכן יכול לקרוא את כל התכנון בבת אחת.

## דפוסים מתוך חריגים

מה שלא ניתן לכסות עם 10 סוגי רצפים עובר ל-`@call`. מה שלא ניתן לכסות עם תכונות data-* עובר ל-`custom.ts`. אם escape hatches אלה עולים על 20% מהכלל, המשמעות של המבניות נשחקת.

אולם חריגים הופכים לנצפים ברגע שהם מבודדים. כשפרויקטים רבים יאמצו את Fullend, דפוסים חוזרים יתגלו ב-`@call` ו-`custom.ts`.

גם 10 סוגי הרצפים של SSaC לא תוכננו מראש. הם התכנסו ל-10 לאחר תצפית על מאות דוגמאות של קוד שירות. אותו עיקרון צפוי לחזור על עצמו ב-escape hatches. דפוסי `@call` שמופיעים לעיתים קרובות יהפכו לסוגי רצפים חדשים; דפוסי `custom.ts` שמופיעים לעיתים קרובות יהפכו לתכונות data-* חדשות.

החריגים לא נעלמים — מתוך החריגים צומח מבנה.

## הרחבת ערימת הטכנולוגיה

כרגע Fullend קבוע על Go(gin) + React + PostgreSQL + Terraform. זה מכוון. בשלב PoC, העדיפות היא לחדור ערימה אחת מקצה לקצה.

עם זאת, רבים מ-10 מקורות SSOT (OpenAPI, SQL DDL, Terraform, Mermaid, OPA Rego, Gherkin) כבר בלתי תלויים בשפה. 10 סוגי הרצפים של SSaC הם דפוסים שאינם תלויים בשפה — הם רק מבוטאים כהערות Go. STML מבוסס על תכונות HTML5 data-* ואינו תלוי בפריימוורק.

הרחבה היא שאלה של הוספת backends לייצור קוד. לוגיקת האימות וכללי האימות הצולב נשארים כפי שהם.

## הקשר ל-GEUL

10 מקורות SSOT מרכיבים את כלל ההחלטות של תוכנה. SSOT הוא נתונים מובנים. נתונים מובנים הם גרף. גרף ניתן לקידוד ב-GEUL.

`data-fetch="ListReservations"` של STML הוא יחס בין ישויות. `@get → @empty → @state → @call → @put → @response` של SSaC הוא רצף אירועים. מעברים ב-stateDiagram הם גרף מצבים. מדיניות OPA היא יחסי הרשאות. הגדרות נקודות הקצה של OpenAPI הן חוזים. כולם מבנים סמנטיים שניתן לבטא כקשתות triple, קשתות event6 וצמתי entity של GEUL.

הדרך שבה Fullend מבצע אימות צולב בין 10 מקורות SSOT — התאמה סמלית, בדיקת עקביות טיפוסים, שלמות ייחוס — פועלת לפי אותו עיקרון כמו אימות מכני בזרמי GEUL.

## רישיון

MIT — <a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">GitHub</a>
