# MovieFlix V2 — Online Edition

هذه النسخة تنقل المشروع من قاعدة محلية إلى بنية أقرب لتطبيق حقيقي:
- Supabase Auth لتسجيل دخول لوحة التحكم.
- PostgreSQL للمحتوى والحلقات والمفضلة.
- Supabase Storage للصور والفيديو.
- واجهة HTML/CSS/JS قابلة للتحويل إلى APK عبر WebView/HTML-to-APK.

## قبل التشغيل
1. أنشئ مشروعًا مجانيًا في Supabase.
2. افتح SQL Editor ونفّذ `supabase/schema.sql`.
3. أنشئ Storage Buckets باسم `posters` و`videos`.
4. انسخ `js/config.js` وضع فيه Project URL وanon/publishable key.
5. أنشئ حساب مدير من Authentication > Users.
6. افتح `admin.html` وسجّل الدخول.

## أمان
- لا تضع `service_role` key داخل HTML أو APK.
- النسخة الحالية تحتاج لاحقًا إلى سياسة RLS للمديرين قبل نشرها للعامة.
- إذا كانت الفيديوهات كبيرة، يفضّل استخدام تخزين مناسب وSigned URLs بدل جعل كل الفيديوهات Public.

## تشغيل APK
حوّل `index.html` إلى APK باستخدام أداة WebView/HTML-to-APK تدعم:
- JavaScript
- HTTPS/network access
- localStorage/cookies
- file input
- IndexedDB (اختياري)
وتأكد أن الأداة تسمح بفتح الروابط HTTPS.

## حقوق المحتوى
استخدم فقط المحتوى الذي تملك حقوق استخدامه وتوزيعه.
