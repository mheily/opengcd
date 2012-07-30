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
LOCAL_CFLAGS    += -fblocks -D__BLOCKS__ -I./src -D__ANDROID_API__=14 -nostdlib -I../libkqueue/include -I../libpthread_workqueue/include
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../libBlocksRuntime
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

LOCAL_SHARED_LIBRARIES := pwq-prebuilt kqueue-prebuilt blocks-prebuilt

include $(BUILD_SHARED_LIBRARY)

#--------------------------------------------------------------
#
# dispatch_api unit tests
#

include $(CLEAR_VARS)

LOCAL_MODULE    := dispatch-api
LOCAL_CFLAGS    += -Iinclude -nostdlib
LOCAL_SRC_FILES := testing/dispatch_api.c \
                   testing/dispatch_test.c
LOCAL_SHARED_LIBRARIES := libdispatch pwq-prebuilt kqueue-prebuilt blocks-prebuilt
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../libBlocksRuntime
LOCAL_CFLAGS    += -D__ANDROID_API__=14

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_MODULE    := dispatch-c99
LOCAL_CFLAGS    += -Iinclude -nostdlib
LOCAL_SRC_FILES := testing/dispatch_c99.c \
                   testing/dispatch_test.c
LOCAL_SHARED_LIBRARIES := libdispatch pwq-prebuilt kqueue-prebuilt blocks-prebuilt
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../libBlocksRuntime
LOCAL_CFLAGS    += -D__ANDROID_API__=14

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_MODULE    := dispatch-cascade
LOCAL_CFLAGS    += -Iinclude -nostdlib
LOCAL_SRC_FILES := testing/dispatch_cascade.c \
                   testing/dispatch_test.c
LOCAL_SHARED_LIBRARIES := libdispatch pwq-prebuilt kqueue-prebuilt blocks-prebuilt
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../libBlocksRuntime
LOCAL_CFLAGS    += -D__ANDROID_API__=14

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_MODULE    := dispatch-debug
LOCAL_CFLAGS    += -Iinclude -nostdlib
LOCAL_SRC_FILES := testing/dispatch_debug.c \
                   testing/dispatch_test.c
LOCAL_SHARED_LIBRARIES := libdispatch pwq-prebuilt kqueue-prebuilt blocks-prebuilt
LOCAL_CFLAGS    += -D__ANDROID_API__=14
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../libBlocksRuntime

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_MODULE    := dispatch-priority
LOCAL_CFLAGS    += -Iinclude -nostdlib
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../libBlocksRuntime
LOCAL_SRC_FILES := testing/dispatch_priority.c \
                   testing/dispatch_test.c
LOCAL_SHARED_LIBRARIES := libdispatch pwq-prebuilt kqueue-prebuilt blocks-prebuilt
LOCAL_CFLAGS    += -D__ANDROID_API__=14

# Workaround for error compiling <TargetConditional.h>
LOCAL_CFLAGS    += -DTARGET_CPU_ARM=1

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_MODULE    := dispatch-priority2
LOCAL_CFLAGS    += -Iinclude -nostdlib -DUSE_SET_TARGET_QUEUE=1
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../libBlocksRuntime
LOCAL_SRC_FILES := testing/dispatch_priority.c \
                   testing/dispatch_test.c
LOCAL_SHARED_LIBRARIES := libdispatch pwq-prebuilt kqueue-prebuilt blocks-prebuilt
LOCAL_CFLAGS    += -D__ANDROID_API__=14

# Workaround for error compiling <TargetConditional.h>
LOCAL_CFLAGS    += -DTARGET_CPU_ARM=1

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_MODULE    := dispatch-starfish
LOCAL_CFLAGS    += -Iinclude -nostdlib
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../libBlocksRuntime $(LOCAL_PATH)/../libpthread_workqueue/include
LOCAL_SRC_FILES := testing/dispatch_starfish.c \
                   testing/dispatch_test.c
LOCAL_SHARED_LIBRARIES := libdispatch pwq-prebuilt kqueue-prebuilt blocks-prebuilt
LOCAL_CFLAGS    += -D__ANDROID_API__=14

# Workaround for error compiling <TargetConditional.h>
LOCAL_CFLAGS    += -DTARGET_CPU_ARM=1

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_MODULE    := dispatch-after
LOCAL_CFLAGS    += -Iinclude -nostdlib -fblocks
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../libBlocksRuntime
LOCAL_SRC_FILES := testing/dispatch_after.c \
                   testing/dispatch_test.c
LOCAL_SHARED_LIBRARIES := libdispatch pwq-prebuilt kqueue-prebuilt blocks-prebuilt
LOCAL_CFLAGS    += -D__ANDROID_API__=14

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_MODULE    := dispatch-apply
LOCAL_CFLAGS    += -Iinclude -nostdlib -fblocks
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../libBlocksRuntime
LOCAL_SRC_FILES := testing/dispatch_apply.c \
                   testing/dispatch_test.c
LOCAL_SHARED_LIBRARIES := libdispatch pwq-prebuilt kqueue-prebuilt blocks-prebuilt
LOCAL_CFLAGS    += -D__ANDROID_API__=14

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_MODULE    := dispatch-drift
LOCAL_CFLAGS    += -Iinclude -nostdlib -fblocks
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../libBlocksRuntime
LOCAL_SRC_FILES := testing/dispatch_drift.c \
                   testing/dispatch_test.c
LOCAL_SHARED_LIBRARIES := libdispatch pwq-prebuilt kqueue-prebuilt blocks-prebuilt
LOCAL_CFLAGS    += -D__ANDROID_API__=14

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_MODULE    := dispatch-group
LOCAL_CFLAGS    += -Iinclude -nostdlib -fblocks
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../libBlocksRuntime
LOCAL_SRC_FILES := testing/dispatch_group.c \
                   testing/dispatch_test.c
LOCAL_SHARED_LIBRARIES := libdispatch pwq-prebuilt kqueue-prebuilt blocks-prebuilt
LOCAL_CFLAGS    += -D__ANDROID_API__=14

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_MODULE    := dispatch-pingpong
LOCAL_CFLAGS    += -Iinclude -nostdlib -fblocks
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../libBlocksRuntime
LOCAL_SRC_FILES := testing/dispatch_pingpong.c \
                   testing/dispatch_test.c
LOCAL_SHARED_LIBRARIES := libdispatch pwq-prebuilt kqueue-prebuilt blocks-prebuilt
LOCAL_CFLAGS    += -D__ANDROID_API__=14

include $(BUILD_EXECUTABLE)

# FIXME - This is broken because Linux doesn't return EOF for regular files
#         (I think)
#
#include $(CLEAR_VARS)
#
#LOCAL_MODULE    := dispatch-read
#LOCAL_CFLAGS    += -Iinclude -nostdlib -fblocks
#LOCAL_SRC_FILES := testing/dispatch_read.c \
#                   testing/dispatch_test.c
#LOCAL_SHARED_LIBRARIES := libdispatch pwq-prebuilt kqueue-prebuilt blocks-prebuilt
#LOCAL_CFLAGS    += -D__ANDROID_API__=14
#
#include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_MODULE    := dispatch-readsync
LOCAL_CFLAGS    += -Iinclude -nostdlib -fblocks
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../libBlocksRuntime
LOCAL_SRC_FILES := testing/dispatch_readsync.c \
                   testing/dispatch_test.c
LOCAL_SHARED_LIBRARIES := libdispatch pwq-prebuilt kqueue-prebuilt blocks-prebuilt
LOCAL_CFLAGS    += -D__ANDROID_API__=14

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_MODULE    := dispatch-sema
LOCAL_CFLAGS    += -Iinclude -nostdlib -fblocks
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../libBlocksRuntime
LOCAL_SRC_FILES := testing/dispatch_sema.c \
                   testing/dispatch_test.c
LOCAL_SHARED_LIBRARIES := libdispatch pwq-prebuilt kqueue-prebuilt blocks-prebuilt
LOCAL_CFLAGS    += -D__ANDROID_API__=14

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_MODULE    := dispatch-timer_bit31
LOCAL_CFLAGS    += -Iinclude -nostdlib -fblocks
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../libBlocksRuntime
LOCAL_SRC_FILES := testing/dispatch_timer_bit31.c \
                   testing/dispatch_test.c
LOCAL_SHARED_LIBRARIES := libdispatch pwq-prebuilt kqueue-prebuilt blocks-prebuilt
LOCAL_CFLAGS    += -D__ANDROID_API__=14

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_MODULE    := dispatch-timer_bit63
LOCAL_CFLAGS    += -Iinclude -nostdlib -fblocks
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../libBlocksRuntime
LOCAL_SRC_FILES := testing/dispatch_timer_bit63.c \
                   testing/dispatch_test.c
LOCAL_SHARED_LIBRARIES := libdispatch pwq-prebuilt kqueue-prebuilt blocks-prebuilt
LOCAL_CFLAGS    += -D__ANDROID_API__=14

include $(BUILD_EXECUTABLE)

#
#--------------------------------------------------------------
#

#
# Bring in libpwq as a prebuilt-library
#

include $(CLEAR_VARS)
LOCAL_MODULE := pwq-prebuilt
LOCAL_SRC_FILES := libpthread_workqueue.so
include $(PREBUILT_SHARED_LIBRARY)

#
# Bring in libkqueue as a prebuilt-library
#

include $(CLEAR_VARS)
LOCAL_MODULE := kqueue-prebuilt
LOCAL_SRC_FILES := libkqueue.so
include $(PREBUILT_SHARED_LIBRARY)

#
# Bring in libBlocksRuntime as a prebuilt-library
#

include $(CLEAR_VARS)
LOCAL_MODULE := blocks-prebuilt
LOCAL_SRC_FILES := libBlocksRuntime.so
include $(PREBUILT_SHARED_LIBRARY)
