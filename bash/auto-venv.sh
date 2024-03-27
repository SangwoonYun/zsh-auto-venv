#!/bin/bash

find_venv() {
    local dir=$1
    local found_venvs=()  # Array to hold found virtual environments

    # Search for 'bin/activate' in current and all parent directories
    while [[ "$dir" != "" ]]; do
        # Look for 'bin/activate' in all subdirectories of the current directory
        while IFS= read -r line; do
            found_venvs+=("$line")
        done < <(find "$dir" -maxdepth 3 -type f -name "activate" -path "*/bin/activate" 2>/dev/null)

        if [[ "${#found_venvs[@]}" -gt 0 ]]; then
            printf "%s\n" "${found_venvs[0]}"  # Return the first found virtual environment path
            return
        fi
        dir=${dir%/*}  # Move up to the parent directory
    done
}

# Function to activate or deactivate virtual environments.
activate_venv() {
    local venv_path
    if ! venv_path=$(find_venv "$PWD"); then
        printf "Error finding virtual environment.\n" >&2
        return 1
    fi

    if [[ -n "$venv_path" ]]; then
        if [[ -n "$VIRTUAL_ENV" && "$VIRTUAL_ENV" != "$venv_path" ]]; then
            deactivate
        fi
        # Activates the virtual environment if found.
        source "$venv_path"
    elif [[ -n "$VIRTUAL_ENV" ]]; then
        # Deactivates the virtual environment if exited from project directory.
        deactivate
    fi
}

# Check the virtual environment whenever the command prompt is displayed.
PROMPT_COMMAND="activate_venv; $PROMPT_COMMAND"

