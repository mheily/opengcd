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
NDK_BUILD   := $(NDK)/ndk-build
NDK_INCLUDE := $(NDK)/platforms/android-14/arch-arm/usr/lib/
NDK_LIB     := $(NDK)/platforms/android-14/arch-arm/usr/lib/
CC          := $(NDK_TOOLCHAIN)/bin/arm-linux-androideabi-gcc

# Convenience variables for output objects
BLOCKS_RUNTIME := ./build/libBlocksRuntime/obj/local/armeabi/libBlocksRuntime.so
PWQ_LIB := build/libpthread_workqueue/libs/armeabi/libpthread_workqueue.so
KQUEUE_LIB := build/libkqueue/libs/armeabi/libkqueue.so


.PHONY : clean

all: check-environment clean build ndk-build

check-environment:
	test -x $(CC)
	test -x $(NDK_BUILD)
	test -x $(NDK_INCLUDE)
	test -x $(NDK_LIB)

build:
	mkdir build

	# libBlocksRuntime
	cp -R libBlocksRuntime build
	cp -R overlay/libBlocksRuntime/config.h build/libBlocksRuntime
	cp -R overlay/libBlocksRuntime/jni build/libBlocksRuntime

	# libpthread_workqueue
	cp -R libpthread_workqueue build
	cp -R overlay/libpthread_workqueue/jni build/libpthread_workqueue
	cd build/libpthread_workqueue && patch -p0 < ../../patch/getloadavg.diff

	# libkqueue
	cp -R libkqueue build
	cp overlay/libkqueue/Android.mk build/libkqueue
	cp -R overlay/libkqueue/jni build/libkqueue
	cp -R overlay/libkqueue/test/jni build/libkqueue/test
	cd build/libkqueue && patch -p0 < ../../patch/kqueue-private.diff
	cd build/libkqueue && patch -p0 < ../../patch/kqueue-timer.diff
	cd build/libkqueue && patch -p0 < ../../patch/kqueue-tls.diff
	cd build/libkqueue/test && patch -p0 < ../../../patch/kqueue-test.diff

	# libdispatch
	cp -R libdispatch-0* build/libdispatch
	#TODO:cp -R overlay/libdispatch/jni build/libdispatch

$(BLOCKS_RUNTIME): build
	cd build/libBlocksRuntime && ndk-build

$(PWQ_LIB): build
	cd build/libpthread_workqueue && ndk-build TARGET_PLATFORM=android-14

$(KQUEUE_LIB): build
	cd build/libkqueue && ndk-build NDK_PROJECT_PATH=.

# Run all unit tests
check: check-kqueue

# Run libkqueue unit tests
check-kqueue:
	adb push build/libkqueue/libs/armeabi/libkqueue.so /data
	adb push build/libkqueue/libs/armeabi/kqtest /data
	adb shell LD_LIBRARY_PATH=/data /data/kqtest
	adb shell rm /data/kqtest /data/libkqueue.so
	
ndk-build: $(BLOCKS_RUNTIME) $(PWQ_LIB) $(KQUEUE_LIB)

 	# FIXME: fails due to missing atomics
	cd build/libdispatch && autoreconf -fvi && \
          CC=$(CC) \
	  CPPFLAGS="-I$(NDK_INCLUDE)" \
 	  CFLAGS="-nostdlib" \
	  LIBS="" \
          LDFLAGS="-Wl,-rpath-link=$(NDK_LIB) -L$(NDK_LIB)" \
 	  ./configure --build=x86_64-unknown-linux-gnu --host=arm-linux-androideabi --target=arm-linux-androideabi 


clean:
	rm -rf build
