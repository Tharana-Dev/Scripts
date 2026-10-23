# 🐧 Automated Portfolio Backup Script

A robust bash script designed to create clean, lightweight backups of development directories (like portfolios or web apps). It automatically ignores heavy environment folders (`venv`, `__pycache__`, `node_modules`), compiles the project into a `.zip`, generates a detailed text report, and stages the final package for deployment.

## ✨ Features

- **Smart Exclusions:** Automatically skips virtual environments, Python bytecode, Git history, and local IDE settings.
- **Dynamic Reporting:** Generates a `portfolio_backup_report.txt` that shows original size vs. zipped size, and counts exactly how many junk files were excluded.
- **Configurable:** Uses a clean configuration block at the top of the script so you can easily change source paths, destination paths, and exclusion patterns.
- **Staging & Deployment:** Packages the final ZIP, the report, and the script itself into a clean deployment folder.

## 🚀 How to Use

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Tharana-Dev/automated-backup-script.git
   cd automated-backup-script
   ```

2. **Make the script executable:**
   ```bash
   chmod +x log.sh
   ```

3. **Configure the paths:**
   Open `log.sh` in your favorite text editor (like Vim or Nano) and update the `CONFIGURATION` section at the top:
   ```bash
   SOURCE_DIR="/path/to/your/project"
   WORKSPACE_DIR="$HOME/data/backup"
   DEPLOY_DIR="/path/to/your/deploy_folder"
   ```

4. **Run the script:**
   ```bash
   ./log.sh
   ```

## 📁 What Happens When You Run It?

1. It copies your source directory to a temporary workspace.
2. It scans and counts excluded items (like `venv` and `.pyc` files).
3. It zips the clean workspace.
4. It generates a report text file.
5. It stages everything into your `DEPLOY_DIR` (which you can point to a cloud sync folder like Google Drive, OneDrive, or a mounted USB).

## 🛠️ Technologies Used
- **Bash** (Shell Scripting)
- **Zip / Unzip** (Compression)
- **Coreutils** (find, du, cp, rm)

## 📧 Contact
Tharana Nimsara — [dev.tharana@gmail.com](mailto:dev.tharana@gmail.com)
```
