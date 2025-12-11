#!/usr/bin/env bash
# setup-sudo.sh - Enable Touch ID for sudo on macOS

set -e

# Output helper functions
debug() {
    if [ "${VERBOSE:-0}" = "1" ]; then
        echo "[DEBUG] $*" >&2
    fi
}

info() {
    echo "[INFO] $*"
}

ok() {
    echo "[✓] $*"
}

warn() {
    echo "[WARN] $*" >&2
}

error() {
    echo "[ERROR] $*" >&2
}

verbose() {
    if [ "${VERBOSE:-0}" = "1" ]; then
        echo "$*"
    fi
}

# Main Touch ID setup function
setup_sudo_touchid() {
    debug "Starting Touch ID for sudo setup"
    
    # Check if running on macOS
    if [ "$(uname)" != "Darwin" ]; then
        debug "Not macOS ($(uname)), skipping Touch ID setup"
        return 0
    fi
    
    debug "macOS detected, proceeding with Touch ID setup"
    
    # Check if Touch ID is available
    if ! /usr/bin/bioutil -r >/dev/null 2>&1; then
        warn "Touch ID may not be available on this system, skipping setup"
        return 0
    fi
    
    debug "Touch ID hardware detected"
    
    # Path to the sudo_local file
    local sudo_local_file="/etc/pam.d/sudo_local"
    
    # Check if file already exists and is configured
    if [ -f "$sudo_local_file" ]; then
        debug "File $sudo_local_file already exists"
        if grep -q "pam_tid.so" "$sudo_local_file"; then
            ok "Touch ID for sudo is already configured"
            return 0
        else
            debug "File exists but doesn't contain Touch ID configuration, will update"
        fi
    fi
    
    info "Configuring Touch ID for sudo authentication"
    
    # Create the sudo_local file with Touch ID enabled
    if sudo tee "$sudo_local_file" > /dev/null << 'EOF'; then
# sudo_local: local config file which survives system update and is included for sudo
# uncomment following line to enable Touch ID for sudo
auth       sufficient     pam_tid.so
EOF
        # Set appropriate permissions
        sudo chmod 644 "$sudo_local_file"
        sudo chown root:wheel "$sudo_local_file"
        
        ok "Touch ID for sudo has been enabled"
        verbose "Touch ID authentication is now available for sudo commands"
        verbose "Note: May require restarting terminal session to take effect"
    else
        error "Failed to create Touch ID configuration file"
        return 1
    fi
}

# Run the main function
setup_sudo_touchid
