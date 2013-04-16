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

LOCAL_MODULE    := libkqueue
LOCAL_CFLAGS    += -Iinclude -I./src/common
LOCAL_SRC_FILES := ./src/common/filter.c ./src/common/knote.c ./src/common/kevent.c ./src/common/kqueue.c ./src/posix/kevent.c ./src/linux/eventfd.c ./src/posix/signal.c ./src/linux/proc.c ./src/linux/socket.c ./src/posix/timer.c ./src/posix/user.c ./src/linux/vnode.c 

include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)

LOCAL_MODULE    := kqtest
LOCAL_CFLAGS    += -Iinclude -DHAVE_EVFILT_USER=1
LOCAL_SRC_FILES := ./test/main.c ./test/kevent.c ./test/test.c ./test/proc.c ./test/read.c ./test/signal.c ./test/timer.c ./test/vnode.c ./test/user.c
LOCAL_SHARED_LIBRARIES := libkqueue

# XXX-WORKAROUND - adding APP_PLATFORM to ndk-build causes __ANDROID_API__ to be undefined
LOCAL_CFLAGS    += -D__ANDROID_API__=14

include $(BUILD_EXECUTABLE)
