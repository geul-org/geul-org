---
title: "Meta — מוצא"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "מחלקת המוצא של Meta (שלושה ביטים עליונים `010`, `0x20`~`0x2F`) רושמת מי יצר ותיעד את המסמך ומתי. חומר המקור נכתב כ-Edge הראיה SOURCE."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

מחלקת המוצא של Meta (שלושה ביטים עליונים `010`, Codec `0x20`~`0x2F`) רושמת מי יצר ותיעד את המסמך ומתי.

- הכותב והמתעד וזמניהם עוקבים אחרי מודל ה-author וה-committer של git (`AUTHOR`·`CREATED-AT`, `RECORDED-BY`·`RECORDED-AT`).
- מחיקת המוצא אינה משנה את תוכן התיאור. רק חומר הגלם לשיקול אמון נעלם.
- חומר המקור אינו במחלקה הזו. המקור של המסמך כולו נכתב ב-HEAD, והמקור של רשומה בודדת ב-BODY, כ-Edge הראיה [SOURCE](/he/grammar/edge/source/). הטווח המתאים בטקסט המקורי, זמן ההשגה וה-hash של הטקסט המקורי הם QUALIFIER שמצורף ל-SOURCE הזה (עמוד P304, סעיף P958, תאריך גישה P813, checksum P4092).
- אם מאפיינים שמצורפים למקור (טווח בטקסט המקורי, זמן השגה) מוצבים ב-Meta, כשיש כמה מקורות אי אפשר לדעת של איזה מקור הם. לכן הם נכתבים כ-QUALIFIER שה-Target שלו הוא SOURCE. Codec `0x26`~`0x2F` שמורים.
