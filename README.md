# zsh-auto-venv Zsh Plugin

This is a Zsh plugin that automatically activates a Python virtual environment when entering a directory that contains a `.venv` folder and deactivates it when leaving the directory.

## Installation

### Oh My Zsh

1. Clone the repository into the Oh My Zsh custom plugins folder:

   ```
   git clone https://github.com/SangwoonYun/zsh-auto-venv ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-auto-venv
   ```

2. Add `zsh-auto-venv` to the list of plugins in your `.zshrc`:

   ```zsh
   plugins=(... zsh-auto-venv)
   ```

3. Source your `.zshrc` or restart your terminal session:

   ```zsh
   source ~/.zshrc
   ```

## Usage

The plugin will automatically activate and deactivate `.venv` when you move into and out of directories containing a `.venv` folder. There is no need for manual activation.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/SangwoonYun/zsh-auto-venv/blob/main/LICENSE) file for details.
