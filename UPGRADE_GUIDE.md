# Callelement-x iOS Upgrade Guide

Это руководство описывает процесс обновления Callelement-x (форк Element X iOS) с сохранением кастомных изменений.

## 🏗️ Архитектура обновлений

### Ветки:
- `main` - стабильная production версия
- `develop` - ветка для интеграции обновлений
- `rebrand/prostor` - оригинальные кастомные изменения (брендинг)
- `feature/upgrade-*` - ветки для обновлений
- `backup/*` - резервные копии

### Файлы конфигурации:
- `scripts/upgrade/config.sh` - настройки обновлений
- `scripts/upgrade/sync-from-upstream.sh` - основной скрипт

## 🔄 Процесс обновления

### Автоматический способ:
\`\`\`bash
# 1. Переключитесь на develop ветку
git checkout develop
git pull origin develop

# 2. Запустите скрипт обновления
./scripts/upgrade/sync-from-upstream.sh

# 3. Скрипт создаст ветку backup/upstream-sync-YYYYMMDD-HHMMSS
# 4. Проверьте изменения, запустите тесты
# 5. Создайте Pull Request на GitHub
\`\`\`

### Ручной способ:
\`\`\`bash
# 1. Получите обновления из upstream
git fetch upstream
git checkout -b feature/upgrade-\$(date +'%Y%m%d')

# 2. Смержите изменения
git merge upstream/develop --no-ff

# 3. Удалите enterprise файлы
rm -rf Enterprise
rm -f .gitmodules

# 4. Восстановите кастомные файлы
git checkout rebrand/prostor -- \\
  ElementX/Resources/Assets.xcassets/colors/accent-color.colorset/Contents.json \\
  ElementX/Resources/Assets.xcassets/colors/background-color.colorset/Contents.json \\
  ElementX/Resources/Assets.xcassets/colors/backUp/ \\
  app.yml \\
  project.yml

# 5. Обновите зависимости
xcodebuild -resolvePackageDependencies -scmProvider system
\`\`\`

## 📁 Сохраняемые кастомные файлы

При каждом обновлении сохраняются:
- \`ElementX/Resources/Assets.xcassets/colors/accent-color.colorset/Contents.json\` - цвет акцента
- \`ElementX/Resources/Assets.xcassets/colors/background-color.colorset/Contents.json\` - фоновый цвет
- \`ElementX/Resources/Assets.xcassets/colors/backUp/\` - backup оригинальных цветов
- \`app.yml\` - конфигурация приложения
- \`project.yml\` - конфигурация Xcode проекта

## 🗑️ Удаляемые файлы

Автоматически удаляются:
- \`Enterprise/\` - enterprise компоненты
- \`.gitmodules\` - ссылки на enterprise submodules

## 🧪 Тестирование после обновления

\`\`\`bash
# Запустите unit тесты
xcodebuild test \\
  -scheme ElementX \\
  -destination "platform=iOS Simulator,name=iPhone 15" \\
  -only-testing:UnitTests

# Запустите UI тесты
xcodebuild test \\
  -scheme ElementX \\
  -destination "platform=iOS Simulator,name=iPhone 15" \\
  -only-testing:UITests

# Соберите проект
xcodebuild build \\
  -scheme ElementX \\
  -destination "platform=iOS Simulator,name=iPhone 15"
\`\`\`

## 🤖 Автоматические проверки

GitHub Actions автоматически:
1. **Проверяет доступность обновлений** каждый понедельник (upgrade-check.yml)
2. **Запускает тесты** при каждом PR (существующие workflows)
3. **Создает issue** когда есть новые обновления

## 🚨 Troubleshooting

### Конфликты при мерже:
1. Разрешите конфликты вручную
2. Убедитесь что кастомные файлы не перезаписаны
3. Проверьте \`git status\` для списка конфликтующих файлов

### Проблемы с Swift packages:
\`\`\`bash
# Очистите кэш
rm -rf ~/Library/Developer/Xcode/DerivedData
rm -rf ~/Library/Caches/org.swift.swiftpm

# Переустановите зависимости
xcodebuild -resolvePackageDependencies -scmProvider system -disableAutomaticResolution
\`\`\`

### Скрипт не запускается:
\`\`\`bash
# Дайте права на выполнение
chmod +x scripts/upgrade/*.sh

# Проверьте что в develop ветке
git checkout develop
git pull origin develop
\`\`\`

## 📞 Поддержка

Для вопросов по обновлениям:
1. Создайте Issue в репозитории
2. Укажите версию и ошибку
3. Приложите логи выполнения скрипта

---
*Последнее обновление: $(date +'%Y-%m-%d')*
