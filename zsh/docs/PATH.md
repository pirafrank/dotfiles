# Zsh PATH modification

The primary source of truth for PATH configuration is [zsh/common/zsh_env](../common/zsh_env), which runs for all shell types.

## Base PATH (all shells)

Set in [zsh/common/zsh_env](../common/zsh_env):

1. `~/bin2` - Highest priority user binaries
2. `~/.local/bin` - Local user binaries
3. `~/dotfiles/bin` - Dotfiles utility scripts
4. `/opt/local/{bin,sbin}` - Optional local packages
5. `/usr/local/{bin,sbin}` - System-wide local packages
6. `/usr/{bin,sbin}` - System binaries
7. Existing `$path` - Preserved existing paths

## Conditional Additions (all shells)

Source: [zsh/common/zsh_env](../common/zsh_env). Each tool is added if its expected directory exists.

| Tool | PATH Addition | Condition |
|------|--------------|-----------|
| Pyenv | `$PYENV_ROOT/bin` + pyenv init | `~/.pyenv` exists |
| jenv | `~/.jenv/bin` + jenv init | `~/.jenv` exists |
| Maven | `~/bin2/maven/bin` | Always |
| Golang (goenv) | `$GOENV_ROOT/bin`, `$GOROOT/bin`, `$GOPATH/bin` | goenv exists |
| Golang (system) | `/usr/local/go/bin`, `$GOPATH/bin` | system go exists |
| Golang (custom) | `~/bin2/go/bin`, `$GOPATH/bin` | custom go exists |
| Swift | `/opt/swift/usr/bin` | Linux + `/opt/swift` exists |
| NVM | PATH modified by nvm.sh | `~/.nvm` exists |
| Cargo/Rust | `~/.cargo/bin` | `~/.cargo/bin` exists |
| Krew | `$KREW_ROOT/bin` (default: `~/.krew/bin`) | krew dir exists |
| Wasmer | PATH modified by wasmer.sh | wasmer installed |
| Wasmtime | `$WASMTIME_HOME/bin` | `~/.wasmtime` exists |
| Deno | `$DENO_INSTALL/bin` | `~/.deno` exists |
| Serverless | `~/.serverless/bin` | serverless bin exists |
| PNPM | `$PNPM_HOME` | `~/.local/share/pnpm` exists |
| Bun | `$BUN_INSTALL/bin` | `~/.bun` exists |
| TFEnv | `~/.tfenv/bin` | Always |
| RVM (user) | PATH modified by rvm script + `~/.rvm/bin` | `~/.rvm` exists |
| RVM (system) | PATH modified by system rvm script | `/usr/local/rvm` exists |
| poof | `$POOF_ROOT/bin` | Always |

## Interactive-Only Additions

Source: [zsh/common/zsh_env_interactive](../common/zsh_env_interactive)

| Tool | PATH Addition | Condition |
|------|--------------|-----------|
| FZF | PATH modified by fzf.zsh | `~/.fzf.zsh` exists |
| FZF API | Sourced | fzf_api.sh exists |
| Zoxide | Init hook | zoxide installed |
| Fasd | Init hook (legacy) | fasd installed |
| Direnv | Init hook | direnv installed |
| OpenCode | `~/.opencode/bin` | `~/.opencode/bin` exists |
| Serverless | `~/.serverless/bin` (duplicate) | serverless bin exists |

## Fpath Modifications (completion paths)

Source: [zsh/zprezto/runcoms/zshrc](../zprezto/runcoms/zshrc)

| Path | Condition |
|------|-----------|
| `~/.zsh_user_themes` | `CUSTOM_THEMES_ENABLED=1` |
| `~/dotfiles/zsh/completions` | Directory exists |
| `~/dotfiles/zsh/autoloaded` | Always |

## PATH Environment Variable Modifications Diagram

The PATH variable is built up through multiple configuration files, with earlier additions taking priority. The diagram shows the order and conditional logic:

```mermaid
flowchart TD
    Start([Shell Starts]) --> BaseInit[Initialize Base PATH Array<br/>zsh_env lines 33-42]

    BaseInit --> BasePaths["Priority paths:<br/>1. ~/bin2<br/>2. ~/.local/bin<br/>3. ~/dotfiles/bin<br/>4. /opt/local/bin,sbin<br/>5. /usr/local/bin,sbin<br/>6. /usr/bin,sbin<br/>7. existing $path"]

    BasePaths --> Pyenv{pyenv exists?<br/>~/.pyenv}

    %% Pyenv
    Pyenv -->|Yes| PyenvAdd[Add $PYENV_ROOT/bin<br/>Run: pyenv init --path<br/>zsh_env line 90-92]
    Pyenv -->|No| Jenv
    PyenvAdd --> Jenv

    %% Jenv
    Jenv{jenv exists?<br/>~/.jenv} -->|Yes| JenvAdd[Add ~/.jenv/bin<br/>Run: jenv init -<br/>zsh_env line 100-101]
    Jenv -->|No| Maven
    JenvAdd --> Maven

    %% Maven
    Maven[Add ~/bin2/maven/bin<br/>zsh_env line 105] --> Golang

    %% Golang
    Golang{Golang?} -->|goenv exists| GoenvPath[Add $GOENV_ROOT/bin<br/>Run: goenv init -<br/>Add $GOROOT/bin<br/>Add $GOPATH/bin<br/>zsh_env lines 111-115]
    Golang -->|system go exists| SystemGoPath[Add /usr/local/go/bin<br/>Add $GOPATH/bin<br/>zsh_env lines 118-120]
    Golang -->|custom go| CustomGoPath[Add ~/bin2/go/bin<br/>Add $GOPATH/bin<br/>zsh_env lines 123-125]
    GoenvPath --> Swift
    SystemGoPath --> Swift
    CustomGoPath --> Swift

    %% Swift
    Swift{Swift exists?<br/>Linux + /opt/swift} -->|Yes| SwiftAdd[Add /opt/swift/usr/bin<br/>zsh_env line 131]
    Swift -->|No| NVM
    SwiftAdd --> NVM

    %% NVM
    NVM{NVM exists?<br/>~/.nvm} -->|Yes| NVMAdd[Source nvm.sh<br/>modifies PATH<br/>zsh_env line 137]
    NVM -->|No| Cargo
    NVMAdd --> Cargo

    %% Cargo/Rust
    Cargo{Cargo exists?<br/>~/.cargo} -->|Yes| CargoAdd[Add ~/.cargo/bin<br/>zsh_env line 143]
    Cargo -->|No| Krew
    CargoAdd --> Krew

    %% Krew
    Krew{Krew exists?} -->|Yes| KrewAdd[Add $KREW_ROOT/bin<br/>zsh_env line 148]
    Krew -->|No| Wasmer
    KrewAdd --> Wasmer

    %% Wasmer
    Wasmer{Wasmer exists?} -->|Yes| WasmerAdd[Source wasmer.sh<br/>zsh_env line 155]
    Wasmer -->|No| Wasmtime
    WasmerAdd --> Wasmtime

    %% Wasmtime
    Wasmtime{Wasmtime exists?<br/>~/.wasmtime} -->|Yes| WasmtimeAdd[Add $WASMTIME_HOME/bin<br/>zsh_env line 160]
    Wasmtime -->|No| Deno
    WasmtimeAdd --> Deno

    %% Deno
    Deno{Deno exists?<br/>~/.deno} -->|Yes| DenoAdd[Add $DENO_INSTALL/bin<br/>zsh_env line 168]
    Deno -->|No| Serverless
    DenoAdd --> Serverless

    %% Serverless
    Serverless{Serverless exists?} -->|Yes| ServerlessAdd[Add ~/.serverless/bin<br/>zsh_env line 173]
    Serverless -->|No| PNPM
    ServerlessAdd --> PNPM

    %% PNPM
    PNPM{PNPM exists?} -->|Yes| PNPMAdd[Add $PNPM_HOME<br/>zsh_env line 178]
    PNPM -->|No| Bun
    PNPMAdd --> Bun

    %% Bun
    Bun{Bun exists?<br/>~/.bun} -->|Yes| BunAdd[Add $BUN_INSTALL/bin<br/>zsh_env line 185]
    Bun -->|No| TFEnv
    BunAdd --> TFEnv

    %% TFEnv
    TFEnv[Add ~/.tfenv/bin<br/>zsh_env line 189] --> RVM

    %% RVM
    RVM{RVM exists?} -->|~/.rvm| UserRVM[Source ~/.rvm/scripts/rvm<br/>Add ~/.rvm/bin<br/>zsh_env lines 196-197]
    RVM -->|system /usr/local/rvm| SystemRVM[Source system rvm script<br/>zsh_env line 200]
    RVM -->|No| Poof
    UserRVM --> Poof
    SystemRVM --> Poof

    %% Poof
    Poof[Add $POOF_ROOT/bin<br/>zsh_env line 210] --> ShellCheck

    %% Check if interactive
    ShellCheck{Interactive<br/>Shell?} -->|No| NonIntEnd([Non-Interactive:<br/>PATH Complete])
    ShellCheck -->|Yes| FZF

    %% Interactive-only additions from zsh_env_interactive
    %% FZF
    FZF{FZF exists?} -->|Yes| FZFAdd[Source ~/.fzf.zsh<br/>may modify PATH<br/>zsh_env_interactive line 16]
    FZF -->|No| FZFApi
    FZFAdd --> FZFApi

    %% FZF API
    FZFApi[Source fzf_api.sh<br/>zsh_env_interactive line 35] --> Zoxide

    %% Zoxide
    Zoxide{zoxide installed?} -->|Yes| ZoxideAdd[Run: zoxide init zsh<br/>zsh_env_interactive line 102]
    Zoxide -->|No| Fasd
    ZoxideAdd --> Fasd

    %% Fasd
    Fasd{fasd installed?} -->|Yes| FasdAdd[Run: fasd --init auto<br/>zsh_env_interactive line 105]
    Fasd -->|No| Direnv
    FasdAdd --> Direnv

    %% Direnv
    Direnv{direnv installed?} -->|Yes| DirenvAdd[Run: direnv hook zsh<br/>zsh_env_interactive line 110]
    Direnv -->|No| OpenCode
    DirenvAdd --> OpenCode

    %% OpenCode
    OpenCode{opencode exists?} -->|Yes| OpenCodeAdd[Add ~/.opencode/bin<br/>zsh_env_interactive line 123]
    OpenCode -->|No| IntServerless
    OpenCodeAdd --> IntServerless

    %% Serverless duplicate
    IntServerless{serverless exists?} -->|Yes| IntServerlessAdd[Add ~/.serverless/bin<br/>duplicate check<br/>zsh_env_interactive line 128]
    IntServerless -->|No| FpathMods
    IntServerlessAdd --> FpathMods

    %% Fpath modifications
    FpathMods[Fpath modifications:<br/>1. ~/.zsh_user_themes<br/>2. ~/dotfiles/zsh/completions<br/>3. ~/dotfiles/zsh/autoloaded<br/>zshrc lines 62, 91, 102] --> IntEnd

    IntEnd([Interactive:<br/>PATH Complete])

    style BasePaths fill:#e3f2fd
    style NonIntEnd fill:#e1f5e1
    style IntEnd fill:#e1f5e1
    style PyenvAdd fill:#fff4e6
    style IntPyenvAdd fill:#fff4e6
