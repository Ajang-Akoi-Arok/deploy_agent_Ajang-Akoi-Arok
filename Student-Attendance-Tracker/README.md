# Student Attendance Tracker

## How to Run

1. **Make the script executable:**
   ```bash
   chmod +x setup_project.sh
   ```

2. **Run the setup script:**
   ```bash
   ./setup_project.sh
   ```

3. **Follow the prompts:**
   - Enter a name for your attendance tracker
   - Choose whether to update attendance thresholds (warning/failure percentages)

4. **Run the application:**
   ```bash
   cd attendance_tracker_<your_name>
   python3 attendance_checker.py
   ```

## Archive Feature

The script includes an automatic archive feature that activates when setup is interrupted.

### How to Trigger Archive:

Press **Ctrl+C** at any point during the setup process.

### What Happens:

1. The incomplete project directory is compressed into a `.tar.gz` archive
2. Archive is saved as `attendance_tracker_<your_name>_archive.tar.gz`
3. The incomplete directory is removed
4. Setup exits cleanly

### Example:
```bash
./setup_project.sh
# Enter name: "test"
# Press Ctrl+C during setup
# Result: Creates "attendance_tracker_test_archive.tar.gz"
```

## Requirements

- Bash shell
- Python 3
- `tree` command (for directory visualization)
