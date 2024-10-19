# My Neovim Configuration

This is my personal Neovim configuration, started from the [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) template.

## To get started

1. Make sure you have the following installed:

   - [Neovim](https://github.com/neovim/neovim/releases)
   - [Git](https://git-scm.com/downloads)
   - [NodeJS](https://nodejs.org/en/download/)

2. Clone this repository

```bash
git clone https://github.com/jacobsamo/nvim-setup
```

### 3. Setting up the language servers

Install the following language servers globally: - [vscode-langservers-extracted](https://github.com/vscode-langservers/vscode-langservers-extracted) for css, html, json and eslint language servers - [typescipt](https://github.com/typescript-language-server/typescript-language-server) - [tailwindcss](https://github.com/tailwindlabs/tailwindcss-intellisense) - [angular]() for those using angular (optional)

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

4. Run `nvim` to start Neovim
