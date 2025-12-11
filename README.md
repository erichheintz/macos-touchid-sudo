# macOS Touch ID Sudo

This project enables the use of Touch ID for `sudo` authentication on macOS. With this setup, you can use your Mac's fingerprint sensor to authenticate `sudo` commands in the terminal, making the process more secure and convenient.

## Features
- Use Touch ID for `sudo` authentication
- Simple setup script
- No need to manually edit PAM configuration files

## Requirements
- macOS with Touch ID support
- Administrator privileges

## Setup
1. Clone this repository:
   ```sh
   git clone https://github.com/erichheintz/macos-touchid-sudo.git
   cd macos-touchid-sudo
   ```
2. Run the setup script:
   ```sh
   ./setup.sh
   ```
   You may be prompted for your password.

## How It Works
The setup script adds the Touch ID PAM module to the `/etc/pam.d/sudo` configuration, allowing you to use your fingerprint for `sudo` authentication.

## Uninstall
To remove Touch ID support for `sudo`, you can manually edit `/etc/pam.d/sudo` and remove the line referencing `pam_tid.so`.

## Disclaimer
Use at your own risk. Modifying PAM configuration files can affect system authentication. Make sure you understand the changes being made.
