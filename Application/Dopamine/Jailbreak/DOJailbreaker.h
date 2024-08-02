//
//  Jailbreaker.h
//  Dopamine
//
//  Created by Lars Fröder on 10.01.24.
//  edited by awesomecat2011 08/02/2024

#import <Foundation/Foundation.h>
#import <xpc/xpc.h>

NS_ASSUME_NONNULL_BEGIN

@interface DOJailbreaker : NSObject
{
    xpc_object_t _systemInfoXdict;
}

- (void)runWithError:(NSError **)errOut didRemoveJailbreak:(BOOL*)didRemove showLogs:(BOOL *)showLogs;
- (void)finalize;

@end

NS_ASSUME_NONNULL_END

#import "Jailbreaker.h"

@implementation DOJailbreaker

- (void)runWithError:(NSError **)errOut didRemoveJailbreak:(BOOL*)didRemove showLogs:(BOOL *)showLogs {
    // original method impl
}

- (void)finalize {
    if (_systemInfoXdict) {
        xpc_release(_systemInfoXdict);  // Properly release _systemInfoXdict to prevent memory leaks
        _systemInfoXdict = NULL;
    }
    // original finalize impl
}

@end
