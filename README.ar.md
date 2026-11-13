<div dir="rtl">

# المشروع الختامي: أمّن تطبيق ويب للتدريب، وراقبه


> **ملخص درسي قصير عن قصد.** الدرس في التطبيق بيعرض خطوات ضغط مختصرة. الـ README ده بيحفظ الأوامر الكاملة وإصلاح الأخطاء والخلفية لكل مرحلة — افتح قسم **المرحلة N** لما تحتاج تفاصيل.

دفاع فقط على جهازك: شغّل OWASP Juice Shop وراه nginx على localhost، افحصه بفحص ZAP الأساسي وراجع إعداداته بـ Semgrep، زوّد خمسة دفاعات في الوسيط، اكتشف هجوم دخول في السجلات، واكتب دليل استجابة للحوادث فيه إمتى تبلّغ EG-CERT، واعمل ملصق عربي لأولياء الأمور.

[English](README.md)

## هتقدر تعمل إيه

- تشغّل أدوات حقيقية مجانية من اللابتوب أو Codespaces
- تخلّص خمس مراحل، كل مرحلة ليها فحص تقدر تتأكد منه بنفسك
- تطلع بقطعة بورتفوليو: تقرير أو عرض أو أداة بإصدار v1.0
- **درسي مش بيشغّل كودك أبدًا** — بيقرا الرابط وملف الفحص وبمراجعة استشارية

## ثبّت مرة واحدة

### ويندوز

1. ثبّت Docker Desktop لـ Windows من https://www.docker.com/products/docker-desktop مجانًا للاستخدام الشخصي والتعليمي. شغّل WSL 2 لما يطلب منك.
2. ثبّت Python 3.12 وGit: في PowerShell اكتب `winget install Python.Python.3.12`، وبعدين `winget install Git.Git`. وثبّت VS Code من https://code.visualstudio.com مجانًا.
3. على GitHub افتح https://github.com/darsi-org/cyber-capstone واضغط **Use this template** عشان تعمل نسختك. وبعدين اعمل Clone لنسختك أنت، مش نسخة darsi-org: `git clone https://github.com/<your-username>/cyber-capstone.git`
4. افتح PowerShell جديد، وادخل الفولدر بـ `cd cyber-capstone`، وشغّل السطور دي واحد واحد:

   ```powershell
   docker compose up -d
   python -m venv .venv
   .venv\Scripts\Activate.ps1
   pip install -r requirements.txt
   python check.py
   ```

   لو PowerShell قال إن تشغيل السكربتات متقفل على الجهاز ده، مش محتاج تغيّر أي إعداد: استخدم Command Prompt وشغّل `.venv\Scripts\activate.bat` بداله، أو من غير تفعيل ابدأ كل أمر بـ `.venv\Scripts\python` (مثلًا `.venv\Scripts\python -m pip install -r requirements.txt`، وبعدين `.venv\Scripts\python check.py`).

كل حاجة مربوطة بـ localhost على الجهاز ده بس.

### ماك

1. ثبّت Docker Desktop لـ Mac من https://www.docker.com/products/docker-desktop
2. ثبّت Homebrew من https://brew.sh لو مش متثبت، وبعدين `brew install python@3.12 git`، وثبّت VS Code من https://code.visualstudio.com
3. على GitHub افتح https://github.com/darsi-org/cyber-capstone واضغط **Use this template**، وبعدين اعمل Clone لنسختك: `git clone https://github.com/<your-username>/cyber-capstone.git`
4. في Terminal ادخل الفولدر بـ `cd cyber-capstone` وشغّل:

   ```bash
   docker compose up -d
   python3.12 -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
   python check.py
   ```

كل حاجة مربوطة بـ localhost بس.

### Codespaces

افتح نسختك في GitHub Codespaces: **Code** → **Codespaces** → **Create codespace**. Docker وPython وGit موجودين أصلًا، وlocalhost يعني الـ codespace بتاعك مش جهاز حد تاني. Colab مش بيقدر يشغّل Docker، فاستخدم Codespaces للمشروع ده. في الـ terminal بتاعه شغّل:

```bash
docker compose up -d
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python check.py
```

متصفح الموبايل يكفي تقرا النتائج.

## البداية

اضغط **Use this template** على https://github.com/darsi-org/cyber-capstone، Clone نسختك، وبعدين اتبع المرحلة ١.

## المراحل

### m1: مختبرك، على localhost فقط (3 ساعات)

#### ليه ده مهم
Juice Shop مش آمن عمدًا. على الإنترنت المفتوح بيبقى مشكلة حد تاني — ومشكلتك قانونيًا. localhost بس.

#### الأدوات للمرحلة دي
- **Docker Desktop** — بيشغّل Juice Shop وnginx. هتجيبه من: https://www.docker.com/products/docker-desktop — free for personal/education
- **OWASP Juice Shop** — متجر تدريب مش آمن عمدًا. هتجيبه من: image pulled by docker compose

#### اعمل كده
1. جهّز نسختك زي **ثبّت مرة واحدة** (نسختك أنت، مش نسخة darsi-org)، عشان يكون `docker compose up -d` شغّل المختبر.
2. اتأكد: docker compose ps وافتح http://localhost:8080. اتأكد إن المنافذ في docker-compose.yml هي 127.0.0.1:…
3. اكتب SCOPE.md: مختبرك على localhost بس؛ مفيش مدرسة أو موقع عام. شغّل python check.py --milestone m1.

#### هتبقى خلصت لما
- المنافذ مربوطة بـ 127.0.0.1
- SCOPE.md بيذكر localhost
- m1 ناجحة

#### لو حاجة وقفت
- **Docker Desktop مش بيشتغل على Windows** → شغّل WSL 2 والـ virtualisation في BIOS؛ عيد التشغيل
- **المنفذ مستخدم** → وقّف الحاوية التانية أو غيّر منفذ المضيف، برضه على 127.0.0.1
- **0.0.0.0 في compose بالغلط** → رجّع كل سطر ports لـ 127.0.0.1:HOST:CONTAINER

#### إيه اللي لازم تفهمه
تقدر تشغّل هدف تدريب مش آمن يوصل له جهازك بس، بنطاق مكتوب.

**المطلوب تسليمه:** docker-compose.yml بمنافذ localhost، وSCOPE.md، وdarsi-check.json بيجتاز m1.

### m2: فحوص سلبية: ZAP baseline وSemgrep (3 ساعات)

#### ليه ده مهم
ابدأ بالبص من غير هجوم. وضع الأساس بيقرا الردود؛ مش بيكسر.

#### الأدوات للمرحلة دي
- **OWASP ZAP** — ماسح أساس سلبي. هتجيبه من: صورة Docker اللي scripts/zap-baseline.* بيشغّلها
- **Semgrep** — قواعد ثابتة على إعداد nginx والسكربتات. هتجيبه من: صورة Docker اسمها semgrep/semgrep (وActions بيشغّله من ci.yml)

#### اعمل كده
1. شغّل `powershell -ExecutionPolicy Bypass -File scripts\zap-baseline.ps1 before` (ويندوز؛ مش بيغيّر أي إعداد) أو `bash scripts/zap-baseline.sh before` (ماك وCodespaces).
2. شغّل Semgrep على nginx/ وscripts/ (نفس السطر بيشتغل في PowerShell وفي terminal الماك أو Codespaces): `docker run --rm -v "${PWD}:/src" semgrep/semgrep semgrep scan --config auto nginx scripts`. اعمل FINDINGS.md: التنبيه، والخطورة، والمكان، ومعناه لموقع مدرسة حقيقي.
3. شغّل python check.py --milestone m2.

#### هتبقى خلصت لما
- reports/before/scan-meta.json هو zap على localhost
- FINDINGS.md موجود
- m2 ناجحة

#### لو حاجة وقفت
- **السكربت رفض الهدف** → المسموح http://localhost:8080 أو 127.0.0.1 بس
- **حاوية ZAP مش واصلة للتطبيق على Windows أو Mac** → السكربتات بتحوّل localhost لـ host.docker.internal مع Docker Desktop؛ اتأكد إن `docker compose ps` بيبيّن الـ proxy شغّال
- **ZAP مكتبش تقرير** → المختبر مش شغّال: `docker compose up -d`، وبعدين افحص تاني
- **تنبيهات Low كتير** → رتّب High/Medium الأول؛ Low يستنى

#### إيه اللي لازم تفهمه
تقدر تشغّل فحص ويب سلبي على مختبرك بس وتشرح النتائج بكلام بسيط.

**المطلوب تسليمه:** reports/before/، وFINDINGS.md، وdarsi-check.json بيجتاز m2.

### m3: خمسة إصلاحات قدام التطبيق (4 ساعات)

#### ليه ده مهم
مش هتقدر تغيّر كود Juice Shop، زي مدارس كتير مش بتقدر تغيّر برنامج قديم. الوسيط طبقة دفاع حقيقية.

#### الأدوات للمرحلة دي
- **nginx** — بيزوّد ترويسات وحدود معدل وحجم. هتجيبه من: إعداده في nginx/default.conf

#### اعمل كده
1. في nginx/default.conf زوّد: ترويسات أمان، وأعلام كوكيز آمنة، وحد معدل على /rest/user/login، وserver_tokens off، وحد حجم الطلب.
2. عيد التشغيل: docker compose restart proxy. افحص تاني في reports/after/ بنفس السكربت، بس اكتب `after` مكان `before`.
3. قارن تنبيهات High/Medium قبل وبعد. شغّل python check.py --milestone m3.

#### هتبقى خلصت لما
- nginx فيه الخمسة دفاعات
- فحص after على localhost
- m3 ناجحة

#### لو حاجة وقفت
- **اختبار الإعداد فشل** → `docker compose run --rm proxy nginx -t` واقرا سطر الغلط (run مش exec: الوسيط اللي إعداده بايظ بيقف، فمفيش حاجة تعمل فيها exec)
- **التطبيق باظ بعد الترويسات** → هوّن CSP بحذر؛ ابدأ بـ default-src 'self'
- **عدد التنبيهات مانزلش** → اتأكد إنك فحصت منفذ الوسيط ٨٠٨٠ مش ٣٠٠٠ مباشرة

#### إيه اللي لازم تفهمه
تقدر تحصّن برنامج قديم من القدّام وتثبّت بكده بنفس الفحص.

**المطلوب تسليمه:** إعداد nginx، وreports/after/، وجدول قبل/بعد، وdarsi-check.json بيجتاز m3.

### m4: اكتشف هجوم دخول في السجلات (4 ساعات)

#### ليه ده مهم
المدافعون بيراقبوا كمان بيمنعوا. قاعدة بتزعق على كل غلطة كتابة هتتجاهل.

#### الأدوات للمرحلة دي
- **scripts/simulate-logins.py** — ٤٠ دخول فاشل على localhost بس. هتجيبه من: موجود في قالب البداية
- **detect.py** — بينبّه لما عنوان يفشل أكتر من ١٠ مرات في دقيقة. هتجيبه من: إنت بتكتبه

#### اعمل كده
1. شغّل: python scripts/simulate-logins.py  (بيرفض غير localhost).
2. اكتب detect.py يقرا سجلات nginx وينبّه على >١٠ إخفاقات/دقيقة من عنوان واحد. احفظ التنبيه تحت alerts/.
3. اختياري لو عندك ≥٨ جيجا رام: ابعت السجلات لـ Wazuh جهاز واحد. ورّي مفيش تنبيه على حركة عادية. شغّل python check.py --milestone m4.

#### هتبقى خلصت لما
- detect.py موجود
- alerts/ فيه ملف
- m4 ناجحة

#### لو حاجة وقفت
- **simulate-logins رفض** → مرّر http://localhost:8080 بس
- **مفيش سجل وصول** → اربط ./logs وضبط access_log في nginx؛ ولّد حركة
- **التنبيه بيزعق على غلطة واحدة** → ارفع الحد واستخدم نافذة دقيقة

#### إيه اللي لازم تفهمه
تقدر تكتب قاعدة اكتشاف بتزعق على الهجمات وتهدّى في الاستعمال العادي.

**المطلوب تسليمه:** detect.py، وناتج التنبيه، وdarsi-check.json بيجتاز m4.

### m5: دليل الاستجابة للحوادث وتمرين (3 ساعات)

#### ليه ده مهم
الخطط بتفشل من غير تدريب. ملصق عربي لأولياء الأمور بيحوّل الشغل التقني لدفاع مجتمعي.

#### الأدوات للمرحلة دي
- **فريق CERT الوطني** — مين تتصل بيه في الحوادث الكبيرة. هتجيبه من: في مصر EG-CERT على https://www.egcert.eg (فريق CSIRT الوطني في مصر)؛ وفي أي بلد تاني دوّر على فريق CERT أو CSIRT الوطني بتاعه

#### اعمل كده
1. اكتب RUNBOOK.md: مين يتّصل به، وخمس خطوات أولى (احتواء، حفظ أدلة، إبلاغ، إصلاح، مراجعة)، وإمتى تبلّغ فريق CERT الوطني (في مصر: EG-CERT).
2. اعمل تمرين طاولة ١٥ دقيقة مع اتنين باستخدام تنبيهك؛ سجّل إيه يتحسّن.
3. زوّد ملصق تصيّد عربي لأولياء الأمور تحت docs/. حط v1.0. شغّل python check.py --milestone m5.

#### هتبقى خلصت لما
- RUNBOOK بيذكر فريق CERT الوطني (في مصر: EG-CERT)
- docs/ فيه ملصق
- m5 ناجحة

#### لو حاجة وقفت
- **التمرين مالقاش حاجة** → اسأل: مين عنده رقم البديل؟ السجلات فين؟
- **الملصق تقني زيادة** → تلات علامات لرسالة مدرسة مزيفة + تعمل إيه؛ من غير مصطلحات

#### إيه اللي لازم تفهمه
تقدر تكتب خطة حوادث الناس تتدرّب عليها، وصفحة أولياء أمور يقدروا يقرواها.

**المطلوب تسليمه:** RUNBOOK.md، وملاحظات التمرين، والملصق، وActions أخضر، وv1.0، وdarsi-check.json بيجتاز m5، وشرحك.

## الفحص

شغّل `python check.py` أو `python check.py --milestone m2`. بيقرا الملفات بس، بيكتب `darsi-check.json`، وبيطبّع بالإنجليزي والعربي. مش بيرفع حاجة.

## المراجعة على درسي

ابعت رابط الريبو و`darsi-check.json` مع كل مرحلة على درسي. درسي بيقرا آخر تشغيل Actions والإصدار من واجهة GitHub العامة، بيضيف مراجعة استشارية بالذكاء الاصطناعي، وبعدين معلّمك أو فريق درسي بيراجع. **درسي مش بيشغّل كودك.**

## القواعد

دفاع فقط. الهدف الوحيد هو مختبر Juice Shop الخاص بك على هذا الكمبيوتر (localhost). وكل منفذ مربوط بـ 127.0.0.1، وترفض سكربتات الفحص والدخول أي هدف آخر، ويسجّل check.py هدف كل فحص. لا توجّه هذه الأدوات أبدًا إلى مدرسة أو موقع أو شبكة لا تملكها.

## الترخيص

MIT — شوف [LICENSE](LICENSE).

</div>
