# GLOBAL DEFAULT APPLICATIONS
mkdir -p /etc/xdg

cat << 'EOF' > /etc/xdg/mimeapps.list
[Default Applications]
x-scheme-handler/http=com.brave.Browser.desktop
x-scheme-handler/https=com.brave.Browser.desktop

text/plain=mousepad.desktop

application/pdf=org.gnome.Evince.desktop

image/png=feh.desktop
image/jpeg=feh.desktop

text/x-csrc=com.visualstudio.code.desktop
text/x-c++src=com.visualstudio.code.desktop
text/x-python=com.visualstudio.code.desktop
application/x-shellscript=com.visualstudio.code.desktop
text/markdown=com.visualstudio.code.desktop
application/json=com.visualstudio.code.desktop
text/html=com.visualstudio.code.desktop
text/css=com.visualstudio.code.desktop
text/javascript=com.visualstudio.code.desktop
EOF
