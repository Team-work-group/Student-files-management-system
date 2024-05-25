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
        echo "$name , $id , $gpa" >> students.txt
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


# Function to display all students
display_students() {
    if [ -s students.txt ]; then
        cat students.txt
    else
        echo "No students found."
    fi
}

# Function to calculate average GPA
calculate_average_gpa() {
 awk '{total=total+$NF} END{print total/NR}' students.txt
}

# Function to modify a student's data
modify_student() {
    echo "Enter student ID to modify: "
    read id
    if grep -qw "$id" students.txt; then
        old_data=$(grep -w "$id" students.txt)
        old_name=$(echo "$old_data" | cut -d',' -f1)
        old_id=$(echo "$old_data" | cut -d',' -f2)
        old_gpa=$(echo "$old_data" | cut -d',' -f3)

        while true; do
            echo "What would you like to modify?"
            echo "1. Name"
            echo "2. ID"
            echo "3. GPA"
            echo "4. Out"
            read choice

            case $choice in
                1)
                    echo "Current name is $old_name. Enter new name: "
                    read new_name
                    new_name=${new_name:-$old_name}
                    old_name=$new_name
                    echo "Student name updated successfully."
                    ;;
                2)
                    echo "Current ID is $old_id. Enter new ID: "
                    read new_id
                    if [[ $(grep -w "$new_id" students.txt) ]]; then
                        echo "Student with new ID $new_id already exists. Cannot update to this ID."
                    else
                        old_id=$new_id
                        echo "Student ID updated successfully."
                    fi
                    ;;
                3)
                    echo "Current GPA is $old_gpa. Enter new GPA: "
                    read new_gpa
                    
                    # Check if GPA is a valid number
                    if ! [[ "$new_gpa" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
                    echo "Invalid GPA format. Please enter a valid number."
                    return
                    fi
                    
                    new_gpa=${new_gpa:-$old_gpa}
                    old_gpa=$new_gpa
                    echo "Student GPA updated successfully."
                    ;;
                4)
                    # Apply all changes
                    sed -i "/ $id /c\\$old_name $old_id $old_gpa" students.txt
                    echo "Outside modification menu. All changes saved."
                    break
                    ;;
                *)
                    echo "Invalid choice. Please try again."
                    ;;
            esac
        done
    else
        echo "Student not found."
    fi
}

echo "Enter password: "
    entered_password=$(prompt_password)

    # Check if entered password is correct
    if check_password "$entered_password" ]; then

# Main loop
while true; do

        display_menu
        echo "Enter your choice: "
        read -r choice

        case $choice in
            1) add_student;;
            2) delete_student;;
            3) search_student;;
            4) display_students;;
            5) calculate_average_gpa;;
            6) modify_student;;
            7) set_password;;
            8) echo "Exiting..."; break;;
            *) echo "Invalid choice. Please try again.";;
        esac
done

    else
        echo "Incorrect password. Please try again."
    fi

