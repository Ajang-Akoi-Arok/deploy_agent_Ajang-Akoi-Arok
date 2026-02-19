# Student Attendance Tracker

## How to Run

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Ajang-Akoi-Arok/deploy_agent_Ajang-Akoi-Arok.git
   ```

2. **Navigate to the project directory:**
   ```bash
   cd deploy_agent_Ajang-Akoi-Arok
   ```

3. **Make the script executable:**
   ```bash
   chmod +x setup_project.sh
   ```

4. **Run the setup script:**
   ```bash
   ./setup_project.sh
   ```

5. **Follow the prompts:**
   - Enter a name for your attendance tracker
   - Choose whether to update attendance thresholds (yes/y or no/n)
   - If updating thresholds:
     - Enter warning threshold (0-100, default: 75%)
     - Enter failure threshold (0-100, default: 50%)
     - Note: Warning threshold must be higher than failure threshold
   - The script will verify directory structure using `tree` command
   - Health check will validate Python 3 installation and file integrity

6. **Run the application:**
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

## Thank you

## link to the vidoe

Watch the complete walkthrough: [Student Attendance Tracker Demo](https://drive.google.com/file/d/1HlTumZ6_rNLwZPKv10uSwD7DZAVOu842/view?usp=sharing)