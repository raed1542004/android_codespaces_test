# Hello Android — GitHub Codespaces v3

مرحبًا بك! هذه الباكج جاهزة لاستخدام Android Studio داخل GitHub Codespaces،
مصممة لطالب تقني في غزة يدرس مساق Android Studio بـ Java.

## ✨ ما الجديد في v3؟

- **أسرع 5x**: استخدام Prebuilds + سكربت idempotent
- **أكثر استقرارًا**: retries + timeouts + lock file (لا يعلّق)
- **محفوظ**: codespace واحد، توقف/إعادة تشغيل بدون فقدان
- **شامل**: كل مواضيع المساق جاهزة (Fragments, Material, Services, Firebase...)
- **Hello World جاهز**: يعمل فورًا بعد البناء

---

## 📁 محتويات الباكج

```
android-codespaces-v3/
├── .devcontainer/
│   ├── devcontainer.json    ← إعدادات Codespace (Java 17 + Desktop-lite + SDK)
│   └── install.sh           ← سكربت تثبيت idempotent مع retries
├── .github/workflows/
│   └── codespaces-prebuild.yml  ← Prebuild workflow (تسريع الإنشاء)
├── testproject/             ← مشروع Hello World جاهز
│   ├── build.gradle
│   ├── settings.gradle
│   ├── gradle.properties
│   ├── gradle/wrapper/gradle-wrapper.properties
│   └── app/
│       ├── build.gradle     ← كل dependencies لمواضيع المساق
│       └── src/main/
│           ├── AndroidManifest.xml  (أذونات: Internet, Notifications)
│           ├── java/com/example/helloandroid/MainActivity.java
│           └── res/
│               ├── values/  (strings, colors, themes - Material Design 3)
│               ├── values-night/  (Dark mode)
│               └── layout/activity_main.xml
└── README.md  (هذا الملف)
```

---

## 🚀 الإعداد الأول (مرة واحدة فقط)

### 1. ارفع الباكج إلى GitHub

1. فُك ضغط الـ ZIP على جهازك
2. أنشئ مستودعًا جديدًا على [github.com/new](https://github.com/new)
   - اسم مقترح: `android-course`
   - اختر **Private** (لا تشارك أكوادك)
3. ارفع كل محتويات مجلد `android-codespaces-v3` إلى المستودع
   - اسحب الملفات وأفلِتها في صفحة المستودع، أو
   - استخدم git:
     ```bash
     git clone https://github.com/USERNAME/android-course.git
     # انسخ الملفات إلى المجلد
     git add .
     git commit -m "Initial setup: Android Studio codespace"
     git push
     ```

### 2. فعّل Prebuild (مهم للتسريع)

1. ادخل: GitHub → المستودع → **Settings** → **Codespaces**
2. في قسم **Prebuild configuration**:
   - اختر فرع: `main`
   - Machine type: `4-core · 16 GB RAM`
   - تفعيل: ✅ Automatically start codespace prebuilds
   - تفعيل: ✅ Automatically delete codespaces created from prebuilds
3. اضغط **Save**

> من الآن، أي push لـ main سيُبنى Prebuild تلقائيًا.
> عند إنشاء codespace جديد، سيبدأ من Prebuild جاهز (1-2 دقيقة فقط).

### 3. اضبط إعدادات Codespace الافتراضية

1. ادخل: https://github.com/settings/codespaces
2. في **Default idle timeout**:
   - اختر: **60 minutes** (افتراضي) أو **240 minutes** (أقصى)
   - هذا يحدد متى يتوقف الـ codespace تلقائيًا عند الخمول
3. في **Default retention period**:
   - اختر: **30 days** (كافٍ للاستخدام خلال المساق)

---

## 🎬 تشغيل Codespace (بعد الإعداد)

### الطريقة 1: من GitHub.com

1. ادخل إلى مستودعك على GitHub
2. اضغط زر **Code** الأخضر
3. اختر تبويب **Codespaces**
4. اضغط **+** لإنشاء codespace جديد (لو لا يوجد)
   - أو اضغط على codespace موجود لإعادة تشغيله

### الطريقة 2: من VS Code

1. افتح VS Code
2. `Ctrl+Shift+P` → اكتب: **Codespaces: Create New Codespace**
3. اختر مستودعك وفرع main

### المدة المتوقعة للإنشاء:

- **أول مرة** (بدون prebuild): 5-10 دقائق
- **بعد prebuild جاهز**: 1-3 دقائق فقط ✅

---

## 🖥️ الوصول إلى Android Studio

عندما يبدأ الـ codespace:

### 1. افتح noVNC (سطح المكتب)

1. في VS Code، اذهب لتبويب **Ports** (أسفل الشاشة)
2. ابحث عن المنفذ **6080**
3. انقر على أيقونة 🌐 (Open in Browser) بجانبه
4. ستفتح صفحة noVNC في المتصفح
5. أدخل كلمة المرور: **`android`**
6. اضغط **Connect**

### 2. شغّل Android Studio

في سطح مكتب Linux الذي ظهر:

1. افتح Terminal (اضغط Ctrl+Alt+T أو من قائمة التطبيقات)
2. اكتب الأمر التالي واضغط Enter:
   ```bash
   android-studio &
   ```
3. ستفتح واجهة Android Studio الكاملة!

### 3. افتح مشروع الاختبار

من داخل Android Studio:

1. **File → Open**
2. اختر المسار: `/workspaces/android-course/testproject`
   - (أو `/workspaces/android-codespaces-v3/testproject` حسب اسم مستودعك)
3. انتظر Gradle Sync (1-2 دقيقة)
4. اضغط **Run** (السهم الأخضر) أو **Build → Build APK(s)**

---

## 📱 اختبار التطبيق على هاتفك

> المحاكي لا يعمل في Codespaces (لا يوجد KVM).

### بناء APK:

```bash
cd /workspaces/android-course/testproject
./gradlew assembleDebug
```

### تنزيل APK:

1. في VS Code، اذهب إلى المسار:
   `testproject/app/build/outputs/apk/debug/`
2. انقر بزر يمين على `app-debug.apk`
3. اختر **Download...**
4. انقل الملف إلى هاتفك الأندرويد
5. فعّل تثبيت التطبيقات من مصادر غير معروفة
6. افتح ملف APK وثبّته

---

## 🔄 إدارة Codespace (Start / Stop / Save)

### كيف يعمل الحفظ التلقائي؟

- الـ codespace **محفوظ دائمًا** — لا يحتاج "حفظ"
- عندما تتوقف عن العمل 60 دقيقة (أو حسب إعداداتك)، يتوقف تلقائيًا
- عند إعادة التشغيل، كل شيء يبقى كما هو (الملفات، الإعدادات، Android Studio)

### لإيقاف يدوي:

1. من GitHub: https://github.com/codespaces
2. اضغط زر `...` بجانب الـ codespace
3. اختر **Stop codespace**

### لإعادة تشغيل:

1. من نفس الصفحة
2. اضغط على اسم الـ codespace
3. سيبدأ خلال 30-60 ثانية (كل شيء محفوظ)

### حذف (لا تفعل إلا عند الانتهاء):

- اضغط `...` → **Delete**
- سيُحذف كل شيء — استخدم فقط عند الانتهاء من المساق

---

## 💡 نصائح لتوفير الرصيد

### 1. أوقف الـ codespace عند الانتهاء

لا تتركه يعمل إذا لن تعمل به لساعات. توقف تلقائي بعد 60 دقيقة، لكن أوقف يدويًا إن أمكن.

### 2. استخدم Prebuilds

عندما تعدل `devcontainer.json` أو `install.sh`، اعمل commit & push.
سيُبنى prebuild جديد تلقائيًا، فيصبح إنشاء codespace أسرع بكثير.

### 3. احذف codespaces القديمة

من https://github.com/codespaces — احذف أي codespace لم تعد تحتاجه.
الـ codespaces المحذوفة لا تستهلك رصيدًا.

### 4. راقب استهلاكك

- ادخل: https://github.com/settings/billing/summary
- ابحث عن: **Codespaces** لرؤية الاستهلاك الشهري

---

## 🆘 حل المشاكل الشائعة

### المشكلة: "Setting up your codespace" يعلّق

**الحل:**
1. احذف الـ codespace من https://github.com/codespaces
2. تأكد أن `install.sh` تم رفعه بشكل صحيح وأنه قابل للتنفيذ
3. أنشئ codespace جديد
4. لو استمرت المشكلة، راجع logs:
   - في VS Code: View → Output → Codespaces

### المشكلة: Android Studio لا يفتح

**الحل:**
1. تحقق أن `install.sh` اكتمل (ابحث عن ملف `/workspaces/.android-setup-complete`)
2. لو غير موجود، شغّل يدويًا:
   ```bash
   bash .devcontainer/install.sh
   ```
3. لو فشل، حاول تثبيت Android Studio يدويًا:
   ```bash
   curl -fL -o /tmp/studio.tar.gz "https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2024.1.1.13/android-studio-2024.1.1.13-linux.tar.gz"
   sudo tar -xzf /tmp/studio.tar.gz -C /opt
   sudo ln -sf /opt/android-studio/bin/studio.sh /usr/local/bin/android-studio
   ```

### المشكلة: Gradle Sync يفشل

**الحل:**
1. تأكد من توليد Gradle wrapper:
   ```bash
   cd testproject
   gradle wrapper --gradle-version 8.7
   ```
2. حدث الـ wrapper:
   ```bash
   ./gradlew --version
   ```

### المشكلة: لا يظهر المنفذ 6080

**الحل:**
1. في VS Code، اذهب لتبويب **Ports**
2. اضغط **Forward a Port**
3. أدخل: `6080`
4. اضغط Enter

### المشكلة: noVNC يطلب كلمة مرور

**كلمة المرور:** `android`

---

## 📚 دعم مواضيع المساق

كل dependencies جاهزة في `app/build.gradle`:

| الموضوع | الـ Dependency | الحالة |
|---|---|---|
| 1.1, 1.2 Fragments | `androidx.fragment:fragment` | ✅ جاهز |
| 2.1 Menus | `androidx.appcompat` + `material` | ✅ جاهز |
| 2.2 Navigation | `androidx.navigation:navigation-*` | ✅ جاهز |
| 3.1 Styles/Themes | `themes.xml` | ✅ جاهز |
| 3.2 Material Design | `com.google.android.material` | ✅ جاهز |
| 3.3 Adaptive Layouts | `res/values-sw600dp/` | أنشئ عند الحاجة |
| 4.1 AsyncTask | (مدمج في AndroidX) | ✅ جاهز |
| 4.2 Internet | `INTERNET` permission | ✅ جاهز |
| 4.3 Broadcasts | `localbroadcastmanager` | ✅ جاهز |
| 4.4 Services | (Android framework) | ✅ جاهز |
| 5.1 Notifications | `POST_NOTIFICATIONS` | ✅ جاهز |
| 6.1 Firebase | (معطل - فعّل من build.gradle) | ⚠️ تفعيل يدوي |

### تفعيل Firebase:

1. اذهب إلى https://console.firebase.google.com
2. أنشئ مشروعًا جديدًا
3. أضف تطبيق Android (com.example.helloandroid)
4. نزّل `google-services.json` وضعه في `app/`
5. في `app/build.gradle`، أزل التعليقات (//) من أسطر Firebase
6. في `build.gradle` (المستوى الأعلى)، أضف:
   ```groovy
   plugins {
       id 'com.android.application' version '8.5.2' apply false
       id 'com.google.gms.google-services' version '4.4.0' apply false
   }
   ```
7. في `app/build.gradle`، أضف أعلى الملف:
   ```groovy
   plugins {
       id 'com.android.application'
       id 'com.google.gms.google-services'
   }
   ```

---

## 📞 تحتاج مساعدة؟

لو واجهت أي مشكلة، انسخ رسالة الخطأ كاملة واطلب المساعدة.
