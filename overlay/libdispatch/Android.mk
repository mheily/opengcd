# Copyright (C) 2009 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := libdispatch
LOCAL_CFLAGS    += -I./src -D__ANDROID_API__=14
LOCAL_SRC_FILES := src/apply.c \
                   src/benchmark.c	\
                   src/object.c	\
                   src/once.c		\
                   src/queue.c		\
                   src/queue_kevent.c	\
                   src/semaphore.c	\
                   src/source.c	\
                   src/source_kevent.c	\
                   src/time.c \
                   src/shims/mach.c	\
                   src/shims/time.c	\
                   src/shims/tsd.c

# XXX-WORKAROUND - adding TARGET_PLATFORM to ndk-build causes __ANDROID_API__ to be undefined
LOCAL_CFLAGS    += -D__ANDROID_API__=14

include $(BUILD_SHARED_LIBRARY)

###include $(CLEAR_VARS)
###
###LOCAL_MODULE    := pwqtest
###LOCAL_CFLAGS    += -Iinclude
###LOCAL_SRC_FILES := ./testing/api/test.c
###LOCAL_SHARED_LIBRARIES := libpthread_workqueue
###
#### XXX-WORKAROUND - adding APP_PLATFORM to ndk-build causes __ANDROID_API__ to be undefined
###LOCAL_CFLAGS    += -D__ANDROID_API__=14
###
###include $(BUILD_EXECUTABLE)
