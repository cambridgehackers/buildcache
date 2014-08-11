buildcache
==========

Memoizes execution of build commands

    export BUILDCACHE_CACHEDIR=/path/to/buildcache
    buildcache vivado build.tcl

Buildcache uses strace to see which files are read and written during the build step.

A build is identified by the SHA1 of the executable, its arguments,
and filtered environment variables. After the build is run, buildcache
takes the md5sum of the files that were read (the "footprint" of the
build) and caches a copy of the files that were written.

If a previous build exists, and the md5sum of the footprint of the
previous build matches the current contents of the footprint files,
the cached output is restored and used instead of re-running the build
command.
