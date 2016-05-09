BUILDCACHE=$(shell /bin/pwd)/buildcache

tests:

alltests: test1 test2 test3 test4

test1:
	rm -fr cache data output.bak
	mkdir -p output data
	cp -f /etc/os-release data
	BUILDCACHE_CACHEDIR=./cache/test1 \
	BUILDCACHE_OUTPUTDIR=./output \
	$(BUILDCACHE) sort data/os-release -o output/dmot
	mv output output.bak
	BUILDCACHE_CACHEDIR=./cache/test1 \
	BUILDCACHE_OUTPUTDIR=./output \
	$(BUILDCACHE) sort data/os-release -o output/dmot
	diff -urN output.bak output
	find cache

## verify that BUILDCACHE_OUTPUTDIR is not needed
test2:
	rm -fr test2dir data
	mkdir -p test2dir/output data
	cp -f /etc/os-release data
	cd test2dir; \
	BUILDCACHE_CACHEDIR=./cache/test2 \
	$(BUILDCACHE) sort ../data/os-release -o output/dmot; \
	mv output output.bak; \
	BUILDCACHE_CACHEDIR=./cache/test2 \
	$(BUILDCACHE) sort ../data/os-release -o output/dmot; \
	diff -urN output.bak output

## make sure it works even if a file is written and removed
test3:
	rm -fr test3dir data
	mkdir -p test3dir/output data
	cp -f /etc/os-release data
	cd test3dir; \
	BUILDCACHE_CACHEDIR=./cache/test3 \
	$(BUILDCACHE) ../test3.sh ../data/os-release output/dmot; \
	mv output output.bak; \
	BUILDCACHE_CACHEDIR=./cache/test3 \
	$(BUILDCACHE) ../test3.sh ../data/os-release output/dmot; \
	diff -urN output.bak output

## make sure it works even if BUILDCACHE_CACHEDIR is unset
test4:
	rm -fr test4dir data
	mkdir -p test4dir/output data
	cp -f /etc/os-release data
	cd test4dir; \
	unset BUILDCACHE_CACHEDIR; \
	$(BUILDCACHE) sort ../data/os-release -o output/dmot
	diff -urN output.bak output


all:
	true

install:
	install -d -m755 $(DESTDIR)/usr/share/buildcache
	install -m755 buildcache $(DESTDIR)/usr/share/buildcache/buildcache

VERSION=16.05.1

dpkg:
	sed -i s/trusty/precise/g debian/changelog
	git buildpackage --git-ignore-new --git-upstream-branch=master -us -uc
	sed -i s/trusty/precise/g debian/changelog

spkg:
	sed -i s/trusty/precise/g debian/changelog
	git buildpackage --git-ignore-new --git-upstream-branch=master -S -tc '--git-upstream-tag=v%(version)s'
	sed -i s/precise/trusty/g debian/changelog
	git buildpackage --git-ignore-new --git-upstream-branch=master -S -tc '--git-upstream-tag=v%(version)s'
	sed -i s/trusty/utopic/g debian/changelog
	git buildpackage --git-ignore-new --git-upstream-branch=master -S -tc '--git-upstream-tag=v%(version)s'
	git checkout debian
	sed -i s/trusty/xenial/g debian/changelog
	git buildpackage --git-ignore-new --git-upstream-branch=master -S -tc '--git-upstream-tag=v%(version)s'
	git checkout debian

upload:
	git push origin v$(VERSION)
	dput ppa:jamey-hicks/connectal ../buildcache_$(VERSION)-*_source.changes
	(cd  ../obs/home:jameyhicks:connectaldeb/buildcache/; osc rm * || true)
	cp -v ../buildcache_$(VERSION)*trusty*.diff.gz ../buildcache_$(VERSION)*trusty*.dsc ../buildcache_$(VERSION)*.orig.tar.gz ../obs/home:jameyhicks:connectaldeb/buildcache/
	(cd ../obs/home:jameyhicks:connectaldeb/buildcache/; osc add *; osc commit -m $(VERSION) )
	(cd ../obs/home:jameyhicks:connectal/buildcache; sed -i "s/>v.....</>v$(VERSION)</" _service; osc commit -m "v$(VERSION)" )

