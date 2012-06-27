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

TARGET_PLATFROM := android-14
LOCAL_MODULE    := kqtest
LOCAL_CFLAGS    += -I../include
LOCAL_SRC_FILES := ../main.c ../kevent.c ../test.c ../proc.c ../read.c ../signal.c ../timer.c ../vnode.c

# maybe need?
#cflags="-g -O0 -Wall -Werror"
#ldadd="-lpthread -lrt"

# XXX-WORKAROUND - adding TARGET_PLATFORM to ndk-build causes __ANDROID_API__ to be undefined
LOCAL_CFLAGS    += -D__ANDROID_API__=14

include $(BUILD_EXECUTABLE)
