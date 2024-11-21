function new-c-project
    # Check if the user provided a project name
    if test (math (count $argv)) -lt 1
        echo "Usage: new-c-project <project_name>"
        return 1
    end

    # Get the project name from the arguments
    set project_name $argv[1]

    # Check if the project directory already exists
    if test -d ~/Dev/Projects/C/$project_name
        echo "Error: Directory '$project_name' already exists."
        return 1
    end

    # Create the project directory and necessary subdirectories
    mkdir -p ~/Dev/Projects/C/$project_name/src
    mkdir -p ~/Dev/Projects/C/$project_name/include
    mkdir -p ~/Dev/Projects/C/$project_name/build

    # Change to the project directory
    cd ~/Dev/Projects/C/$project_name

    # Create a README.md file
    echo "# C Project" > README.md

    # Create .gitignore file
    echo "build/" >  .gitignore
    echo "*.o"    >> .gitignore
    echo "*.out"  >> .gitignore
    echo "*.exe"  >> .gitignore
    
    create-c-makefile "$project_name"
    
    # Create main.c
    echo -e "#include <stdio.h>\n"  >  src/main.c
    echo "int main() {"             >> src/main.c 
    echo -e "\tprintf(\"Hello, World!\\\\n\");" >> src/main.c
    echo -e "\treturn 0;\n}"  >> src/main.c

    # Print a success message
    echo "C project '$project_name' has been created and Makefile is set up."
end

function list-c-project
    # Set directory to ~/Dev/Projects/C/
    set directory ~/Dev/Projects/C

    # List all subdirectories under the given directory
    set projects (find $directory -mindepth 1 -maxdepth 1 -type d)

    if test (count $projects) -eq 0
        echo "No projects found in '$directory'."
    else
        echo "Listing all C projects in '$directory':"
        
        # Initialize a counter for the numbered list
        set i 1
        
        # Loop through each project and print the numbered project name
        for project in $projects
            set project_name (basename $project)
            echo "$i. $project_name"
            set i (math $i + 1)  # Increment the counter
        end
    end
end

function c-project
    # Set directory to ~/Dev/Projects/Python/
    set directory ~/Dev/Projects/Python

    # List all subdirectories (projects) under the given directory
    set projects (find $directory -mindepth 1 -maxdepth 1 -type d)

    # Check if there are no projects in the directory

    if test (count $projects) -eq 0 -a (count $argv) -eq 0
        echo "No projects found in '$directory'."
        return 1
    end

    # If no argument is given, show a helpful message
    if test (count $argv) -eq 0
        echo "Usage: c-project <project_number_or_name>"      
        list-c-project
        return 1
    end

    # Case 1: If the argument is a number
    if test (string match -r '^\d+$' $argv[1])
        set project_number $argv[1]  # No need to subtract 1, Fish arrays are 1-based
        if test $project_number -ge 1 -a $project_number -le (count $projects)
            set project_name (basename $projects[$project_number])
            echo "Opening project: $project_name"
            # Open the project (replace `cd` with your desired command, e.g., `nvim .`)
            cd $projects[$project_number]
            check-c-project
        else
            echo "Project number '$argv[1]' not found"
            echo "Do you want to create a new project instead? (y,N)"
            read create_project
            if test "$create_project" = "y"
                echo "Project name↴"
                read project_name
                new-c-project "$project_name"
            end

            return 1
        end
    # Case 2: If the argument is a project name
    else
        set project_name $argv[1]
        set project_path "$directory/$project_name"
        if test -d $project_path
            echo "Opening project: $project_name"
            # Open the project (replace `cd` with your desired command, e.g., `nvim .`)
            cd $project_path
            check-c-project
        else
            echo "Project '$project_name' not found."
            echo "Do you want to create a new project instead? (y,N)" 
            read create_project
            if test "$create_project" = "y"
                echo "Use $project_name as Project name? (Y,n)"
                read use_default_name
                if test "$use_default_name" = "n"
                    echo "Project name↴"
                    read new_project_name
                    new-c-project "$new_project_name"
                else
                    new-c-project "$project_name"
                end
            end
            return 1
        end
    end
end

function check-c-project
    # Get the current directory (project)
    set directory .

    # Check if the directory contains .venv and requirements.txt
    set has_makefile (test -d $directory/Makefile; echo $status)

    # Display results
    echo "Checking project"

    if test $has_makefile -eq 1
        echo "  This project has Makefile."
    else
        echo "  This project has no Makefile"
        echo "  To make a virtual envronment, run: make-c-makefile"

    end
end

function create-c-makefile
    set project_name $argv[1]
    # Create the Makefile
    echo "CC = gcc"           >  Makefile
    echo "CFLAGS = -Wall -g"  >> Makefile
    echo "SRCDIR = src"       >> Makefile
    echo "OBJDIR = build"     >> Makefile
    echo "SOURCES = \$(wildcard \$(SRCDIR)/*.c)"                >> Makefile
    echo "OBJECTS = \$(SOURCES:\$(SRCDIR)/%.c=\$(OBJDIR)/%.o)"  >> Makefile
    echo "EXEC = $project_name.out"     >> Makefile
    echo "all: \$(EXEC)"            >> Makefile
    echo "" >> Makefile
    echo -e "\$(EXEC): \$(OBJECTS)\n\t\t\$(CC) \$(OBJECTS) -o \$(EXEC)" >> Makefile
    echo "" >> Makefile
    echo -e "\$(OBJDIR)/%.o: \$(SRCDIR)/%.c\n\t\t\$(CC) \$(CFLAGS) -Iinclude -c \$< -o \$@" >> Makefile
    echo "" >> Makefile
    echo -e "clean:\n\t\trm -rf \$(OBJDIR)/*.o \$(EXEC)" >> Makefile
    echo ".PHONY: all clean"        >> Makefile
end
