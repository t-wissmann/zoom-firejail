Zoom-Firejail
=============

A configuration for running zoom in a firejail sandbox:

  - The `./setup.sh` downloads the latest zoom version and installs it
    to `~/.zoom-home`
  - Installs a desktop launcher such that you can run it from your
    menu and can click on zoom-links.
  - The desktop launcher starts zoom with the shipped firejail
    profile and is in fact the only entry point to the sandboxed zoom
    in your `$PATH`.
  - The sandbox also includes a `~/.mozilla` directory such that you
    can authenticate to zoom via SSO in the firefox browser.

The benefits:

  - No system-wide installation of zoom required
  - No risk of accidentally running zoom outside the sandbox

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
