# Plugin update check function
auto_venv_update_check() {
    local remote_tag local_tag repo_path user_input
    repo_path="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-auto-venv"
    
    # Check if git is available, if not, skip update check
    if ! command -v git &> /dev/null; then
        # Skip the update check if git is not installed
        return
    fi

    # Fetch the latest tags from the remote, skip if fails
    git -C "$repo_path" fetch --tags 2> /dev/null || return
    
    # Get the latest tag name from the remote and local, continue only if both are retrieved
    remote_tag=$(git -C "$repo_path" describe --tags `git -C "$repo_path" rev-list --tags --max-count=1` 2> /dev/null)
    local_tag=$(git -C "$repo_path" describe --tags 2> /dev/null)
    if [ -z "$remote_tag" ] || [ -z "$local_tag" ]; then
        # Skip the update process if unable to retrieve tags
        return
    fi
    
    # Check if the latest tag matches the currently checked-out version
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

# Plugin update check function
auto_venv_update_check() {
    local remote_tag local_tag repo_path user_input
    repo_path="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/auto-venv"
    
    # Ensure git is available
    if ! command -v git &> /dev/null; then
        echo "Git is not installed. Cannot check for plugin updates."
        return
    fi

    # Fetch the latest tags from the remote
    git -C "$repo_path" fetch --tags
    
    # Get the latest tag name from the remote and local
    remote_tag=$(git -C "$repo_path" describe --tags `git -C "$repo_path" rev-list --tags --max-count=1`)
    local_tag=$(git -C "$repo_path" describe --tags)
    
    # Check if the latest tag matches the currently checked-out version
    if [ "$remote_tag" != "$local_tag" ]; then
        echo "New version available for auto-venv: $remote_tag (current version: $local_tag)"
        echo -n "Do you want to update the plugin now? [Y/n] "
        read user_input

        if [[ "$user_input" = "Y" || "$user_input" = "y" || "$user_input" = "" ]]; then
            echo "Updating auto-venv plugin from $local_tag to $remote_tag..."
            git -C "$repo_path" checkout "$remote_tag"
        else
            echo "Update aborted. You can manually update later by running:"
            echo "git -C $repo_path checkout $remote_tag"
        fi
    else
        echo "auto-venv plugin is up to date."
    fi
}

# Call the update check function when the plugin loads
auto_venv_update_check

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

