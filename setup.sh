#!/usr/bin/env bash

usage(){
cat <<EOF
Run this as a user. It installs zoom to your home without
requiring root access and without the risk that you accidentally
run it without the firejail.
EOF
}

==() {
    echo "=== $* ===" >&2
}

::() {
    echo ":: $*" >&2
    "$@"
}

desktop-entry() {
echo "Creating Desktop Entry for \"$1\"..." >&2
cat <<EOF
[Desktop Entry]
Name=Zoom in Firejail
Comment=Zoom Video Conference in Firejail Sandbox
Exec=$1 %U
Icon=Zoom
Terminal=false
Type=Application
Encoding=UTF-8
Categories=Network;Application;
StartupWMClass=Zoom
MimeType=x-scheme-handler/zoommtg;x-scheme-handler/zoomus;x-scheme-handler/tel;x-scheme-handler/callto;x-scheme-handler/zoomphonecall;application/x-zoom
X-KDE-Protocols=zoommtg;zoomus;tel;callto;zoomphonecall;
Name[en_US]=Zoom
EOF
}

thisDir=${0%/*}
thisDir=$(realpath "$thisDir")
zoomWrapper=$thisDir/zoom-firejail
downloadurl=https://zoom.us/client/latest/zoom_x86_64.tar.xz
zoomHome="$HOME/.zoom-home"
set -e

:: mkdir -p "$zoomHome"
pushd "$zoomHome"
:: wget "$downloadurl" -O zoom-latest.tar.xz
:: tar xvf zoom-latest.tar.xz

:: mkdir -p "$zoomHome/bin"
:: ln -sfvr "$zoomHome/zoom/ZoomLauncher" "$zoomHome/bin/zoom"

== setup mime outside the sandbox
:: mkdir -p "$HOME/.local/share/applications"
desktop-entry "$zoomWrapper" | :: tee "$HOME/.local/share/applications/zoom-firejail.desktop" > /dev/null

for scheme in zoommtg zoomus tel callto zoomphonecall ; do
    :: xdg-mime default zoom-firejail.desktop x-scheme-handler/$scheme
done
:: update-desktop-database "$HOME/.local/share/applications"

== setup mime inside the sandbox
name=ZoomAlreadySandboxed
:: mkdir -p "$zoomHome/.local/share/applications"
desktop-entry "$HOME/zoom/ZoomLauncher" | :: tee "$zoomHome/.local/share/applications/$name.desktop" > /dev/null

firejailprefix=(
    firejail --quiet
        --profile=$thisDir/zoom.profile
        --private=$HOME/.zoom-home
)

for scheme in zoommtg zoomus tel callto zoomphonecall ; do
    :: "${firejailprefix[@]}" \
        -- xdg-mime default ${name}.desktop x-scheme-handler/$scheme
done
:: "${firejailprefix[@]}" \
    xdg-settings set default-web-browser firefox.desktop
#:: "${firejailprefix[@]}" \
#    update-desktop-database "$HOME/.local/share/applications"
cat >&2 <<EOF
If you want to double check the above xdg-connection, 
run the following *inside* the sandbox (i.e. in ./zoom-firejail --shell).
It should print ${name}.desktop:

    xdg-mime query default x-scheme-handler/zoommtg
EOF
