function scwupdate --description 'update Scaleway CLI tool'
    rm -f ~/bin2/scw
    set -l download_url (curl -sL https://api.github.com/repos/scaleway/scaleway-cli/releases/latest | grep http | grep linux | grep x86_64 | cut -d':' -f 2,3 | cut -d'"' -f2)
    curl -o ~/bin2/scw -L $download_url
    chmod +x ~/bin2/scw
end
