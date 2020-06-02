# Firejail profile for zoom
# This file is overwritten after every install/update
# Persistent local customizations
include zoom.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/zoomus.conf
noblacklist ${HOME}/.zoom

# for SSO via firefox:
noblacklist ${HOME}/.mozilla
noblacklist ${HOME}/.cache/mozilla

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.cache/zoom
mkfile ${HOME}/.config/zoomus.conf
mkdir ${HOME}/.zoom
whitelist ${HOME}/.cache/zoom
whitelist ${HOME}/.config/zoomus.conf
whitelist ${HOME}/.zoom
include whitelist-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
# the following protocoll restriction breaks a lot:
# 1. the profile picture isn't loaded
# 2. hte login and recent meetings aren't remembered
# 3. the 'new meeting' button does nothing.
#protocol unix,inet,inet6

# I had to disalbe the following to make networking
# in browsers work, which is required for SSO
#seccomp

private-tmp
