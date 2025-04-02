# Ubuntu 24.04 LTS Post-Install Script for Intel NUC12SNKi72

Optimized for **Gaming**, **LLMs**, **Development**, and **Virtualization**.

> ⚠️ **Warning:** This script is **highly specific** to the **Intel NUC12SNKi72**.
> Do **not** use it on other systems without thoroughly reviewing and adapting it to your hardware setup.

## Features

- Updates and upgrades the system.
- Installs essential tools and developer utilities.
- Configures virtualization tools and adds the user to necessary groups.
- Sets up Intel GPU drivers and runtimes.
- Installs various applications via Snap.
- Configures Docker and adds the user to the Docker group.

## Instructions

### Making the Script Executable

Before running the script, you need to make it executable. You can do this by using the `chmod` command:

```bash
chmod +x post-install-script.sh
```

### Execute the Script as sudo

To execute the script, you need to run it with sudo to ensure that all commands have the necessary permissions:

```bash
sudo ./post-install-script.sh
```