# 🛠️ Dotfiles Installer

This repository contains a script 📜 to install dotfiles from a given GitHub URL. It also includes a GitHub Actions workflow 💫 that tests the script and creates an issue when the workflow fails.

## 📥 Installation

To install the script, on file, you can run:

```bash
curl -s https://raw.githubusercontent.com/PunGrumpy/dotfiles-installer/main/install.sh -o install.sh
```

To install the script, without cloning the repository, you can run:

```bash
curl -s https://raw.githubusercontent.com/PunGrumpy/dotfiles-installer/main/install.sh | bash h
```

## 📖 Usage

To run the installation script:

```bash
./install.sh -u <URL>
```

The `<URL>` should be replaced with the URL of the GitHub repository containing the dotfiles. If no URL is provided, the script will use a default URL.

You can also use the `-s` 🤫 flag to run the script in silent mode:

```bash
./install.sh -s -u <URL>
```

The `-i` 🧰 flag can be used to install Neovim and Packer before installing the dotfiles:

```bash
./install.sh -i -u <URL>
```

These flags can be combined as needed. For example, to run the script in silent mode and install Neovim and Packer, you can run:

```bash
./install.sh -s -i -u <URL>
```

## 📃 License

This repository is licensed under the [MIT License](LICENSE) 📝.
