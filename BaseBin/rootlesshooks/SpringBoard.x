#import <Foundation/Foundation.h>
#import <substrate.h>
#import <objc/objc.h>
#import <libroot.h>
#import <fcntl.h>

// util func to check if a string has a given prefix
bool string_has_prefix(const char *str, const char* prefix) {
	if (!str || !prefix) {
		return false;
	}

	size_t str_len = strlen(str);
	size_t prefix_len = strlen(prefix);

	if (str_len < prefix_len) {
		return false;
	}

	return !strncmp(str, prefix, prefix_len);
}

@interface XBSnapshotContainerIdentity : NSObject <NSCopying>
@property (nonatomic, readonly, copy) NSString* bundleIdentifier;
- (NSString*)snapshotContainerPath;
@end

#pragma mark - Hook XBSnapshotContainerIdentity

%hook XBSnapshotContainerIdentity

- (NSString *)snapshotContainerPath {
	NSString *path = %orig;
	if ([path hasPrefix:@"/var/mobile/Library/SplashBoard/Snapshots/"] && ![self.bundleIdentifier hasPrefix:@"com.apple."]) {
		return JBROOT_PATH_NSSTRING(path);
	}
	return path;
}

%end

#pragma mark - Hook fcntl

%hookf(int, fcntl, int fildes, int cmd, ...) {
	if (cmd == F_SETPROTECTIONCLASS) {
		char filePath[PATH_MAX];
		if (fcntl(fildes, F_GETPATH, filePath) != -1) {
			// Skip setting protection class on jailbreak apps, this doesn't work and causes snapshots to not be saved correctly
			if (string_has_prefix(filePath, JBROOT_PATH_CSTRING("/var/mobile/Library/SplashBoard/Snapshots"))) {
				return 0;
			}
		}
	}

	va_list args;
	va_start(args, cmd);
	int result = %orig(fildes, cmd, args);
	va_end(args);

	return result;
}

#pragma mark - Initialize SpringBoard Hooks

// func to init springboard hooks
void springboardInit(void) {
	%init();
}
