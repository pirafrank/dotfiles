# zellij

## Repo

- <https://github.com/zellij-org/zellij>

## Docs

- <https://zellij.dev/documentation>

## Config

- <https://zellij.dev/documentation/configuration.html>
- <https://github.com/zellij-org/zellij/tree/main/example>

## Keybindings

Check the [KEYBINDINGS](./KEYBINDINGS.md) file.

## How to setup

Symlink config

```sh
ln -s ~/dotfiles/zellij/config.kdl ~/.config/zellij/config.kdl
```

or set env var `ZELLIJ_CONFIG_DIR` to a dir with structure to replace `~/.config/zellij`.

## Completions

Completions can be generated with `zellij setup --generate-completion zsh`.

You need to remove any function below the `_zellij "$@"` statement in the generated file as those aren't completion functions.

In this repository, the completion file is in the zsh completions directory (`zsh/completions`). It is modified to:

- remove those functions I wrote about above,
- work with the `zj` alias, with:

  ```text
  #compdef zellij zj=zellij
  ```

- and provide autocomplete for layouts in the `${ZELLIJ_CONFIG_DIR}/layouts` dir, with:

  ```text
  # the following line to get layout filenames to use as entries of -l and --layout args
  layout_files=$(find "${ZELLIJ_CONFIG_DIR}/layouts" -type f -name "*.kdl" -exec basename {} .kdl \;)
  ```

  and

  ```text
  ...session]:LAYOUT:(${layout_files})" \
  ```

Source: <https://github.com/zellij-org/zellij/issues/3342>
