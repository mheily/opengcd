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

#
# You should not need to modify any variables below here.
#

UNAME := $(shell uname)
NDK := $(PWD)/android-ndk
SDK := $(PWD)/android-sdk

TOOLCHAIN_ID := arm-linux-androideabi-4.6

ifeq ($(UNAME), Darwin)
NDK_TOOLCHAIN := $(NDK)/toolchains/$(TOOLCHAIN_ID)/prebuilt/darwin-x86
endif
ifeq ($(UNAME), Linux)
NDK_TOOLCHAIN := $(NDK)/toolchains/$(TOOLCHAIN_ID)/prebuilt/linux-x86
endif

NDK_BUILD   := $(NDK)/ndk-build V=1
NDK_PREFIX := $(NDK)/platforms/android-14/arch-arm/usr
NDK_LIB     := $(NDK)/platforms/android-14/arch-arm/usr/lib/
CC          := $(NDK_TOOLCHAIN)/bin/arm-linux-androideabi-gcc
ADB         := $(SDK)/platform-tools/adb


# Convenience variables for output objects
BLOCKS_RUNTIME := ./build/libBlocksRuntime/obj/local/armeabi/libBlocksRuntime.so
PWQ_LIB := build/libpthread_workqueue/libs/armeabi/libpthread_workqueue.so
KQUEUE_LIB := build/libkqueue/libs/armeabi/libkqueue.so
DISPATCH_LIB := build/libdispatch/libs/armeabi/libdispatch.so


.PHONY : clean

all: android-sdk android-ndk clang/build android-ndk/toolchains/$(TOOLCHAIN_ID)/clang $(ADB) check-environment build ndk-build

android-sdk-macosx:
	curl -o tmp.zip http://dl.google.com/android/android-sdk_r20.0.1-macosx.zip 
	unzip tmp.zip
	rm tmp.zip

android-sdk-linux:
	curl http://dl.google.com/android/android-sdk_r20.0.1-linux.tgz | tar zxf -

android-sdk:
	case `uname` in \
      Linux) \
        make android-sdk-linux ; \
        ln -s android-sdk-linux android-sdk ; \
        ;; \
      Darwin) \
        make android-sdk-macosx ; \
        ln -s android-sdk-macosx android-sdk ; \
        ;; \
      *) \
        echo 'Unsupported OS' ; \
        exit 1 ; \
        ;; \
    esac
    
android-ndk-r8b:
	case `uname` in \
      Linux) \
	curl http://dl.google.com/android/ndk/android-ndk-r8b-linux-x86.tar.bz2 | tar jxf - ; \
	;; \
      Darwin) \
	curl http://dl.google.com/android/ndk/android-ndk-r8b-darwin-x86.tar.bz2 | tar jxf - ; \
	;; \
      *) \
        echo 'Unsupported OS' ; \
        exit 1 ; \
        ;; \
    esac

android-ndk: android-ndk-r8b
	ln -s android-ndk-r8b android-ndk

android-ndk/toolchains/$(TOOLCHAIN_ID)/clang: android-ndk clang/build
#TODO: Save old copy
#	cp -R android-ndk/toolchains/$(TOOLCHAIN_ID) android-ndk/toolchains/$(TOOLCHAIN_ID).orig ; 
	cp clang/build/Debug+Asserts/bin/clang $(NDK_TOOLCHAIN)/bin
	cp -r clang/build/Debug+Asserts/lib/clang $(NDK_TOOLCHAIN)/lib
	ln -sf clang $(NDK_TOOLCHAIN)/bin/arm-linux-androideabi-gcc
	ln -sf clang $(NDK_TOOLCHAIN)/bin/arm-linux-androideabi-g++

#   1- Android SDK Tools, revision 20.0.3
#   2- Android SDK Platform-tools, revision 14
$(ADB):
	$(SDK)/tools/android update sdk --no-ui -t platform-tools
	$(SDK)/tools/android update sdk --no-ui -t tools
    

clang:
	# Checkout LLVM
	#
	mkdir clang
	cd clang && svn co -q http://llvm.org/svn/llvm-project/llvm/trunk llvm

	#
	# Checkout clang
	#
	cd clang/llvm/tools && svn co -q http://llvm.org/svn/llvm-project/cfe/trunk clang

	#
	# Checkout compiler-rt
	#
	cd clang/llvm/projects && svn co -q http://llvm.org/svn/llvm-project/compiler-rt/trunk compiler-rt

	#
	# Build everything 
	#
clang/build: clang
	mkdir clang/build 
	cd clang/build && \
	../llvm/configure --target=arm-linux-androideabi  && \
	make -j4 || true # Workaround for build failure on Darwin

check-environment:
	test -x $(SDK)
	test -x $(NDK)
	test -x $(CC)
	test -x $(ADB)
	test -x $(NDK_TOOLCHAIN)
#test -x $(NDK_BUILD)
	test -x $(NDK_INCLUDE)
	test -x $(NDK_LIB)

build:
	mkdir build

build/libBlocksRuntime: build
	cp -R libBlocksRuntime build
	cp -R overlay/libBlocksRuntime/config.h build/libBlocksRuntime
	cp overlay/libBlocksRuntime/Android.mk build/libBlocksRuntime
	cp -R overlay/libBlocksRuntime/jni build/libBlocksRuntime

build/libpthread_workqueue: build
	cp -R libpthread_workqueue build
	cp -R overlay/libpthread_workqueue/jni build/libpthread_workqueue
	cp -R overlay/libpthread_workqueue/config.h build/libpthread_workqueue
	cp overlay/libpthread_workqueue/Android.mk build/libpthread_workqueue
	cd build/libpthread_workqueue && patch -p0 < ../../patch/getloadavg.diff

build/libkqueue: build
	cp -R libkqueue build
	cp overlay/libkqueue/Android.mk build/libkqueue
	cp overlay/libkqueue/config.h build/libkqueue
	cp -R overlay/libkqueue/jni build/libkqueue
	cd build/libkqueue && patch -p0 < ../../patch/kqueue-private.diff
	cd build/libkqueue && patch -p0 < ../../patch/kqueue-timer.diff
	cd build/libkqueue && patch -p0 < ../../patch/kqueue-tls.diff
	cd build/libkqueue/test && patch -p0 < ../../../patch/kqueue-test.diff

build/libdispatch: build
	cp -R libdispatch-0* build/libdispatch
	cp overlay/libdispatch/Android.mk build/libdispatch
	cp -R overlay/libdispatch/jni build/libdispatch
	cd build/libdispatch && patch -p0 < ../../patch/dispatch-workaround.diff
	cd build/libdispatch && patch -p0 < ../../patch/dispatch-spawn.diff
	# NOTE : this is from a Debian system, not an Android system..
	cp overlay/libdispatch/config.h build/libdispatch/config

$(BLOCKS_RUNTIME): build/libBlocksRuntime
	cd build/libBlocksRuntime && $(NDK_BUILD) NDK_PROJECT_PATH=. 

$(PWQ_LIB): build/libpthread_workqueue
	cd build/libpthread_workqueue && $(NDK_BUILD) NDK_PROJECT_PATH=.

$(KQUEUE_LIB): build/libkqueue
	cd build/libkqueue && $(NDK_BUILD) NDK_PROJECT_PATH=.

# Run all unit tests
check: check-blocks check-kqueue check-pwq check-libdispatch

# Run libBlocksRuntime unit tests
check-blocks:
	$(ADB) push build/libBlocksRuntime/libs/armeabi/libBlocksRuntime.so /data
	$(ADB) push build/libBlocksRuntime/libs/armeabi/brtest /data
	$(ADB) shell LD_LIBRARY_PATH=/data /data/brtest

# Run libpthread_workqueue unit tests
check-pwq: $(PWQ_LIB)
	$(ADB) push build/libpthread_workqueue/libs/armeabi/libpthread_workqueue.so /data
	$(ADB) push build/libpthread_workqueue/libs/armeabi/pwqtest /data
	$(ADB) shell LD_LIBRARY_PATH=/data /data/pwqtest

# Run libkqueue unit tests
check-kqueue: $(KQUEUE_LIB)
	$(ADB) push build/libkqueue/libs/armeabi/libkqueue.so /data
	$(ADB) push build/libkqueue/libs/armeabi/kqtest /data
	$(ADB) shell LD_LIBRARY_PATH=/data TMPDIR=/data KQUEUE_DEBUG=yes /data/kqtest

# Run libdispatch unit tests
check-libdispatch:
	$(ADB) push build/libdispatch/libs/armeabi/libdispatch.so /data
	cd build/libdispatch/libs/armeabi ; for x in dispatch-* ; \
		do \
			$(ADB) push $$x /data ; \
	        $(ADB) shell LD_LIBRARY_PATH=/data /data/$$x ; \
		done 

# FIXME: use ndk-gdb instead, this is broken
# Debug the libkqueue unit tests
#debug-kqueue:
#	adb forward tcp:5039 tcp:5039
#	adb shell LD_LIBRARY_PATH=/data TMPDIR=/data KQUEUE_DEBUG=yes gdbserver :5039 /data/kqtest
	
$(DISPATCH_LIB): build/libdispatch $(PWQ_LIB) $(KQUEUE_LIB)
	cp $(BLOCKS_RUNTIME) $(PWQ_LIB) $(KQUEUE_LIB) build/libdispatch
	cd build/libdispatch && $(NDK_BUILD) NDK_PROJECT_PATH=.
# FIXME: autoconf gets stuck in an infinite loop
#	cd build/libdispatch && autoreconf -fvi && \
#          CC=$(CC) \
#	  CPPFLAGS="-I$(NDK_INCLUDE)" \
# 	  CFLAGS="-nostdlib" \
#	  LIBS="" \
#          LDFLAGS="-Wl,-rpath-link=$(NDK_LIB) -L$(NDK_LIB)" \
#    ./configure --build=x86_64-unknown-linux-gnu --host=arm-linux-androideabi --target=arm-linux-androideabi && \

ndk-build: $(BLOCKS_RUNTIME) $(PWQ_LIB) $(KQUEUE_LIB) $(DISPATCH_LIB)

# Combine all the headers into a single include/ directory
#
include: $(BLOCKS_RUNTIME) $(PWQ_LIB) $(KQUEUE_LIB) $(DISPATCH_LIB)
	mkdir include
    
clean:
	rm -rf build include
#TODO:adb shell rm /data/kqtest /data/libkqueue.so
