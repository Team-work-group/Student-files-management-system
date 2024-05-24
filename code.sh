#!/bin/bash

# Function to prompt for password
prompt_password() {
    read -s password
    echo "$password"
}

# Function to check if the entered password is correct
check_password() {
    stored_password=$(cat password.txt)
    if [ "$stored_password" = "$1" ]; then
        return 0  # Password is correct
    else
        return 1  # Password is incorrect
    fi
}

# Function to set a new password
set_password() {
    echo "Enter new password: "
    read -s new_password
    echo "$new_password" > password.txt
    echo "Password set successfully."
}

# Check if password file exists, if not, prompt the user to create a new password
if [ ! -f password.txt ]; then
    echo "No password set. Please create a new password."
    set_password
fi

# Function to display menu
display_menu() {
    echo "Student File Management System"
    echo "1. Add Student"
    echo "2. Delete Student"
    echo "3. Search Student"
    echo "4. Display All Students"
    echo "5. Calculate Average GPA"
    echo "6. Modify Student"
    echo "7. set password"
    echo "8. Exit"
}

# Function to add a student
add_student() {
    echo "Enter student name: "
    read -r name
    echo "Enter student ID: "
    read -r id
    echo "Enter student GPA: "
    read -r gpa

        # Check if GPA is a valid number
    if ! [[ "$gpa" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        echo "Invalid GPA format. Please enter a valid number."
        return
    fi
    
    if grep -qw "$id" students.txt; then
        echo "Student with ID $id already exists."
        return
    else
        echo "$name $id $gpa" >> students.txt
        echo "Student added successfully."
    fi
}

# Function to delete a student
delete_student() {
    echo "Enter student ID to delete: "
    read -r id
    if grep -qw "$id" students.txt; then
        sed -i "/ $id /d" students.txt
        echo "Student deleted successfully."
    else
        echo "Student not found."
    fi
}

# Function to search for a student
search_student() {
    echo "Enter student ID to search: "
    read -r id
    result=$(grep -w "$id" students.txt)
    if [ -z "$result" ]; then
        echo "Student not found."
    else
        echo "$result"
    fi
}

