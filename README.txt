Zoom-Firejail
=============

Installation
------------
Requirements: +firejail+

To install it under the current user, run

    ./setup.sh

This will place the zoom executables in +~/.zoom-home+ and will create
desktop entries

Deinstallation
--------------

Run the following commands to uninstall:

    rm -r ~/.zoom-home
    rm ~/.local/share/applications/zoom-firejail.desktop
    update-desktop-database ~/.local/share/applications

// vim: ft=asciidoc tw=70
