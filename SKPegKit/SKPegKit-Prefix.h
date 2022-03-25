//
//  SKPegKit-Prefix.h
//  SKPegKit
//
//  Created by Sam Krishna on 3/24/22.
//

#ifdef __OBJC__
@import Foundation;
#endif

#define TDAssert(b) NSAssert2((b), @" %s : assert(%@)", __PRETTY_FUNCTION__, @#b);
#define TDAssertMainThread() NSAssert1([NSThread isMainThread], @"%s should be called on the main thread only.", __PRETTY_FUNCTION__);
#define TDAssertNotMainThread() NSAssert1(![NSThread isMainThread], @"%s should be called on the main thread only.", __PRETTY_FUNCTION__);
