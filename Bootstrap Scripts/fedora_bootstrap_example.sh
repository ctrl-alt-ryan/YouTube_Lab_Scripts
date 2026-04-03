#!/bin/bash

# ==============================================================================
#  PROJECT: Ctrl Alt Ryan - Fedora Bootstrap
#  DESCRIPTION: Automated Engineering Environment & MacOS Aesthetic (WhiteSur)
#  AUTHOR: Ryan (Senior Infrastructure & Cloud Engineer)
# ==============================================================================

# --- 1. REPOSITORY CLEANUP & SETUP (DNF5) ---
echo "--- Step 1: Configuring Repositories (DNF5 Standard) ---"
# Clear the broken Lens repo to prevent transaction failure
sudo rm -f /etc/yum.repos.d/lens.repo

# Using --from-repofile for DNF5 compatibility
sudo dnf config-manager addrepo --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo --overwrite
sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo --overwrite
sudo dnf config-manager addrepo --from-repofile=https://rpm.releases.hashicorp.com/fedora/hashicorp.repo --overwrite
sudo dnf config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo --overwrite
sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo --overwrite
sudo dnf config-manager addrepo --from-repofile=https://packages.microsoft.com/yumrepos/edge/config.repo --overwrite

# --- 2. THE ENGINEERING STACK (DNF) ---
echo "--- Step 2: Installing Infrastructure & CLI Tools ---"
sudo dnf install -y \
    ansible terraform vagrant gh \
    docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    awscli2 azure-cli k9s code \
    brave-browser microsoft-edge-stable \
    tailscale ulauncher filezilla remmina \
    fastfetch neovim htop tree \
    virt-manager virt-viewer libvirt libvirt-daemon-kvm \
    dkms kernel-devel kernel-headers @virtualization

# --- 3. THE PRODUCTIVITY SUITE (FLATPAK) ---
echo "--- Step 3: Installing Flatpaks (Isolated Apps) ---"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub \
    com.github.IsmaelMartinez.teams_for_linux com.github.tchx84.Flatseal \
    com.spotify.Client com.vivaldi.Vivaldi dev.deedles.Trayscale \
    md.obsidian.Obsidian net.cozic.joplin_desktop org.kde.krita \
    org.onlyoffice.desktopeditors dev.k8slens.OpenLens com.discordapp.Discord \
    com.obsproject.Studio org.angryip.ipscan

# --- 4. SERVICES & PERMISSIONS ---
echo "--- Step 4: Enabling Services & Lab Permissions ---"
sudo systemctl daemon-reload
sudo systemctl enable --now docker tailscaled libvirtd
sudo usermod -aG docker,libvirt $USER

# --- 5. THE "RICE" (KDE WHITESUR THEME) ---
echo "--- Step 5: Applying WhiteSur-Dark Aesthetic ---"
# Install the Global Theme via kpackagetool6 (KDE 6)
kpackagetool6 --type=lookandfeel --install com.github.vinceliuice.WhiteSur-dark 2>/dev/null
# Apply it immediately
lookandfeeltool -a com.github.vinceliuice.WhiteSur-dark

# --- 6. CUSTOM ENVIRONMENT (ALIASES) ---
echo "--- Step 6: Injecting Custom Bash Profile ---"
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

# --- 7. FINAL REVEAL ---
clear
fastfetch
echo "------------------------------------------------"
echo "  BOOTSTRAP COMPLETE - INFRASTRUCTURE READY     "
echo "  CTRL ALT RYAN | NO-EXPERIENCE CLOUD CAREER    "
echo "------------------------------------------------"
