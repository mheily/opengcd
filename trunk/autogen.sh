
#!/bin/bash -ex

test -d blocks-runtime || \
  git clone https://github.com/mheily/blocks-runtime.git

test -d libkqueue || \
  git clone https://github.com/mheily/libkqueue.git

test -d libpwq || \
  svn co svn://svn.code.sf.net/p/libpwq/code/trunk libpwq

test -d libdispatch
if [ $? -ne 0 ] ; then
  svn co http://svn.macosforge.org/repository/libdispatch/trunk@197 libdispatch
  cd libdispatch
  patch -p0 < ../patch/disable_dispatch_read.patch
  patch -p0 < ../patch/libdispatch-r197_v2.patch
  cd ..
fi

autoreconf -fvi
