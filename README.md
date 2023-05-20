# 🛠️ Dotfiles Installer

This repository contains a script 📜 to install dotfiles from a given GitHub URL. It also includes a GitHub Actions workflow 💫 that tests the script on different environments and creates an issue when the workflow fails.

**📌 Highly Recommended:** Use the [Dotfiles](https://github.com/PunGrumpy/dotfiles) repository as a template for your dotfiles (on default).

## 💻 Available on

- Linux 🐧
- macOS 🍎
- ~~Windows 🪟~~

## 📜 About

Here's what install.sh will do:

1. Clone the dotfiles repository to a temporary directory.
2. Copy the dotfiles to your home directory.
3. Update all packages (for Debian-based distributions).
4. Install optional build tools for Debian-based distributions.
5. Install Homebrew and some optional tools for it.
6. Set Fish as the default shell.
7. Install optional tools for the Fish shell.
8. Install commitizen for standardizing commit messages.
9. You will be prompted for confirmation before each step (unless you run the script with `-y` or `--yes`).

## 📥 Installation

To install the script, on file, you can run:

```bash
curl -s https://raw.githubusercontent.com/PunGrumpy/dotfiles-installer/main/install.sh -o install.sh
```

To install the script, without cloning the repository, you can run:

```bash
curl -s https://raw.githubusercontent.com/PunGrumpy/dotfiles-installer/main/install.sh | bash -h
```

If you want to install you should edit `bash -h` and follow the instructions in the [Usage](#📖-usage) section.

## 📖 Usage

To run the installation script:

```bash
./install.sh
```

You can also use the `-y` 🤫 flag to run the script in silent mode:

```bash
./install.sh -y
```

You can also use the `-s` 🤫 flag to run the script in silent mode:

```bash
./install.sh -s
```

For example if you want to run the script in silent mode and without confirmation:

```bash
./install.sh -s -y
```

## 📃 License

This repository is licensed under the [MIT License](LICENSE) 📝.

```

```
