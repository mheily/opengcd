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
LOCAL_PATH := $(call my-dir)/..
TARGET_PLATFORM := 'android-14'

include $(CLEAR_VARS)

LOCAL_MODULE    := libpthread_workqueue
# XXX-should not need to define __ANDROID_API__, possibly a Clang-related bug
LOCAL_CFLAGS    += -Iinclude -I./src/common -D__ANDROID_API__=14
LOCAL_SRC_FILES := src/api.c src/posix/manager.c src/posix/thread_info.c src/witem_cache.c src/posix/thread_rt.c

include $(BUILD_SHARED_LIBRARY)
