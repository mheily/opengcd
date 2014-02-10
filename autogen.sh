#!/bin/bash -ex

test -d blocks-runtime || \
  git clone https://github.com/mheily/blocks-runtime.git

test -d libkqueue || \
  git clone https://github.com/mheily/libkqueue.git

test -d libpwq || \
  svn co svn://svn.code.sf.net/p/libpwq/code/trunk libpwq

autoreconf -fvi