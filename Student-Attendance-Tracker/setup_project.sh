#!/bin/bash

parent_dir=""

cleanup_on_interrupt() {
    echo ""
    echo "Interrupt detected! Cleaning up..."

    if [[ -n "$parent_dir" && -d "$parent_dir" ]]; then
        tar -czf "${parent_dir}_archive.tar.gz" "$parent_dir"
        echo "Project archived as ${parent_dir}_archive.tar.gz"
        rm -rf "$parent_dir"
        echo "Incomplete project directory removed."
    fi

    exit 1
}

trap cleanup_on_interrupt SIGINT

echo ""
echo "STUDENT ATTENDANCE TRACKER"
echo ""

read -p "Enter the name for attendance tracker: " identifier

if [ -z "$identifier" ]; then
    echo "Error: Identifier cannot be empty"
    exit 1
fi

parent_dir="attendance_tracker_${identifier}"

echo ""
echo "$parent_dir"
echo ""

if [ -d "$parent_dir" ]; then
    echo "Error: Directory '$parent_dir' already exists"
    exit 1
fi

echo "Creating directory structure..."

mkdir -p "$parent_dir" || { echo "Permission denied. Cannot create root directory."; exit 1; }
mkdir -p "$parent_dir/Helpers" || { echo "Permission denied. Cannot create Helpers directory."; exit 1; }
mkdir -p "$parent_dir/reports" || { echo "Permission denied. Cannot create reports directory."; exit 1; }

if [ ! -d "source_files" ]; then
    echo "Error: source_files directory not found"
    exit 1
fi

cp source_files/attendance_checker.py "$parent_dir/"
cp source_files/assets.csv "$parent_dir/Helpers/"
cp source_files/config.json "$parent_dir/Helpers/"
cp source_files/reports.log "$parent_dir/reports/"

if [ ! -f "$parent_dir/attendance_checker.py" ] || \
   [ ! -f "$parent_dir/Helpers/assets.csv" ] || \
   [ ! -f "$parent_dir/Helpers/config.json" ] || \
   [ ! -f "$parent_dir/reports/reports.log" ]; then
    echo "Error: Failed to copy source files"
    exit 1
fi
echo ""
echo "Directories structure is created and files are copied from the source_files successfully"

config_file="$parent_dir/Helpers/config.json"

current_warning=$(grep -o '"warning": [0-9]*' "$config_file" | grep -o '[0-9]*')
current_failure=$(grep -o '"failure": [0-9]*' "$config_file" | grep -o '[0-9]*')

echo ""
echo "Current warning threshold: ${current_warning}%"
echo "Current failure threshold: ${current_failure}%"
echo ""

while true; do
    read -p "Do you want to update the attendance thresholds? (yes/y or no/n): " update_choice

    case "$update_choice" in
        yes|y|Y|YES)
        echo ""
            echo "Proceeding with threshold update..."
            echo ""
            echo "Note: Thresholds must be integers between 0 and 100. Press Enter to keep current values."
            echo ""
            read -p "Enter new warning threshold (default: ${current_warning}%): " warn_input
            if [[ -z "$warn_input" ]]; then
                warn_threshold=$current_warning
            elif [[ "$warn_input" =~ ^[0-9]+$ ]] && [ "$warn_input" -ge 0 ] && [ "$warn_input" -le 100 ]; then
                warn_threshold=$warn_input
            else
                warn_threshold=$current_warning
                echo "Invalid input. Using default: ${warn_threshold}%"
            fi

            read -p "Enter new failure threshold (default: ${current_failure}%): " fail_input
            if [[ -z "$fail_input" ]]; then
                fail_threshold=$current_failure
            elif [[ "$fail_input" =~ ^[0-9]+$ ]] && [ "$fail_input" -ge 0 ] && [ "$fail_input" -le 100 ]; then
                fail_threshold=$fail_input
            else
                fail_threshold=$current_failure
                echo "Invalid input. Using default: ${fail_threshold}%"
            fi

            sed -i.bak "s/\"warning\": [0-9]*/\"warning\": $warn_threshold/" "$config_file"
            sed -i.bak "s/\"failure\": [0-9]*/\"failure\": $fail_threshold/" "$config_file"
            rm -f "${config_file}.bak"

            echo "Configuration updated"
            break
            ;;
        no|n|N|NO)
            echo "Keeping existing thresholds"
            warn_threshold=$current_warning
            fail_threshold=$current_failure
            break
            ;;
        *)
            echo "Invalid input. Please enter yes/y or no/n."
            ;;
    esac
done

echo ""
echo "Running Health Check..."
echo ""
echo "Checking Python 3:"

if command -v python3 &> /dev/null; then
    python_version=$(python3 --version)
    echo "Python 3 is installed: $python_version"
else
    echo "Python 3 not found - Warning"
fi

echo ""
echo "Verifying directory structure:"
echo ""
tree "$parent_dir"
if [ -d "$parent_dir" ] && \
   [ -d "$parent_dir/Helpers" ] && \
   [ -d "$parent_dir/reports" ] && \
   [ -f "$parent_dir/attendance_checker.py" ] && \
   [ -f "$parent_dir/Helpers/assets.csv" ] && \
   [ -f "$parent_dir/Helpers/config.json" ] && \
   [ -f "$parent_dir/reports/reports.log" ]; then
    echo "All required directories and files are in place"
else
    echo "Error: Directory structure validation failed"
    exit 1
fi

echo ""
echo "Health check complete"
echo ""
echo "Setup Completed"
echo ""
echo "Current thresholds:"
echo "  Warning: $(grep -o '"warning": [0-9]*' "$config_file" | grep -o '[0-9]*')%"
echo "  Failure: $(grep -o '"failure": [0-9]*' "$config_file" | grep -o '[0-9]*')%"
echo ""
echo "To run application:"
echo "  cd $parent_dir"
echo "  python3 attendance_checker.py"
echo ""
echo "To view report:"
echo "  cat $parent_dir/reports/reports.log"
echo ""
echo "Press Ctrl+C during setup to test archive feature"
echo ""

exit 0