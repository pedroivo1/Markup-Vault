#!/bin/sh

set -e

# ==========================================
# SYSTEM-WIDE XFCE CUSTOMIZATION
# Note: This script mandates root privileges.
# ==========================================

echo "--- Establishing Global Theme Infrastructure ---"

# 1. GLOBAL TOGGLE SCRIPT INSTALLATION
create_global_toggle() {
    mkdir -p /usr/local/bin
    
    cat << 'EOF' > /usr/local/bin/toggle-theme.sh
#!/bin/sh
CURRENT_THEME=$(xfconf-query -c xsettings -p /Net/ThemeName)
if [ "$CURRENT_THEME" = "Arc-Darker" ]; then
    xfconf-query -c xsettings -p /Net/ThemeName -s "Arc"
    xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus"
    xfconf-query -c xfwm4 -p /general/theme -s "Arc"
else
    xfconf-query -c xsettings -p /Net/ThemeName -s "Arc-Darker"
    xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark"
    xfconf-query -c xfwm4 -p /general/theme -s "Arc-Darker"
fi
EOF

    chmod +x /usr/local/bin/toggle-theme.sh
}

# 2. SYSTEM-WIDE DEFAULTS (XDG CONFIGURATION)
apply_global_settings() {
    CONF_DIR="/etc/xdg/xfce4/xfconf/xfce-perchannel-xml"
    mkdir -p "$CONF_DIR"

    # Define Default Theme and Icons
    cat << 'EOF' > "$CONF_DIR/xsettings.xml"
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="Arc-Darker"/>
    <property name="IconThemeName" type="string" value="Papirus-Dark"/>
  </property>
</channel>
EOF

    # Define Default Window Manager Theme
    cat << 'EOF' > "$CONF_DIR/xfwm4.xml"
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="theme" type="string" value="Arc-Darker"/>
  </property>
</channel>
EOF

    # Define Global Keyboard Shortcut (Super + T)
    cat << 'EOF' > "$CONF_DIR/xfce4-keyboard-shortcuts.xml"
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-keyboard-shortcuts" version="1.0">
  <property name="commands" type="empty">
    <property name="custom" type="empty">
      <property name="&lt;Super&gt;t" type="string" value="/usr/local/bin/toggle-theme.sh"/>
    </property>
  </property>
</channel>
EOF
}

# ==========================================
# MAIN EXECUTION
# ==========================================
if [ "$(id -u)" -ne 0 ]; then
    echo "Fatal Error: Administrative privileges required. Execute with 'sudo'." >&2
    exit 1
fi

create_global_toggle
apply_global_settings

echo "--- PROCEDIMENTO FINALIZADO ---"
echo "System-wide defaults and the [Super] + [T] shortcut have been successfully provisioned."
