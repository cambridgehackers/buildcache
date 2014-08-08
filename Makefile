

test:
	rm -fr cache data output.bak
	mkdir -p output data
	cp -f /etc/motd data
	BUILDCACHE_CACHEDIR=./cache \
	BUILDCACHE_OUTPUTDIR=./output \
	./buildcache sort data/motd -o output/dmot
	mv output output.bak
	BUILDCACHE_CACHEDIR=./cache \
	BUILDCACHE_OUTPUTDIR=./output \
	./buildcache sort data/motd -o output/dmot
	diff -urN output.bak output
