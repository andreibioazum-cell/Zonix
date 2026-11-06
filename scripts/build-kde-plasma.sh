#!/usr/bin/env bash
# Сборка KDE Plasma 6.8 из исходного кода
# Полностью владеть кодом и собирать каждый компонент самостоятельно
#
# Использование:
#   chmod +x scripts/build-kde-plasma.sh
#   ./scripts/build-kde-plasma.sh

set -euo pipefail

INSTALL_PREFIX="${INSTALL_PREFIX:-/usr/local}"
BUILD_DIR="${BUILD_DIR:-$HOME/kde-build}"
SRC_DIR="${SRC_DIR:-$HOME/kde-src}"
JOBS="${JOBS:-$(nproc)}"

echo "=============================================="
echo " KDE Plasma 6.8 - сборка из исходного кода"
echo "=============================================="
echo "Установка в: $INSTALL_PREFIX"
echo "Исходники:   $SRC_DIR"
echo "Сборка:      $BUILD_DIR"
echo "Потоков:     $JOBS"
echo "=============================================="

# Проверка зависимостей
echo "[1/5] Проверка и установка зависимостей сборки..."
sudo apt-get update -y
sudo apt-get install -y --no-install-recommends \
    build-essential cmake cmake-data ninja-build ccache git \
    gettext intltool pkg-config libssl-dev libxcb-util0-dev \
    libxcb-icccm4-dev libxcb-image0-dev libxcb-keysyms1-dev \
    libxcb-render-util0-dev libxcb-shape0-dev libxcb-xkb-dev \
    libxcb-xinerama0-dev libxcb-xfixes0-dev libwayland-dev \
    libwayland-client0 libwayland-server0 libwayland-cursor0 \
    libegl1-mesa-dev libgles2 libgl1-mesa-dev libvulkan-dev \
    libdbus-1-dev libsystemd-dev polkitd \
    libkf6archive-dev libkf6auth-dev libkf6codecs-dev \
    libkf6completion-dev libkf6config-dev libkf6configwidgets-dev \
    libkf6coreaddons-dev libkf6crash-dev libkf6dbusaddons-dev \
    libkf6globalaccel-dev libkf6guiaddons-dev libkf6i18n-dev \
    libkf6iconthemes-dev libkf6itemmodels-dev libkf6itemviews-dev \
    libkf6jobwidgets-dev libkf6kcmutils-dev libkf6kdeclarative-dev \
    libkf6ki18n-dev libkf6kio-dev libkf6newstuff-dev \
    libkf6notifications-dev libkf6package-dev libkf6parts-dev \
    libkf6runner-dev libkf6service-dev libkf6textwidgets-dev \
    libkf6widgetsaddons-dev libkf6windowsystem-dev libkf6xmlgui-dev \
    libqt6base6 libqt6base-dev qt6-base-dev-tools qmake6 \
    qt6-tools-dev qt6-tools-dev-tools

mkdir -p "$SRC_DIR" "$BUILD_DIR"

# Функция клонирования и сборки одного модуля
build_module() {
    local repo_url="$1"
    local module_name
    module_name="$(basename "$repo_url" .git)"
    local module_dir="$SRC_DIR/$module_name"
    local build_dir="$BUILD_DIR/$module_name"

    echo ""
    echo "=============================================="
    echo " Модуль: $module_name"
    echo "=============================================="

    if [ ! -d "$module_dir" ]; then
        echo "Клонируем: $repo_url"
        git clone --depth=1 "$repo_url" "$module_dir"
    else
        echo "Обновляем: $module_name"
        git -C "$module_dir" pull --ff-only || true
    fi

    mkdir -p "$build_dir"
    cd "$build_dir"

    echo "Конфигурация CMake для $module_name..."
    cmake -S "$module_dir" -B "$build_dir" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
        -DCMAKE_C_COMPILER_LAUNCHER=ccache \
        -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
        -Wno-dev || {
        echo "ОШИБКА: CMake configure не удался для $module_name"
        return 1
    }

    echo "Сборка $module_name ($JOBS потоков)..."
    cmake --build "$build_dir" --parallel "$JOBS" || {
        echo "ОШИБКА: сборка не удалась для $module_name"
        return 1
    }

    echo "Установка $module_name в $INSTALL_PREFIX..."
    sudo cmake --install "$build_dir" || {
        echo "ОШИБКА: установка не удалась для $module_name"
        return 1
    }

    echo "Готово: $module_name"
}

echo ""
echo "[2/5] Клонирование и сборка Plasma Desktop (панели, виджеты, значки)..."
build_module "https://invent.kde.org/plasma/plasma-desktop.git" || echo "ПРЕДУПРЕЖДЕНИЕ: plasma-desktop не собран"

echo ""
echo "[3/5] Клонирование и сборка KWin (оконный менеджер, Wayland, эффекты)..."
build_module "https://invent.kde.org/plasma/kwin.git" || echo "ПРЕДУПРЕЖДЕНИЕ: kwin не собран"

echo ""
echo "[4/5] Клонирование и сборка KDE Frameworks (основные библиотеки)..."
for framework in karchive kauth kcodecs kcompletion kconfig kconfigwidgets \
    kcoreaddons kcrash kdbusaddons kglobalaccel kguiaddons ki18n \
    kiconthemes kitemmodels kitemviews kjobwidgets kcmutils kdeclarative \
    ki18n kio knewstuff notifications package parts runner service \
    textwidgets widgetsaddons windowsystem xmlgui; do
    build_module "https://invent.kde.org/frameworks/$framework.git" || \
        echo "ПРЕДУПРЕЖДЕНИЕ: $framework не собран (пропускаем)"
done

echo ""
echo "[5/5] Завершение..."
echo "=============================================="
echo "  Сборка KDE Plasma завершена!"
echo "=============================================="
echo "Установлено в: $INSTALL_PREFIX"
echo "Исходники:     $SRC_DIR"
echo "Сборка:        $BUILD_DIR"
echo ""
echo "Запуск Plasma: startplasma-wayland  или  startplasma-x11"
echo "=============================================="
