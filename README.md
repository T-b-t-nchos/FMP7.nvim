# FMP7.nvim
##### A Neovim plugin to control FMP7 (FMP7.exe) from Neovim.
<br>
<a href="https://neovim.io/">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/%20Neovim-%2357a143?style=flat&logo=Neovim&logoColor=%2357a143&label=Built%20for&labelColor=%23444444&link=https%3A%2F%2Fneovim.io%2F">
        <source media="(prefers-color-scheme: light)" srcset="https://img.shields.io/badge/%20Neovim-%2357a143?style=flat&logo=Neovim&logoColor=%2357a143&label=Built%20for&labelColor=%23ffffff&link=https%3A%2F%2Fneovim.io%2F">
        <img alt="Built for Neovim" src="https://img.shields.io/badge/%20Neovim-%2357a143?style=flat&logo=Neovim&logoColor=%2357a143&label=Built%20for&labelColor=%23444444&link=https%3A%2F%2Fneovim.io%2F">
    </picture>
<a href="https://neovim.io/doc/install/">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/%200.11+-%233791d4?style=flat&logo=Neovim&logoColor=%233791d4&label=Required&labelColor=%23444444&link=https%3A%2F%2Fneovim.io%2F">
        <source media="(prefers-color-scheme: light)" srcset="https://img.shields.io/badge/%200.11+-%233791d4?style=flat&logo=Neovim&logoColor=%233791d4&label=Required&labelColor=%23ffffff&link=https%3A%2F%2Fneovim.io%2F">
        <img alt="Required Neovim 0.11+" src="https://img.shields.io/badge/%200.11+-%233791d4?style=flat&logo=Neovim&logoColor=%233791d4&label=Required&labelColor=%23444444&link=https%3A%2F%2Fneovim.io%2F">
    </picture>
<br>
<a href="./LICENSE">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset="https://img.shields.io/badge/%20MIT%20License%20-%23004584?style=flat&label=License&labelColor=%23444444&link=https%3A%2F%2Fneovim.io%2F">
        <source media="(prefers-color-scheme: light)" srcset="https://img.shields.io/badge/%20MIT%20License%20-%23004584?style=flat&label=License&labelColor=%23ffffff&link=https%3A%2F%2Fneovim.io%2F">
        <img alt="License" src="https://img.shields.io/badge/%20MIT%20License%20-%23004584?style=flat&label=License&labelColor=%23444444&link=https%3A%2F%2Fneovim.io%2F">
    </picture>
</a>

<hr>

## ✨ 概要 - Overview -
<sub>FMP7.nvim is a plugin to control FMP7 (FMP7.exe) from Neovim.</sub><br>
FMP7.nvimは、NeovimからFMP7(FMP7.exe)を制御するためのプラグインです。<br>

<sub>It can be used to play, stop, pause, fade, etc. basic functions.</sub><br>
再生、停止、ポーズ、フェードなど、基本的な機能を利用することができます。<br>

> [!WARNING]
> <sub>This plugin is only for Windows.</sub><br>
> このプラグインはWindowsのみで利用できます。<br>

## 💼 依存関係 - Dependents -
- [Neovim](https://github.com/neovim/neovim) 0.11+
- [FMP7](http://archive.fmp.jp/archives/category/program) 
- [FMP7CLI (T-b-t-nchos/FMP7CLI)](https://github.com/T-b-t-nchos/FMP7CLI)

## 🔧 インストール - Install -
### In Neovim
#### lazy.nvim
```lua
return {
    "T-b-t-Nchos/FMP7.nvim",
    cmd = "FMP",
    opts = {
        FMP7_CLI_PATH = "C:/path/to/FMP7CLI.exe",
        fadeout_before_play = true
    },
}

```

### Other
- FMP7CLIを任意の場所に配置し、`FMP7_CLI_PATH`にパスを指定してください。

- Place FMP7CLI in any location and specify the path in FMP7_CLI_PATH.


## 🛠️ オプション - Options -
```lua
{
    FMP7_CLI_PATH = "C:/path/to/FMP7CLI.exe", -- (Required) Specify the path of the command-line tool.

    fmp7_path = "C:/path/to/FMP7.exe", -- Specify the path of the FMP7 software.
    fadeout_before_play = true, -- Whether to fade out before playing.
}
```

## 💡 使用ソフトウェア - Softwares -
<sub>This plugin uses the following software directly, or indirectly.</sub><br>
本プラグインは以下のソフトウェアを直接的、または間接的に使用しています。<br>

- [FMP7](http://archive.fmp.jp/archives/category/program) 
- [FMP7CLI (T-b-t-nchos/FMP7CLI)](https://github.com/T-b-t-nchos/FMP7CLI)
  - [FMP7 SDK for .NET](https://github.com/aosoft/FMP7ApiCLR) (zlib/libpng License)

<sub>I would like to thank the authors of the following software.</sub><br>
素晴らしいソフトウェアをありがとうございます。<br>
