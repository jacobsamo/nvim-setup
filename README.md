# My 💤 LazyVim Neovim Configuration

This is my personal Neovim configuration, using the starter template for [LazyVim](https://github.com/LazyVim/LazyVim), Refer to the [documentation](https://lazyvim.github.io/installation) to get started and configure to your liking.

I have configured the setup to work with the following lanauges:

- JavaScript/TypeScript
- HTML/CSS
- Python
- C#
- Lua
- Dart / Flutter

To get them working please follow the instructions below.

## To get started

1. Make sure you have the following installed:

   - [Neovim](https://github.com/neovim/neovim/releases)
   - [Git](https://git-scm.com/downloads)
   - [NodeJS](https://nodejs.org/en/download/)
   - [C#](https://dotnet.microsoft.com/en-us/download) (optional, only if you want to use C#)

2. Clone this repository

```bash
git clone https://github.com/jacobsamo/nvim-setup
```

### 3. Setting up the language servers

The following language servers will need to be installed globally:

- [vscode-langservers-extracted](https://github.com/vscode-langservers/vscode-langservers-extracted) for css, html, json and eslint language servers
- [typescipt](https://github.com/typescript-language-server/typescript-language-server)
- [tailwindcss](https://github.com/tailwindlabs/tailwindcss-intellisense)
- [angular]() for those using angular (optional)

required:

```bash
npm install -g vscode-langservers-extracted
npm install -g typescript-language-server
npm install -g @tailwindcss/language-server
```

optional (if your not using any of this make sure to uncomment them in the `lspconfig.lua` file):

```bash
npm install -g @angular/language-server
```

**C# setup**

- make sure you have the [dotnet-sdk](https://dotnet.microsoft.com/en-us/download) installed
- make sure you install the csharp-ls tool globally

```bash
dotnet tool install --global csharp-ls
```

**LazyGit**
following the install guide from https://github.com/jesseduffield/lazygit?tab=readme-ov-file#installation

- windows: `choco install lazygit`
- mac: `brew install lazygit`
- linux: `sudo apt install lazygit`

4. Run `nvim` to start Neovim
