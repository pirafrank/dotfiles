# Zsh Performance Notes

## References

- [faster and enjoyable ZSH (maybe)](https://htr3n.github.io/2018/07/faster-zsh/)
- [function lazy loading](https://zsh.sourceforge.io/Doc/Release/Functions.html#Autoloading-Functions)
- [compile completions](https://github.com/zsh-users/zsh/blob/master/Functions/Misc/zrecompile)
- [wrapper functions](https://peterlyons.com/problog/2018/01/zsh-lazy-loading/)

## Check load times

Run

```sh
for i in $(seq 1 10); do /usr/bin/time /bin/zsh -i -c exit; done;
```

then take the average.

## Performance Optimizations

1. **Skip global compinit** (`skip_global_compinit=1` in zshenv) - Avoids redundant completion initialization
2. **Ignore system rc files** (`setopt noglobalrcs` in zshenv) - Only loads user configs
3. **Background compilation** (zlogin) - `zcompile` files in background for faster subsequent loads
4. **Lazy loading** - 22 functions in `autoloaded/` only loaded when first called
5. **Conditional sourcing** - Most tools check directory existence before PATH modification
