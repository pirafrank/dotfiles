# `gpg` notes

## Docs

- [config options](https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html)
- [agent operations](https://www.gnupg.org/documentation/manuals/gnupg/Agent-Options.html)

## Links

- [drduh/YubiKey-Guide](https://github.com/drduh/YubiKey-Guide/blob/master/README.md)
- [A guide to setting up & managing GPG keys on a Yubikey 4](https://disjoint.ca/til/2017/10/05/a-guide-to-setting-up--managing-gpg-keys-on-a-yubikey-4/)
- [GPG: Strong Keys and Rotation (reissue)](https://web.archive.org/web/20210122124500/https://sungo.io/posts/2020/gpg-rotation/)
- [GPG with yubikey - malcolmsparks.com](https://web.archive.org/web/20201112015846/https://malcolmsparks.com/posts/yubikey-gpg.html)
- [https://support.yubico.com/hc/en-us/articles/360013714599-YubiKey-4](https://support.yubico.com/hc/en-us/articles/360013714599-YubiKey-4)
- [https://support.yubico.com/hc/en-us/articles/360016614900-YubiKey-5-Series-Technical-Manual#NFCqac5ji](https://support.yubico.com/hc/en-us/articles/360016614900-YubiKey-5-Series-Technical-Manual#NFCqac5ji)
- [The ultimate guide to Yubikey on WSL2 [Part 1]](https://jardazivny.medium.com/the-ultimate-guide-to-yubikey-on-wsl2-part-1-dce2ff8d7e45)
- [SSH authentication using a GPG smart card on Windows](https://github.com/herlo/ssh-gpg-smartcard-config/blob/master/Windows.md)
- [YubiKey GPG key for SSH authentication](https://mikebeach.org/2017/09/07/yubikey-gpg-key-for-ssh-authentication/)
- [Yubikey for SSH Authentication (old OSes)](https://occamy.chemistry.jhu.edu/references/pubsoft/YubikeySSH/index.php)
- [Securing My Digital Life: GPG, Yubikey, & SSH on macOS](https://medium.com/@ahawkins/securing-my-digital-life-gpg-yubikey-ssh-on-macos-5f115cb01266)
- [Using password-store with git repository synching](https://gist.github.com/abtrout/d64fb11ad6f9f49fa325)

## Snippets

- to reload the gpg-agent run

```txt
gpg-connect-agent reloadagent /bye
```
