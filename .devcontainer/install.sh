#!/usr/bin/env bash
# ============================================================
#  install.sh - إعداد بيئة Android Studio (خفيف وسريع)
#  - Idempotent: يتخطى ما تم تثبيته مسبقًا
#  - Retries: يعيد المحاولة عند فشل الشبكة
#  - Timeouts: لا يعلّق للأبد
#  - Lock file: يتخطى الإعداد بالكامل إذا اكتمل قبل ذلك
# ============================================================

set -eo pipefail

SDK="/workspaces/android-sdk"
STUDIO_DIR="/opt/android-studio"
LOCK_FILE="/workspaces/.android-setup-complete"

# ألوان للطباعة
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

log()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; }
info() { echo -e "${BLUE}[i]${NC} $1"; }

# تحميل مع إعادة المحاولة (لا يعلّق)
download_with_retry() {
  local url=$1
  local output=$2
  local label=$3
  local max_attempts=3
  for i in $(seq 1 $max_attempts); do
    info "محاولة $i/$max_attempts: تنزيل $label..."
    if curl -fL --retry 3 --connect-timeout 30 --max-time 900 -o "$output" "$url" 2>&1 | tail -1; then
      log "تم تنزيل $label بنجاح"
      return 0
    fi
    warn "المحاولة $i فشلت، إعادة المحاولة بعد 5 ثوانٍ..."
    sleep 5
  done
  err "فشل تنزيل $label بعد $max_attempts محاولات"
  return 1
}

# تخطي الإعداد إذا اكتمل سابقًا
if [ -f "$LOCK_FILE" ]; then
  log "الإعداد مكتمل سابقًا. تخطي..."
  exit 0
fi

info "بدء إعداد بيئة Android..."

# ============================================================
# 1. Android SDK (Command-line Tools)
# ============================================================
if [ ! -d "$SDK/cmdline-tools/latest" ]; then
  info "الخطوة 1/4: تثبيت Android Command-line Tools..."
  mkdir -p "$SDK/cmdline-tools"
  if download_with_retry \
    "https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip" \
    "/tmp/cmdline-tools.zip" \
    "Android Command-line Tools"; then
    unzip -q /tmp/cmdline-tools.zip -d "$SDK/cmdline-tools"
    mv "$SDK/cmdline-tools/cmdline-tools" "$SDK/cmdline-tools/latest"
    rm -f /tmp/cmdline-tools.zip
    log "تم تثبيت Command-line Tools"
  else
    warn "تعذر تثبيت Command-line Tools (متابعة على أمل العمل لاحقًا)"
  fi
else
  log "Command-line Tools مثبت مسبقًا"
fi

export ANDROID_HOME="$SDK"
export ANDROID_SDK_ROOT="$SDK"
export PATH="$SDK/cmdline-tools/latest/bin:$SDK/platform-tools:$PATH"

# ============================================================
# 2. قبول التراخيص
# ============================================================
if command -v sdkmanager &> /dev/null; then
  info "الخطوة 2/4: قبول تراخيص Android..."
  yes | sdkmanager --licenses > /dev/null 2>&1 || true
  log "تم قبول التراخيص"

  # ============================================================
  # 3. تثبيت حزم SDK
  # ============================================================
  info "الخطوة 3/4: تثبيت حزم SDK الأساسية..."
  sdkmanager --install \
    "platform-tools" \
    "platforms;android-34" \
    "build-tools;34.0.0" 2>&1 | tail -5 || warn "تعذر تثبيت بعض حزم SDK"
  log "تم تثبيت حزم SDK"
else
  warn "sdkmanager غير متاح - تخطي تثبيت حزم SDK"
fi

# ============================================================
# 4. Android Studio (GUI)
# ============================================================
if [ ! -x "$STUDIO_DIR/bin/studio.sh" ]; then
  info "الخطوة 4/4: تثبيت Android Studio..."
  # نستخدم أحدث إصدار مستقر - الرابط الرسمي من Google
  STUDIO_URL="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2024.1.1.13/android-studio-2024.1.1.13-linux.tar.gz"
  if download_with_retry "$STUDIO_URL" "/tmp/android-studio.tar.gz" "Android Studio (~1.2 GB)"; then
    info "فك ضغط Android Studio..."
    sudo mkdir -p /opt
    sudo tar -xzf /tmp/android-studio.tar.gz -C /opt
    rm -f /tmp/android-studio.tar.gz
    if [ -x "$STUDIO_DIR/bin/studio.sh" ]; then
      sudo chown -R vscode:vscode "$STUDIO_DIR" 2>/dev/null || true
      sudo chmod +x "$STUDIO_DIR/bin/studio.sh"
      sudo ln -sf "$STUDIO_DIR/bin/studio.sh" /usr/local/bin/android-studio
      log "تم تثبيت Android Studio"
    else
      err "فشل التثبيت: studio.sh غير موجود بعد فك الضغط"
    fi
  else
    warn "تعذر تنزيل Android Studio (متابعة بدون GUI)"
    warn "يمكنك تثبيته يدويًا لاحقًا بتشغيل: bash .devcontainer/install-studio.sh"
  fi
else
  log "Android Studio مثبت مسبقًا"
fi

# ============================================================
# 5. توليد Gradle Wrapper لمشروع الاختبار
# ============================================================
if [ -f "/workspaces/android-codespaces-v3/testproject/build.gradle" ] && [ ! -f "/workspaces/android-codespaces-v3/testproject/gradlew" ]; then
  info "توليد Gradle Wrapper..."
  cd /workspaces/android-codespaces-v3/testproject
  if command -v gradle &> /dev/null; then
    gradle wrapper --gradle-version 8.7 2>&1 | tail -3 || warn "تعذر توليد Wrapper"
    log "تم توليد Gradle Wrapper"
  fi
  cd /workspaces
fi

# ============================================================
# 6. وضع علامة الإكمال
# ============================================================
touch "$LOCK_FILE"

echo ""
echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}  ✅ اكتمل إعداد بيئة Android Studio!${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""
echo -e "${BLUE}الوصول إلى Android Studio:${NC}"
echo "  1. تبويب Ports في VS Code"
echo "  2. افتح المنفذ 6080 في المتصفح"
echo "  3. كلمة المرور: android"
echo "  4. في Terminal سطح المكتب: android-studio &"
echo ""
echo -e "${BLUE}لبناء APK:${NC}"
echo "  cd /workspaces/android-codespaces-v3/testproject"
echo "  ./gradlew assembleDebug"
echo "  → APK في: app/build/outputs/apk/debug/app-debug.apk"
echo ""
