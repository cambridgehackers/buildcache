BUILDCACHE=$(shell /bin/pwd)/buildcache

tests: test1 test2 test3 test4

test1:
	rm -fr cache data output.bak
	mkdir -p output data
	cp -f /etc/motd data
	BUILDCACHE_CACHEDIR=./cache/test1 \
	BUILDCACHE_OUTPUTDIR=./output \
	$(BUILDCACHE) sort data/motd -o output/dmot
	mv output output.bak
	BUILDCACHE_CACHEDIR=./cache/test1 \
	BUILDCACHE_OUTPUTDIR=./output \
	$(BUILDCACHE) sort data/motd -o output/dmot
	diff -urN output.bak output
	find cache

## verify that BUILDCACHE_OUTPUTDIR is not needed
test2:
	rm -fr test2dir data
	mkdir -p test2dir/output data
	cp -f /etc/motd data
	cd test2dir; \
	BUILDCACHE_CACHEDIR=./cache/test2 \
	$(BUILDCACHE) sort ../data/motd -o output/dmot; \
	mv output output.bak; \
	BUILDCACHE_CACHEDIR=./cache/test2 \
	$(BUILDCACHE) sort ../data/motd -o output/dmot; \
	diff -urN output.bak output

## make sure it works even if a file is written and removed
test3:
	rm -fr test3dir data
	mkdir -p test3dir/output data
	cp -f /etc/motd data
	cd test3dir; \
	BUILDCACHE_CACHEDIR=./cache/test3 \
	$(BUILDCACHE) ../test3.sh ../data/motd output/dmot; \
	mv output output.bak; \
	BUILDCACHE_CACHEDIR=./cache/test3 \
	$(BUILDCACHE) ../test3.sh ../data/motd output/dmot; \
	diff -urN output.bak output

## make sure it works even if BUILDCACHE_CACHEDIR is unset
test4:
	rm -fr test4dir data
	mkdir -p test4dir/output data
	cp -f /etc/motd data
	cd test4dir; \
	unset BUILDCACHE_CACHEDIR; \
	$(BUILDCACHE) sort ../data/motd -o output/dmot
	diff -urN output.bak output
