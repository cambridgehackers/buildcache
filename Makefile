

all:
	true

INSTALL_DIRS = $(shell ls | grep -v debian)

install:
	find $(INSTALL_DIRS) -type d -exec install -d -m755 $(DESTDIR)/usr/share/buildcache/{} \; -print
	find $(INSTALL_DIRS) -type f -exec install -m644 {} $(DESTDIR)/usr/share/buildcache/{} \; -print
	install -m755 buildcache $(DESTDIR)/usr/share/buildcache/buildcache

VERSION=14.10.1

dpkg:
	git buildpackage --git-upstream-branch=master --git-debian-branch=ubuntu/trusty -S -tc
