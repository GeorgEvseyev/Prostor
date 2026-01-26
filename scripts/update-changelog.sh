#!/bin/bash
# Скрипт для обновления CHANGES.md при обновлениях

set -e

VERSION="$1"
UPSTREAM_COMMIT="$2"
OUR_COMMIT="$3"

if [ -z "$VERSION" ] || [ -z "$UPSTREAM_COMMIT" ]; then
    echo "Использование: $0 <версия> <upstream-commit> [наш-commit]"
    echo "Пример: $0 v26.01.1 3b231339c e3d29f9ff"
    exit 1
fi

# Создаем backup
cp CHANGES.md CHANGES.md.backup

# Получаем список коммитов между нашим и upstream
COMMITS=$(git log --oneline --no-merges $OUR_COMMIT..$UPSTREAM_COMMIT 2>/dev/null || git log --oneline --no-merges upstream/develop 2>/dev/null | head -20)

# Обновляем CHANGES.md
{
    echo "# Version $VERSION - $(date +'%Y-%m-%d')"
    echo ""
    echo "## Обновления из Element X iOS"
    echo ""
    echo "Основные изменения:"
    echo ""
    echo "$COMMITS" | sed 's/^/- /'
    echo ""
    echo "## Наши модификации"
    echo "- Сохранен кастомный брендинг"
    echo "- Удалены enterprise компоненты"
    echo "- Обновлены зависимости"
    echo ""
    echo "---"
    echo ""
    cat CHANGES.md
} > CHANGES.md.new

mv CHANGES.md.new CHANGES.md
echo "✅ CHANGES.md обновлен для версии $VERSION"
