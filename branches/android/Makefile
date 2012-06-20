#
# Copyright (c) 2012 Mark Heily <mark@heily.com>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#

NDK := ~/android/android-ndk-r8
NDK_TOOLCHAIN := $(NDK)/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86
NDK_BUILD := $(NDK)/ndk-build
CC := $(NDK_TOOLCHAIN)/bin/arm-linux-androideabi-gcc

.PHONY : clean

all: check-environment clean build ndk-build

check-environment:
	test -x $(CC)
	test -x $(NDK_BUILD)

build:
	mkdir build

	# libBlocksRuntime
	cp -R libBlocksRuntime build
	cp -R overlay/libBlocksRuntime/config.h build/libBlocksRuntime
	cp -R overlay/libBlocksRuntime/jni build/libBlocksRuntime

	# libpthread_workqueue

ndk-build: build
	cd build/libBlocksRuntime && \
	    ndk-build
clean:
	rm -rf build
