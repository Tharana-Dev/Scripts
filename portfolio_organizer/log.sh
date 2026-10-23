#!/bin/bash

# =========================================
# CONFIGURATION
# Change these variables to match your setup
# =========================================
SOURCE_DIR="/mnt/c/python/Portfolio"
WORKSPACE_DIR="$HOME/data/backup"
REPORT_FILE="$HOME/portfolio_backup_report.txt"
ZIP_FILENAME="portfolio_clean.zip"
DEPLOY_DIR="/mnt/c/python/portfolio_package"

# =========================================
# EXCLUSION PATTERNS
# Add or remove patterns here as needed
# =========================================
EXCLUDE_PATTERNS=(
    "*/venv/*"
    "*/__pycache__/*"
    "*/.mypy_cache/*"
    "*/.pytest_cache/*"
    "*/.ipynb_checkpoints/*"
    "*.pyc"
    "*/.git/*"
    "*/.gitignore"
    "*/.idea/*"
    "*/.vscode/*"
    "*/build/*"
    "*/dist/*"
    "*/ffmpeg/*"
    "*/Downloader/version 1/*"
    "*/Downloader/version 2/*"
    "*/Downloader/version 3/*"
    "*/Downloader/version 4/*" # Excludes all media in v4
)

# =========================================
# VALIDATION
# =========================================
if [ ! -d "$SOURCE_DIR" ]; then
    echo "❌ Error: Source directory '$SOURCE_DIR' does not exist."
    exit 1
fi

echo "🚀 Starting backup process..."
ORIG_SIZE=$(du -sh "$SOURCE_DIR" | cut -f1)

# 1. Prepare Workspace
rm -rf "$WORKSPACE_DIR"
mkdir -p "$WORKSPACE_DIR"
cp -r "$SOURCE_DIR/." "$WORKSPACE_DIR/"
cd "$WORKSPACE_DIR" || exit 1

# 2. Count Excluded Items (For the Report)
VENV_COUNT=$(find . -type d -name "venv" | wc -l)
PYCACHE_COUNT=$(find . -type d -name "__pycache__" | wc -l)
MYPY_COUNT=$(find . -type d -name ".mypy_cache" | wc -l)
PYTEST_COUNT=$(find . -type d -name ".pytest_cache" | wc -l)
PYC_COUNT=$(find . -type f -name "*.pyc" | wc -l)
BUILD_COUNT=$(find . -type d -name "build" | wc -l)
DIST_COUNT=$(find . -type d -name "dist" | wc -l)
GIT_AND_GITIGNORE=$(find . -name ".git*" | wc -l)
JUPYTER_NOTEBOOKS=$(find . -type d -name ".ipynb_checkpoints" | wc -l)

# 3. Create the Zip
ZIPPED_PATH="$HOME/backedup_data"
rm -rf "$ZIPPED_PATH"
mkdir -p "$ZIPPED_PATH"

# Build the zip arguments dynamically
ZIP_ARGS=()
for pattern in "${EXCLUDE_PATTERNS[@]}"; do
    ZIP_ARGS+=("-x" "$pattern")
done

echo "📦 Zipping files..."
zip -r "$ZIPPED_PATH/$ZIP_FILENAME" . "${ZIP_ARGS[@]}" > /dev/null
ZIP_SIZE=$(du -sh "$ZIPPED_PATH/$ZIP_FILENAME" | cut -f1)

# 4. Generate the Report
cat << EOF | tee "$REPORT_FILE"

PORTFOLIO BACKUP REPORT
=======================
Date:            $(date)
Source:          $SOURCE_DIR
Original Size:   $ORIG_SIZE
Zip Size:        $ZIP_SIZE
Workspace:       $WORKSPACE_DIR
Deploy Path:     $DEPLOY_DIR

============ EXCLUDED FILES COUNT ============
venv folders:            $VENV_COUNT
__pycache__ folders:     $PYCACHE_COUNT
.mypy_cache folders:     $MYPY_COUNT
.pytest_cache folders:   $PYTEST_COUNT
.pyc files:              $PYC_COUNT
build folders:           $BUILD_COUNT
dist folders:            $DIST_COUNT
.git and .gitignore:     $GIT_AND_GITIGNORE
Jupyter Notebooks:       $JUPYTER_NOTEBOOKS

Status:          ✅ STAGING COMPLETE
File Name:       $ZIP_FILENAME
EOF

# 5. Stage and Deploy
echo "🚚 Deploying to $DEPLOY_DIR..."
STAGE_DIR="$HOME/portfolio_package"
rm -rf "$STAGE_DIR"
mkdir -p "$STAGE_DIR"

cp "$ZIPPED_PATH/$ZIP_FILENAME" "$STAGE_DIR/"
cp "$REPORT_FILE" "$STAGE_DIR/"
cp "$HOME/log.sh" "$STAGE_DIR/" # Copies the script itself into the package

rm -rf "$DEPLOY_DIR"
cp -r "$STAGE_DIR" "$DEPLOY_DIR"

echo ""
echo "✅ Package deployed successfully to: $DEPLOY_DIR"
ls -lh "$DEPLOY_DIR"