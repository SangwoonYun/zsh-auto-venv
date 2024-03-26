# autoload is used to load the add-zsh-hook function.
autoload -U add-zsh-hook

# Function to search for .venv directories from the current directory upwards.
find_venv() {
    local dir=$1
    while [[ "$dir" != "" && ! -e "$dir/.venv" ]]; do
        dir=${dir%/*}
    done
    echo $dir
}

# Function to activate or deactivate virtual environments.
activate_venv() {
    local venv_path=$(find_venv $PWD)
    if [[ -n "$venv_path" ]]; then
        # Activates the virtual environment if found.
        source "$venv_path/.venv/bin/activate"
    elif [[ -n "$VIRTUAL_ENV" ]]; then
        # Deactivates the virtual environment if exited from project directory.
        deactivate
    fi
}

# Sets up the function to be called whenever the current directory changes.
add-zsh-hook chpwd activate_venv

