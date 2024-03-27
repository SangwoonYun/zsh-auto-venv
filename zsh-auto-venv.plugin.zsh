# Plugin update check function
auto_venv_update_check() {
    local update_file="$ZSH_CUSTOM/plugins/zsh-auto-venv/.last_update_check"
    local current_time=$(date +%s)
    local last_update_check

    if [[ -f "$update_file" ]]; then
        last_update_check=$(cat "$update_file")
    else
        last_update_check=0
    fi

    # Check for updates every 24 hours (86400 seconds)
    if (( current_time - last_update_check < 86400 )); then
        # Last check was less than 24 hours ago, skip update check
        return
    fi

    # Record the time of this update check
    echo $current_time > "$update_file"

    # Proceed with the rest of the update check process...
    local remote_tag local_tag repo_path user_input
    repo_path="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-auto-venv"
    
    # Skip update check if git is not installed
    if ! command -v git &> /dev/null; then return; fi
    
    # Skip if fails to fetch the latest tags from the remote
    git -C "$repo_path" fetch --tags 2> /dev/null || return
    
    # Continue only if both tags are retrieved successfully
    remote_tag=$(git -C "$repo_path" describe --tags `git -C "$repo_path" rev-list --tags --max-count=1` 2> /dev/null)
    local_tag=$(git -C "$repo_path" describe --tags 2> /dev/null)
    if [ -z "$remote_tag" ] || [ -z "$local_tag" ]; then return; fi
    
    # Notify user of new version and ask for update permission
    if [ "$remote_tag" != "$local_tag" ]; then
        echo "New version available for zsh-auto-venv: $remote_tag (current version: $local_tag)"
        echo -n "Do you want to update the plugin now? [Y/n] "
        read user_input

        if [[ "$user_input" = "Y" || "$user_input" = "y" || "$user_input" = "" ]]; then
            echo "Updating zsh-auto-venv plugin from $local_tag to $remote_tag..."
            git -C "$repo_path" checkout "$remote_tag" 2> /dev/null || {
                echo "Failed to update zsh-auto-venv plugin."
                return
            }
        else
            echo "Update aborted. You can manually update later by running:"
            echo "git -C $repo_path checkout $remote_tag"
        fi
    else
        echo "zsh-auto-venv plugin is up to date."
    fi
}

# Call the update check function when the plugin loads
auto_venv_update_check

find_venv() {
    local dir=$1
    local found_venvs=()  # Array to hold found virtual environments

    # Search for 'bin/activate' in current and all parent directories
    while [[ "$dir" != "" ]]; do
        # Look for 'bin/activate' in all subdirectories of the current directory
        found_venvs=($(find "$dir" -maxdepth 3 -type f -name "activate" -path "*/bin/activate" 2>/dev/null))
        if [[ "${#found_venvs[@]}" -gt 0 ]]; then
            echo $found_venvs  # Return the first found virtual environment path
            return
        fi
        dir=${dir%/*}  # Move up to the parent directory
    done
}

# Function to activate or deactivate virtual environments.
activate_venv() {
    local venv_path=$(find_venv $PWD)
    if [[ -n "$venv_path" ]]; then
        if [[ "$VIRTUAL_ENV" && "$VIRTUAL_ENV" != "$venv_path" ]]; then
            deactivate
        fi
        # Activates the virtual environment if found.
        source "$venv_path"
    elif [[ -n "$VIRTUAL_ENV" ]]; then
        # Deactivates the virtual environment if exited from project directory.
        deactivate
    fi
}

# autoload is used to load the add-zsh-hook function.
autoload -U add-zsh-hook

# Sets up the function to be called whenever the current directory changes.
add-zsh-hook chpwd activate_venv

