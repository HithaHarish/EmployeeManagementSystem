#!/bin/bash

# Data files
EMP_FILE="emp.lst"
DEPT_FILE="dept.lst"

# Ensure the data files exist
touch $EMP_FILE $DEPT_FILE

# Function: Display Main Menu
main_menu() {
    while true; do
        CHOICE=$(dialog --clear --backtitle "Employee & Department Management System" \
            --title "Main Menu" \
            --menu "Choose an action:" 20 60 9 \
            1 "Add Employee" \
            2 "Add Department" \
            3 "View Employee Records" \
            4 "View Department Details" \
            5 "Search Employee Records" \
            6 "Update Employee Details" \
            7 "Delete Employee" \
            8 "Generate Reports" \
            9 "Exit" \
            3>&1 1>&2 2>&3)

       case $CHOICE in
            1) add_employee ;;
            2) add_department ;;
            3) view_records ;;
            4) view_departments ;;
            5) search_records ;;
            6) update_employee ;;
            7) delete_employee ;;
            8) generate_reports ;;
            9) dialog --msgbox "Exiting the system. Goodbye!" 10 30 ; clear ; exit 0 ;;
            *) dialog --msgbox "Invalid choice!" 10 30 ;;
        esac
    done
}

# Function: Add Employee
add_employee() {
    emp_id=$(dialog --inputbox "Enter Employee ID:" 10 40 3>&1 1>&2 2>&3)
    name=$(dialog --inputbox "Enter Employee Name:" 10 40 3>&1 1>&2 2>&3)
    dept=$(dialog --inputbox "Enter Department:" 10 40 3>&1 1>&2 2>&3)
    salary=$(dialog --inputbox "Enter Salary:" 10 40 3>&1 1>&2 2>&3)

    if [[ -n $emp_id && -n $name && -n $dept && -n $salary ]]; then
        echo "$emp_id|$name|$dept|$salary" >> $EMP_FILE
        dialog --msgbox "Employee added successfully!" 10 30
    else
        dialog --msgbox "All fields are required!" 10 30
    fi
}

# Function: Add Department
add_department() {
    dept_id=$(dialog --inputbox "Enter Department ID:" 10 40 3>&1 1>&2 2>&3)
    dept_name=$(dialog --inputbox "Enter Department Name:" 10 40 3>&1 1>&2 2>&3)

    if [[ -n $dept_id && -n $dept_name ]]; then
        echo "$dept_id|$dept_name" >> $DEPT_FILE
        dialog --msgbox "Department added successfully!" 10 30
    else
        dialog --msgbox "All fields are required!" 10 30
    fi
}

# Function: View Employee Records
view_records() {
    if [[ -s $EMP_FILE ]]; then
        dialog --textbox $EMP_FILE 20 60
    else
        dialog --msgbox "No employee records found!" 10 30
    fi
}

# Function: View Department Details
view_departments() {
    if [[ -s $DEPT_FILE ]]; then
        dialog --textbox $DEPT_FILE 20 60
    else
        dialog --msgbox "No department records found!" 10 30
    fi
}

# Function: Search Records
search_records() {
    search_term=$(dialog --inputbox "Enter search term:" 10 40 3>&1 1>&2 2>&3)
    result=$(grep -i "$search_term" $EMP_FILE)

    if [[ -n $result ]]; then
        echo "$result" > temp_result.txt
        dialog --textbox temp_result.txt 20 60
        rm temp_result.txt
    else
        dialog --msgbox "No matching records found!" 10 30
    fi
}

# Function: Update Employee Details
update_employee() {
    emp_id=$(dialog --inputbox "Enter Employee ID to update:" 10 40 3>&1 1>&2 2>&3)
    record=$(grep "^$emp_id|" $EMP_FILE)

    if [[ -n $record ]]; then
        name=$(dialog --inputbox "Enter New Name:" 10 40 "$(echo $record | cut -d'|' -f2)" 3>&1 1>&2 2>&3)
        dept=$(dialog --inputbox "Enter New Department:" 10 40 "$(echo $record | cut -d'|' -f3)" 3>&1 1>&2 2>&3)
        salary=$(dialog --inputbox "Enter New Salary:" 10 40 "$(echo $record | cut -d'|' -f4)" 3>&1 1>&2 2>&3)

        # Update the record
        sed -i "/^$emp_id|/d" $EMP_FILE
        echo "$emp_id|$name|$dept|$salary" >> $EMP_FILE
        dialog --msgbox "Employee details updated successfully!" 10 30
    else
 dialog --msgbox "Employee ID not found!" 10 30
    fi
}

# Function: Delete Employee
delete_employee() {
    emp_id=$(dialog --inputbox "Enter Employee ID to delete:" 10 40 3>&1 1>&2 2>&3)
    record=$(grep "^$emp_id|" $EMP_FILE)

    if [[ -n $record ]]; then
        sed -i "/^$emp_id|/d" $EMP_FILE
        dialog --msgbox "Employee deleted successfully!" 10 30
    else
        dialog --msgbox "Employee ID not found!" 10 30
    fi
}

# Function: Generate Reports
generate_reports() {
    pr -t -n -d -o 5 $EMP_FILE > emp_report.txt
    dialog --textbox emp_report.txt 20 60
}

# Start the script
main_menu
