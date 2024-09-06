# run this script as admin
# this script needs scoop package manager.

# Add Nerd Fonts bucket
scoop bucket add nerd-fonts

# sudo is required for global installs
scoop install sudo

# Font installation only works when installing font for all users.
sudo scoop install -g Meslo-NF Meslo-NF-Mono JetBrainsMono-NF Hack-NF
