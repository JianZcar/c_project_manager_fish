# C Project Management Script

## Overview

This script provides a set of functions to manage C projects easily. It allows users to create new C projects, list existing projects, open specific projects, and check the status of a project. The script is designed to work with a specific directory structure and includes functionality for creating a Makefile, a README file, and a basic `main.c` file.

## Features

- **Create a New C Project**: The `new-c-project` function creates a new C project with a specified name, including necessary directories and files.
- **List Existing Projects**: The `list-c-project` function lists all existing C projects in the specified directory.
- **Open a C Project**: The `c-project` function allows users to open a project by its number or name, and provides an option to create a new project if the specified one does not exist.
- **Check Project Status**: The `check-c-project` function checks if the current project contains a Makefile and provides relevant information.
- **Create a Makefile**: The `create-c-makefile` function generates a Makefile for the project, setting up compilation rules.

## Directory Structure

The script assumes a specific directory structure for C projects:

```
~/Dev/Projects/C/
```

Each project will have the following subdirectories:

- `src/`: Contains source files.
- `include/`: Contains header files.
- `build/`: Contains compiled object files and executables.

## Usage

### Creating a New C Project

To create a new C project, use the following command:

```bash
new-c-project <project_name>
```

### Listing Existing Projects

To list all existing C projects, use:

```bash
list-c-project
```

### Opening a C Project

To open a specific C project, use:

```bash
c-project <project_number_or_name>
```

If the project does not exist, you will be prompted to create a new one.

### Checking Project Status

To check the status of the current project, simply run:

```bash
check-c-project
```

### Creating a Makefile

The Makefile is automatically created when a new project is initialized using the `new-c-project` function.

## Example

1. Create a new project named `MyCProject`:

   ```bash
   new-c-project MyCProject
   ```

2. List all projects:

   ```bash
   list-c-project
   ```

3. Open the project by name:

   ```bash
   c-project MyCProject
   ```

4. Check the project status:

   ```bash
   check-c-project
   ```

## Requirements

- The script is written in Fish shell scripting language.
- Ensure that the `gcc` compiler is installed on your system for compiling C programs.


## Notes

- The script assumes that your projects are stored in the `~/Dev/Projects/C/` directory. You can modify the script to change this path if needed.
- The script provides prompts for user input when necessary, making it user-friendly.
- Ensure that you have the necessary permissions to create directories and files in the specified project directory.

## License

This script is provided as-is. Feel free to modify and use it according to your needs.
