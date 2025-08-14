# My Neovim Configuration

I have configured the setup to work with the following lanauges:

- JavaScript/TypeScript
- Angular
- HTML/CSS
- Python
- C#
- Lua
- Dart / Flutter

## To get started

1. Make sure you have the following installed:
   - [Neovim](https://github.com/neovim/neovim/releases)
   - [Git](https://git-scm.com/downloads)
   - [NodeJS](https://nodejs.org/en/download/)
   - [C#](https://dotnet.microsoft.com/en-us/download) (optional, only if you want to use C#)

2. Clone this repository

```bash
# If you are using windows
git clone https://github.com/jacobsamo/nvim-setup $env:LOCALAPPDATA\nvim

# if you are using unix

git clone https://github.com/jacobsamo/nvim-setup ~/.config/nvim
```

### 3. Setting up the language servers

The following language servers will need to be installed globally:

- [vscode-langservers-extracted](https://github.com/vscode-langservers/vscode-langservers-extracted) for css, html, json and eslint language servers
- [typescipt](https://github.com/typescript-language-server/typescript-language-server)
- [tailwindcss](https://github.com/tailwindlabs/tailwindcss-intellisense)
- [angular](https://angular.dev/tools/language-service) for those using angular (optional)

required:

```bash
npm install -g vscode-langservers-extracted typescript-language-server @tailwindcss/language-server @angular/language-server
```

**C# setup**

- make sure you have the [dotnet-sdk](https://dotnet.microsoft.com/en-us/download) installed
- make sure you install the csharp-ls tool globally

```bash
dotnet tool install --global csharp-ls
```

**LazyGit**
following the install guide from https://github.com/jesseduffield/lazygit?tab=readme-ov-file#installation

- windows: `winget install --id=JesseDuffield.lazygit`
- mac: `brew install lazygit`
- linux: `sudo apt install lazygit`

4. Run `nvim` to start Neovim
