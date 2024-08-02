TARGET = launchdhook.dylib
CC = clang

INCLUDE_DIR = ../.include
SRC_DIR = src
JBSERVER_DIR = src/jbserver
SYSTEMHOOK_DIR = ../systemhook/src
BUILD_DIR = ../.build
EXTERNAL_LIB_DIR = ../_external/lib

SRC_FILES = $(wildcard $(SRC_DIR)/*.m $(SRC_DIR)/*.c $(JBSERVER_DIR)/*.c) $(SYSTEMHOOK_DIR)/common.c $(SYSTEMHOOK_DIR)/envbuf.c

SDK = $(shell xcrun --sdk iphoneos --show-sdk-path)

CFLAGS = -framework Foundation -framework CoreServices -framework Security \
         -I$(INCLUDE_DIR) -I$(SRC_DIR) \
         -isysroot $(SDK) -arch arm64 -arch arm64e \
         -miphoneos-version-min=15.0 -fobjc-arc -O2

LDFLAGS = -dynamiclib -rpath @loader_path/fallback \
          -L$(BUILD_DIR) -L$(EXTERNAL_LIB_DIR) \
          -ljailbreak -lellekit -lbsm

.PHONY: clean sign

sign: $(TARGET)
	@ldid -S $^

$(TARGET): $(SRC_FILES)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

clean:
	@rm -f $(TARGET)

DEPENDS = $(SRC_FILES:.m=.d) $(SRC_FILES:.c=.d)

%.d: %.m
	@$(CC) $(CFLAGS) -MM $< > $@

%.d: %.c
	@$(CC) $(CFLAGS) -MM $< > $@

-include $(DEPENDS)
