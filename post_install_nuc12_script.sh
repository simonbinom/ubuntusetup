#!/bin/bash

# ========================
# Ubuntu 24.04 LTS post-install script for Intel NUC12SNKi72
# Optimized for Gaming, LLMs, Development and Virtualization
# ========================

# Exit on error
set -e

# Function to print errors
error_exit() {
    echo "Error: $1"
    exit 1
}

# Update and upgrade the system
echo "Updating system..."
sudo apt update && sudo apt upgrade -y || error_exit "Failed to update system."
sudo apt autoremove -y && sudo apt autoclean -y

# Check if snap is installed before refreshing
if command -v snap &>/dev/null; then
    echo "Updating snaps..."
    sudo snap refresh || error_exit "Failed to refresh snaps."
else
    echo "Snap is not installed. Skipping snap refresh."
fi

# Install essential tools and developer utilities
echo "Installing essential tools and developer utilities..."
sudo apt install -y git curl wget gnome-tweaks gnome-shell-extension-manager python3-pip python3-venv pipx clinfo gamemode mangohud qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager || error_exit "Failed to install essential tools."

# Adding user to necessary groups for virtualization
echo "Adding user to libvirt and kvm groups for virtualization..."
sudo usermod -aG libvirt,kvm $USER || error_exit "Failed to add user to libvirt and kvm groups."

# Adding user to render group for GPU access
echo "Adding user to render group for GPU access..."
sudo usermod -aG render $USER || error_exit "Failed to add user to render group."

# Setting up Intel GPU repository for latest drivers and runtimes
echo "Setting up Intel GPU repository for latest drivers and runtimes..."
wget -qO - https://repositories.intel.com/gpu/intel-graphics.key | sudo gpg --dearmor -o /usr/share/keyrings/intel-graphics.gpg || error_exit "Failed to set up Intel GPU repository."
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/gpu/ubuntu noble unified" | sudo tee /etc/apt/sources.list.d/intel-gpu-noble.list

# Installing Intel GPU drivers and runtimes
echo "Installing Intel GPU runtime components..."
sudo apt update
sudo apt install -y libze-intel-gpu1 libze1 intel-opencl-icd clinfo intel-gsc libze-dev intel-ocloc intel-level-zero-gpu-raytracing intel-gpu-tools || error_exit "Failed to install Intel GPU components."

# Installing applications via Snap
echo "Installing VS Code via snap..."
sudo snap install code --classic || error_exit "Failed to install VS Code."

echo "Installing 1Password via snap..."
sudo snap install 1password --classic || error_exit "Failed to install 1Password."

echo "Installing PowerShell via snap..."
sudo snap install powershell --classic || error_exit "Failed to install PowerShell."

echo "Installing Super Productivity via snap..."
sudo snap install superproductivity || error_exit "Failed to install Super Productivity."

echo "Installing Ollama via snap..."
sudo snap install ollama --edge || error_exit "Failed to install Ollama."

echo "Installing Open WebUI via snap..."
sudo snap install open-webui --edge || error_exit "Failed to install Open WebUI."

echo "Installing Steam via snap..."
sudo snap install steam --edge || error_exit "Failed to install Steam."

# Configuring Open WebUI to integrate with Ollama
echo "Configuring Open WebUI to integrate with Ollama..."
sudo snap set open-webui port=8080
sudo snap set open-webui host=0.0.0.0
sudo snap set open-webui ollama-api-base-url=http://localhost:11434/api
sudo snap set open-webui enable-signup=true
sudo snap restart open-webui || error_exit "Failed to configure Open WebUI."

# Install Docker from the official repository
echo "Installing Docker from official repository..."
# Remove any old versions of Docker:
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
    if dpkg -l | grep -q $pkg; then
        sudo apt-get remove -y $pkg || error_exit "Failed to remove old Docker packages."
    fi
done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl || error_exit "Failed to install ca-certificates and curl."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc || error_exit "Failed to download Docker GPG key."
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install needed packages
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || error_exit "Failed to install Docker packages."

# Add current user to docker group
sudo usermod -aG docker $USER || error_exit "Failed to add user to docker group."

# END OF SCRIPT
echo "Post-install script complete. Please reboot the system for group changes to take effect."
echo "After reboot, run 'gnome-shell-extension-manager' to configure extensions."