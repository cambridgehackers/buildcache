BUILDCACHE=$(shell /bin/pwd)/buildcache

tests: test1 test2

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
