#!/bin/bash

# --- 1. REPOSITORY SETUP & GPG KEYS ---
echo "--- Step 1: Configuring Repositories & GPG Keys ---"
sudo dnf clean all

# Import GPG Keys manually
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

# Add Repos - Force using 'stable' paths if F43 metadata isn't ready
sudo dnf config-manager addrepo --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo --overwrite
sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo --overwrite
sudo dnf config-manager addrepo --from-repofile=https://rpm.releases.hashicorp.com/fedora/hashicorp.repo --overwrite
sudo dnf config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo --overwrite
sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo --overwrite

# Fix for VS Code / Edge Repo (Standard Microsoft Repo)
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# --- 2. DNF PACKAGE INSTALL ---
echo "--- Step 2: Installing Engineering Stack ---"
# CRITICAL: Added 'git' and 'wget' here
sudo dnf install -y --refresh \
    git wget ansible terraform vagrant gh \
    docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    awscli2 azure-cli code \
    brave-browser \
    tailscale ulauncher filezilla remmina \
    fastfetch neovim htop tree sassc glib2-devel \
    virt-manager virt-viewer libvirt libvirt-daemon-kvm \
    dkms kernel-devel kernel-headers

# --- 3. FLATPAK INSTALLS ---
echo "--- Step 3: Installing Flatpaks ---"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub \
    com.github.IsmaelMartinez.teams_for_linux com.github.tchx84.Flatseal \
    com.spotify.Client com.vivaldi.Vivaldi dev.deedles.Trayscale \
    md.obsidian.Obsidian net.cozic.joplin_desktop org.kde.krita \
    org.onlyoffice.desktopeditors dev.k8slens.OpenLens com.discordapp.Discord \
    com.obsproject.Studio org.angryip.ipscan

# --- 4. THE WHITESUR "AESTHETIC" CLONE ---
echo "--- Step 4: Git Cloning WhiteSur Suite ---"
# Now that 'git' is installed in Step 2, this will work!
mkdir -p ~/Downloads/build && cd ~/Downloads/build

git clone https://github.com/vinceliuice/WhiteSur-kde.git --depth=1
cd WhiteSur-kde && ./install.sh && cd ..

git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git --depth=1
cd WhiteSur-icon-theme && ./install.sh && cd ..

git clone https://github.com/vinceliuice/WhiteSur-cursors.git --depth=1
cd WhiteSur-cursors && ./install.sh && cd ..

# Apply theme (Note: In a VM or clean install, this may need a session restart)
lookandfeeltool -a com.github.vinceliuice.WhiteSur-dark || echo "Theme apply failed - install manually via KDE settings"

# --- 5. SERVICES & PERMISSIONS ---
echo "--- Step 5: Enabling Services ---"
sudo systemctl daemon-reload
# Services will now exist because the DNF install succeeded
sudo systemctl enable --now docker tailscaled libvirtd
sudo usermod -aG docker,libvirt $USER

# --- 6. ENVIRONMENT & ALIASES ---
echo "--- Step 6: Injecting Aliases ---"
mkdir -p ~/Scripts ~/Git/ctrl-alt-ryan ~/Lab/proxmox-k8s
if ! grep -q "alias updateall" ~/.bashrc; then
cat << 'EOF' >> ~/.bashrc
# --- Ctrl Alt Ryan Environment ---
alias updateall='sudo dnf upgrade -y && flatpak update -y && sudo dnf autoremove -y'
alias k='kubectl'
alias tf='terraform'
alias v='vagrant'
alias l='ls -lah --color=auto'
export LAB_DIR="$HOME/Lab/proxmox-k8s"
EOF
fi

# --- 7. REVEAL ---
cd ~
clear
fastfetch
echo "------------------------------------------------"
echo "  BOOTSTRAP COMPLETE - REBOOT FOR FULL EFFECT   "
echo "------------------------------------------------"
