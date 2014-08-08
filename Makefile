

test:
	rm -fr cache data
	mkdir -p output data
	cp -f /etc/motd data
	BUILDCACHE_CACHEDIR=./cache \
	BUILDCACHE_OUTPUTDIR=./output \
	./buildcache sort data/motd -o output/dmot
	BUILDCACHE_CACHEDIR=./cache \
	BUILDCACHE_OUTPUTDIR=./output \
	./buildcache sort data/motd -o output/dmot
