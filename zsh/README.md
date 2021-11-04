# zsh notes

### Performance and optimizations

- [faster and enjoyable ZSH (maybe)](https://htr3n.github.io/2018/07/faster-zsh/)
- [function lazy loading](https://zsh.sourceforge.io/Doc/Release/Functions.html#Autoloading-Functions)
- [compile completions](https://github.com/zsh-users/zsh/blob/master/Functions/Misc/zrecompile)
- [wrapper functions](https://peterlyons.com/problog/2018/01/zsh-lazy-loading/)

#### Check load times

Run

```sh
for i in $(seq 1 10); do /usr/bin/time /bin/zsh -i -c exit; done;
```

then take the average.

#### Shell startup order

![shell startup order](https://htr3n.github.io/2018/07/faster-zsh/shell-startup-actual.png)

### Load changes in login scripts

Reload any updates to shell scripts by running a login shell.

```sh
exec zsh --login
```

