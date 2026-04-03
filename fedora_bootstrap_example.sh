#!/bin/bash
# --- 1. Repository Cleanup & Setup (DNF5) ---
echo "--- Configuring Repositories ---"
sudo rm -f /etc/yum.repos.d/lens.repo

# Added GitHub CLI Repo
sudo dnf config-manager addrepo --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo --overwrite

sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo --overwrite
sudo dnf config-manager addrepo --from-repofile=https://rpm.releases.hashicorp.com/fedora/hashicorp.repo --overwrite
sudo dnf config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo --overwrite
sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo --overwrite
sudo dnf config-manager addrepo --from-repofile=https://packages.microsoft.com/yumrepos/edge/config.repo --overwrite

# --- 2. DNF Package Install ---
echo "--- Installing Infrastructure & CLI Tools ---"
sudo dnf install -y \
    ansible terraform vagrant gh \
    docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    awscli2 azure-cli k9s code \
    brave-browser microsoft-edge-stable \
    tailscale ulauncher filezilla remmina \
    fastfetch neovim htop tree \
    virt-manager virt-viewer libvirt libvirt-daemon-kvm \
    dkms kernel-devel kernel-headers @virtualization

# --- 3. Flatpaks (Productivity & Media) ---
echo "--- Installing Flatpaks ---"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub \
    com.github.IsmaelMartinez.teams_for_linux com.github.tchx84.Flatseal \
    com.spotify.Client com.vivaldi.Vivaldi dev.deedles.Trayscale \
    md.obsidian.Obsidian net.cozic.joplin_desktop org.kde.krita \
    org.onlyoffice.desktopeditors dev.k8slens.OpenLens com.discordapp.Discord \
    com.obsproject.Studio org.angryip.ipscan

# --- 4. Post-Install Services & Groups ---
echo "--- Enabling Services & Setting Permissions ---"
sudo systemctl daemon-reload
sudo systemctl enable --now docker tailscaled libvirtd
sudo usermod -aG docker,libvirt $USER

# --- 5. Theme Application (WhiteSur-Dark) ---
echo "--- Applying WhiteSur-Dark KDE Theme ---"
# Note: This uses the global theme ID for vinceliuce's WhiteSur
kpackagetool6 --type=lookandfeel --install com.github.vinceliuice.WhiteSur-dark 2>/dev/null
lookandfeeltool -a com.github.vinceliuice.WhiteSur-dark

# --- 6. Custom Environment ---
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

echo "--- Fedora Bootstrap Complete! Reboot recommended. ---"
