# Сборка Zonix (KDE Plasma) из исходного кода

Чтобы полностью владеть кодом и собирать каждый компонент системы самостоятельно, используйте официальные репозитории исходного кода.

## 1. Клонирование исходного кода KDE Plasma 6.8

Весь код графического оболочки разбит на модули. Официальный репозиторий всех проектов KDE — [KDE Invent (GitLab)](https://invent.kde.org/).

### Plasma Desktop (панели, виджеты, значки)

```bash
git clone https://invent.kde.org/plasma/plasma-desktop.git
cd plasma-desktop
```

### KWin (оконный менеджер, Wayland-сессия, эффекты)

```bash
git clone https://invent.kde.org/plasma/kwin.git
```

### KDE Frameworks 6.8 (все 69 библиотек)

Официальные архивы исходного кода KDE Frameworks 6.8:

```bash
# Пример клонирования одного из модулей frameworks
git clone https://invent.kde.org/frameworks/kconfig.git
git clone https://invent.kde.org/frameworks/kcoreaddons.git
git clone https://invent.kde.org/frameworks/kio.git
# и так далее для всех 69 компонентов
```

Полный список и архивы: https://kde.org/info/kde-frameworks-6.8.0/

### Главная страница исходного кода KDE (GitHub mirror)

Некоторые компоненты дублируются на GitHub:

- https://github.com/kde/plasma-desktop

## 2. Клонирование исходного кода ядра Linux

Ядро управляет железом, памятью и процессами.

### Официальное зеркало ядра Linux (GitHub)

```bash
git clone https://github.com/torvalds/linux.git
```

Или с официального сайта:

```bash
git clone https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
```

## 3. Сборочные инструкции (PKGBUILD для Arch Linux)

Чтобы превратить исходный код C++ и C в работающие системные файлы, используются скрипты сборки.

### Репозиторий сборочных инструкций Arch Linux

https://gitlab.archlinux.org/archlinux/packaging/packages

Пример для Plasma Desktop:

```bash
git clone https://gitlab.archlinux.org/archlinux/packaging/packages/plasma-desktop.git
```

Информация о пакете: https://archlinux.org/packages/extra/x86_64/plasma-desktop/

### Инструкция по созданию пакетов

https://wiki.archlinux.org/title/Creating_packages

## 4. Порядок сборки (пример)

```bash
# 1. Клонируем ядро
git clone https://github.com/torvalds/linux.git
cd linux
make menuconfig
make -j$(nproc)
sudo make modules_install
sudo make install

# 2. Клонируем и собираем KDE Frameworks
git clone https://invent.kde.org/frameworks/kconfig.git
cd kconfig
mkdir build && cd build
cmake ..
make -j$(nproc)
sudo make install

# 3. Клонируем и собираем Plasma Desktop
git clone https://invent.kde.org/plasma/plasma-desktop.git
cd plasma-desktop
mkdir build && cd build
cmake ..
make -j$(nproc)
sudo make install

# 4. Клонируем и собираем KWin
git clone https://invent.kde.org/plasma/kwin.git
cd kwin
mkdir build && cd build
cmake ..
make -j$(nproc)
sudo make install
```

## 5. Альтернатива: kde-builder

Для автоматической сборки всех компонентов KDE одной командой можно использовать инструмент **kde-builder**. Он выкачивает репозитории, разрешает зависимости и компилирует их в правильном порядке.

Документация: https://community.kde.org/Get_Involved/development/Set_up_kde-builder

## 6. Скрипты automatзации сборки (в этом репозитории)

В папке `scripts/` готовые скрипты для самостоятельной сборки:

| Скрипт | Что делает |
|--------|------------|
| `scripts/build-kde-plasma.sh` | Клонирует и собирает Plasma Desktop, KWin, все 69 модулей KDE Frameworks 6.8 |
| `scripts/build-kernel.sh` | Клонирует и собирает ядро Linux с настройкой конфигурации |
| `scripts/kde-builder.rc` | Конфигурационный файл для утилиты kde-builder |

Пример запуска:

```bash
chmod +x scripts/build-kde-plasma.sh scripts/build-kernel.sh
./scripts/build-kde-plasma.sh    # собирает Plasma из исходников
./scripts/build-kernel.sh        # собирает ядро Linux из исходников
```

## 7. Что уже есть в этом репозитории

В ветке `arena/3cf9175c-zonix` (PR #2) настроен GitHub Actions workflow `.github/workflows/build-iso.yml`, который:

- Собирает загрузочный ISO-образ с MBR-загрузчиком (печать "Zonix ISO Boot Sector" + HLT)
- Создаёт raw-образ HDD-диска 50 МБ с загрузочной сигнатурой 0x55AA
- Пакет `zonix-release.zip` загружается как артефакт GitHub Actions

Этот ISO — не полноценная ОС. Для работы нужна установленная система (например, KDE Neon — самый оптимизированный дистрибутив для Plasma, см. `docs/BEST_DISTRO.md`).

