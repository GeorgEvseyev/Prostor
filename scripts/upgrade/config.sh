#!/bin/bash
# Configuration for Element X iOS upgrades

# Repository configuration
UPSTREAM_REPO="https://github.com/element-hq/element-x-ios.git"
UPSTREAM_BRANCH="develop"
CUSTOM_BRANCH="rebrand/prostor"
DEVELOP_BRANCH="develop"
MAIN_BRANCH="main"

# Paths to custom files that need preservation
CUSTOM_FILES=(
    "LICENSE"
    "LICENSE-COMMERCIAL"
    "MODIFICATIONS.md"
    
    "ElementX/Resources/Assets.xcassets/colors/accent-color.colorset/Contents.json"
    "ElementX/Resources/Assets.xcassets/colors/background-color.colorset/Contents.json"
    "ElementX/Resources/Assets.xcassets/colors/backUp/"
    "app.yml"
    "project.yml"
)

# Files to always remove (enterprise related)
FILES_TO_REMOVE=(
    "Enterprise"
    ".gitmodules"
)

# Package dependencies configuration (if any custom versions)
PACKAGE_OVERRIDES=(
    # "package_name:version_or_branch"
)

# Xcode configuration
XCODE_VERSION="15.2"
IOS_DEPLOYMENT_TARGET="18.5"

# CI/CD configuration
CI_SKIP_TESTS="false"
CI_RUN_LINT="true"

# AGPL-3.0 Compliance
LICENSE_FILE="LICENSE"
MODIFICATIONS_FILE="MODIFICATIONS.md"
ORIGINAL_COPYRIGHT="Copyright (c) 2023 - 2025 Element"

# Files to preserve for license compliance
LICENSE_FILES=(
    "LICENSE"
    "LICENSE-COMMERCIAL"
    "MODIFICATIONS.md"
    "README.md"
    "SECURITY.md"
)
