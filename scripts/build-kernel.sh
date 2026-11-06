#!/usr/bin/env bash
# Сборка ядра Linux из исходного кода
#
# Использование:
#   chmod +x scripts/build-kernel.sh
#   ./scripts/build-kernel.sh

set -euo pipefail

KERNEL_SRC="${KERNEL_SRC:-$HOME/kernel-src}"
KERNEL_BUILD="${KERNEL_BUILD:-$HOME/kernel-build}"
KERNEL_REPO="${KERNEL_REPO:-https://github.com/torvalds/linux.git}"
JOBS="${JOBS:-$(nproc)}"

echo "=============================================="
echo " Ядро Linux - сборка из исходного кода"
echo "=============================================="
echo "Репозиторий:  $KERNEL_REPO"
echo "Исходники:    $KERNEL_SRC"
echo "Сборка:       $KERNEL_BUILD"
echo "Потоков:      $JOBS"
echo "=============================================="

# Установка зависимостей
echo "[1/5] Установка инструментов сборки ядра..."
sudo apt-get update -y
sudo apt-get install -y --no-install-recommends \
    build-essential bc bison flex libssl-dev libelf-dev \
    libncurses-dev xz-utils cpio gzip tar wget git \
    dwarves libncursesw5-dev

mkdir -p "$KERNEL_SRC" "$KERNEL_BUILD"

# Клонирование ядра
if [ ! -d "$KERNEL_SRC/.git" ]; then
    echo "[2/5] Клонирование ядра Linux..."
    git clone --depth=1 "$KERNEL_REPO" "$KERNEL_SRC"
else
    echo "[2/5] Обновление ядра Linux..."
    git -C "$KERNEL_SRC" pull --ff-only || true
fi

cd "$KERNEL_SRC"

# Настройка конфигурации
echo "[3/5] Настройка конфигурации ядра..."
make defconfig

# Опционально: включить дополнительные опции для десктопа
# make menuconfig  # интерактивно, если нужно

# Сборка ядра
echo "[4/5] Сборка ядра ($JOBS потоков)..."
make -j"$JOBS" bzImage
make -j"$JOBS" modules

# Установка
echo "[5/5] Установка ядра и модулей..."
sudo make modules_install
sudo make install

echo ""
echo "=============================================="
echo "  Сборка ядра Linux завершена!"
echo "=============================================="
echo "Ядро установлен: /boot/vmlinuz-$(make kernelrelease)"
echo "Модули:          /lib/modules/$(make kernelrelease)"
echo "Конфиг:          /boot/config-$(make kernelrelease)"
echo ""
echo "Перезагрузитесь и выберите новое ядро в загрузчике (GRUB)."
echo "=============================================="
