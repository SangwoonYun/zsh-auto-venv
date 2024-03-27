# auto-venv Bash Script

This is a Bash plugin that automatically activates a Python virtual environment when entering a directory that contains a `.venv` folder and deactivates it when leaving the directory.

## Installation

1. Clone the repository into the .plugins folder:

   ```
   git clone https://github.com/SangwoonYun/zsh-auto-venv ${HOME}/.plugins/auto-venv
   ```

2. Add `source auto-venv` to the bottom of script in your `.bashrc`:

   ```bash
   ...
   source ${HOME}/.plugins/auto-venv/bash/auto-venv.sh
   ```

3. Source your `.bashrc` or restart your terminal session:

   ```bash
   source ~/.bashrc
   ```

## Usage

The plugin will automatically activate and deactivate `.venv` when you move into and out of directories containing a `.venv` folder. There is no need for manual activation.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/SangwoonYun/zsh-auto-venv/blob/main/LICENSE) file for details.

