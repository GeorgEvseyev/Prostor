#!/bin/bash
# Sync updates from upstream Element X iOS repository

set -e  # Exit on error
set -o pipefail

# Load configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

echo "🚀 Starting Element X iOS upgrade process"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}ℹ $1${NC}"; }
log_success() { echo -e "${GREEN}✓ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠ $1${NC}"; }
log_error() { echo -e "${RED}✗ $1${NC}"; }

# Function to clean up on exit
cleanup() {
    if [ -d "/tmp/element-x-upstream" ]; then
        log_info "Cleaning up temporary directory..."
        rm -rf "/tmp/element-x-upstream"
    fi
}
trap cleanup EXIT

# 1. Create backup branch
log_info "Step 1: Creating backup branch..."
BACKUP_BRANCH="backup/upstream-sync-$(date +'%Y%m%d-%H%M%S')"
git checkout -b "$BACKUP_BRANCH"
log_success "Created backup branch: $BACKUP_BRANCH"

# 2. Fetch latest from upstream
log_info "Step 2: Fetching latest from upstream..."
git fetch upstream
UPSTREAM_COMMIT=$(git rev-parse --short upstream/develop)
log_success "Latest upstream commit: $UPSTREAM_COMMIT"

# 3. Merge upstream changes
log_info "Step 3: Merging upstream changes..."
if git merge upstream/develop --no-ff -m "chore: merge upstream changes from $UPSTREAM_COMMIT"; then
    log_success "Successfully merged upstream changes"
else
    log_warning "Merge conflicts detected. Please resolve manually."
    echo ""
    echo "Conflicted files:"
    git diff --name-only --diff-filter=U
    echo ""
    echo "After resolving conflicts, run:"
    echo "  git add ."
    echo "  git commit -m 'chore: resolve merge conflicts'"
    echo "  git push origin $BACKUP_BRANCH"
    echo ""
    exit 1
fi

# 4. Remove enterprise files
log_info "Step 4: Removing enterprise files..."
for file in "${FILES_TO_REMOVE[@]}"; do
    if [ -e "$file" ]; then
        rm -rf "$file"
        log_success "Removed: $file"
    else
        log_info "File not found (already removed): $file"
    fi
done

# 5. Restore custom files from CUSTOM_BRANCH
log_info "Step 5: Restoring custom files..."
for file in "${CUSTOM_FILES[@]}"; do
    if git show "$CUSTOM_BRANCH:$file" >/dev/null 2>&1; then
        git checkout "$CUSTOM_BRANCH" -- "$file"
        log_success "Restored: $file"
    else
        log_warning "Custom file not found in $CUSTOM_BRANCH: $file"
    fi
done

# 6. Update Package.resolved if needed
log_info "Step 6: Updating Swift packages..."
if [ -f "Package.resolved" ]; then
    xcodebuild -resolvePackageDependencies -scmProvider system -disableAutomaticResolution
    log_success "Package dependencies resolved"
fi

# 7. Run tests
log_info "Step 7: Running basic project validation..."
if xcodebuild -list > /dev/null 2>&1; then
    log_success "Project configuration valid"
else
    log_error "Project configuration invalid"
    exit 1
fi

# 8. Commit changes
log_info "Step 8: Committing changes..."
git add .
if git commit -m "chore: apply customizations after upstream merge" 2>/dev/null; then
    log_success "Changes committed"
else
    log_info "No additional changes to commit"
fi

# 9. Push to remote
log_info "Step 9: Pushing to remote repository..."
git push origin "$BACKUP_BRANCH"

echo ""
echo "=========================================="
log_success "Upgrade process completed successfully!"
echo ""
echo "Next steps:"
echo "1. Review changes in branch: $BACKUP_BRANCH"
echo "2. Run full test suite:"
echo "   xcodebuild test -scheme ElementX -destination 'platform=iOS Simulator,name=iPhone 15'"
echo "3. Create Pull Request to $DEVELOP_BRANCH"
echo "4. After CI passes, merge to $DEVELOP_BRANCH"
echo "5. Test on staging, then merge to $MAIN_BRANCH for release"
echo ""
echo "To abort and return to original state:"
echo "  git checkout $CUSTOM_BRANCH"
echo "  git branch -D $BACKUP_BRANCH"
