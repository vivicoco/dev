LOCAL_ARCH := $(shell uname --m)
BUILD_TARGET := linux-$(LOCAL_ARCH)


#BUILD_TARGET := hisiv100nptl
#CROSS_COMPILE := arm-hisiv100nptl-linux-
#CROSS_SYSROOT := --sysroot=/opt/hisi-linux-nptl/arm-hisiv100-linux/target


DEBUG := true

#=============================================================================
LIBSL_PATH = $(shell pwd)/libsl

INCLUDES += -I$(LIBSL_PATH)/include

ifeq ($(DEBUG),true)
MY_DEF := -O -g -DDEBUG -Wno-comment 
else
MY_DEF := -O2
endif


EXT_LIBS := -L$(LIBSL_PATH)/libs/$(BUILD_TARGET) -lsl_static -lev -lux \
	-loss_c_sdk_static -laprutil-1 -lapr-1 -lcurl -lmxml \
	-lmbedtls -lmbedcrypto

#=============================================================================
COMPILE_OPTS = -I. -I../include $(INCLUDES) -Wall $(MY_DEF) $(CROSS_SYSROOT)
C =			c
C_COMPILER =$(CROSS_COMPILE)gcc
C_FLAGS =	$(COMPILE_OPTS) 
CPP =		cpp
CPLUSPLUS_COMPILER =$(CROSS_COMPILE)g++
CPLUSPLUS_FLAGS =	$(COMPILE_OPTS) -fmessage-length=0 -fpermissive 
OBJ =			o
LINK =			$(CROSS_COMPILE)g++ -o 
LINK_OPTS =		-L.
CONSOLE_LINK_OPTS =	$(LINK_OPTS)
LIBRARY_LINK =		$(CROSS_COMPILE)ar cr 
LIBRARY_LINK_OPTS =	
LIB_SUFFIX =		a
LIBS_FOR_CONSOLE_APPLICATION = $(EXT_LIBS) -lpthread -lm -lrt 
LIBS_FOR_GUI_APPLICATION =
EXE =
##### End of variables to change

SRC_PATH := .

SL_DEVICE := sldevice
SL_OBJS := $(SRC_PATH)/sldevice.$(OBJ) \
	$(SRC_PATH)/mydev.$(OBJ) \
	$(SRC_PATH)/my_devchan_listener.$(OBJ) \

			
LOCAL_LIBS	:=
LIBS		:= $(LOCAL_LIBS) $(LIBS_FOR_CONSOLE_APPLICATION)

ALL = $(SL_DEVICE)

all: $(ALL)

.$(C).$(OBJ):
	$(C_COMPILER) -c $(C_FLAGS) $< -o $@ 

.$(CPP).$(OBJ):
	$(CPLUSPLUS_COMPILER) -c $(CPLUSPLUS_FLAGS) $< -o $@ 

$(SL_DEVICE)$(EXE):$(SL_OBJS)
	$(LINK) $@ $(CONSOLE_LINK_OPTS) $(SL_OBJS) $(LIBS)

clean:
	-rm -rf *.$(OBJ) $(ALL) 
